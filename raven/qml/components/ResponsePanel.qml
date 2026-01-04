import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: responsePanel
    width: parent.width
    height: parent.height
    color: "#ffffff"
    radius: 12
    border.color: "#e1e6f0"
    border.width: 1

    // Expose properties to update response data
    property string statusText: ""
    property string responseHeaders: ""
    property string responseBody: ""

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 12

        // Tab Bar for switching tabs
        TabBar {
            id: tabBar
            Layout.fillWidth: true
            onCurrentIndexChanged: stackLayout.currentIndex = currentIndex
            background: Rectangle {
                color: "#f1f4fb"
                radius: 10
            }

            TabButton {
                id: statusTab
                text: "Status"
                font.bold: true
                background: Rectangle {
                    radius: 8
                    color: statusTab.checked ? "#2d6cdf" : "transparent"
                }
                contentItem: Text {
                    text: statusTab.text
                    color: statusTab.checked ? "#ffffff" : "#334155"
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
            TabButton {
                id: responseHeadersTab
                text: "Headers"
                font.bold: true
                background: Rectangle {
                    radius: 8
                    color: responseHeadersTab.checked ? "#2d6cdf" : "transparent"
                }
                contentItem: Text {
                    text: responseHeadersTab.text
                    color: responseHeadersTab.checked ? "#ffffff" : "#334155"
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
            TabButton {
                id: responseBodyTab
                text: "Body"
                font.bold: true
                background: Rectangle {
                    radius: 8
                    color: responseBodyTab.checked ? "#2d6cdf" : "transparent"
                }
                contentItem: Text {
                    text: responseBodyTab.text
                    color: responseBodyTab.checked ? "#ffffff" : "#334155"
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
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
                    font.pixelSize: 28
                    font.bold: true
                    color: responsePanel.statusText === "Error" ? "#dc2626" : "#16a34a"
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
                        padding: 10
                        background: Rectangle {
                            color: "#f8f9fc"
                            radius: 8
                            border.color: "#d6dbe7"
                        }
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
                        padding: 10
                        background: Rectangle {
                            color: "#f8f9fc"
                            radius: 8
                            border.color: "#d6dbe7"
                        }
                    }
                }
            }
        }
    }
}
