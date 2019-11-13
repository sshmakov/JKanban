import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.2
import QtQuick.LocalStorage 2.0
import "methods.js" as JS

RowLayout {
    implicitWidth: 480
    implicitHeight: cbGroupField.height
    property alias groupVariant: cbGroupField.currentIndex
    property string groupPath: cbGroupField.model.get(cbGroupField.currentIndex).namePath

    Text {
        id: label
        text: qsTr("Группировка:")
        verticalAlignment: Text.AlignVCenter
    }

    ComboBox {
        id: cbGroupField
        model: ListModel {
            ListElement {
                text: qsTr("Статус")
                namePath: "fields/status/name"
            }
            ListElement {
                text: qsTr("Назначен")
                namePath: "fields/assignee/displayName"
            }
            ListElement {
                text: qsTr("Автор")
                namePath: "fields/creator/displayName"
            }
            ListElement {
                text: qsTr("Тип")
                namePath: "fields/issuetype/name"
            }
            ListElement {
                text: qsTr("Приоритет")
                namePath: "fields/priority/name"
            }
        }

        onCurrentIndexChanged: {
            groupPath = model.get(currentIndex).namePath;
            JS.repaintKanban();
        }
    }
}
