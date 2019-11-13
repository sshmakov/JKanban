import QtQuick 2.0
import QtQml.Models 2.2
import "methods.js" as Utils


Rectangle {
    id: root

    width: 250
    height: 250
    property string title: "Title"
    property var issues: null

    Component {
        id: dragDelegate

        MouseArea {
            id: dragArea

            property bool held: false

            anchors { left: parent.left; right: parent.right }
            height: content.height

            enabled: true

            drag.target: held ? content : undefined
            drag.axis: Drag.YAxis

            onPressAndHold: held = true
            onReleased: held = false

            Item {
                id: content

                anchors {
                    horizontalCenter: parent.horizontalCenter
                    verticalCenter: parent.verticalCenter
                }
                width: dragArea.width; height: card.height + 4

                Drag.active: dragArea.held
                Drag.source: dragArea
                Drag.hotSpot.x: width / 2
                Drag.hotSpot.y: height / 2

                states: State {
                    when: dragArea.held

                    ParentChange { target: content; parent: root }
                    AnchorChanges {
                        target: content
                        anchors { horizontalCenter: undefined; verticalCenter: undefined }
                    }
                }

                IssueCard {
                    id: card
                    issue: issueRecord
                    anchors { fill: parent; margins: 2 }
                }

                // Закрашивание карточки при перемещении мышью
                Rectangle {
                    anchors.fill: parent
                    color: "lightsteelblue"
                    visible: dragArea.held
                    opacity: 0.5
                }

            }

            DropArea {
                anchors { fill: parent; margins: 10 }

                onEntered: {
                    visualModel.items.move(
                            drag.source.DelegateModel.itemsIndex,
                            dragArea.DelegateModel.itemsIndex)
                }
            }
        }
    }


    DelegateModel {
        id: visualModel

        property int sortOrder: 0
        onSortOrderChanged: items.setGroups(0, items.count, "unsorted")

        function insertPosition(lessThan, item) {
            var lower = 0
            var upper = items.count
            while (lower < upper) {
                var middle = Math.floor(lower + (upper - lower) / 2)
                var result = lessThan(item.model, items.get(middle).model);
                if (result) {
                    upper = middle
                } else {
                    lower = middle + 1
                }
            }
            return lower
        }

        items.includeByDefault: false
        groups: VisualDataGroup {
            id: unsortedItems
            name: "unsorted"

            includeByDefault: true
            onChanged: setGroups(0, count, "items")
        }
        model: root.issues
        delegate: dragDelegate
    }


    // Вертикальный список карточек
    ListView {
        id: view
        anchors {
            left: parent.left; top: titleRect.bottom;
            right: parent.right;
            bottom: parent.bottom;
            margins: 2
        }
        model: visualModel
        spacing: 4
        cacheBuffer: 50
    }

    // Заголовок столбца
    Rectangle {
        id: titleRect
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            margins: 2
        }
        color: "#cfe5ff"
        height: titleText.height+10
        Text {
            id: titleText
            text: root.title + " (" + (issues ? issues.rowCount() : 0) + ")"
            font.bold: true
            horizontalAlignment: Text.AlignHCenter
            font.pointSize: 12
            anchors.centerIn: parent
        }
    }
}
