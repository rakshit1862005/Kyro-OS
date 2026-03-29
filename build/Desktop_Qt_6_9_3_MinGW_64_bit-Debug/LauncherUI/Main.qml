import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import Qt.labs.settings 1.1

Window {
    Settings {
        id: themeSettings
        property int savedThemeIndex: 0  // default theme
    }

    id: root
    visible: true
    title: "KyroOS Launcher"
    color: "black"
    visibility: Window.FullScreen


    // Track which GridView has focus (0 = main, 1 = secondary, 2 = bottom)
    property int focusedGrid: 0
    property bool startupComplete: false

    // Active panel state (null, "wifi", "customization")
    property string activePanel: ""

    // Theme customization
    property var accentColors: [
        { name: "Default Purple", primary: "#1a0a2e", secondary: "#2d1b3d", accent: "#db5a63" },
        { name: "Ocean Blue", primary: "#0a1e2e", secondary: "#1b2d3d", accent: "#63b5db" },
        { name: "Forest Green", primary: "#0a2e1e", secondary: "#1b3d2d", accent: "#63db7d" },
        { name: "Sunset Orange", primary: "#2e1e0a", secondary: "#3d2d1b", accent: "#db9563" },
        { name: "Rose Pink", primary: "#2e0a1e", secondary: "#3d1b2d", accent: "#db63b5" },
        { name: "Electric Cyan", primary: "#0a2e2e", secondary: "#1b3d3d", accent: "#63dbdb" },
        { name: "Crimson Night", primary: "#2e0a0a", secondary: "#3d1b1b", accent: "#ff4757" },
        { name: "Royal Gold", primary: "#2e1e0a", secondary: "#3d2d1b", accent: "#ffd700" },
        { name: "Neon Magenta", primary: "#2e0a2e", secondary: "#3d1b3d", accent: "#ff00ff" },
        { name: "Arctic Blue", primary: "#0a1a2e", secondary: "#1b2a3d", accent: "#5dade2" },
        { name: "Lime Blast", primary: "#1a2e0a", secondary: "#2a3d1b", accent: "#7bed9f" },
        { name: "Midnight Indigo", primary: "#0a0a2e", secondary: "#1b1b3d", accent: "#a29bfe" },
        { name: "Coral Reef", primary: "#2e1a0a", secondary: "#3d2a1b", accent: "#ff6b6b" },
        { name: "Mint Fresh", primary: "#0a2e1a", secondary: "#1b3d2a", accent: "#2ed573" },
        { name: "Violet Storm", primary: "#1a0a2e", secondary: "#2a1b3d", accent: "#b39ddb" },
        { name: "Amber Glow", primary: "#2e220a", secondary: "#3d321b", accent: "#ffa502" },
        { name: "Teal Wave", primary: "#0a2e2e", secondary: "#1b3d3d", accent: "#1dd1a1" },
        { name: "Ruby Red", primary: "#2e0a14", secondary: "#3d1b24", accent: "#e74c3c" },
        { name: "Sapphire Blue", primary: "#0a142e", secondary: "#1b243d", accent: "#3498db" },
        { name: "Emerald Dream", primary: "#0a2e14", secondary: "#1b3d24", accent: "#27ae60" },
        { name: "Lavender Haze", primary: "#1e0a2e", secondary: "#2e1b3d", accent: "#c39bd3" },
        { name: "Peach Sunset", primary: "#2e1a0a", secondary: "#3d2a1b", accent: "#fab1a0" },
        { name: "Steel Grey", primary: "#1a1a1a", secondary: "#2a2a2a", accent: "#95a5a6" },
        { name: "Hot Pink", primary: "#2e0a1a", secondary: "#3d1b2a", accent: "#fd79a8" },
        { name: "Electric Lime", primary: "#1a2e0a", secondary: "#2a3d1b", accent: "#55efc4" }
    ]

    property var selectedwifi: [
    {name:"default",security:"WPA",ssid:"SHAJ242"}
    ]

    property int selectedThemeIndex: themeSettings.savedThemeIndex

    // WiFi mock data
    ListModel {
        id: wifiNetworks
        ListElement { name: "Home WiFi"; signal: 4; secured: true; connected: true }
        ListElement { name: "Office Network"; signal: 3; secured: true; connected: false }
        ListElement { name: "Guest WiFi"; signal: 2; secured: false; connected: false }
        ListElement { name: "Neighbor's Network"; signal: 2; secured: true; connected: false }
        ListElement { name: "Public WiFi"; signal: 1; secured: false; connected: false }
        ListElement { name: "Coffee Shop"; signal: 3; secured: true; connected: false }
    }

    // Startup sound (optional)
    StartupOverlay{
        id:startupsound
    }
    // Startup Animation Overlay
    StartupAnim{
        id:startupanim
    }

    // Animated Background with theme colors
    BackgroundAnim{

    }

    // Global key handler for navigation
    Item {
        id: keyHandler
        focus: activePanel === ""
        Keys.onPressed: {
            if (event.key === Qt.Key_Escape && activePanel !== "") {
                activePanel = ""
                event.accepted = true
                return
            }

            if (event.key === Qt.Key_Down) {
                if (focusedGrid < 2) {
                    focusedGrid++
                    updateFocus()
                }
                event.accepted = true
            } else if (event.key === Qt.Key_Up) {
                if (focusedGrid > 0) {
                    focusedGrid--
                    updateFocus()
                }
                event.accepted = true
            } else if (event.key === Qt.Key_Left) {
                if (focusedGrid === 0 && mainTiles.currentIndex > 0) {
                    mainTiles.currentIndex--
                } else if (focusedGrid === 1 && secondaryTiles.currentIndex > 0) {
                    secondaryTiles.currentIndex--
                } else if (focusedGrid === 2 && bottomTile.currentIndex > 0) {
                    bottomTile.currentIndex--
                }
                event.accepted = true
            } else if (event.key === Qt.Key_Right) {
                if (focusedGrid === 0 && mainTiles.currentIndex < mainTiles.count - 1) {
                    mainTiles.currentIndex++
                } else if (focusedGrid === 1 && secondaryTiles.currentIndex < secondaryTiles.count - 1) {
                    secondaryTiles.currentIndex++
                } else if (focusedGrid === 2 && bottomTile.currentIndex < bottomTile.count - 1) {
                    bottomTile.currentIndex++
                }
                event.accepted = true
            } else if (event.key === Qt.Key_Enter || event.key === Qt.Key_Return) {
                if (focusedGrid === 2) {
                    var idx = bottomTile.currentIndex
                    if (idx === 5) { // WiFi tab
                        activePanel = "wifi"
                    } else if (idx === 6) { // Customization tab
                        activePanel = "customization"
                    }
                }
                event.accepted = true
            }
        }
    }

    function updateFocus() {
        if (activePanel === "") {
            keyHandler.forceActiveFocus()
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 20
        opacity: startupComplete ? 1 : 0

        Behavior on opacity {
            NumberAnimation { duration: 800; easing.type: Easing.InOutQuad }
        }

        RowLayout {
            Layout.leftMargin: 20
            Layout.topMargin: 20

            ColumnLayout {
                Text {
                    text: "<font color='White'>Kyro</font><font color='" + accentColors[selectedThemeIndex].accent + "'>OS</font>"
                    font.pointSize: 40
                    textFormat: Text.RichText
                    layer.enabled: true
                    layer.smooth: true
                }
                Text {
                    text:"Version 1.0"
                    color: "white"
                    font.pixelSize: 18
                }
            }

            Item {
                Layout.fillWidth: true
            }

            ColumnLayout {
                Layout.rightMargin: 20
                spacing: 5

                Text {
                    id: timeText
                    Layout.alignment: Qt.AlignRight
                    text: Qt.formatTime(new Date(), "hh:mm AP")
                    color: "white"
                    font.pixelSize: 32
                    font.bold: false
                }

                Text {
                    id: dateText
                    Layout.alignment: Qt.AlignRight
                    text: Qt.formatDate(new Date(), "dddd, MMMM d, yyyy")
                    color: accentColors[selectedThemeIndex].accent
                    font.pixelSize: 16
                }

                Timer {
                    interval: 1000
                    running: true
                    repeat: true
                    onTriggered: {
                        var currentDate = new Date()
                        timeText.text = Qt.formatTime(currentDate, "hh:mm AP")
                        dateText.text = Qt.formatDate(currentDate, "dddd, MMMM d, yyyy")
                    }
                }
            }
        }

        GridView {
            id: mainTiles
            Layout.leftMargin: 20
            Layout.fillWidth: true
            Layout.preferredHeight: 380
            cellWidth: 550
            cellHeight: 380
            model: 3
            interactive: false
            clip: false

            delegate: Rectangle {
                width: 530
                height: 350
                color: (focusedGrid === 0 && mainTiles.currentIndex === index) ? Qt.rgba(0, 0.75, 1, 0.5) : Qt.rgba(0.2, 0.4, 0.7, 0.4)
                border.width: focusedGrid === 0 && mainTiles.currentIndex === index ? 3 : 1
                border.color: focusedGrid === 0 && mainTiles.currentIndex === index ? Qt.rgba(1, 1, 1, 0.9) : Qt.rgba(1, 1, 1, 0.3)

                scale: (focusedGrid === 0 && mainTiles.currentIndex === index) ? 1.05 : 1.0
                Behavior on scale {
                    NumberAnimation {
                        duration: 200
                        easing.type: Easing.OutCubic
                    }
                }
                Behavior on border.width { NumberAnimation { duration: 150 } }
                Behavior on color { ColorAnimation { duration: 200 } }
                Behavior on border.color { ColorAnimation { duration: 200 } }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        mainTiles.currentIndex = index
                        focusedGrid = 0
                        keyHandler.forceActiveFocus()
                    }
                }

                Image {
                    anchors.fill: parent
                    source: "images/main" + (index + 1) + ".png"
                    fillMode: Image.PreserveAspectCrop
                    smooth: true
                    antialiasing: true
                }
            }
        }

        GridView {
            id: secondaryTiles
            Layout.leftMargin: 20
            Layout.fillWidth: true
            Layout.preferredHeight: 220
            cellWidth: 360
            cellHeight: 220
            model: 5
            interactive: false
            clip: false

            delegate: Rectangle {
                width: 340
                height: 200
                radius: 20
                color: (focusedGrid === 1 && secondaryTiles.currentIndex === index) ? Qt.rgba(0, 0.75, 1, 0.5) : Qt.rgba(0.2, 0.4, 0.7, 0.4)
                border.width: focusedGrid === 1 && secondaryTiles.currentIndex === index ? 3 : 1
                border.color: focusedGrid === 1 && secondaryTiles.currentIndex === index ? Qt.rgba(1, 1, 1, 0.9) : Qt.rgba(1, 1, 1, 0.3)

                layer.enabled: true
                layer.smooth: true

                scale: (focusedGrid === 1 && secondaryTiles.currentIndex === index) ? 1.05 : 1.0
                Behavior on scale {
                    NumberAnimation {
                        duration: 200
                        easing.type: Easing.OutCubic
                    }
                }
                Behavior on border.width { NumberAnimation { duration: 150 } }
                Behavior on color { ColorAnimation { duration: 200 } }
                Behavior on border.color { ColorAnimation { duration: 200 } }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        secondaryTiles.currentIndex = index
                        focusedGrid = 1
                        keyHandler.forceActiveFocus()
                    }
                }

                Text {
                    anchors.centerIn: parent
                    text: "Tile " + (index + 1)
                    font.pixelSize: 20
                    color: "white"
                    font.bold: false
                }
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 140
            Layout.bottomMargin: 10

            GridView {
                id: bottomTile
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                width: Math.min(parent.width - 40, 1400)
                height: 120
                cellWidth: 180
                cellHeight: 120
                model: 7
                interactive: false
                flow: GridView.FlowLeftToRight
                clip: false

                delegate: Rectangle {
                    width: 160
                    height: 100
                    radius: 15
                    color: (focusedGrid === 2 && bottomTile.currentIndex === index) ? Qt.rgba(1, 0.9, 0.3, 0.4) : Qt.rgba(1, 1, 1, 0.9)
                    border.width: focusedGrid === 2 && bottomTile.currentIndex === index ? 3 : 1
                    border.color: (focusedGrid === 2 && bottomTile.currentIndex === index) ? accentColors[selectedThemeIndex].accent : Qt.rgba(1, 1, 1, 0.4)

                    layer.enabled: true
                    layer.smooth: true

                    scale: (focusedGrid === 2 && bottomTile.currentIndex === index) ? 1.08 : 1.0
                    Behavior on scale {
                        NumberAnimation {
                            duration: 200
                            easing.type: Easing.OutCubic
                        }
                    }
                    Behavior on border.width { NumberAnimation { duration: 150 } }
                    Behavior on color { ColorAnimation { duration: 200 } }
                    Behavior on border.color { ColorAnimation { duration: 200 } }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            bottomTile.currentIndex = index
                            focusedGrid = 2
                            keyHandler.forceActiveFocus()

                            if (index === 5) {
                                activePanel = "wifi"
                            } else if (index === 6) {
                                activePanel = "customization"
                            }
                        }
                    }

                    ColumnLayout {
                        anchors.centerIn: parent
                        spacing: 7

                        Rectangle {
                            Layout.alignment: Qt.AlignHCenter
                            width: 50
                            height: 50
                            radius: 25
                            color: (focusedGrid === 2 && bottomTile.currentIndex === index) ? accentColors[selectedThemeIndex].accent : Qt.rgba(0.2, 0.4, 0.7, 0.9)
                            layer.enabled: true
                            layer.smooth: true

                            Text {
                                anchors.centerIn: parent
                                text: index === 5 ? "📶" : index === 6 ? "🎨" : (index + 1)
                                font.pixelSize: index >= 5 ? 24 : 20
                                color: "white"
                                font.bold: false
                            }
                        }

                        Text {
                            Layout.alignment: Qt.AlignHCenter
                            text: index === 5 ? "WiFi" : index === 6 ? "Theme" : "App " + (index + 1)
                            font.pixelSize: 14
                            color: (focusedGrid === 2 && bottomTile.currentIndex === index) ? accentColors[selectedThemeIndex].accent : "#2c5364"
                            font.bold: false
                        }
                    }
                }
            }
        }
    }

    // WiFi Panel - Overlay
    WifiTab{
        id: wifiPanel
        visible: activePanel === "wifi"
        focus: visible

        Keys.onPressed: {
            if (event.key === Qt.Key_Escape) {
                activePanel = ""
                event.accepted = true
            }
        }

        onVisibleChanged: {
            if (visible) {
                forceActiveFocus()
            } else {
                keyHandler.forceActiveFocus()
            }
        }

        Behavior on opacity {
            NumberAnimation { duration: 300 }
        }
    }

    Wifidetail {
        id: wifidetail
        visible: activePanel === "wifidetail"
        focus: visible

        Keys.onPressed: {
            if (event.key === Qt.Key_Escape) {
                activePanel = "wifi"
                event.accepted = true
            }
        }

        onVisibleChanged: {
            if (visible) {
                forceActiveFocus()
            } else {
                keyHandler.forceActiveFocus()
            }
        }

        Behavior on opacity {
            NumberAnimation { duration: 300 }
        }
    }


    // Customization Panel - Overlay
    Customize{
        id: customizePanel
        visible: activePanel === "customization"
        focus: visible

        Keys.onPressed: {
            if (event.key === Qt.Key_Escape) {
                activePanel = ""
                event.accepted = true
            }
        }

        onVisibleChanged: {
            if (visible) {
                forceActiveFocus()
            } else {
                keyHandler.forceActiveFocus()
            }
        }

        Behavior on opacity {
            NumberAnimation { duration: 300 }
        }
    }


    Component.onCompleted: {
        keyHandler.forceActiveFocus()
    }
}
