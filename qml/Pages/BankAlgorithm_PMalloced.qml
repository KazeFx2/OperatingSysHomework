import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import FluentUI 1.0
import "qrc:/src/js/tools.js" as Tools

FluContentPage {
    id: root

    property var dataSource: []
    property int sortTypeUp: -1
    property int sortTypeDown: -1
    property var names

    // title:"TableView"
    signal checkBoxChanged()

    function loadData() {
        var names = CppBankAlgorithm.getNames();
        var n_process = CppBankAlgorithm.getNProcess();
        var process_ids = CppBankAlgorithm.getProcesses();
        const dataSource = [];
        for (var i = 0; i < n_process; i++) {
            var tmp = {
                "checkbox": table_view.customItem(checbox, {
                    "checked": false
                }),
                "id": process_ids[i],
                "action": table_view.customItem(action),
                "minimumHeight": 50
            };
            var data = CppBankAlgorithm.getMalloced(process_ids[i]);
            for (var j = 0; j < names.length; j++) {
                tmp[names[j]] = data[j];
            }
            dataSource.push(tmp);
        }
        root.dataSource = dataSource;
        table_view.dataSource = root.dataSource;
    }

    Component.onCompleted: {
        loadData();
    }
    onSortTypeUpChanged: {
        table_view.closeEditor();
        if (sortTypeUp === -1 && sortTypeDown === -1)
            table_view.sort();
        else
            table_view.sort((a, b) => {
                return a[names[sortTypeUp]] - b[names[sortTypeUp]];
            });
    }
    onSortTypeDownChanged: {
        table_view.closeEditor();
        if (sortTypeUp === -1 && sortTypeDown === -1)
            table_view.sort();
        else
            table_view.sort((a, b) => {
                return b[names[sortTypeDown]] - a[names[sortTypeDown]];
            });
    }

    Component {
        id: checbox

        Item {
            FluCheckBox {
                anchors.centerIn: parent
                checked: true === options.checked
                enableAnimation: true
                clickListener: function() {
                    var obj = tableModel.getRow(row);
                    obj.checkbox = table_view.customItem(checbox, {
                        "checked": !options.checked
                    });
                    tableModel.setRow(row, obj);
                    checkBoxChanged();
                }
            }

        }

    }

    Component {
        id: action

        Item {
            RowLayout {
                anchors.centerIn: parent

                FluButton {
                    text: qsTr("Delete")
                    onClicked: {
                        var pid = row.id;
                        var ret = CppBankAlgorithm.deleteProcess(pid);
                        if (ret) {
                            table_view.closeEditor();
                            tableModel.removeRow(row);
                            checkBoxChanged();
                            showSuccess(qsTr("Delete process successfully"));
                        } else {
                            showError(qsTr("Delete process failed"));
                        }
                    }
                }

                FluFilledButton {
                    text: qsTr("Apply")
                    onClicked: {
                        var obj = tableModel.getRow(row);
                        var indx = obj.id;
                        var prev_malloced = CppBankAlgorithm.getMalloced(indx);
                        var names = CppBankAlgorithm.getNames();
                        var succ = [];
                        var failed = [];
                        for (var i = 0; i < prev_malloced.length; i++) {
                            if (obj[names[i]] === prev_malloced[i])
                                continue;

                            var ret = CppBankAlgorithm.modifyMalloced(indx, i, obj[names[i]]);
                            if (ret) {
                                succ.push(names[i]);
                            } else {
                                failed.push(names[i]);
                                obj[names[i]] = prev_malloced[i];
                            }
                        }
                        tableModel.setRow(row, obj);
                        var str_a = succ.length === 0 ? qsTr("No") : "" + succ;
                        var str_b = failed.length === 0 ? qsTr("No") : "" + failed;
                        if (succ.length === 0 && failed.length === 0) {
                            showInfo(qsTr("Nothing changed"));
                            return ;
                        }
                        var info = Tools.format(qsTr("'{0}' columns modified successfully, '{1}' columns modified unsuccessfully"), str_a, str_b);
                        if (succ.length === 0)
                            showInfo(info, 0);
                        else
                            showInfo(info);
                    }
                }

            }

        }

    }

    Component {
        id: column_checbox

        Item {
            RowLayout {
                anchors.centerIn: parent

                FluText {
                    text: qsTr("Select all")
                    Layout.alignment: Qt.AlignVCenter
                }

                FluCheckBox {
                    checked: true === options.checked
                    enableAnimation: false
                    Layout.alignment: Qt.AlignVCenter
                    clickListener: function() {
                        var checked = !options.checked;
                        itemModel.display = table_view.customItem(column_checbox, {
                            "checked": checked
                        });
                        for (var i = 0; i < tableModel.rowCount; i++) {
                            var rowData = tableModel.getRow(i);
                            rowData.checkbox = table_view.customItem(checbox, {
                                "checked": checked
                            });
                            tableModel.setRow(i, rowData);
                        }
                    }
                }

                Connections {
                    function onCheckBoxChanged() {
                        for (var i = 0; i < tableModel.rowCount; i++) {
                            if (false === tableModel.getRow(i).checkbox.options.checked) {
                                itemModel.display = table_view.customItem(column_checbox, {
                                    "checked": false
                                });
                                return ;
                            }
                        }
                        itemModel.display = table_view.customItem(column_checbox, {
                            "checked": true
                        });
                    }

                    target: root
                }

            }

        }

    }

    Component {
        id: column_sort_src

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

    FluText {
        anchors.centerIn: parent
        text: qsTr("No process alive")
        font.bold: true
        font.pixelSize: 24
        visible: table_view.tableModel.rowCount === 0
    }

    FluTableView {
        id: table_view

        color: FluTools.colorAlpha(FluColors.Black, FluTheme.dark ? 0.2 : 0.05)
        radius: 8
        anchors.topMargin: 20
        columnSource: {
            var names = CppBankAlgorithm.getNames();
            var tmp_width = (width - 390) / names.length;
            if (tmp_width < 100)
                tmp_width = 100;

            root.names = ["id"];
            var dt = [{
                "title": table_view.customItem(column_checbox, {
                    "checked": false
                }),
                "dataIndex": 'checkbox',
                "width": 100,
                "minimumWidth": 100,
                "maximumWidth": 100
            }, {
                "title": table_view.customItem(column_sort_src, {
                    "name": "PID",
                    "inx": 0
                }),
                "dataIndex": root.names[0],
                "width": 100,
                "minimumWidth": 100,
                "maximumWidth": 100,
                "readOnly": true
            }];
            for (var i = 0; i < names.length; i++) {
                // readOnly: false

                root.names.push(names[i]);
                dt.push({
                    "title": table_view.customItem(column_sort_src, {
                        "name": names[i],
                        "inx": i + 1
                    }),
                    "dataIndex": names[i],
                    "width": tmp_width,
                    "minimumWidth": 100,
                    "maximumWidth": tmp_width > 200 ? tmp_width : 200
                });
            }
            dt.push({
                "title": qsTr("Operation"),
                "dataIndex": "action",
                "width": 160,
                "minimumWidth": 160,
                "maximumWidth": 160
            });
            return dt;
        }

        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            bottom: parent.bottom
        }

    }

    Rectangle {
        id: pad_rect

        anchors.bottom: table_view.bottom
        width: parent.width
        height: 10
        visible: false
    }

    FluFilledButton {
        id: delete_all

        text: qsTr("Delete Selected")
        anchors.bottom: pad_rect.top
        anchors.horizontalCenter: parent.horizontalCenter
        disabled: table_view.tableModel.rowCount === 0
        onClicked: {
            var deleted = 0;
            for (var i = table_view.tableModel.rowCount - 1; i >= 0; i--) {
                var rowData = table_view.tableModel.getRow(i);
                if (!rowData.checkbox.options.checked)
                    continue;

                var id = rowData.id;
                var ret = CppBankAlgorithm.deleteProcess(id);
                if (ret) {
                    deleted++;
                    table_view.tableModel.removeRow(i);
                }
            }
            showInfo(Tools.format(qsTr("Deleted {0} process(es)"), deleted));
        }
    }

}
