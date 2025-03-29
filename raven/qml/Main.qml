import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "components"

ApplicationWindow {
    visible: true
    width: 1200
    height: 800
    title: qsTr("Raven - Postman-like UI")

    // Main vertical layout: Top bar at the top, then the SplitView below
    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // Top bar (method, URL, Send)
        TopBar {
            id: topBar
            Layout.fillWidth: true
            onSendClicked: {
                // For example:
                // mainWindow.handleSendRequest(methodCombo.currentText, urlField.text, requestPanel.headersText, requestPanel.bodyText)
            }
        }

        // SplitView for side-by-side request and response
        SplitView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            orientation: Qt.Horizontal

            RequestPanel {
                id: requestPanel
                Layout.preferredWidth: parent.width * 0.4
            }

            ResponsePanel {
                id: responsePanel
                Layout.preferredWidth: parent.width * 0.6
            }
        }
    }
}
