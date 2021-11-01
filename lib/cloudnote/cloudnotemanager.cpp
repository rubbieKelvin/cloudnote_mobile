#include <QUrl>
#include <QDir>
#include <QFile>
#include <QDebug>
#include <QIODevice>
#include <QDataStream>
#include <QStandardPaths>
#include "cloudnotemanager.h"

CloudnoteManager::CloudnoteManager(QObject *parent) : QObject(parent){}

QString CloudnoteManager::getFile(QString filepath){
	QUrl url(filepath); // the file at this path is compressed, lets try to decompress it
	QFile file(url.toLocalFile());
	QString tempDir = QStandardPaths::writableLocation(QStandardPaths::TempLocation);
	QByteArray compressedData;

	// read compressed file
	if (file.open(QIODevice::ReadOnly)){
		compressedData = file.readAll();
	}

	// write compressed file
	QFile tempFile(QDir::cleanPath(tempDir+QDir::separator()+"cloud-note-current.mp3"));
	if (tempFile.open(QIODevice::WriteOnly)){
		QDataStream stream(&tempFile);
		QByteArray decompressedData = qUncompress(compressedData);
		stream << decompressedData.remove(0, 4);

		if (!decompressedData.isEmpty()){
			QUrl dec_url = QUrl::fromLocalFile(tempFile.fileName());
			return dec_url.toString();
		}
	}

	return "";
}

//void CloudnoteManager::play(QString filename){
//	QUrl url(filename);
//	QFile source(url.toLocalFile());

//	if (source.open(QIODevice::ReadOnly)){
//			QAudioFormat format;

//			// Set up the format, eg.
//			format.setSampleRate(8000);
//			format.setChannelCount(1);
//			format.setSampleSize(8);
//			format.setCodec("audio/mpeg");
//			format.setByteOrder(QAudioFormat::LittleEndian);
//			format.setSampleType(QAudioFormat::UnSignedInt);

//			QAudioDeviceInfo info(QAudioDeviceInfo::defaultOutputDevice());
//			if (!info.isFormatSupported(format)) {
//				qWarning() << "Raw audio format not supported by backend, cannot play audio.";
//				return;
//			}

//			this->audioOutput = new QAudioOutput(format, this);
//			this->audioOutput->start(&source);
//	}
//}
