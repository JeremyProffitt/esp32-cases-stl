# ESP32 Cases (OpenSCAD / STL)

OpenSCAD designs for 3D-printable ESP32 device enclosures.

Generated STL and PNG artifacts are **not committed** — they are produced by
the build scripts and attached to [GitHub Releases](https://github.com/JeremyProffitt/esp32-cases-stl/releases/latest).

## Building locally

Requires [OpenSCAD](https://openscad.org/). Then:

```bash
./build.sh        # Linux / macOS
build.bat         # Windows
```

This renders an STL plus front/rear PNGs for **every** `.scad` in the repo into
`build/`.

---

## Designs

### TTGO-TM ESP32 ("TMusic") Enclosure

A two-part enclosure for a TTGO-TM ESP32 music device: a **base tray** (the
deep box that holds the PCB) and a **front bezel** (the face with the display
window, speaker/finger slots, button hole and side ports). Footprint
76.2 × 49.5 mm.

Each part is provided in **two forms**:

- **Mesh wrapper** (`*_mesh.scad`) — imports the original CATIA-exported STL
  verbatim. **Geometry-exact**; use for final prints / fit checks.
- **Parametric rebuild** (`ttgo_body.scad`, `ttgo_cap.scad`) — hand-modelled
  from OpenSCAD primitives. **Editable but approximate**; use to tweak
  dimensions.

Folder: [`TTGO-TM-ESP32-aka-TMusic/`](TTGO-TM-ESP32-aka-TMusic/)

#### Base Tray — parametric (`ttgo_cap.scad`)

| Front View | Rear View |
|------------|-----------|
| ![Front](https://github.com/JeremyProffitt/esp32-cases-stl/releases/latest/download/ttgo_cap_front.png) | ![Rear](https://github.com/JeremyProffitt/esp32-cases-stl/releases/latest/download/ttgo_cap_rear.png) |

**Documentation**: [ttgo_cap.md](TTGO-TM-ESP32-aka-TMusic/ttgo_cap.md)
· **Download STL**: [ttgo_cap.stl](https://github.com/JeremyProffitt/esp32-cases-stl/releases/latest/download/ttgo_cap.stl)

#### Base Tray — exact mesh (`ttgo_cap_mesh.scad`)

| Front View | Rear View |
|------------|-----------|
| ![Front](https://github.com/JeremyProffitt/esp32-cases-stl/releases/latest/download/ttgo_cap_mesh_front.png) | ![Rear](https://github.com/JeremyProffitt/esp32-cases-stl/releases/latest/download/ttgo_cap_mesh_rear.png) |

**Documentation**: [ttgo_cap_mesh.md](TTGO-TM-ESP32-aka-TMusic/ttgo_cap_mesh.md)
· **Download STL**: [ttgo_cap_mesh.stl](https://github.com/JeremyProffitt/esp32-cases-stl/releases/latest/download/ttgo_cap_mesh.stl)

#### Front Bezel — parametric (`ttgo_body.scad`)

| Front View | Rear View |
|------------|-----------|
| ![Front](https://github.com/JeremyProffitt/esp32-cases-stl/releases/latest/download/ttgo_body_front.png) | ![Rear](https://github.com/JeremyProffitt/esp32-cases-stl/releases/latest/download/ttgo_body_rear.png) |

**Documentation**: [ttgo_body.md](TTGO-TM-ESP32-aka-TMusic/ttgo_body.md)
· **Download STL**: [ttgo_body.stl](https://github.com/JeremyProffitt/esp32-cases-stl/releases/latest/download/ttgo_body.stl)

#### Front Bezel — exact mesh (`ttgo_body_mesh.scad`)

| Front View | Rear View |
|------------|-----------|
| ![Front](https://github.com/JeremyProffitt/esp32-cases-stl/releases/latest/download/ttgo_body_mesh_front.png) | ![Rear](https://github.com/JeremyProffitt/esp32-cases-stl/releases/latest/download/ttgo_body_mesh_rear.png) |

**Documentation**: [ttgo_body_mesh.md](TTGO-TM-ESP32-aka-TMusic/ttgo_body_mesh.md)
· **Download STL**: [ttgo_body_mesh.stl](https://github.com/JeremyProffitt/esp32-cases-stl/releases/latest/download/ttgo_body_mesh.stl)
