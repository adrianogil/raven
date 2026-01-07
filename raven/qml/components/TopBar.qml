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
    property alias requestNameField: requestNameField
    property string projectName: ""
    signal sendClicked()
    signal saveClicked()

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

        TextField {
            id: requestNameField
            placeholderText: "Request name"
            Layout.preferredWidth: 200
            background: Rectangle {
                color: "#f8f9fc"
                radius: 10
                border.color: "#d6dbe7"
            }
            padding: 10
        }

        Button {
            id: sendButton
            text: "Send"
            font.bold: true
            Layout.preferredWidth: 100
            background: Rectangle {
                radius: 10
                color: sendButton.down ? "#1f4fbf" : "#2d6cdf"
            }
            contentItem: Text {
                text: sendButton.text
                color: "#ffffff"
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            onClicked: {
                topBar.sendClicked()
            }
        }

        Button {
            id: saveButton
            text: "Save"
            font.bold: true
            Layout.preferredWidth: 100
            enabled: topBar.projectName.length > 0
            background: Rectangle {
                radius: 10
                color: saveButton.enabled
                    ? (saveButton.down ? "#1b4332" : "#2d6a4f")
                    : "#94a3b8"
            }
            contentItem: Text {
                text: saveButton.text
                color: "#ffffff"
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            onClicked: {
                topBar.saveClicked()
            }
        }

        Text {
            id: projectLabel
            text: topBar.projectName.length > 0
                ? "Project: " + topBar.projectName
                : "No project loaded"
            color: "#475569"
            font.bold: true
            Layout.preferredWidth: 200
            elide: Text.ElideRight
            verticalAlignment: Text.AlignVCenter
        }
    }
}
