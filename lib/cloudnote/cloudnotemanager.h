#ifndef CLOUDNOTEMANAGER_H
#define CLOUDNOTEMANAGER_H

#include <QObject>
#include <QAudioOutput>

class CloudnoteManager : public QObject{
	Q_OBJECT

public:
	explicit CloudnoteManager(QObject *parent = nullptr);

public slots:
	QString getFile(QString);

};

#endif // CLOUDNOTEMANAGER_H
