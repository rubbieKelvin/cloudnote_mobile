import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

Page {
    id: root
    property bool metaUsesSearchBar: false
    property string metaTitle: "Application"
    property string metaSubtitle: ""
    
    signal setHistory(var view, var target)
}
