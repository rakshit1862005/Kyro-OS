import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: wifiPanel
    anchors.right: parent.right
    anchors.top: parent.top
    anchors.bottom: parent.bottom
    width: 450
    color: Qt.rgba(0.1, 0.1, 0.15, 0.95)
    visible: activePanel === "wifi"
    layer.enabled: true
    layer.smooth: true

    // Focus management
    focus: visible

    Keys.onPressed: {
        if (event.key === Qt.Key_Escape) {
            root.activePanel = ""
            event.accepted = true
        }
         else if (event.key === Qt.Key_Down) {
            wifiListView.currentIndex = (wifiListView.currentIndex + 1) % wifiListView.count
            wifiListView.positionViewAtIndex(wifiListView.currentIndex, ListView.Contain)
            event.accepted = true
        }
         else if (event.key === Qt.Key_Up) {
            wifiListView.currentIndex = (wifiListView.currentIndex - 1 + wifiListView.count) % wifiListView.count
            wifiListView.positionViewAtIndex(wifiListView.currentIndex, ListView.Contain)
            event.accepted = true
        }
         else if (event.key === Qt.Key_Enter || event.key === Qt.Key_Return) {
            // Connect to selected network
            var network = wifiNetworks.get(wifiListView.currentIndex)
            root.selectedwifi[0].name = network.name
            console.log("Connect to:", network.name)
            root.activePanel = "wifidetail"
            event.accepted = true
        }
    }

    onVisibleChanged: {
        if (visible) {
            forceActiveFocus()
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 15

        RowLayout {
            Layout.fillWidth: true

            Text {
                text: "WiFi Networks"
                font.pixelSize: 28
                color: "white"
                font.bold: false
            }

            Item { Layout.fillWidth: true }

            Button {
                text: "✕"
                font.pixelSize: 24
                background: Rectangle {
                    color: parent.hovered ? Qt.rgba(1, 0.3, 0.3, 0.5) : "transparent"
                    radius: 5
                }
                contentItem: Text {
                    text: parent.text
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                onClicked: activePanel = ""
            }
        }

        Rectangle {
            Layout.fillWidth: true
            height: 2
            color: accentColors[selectedThemeIndex].accent
        }

        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            ListView {
                id: wifiListView
                model: wifiNetworks
                spacing: 10
                currentIndex: 0
                highlightFollowsCurrentItem: true
                highlightMoveDuration: 200

                delegate: Rectangle {
                    width: ListView.view.width
                    height: 80
                    radius: 10
                    color: {
                        if (model.connected) {
                            return Qt.rgba(0.2, 0.7, 0.4, 0.3)
                        } else if (ListView.isCurrentItem) {
                            return Qt.rgba(0.3, 0.5, 0.7, 0.6)
                        } else {
                            return Qt.rgba(0.2, 0.3, 0.4, 0.5)
                        }
                    }
                    border.width: ListView.isCurrentItem ? 3 : 1
                    border.color: ListView.isCurrentItem ? accentColors[selectedThemeIndex].accent : Qt.rgba(1, 1, 1, 0.3)

                    Behavior on scale {
                        NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
                    }

                    Behavior on color {
                        ColorAnimation { duration: 200 }
                    }

                    Behavior on border.width {
                        NumberAnimation { duration: 150 }
                    }

                    Behavior on border.color {
                        ColorAnimation { duration: 200 }
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: {
                            wifiListView.currentIndex = index
                        }
                        onClicked: {
                            wifiListView.currentIndex = index
                            root.selectedwifi[0].name = model.name
                            console.log("Connect to:", model.name)
                            root.activePanel = "wifidetail"
                        }
                    }

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 15
                        spacing: 15

                        Text {
                            text: "📶"
                            font.pixelSize: 28
                            color: model.signal >= 3 ? "#4CAF50" : model.signal >= 2 ? "#FFC107" : "#FF5722"
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 5

                            Text {
                                text: model.name
                                font.pixelSize: 18
                                color: "white"
                                font.bold: model.connected
                            }

                            RowLayout {
                                spacing: 10

                                Text {
                                    text: model.secured ? "🔒 Secured" : "🔓 Open"
                                    font.pixelSize: 14
                                    color: Qt.rgba(1, 1, 1, 0.7)
                                }

                                Text {
                                    visible: model.connected
                                    text: "Connected"
                                    font.pixelSize: 14
                                    color: "#4CAF50"
                                    font.bold: false

                                }
                            }
                        }

                        Text {
                            text: "›"
                            font.pixelSize: 32
                            color: ListView.isCurrentItem ? accentColors[selectedThemeIndex].accent : Qt.rgba(1, 1, 1, 0.5)
                        }
                    }
                }
            }
        }

        Text {
            Layout.fillWidth: true
            text: "Use ↑↓ to navigate, Enter to connect, Esc to close"
            font.pixelSize: 12
            color: Qt.rgba(1, 1, 1, 0.5)
            horizontalAlignment: Text.AlignHCenter
        }
    }
}
