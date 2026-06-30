# TTGO-TM ESP32 ("TMusic") - Top / Front Bezel

## Overview

`ttgo_body.scad` is an editable, constructive OpenSCAD rebuild of
`ttgo-body-2.stl`. It is not a triangle-exact copy. The source STL remains the
fit-check reference; this model turns the measured STL envelope and visible
openings into named positive and negative primitives.

The model starts with a positive rounded bounding shell and removes named
negative cutouts for the underside cavity, display window, four side control
slots, four small corner relief holes, and skirt alignment reliefs.

## Source Mesh

| Property | Value |
|----------|-------|
| File | `ttgo-body-2.stl` |
| Faces | 51,684 |
| Native min [X,Y,Z] mm | [-36.675, -44.4235, -3.540] |
| Native max [X,Y,Z] mm | [39.525, 5.1000, 11.460] |
| Normalized size [W,D,H] mm | [76.200, 49.5235, 15.000] |

The SCAD file uses normalized corner-origin coordinates. The validation overlay
imports the mesh and translates it by `-source_body_bbox_min_mm`.

## Coordinate System

```text
X = Width  (positive = right)
Y = Depth  (positive = back/away from viewer)
Z = Height (positive = up)

Origin: front-left-bottom corner of the normalized bezel bounding box.
```

## Dimensions

| Parameter | Value | Description |
|-----------|-------|-------------|
| **Source** | | |
| source_body_face_count | 51684 | STL face count from `trimesh` and OpenSCAD import checks |
| source_body_bbox_size_mm | [76.200, 49.5235, 15.000] | Mesh bounding-box size |
| **Global / Shared** | | |
| case_width_mm | 76.200 | Overall X envelope |
| case_depth_mm | 49.523 | Overall Y envelope |
| case_corner_radius_mm | 2.300 | Clean outer corner radius |
| case_inner_corner_radius_mm | 1.300 | Inner cavity corner radius |
| case_wall_thickness_mm | 2.500 | Nominal wall thickness target |
| case_fit_clearance_xy_mm | 0.250 | Named fit allowance for mating interfaces |
| case_epsilon_mm | 0.050 | Boolean anti-coincident-face offset |
| **top_bezel_positive_shell** | | |
| top_bezel_height_mm | 15.000 | Overall Z height |
| top_bezel_face_thickness_mm | 3.000 | Top face plate thickness |
| top_bezel_skirt_height_mm | 12.000 | Lower skirt height |
| **top_bezel_inner_cavity_cutout** | | |
| top_bezel_inner_cavity_x_mm | 2.900 | Cavity X origin |
| top_bezel_inner_cavity_y_mm | 2.400 | Cavity Y origin |
| top_bezel_inner_cavity_width_mm | 70.400 | Cavity X size |
| top_bezel_inner_cavity_depth_mm | 44.700 | Cavity Y size |
| **top_bezel_display_window_cutout** | | |
| display_window_x_mm | 15.200 | Window X origin |
| display_window_y_mm | 5.600 | Window Y origin |
| display_window_width_mm | 51.500 | Window X size |
| display_window_depth_mm | 38.400 | Window Y size |
| display_window_corner_radius_mm | 0.800 | Clean corner radius |
| **top_bezel_side_control_slot_cutouts** | | |
| side_control_slot_count | 4 | Number of rounded side slots observed in top slices |
| side_control_slot_x_mm | 2.750 | Slot X origin |
| side_control_slot_first_y_mm | 12.100 | First slot Y origin |
| side_control_slot_pitch_mm | 7.600 | Y pitch |
| side_control_slot_width_mm | 8.700 | Slot X size |
| side_control_slot_depth_mm | 5.900 | Slot Y size |
| side_control_slot_radius_mm | 2.700 | Slot end radius |
| **top_bezel_corner_relief_hole_cutouts** | | |
| corner_relief_hole_diameter_mm | 1.900 | Small relief hole diameter |
| corner_relief_hole_left_x_mm / right_x_mm | 6.200 / 70.850 | Hole X centers |
| corner_relief_hole_front_y_mm / back_y_mm | 5.300 / 44.350 | Hole Y centers |
| **top_bezel_skirt_alignment_relief_cutouts** | | |
| skirt_relief_width_mm | 8.000 | Front/back skirt notch width |
| skirt_relief_depth_mm | 1.400 | Front/back skirt notch depth |
| skirt_relief_height_mm | 2.500 | Lower skirt notch height |

## Color Key

