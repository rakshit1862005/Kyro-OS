import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Effects

Window {
    id: root
    visible: true
    title: "KyroOS Launcher"
    color: "black"
    visibility: Window.FullScreen

    // Track which GridView has focus (0 = main, 1 = secondary, 2 = bottom)
    property int focusedGrid: 0

    Rectangle {
        id: background
        anchors.fill: parent
        radius: 0
        gradient: Gradient {
            orientation: Gradient.Vertical
            GradientStop { position: 0.0; color: "#0f2027" }
            GradientStop { position: 0.5; color: "#203a43" }
            GradientStop { position: 1.0; color: "#2c5364" }
        }
    }

    // Global key handler for navigation between GridViews
    Item {
        id: keyHandler
        focus: true
        Keys.onPressed: {
            if (event.key === Qt.Key_Down) {
                // Move focus down to next GridView
                if (focusedGrid < 2) {
                    focusedGrid++
                    updateFocus()
                }
                event.accepted = true
            } else if (event.key === Qt.Key_Up) {
                // Move focus up to previous GridView
                if (focusedGrid > 0) {
                    focusedGrid--
                    updateFocus()
                }
                event.accepted = true
            } else if (event.key === Qt.Key_Left) {
                // Navigate left within current GridView
                if (focusedGrid === 0 && mainTiles.currentIndex > 0) {
                    mainTiles.currentIndex--
                } else if (focusedGrid === 1 && secondaryTiles.currentIndex > 0) {
                    secondaryTiles.currentIndex--
                } else if (focusedGrid === 2 && bottomTile.currentIndex > 0) {
                    bottomTile.currentIndex--
                }
                event.accepted = true
            } else if (event.key === Qt.Key_Right) {
                // Navigate right within current GridView
                if (focusedGrid === 0 && mainTiles.currentIndex < mainTiles.count - 1) {
                    mainTiles.currentIndex++
                } else if (focusedGrid === 1 && secondaryTiles.currentIndex < secondaryTiles.count - 1) {
                    secondaryTiles.currentIndex++
                } else if (focusedGrid === 2 && bottomTile.currentIndex < bottomTile.count - 1) {
                    bottomTile.currentIndex++
                }
                event.accepted = true
            } else if (event.key === Qt.Key_Enter || event.key === Qt.Key_Return) {
                // Handle selection
                if (focusedGrid === 0) {
                    console.log("Selected main tile:", mainTiles.currentIndex)
                } else if (focusedGrid === 1) {
                    console.log("Selected secondary tile:", secondaryTiles.currentIndex)
                } else if (focusedGrid === 2) {
                    console.log("Selected bottom tile")
                }
                event.accepted = true
            }
        }
    }

    function updateFocus() {
        keyHandler.forceActiveFocus()
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 20

        RowLayout {
            Layout.leftMargin: 20
            ColumnLayout {
                Text {
                    text: "<font color='White'>Kyro</font><font color='#db5a63'>OS</font>"
                    font.pointSize: 40
                    textFormat: Text.RichText
                }
                Text {
                    text:"Version 1.0"
                    color: "white"
                    font.pixelSize: 18
                }
            }
        }

        // Main Tiles
        GridView {
            id: mainTiles
            Layout.leftMargin: 20
            Layout.fillWidth: true
            Layout.preferredHeight: 380
            cellWidth: 550
            cellHeight: 350
            model: 2
            interactive: false

            delegate: Rectangle {
                anchors.margins: 10
                width: 530
                height: 350
                radius: 20
                // Only highlight if THIS GridView has focus
                color: (focusedGrid === 0 && mainTiles.currentIndex === index) ? "deepskyblue" : "#3498db"
                border.width: focusedGrid === 0 && mainTiles.currentIndex === index ? 4 : 0
                border.color: "white"

                // Animate selection - only scale when this GridView is focused
                scale: (focusedGrid === 0 && mainTiles.currentIndex === index) ? 1.05 : 1.0
                Behavior on scale { NumberAnimation { duration: 150; easing.type: Easing.InOutQuad } }
                Behavior on border.width { NumberAnimation { duration: 100 } }
                Behavior on color { ColorAnimation { duration: 150 } }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        mainTiles.currentIndex = index
                        focusedGrid = 0
                        keyHandler.forceActiveFocus()
                    }
                }

                Text {
                    anchors.centerIn: parent
                    text: "Main Tile " + (index + 1)
                    font.pixelSize: 24
                    color: "white"
                    font.bold: true
                }
            }
        }

        // Secondary Tiles
        GridView {
            id: secondaryTiles
            Layout.leftMargin: 20
            Layout.fillWidth: true
            Layout.preferredHeight: 220
            cellWidth: 360
            cellHeight: 200
            model: 4
            interactive: false

            delegate: Rectangle {
                width: 340
                height: 200
                radius: 20
                // Only highlight if THIS GridView has focus
                color: (focusedGrid === 1 && secondaryTiles.currentIndex === index) ? "deepskyblue" : "#3498db"
                border.width: focusedGrid === 1 && secondaryTiles.currentIndex === index ? 4 : 0
                border.color: "white"

                // Animate selection - only scale when this GridView is focused
                scale: (focusedGrid === 1 && secondaryTiles.currentIndex === index) ? 1.05 : 1.0
                Behavior on scale { NumberAnimation { duration: 150; easing.type: Easing.InOutQuad } }
                Behavior on border.width { NumberAnimation { duration: 100 } }
                Behavior on color { ColorAnimation { duration: 150 } }

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
                    font.bold: true
                }
            }
        }

        // Bottom Tile / Bar - Centered with multiple tiles
        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 100
            Layout.bottomMargin: 5

            GridView {
                id: bottomTile
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                width: Math.min(parent.width - 40, 1400)
                height: 100
                cellWidth: 180
                cellHeight: 100
                model: 7
                interactive: false
                flow: GridView.FlowLeftToRight

                delegate: Rectangle {
                    width: 160
                    height: 120
                    radius: 15
                    // Only highlight if THIS GridView has focus
                    color: (focusedGrid === 2 && bottomTile.currentIndex === index) ? "#FFD700" : "white"
                    border.width: focusedGrid === 2 && bottomTile.currentIndex === index ? 4 : 0
                    border.color: "#db5a63"

                    // Animate selection - only scale when this GridView is focused
                    scale: (focusedGrid === 2 && bottomTile.currentIndex === index) ? 1.08 : 1.0
                    Behavior on scale { NumberAnimation { duration: 150; easing.type: Easing.InOutQuad } }
                    Behavior on border.width { NumberAnimation { duration: 100 } }
                    Behavior on color { ColorAnimation { duration: 150 } }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            bottomTile.currentIndex = index
                            focusedGrid = 2
                            keyHandler.forceActiveFocus()
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
                            color: (focusedGrid === 2 && bottomTile.currentIndex === index) ? "#db5a63" : "#3498db"

                            Text {
                                anchors.centerIn: parent
                                text: (index + 1)
                                font.pixelSize: 20
                                color: "white"
                                font.bold: true
                            }
                        }

                        Text {
                            Layout.alignment: Qt.AlignHCenter
                            text: "App " + (index + 1)
                            font.pixelSize: 14
                            color: (focusedGrid === 2 && bottomTile.currentIndex === index) ? "#db5a63" : "#2c5364"
                            font.bold: true
                        }
                    }
                }
            }
        }
    }

    Component.onCompleted: {
        keyHandler.forceActiveFocus()
    }
}
