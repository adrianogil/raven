import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item {
    id: requestPanel
    width: parent.width
    height: parent.height

    // Expose properties for Python or other QML components.
    property alias headersText: headersArea.text
    property alias bodyText: bodyArea.text

    ColumnLayout {
        anchors.fill: parent

        // Tab Bar for switching tabs
        TabBar {
            id: tabBar
            Layout.fillWidth: true
            onCurrentIndexChanged: stackLayout.currentIndex = currentIndex

            TabButton { text: "Headers" }
            TabButton { text: "Body" }
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
                }
            }

            // Body Tab
            Item {
                TextArea {
                    id: bodyArea
                    anchors.fill: parent
                    placeholderText: "Request body here..."
                }
            }
        }
    }
}
