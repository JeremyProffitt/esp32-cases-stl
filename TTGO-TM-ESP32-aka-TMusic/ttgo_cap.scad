/**
 * TTGO-TM ESP32 ("TMusic") - BASE TRAY
 * Parametric constructive rebuild from ttgo-cap-2.stl.
 *
 * The source file uses "cap", but the part is the deep base tray. This model
 * starts with the overall rounded bounding block, removes the main cavity and
 * rim rabbet as named negative cutouts, and adds discrete support/lug blocks
 * observed in high-Z mesh cross-sections.
 *
 * Coordinate System:
 *   X = Width  (positive = right)
 *   Y = Depth  (positive = back/away from viewer)
 *   Z = Height (positive = up)
 *
 * Origin: Front-left-bottom corner of the normalized tray bounding box.
 *
 * ===========================================
 * COMPONENT INDEX
 * ===========================================
 *
 * | Component                     | Preview Color | Origin [X,Y,Z] | Size [W,D,H]        | Attaches To      |
 * |-------------------------------|---------------|----------------|---------------------|------------------|
 * | base_tray_outer_block         | gold          | [0,0,0]        | [76.2,49.523,22.15] | ground / print   |
 * | base_tray_inner_cavity        | dodgerblue    | [5.25,4.25,1.75]| [66.7,41.0,thru]   | negative cutout  |
 * | base_tray_rim_rabbet          | limegreen     | top perimeter  | 5.4 high            | bezel skirt      |
 * | support_lugs (x4)             | magenta       | inner rim      | variable            | PCB / latch area |
 * | left_wall_connector_reliefs   | red           | left wall      | variable            | negative cutout  |
 */

// ===========================================
// DIMENSIONS (all values in millimeters)
// ===========================================

// --- Source mesh facts ---
source_cap_mesh_file = "ttgo-cap-2.stl";
source_cap_bbox_min_mm = [-36.675, -44.4235, -20.290];
source_cap_bbox_max_mm = [ 39.525,   5.1000,   1.860];
source_cap_bbox_size_mm = [76.200, 49.5235, 22.150];
source_cap_face_count = 54112;

// --- Global / shared case dimensions ---
case_width_mm = 76.200;
case_depth_mm = 49.523;
case_corner_radius_mm = 2.300;
case_inner_corner_radius_mm = 0.800;
case_wall_thickness_mm = 2.500;
case_fit_clearance_xy_mm = 0.250;
case_fit_clearance_z_mm = 0.200;
case_epsilon_mm = 0.050;
case_cut_overshoot_mm = 0.500;

// --- base_tray_outer_block dimensions ---
base_tray_height_mm = 22.150;
base_tray_floor_thickness_mm = 1.750;

// --- base_tray_inner_cavity_cutout dimensions ---
base_tray_inner_cavity_x_mm = 5.250;
base_tray_inner_cavity_y_mm = 4.250;
base_tray_inner_cavity_width_mm = 66.700;
base_tray_inner_cavity_depth_mm = 41.000;

// --- base_tray_rim_rabbet_cutout dimensions ---
base_tray_rim_height_mm = 5.400;
base_tray_rim_inset_x_mm = 3.700;
base_tray_rim_inset_y_mm = 2.700;
base_tray_rim_width_mm = 69.800;
base_tray_rim_depth_mm = 44.100;
base_tray_rim_corner_radius_mm = 1.600;

// --- support_lugs dimensions ---
support_lug_height_mm = 3.300;
support_lug_z_mm = 18.100;
support_lug_depth_mm = 2.200;
support_lug_corner_radius_mm = 0.400;
front_support_lug_specs_mm = [
    [13.800, 14.200],
    [49.000, 14.200]
];
rear_support_lug_specs_mm = [
    [23.800,  6.400],
    [56.000,  8.500]
];

// --- left_wall_connector_relief_cutouts dimensions ---
left_wall_relief_x_mm = -case_epsilon_mm;
left_wall_relief_width_mm = 4.000;
left_wall_relief_height_mm = 8.500;
left_wall_relief_z_mm = base_tray_height_mm - left_wall_relief_height_mm;
left_wall_relief_depth_mm = 7.200;
left_wall_relief_centers_y_mm = [18.200, 36.800];

