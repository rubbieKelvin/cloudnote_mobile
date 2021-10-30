#include <QJSValue>
#include <QDebug>
#include <QByteArray>
#include <QtNetwork>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QHttpMultiPart>
#include <QMimeDatabase>
#include "restlib.h"

RestClient::RestClient(QObject *parent) : QObject(parent){}


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

        QVariantMap headerMap = QVariantMap();

        QList<QPair<QByteArray, QByteArray>> headers = response->rawHeaderPairs();

        for (int i=0; i<headers.size(); i+=1){
            QPair<QByteArray, QByteArray> pair = headers.at(i);
            QByteArray key = pair.first;
            QByteArray value = pair.second;
            headerMap[QString::fromStdString(key.toStdString())] = QString::fromStdString(value.toStdString());
        }

        result["headers"] = headerMap;

        // emit signals
        emit this->loaded(result);
        emit this->finally(result);
    }else{
        if (this->tryCount<this->retry){
            this->tryCount += 1;
            emit this->requestRetry(this->tryCount);
            this->call();
        }else{
            result["errorString"] = response->errorString();
            result["errorCode"] = response->error();

            this->tryCount=0;
            
            emit this->error(result);
            emit this->finally(result);
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
