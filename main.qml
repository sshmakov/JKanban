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
        id: button1
        y: 424
        text: qsTr("Button")
        anchors.left: parent.left
        anchors.leftMargin: 73
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 33
        onClicked: JS.readIssues()
    }
    ListView {
        //id: view
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 100
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.left: parent.left
        orientation: ListView.Horizontal
//        anchors.fill: parent
        model: ListModel { id: model}
        delegate: KanbanColumn {
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            title: groupName
            issues: issueList
        }
//        delegate: Text { text: key + ' ' + status + ' ' + summary + ' ' + assignee}
        //delegate: Text { text: assignee }
//        Component.onCompleted: {
//            var xhr = new XMLHttpRequest;
//            xhr.open("GET", "http://inqstatsapi.inqubu.com/?api_key=YOURKEYHERE&data=population&countries=us");
//            xhr.onreadystatechange = function() {
//                if (xhr.readyState === XMLHttpRequest.DONE) {
//                    var data = JSON.parse(xhr.responseText);
//                    model.clear();
//                    var list = data[0]["population"];
//                    for (var i in list) {
//                        model.append({year: list[i]["year"], population: list[i]["data"]});
//                    }
        //                }
        //            }
        //            xhr.send();
        //        }
    }

    Button {
        id: button2
        y: 424
        text: qsTr("Button")
        anchors.left: parent.left
        anchors.leftMargin: 247
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 33
        onClicked: {
            var db = LocalStorage.openDatabaseSync("JKanban", "1.0", "", 1000000);

            db.transaction(
                        function(tx) {
                            // Create the database if it doesn't already exist
                            tx.executeSql('CREATE TABLE IF NOT EXISTS Settings(skey TEXT, svalue TEXT)');
                            var rs = tx.executeSql('select skey, svalue from Settings')

                            var r = ""
                            var c = rs.rows.length
                            for(var i = 0; i < rs.rows.length; i++) {
                                var skey = rs.rows.item(i).skey
                                var svalue = rs.rows.item(i).svalue
                                r += skey + ", " + svalue + "\n"
                                if (skey === "jiraGroups")
                                    applicationWindow1.jiraGroups = svalue
                            }
                            text1.text = 'readed: ' + c + '\n' + r
                        }
                        )

        }
    }

    Text {
        id: text1
        x: 390
        y: 386
        width: 233
        height: 73
        text: qsTr("Text")
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 21
        anchors.right: parent.right
        anchors.rightMargin: 26
        font.pixelSize: 12
    }
}
