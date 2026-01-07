import json
import re
from dataclasses import dataclass
from pathlib import Path
from typing import Dict, Optional

BRUNO_PROJECT_FILE = "bruno.json"
REQUESTS_DIR_NAME = "requests"


@dataclass(frozen=True)
class Project:
    name: str
    root: Path

    @property
    def requests_dir(self) -> Path:
        return self.root / REQUESTS_DIR_NAME


def create_project(path: str, name: Optional[str] = None) -> Project:
    root = Path(path).expanduser().resolve()
    project_name = name or root.name
    root.mkdir(parents=True, exist_ok=True)
    (root / REQUESTS_DIR_NAME).mkdir(exist_ok=True)

    project_metadata = {
        "name": project_name,
        "type": "collection",
        "version": "1",
    }
    project_file = root / BRUNO_PROJECT_FILE
    if not project_file.exists():
        project_file.write_text(
            json.dumps(project_metadata, indent=2),
            encoding="utf-8",
        )

    return Project(name=project_name, root=root)


def load_project(path: str) -> Project:
    root = Path(path).expanduser().resolve()
    project_file = root / BRUNO_PROJECT_FILE
    if not project_file.exists():
        raise FileNotFoundError(f"Project file not found at {project_file}")

    project_data = json.loads(project_file.read_text(encoding="utf-8"))
    project_name = project_data.get("name") or root.name
    return Project(name=project_name, root=root)


def save_request(
    project: Project,
    request_name: str,
    method: str,
    url: str,
    headers: Optional[Dict[str, str]] = None,
    body: Optional[str] = None,
) -> Path:
    project.requests_dir.mkdir(parents=True, exist_ok=True)
    filename = f"{_slugify(request_name)}.bru"
    request_path = project.requests_dir / filename

    lines = [
        "meta {",
        f"  name: {request_name}",
        "  type: http",
        "}",
        "",
        f"{method.lower()} {{",
        f"  url: {url}",
        "}",
    ]

    if headers:
        lines.extend(["", "headers {"])
        for key, value in headers.items():
            lines.append(f"  {key}: {value}")
        lines.append("}")

    if body:
        lines.extend(["", "body:raw {"])
        lines.extend(_indent_body(body))
        lines.append("}")

    request_path.write_text("\n".join(lines) + "\n", encoding="utf-8")
    return request_path


def _slugify(value: str) -> str:
    slug = re.sub(r"[^a-zA-Z0-9]+", "-", value.strip()).strip("-").lower()
    return slug or "request"


def _indent_body(body: str) -> list[str]:
    return [f"  {line}" if line else "  " for line in body.splitlines()]
