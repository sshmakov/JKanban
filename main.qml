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
    property string jiraGroups: "Gathering Interest;Open;Verified"


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

    Button {
        id: goButton
        text: qsTr("Go")
        anchors.top: parent.top
        anchors.topMargin: 8
        anchors.rightMargin: 8
        anchors.right: parent.right
        onClicked: JS.readIssues()
    }
    ListView {
        anchors.rightMargin: 8
        anchors.leftMargin: 8
        anchors.topMargin: 6
        //id: view
        clip: true
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 8
        anchors.top: groupsTE.bottom
        anchors.right: parent.right
        anchors.left: parent.left
        orientation: ListView.Horizontal
        model: ListModel { id: model}
//        delegate: KanbanColumn {
//            anchors.top: parent.top
//            anchors.bottom: parent.bottom
//            title: groupName
//            issues: issueList
//        }
    }

    TextEdit {
        id: queryTE
        height: 20
        text: qsTr("Text Edit")
        cursorVisible: true
        anchors.right: goButton.left
        anchors.rightMargin: 4
        anchors.top: parent.top
        anchors.topMargin: 8
        anchors.left: parent.left
        anchors.leftMargin: 8
        font.pixelSize: 12
    }

    Text {
        id: text1
        x: 8
        y: 37
        text: qsTr("Группы:")
        font.pixelSize: 12
    }

    GroupBox {
        id: groupBox1
        //x: 380
        visible: false
        anchors.top: groupsTE.bottom
        anchors.topMargin: 6
        anchors.right: buttonGroups.left
        anchors.rightMargin: 6
        title: qsTr("Отображать группы ")

        Column {
            id: column1

            CheckBox {
                id: checkBox1
                text: qsTr("Low")
            }

            CheckBox {
                id: checkBox2
                text: qsTr("Medium")
            }

            CheckBox {
                id: checkBox3
                text: qsTr("High")
            }
        }
    }

    Button {
        id: buttonGroups
        x: 496
        y: 33
        text: qsTr("Выбрать")
        anchors.right: parent.right
        anchors.rightMargin: 78
    }

    TextEdit {
        id: groupsTE
        height: 20
        text: qsTr("Text Edit")
        anchors.top: queryTE.bottom
        anchors.topMargin: 6
        anchors.right: buttonGroups.left
        anchors.rightMargin: 6
        anchors.left: text1.right
        anchors.leftMargin: 6
        font.pixelSize: 12
    }
}
