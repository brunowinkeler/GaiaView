import QtQuick
import QtQuick.Controls
import QtQuick.Window
import GaiaView

Window {
    id: serialWindow
    width: 360
    height: 280
    visible: false
    title: "Open Serial Port"
    modality: Qt.ApplicationModal
    flags: Qt.Dialog | Qt.WindowTitleHint | Qt.WindowCloseButtonHint

    // Inject an external manager (optional). If none is provided, use an internal one.
    property SerialPortManager portManager: null
    SerialPortManager { id: internalManager }

    // Use whichever is available
    property SerialPortManager mgr: portManager ? portManager : internalManager

    // Public API
    property alias selectedPort: portCombo.currentText
    property int baudRate: parseInt(baudCombo.currentText)
    signal connectionSucceeded(string port, int baud)

    function openWindow() {
        visible = true;
        raise();
        requestActivate();
        // refresh each time the window is shown
        mgr.refreshPorts();
    }
    function closeWindow() { close(); }

    // React to the chosen manager signals
    Connections {
        target: mgr
        function onPortsChanged() {
            portCombo.model = mgr.availablePorts
        }
        function onPortOpened(success, error) {
            if (success) {
                connectionSucceeded(portCombo.currentText, baudRate)
                serialWindow.close()
            } else {
                errorLabel.text = error
            }
        }
    }

    Column {
        spacing: 16
        anchors {
            fill: parent
            leftMargin: 20; rightMargin: 20
            topMargin: 20; bottomMargin: 20
        }

        ComboBox {
            id: portCombo
            model: mgr.availablePorts
            width: 220
        }

        ComboBox {
            id: baudCombo
            model: [9600, 19200, 38400, 57600, 115200]
            currentIndex: 4
            width: 220
        }

        Row {
            spacing: 8
            Button {
                text: "Open"
                onClicked: mgr.openPort(portCombo.currentText, parseInt(baudCombo.currentText))
            }
            Button {
                text: "Refresh"
                onClicked: mgr.refreshPorts()
            }
            Button {
                text: "Close"
                onClicked: serialWindow.close()
            }
        }

        Label {
            id: errorLabel
            color: "red"
            wrapMode: Text.WordWrap
            width: parent.width
        }
    }

    Component.onCompleted: mgr.refreshPorts()
}
