import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

RowLayout {
    id: topBar
    // Expose items and signals so Python or other QML files can interact
    property alias methodCombo: methodCombo
    property alias urlField: urlField
    signal sendClicked()

    // Give this layout some size
    Layout.minimumHeight: 50
    Layout.preferredHeight: 50
    spacing: 8

    ComboBox {
        id: methodCombo
        model: ["GET", "POST", "PUT", "DELETE", "PATCH"]
        Layout.preferredWidth: 80
    }

    TextField {
        id: urlField
        placeholderText: "Enter request URL..."
        // Make it expand to fill leftover space
        Layout.fillWidth: true
    }

    Button {
        text: "Send"
        onClicked: {
            topBar.sendClicked()
        }
    }
}
