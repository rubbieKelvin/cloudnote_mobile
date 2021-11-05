#include <QJSValue>
#include <QDir>
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
#include <Qt>
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
	this->responsePath = QDir::cleanPath(
		QStandardPaths::writableLocation(QStandardPaths::AppDataLocation) +
		QDir::separator() + "offlineResponse"
	);

	this->downloadPath = QDir::cleanPath(
		QStandardPaths::writableLocation(QStandardPaths::AppDataLocation) +
		QDir::separator() + "downloads"
	);

	// create download ond offline response path
	QDir().mkdir(this->downloadPath);
	QDir().mkdir(this->responsePath);

	// connect finally to logResponse
	this->connect(this, &RestClient::finally, this, &RestClient::logResponse);
}

QNetworkRequest RestClient::getNetworkRequest(){
    QNetworkRequest request;

    request.setUrl(QUrl(this->url));
	request.setHeader(QNetworkRequest::UserAgentHeader, "CloudNote/Mobile");

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
    QNetworkReply* reply = this->manager.get(request);
    this->connectReplySlots(reply);
    this->connect(&this->manager, &QNetworkAccessManager::finished, this, &RestClient::requestComplete);
}

void RestClient::post(){
    QNetworkRequest request = this->getNetworkRequest();
    QString bodyType = this->checkBodyType(this->body);

    if (bodyType == "object"){
        request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
        QJsonDocument body (this->body.toJsonObject());
        QNetworkReply* reply = manager.post(request, body.toJson());
        this->connectReplySlots(reply);

    }else if (bodyType == "json"){
        request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
        QVariant data = this->evaluateJsonBody(this->body);
        QJsonDocument body (data.toJsonObject());
        QNetworkReply* reply = manager.post(request, body.toJson());
        this->connectReplySlots(reply);

    }else if (bodyType == "formdata"){
        // request.setHeader(QNetworkRequest::ContentTypeHeader, "multipart/form-data");
        QHttpMultiPart* multiPart = this->evaluateFormDataBody(this->body);
        // ignoring the vscode error at manager.post
        QNetworkReply* reply = manager.post(request, multiPart);
        multiPart->setParent(reply);
        this->connectReplySlots(reply);

    }else if (bodyType == "none"){
        request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
        QNetworkReply* reply = manager.post(request, QByteArray());
        this->connectReplySlots(reply);
	}
    
    this->connect(&this->manager, &QNetworkAccessManager::finished, this, &RestClient::requestComplete);
}

void RestClient::requestComplete(QNetworkReply* response){

    QVariantMap result = QVariantMap();

    result["body"] = this->processResponseBody(response);
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
            
			if (response->error() == QNetworkReply::ConnectionRefusedError && this->saveOffine && this->hasOfflineResponse()){
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
	qDebug() << "RestClient::call <<" << this->url;
	if (this->method.toUpper()=="GET"){
        this->get();
	}else if (this->method.toUpper()=="POST"){
        this->post();
	}else{
		qDebug() << "[RestClient] invalid type \"" + this->method + "\"";
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

	QString filepath = QDir::cleanPath(this->responsePath + QDir::separator() + QString(b64));
	qDebug() << this->url << "->" << filepath;
	return filepath;
}

void RestClient::clearBody(){
	this->body = QVariant();
}


void RestClient::connectReplySlots(QNetworkReply* reply){
    this->connect(reply, &QNetworkReply::uploadProgress, this, &RestClient::uploadProgress);
    this->connect(reply, &QNetworkReply::downloadProgress, this, &RestClient::downloadProgress);
}

QVariant RestClient::processResponseBody(QNetworkReply* response){
    QByteArray responseContent = response->readAll();
	QString contentDisposition = response->header(QNetworkRequest::ContentDispositionHeader).toString();

	if (!contentDisposition.isEmpty() && contentDisposition.contains("attachment;")){
		// we have to save the file
		QVariantMap contentDispositionData;
		QStringList contentDispositionList = contentDisposition.split(";");

		for (int i=0; i<contentDispositionList.count(); i+=1){
			QString data = contentDispositionList.at(i).trimmed();
			if (! data.isEmpty()){
				QStringList pair = data.split("=");
				if (pair.count() == 1){
					contentDispositionData[pair.at(0)] = QVariant();
				}else if (pair.count() > 1){
					contentDispositionData[pair.at(0)] = pair.at(1).trimmed();
				}
			}
		}

		// try to write file to device
		if (contentDispositionData.contains("filename") && contentDispositionData.value("filename").isValid()){
			QString filename (contentDispositionData.value("filename").toString().remove("\""));
			filename = QDir::cleanPath(this->downloadPath + QDir::separator() + filename);
			contentDispositionData["filename"] = filename;

			// save file
			qDebug() << "downloaded:" << filename;
			QFile file (filename);

			if (file.open(QIODevice::WriteOnly)){
				QDataStream stream(&file);
				stream << responseContent;
				file.close();
			}
		}

		return contentDispositionData;
	}
    
	QJsonDocument body = QJsonDocument::fromJson(responseContent);
	return body.toVariant();
}

bool RestClient::hasOfflineResponse(){
	QString filename = this->urlToFilename();
	return QFile(filename).exists();
}


void RestClient::logResponse(QVariant response){
	if (this->doLogResponse){
		if (response.canConvert<QVariantMap>()){
			QVariantMap body = response.toMap();
			QMapIterator<QString, QVariant> iter(body);

			qDebug() << Qt::endl <<"[START] RESPONSE-LOG("<< this->url+" ["+this->method.toUpper()+"]" << ") ===================================";

			while (iter.hasNext()) {
				iter.next();
				QString key = iter.key();
				QVariant value = iter.value();

				if (value.canConvert<QVariantMap>()){
					QJsonDocument doc (value.toJsonObject());
					qDebug() << key << ":\t" << doc.toJson(QJsonDocument::Compact);
				}else if (value.canConvert<QVariantList>()){
					QJsonDocument doc (value.toJsonArray());
					qDebug() << key << ":\t" << doc.toJson(QJsonDocument::Compact);
				}else if (value.canConvert<QString>()){
					qDebug() << key << ":\t" << value.toString();
				}else{
					qDebug() << key << ":\t" << value;
				}
			}

			qDebug() << "[END] RESPONSE-LOG ===================================" << Qt::endl;
		}
	}
}


void RestClient::addVariable(QString key, QJSValue value){
	// this doest have anything to do with the request or the response
	// all this does is store a key-value pair that can be used later in the instance
	this->variables[key] = value.toVariant();
}

QVariant RestClient::getVariable(QString key){
	if (this->variables.contains(key)){
		return this->variables.value(key);
	}
	return QVariant();
}


QString RestClient::getBaseUrl(){
	return this->baseurl;
}


void RestClient::reset(){
	this->responsePath = QDir::cleanPath(
		QStandardPaths::writableLocation(QStandardPaths::AppDataLocation) +
		QDir::separator() + "offlineResponse"
	);

	this->downloadPath = QDir::cleanPath(
		QStandardPaths::writableLocation(QStandardPaths::AppDataLocation) +
		QDir::separator() + "downloads"
	);

	this->url = "";
	this->method = "GET";
	this->headers = QVariantMap();
	this->retry = 0;
	this->tryCount = 0;
	this->variables = QVariantMap();
	this->body = QVariant();
}

bool RestClient::isNetworkError(qint64 err){
	return (
		err==1 ||
		err==99 ||
		err==403
	);
}
