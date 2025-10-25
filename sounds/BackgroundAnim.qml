import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: background
    anchors.fill: parent

    gradient: Gradient {
        orientation: Gradient.Vertical
        GradientStop { position: 0.0; color: accentColors[selectedThemeIndex].primary }
        GradientStop { position: 0.5; color: accentColors[selectedThemeIndex].secondary }
        GradientStop { position: 1.0; color: accentColors[selectedThemeIndex].primary }
    }

    Behavior on gradient {
        PropertyAnimation { duration: 800; easing.type: Easing.InOutCubic }
    }

    Repeater {
        model: 3
        Item {
            anchors.fill: parent


            Canvas {
                id: glassWave
                anchors.fill: parent
                opacity: 1.0
                renderStrategy: Canvas.Threaded
                renderTarget: Canvas.FramebufferObject
                antialiasing: true

                property real phase: index * Math.PI * 0.6
                property real amplitude: 40 + (index * 10)
                property real frequency: 0.0025 + (index * 0.0006)
                property real speed: 0.016 + (index * 0.004)
                property real verticalPos: parent.height * (0.35 + (index * 0.1))

                onPaint: {
                    var ctx = getContext("2d")
                    ctx.clearRect(0, 0, width, height)

                    var gradient = ctx.createLinearGradient(0, verticalPos - amplitude * 3, 0, verticalPos + amplitude * 3)
                    gradient.addColorStop(0, Qt.rgba(1, 1, 1, 0))
                    gradient.addColorStop(0.25, Qt.rgba(0.7, 0.75, 0.85, 0.05))
                    gradient.addColorStop(0.5, Qt.rgba(0.9, 0.92, 0.98, 0.15))
                    gradient.addColorStop(0.75, Qt.rgba(0.7, 0.75, 0.85, 0.05))
                    gradient.addColorStop(1, Qt.rgba(1, 1, 1, 0))

                    ctx.fillStyle = gradient
                    ctx.beginPath()

                    var startY = verticalPos + Math.sin(phase) * amplitude
                    ctx.moveTo(0, startY)

                    for (var x = 0; x <= width; x += 2) {
                        var wave1 = Math.sin((x * frequency) + phase) * amplitude
                        var wave2 = Math.sin((x * frequency * 1.3) + phase * 1.2) * (amplitude * 0.3)
                        var y = verticalPos + wave1 + wave2
                        ctx.lineTo(x, y)
                    }

                    ctx.lineTo(width, height)
                    ctx.lineTo(0, height)
                    ctx.closePath()
                    ctx.fill()

                    ctx.strokeStyle = Qt.rgba(1, 1, 1, 0.1)
                    ctx.lineWidth = 1.2
                    ctx.beginPath()
                    ctx.moveTo(0, startY)
                    for (x = 0; x <= width; x += 2) {
                        wave1 = Math.sin((x * frequency) + phase) * amplitude
                        wave2 = Math.sin((x * frequency * 1.3) + phase * 1.2) * (amplitude * 0.3)
                        y = verticalPos + wave1 + wave2
                        ctx.lineTo(x, y)
                    }
                    ctx.stroke()
                }

                Timer {
                    interval: 33
                    running: true
                    repeat: true
                    onTriggered: {
                        parent.phase += parent.speed
                        parent.requestPaint()
                    }
                }
            }
        }
    }

    Repeater {
        model: 50
        Rectangle {
            id: particle
            width: 1.5 + Math.random() * 2.5
            height: width
            radius: width / 2
            color: Qt.rgba(0.7, 0.75, 0.85, 0.25 + Math.random() * 0.5)
            x: Math.random() * parent.width
            y: Math.random() * parent.height
            layer.enabled: true
            layer.smooth: true

            property real driftSpeed: 18 + Math.random() * 28
            property real wobbleAmount: 15 + Math.random() * 25

            SequentialAnimation on y {
                running: startupComplete
                loops: Animation.Infinite
                NumberAnimation {
                    to: -30
                    duration: driftSpeed * 1000
                    easing.type: Easing.Linear
                }
                PropertyAction { value: parent.height + 30 }
            }

            SequentialAnimation on x {
                running: startupComplete
                loops: Animation.Infinite
                NumberAnimation {
                    to: particle.x + wobbleAmount
                    duration: 4000 + Math.random() * 2500
                    easing.type: Easing.InOutSine
                }
                NumberAnimation {
                    to: particle.x
                    duration: 4000 + Math.random() * 2500
                    easing.type: Easing.InOutSine
                }
            }

            SequentialAnimation on opacity {
                running: startupComplete
                loops: Animation.Infinite
                NumberAnimation {
                    to: 0.15
                    duration: 1800 + Math.random() * 2200
                    easing.type: Easing.InOutSine
                }
                NumberAnimation {
                    to: 0.75
                    duration: 1800 + Math.random() * 2200
                    easing.type: Easing.InOutSine
                }
            }
        }
    }
}
