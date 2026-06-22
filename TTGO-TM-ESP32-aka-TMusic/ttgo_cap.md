# TTGO-TM ESP32 ("TMusic") — Base Tray (Parametric)

## Overview

Editable, parametric **approximation** of the base tray of the TTGO-TM ESP32
"TMusic" enclosure, hand-modelled from OpenSCAD primitives in
[`ttgo_cap.scad`](ttgo_cap.scad).

> **Naming note:** the source file is called *cap*, but the part is actually
> the deep **base tray** (the box the electronics sit in), not a lid.

This is **not geometry-exact** — the source part is a dense organic CATIA mesh
(~52k triangles). For an exact reproduction, use the import wrapper
[`ttgo_cap_mesh.scad`](ttgo_cap_mesh.scad) / [`ttgo_cap_mesh.md`](ttgo_cap_mesh.md).

The tray is a deep rounded-rectangle box with constant-thickness walls and
floor, two internal **PCB slide-rails** on the long walls, a stepped **rim
rabbet** around the top edge that the bezel seats into, and a small **notch**
in one rim corner for a cable / connector.

## Dimensions

| Parameter | Value | Description |
|-----------|-------|-------------|
| **Global / Shared** | | |
| case_width_mm | 76.2 | Outer width (X) |
| case_depth_mm | 49.5 | Outer depth (Y) |
| corner_radius_mm | 3 | Outer vertical corner radius |
| wall_thickness_mm | 2.5 | Common wall thickness |
| **tray_shell** | | |
| tray_height_mm | 22.15 | Total height (Z) |
| tray_floor_mm | 2.5 | Floor thickness |
| **rim_rabbet** | | |
| rim_height_mm | 5 | Rim region height from top |
| rim_step_mm | 1.5 | Outer step-in at the rim |
| **pcb_rails** | | |
| pcb_rail_length_mm | 30 | Rail X length |
| pcb_rail_thick_mm | 1.5 | Rail Y protrusion |
| pcb_rail_height_mm | 1.5 | Rail Z height |
| pcb_rail_z_mm | 12 | Rail underside Z |
| pcb_rail_x_mm | 23 | Rail start X |
| **corner_notch** | | |
| corner_notch_width_mm | 6 | Notch X width |
| corner_notch_depth_mm | 5 | Notch Z depth from rim top |

## Component Diagram

### Top View (looking down, -Z, into the open tray)

```
        +Y (back)
           ^
    +------+--------------------[notch]-+
    |  ___________________________      |
    | |                           |     |
    | |   inner cavity     ====== | <-- pcb rail (rear wall)
    | |   ====== <-- pcb rail     |     |
    | |___________________________|     |
    +----------------------------------+ --> +X (right)
   /
  Origin [0,0]
```

### Side View (looking from right, -X)

```
        +Z (up)
           ^
    +------+--+   <- rim rabbet (step the bezel drops into)
    |  cavity |
    |         |
    |         |   <- walls (wall_thickness_mm)
    +---------+
    |  floor  |   <- tray_floor_mm
    +------+--+ --> +Y (back)
   z=0
```

## Components

### tray_shell
- **Purpose**: Box that houses the PCB / battery
- **Position**: Origin [0, 0, 0]
- **Bounding Box**: [0,0,0] to [76.2, 49.5, 22.15]
- Solid rounded outer shell, hollowed to leave walls + floor, with a rabbet
  cut around the top outer edge.

### rim_rabbet
- **Purpose**: Recessed ledge the bezel skirt seats into
- A thin outer ring removed from the top `rim_height_mm` of the wall.

### pcb_rails (×2)
- **Purpose**: Slide guides / supports for the PCB
- Thin ribs on the inner faces of both long walls.

### corner_notch
- **Purpose**: Cable / connector relief
- A cut in the rear-right rim corner.

## Assembly Notes

- Mates with [`ttgo_body.scad`](ttgo_body.md) — the bezel skirt drops into the
  rim rabbet.
- Print orientation: floor down (open mouth up). No supports needed.
- Recommended infill: 20%. Material: PLA or PETG.
- **Approximation caveat**: wall thickness, rail placement and rim step are
  estimated from mesh cross-sections; verify against the real device or the
  mesh wrapper before printing.

## Changelog

| Date | Change |
|------|--------|
| 2026-06-22 | Initial parametric rebuild from ttgo-cap-2.stl |