// --- Preview colors (used only by debug/color-key render modes) ---
color_base_tray_outer_block = "gold";
color_inner_cavity_cutout = "dodgerblue";
color_rim_rabbet_cutout = "limegreen";
color_support_lugs = "magenta";
color_left_wall_connector_reliefs = "red";
color_source_mesh_overlay = "orange";

$fn = 64;

// ===========================================
// HELPERS
// ===========================================

module rounded_rect_2d(width_mm, depth_mm, radius_mm) {
    effective_radius_mm = min(radius_mm, min(width_mm, depth_mm) / 2);
    hull() {
        translate([effective_radius_mm, effective_radius_mm])
            circle(r = effective_radius_mm);
        translate([width_mm - effective_radius_mm, effective_radius_mm])
            circle(r = effective_radius_mm);
        translate([effective_radius_mm, depth_mm - effective_radius_mm])
            circle(r = effective_radius_mm);
        translate([width_mm - effective_radius_mm, depth_mm - effective_radius_mm])
            circle(r = effective_radius_mm);
    }
}

module rounded_box(width_mm, depth_mm, height_mm, radius_mm) {
    linear_extrude(height = height_mm)
        rounded_rect_2d(width_mm, depth_mm, radius_mm);
}

// ===========================================
// POSITIVE GEOMETRY
// ===========================================

/**
 * Base Tray Outer Block
 *
 * POSITION:
 *   Origin: [0,0,0]
 *
 * BOUNDING BOX:
 *   Min: [0,0,0]
 *   Max: [76.2,49.523,22.15]
 *
 * ALIGNMENT:
 *   The normalized source mesh bounding-box minimum maps to this origin.
 *
 * CONNECTS TO:
 *   - top bezel skirt through the rim rabbet.
 */
module base_tray_outer_block() {
    rounded_box(case_width_mm, case_depth_mm, base_tray_height_mm,
                case_corner_radius_mm);
}

/**
 * Base Tray Support Lugs
 *
 * POSITION:
 *   Four discrete raised blocks near the upper inner rim.
 *
 * BOUNDING BOX:
 *   z range: [18.1,21.4].
 *
 * ALIGNMENT:
 *   The blocks are added after the cavity/rabbet are cut so they remain as
 *   functional pads inside the tray.
 *
 * CONNECTS TO:
 *   - PCB edge / bezel latch region inferred from source sections.
 */
module base_tray_support_lugs_positive() {
    for (lug_spec = front_support_lug_specs_mm) {
        translate([lug_spec[0],
                   base_tray_inner_cavity_y_mm - support_lug_depth_mm,
                   support_lug_z_mm])
            rounded_box(lug_spec[1],
                        support_lug_depth_mm,
                        support_lug_height_mm,
                        support_lug_corner_radius_mm);
    }

    for (lug_spec = rear_support_lug_specs_mm) {
        translate([lug_spec[0],
                   base_tray_inner_cavity_y_mm + base_tray_inner_cavity_depth_mm,
                   support_lug_z_mm])
            rounded_box(lug_spec[1],
                        support_lug_depth_mm,
                        support_lug_height_mm,
                        support_lug_corner_radius_mm);
    }
}

// ===========================================
// NEGATIVE CUTOUTS
// ===========================================

module base_tray_shell_negative_cutouts() {
    base_tray_inner_cavity_cutout();
    base_tray_rim_rabbet_cutout();
}

module base_tray_final_negative_cutouts() {
    base_tray_left_wall_connector_relief_cutouts();
}

/**
 * Inner Cavity Cutout
 *
 * POSITION:
 *   Origin: [5.25,4.25,1.75]
 *
 * BOUNDING BOX:
 *   Min: [5.25,4.25,1.75]
 *   Max: [71.95,45.25,22.65]
 *
 * ALIGNMENT:
 *   Removes the main electronics cavity and leaves the measured floor.
 *
 * CONNECTS TO:
 *   - board/battery volume.
 */
