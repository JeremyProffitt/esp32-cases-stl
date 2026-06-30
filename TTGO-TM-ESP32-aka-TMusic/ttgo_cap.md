# TTGO-TM ESP32 ("TMusic") - Base Tray

## Overview

`ttgo_cap.scad` is an editable, constructive OpenSCAD rebuild of
`ttgo-cap-2.stl`. The source file name says "cap", but the part is the deep
base tray that holds the electronics and accepts the top/front bezel.

The model starts from the full positive bounding block, removes the main cavity
and rim rabbet as named negative cutouts, then adds discrete support/lug blocks
near the upper inner rim.

## Source Mesh

| Property | Value |
|----------|-------|
| File | `ttgo-cap-2.stl` |
| Faces | 54,112 |
| Native min [X,Y,Z] mm | [-36.675, -44.4235, -20.290] |
| Native max [X,Y,Z] mm | [39.525, 5.1000, 1.860] |
| Normalized size [W,D,H] mm | [76.200, 49.5235, 22.150] |

The SCAD file uses normalized corner-origin coordinates. The validation overlay
imports the mesh and translates it by `-source_cap_bbox_min_mm`.

## Coordinate System

```text
X = Width  (positive = right)
Y = Depth  (positive = back/away from viewer)
Z = Height (positive = up)

Origin: front-left-bottom corner of the normalized tray bounding box.
```

## Dimensions

| Parameter | Value | Description |
|-----------|-------|-------------|
| **Source** | | |
| source_cap_face_count | 54112 | STL face count from `trimesh` and OpenSCAD import checks |
| source_cap_bbox_size_mm | [76.200, 49.5235, 22.150] | Mesh bounding-box size |
| **Global / Shared** | | |
| case_width_mm | 76.200 | Overall X envelope |
| case_depth_mm | 49.523 | Overall Y envelope |
| case_corner_radius_mm | 2.300 | Clean outer corner radius |
| case_inner_corner_radius_mm | 0.800 | Inner cavity corner radius |
| case_wall_thickness_mm | 2.500 | Nominal wall thickness target |
| case_fit_clearance_xy_mm | 0.250 | Per-side fit clearance |
| case_fit_clearance_z_mm | 0.200 | Seating clearance |
| case_epsilon_mm | 0.050 | Boolean anti-coincident-face offset |
| **base_tray_outer_block** | | |
| base_tray_height_mm | 22.150 | Overall tray height |
| base_tray_floor_thickness_mm | 1.750 | Floor thickness inferred from low-Z sections |
| **base_tray_inner_cavity_cutout** | | |
| base_tray_inner_cavity_x_mm | 5.250 | Cavity X origin |
| base_tray_inner_cavity_y_mm | 4.250 | Cavity Y origin |
| base_tray_inner_cavity_width_mm | 66.700 | Cavity X size |
| base_tray_inner_cavity_depth_mm | 41.000 | Cavity Y size |
| **base_tray_rim_rabbet_cutout** | | |
| base_tray_rim_height_mm | 5.400 | Upper rim/rabbet height |
| base_tray_rim_inset_x_mm | 3.700 | Inset rim X origin |
| base_tray_rim_inset_y_mm | 2.700 | Inset rim Y origin |
| base_tray_rim_width_mm | 69.800 | Inset rim X size |
| base_tray_rim_depth_mm | 44.100 | Inset rim Y size |
| **support_lugs** | | |
| support_lug_z_mm | 18.100 | Lug bottom Z |
| support_lug_height_mm | 3.300 | Lug height |
| support_lug_depth_mm | 2.200 | Lug Y protrusion |
| front_support_lug_specs_mm | [[13.8,14.2],[49.0,14.2]] | Front-side lug X origins and widths |
| rear_support_lug_specs_mm | [[23.8,6.4],[56.0,8.5]] | Rear-side lug X origins and widths |
| **base_tray_left_wall_connector_relief_cutouts** | | |
| left_wall_relief_centers_y_mm | [18.2,36.8] | Y centers for left wall reliefs |
| left_wall_relief_width_mm | 4.000 | X cut depth through left wall |
| left_wall_relief_depth_mm | 7.200 | Y relief size |
| left_wall_relief_height_mm | 8.500 | Z relief size |

## Color Key

