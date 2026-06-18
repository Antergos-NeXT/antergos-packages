/* Antergos NeXT Calamares slideshow */
import QtQuick 2.0;
import calamares.slideshow 1.0;

Presentation
{
    id: presentation

    Timer {
        interval: 5000
        running: presentation.activatedInCalamares
        repeat: true
        onTriggered: presentation.goToNextSlide()
    }

    Slide {
        Text {
            anchors.centerIn: parent
            text: "Welcome to Antergos NeXT"
            font.pixelSize: 24
            font.bold: true
            color: "#2a7ab5"
        }
    }

    Slide {
        Text {
            anchors.centerIn: parent
            text: "Installing Antergos NeXT..."
            font.pixelSize: 20
            color: "#333"
        }
    }

    Slide {
        Text {
            anchors.centerIn: parent
            text: "Almost done!"
            font.pixelSize: 20
            color: "#333"
        }
    }
}
