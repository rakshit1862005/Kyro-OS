import QtQuick 2.15
import QtMultimedia

MediaPlayer {
    id: startupSound
    source: "/sounds/sounds/pulse.wav"
    audioOutput: AudioOutput {
        volume: 0.7
    }
    Component.onCompleted: {
        play()
    }
}
