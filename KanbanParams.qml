import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.LocalStorage 2.0
import "methods.js" as JS

Item {
    width: 480
    height: cbGroupField.height
    property alias groupVariant: cbGroupField.currentIndex
    property string groupValuePath: cbGroupField.model.get(cbGroupField.currentIndex).namePath
    property alias groupList: groupsTE.text

    Text {
        id: label
        height: cbGroupField.height
        text: qsTr("Группировать:")
        verticalAlignment: Text.AlignVCenter
    }

    ComboBox {
        id: cbGroupField
        anchors { left: label.right; leftMargin: 4 }
        model: ListModel {
            ListElement {
                text: qsTr("по статусам")
                namePath: "fields/status/name"
            }
            ListElement {
                text: qsTr("по исполнителям")
                namePath: "fields/assignee/displayName"
            }
            ListElement {
                text: qsTr("по создателям")
                namePath: "fields/creator/displayName"
            }
            ListElement {
                text: qsTr("по типам запросов")
                namePath: "fields/issuetype/name"
            }
        }
    }
    TextField {
        id: groupsTE
        text: ''
        anchors {
            right: buttonGroups.left
            rightMargin: 4
            left: cbGroupField.right
            leftMargin: 4
        }
    }

    Button {
        id: buttonGroups
        text: qsTr("Перерисовать")
        anchors.right: parent.right
        onClicked: JS.repaintKanban()
    }

    Rectangle {
        id: groupBox1
        anchors.top: groupsTE.bottom
        anchors.left: groupsTE.left
        anchors.right: groupsTE.right
        //x: 380
        visible: false
        color: "white"
        height: grBox.height+4
        GroupBox {
            id: grBox
            title: qsTr("")
            y: 2
            anchors.left: parent.left
            anchors.leftMargin: 2
            anchors.right: parent.right
            anchors.rightMargin: 2
            height: 100

            Column {
                id: groupBoxInternal
                Repeater {
                    id: groupView
                    model:  ListModel {
                        ListElement {
                            title: qsTr("Low")
                        }
                        ListElement {
                            title: qsTr("Medium")
                        }
                        ListElement {
                            title: qsTr("High")
                        }
                    }
                    delegate: CheckBox {
                        text: title
//                        anchors {top: groupBox1.top; left: groupBox1.left }
                    }
                }
            }
        }
    }

}
