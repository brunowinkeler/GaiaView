import QtQuick
import QtQuick.Controls
import GaiaView

Dialog {
    id: serialDialog
    modal: true
    title: "Open Serial Port"

    property alias selectedPort: portCombo.currentText

    SerialPortManager {
        id: portManager
        onPortsChanged: portCombo.model = availablePorts
        onPortOpened: (success, error) => {
            if (success) {
                serialDialog.close();
            } else {
                errorLabel.text = error;
            }
        }
    }

    Column {
        spacing: 16
        ComboBox {
            id: portCombo
            model: portManager.availablePorts
            width: 200
        }
        ComboBox {
            id: baudCombo
            model: [9600, 19200, 38400, 57600, 115200]
            currentIndex: 4
            width: 200
        }
        Button {
            text: "Open"
            onClicked: portManager.openPort(portCombo.currentText, baudCombo.currentText)
        }
        Label {
            id: errorLabel
            color: "red"
        }
        Button {
            text: "Refresh"
            onClicked: portManager.refreshPorts()
        }
    }
    Component.onCompleted: portManager.refreshPorts()
}