module base_tray_inner_cavity_cutout() {
    translate([base_tray_inner_cavity_x_mm,
               base_tray_inner_cavity_y_mm,
               base_tray_floor_thickness_mm])
        rounded_box(base_tray_inner_cavity_width_mm,
                    base_tray_inner_cavity_depth_mm,
                    base_tray_height_mm - base_tray_floor_thickness_mm + case_cut_overshoot_mm,
                    case_inner_corner_radius_mm);
}

/**
 * Rim Rabbet Cutout
 *
 * POSITION:
 *   Top perimeter, z starts at base_tray_height_mm - base_tray_rim_height_mm.
 *
 * BOUNDING BOX:
 *   Removes the exterior top ring outside the inset rim footprint.
 *
 * ALIGNMENT:
 *   Produces the approximately 5.4 mm high ledge that accepts the bezel skirt.
 *
 * CONNECTS TO:
 *   - top_bezel_skirt_outer_size_mm with named XY/Z clearance.
 */
module base_tray_rim_rabbet_cutout() {
    difference() {
        translate([-case_epsilon_mm,
                   -case_epsilon_mm,
                   base_tray_height_mm - base_tray_rim_height_mm])
            rounded_box(case_width_mm + 2 * case_epsilon_mm,
                        case_depth_mm + 2 * case_epsilon_mm,
                        base_tray_rim_height_mm + case_cut_overshoot_mm,
                        case_corner_radius_mm);

        translate([base_tray_rim_inset_x_mm,
                   base_tray_rim_inset_y_mm,
                   base_tray_height_mm - base_tray_rim_height_mm - case_epsilon_mm])
            rounded_box(base_tray_rim_width_mm,
                        base_tray_rim_depth_mm,
                        base_tray_rim_height_mm + case_cut_overshoot_mm,
                        base_tray_rim_corner_radius_mm);
    }
}

/**
 * Left Wall Connector Relief Cutouts
 *
 * POSITION:
 *   Two vertical wall interruptions on the left side, matching the high-Z
 *   source section features.
 *
 * BOUNDING BOX:
 *   Each relief cuts through the left wall at the upper rim height.
 *
 * ALIGNMENT:
 *   These are modeled as functional access/clearance reliefs rather than
 *   mesh-faithful organic surfaces.
 *
 * CONNECTS TO:
 *   - connector/cable clearance along the left wall.
 */
module base_tray_left_wall_connector_relief_cutouts() {
    for (center_y_mm = left_wall_relief_centers_y_mm) {
        translate([left_wall_relief_x_mm,
                   center_y_mm - left_wall_relief_depth_mm / 2,
                   left_wall_relief_z_mm])
            cube([left_wall_relief_width_mm,
                  left_wall_relief_depth_mm,
                  left_wall_relief_height_mm + case_cut_overshoot_mm]);
    }
}

// ===========================================
// MAIN ASSEMBLY
// ===========================================

module base_tray_cut_shell() {
    difference() {
        base_tray_outer_block();
        base_tray_shell_negative_cutouts();
    }
}

/**
 * TTGO Base Tray
 *
 * Combines the cut shell with the discrete support lugs, then applies the
 * final wall relief cuts.
 */
module ttgo_base_tray() {
    difference() {
        union() {
            base_tray_cut_shell();
            base_tray_support_lugs_positive();
        }
        base_tray_final_negative_cutouts();
    }
}

// Backward-compatible module name used by earlier docs/builds.
module ttgo_cap() {
    ttgo_base_tray();
}

// ===========================================
// CONNECTION INTERFACES
// ===========================================

function base_tray_outer_size_mm() =
    [case_width_mm, case_depth_mm, base_tray_height_mm];

function base_tray_rim_center_mm() =
    [case_width_mm / 2, case_depth_mm / 2, base_tray_height_mm];

function base_tray_rim_seat_size_mm() =
    [base_tray_rim_width_mm - 2 * case_fit_clearance_xy_mm,
     base_tray_rim_depth_mm - 2 * case_fit_clearance_xy_mm,
     base_tray_rim_height_mm - case_fit_clearance_z_mm];

function base_tray_inner_cavity_size_mm() =
    [base_tray_inner_cavity_width_mm,
     base_tray_inner_cavity_depth_mm,
     base_tray_height_mm - base_tray_floor_thickness_mm];

