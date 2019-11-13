import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.4
import "methods.js" as JS
import QtQuick.LocalStorage 2.0
import QtQuick.Dialogs 1.3

Rectangle {
    id: rectangle1
    width: 640
    height: 480
    color: "transparent"
    clip: true
    Component.onCompleted: JS.loadSettings()

    property var mainModel: []
    property var projects: []
    property var xhr: null
    property string defaultGroups: "Created;In Progress;Inactive;Wait Review;In Review;Wait Testing;Testing;Closed"
    property string authHash
    property string user
    property string url: "http://your-jira.org"
    property int maxResults: 0
    property int startAt: 0
    property int totalIssuies: 0

    onUrlChanged: {
        JS.readProjects(url);
    }

    function setUrl(newUrl) {
        url = newUrl;
        JS.saveSetting('url', newUrl);
    }

    function setAuth(user, password) {
        rectangle1.user = user;
        authHash = Qt.btoa(user + ':' + password);
        JS.saveSetting('auth', authHash);
        JS.saveSetting('user', user);
    }

    function makeQueryUrl() {
        var arguments = [];

        if (queryEdit.text.length > 0)
            arguments.push("jql=" + queryEdit.text);

        if (maxResults > 0)
            arguments.push("maxResults=" + maxResults);
        arguments.push("startAt=" + startAt);

        return arguments.length > 0 ? url + "/rest/api/2/search?" + arguments.join("&")
                                    : url + "/rest/api/2/search";
    }

    function setQuery(query) {
        queryEdit.text = query
        JS.saveSetting('query', query);
        JS.readIssues(makeQueryUrl())
    }

    MessageDialog {
        id: messageDialog
        title: "Message"
    }

    ColumnLayout {
        anchors.fill: parent
        RowLayout {
            Layout.fillWidth: true
            implicitHeight: Math.max(queryEdit.implicitHeight, goButton.implicitHeight)

            KanbanParams {
                id: kanbanParams1
            }
            Label {text: qsTr("Проект") }
            ComboBox {
                model: projects
                textRole: "name"
                property string lastProject: ""
                onCurrentIndexChanged: {
                    if (currentIndex >= projects.length)
                        return;
                    var key = projects[currentIndex].key;
                    if (key === undefined)
                        return;

                    var query = queryEdit.text;
                    var result = query.match("project=([a-zA-Z0-9-_]+)");
                    if (result !== null) {
                        setQuery(query.replace(result[0], "project=" + key));
                    } else {
                        setQuery("project=" + key);
                    }
                    lastProject = key
                }
            }

            TextField {
                id: queryEdit
                text: ""
                placeholderText: "input jira query"

                Layout.fillWidth: true

                onEditingFinished: {
                    setQuery(queryEdit.text);
                }
            }

            Button {
                id: goButton
                text: qsTr("Go")

                onClicked: {
                    setQuery(queryEdit.text);
                }
            }
        }
        ListView {
            Layout.fillWidth: true
            Layout.fillHeight: true

            orientation: ListView.Horizontal
            clip: true
            model: ListModel { id: model }
            delegate: KanbanColumn {
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                title: groupName
                issues: issueList
                color: index % 2 ? "#fafafa" : "#ffffff"
            }
        }
    }
}
