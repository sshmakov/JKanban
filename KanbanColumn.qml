import QtQuick 2.0
import QtQml.Models 2.2
//import JiraModel 1.0
import "methods.js" as Utils


Rectangle {
    id: root

    width: 300; height: 300
    property string title: ""
    property variant issues: null

    Component {
        id: dragDelegate

        MouseArea {
            id: dragArea

            property bool held: false

            anchors { left: parent.left; right: parent.right }
            height: content.height

            enabled: visualModel.sortOrder == visualModel.lessThan.length

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
                width: dragArea.width; height: column.implicitHeight + 4

                //border.width: 1
                //border.color: "lightsteelblue"

                //color: dragArea.held ? "lightsteelblue" : "white"
                //Behavior on color { ColorAnimation { duration: 100 } }

                //radius: 2

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

                Column {
                    id: column
                    anchors { fill: parent; margins: 2 }

                    IssueCard {
                        id: card
                        issue: issueRecord
                        width: parent.width
                    }
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

        property var lessThan: [
            function(left, right) { return left.key < right.key },
            function(left, right) { return left.summary < right.summary },
            function(left, right) { return left.creator < right.creator },
            function(left, right) { return left.assignee < right.assignee },
          /*
            function(left, right) {
                if (left.size == "Small")
                    return true
                else if (right.size == "Small")
                    return false
                else if (left.size == "Medium")
                    return true
                else
                    return false
            }
            */
        ]

        property int sortOrder: 0 //orderSelector.selectedIndex
        onSortOrderChanged: {
            items.setGroups(0, items.count, "unsorted")
        }

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

        function sort(lessThan) {
            while (unsortedItems.count > 0) {
                var item = unsortedItems.get(0)
                var index = insertPosition(lessThan, item)

                item.groups = "items"
                items.move(item.itemsIndex, index)
            }
        }

        items.includeByDefault: false
        groups: VisualDataGroup {
            id: unsortedItems
            name: "unsorted"

            includeByDefault: true
            onChanged: {
                if (visualModel.sortOrder == visualModel.lessThan.length)
                    setGroups(0, count, "items")
                else
                    visualModel.sort(visualModel.lessThan[visualModel.sortOrder])
            }
        }
        model: root.issues
        delegate: dragDelegate
    }

    ListView {
        id: view

        anchors {
            left: parent.left; top: titleRect.bottom;
            right: parent.right;
            bottom: parent.bottom;
//            bottom: orderSelector.top;
            margins: 2
        }

        model: visualModel

        spacing: 4
        cacheBuffer: 50
    }

    Rectangle {
        id: titleRect
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            margins: 2
        }
        color: "#cfe5ff"
        //        border.width: 1
//        border.color: "lightsteelblue"
        height: titleText.height+10
        Text {
            id: titleText
            text: root.title
            font.bold: true
            horizontalAlignment: Text.AlignHCenter
            font.pointSize: 12
            anchors {
                centerIn: parent
//                top: parent.top
//                left: parent.left
//                right: parent.right
//                margins: 2
            }
        }
    }
//    ListSelector {
//        id: orderSelector

//        anchors { left: parent.left; right: parent.right; bottom: parent.bottom; margins: 2 }

//        label: "Sort By"
//        list: [ "Key", "Summary", "Creator", "Assignee", "Custom" ]
//        onSelectedIndexChanged: visualModel.sortOrder = selectedIndex
//    }

}
