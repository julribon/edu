"""Remplace les diagrammes Mermaid d'un HTML Quarto par des SVG statiques.

Quarto dessine les diagrammes Mermaid dans le navigateur, au chargement de la
page. Certains sites (LMS, CMS, ...) n'exécutent pas ce script : le code Mermaid
s'affiche alors en texte brut. Ce script ouvre le HTML dans Chromium (headless),
laisse Mermaid et nos retouches (uml-classes.html) dessiner les diagrammes, puis
remplace chaque bloc <pre class="mermaid ..."> du fichier par le SVG obtenu.

Utilisation :
    python scripts/mermaid_static.py output/content/database/00_database.html [...]

Sans argument, traite les fichiers listés par Quarto dans
QUARTO_PROJECT_OUTPUT_FILES (hook post-render de _quarto.yml).

Chromium / Chrome : chemin pris dans la variable CHROME si elle est définie,
sinon recherché aux emplacements habituels.
"""

from __future__ import annotations

import os
import re
import shutil
import subprocess
import sys
from html.parser import HTMLParser
from pathlib import Path

CHROME_CANDIDATES = [
    "/Applications/Chromium.app/Contents/MacOS/Chromium",
    "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome",
    "chromium",
    "chromium-browser",
    "google-chrome",
]

PRE_RE = re.compile(r'<pre class="mermaid mermaid-js"[^>]*>.*?</pre>', re.DOTALL)


def find_chrome() -> str:
    env = os.environ.get("CHROME")
    if env:
        return env
    for c in CHROME_CANDIDATES:
        path = c if os.path.isabs(c) else shutil.which(c)
        if path and os.path.exists(path):
            return path
    sys.exit("mermaid_static: Chromium/Chrome introuvable (définir la variable CHROME).")


class SvgExtractor(HTMLParser):
    """Récupère, dans l'ordre, le code source des <svg class="... mermaid-js">."""

    def __init__(self, source: str):
        super().__init__(convert_charrefs=False)
        self.source = source
        self.lines = [0]
        for line in source.splitlines(keepends=True):
            self.lines.append(self.lines[-1] + len(line))
        self.svgs: list[str] = []
        self._start: int | None = None
        self._depth = 0

    def _offset(self) -> int:
        line, col = self.getpos()
        return self.lines[line - 1] + col

    def handle_starttag(self, tag, attrs):
        if tag != "svg":
            return
        if self._start is None:
            classes = (dict(attrs).get("class") or "").split()
            if "mermaid-js" in classes:
                self._start = self._offset()
                self._depth = 1
        else:
            self._depth += 1

    def handle_endtag(self, tag):
        if tag != "svg" or self._start is None:
            return
        self._depth -= 1
        if self._depth == 0:
            end = self.source.index(">", self._offset()) + 1
            self.svgs.append(self.source[self._start:end])
            self._start = None


def rendered_svgs(chrome: str, html: Path) -> list[str]:
    dom = subprocess.run(
        [chrome, "--headless", "--disable-gpu", "--window-size=1600,900",
         "--virtual-time-budget=15000", "--dump-dom", html.resolve().as_uri()],
        capture_output=True, text=True, check=True,
    ).stdout
    parser = SvgExtractor(dom)
    parser.feed(dom)
    return parser.svgs


def process(chrome: str, html: Path) -> None:
    text = html.read_text(encoding="utf-8")
    blocks = PRE_RE.findall(text)
    if not blocks:
        return
    svgs = rendered_svgs(chrome, html)
    if len(svgs) != len(blocks):
        sys.exit(f"mermaid_static: {html}: {len(blocks)} diagrammes, "
                 f"mais {len(svgs)} SVG dessinés. Fichier laissé tel quel.")
    it = iter(svgs)
    html.write_text(PRE_RE.sub(lambda m: next(it), text), encoding="utf-8")
    print(f"mermaid_static: {html}: {len(svgs)} diagrammes convertis en SVG")


def main(argv: list[str]) -> None:
    files = argv or os.environ.get("QUARTO_PROJECT_OUTPUT_FILES", "").split()
    files = [Path(f) for f in files if f.endswith(".html")]
    if not files:
        return
    chrome = find_chrome()
    for f in files:
        process(chrome, f)


if __name__ == "__main__":
    main(sys.argv[1:])
