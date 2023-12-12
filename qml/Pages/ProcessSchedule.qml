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
                            return ;
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
                            return ;
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
                height: (dataSource.length + 1)  * 50 - 8
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
                        "width": 100,
                        "minimumWidth": 100,
                        "maximumWidth": 100,
                        "readOnly": true
                    }, {
                        "title": table_view.customItem(col_sort_button, {
                            "name": qsTr("Priority"),
                            "inx": 0
                        }),
                        "dataIndex": "priority",
                        "width": 100,
                        "minimumWidth": 100,
                        "maximumWidth": 100,
                        "readOnly": true
                    }, {
                        "title": table_view.customItem(col_sort_button, {
                            "name": qsTr("SubmitTime"),
                            "inx": 0
                        }),
                        "dataIndex": "submit",
                        "width": 100,
                        "minimumWidth": 100,
                        "maximumWidth": 100,
                        "readOnly": true
                    }, {
                        "title": table_view.customItem(col_sort_button, {
                            "name": qsTr("ServeTime"),
                            "inx": 0
                        }),
                        "dataIndex": "serve",
                        "width": 100,
                        "minimumWidth": 100,
                        "maximumWidth": 100,
                        "readOnly": true
                    }, {
                        "title": table_view.customItem(col_sort_button, {
                            "name": qsTr("StartTime"),
                            "inx": 0
                        }),
                        "dataIndex": "start",
                        "width": 100,
                        "minimumWidth": 100,
                        "maximumWidth": 100,
                        "readOnly": true
                    }, {
                        "title": table_view.customItem(col_sort_button, {
                            "name": qsTr("FinishTime"),
                            "inx": 0
                        }),
                        "dataIndex": "finish",
                        "width": 100,
                        "minimumWidth": 100,
                        "maximumWidth": 100,
                        "readOnly": true
                    }, {
                        "title": table_view.customItem(col_sort_button, {
                            "name": qsTr("ResponseTime"),
                            "inx": 0
                        }),
                        "dataIndex": "response",
                        "width": 100,
                        "minimumWidth": 100,
                        "maximumWidth": 100,
                        "readOnly": true
                    }, {
                        "title": table_view.customItem(col_sort_button, {
                            "name": qsTr("TurnaroundTime"),
                            "inx": 0
                        }),
                        "dataIndex": "turnaround",
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
                        "width": 100,
                        "minimumWidth": 100,
                        "maximumWidth": 100,
                        "readOnly": true
                    }]
            }
        }
    }
}
