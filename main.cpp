#include <QDir>
#include <QQmlContext>
#include <QStandardPaths>
#include <QGuiApplication>
#include <QQmlApplicationEngine>

# if defined (Q_OS_ANDROID)
#include <QtAndroid>
# endif

// my lib
#include "lib/cxx/cxx.h"
#include "lib/qtstatusbar/src/statusbar.h"


int main(int argc, char *argv[]){

	if (qEnvironmentVariableIsEmpty("QTGLESSTREAM_DISPLAY")) {
		qputenv("QT_QPA_EGLFS_PHYSICAL_WIDTH", QByteArray("213"));
		qputenv("QT_QPA_EGLFS_PHYSICAL_HEIGHT", QByteArray("120"));

#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
		QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

	}

// collect permissions


	QGuiApplication app(argc, argv);

	app.setApplicationName("CloudNote");
    app.setOrganizationName("stuffsbyrubbie");
    app.setOrganizationDomain("com.stuffsbyrubbie.cloudenote");

	QQmlApplicationEngine engine;
	Cxx cxx;

	cxx.key = 13;
	cxx.root = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);

	if (!QDir().exists(cxx.root)){
		QDir().mkdir(cxx.root);
	}

	const QUrl url(QStringLiteral("qrc:/uix/main.qml"));

    qmlRegisterType<StatusBar>("StuffsByRubbie", 0, 1, "StatusBar");
	
	QObject::connect(
		&engine,
		&QQmlApplicationEngine::objectCreated,
		&app,
		[url] (QObject *obj, const QUrl &objUrl) {
			if (!obj && url == objUrl) {
				QCoreApplication::exit(-1);
			}
		},
		Qt::QueuedConnection);

	engine.rootContext()->setContextProperty("cxx", &cxx);

	engine.load(url);
	return app.exec();
}
