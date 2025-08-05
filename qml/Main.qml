import QtQuick
import QtQuick.Controls
import GaiaView

ApplicationWindow {
    visible: true
    width: 640
    height: 480
    title: "GaiaView"

    menuBar: MenuBar {
        Menu {
            title: "Connection"
            Action {
                text: "Open Serial Port"
                onTriggered: serialDialog.open()
            }
        }
    }

    SerialPortDialog {
        id: serialDialog
    }
}
