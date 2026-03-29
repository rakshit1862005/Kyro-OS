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

    // Single canvas for all waves - reduces memory by 66%
    Canvas {
        id: allWaves
        anchors.fill: parent
        opacity: 1.0
        renderStrategy: Canvas.Threaded
        renderTarget: Canvas.FramebufferObject
        antialiasing: true

        property real time: 0
        property int frameCount: 0

        onPaint: {
            var ctx = getContext("2d")
            ctx.save()
            ctx.clearRect(0, 0, width, height)

            // Draw all three waves in one paint cycle
            for (var index = 0; index < 3; index++) {
                var phase = (index * Math.PI * 0.6) + (time * (0.016 + index * 0.004))
                var amplitude = 40 + (index * 10)
                var frequency = 0.0025 + (index * 0.0006)
                var verticalPos = height * (0.35 + (index * 0.1))

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

            ctx.restore()
        }

        Timer {
            interval: 33
            running: true
            repeat: true
            onTriggered: {
                parent.time += 2.0  // Faster wave movement
                parent.frameCount++
                parent.requestPaint()

                // Force canvas cleanup every 10 minutes to prevent memory buildup
                // Do it less frequently to avoid stuttering
                if (parent.frameCount >= 18000) {  // ~10 minutes at 30fps
                    parent.frameCount = 0
                    Qt.callLater(gc)  // Call GC async to avoid frame drops
                }
            }
        }
    }

    Repeater {
            model: 25
            Rectangle {
                id: particle
                width: 1.5 + Math.random() * 2.5
                height: width
                radius: width / 2
                color: Qt.rgba(0.7, 0.75, 0.85, 0.25 + Math.random() * 0.5)

                property real initialX: Math.random() * parent.width
                property real initialY: Math.random() * parent.height
                property real driftSpeed: 18 + Math.random() * 28
                property real wobbleAmount: 15 + Math.random() * 25

                x: initialX
                y: initialY

                layer.enabled: true
                layer.smooth: true

                SequentialAnimation on y {
                    running: startupComplete
                    loops: Animation.Infinite
                    NumberAnimation {
                        to: -30
                        duration: particle.driftSpeed * 1000
                        easing.type: Easing.Linear
                    }
                    PropertyAction { value: parent.height + 30 }
                }

                SequentialAnimation on x {
                    running: startupComplete
                    loops: Animation.Infinite
                    NumberAnimation {
                        to: particle.initialX + particle.wobbleAmount
                        duration: 4000 + Math.random() * 2500
                        easing.type: Easing.InOutSine
                    }
                    NumberAnimation {
                        to: particle.initialX
                        duration: 4000 + Math.random() * 2500
                        easing.type: Easing.InOutSine
                    }
                }

                SequentialAnimation on opacity {
                    running: startupComplete
                    loops: Animation.Infinite
                    NumberAnimation {
                        to: 0.4  // Brighter minimum opacity
                        duration: 1800 + Math.random() * 2200
                        easing.type: Easing.InOutSine
                    }
                    NumberAnimation {
                        to: 1.0  // Full brightness maximum
                        duration: 1800 + Math.random() * 2200
                        easing.type: Easing.InOutSine
                    }
                }
            }
        }
}
