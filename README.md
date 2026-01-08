# raven
A simple Postman-like HTTP client built with Python and PySide2/QML

## Project support
Raven can optionally create or load a Bruno-style project so you can save requests
as `.bru` files.

### Create a project
```bash
python -m raven.ui.main_window --create-project /path/to/project --project-name "My Project"
```

### Load an existing project
```bash
python -m raven.ui.main_window --load-project /path/to/project
```

When a project is loaded, the UI shows the active project name and enables the
**Save** button. Enter a request name and click **Save** to export the request
to the project's `requests` folder in Bruno `.bru` format.
