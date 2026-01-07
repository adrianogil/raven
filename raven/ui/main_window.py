import argparse
import os
from PySide2.QtCore import QObject, Slot
from pyutils.pyside.qmlapp import QMLApp
from raven.core.requests_manager import send_request
from raven.core.project_manager import create_project, load_project, save_request

class MainWindow(QObject):
    def __init__(self, project=None):
        super().__init__()
        # Initialize QML application instance
        self.app = QMLApp()
        # Point to Main.qml
        base_dir = os.path.dirname(os.path.abspath(__file__))
        qml_path = os.path.join(base_dir, '..', 'qml', 'Main.qml')
        self.app.main_qml = os.path.abspath(qml_path)
        self.project = project

    def run(self):
        # Expose a method so QML can call into Python
        self.app.qml_engine.rootContext().setContextProperty("mainWindow", self)
        self._update_project_name()
        self.app.show()

    def _update_project_name(self):
        project_name = self.project.name if self.project else ""
        self.app.qml_engine.rootContext().setContextProperty(
            "projectName",
            project_name,
        )

    def _parse_headers(self, headers_text):
        parsed_headers = {}
        if headers_text.strip():
            for line in headers_text.split('\n'):
                if ':' in line:
                    key, val = line.split(':', 1)
                    parsed_headers[key.strip()] = val.strip()
        return parsed_headers

    @Slot(str, str, str, str)
    def handleSendRequest(self, method, url, headers, body):
        """
        Called from QML to send the request and update the UI.
        """
        # Convert 'headers' text into a dict if it’s in a "Key: Value" format
        parsed_headers = self._parse_headers(headers)

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
            formatted_headers = "\n".join(
                f"{key}: {value}" for key, value in response.headers.items()
            )
            response_panel.setProperty(
                "responseHeaders",
                formatted_headers if formatted_headers else "No response headers.",
            )
            response_panel.setProperty("responseBody", response.text)
        else:
            # Show some error info
            response_panel.setProperty("statusText", "Error")
            response_panel.setProperty("responseHeaders", "")
            response_panel.setProperty("responseBody", "Could not send request.")

    @Slot(str, str)
    def createProject(self, project_path, project_name):
        self.project = create_project(project_path, project_name)
        self._update_project_name()
        return True

    @Slot(str, str, str, str, str)
    def saveRequestToProject(self, request_name, method, url, headers, body):
        if not self.project:
            print("Error: No project created. Call createProject first.")
            return False
        cleaned_name = request_name.strip() or f"{method.upper()} {url}"
        parsed_headers = self._parse_headers(headers)
        save_request(self.project, cleaned_name, method, url, parsed_headers, body)
        return True

def _parse_args():
    parser = argparse.ArgumentParser(description="Raven HTTP client")
    project_group = parser.add_mutually_exclusive_group()
    project_group.add_argument(
        "--create-project",
        dest="create_project",
        help="Create a new project at the provided path.",
    )
    project_group.add_argument(
        "--load-project",
        dest="load_project",
        help="Load an existing project from the provided path.",
    )
    parser.add_argument(
        "--project-name",
        dest="project_name",
        help="Optional name to use when creating a project.",
    )
    return parser.parse_args()

if __name__ == '__main__':
    args = _parse_args()
    initial_project = None
    if args.create_project:
        initial_project = create_project(args.create_project, args.project_name)
    elif args.load_project:
        initial_project = load_project(args.load_project)
    window = MainWindow(project=initial_project)
    window.run()
