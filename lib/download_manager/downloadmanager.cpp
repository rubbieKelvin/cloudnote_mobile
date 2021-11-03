#include <QStandardPaths>
#include <QDir>
#include <QJSValue>
#include "downloadmanager.h"
#include "lib/api/restlib.h"

RestClient client;
QList<QVariantMap> queue;

DownloadManager::DownloadManager(QObject *parent) : QObject(parent){

}

QString DownloadManager::cleanurl(QString path){
	if (path.startsWith("/"))
		return API_BASEURL + path;
	return path;
}

qint64 DownloadManager::download(QJSValue obj){
	/* result:
	 * 0: error
	 * 1: downloaded
	 * 2: added to queue
	*/
	QVariant data = obj.toVariant();
	if (data.canConvert<QVariantMap>()){
		QVariantMap audioData = data.toMap();

		if (audioData.contains("audio")){
			QString audio_url = audioData.value("audio").toString();
			QString file_path = this->filePathFromUrl(audio_url);

			// check if the path exists... if it does, it's already downloaded
			if (QDir().exists(file_path)){
				return 1;
			}else{
				// if it doesnt exists,
				// check if you'll find it in the queue
				// if add to queue

				if (!this->inQueue(audioData)) queue.append(audioData);
				this->downloadNext();
				return 2;
			}
		}
	}
	return 0;
}

QString DownloadManager::filePathFromUrl(QString url_path){
	QUrl url(url_path);
	QString file_name = url.fileName();
	QString file_path = QDir::cleanPath(
		QStandardPaths::writableLocation(
			QStandardPaths::AppDataLocation
		) + QDir::separator() + "downloads" + QDir::separator() + file_name
	);

	qDebug() << url_path << "=>" << file_path;
	return file_path;
}


bool DownloadManager::inQueue(QJSValue obj){
	bool result = false;
	if (obj.isObject()){
		QVariantMap audioData = obj.toVariant().toMap();
		for (int i=0; i<queue.count(); i+=1){
			QVariantMap queuedItem = queue.at(i);
			if (queuedItem.value("id") == audioData.value("id")){
				result = true;
				break;
			}
		}
	}
	return result;
}

bool DownloadManager::inQueue(QVariantMap audioData){
	bool result = false;
	for (int i=0; i<queue.count(); i+=1){
		QVariantMap queuedItem = queue.at(i);
		if (queuedItem.value("id") == audioData.value("id")){
			result = true;
			break;
		}
	}
	return result;
}

void DownloadManager::downloadNext(){
	if (!queue.isEmpty() && this->currentDownload==nullptr){

		client.reset();
		this->disconnect(&client);

		QVariantMap audioData = queue.last();
		QString url = this->toDownloadUrl(audioData);
		this->currentDownload = &audioData;
		client.setUrl(url);

		QVariantMap headers;
		headers["Authorization"] = "Token "+this->token;

		client.headers = headers;
		emit this->downloadStarted(&client);


		this->connect(&client, &RestClient::downloadProgress, this, &DownloadManager::downloadProgress);
		this->connect(&client, &RestClient::requestRetry, this, &DownloadManager::downloadRetry);
		this->connect(&client, &RestClient::loaded, this, [this, audioData](){
			emit this->downloadComplete(audioData);
		});
		this->connect(&client, &RestClient::finally, this, [this](){
			queue.removeLast();
			this->currentDownload = nullptr;
			this->downloadNext();
		});

		client.call();
	}
}

QVariant DownloadManager::getCurrentDownload(){
	return *this->currentDownload;
}

void DownloadManager::setAuthToken(QString token){
	this->token = token;
}

QString DownloadManager::toDownloadUrl(QVariantMap audioData){
	QString id = audioData.value("id").toString();
	QString url = "/a/music/audio/"+id+"/download/";
	return this->cleanurl(url);
}
