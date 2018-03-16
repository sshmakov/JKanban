import QtQuick 2.0
import "methods.js" as JS

Rectangle {
    id: rectangle1
    color: "#fbeded"
    radius: 10
    border.color: "#abfdf4"
    width: 300
    height: 150

    property variant issue: null
    onIssueChanged: {
        var p = JS.getValue(issue,"fields/project/key")
        var key = JS.getValue(issue,"key")
        keyText.text = key
        summaryText.text = JS.getValue(issue,"fields/summary")
        dateText.text = JS.getValue(issue,"fields/created")
        creatorText.text = JS.getValue(issue,"fields/creator/displayName")
        var v = JS.getValue(issue,"fields/assignee/displayName")
        assigneeText.text = v === null ? "(no assigned)" : v
        var img = JS.getValue(issue,"fields/priority/iconUrl")
        var txt = JS.getValue(issue,"fields/priority/name")
        priorityImage.source = typeof img == 'undefined' || img === null ? "" : img
    }

    Text {
        id: keyText
        text: "<a href='http://ya.ru'>JIRASERVER-1001</a>"
        anchors.top: parent.top
        anchors.topMargin: 8
        anchors.left: parent.left
        anchors.leftMargin: 8
        font.bold: true
        font.pixelSize: 14
        onLinkActivated: Qt.openUrlExternally(link)
    }

    Text {
        id: summaryText
        y: 51
        height: 42
        color: "#002f7b"
        text: "Create a Global permission for Auditing teams to have full read only access to the instance"
        anchors.right: parent.right
        anchors.rightMargin: 8
        anchors.left: parent.left
        anchors.leftMargin: 8
        wrapMode: Text.WordWrap
        font.pixelSize: 15
        textFormat: Text.PlainText
    }

    Image {
        id: priorityImage
        x: 276
        width: 16
        height: 16
        anchors.top: parent.top
        anchors.topMargin: 9
        anchors.right: parent.right
        anchors.rightMargin: 8
        source: "minor.svg"
    }

    Text {
        id: dateText
        x: 198
        y: 31
        color: "#949090"
        text: "13.03.2018 17:11"
        anchors.right: parent.right
        anchors.rightMargin: 8
        font.pixelSize: 12
    }

    Text {
        id: creatorText
        y: 31
        color: "#949090"
        text: "Chung Park Chan"
        anchors.left: parent.left
        anchors.leftMargin: 8
        font.pixelSize: 12
    }

    Text {
        id: assigneeText
        x: 218
        y: 128
        text: "Kiran Shekhar"
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 8
        anchors.rightMargin: 8
        anchors.right: parent.right
        font.pixelSize: 12
    }

}
