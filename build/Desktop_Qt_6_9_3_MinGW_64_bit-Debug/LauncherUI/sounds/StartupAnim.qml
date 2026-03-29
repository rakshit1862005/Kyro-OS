import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: startupOverlay
    anchors.fill: parent
    color: "black"
    z: 1000
    visible: !startupComplete

    Text {
        id: startupText
        anchors.centerIn: parent
        text: "<font color='White'>Kyro OS</font>"
        font.pointSize: 80
        textFormat: Text.RichText
        opacity: 0
        scale: 0.5
        layer.enabled: true
        layer.smooth: true

        // Fade in + scale animation
        SequentialAnimation {
            running: true
            NumberAnimation { target: startupText; property: "opacity"; to: 1.0; duration: 1200; easing.type: Easing.OutCubic }

            PauseAnimation { duration: 600 } // keep text visible for a moment
            // Fade out together with overlay
            NumberAnimation { target: startupOverlay; property: "opacity"; to: 0; duration: 600; easing.type: Easing.InOutQuad; onFinished: { startupComplete = true; startupOverlay.visible = false } }
        }
    }

    Repeater {
        model: 2
        Item {
            anchors.fill: parent
            layer.enabled: true
            layer.smooth: true

            Canvas {
                id: startupWave
                anchors.fill: parent
                opacity: 0.0
                renderStrategy: Canvas.Threaded
                renderTarget: Canvas.FramebufferObject
                antialiasing: true

                property real phase: index * Math.PI * 0.4
                property real amplitude: 60 + index * 10
                property real frequency: 0.004 + (index * 0.0008)  // Different frequencies for separation
                property real yPosition: parent.height * 0.5
                property real animProgress: 0

                onPaint: {
                    var ctx = getContext("2d")
                    ctx.save()
                    ctx.clearRect(0, 0, width, height)

                    var gradient = ctx.createLinearGradient(0, yPosition - amplitude * 2.5, 0, yPosition + amplitude * 2.5)
                    gradient.addColorStop(0, Qt.rgba(1, 1, 1, 0))
                    gradient.addColorStop(0.2, Qt.rgba(0.7, 0.75, 0.85, 0.04 * animProgress))
                    gradient.addColorStop(0.35, Qt.rgba(0.8, 0.85, 0.95, 0.12 * animProgress))
                    gradient.addColorStop(0.5, Qt.rgba(0.9, 0.92, 0.98, 0.25 * animProgress))
                    gradient.addColorStop(0.65, Qt.rgba(0.8, 0.85, 0.95, 0.12 * animProgress))
                    gradient.addColorStop(0.8, Qt.rgba(0.7, 0.75, 0.85, 0.04 * animProgress))
                    gradient.addColorStop(1, Qt.rgba(1, 1, 1, 0))

                    ctx.fillStyle = gradient
                    ctx.beginPath()
                    ctx.moveTo(0, height)

                    // Reduced step size from 6 to 3 for smoother curves
                    for (var x = 0; x <= width; x += 3) {
                        var wave = Math.sin((x * frequency) + phase) * amplitude * animProgress
                        var y = yPosition + wave
                        if (x === 0) {
                            ctx.moveTo(x, y)
                        } else {
                            ctx.lineTo(x, y)
                        }
                    }

                    ctx.lineTo(width, height)
                    ctx.lineTo(0, height)
                    ctx.closePath()
                    ctx.fill()

                    ctx.strokeStyle = Qt.rgba(1, 1, 1, 0.15 * animProgress)
                    ctx.lineWidth = 2
                    ctx.beginPath()
                    // Reduced step size from 8 to 3 for smoother stroke
                    for (x = 0; x <= width; x += 3) {
                        wave = Math.sin((x * frequency) + phase) * amplitude * animProgress
                        y = yPosition + wave
                        if (x === 0) {
                            ctx.moveTo(x, y)
                        } else {
                            ctx.lineTo(x, y)
                        }
                    }
                    ctx.stroke()
                    ctx.restore()
                }

                SequentialAnimation on animProgress {
                    running: true
                    PauseAnimation { duration: index * 80 }
                    NumberAnimation {
                        to: 1.0
                        duration: 1000
                        easing.type: Easing.OutCubic
                    }
                }

                SequentialAnimation on opacity {
                    running: true
                    PauseAnimation { duration: index * 80 }
                    NumberAnimation {
                        to: 1.0
                        duration: 700
                        easing.type: Easing.OutCubic
                    }
                }

                Timer {
                    interval: 16
                    running: !startupComplete
                    repeat: true
                    onTriggered: {
                        parent.phase += 0.025
                        parent.requestPaint()
                    }
                }
            }
        }

    }

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 40
        layer.enabled: true
        layer.smooth: true

        Text {
            Layout.alignment: Qt.AlignHCenter
            text: "<font color='White'>Kyro</font><font color='#db5a63'>OS</font>"
            font.pointSize: 70
            textFormat: Text.RichText
            scale: logoScale.value
            opacity: logoOpacity.value
            layer.enabled: true
            layer.smooth: true

            NumberAnimation {
                id: logoScale
                property real value: 0.3
                to: 1.0
                duration: 1200
                easing.type: Easing.OutElastic
                easing.amplitude: 1.2
                easing.period: 0.5
                running: true
            }

            NumberAnimation {
                id: logoOpacity
                property real value: 0
                to: 1.0
                duration: 1000
                running: true
            }
        }

        Rectangle {
            NumberAnimation {
                id: loadingAnimation
                property real value: 0
                to: 1.0
                duration: 2200
                easing.type: Easing.InOutCubic
                running: true
                onFinished: {
                    fadeOutAnimation.start()
                }
            }
        }
    }

    NumberAnimation {
        id: fadeOutAnimation
        target: startupOverlay
        property: "opacity"
        to: 0
        duration: 600
        easing.type: Easing.InOutQuad
        onFinished: {
            startupComplete = true
            startupOverlay.visible = false
        }
    }
}
