import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import FluentUI 1.0
import QtQuick.Templates 2.15 as T
import "qrc:/src/js/tools.js" as Tools
import QFMS 1.0

FluWindow {
    id: window

    property int item_height: 32
    property int item_pad: item_height / 4

    property int selected_n: 0
    property var editorPageRegister: registerForWindowResult("/editor")
    property var loginPageRegister: registerForWindowResult("/login")
    property var aboutPageRegister: registerForWindowResult("/about")
    property var licensePageRegister: registerForWindowResult("/license")

    property string c_mod: ""

    property int create_type: 0

    property var modes: ({})

    property string search_res: ""

    property var l_model
    property var dir_get

    property string iname: ""
    property string name_del: ""

    property int chType: 1

    property string chName: ""

    property int deleteType: 1

    property string res_usr: ""

    Component.onCompleted: {
        loginPageRegister.launch({stayTop: stayTop})
    }

    title: qsTr("File Explorer")
    width: 1000
    height: 640
    minimumWidth: 650
    minimumHeight: 500
    fitsAppBarWindows: true
    launchMode: FluWindowType.SingleTask

    Component.onDestruction: {
        FMS.clean()
    }

    FluPopup {
        id: del_dialog
        property string title: qsTr("Delete File(s)")
        property string message: qsTr("Confirm delete?")
        property string neutralText: "Neutral"
        property string negativeText: qsTr("Cancel")
        property string positiveText: qsTr("Delete")
        property alias messageTextFormart: text_message.textFormat
        property int delayTime: 100
            signal
        neutralClicked
            signal
        negativeClicked
            signal
        positiveClicked
        onPositiveClicked: {
            if (deleteType === 0)
                window.deleteCurrent(name_del)
            else {
                for (var i = 0; i < l_model.count; i++) {
                    var row = l_model.get(i)
                    if (row.select === true && row.title !== "..") {
                        window.deleteCurrentNoRef(row.title)
                        row.select = false
                        l_model.set(i, row)
                    }
                }
                window.fileListRefresh()
            }
        }
        onNegativeClicked: {
        }
        property int buttonFlags: FluContentDialogType.NegativeButton | FluContentDialogType.PositiveButton
        focus: true
        implicitWidth: 400
        implicitHeight: text_title.height + sroll_message.height + layout_actions.height
        Rectangle {
            id: layout_content
            anchors.fill: parent
            color: 'transparent'
            radius: 5
            FluText {
                id: text_title
                font: FluTextStyle.Title
                text: del_dialog.title
                topPadding: 20
                leftPadding: 20
                rightPadding: 20
                wrapMode: Text.WrapAnywhere
                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right
                }
            }
            Flickable {
                id: sroll_message
                contentWidth: width
                clip: true
                anchors {
                    top: text_title.bottom
                    left: parent.left
                    right: parent.right
                }
                boundsBehavior: Flickable.StopAtBounds
                contentHeight: text_message.height
                height: Math.min(text_message.height, 300)
                ScrollBar.vertical: FluScrollBar {
                }
                FluText {
                    id: text_message
                    font: FluTextStyle.Body
                    wrapMode: Text.WrapAnywhere
                    text: del_dialog.message
                    width: parent.width
                    topPadding: 14
                    leftPadding: 20
                    rightPadding: 20
                    bottomPadding: 14
                }
            }
            Rectangle {
                id: layout_actions
                height: 68
                radius: 5
                color: FluTheme.dark ? Qt.rgba(32 / 255, 32 / 255, 32 / 255, 1) : Qt.rgba(243 / 255, 243 / 255, 243 / 255, 1)
                anchors {
                    top: sroll_message.bottom
                    left: parent.left
                    right: parent.right
                }
                RowLayout {
                    anchors {
                        centerIn: parent
                        margins: spacing
                        fill: parent
                    }
                    spacing: 15
                    FluButton {
                        id: neutral_btn
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        visible: del_dialog.buttonFlags & FluContentDialogType.NeutralButton
                        text: del_dialog.neutralText
                        onClicked: {
                            del_dialog.close()
                            timer_delay.targetFlags = FluContentDialogType.NeutralButton
                            timer_delay.restart()
                        }
                    }
                    FluButton {
                        id: negative_btn
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        visible: del_dialog.buttonFlags & FluContentDialogType.NegativeButton
                        text: del_dialog.negativeText
                        onClicked: {
                            del_dialog.close()
                            timer_delay.targetFlags = FluContentDialogType.NegativeButton
                            timer_delay.restart()
                        }
                    }
                    FluButton {
                        id: positive_btn
                        normalColor: FluColors.Red.light
                        hoverColor: FluColors.Red.normal
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        visible: del_dialog.buttonFlags & FluContentDialogType.PositiveButton
                        text: del_dialog.positiveText
                        onClicked: {
                            del_dialog.close()
                            timer_delay.targetFlags = FluContentDialogType.PositiveButton
                            timer_delay.restart()
                        }
                    }
                }
            }
        }
        Timer {
            property int targetFlags
            id: timer_delay
            interval: del_dialog.delayTime
            onTriggered: {
                if (targetFlags === FluContentDialogType.NegativeButton) {
                    del_dialog.negativeClicked()
                }
                if (targetFlags === FluContentDialogType.NeutralButton) {
                    del_dialog.neutralClicked()
                }
                if (targetFlags === FluContentDialogType.PositiveButton) {
                    del_dialog.positiveClicked()
                }
            }
        }
    }

    FluPopup {
        id: name_input
        property string title: qsTr("Input the new name")
        property string negativeText: qsTr("Cancel")
        property string positiveText: qsTr("OK")
        property int delayTime: 100
            signal
        negativeClicked
            signal
        positiveClicked
        onPositiveClicked: {
            iname = name_in.text
            var ret = FMS.Create(iname, create_type)
            switch (ret) {
                case FMST.Errors:
                    showError(Tools.format(qsTr("Create {0} failed"), create_type === FMST.Folder ? qsTr("Folder") : qsTr("File")))
                    break
                case FMST.Exists:
                    showError(Tools.format(qsTr("File/Folder '{0}' already exists!"), iname))
                    break
                case FMST.Full:
                    showError(qsTr("No free space for creator"))
                    break
                case FMST.Pass:
                    showSuccess(Tools.format(qsTr("Create {0} '{1}' successfully!"), create_type === FMST.Folder ? qsTr("Folder") : qsTr("File"), iname))
                    break
            }
            fileListRefresh()
        }
        onNegativeClicked: {
            iname = ""
        }
        property int buttonFlags: FluContentDialogType.NegativeButton | FluContentDialogType.PositiveButton
        focus: true
        implicitWidth: 400
        implicitHeight: ni_title.height + ni_actions.height + btm_m.height + name_in.height + 20
        Rectangle {
            anchors.fill: parent
            color: 'transparent'
            radius: 5
            FluText {
                id: ni_title
                font: FluTextStyle.Title
                text: name_input.title
                topPadding: 20
                leftPadding: 20
                rightPadding: 20
                wrapMode: Text.WrapAnywhere
                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right
                }
            }

            FluTextBox {
                id: name_in
                anchors.top: ni_title.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.topMargin: 20
                width: parent.width - 50
                Keys.onEnterPressed: {
                    if (!pos_btn.disabled) {
                        pos_btn.clicked()
                    }
                }
                Keys.onReturnPressed: {
                    if (!pos_btn.disabled) {
                        pos_btn.clicked()
                    }
                }
                validator: RegExpValidator {
                    regExp: /[0-9a-zA-Z._]*/
                }
            }

            Rectangle {
                id: btm_m
                anchors.top: name_in.bottom
                height: 20
                width: parent.width
                color: 'transparent'
            }

            Rectangle {
                id: ni_actions
                height: 68
                radius: 5
                color: FluTheme.dark ? Qt.rgba(32 / 255, 32 / 255, 32 / 255, 1) : Qt.rgba(243 / 255, 243 / 255, 243 / 255, 1)
                anchors {
                    top: btm_m.bottom
                    left: parent.left
                    right: parent.right
                }
                RowLayout {
                    anchors {
                        centerIn: parent
                        margins: spacing
                        fill: parent
                    }
                    spacing: 15
                    FluButton {
                        id: neg_btn
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        visible: name_input.buttonFlags & FluContentDialogType.NegativeButton
                        text: name_input.negativeText
                        onClicked: {
                            name_input.close()
                            ni_timer_delay.targetFlags = FluContentDialogType.NegativeButton
                            ni_timer_delay.restart()
                        }
                    }
                    FluFilledButton {
                        id: pos_btn
                        disabled: name_in.text == ""
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        visible: name_input.buttonFlags & FluContentDialogType.PositiveButton
                        text: name_input.positiveText
                        onClicked: {
                            name_input.close()
                            ni_timer_delay.targetFlags = FluContentDialogType.PositiveButton
                            ni_timer_delay.restart()
                        }
                    }
                }
            }
        }
        Timer {
            property int targetFlags
            id: ni_timer_delay
            interval: name_input.delayTime
            onTriggered: {
                if (targetFlags === FluContentDialogType.NegativeButton) {
                    name_input.negativeClicked()
                }
                if (targetFlags === FluContentDialogType.PositiveButton) {
                    name_input.positiveClicked()
                }
            }
        }
    }

    FluContentDialog {
        id: search_dialog
        title: qsTr("Result")
        message: search_res === "" ? qsTr("Not found") : Tools.format(qsTr("Find a file/folder: '//{0}'"), search_res.slice(5))
        negativeText: qsTr("Cancel")
        buttonFlags: FluContentDialogType.PositiveButton
        positiveText: qsTr("OK")
        onPositiveClicked: {
        }
    }

    FluPopup {
        id: mod_input
        property string title: qsTr("Input the new mode")
        property string negativeText: qsTr("Cancel")
        property string positiveText: qsTr("OK")
        property int delayTime: 100

            signal
        negativeClicked
            signal
        positiveClicked
        onPositiveClicked: {
            if (chType === 0) {
                var ret = FMS.Change(chName, parseInt(mname_in.text))
                if (ret === FMST.Pass) {
                    showSuccess(qsTr("ChangeMode successfully"))
                } else {
                    showError(qsTr("ChangeMode failed"))
                    return
                }
            } else {
                for (var i = 0; i < l_model.count; i++) {
                    var row = l_model.get(i)
                    if (row.select === true && row.title !== "..") {
                        FMS.Change(row.title, parseInt(mname_in.text))
                        row.select = false
                        l_model.set(i, row)
                    }
                }
            }
            fileListRefresh()
        }
        onNegativeClicked: {
        }
        property int buttonFlags: FluContentDialogType.NegativeButton | FluContentDialogType.PositiveButton
        focus: true
        implicitWidth: 400
        implicitHeight: mni_title.height + mni_actions.height + btm_m.height + mname_in.height + 20
        Rectangle {
            anchors.fill: parent
            color: 'transparent'
            radius: 5
            FluText {
                id: mni_title
                font: FluTextStyle.Title
                text: mod_input.title
                topPadding: 20
                leftPadding: 20
                rightPadding: 20
                wrapMode: Text.WrapAnywhere
                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right
                }
            }

            FluTextBox {
                id: mname_in
                anchors.top: mni_title.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.topMargin: 20
                width: parent.width - 50
                placeholderText: chType === 1 ? "" : Tools.format(qsTr("Current Mode: {0}"), c_mod)
                Keys.onEnterPressed: {
                    if (!mpos_btn.disabled) {
                        mpos_btn.clicked()
                    }
                }
                Keys.onReturnPressed: {
                    if (!mpos_btn.disabled) {
                        mpos_btn.clicked()
                    }
                }
                validator: RegExpValidator {
                    regExp: /[0-8][0-8][0-8]/
                }
            }

            Rectangle {
                id: mbtm_m
                anchors.top: mname_in.bottom
                height: 20
                width: parent.width
                color: 'transparent'
            }

            Rectangle {
                id: mni_actions
                height: 68
                radius: 5
                color: FluTheme.dark ? Qt.rgba(32 / 255, 32 / 255, 32 / 255, 1) : Qt.rgba(243 / 255, 243 / 255, 243 / 255, 1)
                anchors {
                    top: mbtm_m.bottom
                    left: parent.left
                    right: parent.right
                }
                RowLayout {
                    anchors {
                        centerIn: parent
                        margins: spacing
                        fill: parent
                    }
                    spacing: 15
                    FluButton {
                        id: mneg_btn
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        visible: mod_input.buttonFlags & FluContentDialogType.NegativeButton
                        text: mod_input.negativeText
                        onClicked: {
                            mod_input.close()
                            mni_timer_delay.targetFlags = FluContentDialogType.NegativeButton
                            mni_timer_delay.restart()
                        }
                    }
                    FluFilledButton {
                        id: mpos_btn
                        disabled: mname_in.text == ""
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        visible: mod_input.buttonFlags & FluContentDialogType.PositiveButton
                        text: mod_input.positiveText
                        onClicked: {
                            mod_input.close()
                            mni_timer_delay.targetFlags = FluContentDialogType.PositiveButton
                            mni_timer_delay.restart()
                        }
                    }
                }
            }
        }
        Timer {
            property int targetFlags
            id: mni_timer_delay
            interval: mod_input.delayTime
            onTriggered: {
                if (targetFlags === FluContentDialogType.NegativeButton) {
                    mod_input.negativeClicked()
                }
                if (targetFlags === FluContentDialogType.PositiveButton) {
                    mod_input.positiveClicked()
                }
            }
        }
    }

    function delay(delayTime, cb) {
        var timer = Qt.createQmlObject("import QtQuick 2.0; Timer {}", window);
        timer.interval = delayTime;
        timer.repeat = false;
        timer.triggered.connect(cb);
        timer.start();
    }

    function fileListRefresh() {
        var list_result = FMS.Ls()
        console.log(list_result.length)
        if (dir_get.items.length > 1)
            var dt = [{
                title: "..",
                type: 0,
                select: false
            }]
        else
            dt = []
        window.l_model.clear()
        // window.modes = ({})
        for (var i = 0; i < list_result.length; i++) {
            var lst = list_result[i].split('/')
            var a = lst[0]
            var b = lst[2]
            var c = lst[1]
            for (var j = 0; j < 3 - c.length; j++)
                c = "0" + c
            window.modes[a] = c
            console.log(window.modes[a])
            dt.push({
                title: a,
                type: b === "f" ? 1 : 0,
                select: false
            })
        }
        for (i = 0; i < dt.length; i++) {
            window.l_model.append(dt[i])
        }
        selected_n = 0
    }

    function editFile(name) {
        editorPageRegister.launch({stayTop: stayTop, fname: name})
    }

    function deleteFile() {
        del_dialog.open()
    }

    function nameInput() {
        name_in.text = ""
        name_input.open()
    }

    function relative2abs(name) {
        var path = "root/"
        for (var i = 0; i < dir_get.items.length; i++) {
            var t = dir_get.items[i].title + "/"
            path += t
        }
        path += name
        return path
    }

    function deleteCurrent(name) {
        deleteCurrentNoRef(name)
        fileListRefresh()
    }

    function deleteCurrentNoRef(name) {
        FMS.Delete(relative2abs(name))
    }

    Connections {
        target: window.loginPageRegister

        function onResult(data) {
            if (data.status === -1) {
                window.loginPageRegister.launch({stayTop: stayTop})
            } else {
                res_usr = data.usr
                if (res_usr != "") {
                    showSuccess(Tools.format(qsTr("Welcome, '{0}'!"), res_usr))
                    wind_loader.sourceComponent = main_win
                } else {
                    wind_loader.sourceComponent = login_need
                }
            }
        }
    }

    FluLoader {
        id: wind_loader
        sourceComponent: undefined
        anchors.fill: parent
    }

    Component {
        id: login_need
        Item {
            anchors.fill: parent
            Rectangle {
                width: childrenRect.width
                height: childrenRect.height
                anchors.centerIn: parent
                color: FluColors.Transparent
                FluText {
                    anchors.horizontalCenter: parent.horizontalCenter
                    padding: 10
                    text: qsTr("Oops! You canceled the login!")
                }
                FluFilledButton {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.children[0].bottom
                    text: qsTr("Retry")
                    onClicked: {
                        window.loginPageRegister.launch({stayTop: stayTop})
                    }
                }
            }
        }
    }

    Component {
        id: main_win
        Item {
            id: main_page

            anchors.fill: parent

            FluText {
                padding: 10
                text: qsTr("File Explorer")
            }

            Rectangle {
                y: 40
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width - 20
                height: parent.height - 50
                color: FluColors.Transparent

                Rectangle {
                    width: parent.width
                    height: childrenRect.height
                    color: FluColors.Transparent

                    FluText {
                        padding: 10
                        anchors.verticalCenter: parent.verticalCenter
                        font.bold: true
                        text: qsTr("Current Directory: ")
                        font.pixelSize: dir_url.textSize - 5
                    }

                    FluText {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.children[0].right
                        text: "/"
                        font.pixelSize: dir_url.textSize
                    }

                    FluBreadcrumbBar {
                        id: dir_url
                        anchors.left: parent.children[1].right
                        anchors.verticalCenter: parent.verticalCenter
                        width: parent.width - search_rect.width
                        separator: "/"
                        spacing: 1
                        textSize: 18
                        onClickItem: (model) => {
                            var res = []
                            //不是点击最后一个item元素
                            if (model.index + 1 !== count()) {
                                var t_path = "//"
                                for (var i = 0; i <= model.index; i++) {
                                    t_path += dir_url.items[i].title
                                    res.push({title: dir_url.items[i].title})
                                    if (i !== model.index) {
                                        t_path += "/"
                                    }
                                }
                                console.log(t_path)
                                FMS.Cd(t_path)
                                // dir_url.remove(model.index+1,count()-model.index-1)
                                dir_url.items = res
                                window.fileListRefresh()
                            }
                        }

                        Component.onCompleted: {
                            var its = [{title: res_usr}]
                            items = its
                            window.dir_get = dir_url
                        }
                    }

                    Rectangle {
                        id: search_rect
                        anchors.right: parent.right
                        width: childrenRect.width
                        height: childrenRect.height
                        color: FluColors.Transparent

                        FluText {
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            padding: 10
                            font.bold: true
                            text: qsTr("Search")
                        }

                        FluTextBox {
                            id: search_input
                            anchors.left: parent.children[0].right
                            anchors.verticalCenter: parent.verticalCenter
                            width: 250
                            validator: RegExpValidator {
                                regExp: /[0-9a-zA-Z._]*/
                            }
                        }

                        FluIconButton {
                            anchors.left: parent.children[1].right
                            anchors.leftMargin: 10
                            anchors.verticalCenter: parent.verticalCenter
                            iconSource: FluentIcons.Search
                            disabled: search_input.text == ""
                            onClicked: {
                                var ret = FMS.Search(search_input.text)
                                search_res = ret
                                search_dialog.open()
                                console.log(ret)
                            }
                        }
                    }
                }

                Rectangle {
                    height: parent.height - parent.children[0].height
                    width: parent.width
                    anchors.top: parent.children[0].bottom
                    color: FluColors.Transparent

                    FluText {
                        font.bold: true
                        padding: 10
                        text: qsTr("Current User:")
                    }

                    FluText {
                        id: usr_name
                        anchors.left: parent.children[0].right
                        padding: 10
                        text: res_usr
                    }

                    FluArea {
                        id: left_filetree
                        topPadding: 10
                        bottomPadding: topPadding
                        property int pad_inner: 8
                        property int minW: 52 + pad_inner * 2
                        anchors.left: parent.left
                        anchors.top: parent.children[0].bottom
                        width: parent.width > 900 ? parent.width * 1 / 5 : minW
                        height: parent.height - parent.children[0].height
                        // color: FluColors.Transparent
                        Behavior on width {
                            NumberAnimation {
                                duration: 250
                            }
                        }

                        FluText {
                            leftPadding: 10
                            visible: parent.width > left_filetree.minW
                            text: qsTr("Tool box")
                            font.pixelSize: 15
                            font.bold: true
                            height: visible ? padding * 2 + font.pixelSize : 0
                            Behavior on height {
                                NumberAnimation {
                                    duration: 250
                                }
                            }
                        }

                        Flickable {
                            // policy: T.ScrollBar.AsNeeded
                            boundsBehavior: Flickable.StopAtBounds
                            contentWidth: parent.width
                            contentHeight: cont.height
                            clip: true
                            ScrollBar.vertical: FluScrollBar {
                                anchors.right: parent.right
                                anchors.rightMargin: 2 - left_filetree.paddings
                            }
                            anchors {
                                top: parent.children[0].bottom
                                topMargin: 10
                                left: parent.left
                                right: parent.right
                                bottom: parent.bottom
                            }

                            ListView {
                                id: cont
                                width: parent.width - 2 * left_filetree.pad_inner
                                anchors.horizontalCenter: parent.horizontalCenter
                                height: childrenRect.height
                                // implicitHeight: parent.height
                                orientation: ListView.Vertical
                                spacing: 5

                                model: ListModel {
                                    id: left_filetree_model

                                }

                                delegate: Rectangle {
                                    property bool _dis: {
                                        switch (index) {
                                            case 3:
                                                return true // window.selected_n !== 1
                                            case 4:
                                            case 7:
                                                return window.selected_n === 0
                                            default:
                                                break
                                        }
                                        return dis
                                    }
                                    width: type !== 1 ? parent.width - 20 : parent.width - 10
                                    height: type !== 1 ? window.item_height : 2
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    radius: 5
                                    border.color: FluTools.colorAlpha(FluColors.Grey110, 0.5)
                                    border.width: type === 0 ? 1 : 0
                                    color: type === 0 ? _dis ? FluColors.Transparent : (children[3].hover ? (children[3].clicked ? FluColors.Grey110 : FluTools.colorAlpha(FluColors.Grey110, 0.5)) : FluColors.Transparent) : type === 1 ? border.color : FluColors.Transparent
                                    opacity: type === 0 ? _dis ? 0.5 : 1.0 : 1.0
                                    clip: type !== 2

                                    FluIcon {
                                        anchors.verticalCenter: parent.verticalCenter
                                        visible: type !== 1 && icon != ""
                                        padding: window.item_pad
                                        iconSize: window.item_height - padding * 2
                                        iconSource: type !== 1 ? icon : FluentIcons.AppIconDefault
                                        iconColor: (icon != "" && icon === FluentIcons.Delete) ? FluColors.Red.light : FluTheme.dark ? "#FFFFFF" : "#000000"
                                    }

                                    FluText {
                                        visible: type !== 1 && parent.width > left_filetree.minW
                                        anchors.left: icon != "" ? parent.children[0].right : parent.left
                                        anchors.verticalCenter: parent.verticalCenter
                                        text: title
                                        font.pixelSize: parent.children[0].iconSize - 2
                                        textColor: (icon != "" && icon === FluentIcons.Delete) ? FluColors.Red.light : FluTheme.dark ? "#FFFFFF" : "#000000"
                                    }

                                    Rectangle {
                                        visible: type === 2
                                        anchors.top: parent.children[1].bottom
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        anchors.topMargin: 5
                                        height: 2
                                        width: parent.width + 10
                                        color: parent.border.color
                                        radius: 2
                                    }

                                    MouseArea {
                                        enabled: type !== 1
                                        width: parent.width
                                        height: parent.height
                                        hoverEnabled: true
                                        property bool clicked: false
                                        property bool hover: false
                                        onHoveredChanged: {
                                            hover = !hover
                                            if (!hover)
                                                clicked = false
                                        }
                                        onPressed: (Mouse) => {
                                            if (Mouse.button === Qt.LeftButton) {
                                                clicked = true
                                            }
                                        }
                                        onReleased: (Mouse) => {
                                            if (Mouse.button === Qt.LeftButton) {
                                                clicked = false
                                            }
                                        }
                                        onClicked: {
                                            if (!_dis) {
                                                func(index, title, type)
                                            }
                                        }

                                        function func(index, title, type) {
                                            // showInfo(index + "_" + title + "_" + type)
                                            switch (index) {
                                                case 3:
                                                case 5: // Folder
                                                {
                                                    window.create_type = FMST.Folder
                                                    window.nameInput()
                                                }
                                                    break
                                                case 6: // File
                                                {
                                                    window.create_type = FMST.File
                                                    window.nameInput()
                                                }
                                                    break
                                                case 7:
                                                    chType = 1
                                                    chName = ""
                                                    mname_in.text = ""
                                                    mod_input.open()
                                                    break
                                                case 4: { // Delete
                                                    window.deleteType = 1
                                                    name_del = ""
                                                    window.deleteFile()
                                                }
                                                    break
                                                case 9: {
                                                    for (var i = 0; i < right_files_model.count; i++) {
                                                        var tmp = right_files_model.get(i)
                                                        if (tmp.title === "..")
                                                            continue
                                                        tmp.select = true
                                                        right_files_model.set(i, tmp)
                                                    }
                                                }
                                                    break
                                                case 10: {
                                                    for (i = 0; i < right_files_model.count; i++) {
                                                        tmp = right_files_model.get(i)
                                                        if (tmp.title === "..")
                                                            continue
                                                        tmp.select = false
                                                        right_files_model.set(i, tmp)
                                                    }
                                                }
                                                    break
                                                case 11: {
                                                    for (i = 0; i < right_files_model.count; i++) {
                                                        tmp = right_files_model.get(i)
                                                        if (tmp.title === "..")
                                                            continue
                                                        tmp.select = !tmp.select
                                                        right_files_model.set(i, tmp)
                                                    }
                                                }
                                                    break
                                                case 13:
                                                    FMS.Cd("//" + res_usr)
                                                    dir_get.items = [{title: res_usr}]
                                                    window.fileListRefresh()
                                                    break
                                                default:
                                                    break
                                            }
                                        }
                                    }

                                    FluTooltip {
                                        parent: parent.handle
                                        visible: parent.children[3].hover && !parent.children[1].visible
                                        text: String(title)
                                    }
                                }

                                Component.onCompleted: {
                                    var dt = [{
                                        icon: FluentIcons.DeveloperTools,
                                        title: qsTr("Quick Operations"),
                                        type: 2,
                                        dis: true
                                    },
                                        {
                                            icon: FluentIcons.Copy,
                                            title: qsTr("Copy"),
                                            type: 0,
                                            dis: true
                                        },
                                        {
                                            icon: FluentIcons.Paste,
                                            title: qsTr("Paste"),
                                            type: 0,
                                            dis: true
                                        },
                                        {
                                            icon: FluentIcons.Rename,
                                            title: qsTr("Rename"),
                                            type: 0,
                                            dis: true
                                        },
                                        {
                                            icon: FluentIcons.Delete,
                                            title: qsTr("Delete"),
                                            type: 0,
                                            dis: true
                                        },
                                        {
                                            icon: FluentIcons.NewFolder,
                                            title: qsTr("NewFolder"),
                                            type: 0,
                                            dis: false
                                        },
                                        {
                                            icon: FluentIcons.Add,
                                            title: qsTr("NewFile"),
                                            type: 0,
                                            dis: false
                                        },
                                        {
                                            icon: FluentIcons.Edit,
                                            title: qsTr("ChangeMode"),
                                            type: 0,
                                            dis: true
                                        },
                                        {
                                            icon: "",
                                            title: "",
                                            type: 1,
                                            dis: true
                                        },
                                        {
                                            icon: FluentIcons.SelectAll,
                                            title: qsTr("SelectAll"),
                                            type: 0,
                                            dis: false
                                        },
                                        {
                                            icon: FluentIcons.ClearSelection,
                                            title: qsTr("UnselectAll"),
                                            type: 0,
                                            dis: false
                                        },
                                        {
                                            icon: FluentIcons.Switch,
                                            title: qsTr("Inverse"),
                                            type: 0,
                                            dis: false
                                        },
                                        {
                                            icon: "",
                                            title: "",
                                            type: 1,
                                            dis: true
                                        },
                                        {
                                            icon: FluentIcons.Folder,
                                            title: res_usr,
                                            type: 0,
                                            dis: false
                                        }]
                                    for (var i = 0; i < dt.length; i++) {
                                        left_filetree_model.append(dt[i])
                                    }
                                }
                            }
                        }
                    }

                    Rectangle {
                        id: right_files
                        anchors.top: parent.children[0].bottom
                        anchors.right: parent.right
                        anchors.left: left_filetree.right
                        anchors.leftMargin: 10
                        height: parent.height - parent.children[0].height
                        color: FluColors.Transparent

                        FluArea {
                            width: parent.width
                            height: parent.height

                            Rectangle {
                                height: 10
                                width: parent.width
                                color: FluColors.Transparent
                            }

                            Flickable {
                                // policy: T.ScrollBar.AsNeeded
                                boundsBehavior: Flickable.StopAtBounds
                                contentWidth: parent.width
                                contentHeight: cont_r.height
                                clip: true
                                ScrollBar.vertical: FluScrollBar {
                                    anchors.right: parent.right
                                    anchors.rightMargin: 2
                                }
                                anchors {
                                    top: parent.children[0].bottom
                                    left: parent.left
                                    right: parent.right
                                    bottom: parent.children[2].top
                                }

                                FluMenu {
                                    id: menu
                                    property bool noAct: false
                                    property int type: -1
                                    property string name: ""
                                    property bool select: false
                                    property int index: -1
                                    FluMenuItem {
                                        text: qsTr("Open")
                                        enabled: true
                                        iconSource: FluentIcons.OpenFile
                                        iconSpacing: window.item_pad
                                        opacity: enabled ? 1.0 : 0.5
                                        onTriggered: {
                                            if (menu.type === 1) {
                                                var ret = FMS.Open("//" + window.relative2abs(menu.name).slice(5))
                                                if (ret === FMST.Errors) {
                                                    showError(Tools.format(qsTr("Open file '{0}' failed"), menu.name))
                                                    return
                                                } else {
                                                    window.editFile(menu.name)
                                                }
                                            } else {
                                                console.log("//" + window.relative2abs(menu.name).slice(5))
                                                ret = FMS.Cd("//" + window.relative2abs(menu.name).slice(5))
                                                if (ret === FMST.Pass) {
                                                    console.log("pass")
                                                    var dt = dir_url.items
                                                    if (menu.name !== "..")
                                                        dt.push({title: menu.name})
                                                    else
                                                        dt.pop()
                                                    dir_url.items = dt
                                                }
                                                console.log(ret)
                                                window.fileListRefresh()
                                            }
                                        }
                                    }
                                    FluMenuItem {
                                        text: qsTr("Copy")
                                        enabled: false
                                        iconSource: FluentIcons.Copy
                                        iconSpacing: window.item_pad
                                        opacity: enabled ? 1.0 : 0.5
                                        onTriggered: {
                                        }
                                    }
                                    FluMenuItem {
                                        text: qsTr("Paste")
                                        enabled: false
                                        iconSource: FluentIcons.Paste
                                        iconSpacing: window.item_pad
                                        opacity: enabled ? 1.0 : 0.5
                                        onTriggered: {
                                        }
                                    }
                                    FluMenuItem {
                                        text: qsTr("Rename")
                                        enabled: false // menu.name == ".." ? false : true
                                        iconSource: FluentIcons.Rename
                                        iconSpacing: window.item_pad
                                        opacity: enabled ? 1.0 : 0.5
                                        onTriggered: {
                                            window.nameInput()
                                        }
                                    }
                                    FluMenuItem {
                                        text: qsTr("ChangeMode")
                                        enabled: menu.name == ".." ? false : true
                                        iconSource: FluentIcons.Edit
                                        iconSpacing: window.item_pad
                                        opacity: enabled ? 1.0 : 0.5
                                        onTriggered: {
                                            chType = 0
                                            chName = menu.name
                                            c_mod = window.modes[chName]
                                            mname_in.text = ""
                                            mod_input.open()
                                        }
                                    }
                                    FluMenuSeparator {
                                    }
                                    Action {
                                        text: qsTr("Select")
                                        enabled: menu.name == ".." ? false : true
                                        checkable: true
                                        checked: menu.select
                                        onCheckedChanged: {
                                            if (menu.noAct)
                                                return
                                            var item = right_files_model.get(menu.index)
                                            item.select = checked
                                            menu.select = checked
                                            right_files_model.set(menu.index, item)
                                        }
                                    }
                                    FluMenuSeparator {
                                    }
                                    T.MenuItem {
                                        property int iconSpacing: window.item_pad
                                        property int iconSource: FluentIcons.Delete
                                        property int iconSize: 16
                                        property color textColor: FluColors.Red.light

                                        text: qsTr("Delete")
                                        enabled: menu.name == ".." ? false : true
                                        opacity: enabled ? 1.0 : 0.5
                                        id: control
                                        implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                                            implicitContentWidth + leftPadding + rightPadding)
                                        implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                                            implicitContentHeight + topPadding + bottomPadding,
                                            implicitIndicatorHeight + topPadding + bottomPadding)
                                        padding: 6
                                        spacing: 6
                                        icon.width: 24
                                        icon.height: 24
                                        icon.color: control.palette.windowText
                                        height: visible ? implicitHeight : 0

                                        onTriggered: {
                                            window.deleteType = 0
                                            window.name_del = menu.name
                                            window.deleteFile()
                                        }
                                        Component {
                                            id: com_icon
                                            FluIcon {
                                                id: content_icon
                                                iconSize: control.iconSize
                                                iconSource: control.iconSource
                                                color: FluColors.Red.light
                                            }
                                        }
                                        contentItem: Item {
                                            Row {
                                                spacing: control.iconSpacing
                                                readonly property real arrowPadding: control.subMenu && control.arrow ? control.arrow.width + control.spacing : 0
                                                readonly property real indicatorPadding: control.checkable && control.indicator ? control.indicator.width + control.spacing : 0
                                                anchors {
                                                    verticalCenter: parent.verticalCenter
                                                    left: parent.left
                                                    leftMargin: (!control.mirrored ? indicatorPadding : arrowPadding) + 5
                                                    right: parent.right
                                                    rightMargin: (control.mirrored ? indicatorPadding : arrowPadding) + 5
                                                }
                                                FluLoader {
                                                    id: loader_icon
                                                    sourceComponent: com_icon
                                                    anchors.verticalCenter: parent.verticalCenter
                                                    visible: status === Loader.Ready
                                                }
                                                FluText {
                                                    id: content_text
                                                    text: control.text
                                                    color: control.textColor
                                                    anchors.verticalCenter: parent.verticalCenter
                                                }
                                            }
                                        }
                                        indicator: FluIcon {
                                            x: control.mirrored ? control.width - width - control.rightPadding : control.leftPadding
                                            y: control.topPadding + (control.availableHeight - height) / 2
                                            visible: control.checked
                                            iconSource: FluentIcons.CheckMark
                                        }
                                        arrow: FluIcon {
                                            x: control.mirrored ? control.leftPadding : control.width - width - control.rightPadding
                                            y: control.topPadding + (control.availableHeight - height) / 2
                                            visible: control.subMenu
                                            iconSource: FluentIcons.ChevronRightMed
                                        }
                                        background: Item {
                                            implicitWidth: 150
                                            implicitHeight: 36
                                            x: 1
                                            y: 1
                                            width: control.width - 2
                                            height: control.height - 2
                                            Rectangle {
                                                anchors.fill: parent
                                                anchors.margins: 3
                                                radius: 4
                                                color: {
                                                    if (control.highlighted) {
                                                        return FluTheme.itemCheckColor
                                                    }
                                                    return FluTheme.itemNormalColor
                                                }
                                            }
                                        }
                                    }
                                }

                                ListView {
                                    id: cont_r
                                    width: parent.width
                                    height: childrenRect.height
                                    // implicitHeight: parent.height
                                    orientation: ListView.Vertical
                                    spacing: 5

                                    model: ListModel {
                                        id: right_files_model

                                    }

                                    delegate: Rectangle {
                                        width: parent.width - 30
                                        height: window.item_height
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        radius: 5
                                        border.color: FluTools.colorAlpha(FluColors.Grey110, 0.5)
                                        border.width: 1
                                        color: children[3].hover ? (children[3].clicked ? FluColors.Grey110 : FluTools.colorAlpha(FluColors.Grey110, 0.5)) : FluColors.Transparent
                                        clip: true

                                        FluCheckBox {
                                            anchors {
                                                top: parent.top
                                                verticalCenter: parent.verticalCenter
                                            }
                                            leftPadding: select ? window.item_pad : -18
                                            checked: select
                                            visible: select
                                            disabled: !select
                                            // size: select ? 18 : 0
                                            onCheckedChanged: {
                                                if (!checked) {
                                                    select = false
                                                }
                                                if (checked) {
                                                    window.selected_n++
                                                } else {
                                                    window.selected_n--
                                                }
                                            }
                                            onVisibleChanged: {
                                                checked = select
                                            }
                                            Behavior on leftPadding {
                                                NumberAnimation {
                                                    duration: 250
                                                }
                                            }
                                        }

                                        FluIcon {
                                            anchors.verticalCenter: parent.verticalCenter
                                            anchors.left: parent.children[0].right
                                            padding: window.item_pad
                                            iconSize: window.item_height - padding * 2
                                            iconSource: type === 0 ? FluentIcons.Folder : FluentIcons.Document
                                        }

                                        FluText {
                                            anchors.left: parent.children[1].right
                                            anchors.verticalCenter: parent.verticalCenter
                                            text: title
                                            font.pixelSize: parent.children[1].iconSize - 2
                                        }

                                        MouseArea {
                                            property int doubleclickct: 0
                                            anchors.left: parent.children[0].right
                                            width: parent.width - parent.children[0].width
                                            height: parent.height
                                            hoverEnabled: true
                                            acceptedButtons: Qt.LeftButton | Qt.RightButton
                                            property bool clicked: false
                                            property bool hover: false
                                            onHoveredChanged: {
                                                hover = !hover
                                                if (!hover)
                                                    clicked = false
                                            }
                                            onPressed: (Mouse) => {
                                                if (Mouse.button === Qt.LeftButton) {
                                                    clicked = true
                                                }
                                            }
                                            onReleased: (Mouse) => {
                                                if (Mouse.button === Qt.LeftButton) {
                                                    clicked = false
                                                }
                                            }

                                            function sg_clk() {
                                                if (doubleclickct == 0) {
                                                    select = !select
                                                } else {
                                                    doubleclickct--
                                                }
                                            }

                                            onClicked: (Mouse) => {
                                                if (Mouse.button === Qt.RightButton) {
                                                    menu.noAct = true
                                                    menu.type = type
                                                    menu.name = title
                                                    menu.select = select
                                                    menu.index = index
                                                    menu.noAct = false
                                                    menu.popup()
                                                } else if (Mouse.button === Qt.LeftButton) {
                                                    // select = !select
                                                    if (title == "..")
                                                        return
                                                    delay(200, sg_clk)
                                                }
                                            }
                                            onDoubleClicked: (Mouse) => {
                                                if (Mouse.button === Qt.LeftButton) {
                                                    doubleclickct++
                                                    // showInfo(title)
                                                    if (type === 1) {
                                                        var ret = FMS.Open("//" + window.relative2abs(title).slice(5))
                                                        if (ret === FMST.Errors) {
                                                            showError(Tools.format(qsTr("Open file '{0}' failed"), title))
                                                            return
                                                        } else {
                                                            window.editFile(title)
                                                        }
                                                    } else {
                                                        console.log("//" + window.relative2abs(title).slice(5))
                                                        ret = FMS.Cd("//" + window.relative2abs(title).slice(5))
                                                        if (ret === FMST.Pass) {
                                                            console.log("pass")
                                                            var dt = dir_url.items
                                                            if (title !== "..")
                                                                dt.push({title: title})
                                                            else
                                                                dt.pop()
                                                            dir_url.items = dt
                                                        }
                                                        console.log(ret)
                                                        window.fileListRefresh()
                                                    }
                                                }
                                            }
                                        }
                                    }

                                    Component.onCompleted: {
                                        window.l_model = right_files_model
                                        window.fileListRefresh()
                                    }
                                }
                            }

                            Rectangle {
                                height: 10
                                width: parent.width
                                anchors.bottom: parent.bottom
                                color: FluColors.Transparent
                            }
                        }
                    }
                }
            }
        }
    }

    appBar: FluAppBar {
        id: app_bar

        darkText: qsTr("SwitchTheme")
        showDark: true
        darkClickListener: (button) => {
            if (FluTheme.dark)
                FluTheme.darkMode = FluThemeType.Light;
            else
                FluTheme.darkMode = FluThemeType.Dark;
        }
        closeClickListener: () => {
            FluApp.exit(0);
        }
        z: 0

        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }

        FluMenuBar {
            // visible: wind_loader.sourceComponent === main_win
            id: head_menu
            padding: 5
            x: wind_loader.sourceComponent === main_win ? 80 : 0

            Behavior on x {
                NumberAnimation {
                    duration: 250
                }
            }

            FluMenu {
                id: about
                title: qsTr("About")
                Action {
                    text: qsTr("This Project...")
                    onTriggered: {
                        window.aboutPageRegister.launch({stayTop: stayTop})
                    }
                }
                Action {
                    text: qsTr("Open Source Licenses")
                    onTriggered: {
                        window.licensePageRegister.launch({stayTop: stayTop})
                    }
                }
            }
        }
    }
}
