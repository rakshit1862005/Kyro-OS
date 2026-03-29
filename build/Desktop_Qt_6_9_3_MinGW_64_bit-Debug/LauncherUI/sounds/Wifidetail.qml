import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: wifiDetailPanel
    anchors.right: parent.right
    anchors.top: parent.top
    anchors.bottom: parent.bottom
    width: 450
    color: Qt.rgba(0.1, 0.1, 0.15, 0.95)
    visible: activePanel === "wifidetail"
    layer.enabled: true
    layer.smooth: true

    onVisibleChanged: {
        if (visible) {
            Qt.callLater(function() {
                wifiNameText.text = root.selectedwifi[0].name
                passwordField.forceActiveFocus()
            })
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 15

        // Header row
        RowLayout {
            Layout.fillWidth: true

            Text {
                text: "Connect to"
                font.pixelSize: 28
                color: "white"
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
                onClicked: activePanel = "wifi"
            }
        }

        Rectangle {
            Layout.fillWidth: true
            height: 2
            color: accentColors[selectedThemeIndex].accent
        }

        // WiFi name - directly in main layout (no nested ColumnLayout)
        Text {
            id: wifiNameText
            text: root.selectedwifi[0].name
            font.pixelSize: 26
            color: "white"
            Layout.topMargin: 10  // Small margin from divider
        }

        TextField {
            id: passwordField
            placeholderText: "Enter WiFi password"
            echoMode: TextInput.Password
            Layout.fillWidth: true
            Layout.preferredHeight: 40
            color: "white"
            font.pixelSize: 16
            leftPadding: 15
            rightPadding: 15
            verticalAlignment: TextInput.AlignVCenter

            background: Rectangle {
                color: Qt.rgba(0.3, 0.3, 0.4, 0.5)
                radius: 15
            }

            Keys.onPressed: {
                if (event.key === Qt.Key_Escape) {
                    activePanel = "wifi"
                    event.accepted = true
                }
            }
        }

        Button {
            text: "Connect"
            Layout.fillWidth: true
            Layout.preferredHeight: 40

            background: Rectangle {
                color: accentColors[selectedThemeIndex].accent
                radius: 15
            }

            contentItem: Text {
                text: parent.text
                color: "white"
                font.pixelSize: 18
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            onClicked: {
                console.log("Connecting to", root.selectedwifi[0].name, "with password:", passwordField.text)
                activePanel = "wifi"
            }
        }

        // Spacer to push everything to the top
        Item {
            Layout.fillHeight: true
        }
    }
}
