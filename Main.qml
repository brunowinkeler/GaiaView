import QtQuick
import QtQuick.Controls
import QtQuick.Window

ApplicationWindow {
    id: window
    width: 320
    height: 260
    visible: true

    menuBar: MenuBar {
        Menu {
            title: qsTr("&File")
            Action { text: qsTr("&New Connection...") }
            Action { text: qsTr("Set Schema JSON...") }
            MenuSeparator { }
            Action { text: qsTr("&Quit") }
        }
        Menu {
            title: qsTr("&Edit")
            Action { text: qsTr("&Change Connection...") }
        }
        Menu {
            title: qsTr("&Help")
            Action { text: qsTr("&About") }
        }
    }

}
