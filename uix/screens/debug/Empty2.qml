import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import QtMultimedia 5.15

Page{
    id: root

    Button{
        anchors.centerIn: parent
        text: "Play"
        onClicked: {
            const temp = cm.getFile("file:///home/rubbiekelvin/.local/share/stuffsbyrubbie/CloudNote/downloads/17.audio.zlib")
            audio.source = temp;
            audio.play();
        }
    }

    Audio{
        id: audio
    }
}
