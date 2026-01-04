import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: requestPanel
    width: parent.width
    height: parent.height
    color: "#ffffff"
    radius: 12
    border.color: "#e1e6f0"
    border.width: 1

    // Expose properties for Python or other QML components.
    property alias headersText: headersArea.text
    property alias bodyText: bodyArea.text

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
                text: "Headers"
                font.bold: true
                background: Rectangle {
                    radius: 8
                    color: control.checked ? "#2d6cdf" : "transparent"
                }
                contentItem: Text {
                    text: control.text
                    color: control.checked ? "#ffffff" : "#334155"
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
            TabButton {
                text: "Body"
                font.bold: true
                background: Rectangle {
                    radius: 8
                    color: control.checked ? "#2d6cdf" : "transparent"
                }
                contentItem: Text {
                    text: control.text
                    color: control.checked ? "#ffffff" : "#334155"
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

            // Headers Tab
            Item {
                TextArea {
                    id: headersArea
                    anchors.fill: parent
                    placeholderText: "Key: Value"
                    padding: 10
                    background: Rectangle {
                        color: "#f8f9fc"
                        radius: 8
                        border.color: "#d6dbe7"
                    }
                }
            }

            // Body Tab
            Item {
                TextArea {
                    id: bodyArea
                    anchors.fill: parent
                    placeholderText: "Request body here..."
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
