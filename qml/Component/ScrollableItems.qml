import QtQuick 2.15
import QtQuick.Layouts 1.15
import FluentUI 1.0

FluArea {
    property bool fillWidth: true
    property int topMargin: 20

    Layout.fillWidth: fillWidth
    Layout.topMargin: topMargin

    Layout.minimumHeight: 10
}
