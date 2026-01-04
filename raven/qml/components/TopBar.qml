import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: topBar
    color: "#ffffff"
    radius: 12
    border.color: "#e1e6f0"
    border.width: 1
    Layout.fillWidth: true
    Layout.minimumHeight: 64

    // Expose items and signals so Python or other QML files can interact
    property alias methodCombo: methodCombo
    property alias urlField: urlField
    signal sendClicked()

    RowLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 12

        ComboBox {
            id: methodCombo
            model: ["GET", "POST", "PUT", "DELETE", "PATCH"]
            Layout.preferredWidth: 96
            font.bold: true
            background: Rectangle {
                color: "#f1f4fb"
                radius: 10
                border.color: "#d6dbe7"
            }
        }

        TextField {
            id: urlField
            placeholderText: "Enter request URL..."
            Layout.fillWidth: true
            background: Rectangle {
                color: "#f8f9fc"
                radius: 10
                border.color: "#d6dbe7"
            }
            padding: 10
        }

        Button {
            text: "Send"
            font.bold: true
            Layout.preferredWidth: 100
            background: Rectangle {
                radius: 10
                color: control.down ? "#1f4fbf" : "#2d6cdf"
            }
            contentItem: Text {
                text: control.text
                color: "#ffffff"
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            onClicked: {
                topBar.sendClicked()
            }
        }
    }
}
