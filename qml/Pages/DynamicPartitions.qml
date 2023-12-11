import QtQuick 2.15
import FluentUI 1.0
import QtQuick.Layouts 1.15
import "qrc:/src/js/tools.js" as Tools

FluScrollablePage {
    id: root

    property int sortTypeUp: -1
    property int sortTypeDown: -1
    property var names: ["index", "start", "size"]
    property int currentI: 0
    property bool noUpdate: false

    signal checkBoxChanged()

    function loadData(_type) {
        if (_type === 0)
            var data = CppDynamicPart.getAllZones();
        else if (_type === 2)
            data = CppDynamicPart.getZones();
        else
            data = CppDynamicPart.getZonesUsed();
        const dataSource = [];
        for (var i = 0; i < data.length; i++) {
            var tmp = {
                "checkbox": table_view.customItem(checbox, {
                    "checked": false
                }),
                "type": table_view.customItem(type, {
                    "used": _type === 0 ? data[i].type === 'Used' : (_type === 1 ? true : false)
                }),
                "index": data[i].index + 1,
                "start": data[i].start,
                "size": data[i].size,
                "action": table_view.customItem(action),
                "minimumHeight": 50
            };
            dataSource.push(tmp);
        }
        table_view.dataSource = dataSource;
        sortTypeUp = sortTypeDown = -1;
        checkBoxChanged();
    }

    title: qsTr("Dynamic Partitions")
    width: parent.width
    height: parent.height
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
    Component.onCompleted: {
        loadData(root.currentI);
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
        id: type_column

        Item {
            FluComboBox {
                id: combobox

                property int prev: 0

                editable: false
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.right: parent.right
                onCurrentIndexChanged: {
                    if (currentIndex !== prev) {
                        prev = currentIndex;
                        root.currentI = currentIndex;
                        loadData(currentIndex);
                    }
                }
                Component.onCompleted: {
                    prev = root.currentI;
                    combobox.currentIndex = root.currentI;
                }

                model: ListModel {
                    id: model

                    ListElement {
                        text: qsTr("Both")
                    }

                    ListElement {
                        text: qsTr("Used")
                    }

                    ListElement {
                        text: qsTr("Free")
                    }

                }

            }

        }

    }

    Component {
        id: type

        Item {
            FluText {
                anchors.centerIn: parent
                text: options.used === true ? qsTr("Used") : qsTr("Free")
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
                        var tmp = tableModel.getRow(row);
                        var type = tmp.type.options.used;
                        var addr = tmp.start;
                        var num = tmp.index - 1;
                        if (type === false) {
                            if (CppDynamicPart.deleteZone(num))
                                showSuccess(qsTr("Delete successfully"));
                            else
                                showError(qsTr("Delete failed"));
                        } else {
                            if (CppDynamicPart.freeMem(addr))
                                showSuccess(qsTr("Delete successfully"));
                            else
                                showError(qsTr("Delete failed"));
                        }
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

    FluArea {
        Layout.topMargin: 10
        width: parent.width
        height: inner_col.height + paddings * 2
        paddings: 10

        Column {
            id: inner_col

            width: parent.width

            FluText {
                padding: 10
                font.bold: true
                font.pixelSize: 16
                text: qsTr("Partitions")
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

            FluTableView {
                id: table_view

                width: parent.width
                height: (dataSource.length + 1) * 50 - 8
                color: FluTools.colorAlpha(FluColors.Black, FluTheme.dark ? 0.2 : 0.05)
                radius: 8
                anchors.topMargin: 20
                columnSource: [{
                    "title": table_view.customItem(column_checbox, {
                        "checked": false
                    }),
                    "dataIndex": 'checkbox',
                    "width": 100,
                    "minimumWidth": 100,
                    "maximumWidth": 100
                }, {
                    "title": table_view.customItem(type_column),
                    "dataIndex": 'type',
                    "width": 100,
                    "minimumWidth": 100,
                    "maximumWidth": 100
                }, {
                    "title": table_view.customItem(column_sort_src, {
                        "name": qsTr("Number"),
                        "inx": 0
                    }),
                    "dataIndex": 'index',
                    "width": (parent.width - 332) / 3 > 120 ? (parent.width - 332) / 3 : 120,
                    "minimumWidth": 120,
                    "maximumWidth": (parent.width - 332) / 3 > 120 ? (parent.width - 332) / 3 : 120,
                    "readOnly": true
                }, {
                    "title": table_view.customItem(column_sort_src, {
                        "name": qsTr("StartAddress"),
                        "inx": 1
                    }),
                    "dataIndex": 'start',
                    "width": (parent.width - 332) / 3 > 120 ? (parent.width - 332) / 3 : 120,
                    "minimumWidth": 120,
                    "maximumWidth": (parent.width - 332) / 3 > 120 ? (parent.width - 332) / 3 : 120,
                    "readOnly": true
                }, {
                    "title": table_view.customItem(column_sort_src, {
                        "name": qsTr("Size"),
                        "inx": 2
                    }),
                    "dataIndex": 'size',
                    "width": (parent.width - 332) / 3 > 120 ? (parent.width - 332) / 3 : 120,
                    "minimumWidth": 120,
                    "maximumWidth": (parent.width - 332) / 3 > 120 ? (parent.width - 332) / 3 : 120,
                    "readOnly": true
                }, {
                    "title": qsTr("Operation"),
                    "dataIndex": "action",
                    "width": 100,
                    "minimumWidth": 100,
                    "maximumWidth": 100
                }]
            }

            Rectangle {
                height: 10
                width: parent.width
                color: FluColors.Transparent
            }

            FluFilledButton {
                x: (parent.width - width) / 2
                text: qsTr("Delete Selected")
                disabled: table_view.tableModel.rowCount === 0
                onClicked: {
                    var deleted = 0;
                    root.noUpdate = true;
                    for (var i = table_view.tableModel.rowCount - 1; i >= 0; i--) {
                        var rowData = table_view.tableModel.getRow(i);
                        if (!rowData.checkbox.options.checked)
                            continue;

                        var tmp = rowData;
                        var type = tmp.type.options.used;
                        var addr = tmp.start;
                        var num = tmp.index - 1;
                        if (type === false) {
                            if (CppDynamicPart.deleteZone(num))
                                deleted++;

                        } else {
                            if (CppDynamicPart.freeMem(addr))
                                deleted++;

                        }
                    }
                    root.noUpdate = false;
                    showInfo(Tools.format(qsTr("Deleted {0} Zone(s)"), deleted));
                    loadData(root.currentI);
                    checkBoxChanged();
                }
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
                        root.currentI = 0;
                        CppDynamicPart.reset();
                        showInfo(qsTr("Clear finished"));
                    }
                }

                Rectangle {
                    width: childrenRect.width
                    height: childrenRect.height
                    color: FluColors.Transparent
                    anchors.centerIn: parent

                    FluText {
                        text: qsTr("Strategy")
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Rectangle {
                        height: childrenRect.height
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.children[0].right
                        anchors.leftMargin: 10
                        color: FluColors.Transparent
                        width: 100
                        Component.onCompleted: {
                            for (var i = 0; i < model.count; i++) if (model.get(i).text === CppDynamicPart.getStrategy()) {
                                strategy.currentIndex = i;
                                break;
                            }
                        }

                        FluComboBox {
                            id: strategy

                            editable: false
                            anchors.left: parent.left
                            anchors.right: parent.right
                            onAccepted: {
                            }

                            model: ListModel {
                                id: model

                                ListElement {
                                    text: "FF"
                                }

                                ListElement {
                                    text: "NF"
                                }

                                ListElement {
                                    text: "BF"
                                }

                                ListElement {
                                    text: "WF"
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
                            if (CppDynamicPart.setStrategy(strategy.currentText)) {
                                showSuccess(qsTr("Apply successfully"));
                            } else {
                                showError(qsTr("Apply failed"));
                                for (var i = 0; i < model.count; i++) if (model.get(i).text === CppDynamicPart.getStrategy()) {
                                    strategy.currentIndex = i;
                                    break;
                                }
                            }
                        }
                    }

                }

                FluFilledButton {
                    anchors.right: parent.right
                    text: qsTr("Load Default")
                    onClicked: {
                        root.currentI = 0;
                        CppDynamicPart.loadDefaultData();
                        showInfo(qsTr("Reset finished"));
                    }
                }

            }

            Rectangle {
                height: 10
                width: parent.width
                color: FluColors.Transparent
            }

            FluText {
                padding: 10
                font.bold: true
                text: qsTr("Add Partition")
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
                width: parent.width
                height: childrenRect.height
                color: FluColors.Transparent

                Rectangle {
                    id: saddr_zone

                    anchors.verticalCenter: parent.verticalCenter
                    height: childrenRect.height
                    width: parent.width * 2 / 5
                    color: FluColors.Transparent

                    FluText {
                        anchors.verticalCenter: parent.verticalCenter
                        padding: 10
                        text: qsTr("Start Address")
                    }

                    FluTextBox {
                        id: add_addr

                        anchors.left: parent.children[0].right
                        anchors.verticalCenter: parent.verticalCenter
                        width: parent.width - parent.children[0].width - 10
                        placeholderText: qsTr("Start address of memory zone")

                        validator: IntValidator {
                        }

                    }

                }

                Rectangle {
                    anchors.left: saddr_zone.right
                    anchors.verticalCenter: parent.verticalCenter
                    height: childrenRect.height
                    width: parent.width * 2 / 5
                    color: FluColors.Transparent

                    FluText {
                        anchors.verticalCenter: parent.verticalCenter
                        padding: 10
                        text: qsTr("Size")
                    }

                    FluTextBox {
                        id: add_size

                        anchors.left: parent.children[0].right
                        anchors.verticalCenter: parent.verticalCenter
                        width: parent.width - parent.children[0].width - 10
                        placeholderText: qsTr("Byte size of memory zone")

                        validator: IntValidator {
                        }

                    }

                }

                Rectangle {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    height: childrenRect.height
                    width: parent.width * 1 / 5
                    color: FluColors.Transparent

                    FluFilledButton {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        text: qsTr("Add")
                        disabled: add_addr.text === "" || add_size.text === ""
                        onClicked: {
                            var start = parseInt(add_addr.text);
                            var size = parseInt(add_size.text);
                            if (CppDynamicPart.addZone(size, start) !== -1) {
                                showSuccess(qsTr("Add successfully"));
                                add_addr.text = "";
                                add_size.text = "";
                            } else {
                                showError(qsTr("Add failed"));
                            }
                        }
                    }

                }

            }

            Rectangle {
                height: 10
                width: parent.width
                color: FluColors.Transparent
            }

            FluText {
                padding: 10
                font.bold: true
                text: qsTr("Allocate memory / Free memory")
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
                width: parent.width
                height: childrenRect.height
                color: FluColors.Transparent

                Rectangle {
                    width: parent.width / 2
                    height: childrenRect.height
                    anchors.verticalCenter: parent.verticalCenter
                    color: FluColors.Transparent

                    FluText {
                        anchors.verticalCenter: parent.verticalCenter
                        padding: 10
                        text: qsTr("Size")
                    }

                    FluTextBox {
                        id: malloc_size

                        anchors.verticalCenter: parent.verticalCenter
                        width: parent.width - parent.children[0].width - parent.children[2].width - 10
                        anchors.left: parent.children[0].right
                        placeholderText: qsTr("Byte size of memory")

                        validator: IntValidator {
                        }

                    }

                    FluFilledButton {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        text: qsTr("Allocate")
                        disabled: malloc_size.text === ""
                        onClicked: {
                            var ret = CppDynamicPart.allocMem(parseInt(malloc_size.text));
                            if (ret.status === -1) {
                                showError(qsTr("Allocation failed"));
                            } else {
                                showSuccess(qsTr("Allocation successfully"));
                                malloc_size.text = "";
                            }
                        }
                    }

                }

                Rectangle {
                    width: parent.width / 2
                    height: childrenRect.height
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    color: FluColors.Transparent

                    FluText {
                        anchors.verticalCenter: parent.verticalCenter
                        padding: 10
                        text: qsTr("Address")
                    }

                    FluTextBox {
                        id: free_addr

                        anchors.verticalCenter: parent.verticalCenter
                        width: parent.width - parent.children[0].width - parent.children[2].width - 10
                        anchors.left: parent.children[0].right
                        placeholderText: qsTr("Start Address to free")

                        validator: IntValidator {
                        }

                    }

                    FluFilledButton {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        text: qsTr("Dealloc")
                        disabled: free_addr.text === ""
                        onClicked: {
                            if (CppDynamicPart.freeMem(parseInt(free_addr.text))) {
                                showSuccess(qsTr("Free successfully"));
                                free_addr.text = "";
                            } else {
                                showError(qsTr("Free failed"));
                            }
                        }
                    }

                }

            }

        }

    }

    Connections {
        target: CppDynamicPart
        onUpdateChanged: {
            if (!root.noUpdate)
                loadData(root.currentI);

        }
    }

}
