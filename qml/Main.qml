import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import GaiaView

ApplicationWindow {
    id: root
    width: 900
    height: 560
    visible: true
    title: "GaiaView – Serial"

    property string logText: ""
    property bool isConnected: false

    // --- backend ---
    SerialPortManager {
        id: portManager
        onMessageReceived: (msg) => {
            logText += `${msg}`
        }
    }

    header: ToolBar {
        RowLayout {
            anchors.fill: parent
            spacing: 12
            Button { text: "Open Serial Port"; onClicked: serialPortWin.openWindow() }
            ToolSeparator {}
            Label {
                id: connectionStatus
                text: isConnected ? "Connected" : "Disconnected"
                Layout.fillWidth: true
            }
            Button { text: "Clear Log"; enabled: tabBar.currentIndex === 0 && logText.length > 0; onClicked: logText = "" }
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        TabBar {
            id: tabBar
            Layout.fillWidth: true
            TabButton { text: "Serial Monitor" }
            TabButton { text: "Second Tab" }
        }

        StackLayout {
            id: stack
            Layout.fillWidth: true
            Layout.fillHeight: true
            currentIndex: tabBar.currentIndex

            // --- Tab 0: Serial Monitor ---
            Pane {
                // This Pane is managed by StackLayout => use Layout.*
                Layout.fillWidth: true
                Layout.fillHeight: true
                padding: 8

                ColumnLayout {
                    anchors.fill: parent     // OK: ColumnLayout is NOT managed by a layout here
                    spacing: 8
                    ScrollView {
                        anchors.fill: parent
                        ScrollBar.vertical.policy: ScrollBar.AsNeeded

                        TextArea {
                            id: logArea
                            text: logText
                            readOnly: true
                            wrapMode: Text.Wrap
                            font.family: "Monospace"

                            onTextChanged: Qt.callLater(() => {
                                if (logArea.flickableItem) {
                                    logArea.flickableItem.contentY =
                                    logArea.flickableItem.contentHeight - logArea.flickableItem.height
                                }
                            })
                        }
                    }
                }
            }

            // --- Tab 1: Second Tab ---
            Item {
                // Managed by StackLayout => use Layout.*, not anchors.*
                Layout.fillWidth: true
                Layout.fillHeight: true
            }
        }
    }

    SerialPortWindow {
        id: serialPortWin
        portManager: portManager
        onConnectionSucceeded: (port, baud) => {
            isConnected = true
            connectionStatus.text = "Connected to " + port + " @ " + baud
            tabBar.currentIndex = 0
        }
    }
}
