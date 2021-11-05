#include "imagefilesystemcache.h"
#include "restlib.h"
#include <QMap>

QMap<QString, RestClient*> clients;

ImageFileSystemCache::ImageFileSystemCache(QObject *parent) : QObject(parent){

}

QString ImageFileSystemCache::urlToFilename(QString){

}
