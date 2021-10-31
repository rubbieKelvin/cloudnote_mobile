#include <QJSValue>
#include <QDebug>
#include <QByteArray>
#include <QtNetwork>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QHttpMultiPart>
#include <QMimeDatabase>
#include <QStandardPaths>
#include <iostream>
#include <string>
#include "restlib.h"


namespace rest_lib_cxx {
    std::string printables {"01lmnrstuvw23>?@|}~\n456ohijkxyzABCefP%&'(DEFGHpqUVWXYZ!\"#$789abcd)*+,-.gIJQRSTKLM[\\]^_`{NO/:;<=\t "};

    std::string code (std::string word, unsigned int key, bool reverse){
        // this function can encode or decode a string
        std::string result;
        std::string chars = printables;

        for (unsigned int i {0}; i<word.length(); i+=1){
            // flip
            if (reverse)
                chars = chars.substr(chars.size()-key) + chars.substr(0, chars.size()-key);
                // std::cout << chars << std::endl;
            else
                chars = chars.substr(key) + chars.substr(0, key);

            // get the index of the character in chars at i
            long unsigned int index {chars.find(word[i])};
            if (index == std::string::npos){
                result += word[i];
                continue;
            }
            // add the character at the index $index or printable to result
            result += printables[index];
        }
        return result;
    }

    std::string encode (std::string word, unsigned int key) {
        return code(word, key, false);
    }

    std::string decode (std::string word, unsigned int key) {
        return code(word, key, true);
    }
}


RestClient::RestClient(QObject *parent) : QObject(parent){

}

QNetworkRequest RestClient::getNetworkRequest(){
    QNetworkRequest request;

    request.setUrl(QUrl(this->url));

    // load headers
    if (this->headers.canConvert<QVariantMap>()){
        // do conversion
        QMap<QString, QVariant> headerMap = this->headers.toMap();
        QMapIterator<QString, QVariant> iter(headerMap);

        // iterate
        while (iter.hasNext()){
            iter.next();
            QString key = QString(iter.key());
            QString value = QString(iter.value().toString());

            request.setRawHeader(
                QByteArray::fromStdString(key.toStdString()),
                QByteArray::fromStdString(value.toStdString())
            );
        }
    }

    return request;
}

void RestClient::setHeader(QJSValue header){
    this->headers = header.toVariant();
}

void RestClient::setUrl(QString url){
    if (url.startsWith('/')){
        this->url = this->baseurl+url;
    }else{
        this->url = url;
    }
    emit this->urlChanged(this->url);
}

void RestClient::setMethod(QString method){
    this->method = method.toUpper();
    emit this->methodChanged(this->method);
}

QString RestClient::getMethod(){
    return this->method;
}

QString RestClient::getUrl(){
    return this->url;
}

void RestClient::setBody(QJSValue body){
    this->body = body.toVariant();
}

void RestClient::get(){
    QNetworkRequest request = this->getNetworkRequest();
    this->manager.get(request);
    this->connect(&this->manager, &QNetworkAccessManager::finished, this, &RestClient::requestComplete);
}

void RestClient::post(){
    QNetworkRequest request = this->getNetworkRequest();
    QString bodyType = this->checkBodyType(this->body);

    if (bodyType == "object"){
        request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
        QJsonDocument body (this->body.toJsonObject());
        manager.post(request, body.toJson());

    }else if (bodyType == "json"){
        request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
        QVariant data = this->evaluateJsonBody(this->body);
        QJsonDocument body (data.toJsonObject());
        manager.post(request, body.toJson());

    }else if (bodyType == "formdata"){
        // request.setHeader(QNetworkRequest::ContentTypeHeader, "multipart/form-data");
        QHttpMultiPart* multiPart = this->evaluateFormDataBody(this->body);
        // ignoring the vscode error at manager.post
        QNetworkReply* reply = manager.post(request, multiPart);
        multiPart->setParent(reply);
    }else if (bodyType == "none"){
        manager.post(request, QByteArray());
	}

    
    this->connect(&this->manager, &QNetworkAccessManager::finished, this, &RestClient::requestComplete);
}

void RestClient::requestComplete(QNetworkReply* response){
    QByteArray responseContent = response->readAll();
    QJsonDocument body = QJsonDocument::fromJson(responseContent);
    QVariantMap result = QVariantMap();

    result["body"] = body.toVariant();
    result["error"] = QVariant();
    result["status"] = response->attribute(QNetworkRequest::HttpStatusCodeAttribute);

    if (response->error() == QNetworkReply::NoError){
        this->tryCount = 0;
        QVariantMap headerMap = QVariantMap();

        QList<QPair<QByteArray, QByteArray>> headers = response->rawHeaderPairs();

        for (int i=0; i<headers.size(); i+=1){
            QPair<QByteArray, QByteArray> pair = headers.at(i);
            QByteArray key = pair.first;
            QByteArray value = pair.second;
            headerMap[QString::fromStdString(key.toStdString())] = QString::fromStdString(value.toStdString());
        }

        result["headers"] = headerMap;

        // save if set
        if (this->saveOffine){
            this->doSaveResponse(result);
        }

        // emit signals
        emit this->loaded(result);
        emit this->finally(result);

    }else{
        if (this->tryCount<this->retry){
            this->tryCount += 1;
            qDebug() << "retrying(" << this->tryCount << "/" << this->retry << ")";
            emit this->requestRetry(this->tryCount);

            response->deleteLater();
            this->disconnect(&manager, &QNetworkAccessManager::finished, this, &RestClient::requestComplete);

            return this->call();

        }else{
            result["errorString"] = response->errorString();
            result["errorCode"] = response->error();

            this->tryCount=0;
            
            if (response->error() == QNetworkReply::ConnectionRefusedError && this->saveOffine){
				QVariantMap offlineResponse = this->doGetOfflineResponse().toMap();
				offlineResponse["offline"] = true;
				emit this->loaded(offlineResponse);
				emit this->finally(offlineResponse);
			}else{
				emit this->error(result);
				emit this->finally(result);
			}

        }
    }

    response->deleteLater();
    this->disconnect(&manager, &QNetworkAccessManager::finished, this, &RestClient::requestComplete);
}


