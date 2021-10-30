#ifndef RESTLIB_H
#define RESTLIB_H

#include <QJSValue>
#include <QObject>
#include <QtNetwork>

class RestClient : public QObject{
    Q_OBJECT

    Q_PROPERTY(qint64 tryCount READ getTryCount)
    Q_PROPERTY(qint64 retry READ getRetry WRITE setRetry)
    Q_PROPERTY(QString url READ getUrl WRITE setUrl NOTIFY urlChanged)
    Q_PROPERTY(QString method READ getMethod WRITE setMethod NOTIFY methodChanged)

public:
    explicit RestClient(QObject *parent=nullptr);
    // properties
    const QString baseurl="http://localhost:8000";
    
    // getters
    QString getUrl();
    qint64 getRetry();
    QString getMethod();
    qint64 getTryCount();

    // setters
    void setRetry(qint64);
    void setUrl(QString);
    void setMethod(QString);


private:
    // properties
    qint64 retry = 0;
    qint64 tryCount = 0;
    QString url;
    QVariant headers;
    QString method = "GET";
    QVariant body;
    QNetworkAccessManager manager;
    
    // methods
    QNetworkRequest getNetworkRequest();
    void requestComplete(QNetworkReply*);
    QVariant evaluateJsonBody(QVariant);
    QHttpMultiPart* evaluateFormDataBody(QVariant);
    QString checkBodyType(QVariant);

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

signals:
    void requestRetry(qint64);
    void methodChanged(QString method);
    void urlChanged(QString url);
    void error(QVariant body);
    void loaded(QVariant body);
    void finally(QVariant body);
    void downloadProgress(qint64 bytesReceived, qint64 bytesTotal);
    void uploadProgress(qint64 bytesSent, qint64 bytesTotal);
};

#endif // RESTLIB_H
