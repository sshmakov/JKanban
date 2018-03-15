import QtQuick 2.3
import QtQuick.Controls 1.2
import "methods.js" as Utils
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

//    TextArea {
//        id: textArea1
//        x: 61
//        y: 36
//        width: 501
//        height: 299
//    }

    Button {
        id: button1
        x: 73
        y: 366
        text: qsTr("Button")
        onClicked: {
            var doc = new XMLHttpRequest();
            doc.onreadystatechange = function() {
                if (doc.readyState == XMLHttpRequest.HEADERS_RECEIVED) {
//                    showRequestInfo("Headers -->");
//                    showRequestInfo(doc.getAllResponseHeaders ());
//                    showRequestInfo("Last modified -->");
//                    showRequestInfo(doc.getResponseHeader ("Last-Modified"));

                } else if (doc.readyState == XMLHttpRequest.DONE) {
//                    var text = doc.responseText
//                    JSON.parse(text)
                    var data = JSON.parse(doc.responseText);
                    model.clear();
                    var list = data["issues"];
                    for (var i in list) {
                        var item = list[i]
                        model.append({
                                         key: item["key"],
                                         summary: Utils.getValue(item,"fields/summary"),
                                         assignee: Utils.getValue(item,"fields/assignee/displayName"),
                                         creator: Utils.getValue(item,"fields/creator/displayName"),
                                         status: Utils.getValue(item,"fields/status/name"),
                                     });
                    }
//                    var a = doc.responseXML.documentElement;
//                    for (var ii = 0; ii < a.childNodes.length; ++ii) {
//                        showRequestInfo(a.childNodes[ii].nodeName);
//                    }
//                    showRequestInfo("Headers -->");
//                    showRequestInfo(doc.getAllResponseHeaders ());
//                    showRequestInfo("Last modified -->");
//                    showRequestInfo(doc.getResponseHeader ("Last-Modified"));
                }
            }
            var url = "https://jira.atlassian.com/rest/api/2/search?jql=project = 'JIRA Server (including JIRA Core)' AND updated >= -1w&maxResults=10"
            doc.open("GET", "file:///C:/Projects/qml/search.json");
            doc.send();
        }
    }
    ListView {
        x: 61
        y: 36
        width: 501
        height: 235
        //orientation: ListView.Horizontal
//        anchors.fill: parent
        model: ListModel { id: model}
        delegate: Text { text: key + ' ' + status + ' ' + summary + ' ' + assignee}
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
        x: 246
        y: 366
        text: qsTr("Button")
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
                                r += rs.rows.item(i).skey + ", " + rs.rows.item(i).svalue + "\n"
                            }
                            text1.text = 'readed: ' + c + '\n' + r
                        }
                        )

        }
    }

    Text {
        id: text1
        x: 368
        y: 290
        width: 233
        height: 142
        text: qsTr("Text")
        font.pixelSize: 12
    }
}
