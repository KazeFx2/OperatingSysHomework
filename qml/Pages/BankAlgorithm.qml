import QtQuick 2.15
import QtQuick.Layouts 1.15
import FluentUI 1.0

Rectangle {
    id: global_ctx

    property var src_names: []

    signal refreshsub()

    width: parent.width
    height: parent.height
    color: FluColors.Transparent

    Column {
        id: col

        height: parent.height
        width: parent.width

        FluText {
            id: title

            leftPadding: 10
            text: qsTr("Bank Algorithm")
            font.pixelSize: 28
            font.bold: true
        }

        Rectangle {
            id: pad

            width: parent.width
            height: 10
            color: FluColors.Transparent
        }

        FluArea {
            id: area

            width: parent.width - 20
            height: parent.height - title.height - bottom_control.height - pad.height
            paddings: 10
            x: 10

            FluPivot {
                id: bank_inner_menu

                width: parent.width
                height: parent.height
                headerSpacing: {
                    var tmp = bank_inner_menu.children[0].contentItem.children;
                    var widdest = 0;
                    for (var i = 0; i < tmp.length; i++) {
                        var j = tmp[i].children[0].data[0];
                        if (typeof (tmp[i].children[0].data[0]) == "undefined" || typeof (tmp[i].children[0].data[0].text) == "undefined" || tmp[i].children[0].data[0].width === 0)
                            continue;

                        if (widdest < tmp[i].children[0].data[0].width)
                            widdest = tmp[i].children[0].data[0].width;

                    }
                    if (widdest === 0)
                        return 0;

                    for (; i < tmp.length; i++) {
                        if (typeof (tmp[i].children[0].data[0]) == "undefined" || typeof (tmp[i].children[0].data[0].text) == "undefined" || tmp[i].children[0].data[0].width === 0)
                            continue;

                        if (tmp[i].children[0].data[0].width !== widdest)
                            tmp[i].children[0].data[0].leftPadding += (widdest - tmp[i].children[0].data[0].width) / 2;

                        tmp[i].children[0].data[0].bottomPadding = 10;
                        tmp[i].children[0].data[0].width = widdest;
                    }
                    var hlight = bank_inner_menu.children[0].highlight;
                    if (tmp.length < 3)
                        return 0;

                    return (bank_inner_menu.width - widdest * (tmp.length - 1)) / (tmp.length - 2);
                }
                currentIndex: 0

                FluPivotItem {
                    title: qsTr("SysStatus")

                    contentItem: FluLoader {
                        id: sys_st

                        width: parent.width
                        height: parent.height
                        source: "qrc:/qml/Pages/BankAlgorithm_SysStatus.qml"
                        onVisibleChanged: {
                            if (visible) {
                                source = "qrc:/qml/Pages/BankAlgorithm_SysStatus.qml";
                                bottom_control.refreshbuttons();
                            } else {
                                source = "";
                                bottom_control.disablebuttons();
                            }
                        }
                        onLoaded: {
                            if (visible) {
                                item.refreshbuttons.connect(bottom_control.refreshbuttons);
                                global_ctx.refreshsub.connect(item.refresh);
                            }
                        }
                    }

                }

                FluPivotItem {
                    title: qsTr("PMalloced")

                    contentItem: FluLoader {
                        width: parent.width
                        height: parent.height
                        source: "qrc:/qml/Pages/BankAlgorithm_PMalloced.qml"
                        onVisibleChanged: {
                            if (visible)
                                source = "qrc:/qml/Pages/BankAlgorithm_PMalloced.qml";
                            else
                                source = "";
                        }
                    }

                }

                FluPivotItem {
                    title: qsTr("PNeed")

                    contentItem: FluLoader {
                        width: parent.width
                        height: parent.height
                        source: "qrc:/qml/Pages/BankAlgorithm_PNeed.qml"
                        onVisibleChanged: {
                            if (visible)
                                source = "qrc:/qml/Pages/BankAlgorithm_PNeed.qml";
                            else
                                source = "";
                        }
                    }

                }

            }

        }

        Row {
            id: bottom_control

            function refreshbuttons() {
                prev.disabled = CppBankAlgorithm.isBegin();
                next.disabled = CppBankAlgorithm.isEnd();
            }

            function disablebuttons() {
                prev.disabled = true;
                next.disabled = true;
            }

            width: parent.width
            padding: 10

            FluFilledButton {
                id: prev

                text: qsTr("PrevStatus")
                disabled: bank_inner_menu.currentIndex !== 0 || CppBankAlgorithm.isBegin()
                onClicked: {
                    var ret = CppBankAlgorithm.prevStatus();
                    if (ret) {
                        global_ctx.refreshsub();
                        bottom_control.refreshbuttons();
                    }
                }
            }

            FluRectangle {
                height: prev.height
                width: (parent.width - prev.width - next.width - reset.width - parent.padding * 2) / 2
                color: FluColors.Transparent
            }

            FluFilledButton {
                id: reset

                text: qsTr("Reset")
                onClicked: {
                    CppBankAlgorithm.reset();
                    if (bank_inner_menu.currentIndex === 0)
                        global_ctx.refreshsub();

                    bank_inner_menu.currentIndex = 0;
                }
            }

            FluRectangle {
                height: prev.height
                width: (parent.width - prev.width - next.width - reset.width - parent.padding * 2) / 2
                color: FluColors.Transparent
            }

            FluFilledButton {
                id: next

                text: qsTr("NextStatus")
                disabled: bank_inner_menu.currentIndex !== 0 || CppBankAlgorithm.isEnd()
                onClicked: {
                    var ret = CppBankAlgorithm.nextStatus();
                    if (ret) {
                        global_ctx.refreshsub();
                        bottom_control.refreshbuttons();
                    }
                }
            }

        }

    }

}
