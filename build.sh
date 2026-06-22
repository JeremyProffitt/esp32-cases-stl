#!/usr/bin/env bash
#
# build.sh — Generate STL + PNG (front & rear) for every .scad in the repo.
# Linux/macOS. Outputs to build/.
#
# Usage: ./build.sh
#
set -euo pipefail

# Locate the OpenSCAD binary.
OPENSCAD="${OPENSCAD:-openscad}"
if ! command -v "$OPENSCAD" >/dev/null 2>&1; then
    for c in \
        "/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD" \
        "/usr/bin/openscad" "/usr/local/bin/openscad"; do
        [ -x "$c" ] && OPENSCAD="$c" && break
    done
fi

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUT="$ROOT/build"
mkdir -p "$OUT"

IMGSIZE="800,600"
# Front: rotX=55, rotY=0, rotZ=45 ; Rear: rotZ=225 (see CLAUDE.md)
CAM_FRONT="0,0,0,55,0,45,0"
CAM_REAR="0,0,0,55,0,225,0"

# Find every design .scad (skip the build dir and the tools/ helper wrappers).
find "$ROOT" -name '*.scad' -not -path "$OUT/*" -not -path "$ROOT/tools/*" | while read -r scad; do
    name="$(basename "$scad" .scad)"
    echo ">> $name"
    "$OPENSCAD" -o "$OUT/$name.stl" --export-format=binstl "$scad"
    "$OPENSCAD" -o "$OUT/${name}_front.png" \
        --camera="$CAM_FRONT" --viewall --autocenter \
        --imgsize="$IMGSIZE" --colorscheme=Tomorrow "$scad"
    "$OPENSCAD" -o "$OUT/${name}_rear.png" \
        --camera="$CAM_REAR" --viewall --autocenter \
        --imgsize="$IMGSIZE" --colorscheme=Tomorrow "$scad"
done

# Engineering drawing sheets (multi-view, dimensioned). Needs Python + Pillow.
PY="${PYTHON:-}"
if [ -z "$PY" ]; then
    command -v python3 >/dev/null 2>&1 && PY=python3 || PY=python
fi
if "$PY" -c "import PIL" >/dev/null 2>&1; then
    echo ">> drawing sheets"
    OPENSCAD="$OPENSCAD" "$PY" "$ROOT/tools/make_drawings.py"
else
    echo ">> skipping drawing sheets (Python Pillow not installed)"
fi

echo "Done. Artifacts in $OUT/"
