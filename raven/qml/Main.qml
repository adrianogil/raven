import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "components"

ApplicationWindow {
    visible: true
    width: 1200
    height: 800
    title: qsTr("Raven - Postman-like UI")
    color: "#f4f6fb"

    // Main vertical layout: Top bar at the top, then the SplitView below
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 16

        // Top bar (method, URL, Send)
        TopBar {
            id: topBar
            Layout.fillWidth: true
            projectName: projectName
            onSendClicked: {
                mainWindow.handleSendRequest(
                    methodCombo.currentText,
                    urlField.text,
                    requestPanel.headersText,
                    requestPanel.bodyText
                )
            }
            onSaveClicked: {
                mainWindow.saveRequestToProject(
                    requestNameField.text,
                    methodCombo.currentText,
                    urlField.text,
                    requestPanel.headersText,
                    requestPanel.bodyText
                )
            }
        }

        // SplitView for side-by-side request and response
        SplitView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            orientation: Qt.Horizontal
            handle: Rectangle {
                implicitWidth: 8
                color: "#d6dbe7"
                radius: 4
            }

            RequestPanel {
                id: requestPanel
                Layout.preferredWidth: parent.width * 0.4
            }

            ResponsePanel {
                id: responsePanel
                objectName: "responsePanel"
                Layout.preferredWidth: parent.width * 0.6
            }
        }
    }
}