Set `render_mode = "color_key"` in `ttgo_cap.scad` and use OpenSCAD Preview
(`F5`) to show the shell, support lugs, and cutout volumes by color. The
default `render_mode = "model"` is the printable boolean result; the cutouts
are voids there, so they cannot remain separately colored. The magenta support
lugs are lifted upward only in this preview mode so they are not hidden inside
the rim. Colors are preview aids only; exported STL files do not retain them.

| Color | Section Name | Meaning |
|-------|--------------|---------|
| Gold | `base_tray_outer_block` | Starting positive tray body |
| Dodger blue | `base_tray_inner_cavity_cutout` | Main electronics cavity removed from the tray |
| Lime green | `base_tray_rim_rabbet_cutout` | Rim rabbet removed to form the bezel seat |
| Magenta | `base_tray_support_lugs_positive` | Positive support / latch / PCB-location lugs |
| Red | `base_tray_left_wall_connector_relief_cutouts` | Upper left-wall connector relief cutouts |
| Orange | `validation_source_mesh` | Source STL overlay in validation mode |

## Component Diagram

### Top View (looking down, -Z, into the open tray)

```text
        +Y (back)
           ^
    +------+---------------------------+
    |     [rear lug]        [rear lug] |
    |  +-----------------------------+ |
    |  |                             | |
    |  |        inner cavity         | |
    |  |                             | |
    |  +-----------------------------+ |
    |   [front lug]       [front lug]  |
    +--[relief]-----------[relief]-----+ --> +X
   /
  Origin [0,0]
```

### Side View (looking from right, -X)

```text
        +Z
         ^
    +----+---------+  inset upper rim / rabbet
    |    cavity    |
    |              |
    |              |
    +--------------+
    |    floor     |
    +--------------+ --> +Y
   z=0
```

## Components

### base_tray_outer_block

- Purpose: Overall positive rounded bounding block.
- Position: Origin `[0,0,0]`.
- Bounding box: `[0,0,0]` to `[76.2,49.523,22.15]`.

### base_tray_inner_cavity_cutout

- Purpose: Main hollow electronics volume.
- Position: `[5.25,4.25,1.75]`.
- Bounding box: approximately `[5.25,4.25,1.75]` to `[71.95,45.25,22.65]`.

### base_tray_rim_rabbet_cutout

- Purpose: Removes the outer top ring to form the inset ledge that receives
  the bezel skirt.
- Z range: approximately `[16.75,22.15]`.
- Functional interface: `base_tray_rim_seat_size_mm()`.

### base_tray_support_lugs_positive

- Purpose: Four discrete support/latch/PCB-locating pads near the upper rim.
- Z range: `[18.1,21.4]`.
- These replace the earlier single continuous rail approximation.

### base_tray_left_wall_connector_relief_cutouts

- Purpose: Two upper left-wall reliefs visible in high-Z source sections.
- These are modeled as clean rectangular cutouts because the STL does not
  expose original CAD feature history.

## Debug And Validation Modules

| Module | Purpose |
|--------|---------|
| `debug_axes(length_mm)` | Shows RGB XYZ axes |
| `debug_bounds()` | Shows normalized bounding box |
| `debug_positive_only()` | Shows the outer block plus lug positives |
| `debug_negative_only()` | Shows all cutout volumes |
| `debug_cutouts()` | Overlays positive and negative volumes |
| `color_key_preview()` | Shows the named color key geometry |
| `debug_section_x(x_mm)` | Thin X section |
| `debug_section_y(y_mm)` | Thin Y section |
| `validation_source_mesh()` | Imports and normalizes the source STL |
| `validation_overlay()` | Overlays rebuild and source mesh |
| `assembly_colored()` | Colored part view |
| `assembly_exploded(separation_mm)` | Exploded-position helper |

## Assembly Notes

- Mates with `ttgo_body.scad` / `ttgo_top_bezel()`.
- The rim seat includes named XY and Z clearances rather than hidden offsets.
- Print orientation: floor down, open mouth up.
- Recommended material: PLA or PETG.

## Known Approximations

- CATIA fillets and small organic transitions are simplified to clean radii.
- The rim/lug geometry is modeled from mesh slices, not recovered CAD history.
- Connector reliefs are named functionally but should be verified against the
  physical board before relying on them for final connector clearance.

## Changelog

| Date | Change |
|------|--------|
| 2026-06-30 | Rebuilt as explicit constructive tray with rim rabbet, discrete support lugs, named reliefs, and validation modules |
