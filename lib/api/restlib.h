#ifndef RESTLIB_H
#define RESTLIB_H

#include <QJSValue>
#include <QObject>
#include <QtNetwork>

#define API_BASEURL "http://localhost:8000"

class RestClient : public QObject{
	Q_OBJECT

	Q_PROPERTY(QString BASEURL READ getBaseUrl)
	Q_PROPERTY(qint64 tryCount READ getTryCount)
	Q_PROPERTY(qint64 retry READ getRetry WRITE setRetry NOTIFY retryChanged)
	Q_PROPERTY(QString url READ getUrl WRITE setUrl NOTIFY urlChanged)
	Q_PROPERTY(QString method READ getMethod WRITE setMethod NOTIFY methodChanged)
	Q_PROPERTY(bool saveOffline READ getSaveOffline WRITE setSaveOffline)

public:
	explicit RestClient(QObject *parent=nullptr);
	// properties
	const QString baseurl=API_BASEURL;
	QVariant headers;
	QVariant body;
	void reset();

	// getters
	QString getUrl();
	qint64 getRetry();
	QString getMethod();
	qint64 getTryCount();
	bool getSaveOffline();
	QString getBaseUrl();

	// setters
	void setRetry(qint64);
	void setUrl(QString);
	void setMethod(QString);
	void setSaveOffline(bool);


private:
	// properties
	// TODO: test retries
	qint64 retry = 0;
	qint64 tryCount = 0;
	QString url;
	QString method = "GET";
	QNetworkAccessManager manager;
	bool doLogResponse = true;
	QVariantMap variables;

	// paths
	QString responsePath;
	QString downloadPath;

	// TODO: test save
	// saving and reading offline response will help
	// when the user is offline
	bool saveOffine = false;
	
	// methods
	QNetworkRequest getNetworkRequest();
	void requestComplete(QNetworkReply*);
	QVariant evaluateJsonBody(QVariant);
	QHttpMultiPart* evaluateFormDataBody(QVariant);
	QString checkBodyType(QVariant);
	QString urlToFilename();
	void doSaveResponse(QVariant);
	QVariant doGetOfflineResponse();
	void connectReplySlots(QNetworkReply*);
	bool hasOfflineResponse();
	void logResponse(QVariant);

	// verbs
	void get();
	void post();


public slots:
	// setters
	void setHeader(QJSValue);
	QVariant createJsonBody(QJSValue);
	QVariant createFormDataBody(QJSValue);
	void setBody(QJSValue);
	void call();
	QVariant multiPartText(QString, QString);
	QVariant multiPartFile(QString, QString);
	void clearBody();
	QVariant processResponseBody(QNetworkReply*);
	void addVariable(QString, QJSValue);
	QVariant getVariable(QString);

signals:
	void requestRetry(qint64 count);
	void methodChanged(QString method);
	void urlChanged(QString url);
	void retryChanged(qint64 retry);
	void error(QVariant error);
	void loaded(QVariant response);
	void finally(QVariant body);

	// TODO: add this feature
	void downloadProgress(qint64 bytesReceived, qint64 bytesTotal);
	void uploadProgress(qint64 bytesSent, qint64 bytesTotal);
};

#endif // RESTLIB_H