// ===========================================
// DEBUG / VALIDATION
// ===========================================

module debug_axes(length_mm = 50) {
    color("red")   cylinder(h = length_mm, r = 1, $fn = 16);
    color("green") rotate([0, 90, 0]) cylinder(h = length_mm, r = 1, $fn = 16);
    color("blue")  rotate([-90, 0, 0]) cylinder(h = length_mm, r = 1, $fn = 16);
}

module debug_bounds() {
    color("yellow", 0.2)
        cube(base_tray_outer_size_mm());
}

module debug_positive_only() {
    color(color_base_tray_outer_block) base_tray_outer_block();
    color(color_support_lugs) base_tray_support_lugs_positive();
}

module debug_negative_only() {
    color(color_inner_cavity_cutout, 0.45) base_tray_inner_cavity_cutout();
    color(color_rim_rabbet_cutout, 0.55) base_tray_rim_rabbet_cutout();
    color(color_left_wall_connector_reliefs, 0.70) base_tray_left_wall_connector_relief_cutouts();
}

module debug_cutouts() {
    color(color_base_tray_outer_block, 0.25) base_tray_outer_block();
    debug_negative_only();
    color(color_support_lugs, 0.90) base_tray_support_lugs_positive();
}

/**
 * Color Key Preview
 *
 * Shows the positive shell, support lugs, and each named cutout volume in a
 * distinct color. The magenta support lugs are lifted upward as a visual
 * callout because they sit inside the rim in the real model. This is for
 * identification only; STL export ignores colors and this mode is not the
 * printable model.
 */
module color_key_preview() {
    color(color_base_tray_outer_block, 0.25) base_tray_outer_block();
    debug_negative_only();
    translate([0, 0, 4])
        color(color_support_lugs, 0.95) base_tray_support_lugs_positive();
}

module debug_section_x(x_mm = case_width_mm / 2) {
    intersection() {
        ttgo_base_tray();
        translate([x_mm - case_epsilon_mm, -case_epsilon_mm, -case_epsilon_mm])
            cube([2 * case_epsilon_mm,
                  case_depth_mm + 2 * case_epsilon_mm,
                  base_tray_height_mm + 2 * case_epsilon_mm]);
    }
}

module debug_section_y(y_mm = case_depth_mm / 2) {
    intersection() {
        ttgo_base_tray();
        translate([-case_epsilon_mm, y_mm - case_epsilon_mm, -case_epsilon_mm])
            cube([case_width_mm + 2 * case_epsilon_mm,
                  2 * case_epsilon_mm,
                  base_tray_height_mm + 2 * case_epsilon_mm]);
    }
}

module validation_source_mesh() {
    translate(-source_cap_bbox_min_mm)
        import(source_cap_mesh_file, convexity = 10);
}

module validation_overlay() {
    color("gray", 0.55) ttgo_base_tray();
    color(color_source_mesh_overlay, 0.25) validation_source_mesh();
}

module assembly_colored() {
    color(color_base_tray_outer_block) ttgo_base_tray();
}

module assembly_exploded(separation_mm = 30) {
    translate([0, 0, 0]) ttgo_base_tray();
}

// ===========================================
// DEFAULT RENDER
// ===========================================

// [View Mode]
// Set to 1 in OpenSCAD Preview (F5) to identify named sections by color.
// Keep 0 for printable STL export. Cutouts are voids in the final model, so
// they cannot stay colored in the printable boolean solid.
see_in_color = 1; // [0:No, 1:Yes]

// Advanced debug mode used when see_in_color is 0.
debug_view_mode = "model"; // [model, overlay, cutouts, positive, section_x, section_y]

if (see_in_color == 1) {
    color_key_preview();
} else if (debug_view_mode == "overlay") {
    validation_overlay();
} else if (debug_view_mode == "cutouts") {
    debug_cutouts();
} else if (debug_view_mode == "positive") {
    debug_positive_only();
} else if (debug_view_mode == "section_x") {
    debug_section_x();
} else if (debug_view_mode == "section_y") {
    debug_section_y();
} else {
    ttgo_base_tray();
}
