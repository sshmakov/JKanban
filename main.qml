import QtQuick 2.3
import QtQuick.Controls 1.2

ApplicationWindow {
    id: applicationWindow1
    visible: true
    width: 649
    height: 480
    title: qsTr("JKanban")

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
