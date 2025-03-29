import os
from pyutils.pyside.qmlapp import QMLApp
from raven.core.requests_manager import send_request

class MainWindow:
    def __init__(self):
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
        if response:
            # Access the QML objects by name (if needed) or set context properties
            self.app.qml_engine.rootObjects[0].findChild(type=None, name="responsePanel").statusText = str(response.status_code)
            self.app.qml_engine.rootObjects[0].findChild(type=None, name="responsePanel").responseHeaders = str(response.headers)
            self.app.qml_engine.rootObjects[0].findChild(type=None, name="responsePanel").responseBody = response.text
        else:
            # Show some error info
            self.app.qml_engine.rootObjects[0].findChild(type=None, name="responsePanel").statusText = "Error"
            self.app.qml_engine.rootObjects[0].findChild(type=None, name="responsePanel").responseHeaders = ""
            self.app.qml_engine.rootObjects[0].findChild(type=None, name="responsePanel").responseBody = "Could not send request."

if __name__ == '__main__':
    window = MainWindow()
    window.run()
