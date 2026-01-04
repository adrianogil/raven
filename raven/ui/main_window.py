import os
from PySide2.QtCore import QObject, Slot
from pyutils.pyside.qmlapp import QMLApp
from raven.core.requests_manager import send_request

class MainWindow(QObject):
    def __init__(self):
        super().__init__()
        # Initialize QML application instance
        self.app = QMLApp()
        # Point to Main.qml
        base_dir = os.path.dirname(os.path.abspath(__file__))
        qml_path = os.path.join(base_dir, '..', 'qml', 'Main.qml')
        self.app.main_qml = os.path.abspath(qml_path)

    def run(self):
        # Expose a method so QML can call into Python
        self.app.qml_engine.rootContext().setContextProperty("mainWindow", self)
        self.app.show()

    @Slot(str, str, str, str)
    def handleSendRequest(self, method, url, headers, body):
        """
        Called from QML to send the request and update the UI.
        """
        # Convert 'headers' text into a dict if it’s in a "Key: Value" format
        parsed_headers = {}
        if headers.strip():
            for line in headers.split('\n'):
                if ':' in line:
                    key, val = line.split(':', 1)
                    parsed_headers[key.strip()] = val.strip()

        # Send request
        response = send_request(method, url, parsed_headers, body)

        # Update the QML side with response details
        root_object = self.app.qml_engine.rootObjects()[0]
        response_panel = root_object.findChild(QObject, "responsePanel")
        if response_panel is None:
            print("Error: responsePanel not found in QML tree.")
            return

        if response:
            # Access the QML objects by name (if needed) or set context properties
            response_panel.setProperty("statusText", str(response.status_code))
            response_panel.setProperty("responseHeaders", str(response.headers))
            response_panel.setProperty("responseBody", response.text)
        else:
            # Show some error info
            response_panel.setProperty("statusText", "Error")
            response_panel.setProperty("responseHeaders", "")
            response_panel.setProperty("responseBody", "Could not send request.")

if __name__ == '__main__':
    window = MainWindow()
    window.run()
