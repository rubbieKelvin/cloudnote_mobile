#include "cxx.h"
#include "core.h"
#include <QDir>
#include <string>
#include <QTextStream>
#include <QDebug>

Cxx::Cxx(QObject *parent) : QObject(parent){

}


void Cxx::write(QString name, QString data){
    QString filepath = root + "/" + name + ext;
    QFile file(filepath);

    if (file.open(QIODevice::WriteOnly)){
        qDebug() << "writing to:" << filepath;

        QTextStream stream(&file);
        std::string encoded = cxx::encode(data.toStdString(), key);

        stream << QString::fromStdString(encoded);
        file.close();
    }else{
        qDebug() << "couldn't write to:" << filepath;
    }
}

QString Cxx::read(QString name){
    QString filepath = root + "/" + name + ext;
    QFile file(filepath);

    if (!file.exists()){
        qDebug() << "file doesnt exist: " << filepath;
        return "";
    }

    if (file.open(QIODevice::ReadOnly | QIODevice::Text)){
        QTextStream stream(&file);
        QString crypted = stream.readAll();
        std::string decrypted = cxx::decode(crypted.toStdString(), key);
        return QString::fromStdString(decrypted);
    }else{
        qDebug() << "cannot read file: " << filepath;
    }

    return "";
}