`see_in_color` defaults to `1` in `ttgo_body.scad`, so OpenSCAD Preview (`F5`)
shows the shell and cutout volumes by color when the file is opened manually.
Set `see_in_color = 0` for the printable boolean result; the project build
scripts force that value for generated STL/PNG artifacts. The cutouts are voids
in the printable model, so they cannot remain separately colored. Colors are
preview aids only; exported STL files do not retain them.

| Color | Section Name | Meaning |
|-------|--------------|---------|
| Gold | `top_bezel_positive_shell` | Starting positive bezel body |
| Dodger blue | `top_bezel_inner_cavity_cutout` | Underside hollow cavity removed from the shell |
| Lime green | `top_bezel_display_window_cutout` | Display window through-cut |
| Magenta | `top_bezel_side_control_slot_cutouts` | Four side control / access slots |
| Red | `top_bezel_corner_relief_hole_cutouts` | Four small corner relief holes |
| Cyan | `top_bezel_skirt_alignment_relief_cutouts` | Lower skirt and side relief notches |
| Orange | `validation_source_mesh` | Source STL overlay in validation mode |

## Component Diagram

### Top View (looking down, -Z)

```text
        +Y (back)
           ^
    +--o---------------------------o--+
    | [slot]  +-------------------+   |
    | [slot]  |                   |   |
    | [slot]  |   display window  |   |
    | [slot]  |                   |   |
    |         +-------------------+   |
    +--o---------------------------o--+ --> +X
   /
  Origin [0,0]
```

### Side View (looking from right, -X)

```text
        +Z
         ^
    +----+------------------+  top face with window/slots/holes
    |                       |
    |       hollow skirt    |
    |                       |
    +---[small reliefs]-----+ --> +Y
   z=0
```

## Components

### top_bezel_positive_shell

- Purpose: Main printable mass of the top/front bezel.
- Position: Origin `[0,0,0]`.
- Bounding box: `[0,0,0]` to `[76.2,49.523,15]`.
- Construction: Rounded rectangular prism.

### top_bezel_inner_cavity_cutout

- Purpose: Opens the underside while preserving a 3 mm top face.
- Position: `[2.9,2.4,-0.05]`.
- Bounding box: approximately `[2.9,2.4,-0.05]` to `[73.3,47.1,12.05]`.

### top_bezel_display_window_cutout

- Purpose: Main display aperture.
- Position: `[15.2,5.6,11.95]`.
- Bounding box: approximately `[15.2,5.6,11.95]` to `[66.7,44.0,15.55]`.

### top_bezel_side_control_slot_cutouts

- Purpose: Four rounded rectangular side openings visible in upper mesh
  cross-sections.
- Position: left-side top face region.
- Approximate slot size: `[8.7,5.9,thru]`.

### top_bezel_corner_relief_hole_cutouts

- Purpose: Four small holes near the top-face corners. They are named
  generically because the STL does not reveal whether they are screw,
  locating, or manufacturing relief features.
- Diameter: `1.9 mm`.

### top_bezel_skirt_alignment_relief_cutouts

- Purpose: Small notches in the lower skirt and left slot wall region.
- Position: lower skirt edges and left-side slot edge.

## Debug And Validation Modules

| Module | Purpose |
|--------|---------|
| `debug_axes(length_mm)` | Shows RGB XYZ axes |
| `debug_bounds()` | Shows normalized bounding box |
| `debug_positive_only()` | Shows the starting positive shell |
| `debug_negative_only()` | Shows all cutout volumes |
| `debug_cutouts()` | Overlays positive shell and negative volumes |
| `color_key_preview()` | Shows the named color key geometry |
| `debug_section_x(x_mm)` | Thin X section |
| `debug_section_y(y_mm)` | Thin Y section |
| `validation_source_mesh()` | Imports and normalizes the source STL |
| `validation_overlay()` | Overlays rebuild and source mesh |
| `assembly_colored()` | Colored part view |
| `assembly_exploded(separation_mm)` | Exploded-position helper |

## Assembly Notes

- Mates with `ttgo_cap.scad` / `ttgo_base_tray()`.
- The original mesh and rebuild should be compared with `validation_overlay()`
  before printing.
- Print orientation depends on whether face quality or support avoidance matters
  more. Face-down gives a cleaner visible face; skirt-down reduces top-face bed
  contact marks but may need support for openings.
- Recommended material: PLA or PETG.

## Known Approximations

- Organic CATIA fillets were simplified to clean rounded rectangles.
- The four side slots are modeled from slice measurements rather than recovered
  CAD history.
- The lower skirt reliefs are functional approximations of repeated mesh edge
  breaks.

## Changelog

| Date | Change |
|------|--------|
| 2026-06-30 | Rebuilt as explicit positive shell plus named negative cutouts; corrected slot count to four; added validation modules |
