#ifndef DOWNLOADMANAGER_H
#define DOWNLOADMANAGER_H
#include "lib/api/restlib.h"
#include <QObject>
#include <QJSValue>

class DownloadManager : public QObject{
	Q_OBJECT

public:
	explicit DownloadManager(QObject *parent = nullptr);
	QString filePathFromUrl(QString);
	bool inQueue(QVariantMap);
	void downloadNext();

private:
	QString token;
	QVariantMap *currentDownload = nullptr;
	QString toDownloadUrl(QVariantMap);

public slots:
	QString cleanurl(QString);
	qint64 download(QJSValue);
	bool inQueue(QJSValue);
	QVariant getCurrentDownload();
	void setAuthToken(QString);

signals:
	void downloadStarted(RestClient *client);
	void downloadProgress(qint64 bytesReceived, qint64 bytesTotal);
	void downloadRetry(qint64 count);
	void downloadComplete(QVariant audioData);
};

#endif // DOWNLOADMANAGER_H
