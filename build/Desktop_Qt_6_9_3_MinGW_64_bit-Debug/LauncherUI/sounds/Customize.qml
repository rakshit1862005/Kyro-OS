import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15


Rectangle {

    id: customizationPanel
    anchors.right: parent.right
    anchors.top: parent.top
    anchors.bottom: parent.bottom
    width: 500
    color: Qt.rgba(0.1, 0.1, 0.15, 0.95)
    visible: activePanel === "customization"
    layer.enabled: true
    layer.smooth: true

    property int currentThemeIndex: 0

    // Focus management
    focus: visible

    Keys.onPressed: {
        if (event.key === Qt.Key_Escape) {
            activePanel = ""
            event.accepted = true
        } else if (event.key === Qt.Key_Up) {
            currentThemeIndex--
            if (currentThemeIndex < 0) {
                currentThemeIndex = accentColors.length - 1  // wrap to last
            }
            themeListView.positionViewAtIndex(currentThemeIndex, ListView.Contain)
            event.accepted = true
        } else if (event.key === Qt.Key_Down) {
            currentThemeIndex++
            if (currentThemeIndex >= accentColors.length) {
                currentThemeIndex = 0  // wrap to first
            }
            themeListView.positionViewAtIndex(currentThemeIndex, ListView.Contain)
            event.accepted = true
        } else if (event.key === Qt.Key_Enter || event.key === Qt.Key_Return) {
            selectedThemeIndex = currentThemeIndex
            themeSettings.savedThemeIndex = selectedThemeIndex
            event.accepted = true
        }
    }

    onVisibleChanged: {
        if (visible) {
            forceActiveFocus()
            currentThemeIndex = selectedThemeIndex
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 15

        RowLayout {
            Layout.fillWidth: true

            Text {
                text: "UI Customization"
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

        Text {
            text: "Accent Color Themes"
            font.pixelSize: 20
            color: "white"
            font.bold: false
        }

        ScrollView {
            id: scrollView
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            ScrollBar.vertical.policy: ScrollBar.AlwaysOff
            ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

            ListView {
                id: themeListView
                width: customizationPanel.width - 40
                spacing: 15
                model: accentColors.length
                currentIndex: customizationPanel.currentThemeIndex


                delegate: Rectangle {
                    width: ListView.view.width
                    height: 120
                    radius: 15
                    color: {
                        if (selectedThemeIndex === index) {
                            return Qt.rgba(0.3, 0.5, 0.6, 0.6)
                        } else if (customizationPanel.currentThemeIndex === index) {
                            return Qt.rgba(0.3, 0.4, 0.5, 0.7)
                        } else {
                            return Qt.rgba(0.2, 0.3, 0.4, 0.5)
                        }
                    }
                    border.width: {
                        if (selectedThemeIndex === index) {
                            return 4
                        } else if (customizationPanel.currentThemeIndex === index) {
                            return 3
                        } else {
                            return 1
                        }
                    }
                    border.color: {
                        if (customizationPanel.currentThemeIndex === index) {
                            return accentColors[selectedThemeIndex].accent
                        } else if (selectedThemeIndex === index) {
                            return "white"
                        } else {
                            return Qt.rgba(1, 1, 1, 0.3)
                        }
                    }

                    layer.enabled: true
                    layer.smooth: true


                    Behavior on scale {
                        NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
                    }

                    Behavior on color {
                        ColorAnimation { duration: 200 }
                    }

                    Behavior on border.width {
                        NumberAnimation { duration: 200 }
                    }

                    Behavior on border.color {
                        ColorAnimation { duration: 200 }
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: {
                            customizationPanel.currentThemeIndex = index
                        }
                        onClicked: {
                            customizationPanel.currentThemeIndex = index
                            selectedThemeIndex = index
                        }
                    }

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 20
                        spacing: 20

                        Rectangle {
                            Layout.preferredWidth: 80
                            Layout.preferredHeight: 80
                            radius: 40
                            layer.enabled: true
                            layer.smooth: true

                            gradient: Gradient {
                                GradientStop { position: 0.0; color: accentColors[index].primary }
                                GradientStop { position: 0.5; color: accentColors[index].secondary }
                                GradientStop { position: 1.0; color: accentColors[index].primary }
                            }

                            Rectangle {
                                anchors.centerIn: parent
                                width: 40
                                height: 40
                                radius: 20
                                color: accentColors[index].accent
                            }
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 8

                            Text {
                                text: accentColors[index].name
                                font.pixelSize: 20
                                color: "white"
                                font.bold: false
                            }

                            RowLayout {
                                spacing: 10

                                Rectangle {
                                    width: 30
                                    height: 30
                                    radius: 15
                                    color: accentColors[index].primary
                                    border.width: 1
                                    border.color: Qt.rgba(1, 1, 1, 0.3)
                                }

                                Rectangle {
                                    width: 30
                                    height: 30
                                    radius: 15
                                    color: accentColors[index].secondary
                                    border.width: 1
                                    border.color: Qt.rgba(1, 1, 1, 0.3)
                                }

                                Rectangle {
                                    width: 30
                                    height: 30
                                    radius: 15
                                    color: accentColors[index].accent
                                    border.width: 1
                                    border.color: Qt.rgba(1, 1, 1, 0.3)
                                }
                            }

                            Text {
                                visible: selectedThemeIndex === index
                                text: "✓ Active Theme"
                                font.pixelSize: 14
                                color: accentColors[index].accent
                                font.bold: false
                            }
                        }

                        Text {
                            text: selectedThemeIndex === index ? "✓" : "○"
                            font.pixelSize: 36
                            color: selectedThemeIndex === index ? accentColors[index].accent : Qt.rgba(1, 1, 1, 0.3)
                        }
                    }
                }
            }
        }

        Text {
            Layout.topMargin: 10
            Layout.fillWidth: true
            text: "Use ↑↓ to navigate, Enter to apply theme, Esc to close"
            font.pixelSize: 12
            color: Qt.rgba(1, 1, 1, 0.5)
            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignHCenter
        }

        Text {
            Layout.fillWidth: true
            text: "Theme changes apply instantly to the background and accent colors throughout the UI."
            font.pixelSize: 13
            color: Qt.rgba(1, 1, 1, 0.6)
            wrapMode: Text.WordWrap
        }
    }
}
