# STL To OpenSCAD Conversion Notes

## Purpose

This document records how the TTGO-TM ESP32 ("TMusic") STL files in this folder
were converted into editable OpenSCAD approximations.

The goal was not to reproduce every triangle. STL files do not contain the
original CAD feature tree, sketch constraints, or boolean history. The practical
goal was to identify the functional envelope, openings, cavities, lips, rims,
and support features, then rebuild them with clean named OpenSCAD primitives.

## Files Converted

| Source STL | New Parametric SCAD | Functional Name |
|------------|---------------------|-----------------|
| `ttgo-body-2.stl` | `ttgo_body.scad` | `ttgo_top_bezel()` |
| `ttgo-cap-2.stl` | `ttgo_cap.scad` | `ttgo_base_tray()` |

Backward-compatible module names were retained:

- `ttgo_body()` calls `ttgo_top_bezel()`.
- `ttgo_cap()` calls `ttgo_base_tray()`.

## Guidance Used

The process followed `C:\dev\esp32-cases-stl\CLAUDE.md`:

- Document the coordinate system at the top of each SCAD file.
- Use named `*_mm` constants for all measurements.
- Keep each component or cutout in its own module.
- Include a component index table.
- Add module comments with position, bounding box, alignment, and connection
  notes.
- Provide connection interface functions.
- Provide debug and validation modules.
- Keep matching Markdown documentation next to each SCAD file.

## Measurement Method

The STLs were inspected with Python `trimesh` and section plots:

```powershell
python - <<'PY'
import trimesh
for file in ["ttgo-body-2.stl", "ttgo-cap-2.stl"]:
    mesh = trimesh.load_mesh(file, process=True)
    print(file, len(mesh.faces), mesh.bounds, mesh.extents, mesh.is_watertight)
PY
```

Additional XY section images were generated at representative Z heights and
saved in `analysis_slices/`.

Measured source facts:

| Part | Faces | Native min [X,Y,Z] | Native max [X,Y,Z] | Size [W,D,H] |
|------|-------|--------------------|--------------------|--------------|
| Top bezel | 51,684 | [-36.675, -44.4235, -3.540] | [39.525, 5.1000, 11.460] | [76.200, 49.5235, 15.000] |
| Base tray | 54,112 | [-36.675, -44.4235, -20.290] | [39.525, 5.1000, 1.860] | [76.200, 49.5235, 22.150] |

The earlier mesh Markdown had the face counts swapped; the docs now reflect the
actual loaded files.

## Coordinate Normalization

The original CATIA-exported meshes use native coordinates with the origin inside
or near the assembly. The parametric SCAD files use the project convention:

```text
X = width
Y = depth
Z = height
Origin = front-left-bottom corner of each normalized part
```

Normalization is:

```text
normalized_point = native_point - source_bbox_min
```

The validation modules reverse this by importing the STL and applying:

```openscad
translate(-source_*_bbox_min_mm)
    import(source_*_mesh_file, convexity = 10);
```

## Reconstruction Strategy

Each part was rebuilt using the same pattern:

1. Start with a positive rounded rectangular bounding block matching the STL
   length, width, and height.
2. Subtract named negative cutouts for cavities and openings.
3. Add positive support features only when they are functional and visible in
   multiple sections.
4. Preserve the exact STL import as a validation overlay, not as the default
   model.

This makes the SCAD files readable as manufacturing recipes instead of opaque
polyhedron dumps.

## Top Bezel Feature Decisions

The top bezel was rebuilt around these named features:

- `top_bezel_positive_shell()`: full `76.2 x 49.523 x 15 mm` rounded shell.
- `top_bezel_inner_cavity_cutout()`: underside cavity leaving a 3 mm top face.
- `top_bezel_display_window_cutout()`: large display aperture measured from
  high-Z sections, about `51.5 x 38.4 mm`.
- `top_bezel_side_control_slot_cutouts()`: four rounded rectangular openings.
- `top_bezel_corner_relief_hole_cutouts()`: four small 1.9 mm holes near the
  top-face corners.
