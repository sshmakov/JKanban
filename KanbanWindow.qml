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

    Item {
        id: row1

        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            margins: 4
        }
        height: Math.max(queryTE.implicitHeight, goButton.implicitHeight)

        TextField {
            id: queryTE
            text: "file:///C:/Projects/qml/search.json"
            anchors.rightMargin: 4
            anchors.right: goButton.left
            anchors.left: parent.left
            anchors.leftMargin: 0
        }

        Button {
            id: goButton
            text: qsTr("Go")
            anchors.right: parent.right
            onClicked: JS.readIssues(queryTE.text)
        }
    }
    KanbanParams {
        id: kanbanParams1
        visible: true
        anchors{
            top: row1.bottom
            right: parent.right
            left: parent.left
            margins: 4
        }
    }
    ListView {
        anchors{
            top: kanbanParams1.bottom
            bottom: parent.bottom
            right: parent.right
            left: parent.left
            margins: 4
        }
        orientation: ListView.Horizontal
        clip: true
        model: ListModel { id: model }
        delegate: KanbanColumn {
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            title: groupName
            issues: issueList
        }
    }
}