void RestClient::call(){
    if (this->method=="GET"){
        this->get();
    }else if (this->method=="POST"){
        this->post();
    }
}

void RestClient::setRetry(qint64 count){
    this->retry = count;
	emit this->retryChanged(count);
}

qint64 RestClient::getRetry(){
    return this->retry;
}

qint64 RestClient::getTryCount(){
    return this->tryCount;
}

QVariant RestClient::createFormDataBody(QJSValue body){
    QVariantMap result;
    result["%bodyType"] = "formdata";

    if (body.isArray()){
        result["%bodyData"] = body.toVariant();
    }else{
        result["%bodyData"] = QVariantList();
    }
    return result;
}

QVariant RestClient::createJsonBody(QJSValue body){
    QVariantMap result;
    result["%bodyType"] = "json";
    result["%bodyData"] = body.toVariant();
    return result;
}

QVariant RestClient::evaluateJsonBody(QVariant body){
    QVariantMap data = body.toMap();
    return data.value("%bodyData");
}

QHttpMultiPart* RestClient::evaluateFormDataBody(QVariant body){
    QHttpMultiPart* multiPart = new QHttpMultiPart(QHttpMultiPart::FormDataType);
    QVariantMap data = body.toMap();
    QVariantList formBodies = data.value("%bodyData").toList();

    for (int i=0; i < formBodies.size(); i+=1){
        QVariantMap formBody = formBodies.at(i).toMap();
        QString type = formBody.value("type").toString();
        QString name = formBody.value("name").toString();
        QVariant content = formBody.value("content");

        if (type=="text"){
            QHttpPart textpart;
            textpart.setHeader(
				QNetworkRequest::ContentDispositionHeader,
				QVariant("form-data; name=\""+name+"\"")
			);
            textpart.setBody(content.toByteArray());
            multiPart->append(textpart);
        
        }else if(type=="file"){
            QHttpPart filePart;
			QUrl url (content.toString());

			QFile *file = new QFile(url.toLocalFile());

			if (file->open(QIODevice::ReadOnly)){
				QMimeDatabase mimeDb;
				QMimeType mime = mimeDb.mimeTypeForData(file);

				QString mimeName(mime.name());
				QString contentDispositionHeader("form-data; name=\""+name+"\"; filename=\""+url.fileName()+"\"");

				filePart.setHeader(
					QNetworkRequest::ContentTypeHeader,
					QVariant(mimeName)
				);

				filePart.setHeader(
					QNetworkRequest::ContentDispositionHeader,
					QVariant(contentDispositionHeader)
				);

				filePart.setBodyDevice(file);
				file->setParent(multiPart);

				multiPart->append(filePart);
			}
        }
    }

    return multiPart;
}


QString RestClient::checkBodyType(QVariant body){
	if ((!body.isValid()) || body.isNull()){
		return "none";
	}

    if (body.canConvert<QVariantMap>()){
        QVariantMap dict = body.toMap();

        if (dict.contains("%bodyType") && dict.contains("%bodyData")){
            return dict.value("%bodyType").toString();
        }
    }
    return "object";
}

QVariant RestClient::multiPartText(QString name, QString content){
    QVariantMap result;
    result["name"] = name;
    result["type"] = "text";
    result["content"] = content;
    return result;
}

QVariant RestClient::multiPartFile(QString name, QString filename){
    QVariantMap result;
    result["name"] = name;
    result["type"] = "file";
    result["content"] = filename;
    return result;
}


bool RestClient::getSaveOffline(){
	return this->saveOffine;
}

void RestClient::setSaveOffline(bool value){
	this->saveOffine = value;
}

void RestClient::doSaveResponse(QVariant body){
	QJsonDocument doc(body.toJsonObject());
	QString data(doc.toJson(QJsonDocument::Compact));

	QString encoded = QString::fromStdString(
		rest_lib_cxx::encode(data.toStdString(), this->url.length())
	);

	QFile *file = new QFile(this->urlToFilename());
	if (file->open(QIODevice::WriteOnly)){
		QTextStream stream(file);
		stream << encoded;
		file->close();
	}
}

QVariant RestClient::doGetOfflineResponse(){
	QString filename = this->urlToFilename();
	QFile file(filename);

	if (file.exists() && file.open(QIODevice::ReadOnly)){
		QTextStream stream(&file);
		std::string data = rest_lib_cxx::decode(stream.readAll().toStdString(), this->url.length());
		file.close();

		QJsonDocument doc = QJsonDocument::fromJson(QByteArray::fromStdString(data));
		return doc.toVariant();
	}

	return QVariant();
}

QString RestClient::urlToFilename(){
	QByteArray b64 = QByteArray::fromStdString(
		this->url.toStdString()
	).toBase64(
		QByteArray::Base64UrlEncoding |
		QByteArray::OmitTrailingEquals
	);

	QString filepath = QDir::cleanPath(
		QStandardPaths::writableLocation(QStandardPaths::AppDataLocation) +
		QDir::separator() + QString(b64) + ".response"
	);

	qDebug() << this->url << "->" << filepath;
	return filepath;
}

void RestClient::clearBody(){
	this->body = QVariant();
}