- `top_bezel_skirt_alignment_relief_cutouts()`: small inside-wall lower skirt
  reliefs.

Important correction: the previous approximation used five narrow slots. The
source mesh sections show four larger rounded slots, so the rebuild uses four.

## Base Tray Feature Decisions

The base tray was rebuilt around these named features:

- `base_tray_outer_block()`: full `76.2 x 49.523 x 22.15 mm` rounded shell.
- `base_tray_inner_cavity_cutout()`: main electronics cavity, starting above a
  1.75 mm floor.
- `base_tray_rim_rabbet_cutout()`: top perimeter rabbet, approximately 5.4 mm
  high, used by the bezel skirt.
- `base_tray_support_lugs_positive()`: four discrete lugs near the upper rim.
- `base_tray_left_wall_connector_relief_cutouts()`: two left-wall reliefs at
  the upper rim.

Important correction: the previous approximation used continuous PCB rails. The
source sections show discrete support/lug blocks, so the rebuild models those
instead.

## Validation Performed

OpenSCAD was found at:

```text
C:\Program Files\OpenSCAD\openscad.exe
```

Both files were exported through OpenSCAD:

```powershell
& 'C:\Program Files\OpenSCAD\openscad.exe' -o .\build\ttgo_body_test.stl .\ttgo_body.scad
& 'C:\Program Files\OpenSCAD\openscad.exe' -o .\build\ttgo_cap_test.stl .\ttgo_cap.scad
```

The generated STL files were then checked with `trimesh`:

| Generated STL | Watertight | Connected Components | Extents |
|---------------|------------|----------------------|---------|
| `build/ttgo_body_test.stl` | yes | 1 | [76.2, 49.523, 15.0] |
| `build/ttgo_cap_test.stl` | yes | 1 | [76.2, 49.523, 22.15] |

Preview PNGs were also rendered with OpenSCAD:

```powershell
& 'C:\Program Files\OpenSCAD\openscad.exe' --autocenter --viewall --imgsize=1200,900 --camera=0,0,0,55,0,45,0 -o .\build\ttgo_body_preview.png .\ttgo_body.scad
& 'C:\Program Files\OpenSCAD\openscad.exe' --autocenter --viewall --imgsize=1200,900 --camera=0,0,0,55,0,45,0 -o .\build\ttgo_cap_preview.png .\ttgo_cap.scad
```

## How To Inspect In OpenSCAD

Open either file in OpenSCAD:

- `ttgo_body.scad`
- `ttgo_cap.scad`

At the bottom of each SCAD file, use:

```openscad
see_in_color = 1; // colored manual preview
```

Primary display toggle:

| Variable | Meaning |
|----------|---------|
| `see_in_color = 0` | Printable model view and STL export; forced by `build.sh` and `build.bat` |
| `see_in_color = 1` | Default manual view; color-coded positive/support/cutout preview for OpenSCAD Preview/F5 |

Advanced debug modes are available through `debug_view_mode` when
`see_in_color = 0`:

| Mode | Meaning |
|------|---------|
| `"model"` | Default rebuilt parametric part for printable STL export |
| `"overlay"` | Rebuilt part over the normalized source STL |
| `"cutouts"` | Positive shell plus visible negative volumes |
| `"positive"` | Positive starting geometry only |
| `"section_x"` | Thin X section |
| `"section_y"` | Thin Y section |

## Remaining Judgment Calls

The following details should be verified against the real board before final
printing:

- Whether the four small top holes are screw holes, locating holes, or reliefs.
- Exact connector clearance needs on the left wall and lower skirt.
- Whether the support lugs should be widened or lowered for the actual PCB.
- Preferred fit clearance between the bezel skirt and base tray rim.

## Summary

The final SCAD files are now editable constructive models instead of mesh
imports or polyhedron dumps. The source STLs remain available through the mesh
wrapper files for exact reference and overlay validation.
