import QtQuick 2.15
import FluentUI 1.0
import QtQuick.Layouts 1.15
import "qrc:/src/js/tools.js" as Tools

FluScrollablePage {
    id: root

    property int sortTypeUp: -1
    property int sortTypeDown: -1

    title: qsTr("Process Schedule")
    width: parent.width
    height: parent.height

    Component {
        id: col_sort_button

        Item {

            FluText {
                text: options.name
                anchors.centerIn: parent
            }

            ColumnLayout {
                spacing: 0

                anchors {
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                    rightMargin: 4
                }

                FluIconButton {
                    Layout.preferredWidth: 20
                    Layout.preferredHeight: 15
                    iconSize: 12
                    verticalPadding: 0
                    horizontalPadding: 0
                    iconSource: FluentIcons.ChevronUp

                    iconColor: {
                        if (options.inx === root.sortTypeUp)
                            return FluTheme.primaryColor;

                        return FluTheme.dark ? Qt.rgba(1, 1, 1, 1) : Qt.rgba(0, 0, 0, 1);
                    }

                    onClicked: {
                        if (root.sortTypeUp === options.inx) {
                            root.sortTypeUp = -1;
                            return;
                        }
                        root.sortTypeDown = -1;
                        root.sortTypeUp = options.inx;
                    }
                }

                FluIconButton {
                    Layout.preferredWidth: 20
                    Layout.preferredHeight: 15
                    iconSize: 12
                    verticalPadding: 0
                    horizontalPadding: 0
                    iconSource: FluentIcons.ChevronDown

                    iconColor: {
                        if (options.inx === root.sortTypeDown)
                            return FluTheme.primaryColor;

                        return FluTheme.dark ? Qt.rgba(1, 1, 1, 1) : Qt.rgba(0, 0, 0, 1);
                    }

                    onClicked: {
                        if (root.sortTypeDown === options.inx) {
                            root.sortTypeDown = -1;
                            return;
                        }
                        root.sortTypeUp = -1;
                        root.sortTypeDown = options.inx;
                    }
                }
            }
        }
    }

    FluArea {
        Layout.topMargin: 10
        height: inner_col.height + paddings * 2
        width: parent.width
        paddings: 10

        Column {
            id: inner_col

            width: parent.width

            FluText {
                padding: 10
                font.bold: true
                font.pixelSize: 16
                text: qsTr("Processes")
            }

            Rectangle {
                width: parent.width
                height: 1
                radius: 1
                color: FluColors.Grey110
            }

            Rectangle {
                width: parent.width
                height: 10
                color: FluColors.Transparent
            }

            FluTableView {
                id: table_view

                width: parent.width
                height: (dataSource.length + 1) * 50 - 8
                color: FluTools.colorAlpha(FluColors.Black, FluTheme.dark ? 0.2 : 0.05)
                radius: 8

                columnSource: [{
                    "title": qsTr("Name"),
                    "dataIndex": "name",
                    "width": 100,
                    "minimumWidth": 100,
                    "maximumWidth": 100,
                    "readOnly": true
                }, {
                    "title": table_view.customItem(col_sort_button, {
                        "name": qsTr("PID"),
                        "inx": 0
                    }),
                    "dataIndex": "pid",
                    "width": 160,
                    "minimumWidth": 160,
                    "maximumWidth": 160,
                    "readOnly": true
                }, {
                    "title": table_view.customItem(col_sort_button, {
                        "name": qsTr("Priority"),
                        "inx": 1
                    }),
                    "dataIndex": "priority",
                    "width": 160,
                    "minimumWidth": 160,
                    "maximumWidth": 160,
                    "readOnly": true
                }, {
                    "title": table_view.customItem(col_sort_button, {
                        "name": qsTr("SubmitTime"),
                        "inx": 2
                    }),
                    "dataIndex": "submit",
                    "width": 160,
                    "minimumWidth": 160,
                    "maximumWidth": 160,
                    "readOnly": true
                }, {
                    "title": table_view.customItem(col_sort_button, {
                        "name": qsTr("ServeTime"),
                        "inx": 3
                    }),
                    "dataIndex": "serve",
                    "width": 160,
                    "minimumWidth": 160,
                    "maximumWidth": 160,
                    "readOnly": true
                }, {
                    "title": table_view.customItem(col_sort_button, {
                        "name": qsTr("StartTime"),
                        "inx": 4
                    }),
                    "dataIndex": "start",
                    "width": 160,
                    "minimumWidth": 160,
                    "maximumWidth": 160,
                    "readOnly": true
                }, {
                    "title": table_view.customItem(col_sort_button, {
                        "name": qsTr("FinishTime"),
                        "inx": 5
                    }),
                    "dataIndex": "finish",
                    "width": 160,
                    "minimumWidth": 160,
                    "maximumWidth": 160,
                    "readOnly": true
                }, {
                    "title": table_view.customItem(col_sort_button, {
                        "name": qsTr("ResponseTime"),
                        "inx": 6
                    }),
                    "dataIndex": "response",
                    "width": 160,
                    "minimumWidth": 160,
                    "maximumWidth": 160,
                    "readOnly": true
                }, {
                    "title": table_view.customItem(col_sort_button, {
                        "name": qsTr("TurnaroundTime"),
                        "inx": 7
                    }),
                    "dataIndex": "turnaround",
                    "width": 160,
                    "minimumWidth": 160,
                    "maximumWidth": 160,
                    "readOnly": true
                }, {
                    "title": table_view.customItem(col_sort_button, {
                        "name": qsTr("W_TurnaroundTime"),
                        "inx": 8
                    }),
                    "dataIndex": "turnaround_weight",
                    "width": 160,
                    "minimumWidth": 160,
                    "maximumWidth": 160,
                    "readOnly": true
                }]
            }

            FluText {
                padding: 10
                font.bold: true
                font.pixelSize: 16
                text: qsTr("Management")
            }

            Rectangle {
                width: parent.width
                height: 1
                radius: 1
                color: FluColors.Grey110
            }

            Rectangle {
                height: 10
                width: parent.width
                color: FluColors.Transparent
            }

            Rectangle {
                height: childrenRect.height
                width: parent.width
                color: FluColors.Transparent

                FluFilledButton {
                    anchors.left: parent.left
                    text: qsTr("Clear All")
                    onClicked: {
                        // TODO

                    }
                }

                Rectangle {
                    width: childrenRect.width
                    height: childrenRect.height
                    color: FluColors.Transparent
                    anchors.right: parent.right

                    FluText {
                        text: qsTr("Strategy")
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Rectangle {
                        height: childrenRect.height
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.children[0].right
                        anchors.leftMargin: 10
                        width: 100
                        color: FluColors.Transparent
                        Component.onCompleted: {
                            // TODO

                        }

                        FluComboBox {
                            id: strategy

                            editable: false
                            anchors.left: parent.left
                            anchors.right: parent.right

                            model: ListModel {
                                id: model

                                ListElement {
                                    text: "FCFS"
                                }

                                ListElement {
                                    text: "SJF"
                                }

                                ListElement {
                                    text: "PSA"
                                }

                                ListElement {
                                    text: "HRRN"
                                }

                                ListElement {
                                    text: "RR"
                                }

                                ListElement {
                                    text: "MLFQ"
                                }
                            }
                        }
                    }

                    FluFilledButton {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.children[1].right
                        anchors.leftMargin: 10
                        text: qsTr("Apply")
                        onClicked: {
                            // TODO

                        }
                    }
                }
            }

            FluText {
                padding: 10
                font.bold: true
                text: qsTr("Add Process")
            }

            Rectangle {
                width: parent.width
                height: 1
                radius: 1
                color: FluColors.Grey110
            }

            Rectangle {
                height: 10
                width: parent.width
                color: FluColors.Transparent
            }

            Rectangle {
                height: childrenRect.height
                width: parent.width
                color: FluColors.Transparent

                Rectangle {
                    id: line1

                    width: Math.max(line1.childrenRect.width, line2.childrenRect.width, line3.childrenRect.width)
                    height: childrenRect.height
                    color: FluColors.Transparent
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter

                    FluText {
                        padding: 10
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.children[1].left
                        text: qsTr("Name")
                    }

                    FluTextBox {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        width: 200
                        placeholderText: qsTr("Input the name")
                    }
                }

                Rectangle {
                    width: childrenRect.width
                    height: childrenRect.height
                    color: FluColors.Transparent
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter

                    FluText {
                        padding: 10
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        text: qsTr("PID")
                    }

                    FluTextBox {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.children[0].right
                        width: 200
                        placeholderText: qsTr("Input the pid")
                        validator: IntValidator {}
                    }
                }
            }

            Rectangle {
                height: 10
                width: parent.width
                color: FluColors.Transparent
            }

            Rectangle {
                height: childrenRect.height
                width: parent.width
                color: FluColors.Transparent

                Rectangle {
                    id: line2

                    width: Math.max(line1.childrenRect.width, line2.childrenRect.width, line3.childrenRect.width)
                    height: childrenRect.height
                    color: FluColors.Transparent
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter

                    FluText {
                        padding: 10
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.children[1].left
                        text: qsTr("Priority")
                    }

                    FluTextBox {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        width: 200
                        placeholderText: qsTr("Input the priority")
                        validator: IntValidator {}
                    }
                }

                Rectangle {
                    width: childrenRect.width
                    height: childrenRect.height
                    color: FluColors.Transparent
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter

                    FluText {
                        padding: 10
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        text: qsTr("Serve Time")
                    }

                    FluTextBox {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.children[0].right
                        width: 200
                        placeholderText: qsTr("Input the serve time")
                        validator: IntValidator {}
                    }
                }
            }

            Rectangle {
                height: 10
                width: parent.width
                color: FluColors.Transparent
            }

            Rectangle {
                height: childrenRect.height
                width: parent.width
                color: FluColors.Transparent

                Rectangle {
                    id: line3

                    width: Math.max(line1.childrenRect.width, line2.childrenRect.width, line3.childrenRect.width)
                    height: childrenRect.height
                    color: FluColors.Transparent
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter

                    FluText {
                        padding: 10
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.children[1].left
                        text: qsTr("Submit Time")
                    }

                    FluTextBox {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        width: 200
                        placeholderText: qsTr("Input the submit time")
                        validator: IntValidator {}
                    }
                }

                Rectangle {
                    width: childrenRect.width
                    height: childrenRect.height
                    color: FluColors.Transparent
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter

                    FluFilledButton {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        text: qsTr("Add")

                        onClicked: {
                            // TODO

                        }
                    }
                }
            }

            FluText {
                padding: 10
                font.bold: true
                text: qsTr("Delete Process")
            }

            Rectangle {
                width: parent.width
                height: 1
                radius: 1
                color: FluColors.Grey110
            }

            Rectangle {
                height: 10
                width: parent.width
                color: FluColors.Transparent
            }
        }
    }

    Component.onCompleted: {
        loadData()
    }

    function loadData() {
        const data = []
        for (var i = 0; i < 5; i++) {
            var tmp = {
                "name": "name_" + i.toString(),
                "pid": i,
                "priority": i,
                "submit": i,
                "serve": i,
                "start": i,
                "finish": i,
                "response": i,
                "turnaround": i,
                "turnaround_weight": i,
                "minimumHeight": 50
            }
            data.push(tmp)
        }
        table_view.dataSource = data
    }
}
