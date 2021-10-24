#ifndef CXX_H
#define CXX_H

#include <QObject>
#include <QStandardPaths>

class Cxx : public QObject{
    Q_OBJECT

public:
    explicit Cxx(QObject *parent = nullptr);
    QString root = "";
    qint64 key = 2;
    QString ext = ".rubbie-crypt";

public slots:
    void write(QString name, QString data);
    QString read(QString name);
};

#endif // CXX_H
