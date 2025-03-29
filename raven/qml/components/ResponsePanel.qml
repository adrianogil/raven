import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item {
    id: responsePanel
    width: parent.width
    height: parent.height

    // Expose properties to update response data
    property string statusText: ""
    property string responseHeaders: ""
    property string responseBody: ""

    ColumnLayout {
        anchors.fill: parent

        // Tab Bar for switching tabs
        TabBar {
            id: tabBar
            Layout.fillWidth: true
            onCurrentIndexChanged: stackLayout.currentIndex = currentIndex

            TabButton { text: "Status" }
            TabButton { text: "Headers" }
            TabButton { text: "Body" }
        }

        // StackLayout for switching the visible content
        StackLayout {
            id: stackLayout
            Layout.fillWidth: true
            Layout.fillHeight: true

            // Status Tab
            Item {
                Label {
                    anchors.centerIn: parent
                    text: responsePanel.statusText
                }
            }

            // Headers Tab
            Item {
                ScrollView {
                    anchors.fill: parent
                    TextArea {
                        anchors.fill: parent
                        text: responsePanel.responseHeaders
                        readOnly: true
                    }
                }
            }

            // Body Tab
            Item {
                ScrollView {
                    anchors.fill: parent
                    TextArea {
                        anchors.fill: parent
                        text: responsePanel.responseBody
                        readOnly: true
                    }
                }
            }
        }
    }
}
