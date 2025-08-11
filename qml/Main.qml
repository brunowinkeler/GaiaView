import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import GaiaView

ApplicationWindow {
    id: root
    width: 800
    height: 520
    visible: true
    title: "GaiaView – Serial Monitor"

    property string logText: ""
    property string currentPort: ""
    property int currentBaud: 115200

    // Shared manager
    SerialPortManager {
        id: portManager
        onMessageReceived: (msg) => {
            logText += `${msg}`;
        }
    }

    header: ToolBar {
        RowLayout {
            anchors.fill: parent
            spacing: 12
            Button {
                text: "Open Serial Port"
                onClicked: serialPortWin.openWindow()
            }
            ToolSeparator {}
            Label {
                id: connectionStatus
                text: "Disconnected"
                Layout.fillWidth: true
            }
            Button {
                text: "Clear Log"
                enabled: serialMonitor.visible && logText.length > 0
                onClicked: logText = ""
            }
        }
    }

    Frame {
        id: serialMonitor
        visible: false
        anchors.fill: parent
        anchors.margins: 8
        ColumnLayout {
            anchors.fill: parent
            spacing: 8
            TextArea {
                id: logArea
                text: logText
                readOnly: true
                wrapMode: Text.Wrap
                font.family: "Monospace"
                Layout.fillWidth: true
                Layout.fillHeight: true
                onTextChanged: Qt.callLater(() => {
                    flickableItem.contentY = flickableItem.contentHeight - flickableItem.height
                })
            }
        }
    }

    SerialPortWindow {
        id: serialPortWin
        portManager: portManager
        onConnectionSucceeded: (port, baud) => {
            currentPort = port
            currentBaud = baud
            connectionStatus.text = "Connected to " + port + " @ " + baud
            serialMonitor.visible = true
        }
    }
}
