#ifndef IMAGEFILESYSTEMCACHE_H
#define IMAGEFILESYSTEMCACHE_H

#include <QObject>

class ImageFileSystemCache : public QObject{
	Q_OBJECT

public:
	explicit ImageFileSystemCache(QObject *parent = nullptr);
	QString urlToFilename(QString path);

public slots:
	QString loadImage(QString);

signals:

};

#endif // IMAGEFILESYSTEMCACHE_H
