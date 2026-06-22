# TTGO-TM ESP32 ("TMusic") — Front Bezel (Parametric)

## Overview

Editable, parametric **approximation** of the front bezel of the TTGO-TM
ESP32 "TMusic" enclosure, hand-modelled from OpenSCAD primitives in
[`ttgo_body.scad`](ttgo_body.scad).

This is **not geometry-exact** — the source part is a dense organic CATIA mesh
(~54k triangles). For an exact reproduction, use the import wrapper
[`ttgo_body_mesh.scad`](ttgo_body_mesh.scad) / [`ttgo_body_mesh.md`](ttgo_body_mesh.md),
which loads the original STL verbatim.

The bezel is a rounded-rectangle frame with a top face plate carrying a large
rectangular **display window**, a row of five **finger / speaker slots** plus a
round **button hole** on the right short edge, and two **side ports** cut into
the front long wall. The outer walls below the face form a skirt that seats
into the cap's rim.

## Dimensions

| Parameter | Value | Description |
|-----------|-------|-------------|
| **Global / Shared** | | |
| case_width_mm | 76.2 | Outer width (X) |
| case_depth_mm | 49.5 | Outer depth (Y) |
| corner_radius_mm | 3 | Outer vertical corner radius |
| wall_thickness_mm | 2.5 | Common wall thickness |
| **bezel_shell** | | |
| bezel_height_mm | 15 | Total height (Z) |
| bezel_face_mm | 3 | Top face-plate thickness |
| bezel_skirt_mm | 12 | Outer skirt height below face (mates cap) |
| **display_window** | | |
| display_window_width_mm | 44 | Window X size |
| display_window_depth_mm | 41.5 | Window Y size |
| display_window_x_mm | 4 | Window origin X |
| display_window_y_mm | 4 | Window origin Y |
| **finger_slots** | | |
| finger_slot_count | 5 | Number of slots |
| finger_slot_width_mm | 2.4 | Slot X width |
| finger_slot_length_mm | 9 | Slot Y length |
| finger_slot_pitch_mm | 4.6 | Centre-to-centre spacing |
| finger_slot_x0_mm | 55 | X centre of first slot |
| finger_slot_y_mm | 30 | Y centre of the slot row |
| **button_hole** | | |
| button_hole_diameter_mm | 5 | Button opening diameter |
| button_hole_x_mm | 67 | X centre |
| button_hole_y_mm | 14 | Y centre |
| **side_ports** | | |
| side_port_width_mm | 11 | Port X length |
| side_port_height_mm | 6 | Port Z height |
| side_port_z_mm | 2 | Port bottom Z |
| side_port_x1_mm / x2_mm | 14 / 34 | Port X centres |

## Component Diagram

### Top View (looking down, -Z)

```
        +Y (back)
           ^
    +------+---------------------------+
    |                                  |
    |   +---------------+    ||||| <-- finger slots
    |   |   display     |    o    <--- button hole
    |   |   window      |              |
    |   +---------------+              |
    +---[port]---[port]----------------+ --> +X (right)
   /
  Origin [0,0]   (ports cut into front long wall, y=0)
```

### Side View (looking from right, -X)

```
        +Z (up)
           ^
    +------+------------------+   <- top face plate (window/slots cut here)
    |                         |
    |      (hollow skirt)     |   <- outer walls seat into cap rim
    +------+------------------+ --> +Y (back)
   z=0
```

## Components

### bezel_shell
- **Purpose**: Front frame / face of the enclosure
- **Position**: Origin [0, 0, 0]
- **Bounding Box**: [0,0,0] to [76.2, 49.5, 15]
- Solid rounded outer shell, hollowed from below leaving a 3 mm face plate;
  the surrounding outer walls form the mating skirt.

### display_window
- **Purpose**: Opening for the LCD / TFT display
- Rectangular (rounded corners) through-cut in the face plate.

### finger_slots (×5)
- **Purpose**: Speaker / vent slots
- Rounded-end vertical slots through the face on the right panel.

### button_hole
- **Purpose**: Push-button opening
- Round through-hole on the right panel.

### side_ports (×2)
- **Purpose**: USB / SD / power edge access
- Rectangular cut-outs through the front long wall.

## Assembly Notes

- Mates with [`ttgo_cap.scad`](ttgo_cap.md) — the bezel skirt drops into the
  cap's rim rabbet.
- Print orientation: face plate down (window side on the bed) for the cleanest
  visible surface, or skirt down with supports for the ports.
- Recommended infill: 20%. Material: PLA or PETG.
- **Approximation caveat**: slot/port/window placements are estimated from
  mesh cross-sections; verify against the real device or the mesh wrapper
  before committing to a print.

## Changelog

| Date | Change |
|------|--------|
| 2026-06-22 | Initial parametric rebuild from ttgo-body-2.stl |
