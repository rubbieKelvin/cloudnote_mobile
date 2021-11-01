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
#include "lib/api/restlib.h"
#include "lib/cloudnote/cloudnotemanager.h"
#include "lib/qtstatusbar/src/statusbar.h"


int main(int argc, char *argv[]){

	if (qEnvironmentVariableIsEmpty("QTGLESSTREAM_DISPLAY")) {
		qputenv("QT_QPA_EGLFS_PHYSICAL_WIDTH", QByteArray("213"));
		qputenv("QT_QPA_EGLFS_PHYSICAL_HEIGHT", QByteArray("120"));

#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
		QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

	}

	QGuiApplication app(argc, argv);

	QDir root = QDir(QStandardPaths::writableLocation(QStandardPaths::AppDataLocation));
	root.cdUp();
	QDir().mkdir(root.path());
	QDir().mkdir(QDir::cleanPath(root.path()+QDir::separator()+"stuffsbyrubbie"));

	app.setApplicationName("CloudNote");
	app.setOrganizationName("stuffsbyrubbie");
	app.setOrganizationDomain("com.stuffsbyrubbie.cloudenote");

	Cxx cxx;
	CloudnoteManager cm;
	QQmlApplicationEngine engine;

	QString appDataRoot = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
	if (!QDir().exists(appDataRoot)){
		// check if parent folder exists
		QDir parent = QDir(appDataRoot);
		parent.cdUp();

		if (!parent.exists()){
			qDebug() << "creating root directory" << parent;
			QDir().mkdir(parent.path());
		}
		qDebug() << "creating appDataRoot" << appDataRoot;
		QDir().mkdir(appDataRoot);
	}

	cxx.key = 13;
	cxx.root = QDir::cleanPath(appDataRoot + QDir::separator() + "rubbbie-crypt-files");

	if (!QDir().exists(cxx.root)){
		QDir().mkdir(cxx.root);
	}

	const QUrl url(QStringLiteral("qrc:/uix/main.qml"));

    qmlRegisterType<StatusBar>("StuffsByRubbie", 0, 1, "StatusBar");
	qmlRegisterType<RestClient>("StuffsByRubbie", 0, 1, "RestClient");
	
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

	engine.rootContext()->setContextProperty("cm", &cm);
	engine.rootContext()->setContextProperty("cxx", &cxx);

	engine.load(url);
	return app.exec();
}
