import QtQuick 2.3
import QtQuick.Controls 1.2
import "methods.js" as JS
import QtQuick.LocalStorage 2.0
//import KanbanColumn 1.0

ApplicationWindow {
    id: applicationWindow1
    visible: true
    width: 649
    height: 480
    title: qsTr("Hello World")




    menuBar: MenuBar {
        Menu {
            title: qsTr("File")
            MenuItem {
                text: qsTr("&Open")
                onTriggered: console.log("Open action triggered");
            }
            MenuItem {
                text: qsTr("Exit")
                onTriggered: Qt.quit();
            }
        }
    }

    KanbanWindow {
        anchors.fill: parent
    }

}
