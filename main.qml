import QtQuick 2.3
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.4

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
                text: qsTr("Settings")
                onTriggered: {
                    settings.visible = true;
                }
            }
            MenuItem {
                text: qsTr("Exit")
                onTriggered: Qt.quit();
            }
        }
    }

    GridLayout {
        id: settings
        visible: false
        anchors.fill: parent
        columns: 2

        Label { text: "url" }
        TextField {
            id: urlEdit
            text: kanban.url

            Layout.fillWidth: true
        }
        Label { text: "Default groups" }
        TextField {
            id: groupEdit
            text: kanban.defaultGroups

            Layout.fillWidth: true
        }
        Label { text: "Max results" }
        SpinBox {
            id: maxResultsEdit
            minimumValue: 0
            maximumValue: 1000
            value: kanban.maxResults
        }
        Label { text: "User" }
        TextField {
            id: userEdit
            text: kanban.user

            Layout.fillWidth: true
        }
        Label { text: "Password" }
        TextField {
            id: passwordEdit
            echoMode: TextInput.Password
            Layout.fillWidth: true
        }
        RowLayout {
            Layout.columnSpan: 2
            Button {
                text: "Save"
                onClicked: {
                    if (passwordEdit.text.length === 0 && userEdit.text !== kanban.user) {
                        kanban.setAuth(userEdit.text, passwordEdit.text);
                    }
                    kanban.setUrl(urlEdit.text);
                    kanban.maxResults = maxResultsEdit.value;
                    kanban.defaultGroups = groupEdit.text;
                    settings.visible = false
                }
            }
            Button {
                text: "Close"
                onClicked: {
                    settings.visible = false
                }
            }
        }
        Item {Layout.fillHeight: true} //spacer
    }

    KanbanWindow {
        id: kanban
        visible: !settings.visible
        anchors.fill: parent
    }

}
