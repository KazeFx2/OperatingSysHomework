pragma Singleton


import QtQuick 2.15
import FluentUI 1.0

FluObject {

   property var navigationView
   // property var paneItemMenu

   FluPaneItem{
        title: qsTr("Bank Algorithm")
        // menuDelegate: paneItemMenu
        icon: FluentIcons.TaskView
        url: "qrc:/qml/Pages/BankAlgorithm.qml"
        onTap: {
            navigationView.push(url)
        }
   }

    FluPaneItem{
         title: qsTr("Dynamic Partitions")
         // menuDelegate: paneItemMenu
         icon: FluentIcons.TaskView
         url: "qrc:/qml/Pages/DynamicPartitions.qml"
         onTap: {
             navigationView.push(url)
         }
    }

    FluPaneItem{
         title: qsTr("Process Schedule")
         // menuDelegate: paneItemMenu
         icon: FluentIcons.TaskView
         url: "qrc:/qml/Pages/ProcessSchedule.qml"
         onTap: {
             navigationView.push(url)
         }
    }

    FluPaneItem{
         title: qsTr("Page Swapping")
         // menuDelegate: paneItemMenu
         icon: FluentIcons.TaskView
         url: "qrc:/qml/Pages/PageSwapping.qml"
         onTap: {
             navigationView.push(url)
         }
    }

    FluPaneItem{
        title: qsTr("Disk Schedule")
        // menuDelegate: paneItemMenu
        icon: FluentIcons.TaskView
        url: "qrc:/qml/Pages/DiskSchedule.qml"
        onTap: {
            navigationView.push(url)
        }
    }
}
