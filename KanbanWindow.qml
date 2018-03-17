import QtQuick 2.0
import QtQuick.Controls 1.2
import "methods.js" as JS
import QtQuick.LocalStorage 2.0

Rectangle {
    id: rectangle1
    width: 640
    height: 480
    color: "#e0edf6"
    clip: true
    Component.onCompleted: JS.loadSettings()

    property var mainModel: []

    Button {
        id: goButton
        text: qsTr("Go")
        anchors.top: parent.top
        anchors.topMargin: 8
        anchors.rightMargin: 8
        anchors.right: parent.right
        onClicked: JS.readIssues(queryTE.text)
    }

    ListView {
        anchors.topMargin: 6
        anchors.rightMargin: 8
        anchors.leftMargin: 8
        //id: view
        clip: true
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 8
        anchors.top: kanbanParams1.bottom
        anchors.right: parent.right
        anchors.left: parent.left
        orientation: ListView.Horizontal
        model: ListModel { id: model}
        delegate: KanbanColumn {
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            title: groupName
            issues: issueList
        }
    }

    TextField {
        id: queryTE
        //        height: 28
        text: "file:///C:/Projects/qml/search.json"
        anchors.right: goButton.left
        anchors.rightMargin: 4
        anchors.top: parent.top
        anchors.topMargin: 8
        anchors.left: parent.left
        anchors.leftMargin: 8
        font.pixelSize: 12
    }

    KanbanParams {
        id: kanbanParams1
        anchors.top: queryTE.bottom
        anchors.topMargin: 6
        anchors.rightMargin: 8
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.leftMargin: 8
    }


}
