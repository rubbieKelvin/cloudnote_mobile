import QtQuick 2.15
import QtQuick.Controls 2.15
import "qrc:/uix/scripts/lib/svg.js" as Svg
import "qrc:/uix/scripts/frozen/icon.js" as Icons

ListView{
	id: root
	clip: true
	onVerticalOvershootChanged: {
		if (verticalOvershoot < -slingshotThreshold && !draggingVertically){
			if (shadow.lastShoot===0){
				triggered()
				shadow.lastShoot = verticalOvershoot
			}
		}

		if (verticalOvershoot===0 && !draggingVertically){
			shadow.lastShoot = 0
		}
	}

	QtObject{
		id: shadow
		property int lastShoot: 0
	}
	signal triggered
	property int slingshotThreshold: 130

	Rectangle{
		color: thememanager.accent15
		width: 40
		height: 40
		radius: width/2
		rotation: Math.min(-135-parent.verticalOvershoot, 0)
		anchors.horizontalCenter: parent.horizontalCenter
		y: Math.min(parent.verticalOvershoot*-.7, 90)-height

		Image {
			anchors.centerIn: parent
			source: Svg.fromString(Icons.ICON_COOLICONS_ARROW_SHORT_DOWN, {color: thememanager.accent})
		}
	}
}

/*##^##
Designer {
	D{i:0;autoSize:true;formeditorZoom:0.5;height:480;width:640}
}
##^##*/
