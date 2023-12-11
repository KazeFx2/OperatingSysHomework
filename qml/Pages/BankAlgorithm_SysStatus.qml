import QtQuick 2.15
import QtQuick.Templates 2.15 as T
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import FluentUI 1.0
import "qrc:/src/js/tools.js" as Tools

FluScrollablePage {
    id: sys_status_page

    property int ringtPad: 10
    property var src_names: []

    signal refreshbuttons()

    function refresh() {
        safe_txt.refresh();
        seq_txt.refresh();
        alive_process_txt.refresh();
        process_num.refresh();
        process_add_list.refresh();
        src_ring_view.refresh_data();
        refreshbuttons();
    }

    width: parent.width
    height: parent.height

    FluText {
        topPadding: 10
        leftPadding: 10
        bottomPadding: 10
        font.bold: true
        font.pixelSize: 16
        text: qsTr("Resources and Usage")
    }

    Rectangle {
        Layout.alignment: Qt.AlignHCenter
        Layout.fillWidth: true
        height: 1
        radius: 1
        color: FluColors.Grey110
    }

    Rectangle {
        width: parent.width
        height: 10
        color: FluColors.Transparent
    }

    // src ring view
    T.ScrollBar {
        id: src_ring_view

        function refresh_data() {
            sys_status_page.src_names = CppBankAlgorithm.getNames();
            for (var i = ring_view.count - 1; i > 0; i--) {
                var tmp = ring_view.get(i);
                var flag = true;
                for (var j = 0; j < sys_status_page.src_names.length; j++) {
                    if (sys_status_page.src_names[j] === tmp.name) {
                        flag = false;
                        break;
                    }
                }
                if (flag)
                    ring_view.remove(i);

            }
            var Cost = CppBankAlgorithm.getCost();
            var Total = CppBankAlgorithm.getTotal();
            for (; i < ring_view.count; i++) {
                ring_view.set(i, {
                    "cost": Cost[i - 1],
                    "total": Total[i - 1]
                });
            }
        }

        implicitWidth: parent.width
        implicitHeight: this_list_view.height
        orientation: ListView.Horizontal

        ListView {
            id: this_list_view

            implicitWidth: parent.width
            implicitHeight: 190
            orientation: ListView.Horizontal
            spacing: {
                var tmp = children[0].children;
                var pad = tmp.length > 2 ? (parent.width - tmp[2].width * (tmp.length - 2)) / (tmp.length - 1) : 0;
                if (pad < 10)
                    pad = 10;

                return pad;
            }
            Component.onCompleted: {
                // Add defalut
                sys_status_page.src_names = CppBankAlgorithm.getNames();
                if (sys_status_page.src_names.length === 0)
                    return ;

                var Cost = CppBankAlgorithm.getCost();
                var Total = CppBankAlgorithm.getTotal();
                var n = CppBankAlgorithm.getNSrc();
                for (var i = 0; i < n; i++) ring_view.append({
                    "name": sys_status_page.src_names[i],
                    "cost": Cost[i],
                    "total": Total[i]
                })
            }

            FluText {
                visible: parent.children[0].children.length < 3
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                font.bold: true
                font.pixelSize: 20
                text: qsTr("No resouces added")
            }

            model: ListModel {
                id: ring_view

                ListElement {
                    name: ""
                    cost: 0
                    total: -1
                }

            }

            delegate: Rectangle {
                id: ring_view_bk

                height: ring_view_col.height + 20
                visible: total !== -1
                width: total === -1 ? 0 : ring_view_col.width + 20
                radius: 10
                color: FluTools.colorAlpha(FluColors.Black, FluTheme.dark ? 0.2 : 0.05)

                Column {
                    id: ring_view_col

                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: ring_item.width

                    FluText {
                        text: (index - 1) + ":" + name
                        bottomPadding: 10
                        x: (ring_item.width - width) / 2
                    }

                    FluProgressRing {
                        id: ring_item

                        height: 100
                        width: height
                        strokeWidth: 10
                        indeterminate: false
                        progressVisible: true
                        value: (total - cost) / total
                    }

                    FluText {
                        topPadding: 10
                        text: cost + "/" + (total - cost) + "/" + total
                        x: (ring_item.width - width) / 2
                    }

                }

            }

        }

    }

    FluText {
        leftPadding: 10
        bottomPadding: 10
        font.bold: true
        font.pixelSize: 16
        text: qsTr("Management")
    }

    Rectangle {
        Layout.alignment: Qt.AlignHCenter
        Layout.fillWidth: true
        height: 1
        radius: 1
        color: FluColors.Grey110
    }

    FluText {
        padding: 10
        font.bold: true
        text: qsTr("Add resource")
    }

    Row {
        FluText {
            id: src_name_txt

            padding: 10
            anchors.verticalCenter: parent.verticalCenter
            text: qsTr("Src Name")
        }

        FluTextBox {
            id: src_name_input

            width: (parent.parent.width - src_name_txt.width - src_size_txt.width - add_src_button.width - src_add_rect.width) / 2
            anchors.verticalCenter: parent.verticalCenter
            placeholderText: qsTr("Input resource name")
        }

        FluText {
            id: src_size_txt

            padding: 10
            anchors.verticalCenter: parent.verticalCenter
            text: qsTr("Src Size")
        }

        FluTextBox {
            id: src_size_input

            width: (parent.parent.width - src_name_txt.width - src_size_txt.width - add_src_button.width - src_add_rect.width - sys_status_page.ringtPad) / 2
            anchors.verticalCenter: parent.verticalCenter
            placeholderText: qsTr("Input resource max size")

            validator: IntValidator {
                bottom: 1
                top: 1000
            }

        }

        Rectangle {
            id: src_add_rect

            width: 10
            height: parent.height
            color: FluColors.Transparent
        }

        FluFilledButton {
            id: add_src_button

            anchors.verticalCenter: parent.verticalCenter
            text: qsTr("Add")
            disabled: {
                if (src_name_input.text !== "" && src_size_input.text !== "")
                    return false;

                return true;
            }
            onClicked: {
                if (src_name_input.text === "" || src_size_input.text === "") {
                    showError(qsTr("Please set the name and max size of new resource"));
                    return ;
                }
                var name = src_name_input.text;
                var size = parseInt(src_size_input.text);
                var names = CppBankAlgorithm.getNames();
                for (var i = 0; i < names.length; i++) {
                    if (name === names[i]) {
                        showError(Tools.format(qsTr("There already exists a resource named '{0}'"), name));
                        return ;
                    }
                }
                var ret = CppBankAlgorithm.addSrc(name, size);
                if (ret !== -1) {
                    var Cost = CppBankAlgorithm.getCost();
                    var Total = CppBankAlgorithm.getTotal();
                    sys_status_page.src_names.push(name);
                    ring_view.append({
                        "name": name,
                        "cost": Cost[ret],
                        "total": Total[ret]
                    });
                    src_name_input.text = "";
                    src_size_input.text = "";
                    showSuccess(qsTr("Add resource successfully"));
                    process_add_list.refresh();
                } else {
                    showError(qsTr("Add resource failed"));
                }
            }
        }

    }

    Rectangle {
        width: parent.width
        height: 10
        color: FluColors.Transparent
    }

    Rectangle {
        Layout.alignment: Qt.AlignHCenter
        Layout.fillWidth: true
        height: 1
        radius: 1
        color: FluColors.Grey110
    }

    // Src del txt
    FluText {
        padding: 10
        font.bold: true
        text: qsTr("Delete resource")
    }

    // Src del row
    Row {
        function delete_() {
            if (delete_type.currentIndex === 0) {
                var ret = CppBankAlgorithm.deleteSrc(parseInt(delete_input.text));
                if (!ret) {
                    showError(Tools.format(qsTr("Delete failed. May resource with ID '{0}' not exist"), parseInt(delete_input.text)));
                    return ;
                }
                ring_view.remove(parseInt(delete_input.text) + 1);
            } else {
                var name = delete_input.text;
                var names = CppBankAlgorithm.getNames();
                var flag = false;
                for (var i = 0; i < names.length; i++) {
                    if (name === names[i]) {
                        flag = true;
                        ret = CppBankAlgorithm.deleteSrc(name);
                        if (!ret) {
                            showError(qsTr("Delete resource faild"));
                            return ;
                        }
                        break;
                    }
                }
                if (!flag) {
                    showError(Tools.format(qsTr("Delete faild. No such resource named '{0}'"), name));
                    return ;
                }
                for (; i < ring_view.count; i++) if (ring_view.get(i).name === name) {
                    ring_view.remove(i);
                    break;
                }
            }
            showSuccess(qsTr("Delete resource successfully"));
            delete_input.text = "";
            sys_status_page.refresh();
        }

        FluText {
            id: type_txt

            anchors.verticalCenter: parent.verticalCenter
            padding: 10
            text: qsTr("Type")
        }

        FluRadioButtons {
            id: delete_type

            anchors.verticalCenter: parent.verticalCenter
            spacing: 8
            onCurrentIndexChanged: {
                delete_input.text = "";
            }

            FluRadioButton {
                text: qsTr("ID")
            }

            FluRadioButton {
                text: qsTr("Name")
            }

        }

        IntValidator {
            id: inx_vali

            bottom: 0
            top: CppBankAlgorithm.getNSrc() - 1
        }

        RegExpValidator {
            id: def_vali
        }

        Rectangle {
            width: (parent.parent.width - type_txt.width - delete_type.width - delete_value_txt.width - delete_input.width - del_src_button.width - sys_status_page.ringtPad) / 2
            height: parent.height
            color: FluColors.Transparent
        }

        FluText {
            id: delete_value_txt

            anchors.verticalCenter: parent.verticalCenter
            padding: 10
            text: qsTr("Value")
        }

        FluTextBox {
            id: delete_input

            anchors.verticalCenter: parent.verticalCenter
            // width: 200
            placeholderText: delete_type.currentIndex === 0 ? qsTr("Input the ID of resource") : qsTr("Input the name of resource")
            validator: delete_type.currentIndex === 0 ? inx_vali : def_vali
        }

        Rectangle {
            width: (parent.parent.width - type_txt.width - delete_type.width - delete_value_txt.width - delete_input.width - del_src_button.width) / 2
            height: parent.height
            color: FluColors.Transparent
        }

        FluContentDialog {
            id: dialog

            title: qsTr("Warnning")
            message: qsTr("There still exist alive processes. Delete resource will kill all processes. Continue?")
            positiveText: qsTr("Confirm")
            onPositiveClicked: {
                parent.delete_();
            }
            negativeText: qsTr("Cancel")
            buttonFlags: FluContentDialogType.PositiveButton | FluContentDialogType.NegativeButton
            onNegativeClicked: {
                showSuccess(qsTr("You cancel the deleting"));
            }
        }

        FluFilledButton {
            id: del_src_button

            anchors.verticalCenter: parent.verticalCenter
            disabled: delete_input.text === "" || CppBankAlgorithm.getNSrc() <= 0
            text: qsTr("Delete")
            onClicked: {
                // TO DO PROCESS CONFIRM
                if (CppBankAlgorithm.getNProcess() > 0)
                    dialog.open();
                else
                    parent.delete_();
            }
        }

    }

    Rectangle {
        width: parent.width
        height: 10
        color: FluColors.Transparent
    }

    Rectangle {
        Layout.alignment: Qt.AlignHCenter
        Layout.fillWidth: true
        height: 1
        radius: 1
        color: FluColors.Grey110
    }

    // Process add txt
    FluText {
        padding: 10
        font.bold: true
        text: qsTr("Add process")
    }

    // Process add row
    Row {
        Rectangle {
            width: parent.parent.width - Math.max(process_add_button.width, process_random_button.width) - process_add_rect.width - sys_status_page.ringtPad
            height: process_add_txt.height
            color: FluColors.Transparent

            Row {
                Rectangle {
                    width: process_add_txt.width
                    height: parent.parent.height
                    color: FluColors.Transparent

                    Column {
                        id: process_add_txt

                        FluText {
                            padding: 6
                            text: qsTr("Name")
                        }

                        FluText {
                            padding: 6
                            text: qsTr("Malloced")
                        }

                        FluText {
                            padding: 6
                            text: qsTr("Need")
                        }

                    }

                }

                Rectangle {
                    width: parent.parent.width - process_add_txt.width
                    height: parent.parent.height
                    color: FluColors.Transparent

                    T.ScrollBar {
                        width: parent.width
                        height: parent.height
                        orientation: ListView.Horizontal

                        ListView {
                            // clip: true

                            id: process_add_list

                            function refresh() {
                                sys_status_page.src_names = CppBankAlgorithm.getNames();
                                for (var i = process_add_model.count - 1; i > 0; i--) {
                                    var tmp = process_add_model.get(i).name;
                                    var flag = false;
                                    for (var j = 0; j < sys_status_page.src_names.length; j++) {
                                        if (tmp === sys_status_page.src_names[j]) {
                                            flag = true;
                                            break;
                                        }
                                    }
                                    if (!flag)
                                        process_add_model.remove(i);

                                }
                                for (; i < sys_status_page.src_names.length; i++) {
                                    tmp = sys_status_page.src_names[i];
                                    flag = false;
                                    for (; j < process_add_model.count; j++) {
                                        if (tmp === process_add_model.get(j).name) {
                                            flag = true;
                                            break;
                                        }
                                    }
                                    if (!flag)
                                        process_add_model.append({
                                        "name": tmp
                                    });

                                }
                            }

                            width: parent.width
                            height: parent.height + 10
                            clip: true
                            orientation: ListView.Horizontal
                            spacing: {
                                var tmp = children[0].children;
                                var pad = tmp.length > 2 ? (parent.width - tmp[2].width * (tmp.length - 2)) / (tmp.length - 1) : 0;
                                if (pad < 10)
                                    pad = 10;

                                return pad;
                            }
                            Component.onCompleted: {
                                refresh();
                            }

                            FluText {
                                visible: parent.children[0].children.length < 3
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.horizontalCenter: parent.horizontalCenter
                                font.bold: true
                                font.pixelSize: 20
                                text: qsTr("Please add resource first")
                            }

                            model: ListModel {
                                id: process_add_model

                                ListElement {
                                    name: ""
                                }

                            }

                            delegate: Rectangle {
                                id: process_add_item_rect

                                height: process_add_item.height
                                visible: index !== 0
                                width: index === 0 ? 0 : 50
                                radius: 5
                                color: FluTools.colorAlpha(FluColors.Black, FluTheme.dark ? 0.2 : 0.05)

                                Column {
                                    id: process_add_item

                                    FluText {
                                        padding: 5
                                        text: name
                                        x: (50 - width) / 2
                                    }

                                    FluMenuSeparator {
                                        width: 50
                                    }

                                    FluTextBox {
                                        width: 50
                                        text: "0"
                                        cleanEnabled: false

                                        background: Rectangle {
                                            color: FluColors.Transparent
                                        }

                                        validator: IntValidator {
                                            bottom: 0
                                            top: 10000
                                        }

                                    }

                                    FluMenuSeparator {
                                        width: 50
                                    }

                                    FluTextBox {
                                        width: 50
                                        text: "0"
                                        cleanEnabled: false

                                        background: Rectangle {
                                            color: FluColors.Transparent
                                        }

                                        validator: IntValidator {
                                            bottom: 0
                                            top: 10000
                                        }

                                    }

                                }

                            }

                        }

                    }

                }

            }

        }

        Rectangle {
            id: process_add_rect

            width: 10
            height: process_add_txt.height
            color: FluColors.Transparent
        }

        Rectangle {
            width: process_random_button.width
            height: parent.height
            color: FluColors.Transparent

            Column {
                anchors.verticalCenter: parent.verticalCenter
                height: process_add_button.height + process_add_random_rect.height + process_random_button.height

                FluFilledButton {
                    id: process_add_button

                    width: process_random_button.width
                    // anchors.verticalCenter: parent.verticalCenter
                    text: qsTr("Add")
                    disabled: {
                        var subitems = process_add_list.children[0].children;
                        for (var i = 2; i < subitems.length; i++) {
                            var n = subitems[i].data[0].data[0].text, m = parseInt(subitems[i].data[0].data[2].text), nd = parseInt(subitems[i].data[0].data[4].text);
                            if (isNaN(m) || isNaN(nd))
                                return true;

                            if (m !== 0 || nd !== 0)
                                return false;

                        }
                        return true;
                    }
                    onClicked: {
                        var subitems = process_add_list.children[0].children;
                        var malloced = [];
                        var need = [];
                        for (var i = 2; i < subitems.length; i++) {
                            var n = subitems[i].data[0].data[0].text, m = parseInt(subitems[i].data[0].data[2].text), nd = parseInt(subitems[i].data[0].data[4].text);
                            malloced.push(m);
                            need.push(nd);
                        }
                        var ret = CppBankAlgorithm.addProcess(malloced, need);
                        if (ret === -1) {
                            showError(qsTr("Add process failed"));
                            return ;
                        }
                        for (; i < subitems.length; i++) {
                            subitems[i].data[0].data[2].text = "0";
                            subitems[i].data[0].data[4].text = "0";
                        }
                        refresh();
                        showSuccess(qsTr("Add process successfully"));
                    }
                }

                Rectangle {
                    id: process_add_random_rect

                    width: process_random_button.width
                    height: 10
                    color: FluColors.Transparent
                }

                FluFilledButton {
                    id: process_random_button

                    text: qsTr("Random fill")
                    disabled: process_add_model.count <= 1
                    onClicked: {
                        // TO DO
                        var subitems = process_add_list.children[0].children;
                        var total = CppBankAlgorithm.getTotal();
                        var left = CppBankAlgorithm.getLeft();
                        for (var i = 2; i < subitems.length; i++) {
                            var malloced = parseInt(Math.random() * (left[i - 2] + 1));
                            var need = parseInt(Math.random() * (total[i - 2] - malloced + 1));
                            subitems[i].data[0].data[2].text = "" + malloced;
                            subitems[i].data[0].data[4].text = "" + need;
                        }
                    }
                }

            }

        }

    }

    Rectangle {
        width: parent.width
        height: 10
        color: FluColors.Transparent
    }

    Rectangle {
        Layout.alignment: Qt.AlignHCenter
        Layout.fillWidth: true
        height: 1
        radius: 1
        color: FluColors.Grey110
    }

    // Process del txt
    FluText {
        padding: 10
        font.bold: true
        text: qsTr("Delete process")
    }

    // Process del row
    Row {
        id: process_num

        property string txt: qsTr("Num of alive processes: ") + CppBankAlgorithm.getNProcess()

        function refresh() {
            txt = qsTr("Num of alive processes: ") + CppBankAlgorithm.getNProcess();
            validator.top = CppBankAlgorithm.getNProcess() - 1;
        }

        FluText {
            id: process_num_txt

            anchors.verticalCenter: parent.verticalCenter
            padding: 10
            text: process_num.txt
        }

        Rectangle {
            id: process_del_rect_m

            width: parent.parent.width - process_num_txt.width - process_del_rect_a.width - process_del_rect_b.width - process_del_input.width - process_del_txt.width - process_del_button.width - sys_status_page.ringtPad
            height: parent.height
            color: FluColors.Transparent
        }

        FluText {
            id: process_del_txt

            anchors.verticalCenter: parent.verticalCenter
            padding: 10
            text: qsTr("Process ID")
        }

        Rectangle {
            id: process_del_rect_b

            width: process_del_rect_a.width
            height: parent.height
            color: FluColors.Transparent
        }

        FluTextBox {
            id: process_del_input

            anchors.verticalCenter: parent.verticalCenter
            placeholderText: qsTr("Input the ID of the process")

            validator: IntValidator {
                id: validator

                bottom: 0
                top: CppBankAlgorithm.getNProcess() - 1
            }

        }

        Rectangle {
            id: process_del_rect_a

            width: 10
            height: parent.height
            color: FluColors.Transparent
        }

        FluFilledButton {
            id: process_del_button

            anchors.verticalCenter: parent.verticalCenter
            text: qsTr("Delete")
            disabled: process_del_input.text === ""
            onClicked: {
                var indx = parseInt(process_del_input.text);
                if (isNaN(indx)) {
                    showError(qsTr("Illegal input"));
                    return ;
                }
                var ret = CppBankAlgorithm.deleteProcess(indx);
                if (!ret) {
                    showError(qsTr("Delete process failed"));
                    return ;
                }
                sys_status_page.refresh();
                process_del_input.text = "";
                showSuccess(qsTr("Delete process successfully"));
            }
        }

    }

    Rectangle {
        width: parent.width
        height: 10
        color: FluColors.Transparent
    }

    FluText {
        topPadding: 10
        leftPadding: 10
        bottomPadding: 10
        font.bold: true
        font.pixelSize: 16
        text: qsTr("Status")
    }

    Rectangle {
        Layout.alignment: Qt.AlignHCenter
        Layout.fillWidth: true
        height: 1
        radius: 1
        color: FluColors.Grey110
    }

    Rectangle {
        width: parent.width
        height: 10
        color: FluColors.Transparent
    }

    Row {
        FluText {
            padding: 10
            font.bold: true
            text: qsTr("Alive process IDs: ")
        }

        FluText {
            id: alive_process_txt

            function refresh() {
                if (CppBankAlgorithm.getNProcess() <= 0)
                    text = qsTr("No Process");
                else
                    text = "" + CppBankAlgorithm.getProcesses();
            }

            anchors.verticalCenter: parent.verticalCenter
            text: {
                if (CppBankAlgorithm.getNProcess() <= 0)
                    return qsTr("No Process");
                else
                    return "" + CppBankAlgorithm.getProcesses();
            }
        }

    }

    Row {
        FluText {
            padding: 10
            font.bold: true
            text: qsTr("Safety Status: ")
        }

        FluText {
            id: safe_txt

            property int status

            function refresh() {
                if (CppBankAlgorithm.getNProcess() <= 0) {
                    status = -1;
                    text = qsTr("No Process");
                } else if (CppBankAlgorithm.isSafe()) {
                    status = 1;
                    text = qsTr("Safe");
                } else {
                    status = 0;
                    text = qsTr("Unsafe");
                }
            }

            anchors.verticalCenter: parent.verticalCenter
            text: {
                if (CppBankAlgorithm.getNProcess() <= 0) {
                    status = -1;
                    return qsTr("No Process");
                } else if (CppBankAlgorithm.isSafe()) {
                    status = 1;
                    return qsTr("Safe");
                } else {
                    status = 0;
                    return qsTr("Unsafe");
                }
            }
            color: {
                if (status === -1)
                    return FluColors.Grey100;

                if (status === 1)
                    return FluColors.Green.normal;

                return FluColors.Red.normal;
            }
        }

    }

    Row {
        FluText {
            padding: 10
            font.bold: true
            text: qsTr("Safe Sequence: ")
        }

        FluText {
            id: seq_txt

            property int status

            function refresh() {
                if (CppBankAlgorithm.getNProcess() <= 0) {
                    status = -1;
                    text = qsTr("Not available");
                } else if (CppBankAlgorithm.isSafe()) {
                    status = 1;
                    text = "" + CppBankAlgorithm.getSequence();
                } else {
                    status = 0;
                    text = qsTr("Not exist");
                }
            }

            anchors.verticalCenter: parent.verticalCenter
            text: {
                if (CppBankAlgorithm.getNProcess() <= 0) {
                    status = -1;
                    return qsTr("Not available");
                } else if (CppBankAlgorithm.isSafe()) {
                    status = 1;
                    return "" + CppBankAlgorithm.getSequence();
                } else {
                    status = 0;
                    return qsTr("Not exist");
                }
            }
            color: {
                if (status === -1)
                    return FluColors.Grey100;

                if (status === 1)
                    return FluColors.Green.normal;

                return FluColors.Red.normal;
            }
        }

    }

}
