/**
 * TTGO-TM ESP32 ("TMusic") - TOP / FRONT BEZEL
 * Parametric constructive rebuild from ttgo-body-2.stl.
 *
 * This is an editable approximation, not a triangle-for-triangle copy. The
 * source STL is kept as the reference mesh. The model is built from one
 * positive rounded bounding shell and named negative cutouts for the functional
 * openings observed in mesh cross-sections.
 *
 * Coordinate System:
 *   X = Width  (positive = right)
 *   Y = Depth  (positive = back/away from viewer)
 *   Z = Height (positive = up)
 *
 * Origin: Front-left-bottom corner of the normalized bezel bounding box.
 *
 * ===========================================
 * COMPONENT INDEX
 * ===========================================
 *
 * | Component                    | Preview Color | Origin [X,Y,Z] | Size [W,D,H]       | Attaches To      |
 * |------------------------------|---------------|----------------|--------------------|------------------|
 * | top_bezel_positive_shell     | gold          | [0,0,0]        | [76.2,49.523,15]   | base tray rim    |
 * | top_bezel_inner_cavity       | dodgerblue    | [2.9,2.4,0]    | [70.4,44.7,12.05]  | negative cutout  |
 * | display_window               | limegreen     | [15.2,5.6,12]  | [51.5,38.4,thru]   | negative cutout  |
 * | side_control_slots (x4)      | magenta       | left face area | [8.7,5.9,thru]     | negative cutout  |
 * | corner_relief_holes (x4)     | red           | top corners    | d=1.9              | negative cutout  |
 * | skirt_alignment_reliefs      | cyan          | skirt edges    | variable           | negative cutout  |
 */

// ===========================================
// DIMENSIONS (all values in millimeters)
// ===========================================

// --- Source mesh facts ---
source_body_mesh_file = "ttgo-body-2.stl";
source_body_bbox_min_mm = [-36.675, -44.4235, -3.540];
source_body_bbox_max_mm = [ 39.525,   5.1000, 11.460];
source_body_bbox_size_mm = [76.200, 49.5235, 15.000];
source_body_face_count = 51684;

// --- Global / shared case dimensions ---
case_width_mm = 76.200;
case_depth_mm = 49.523;
case_corner_radius_mm = 2.300;
case_inner_corner_radius_mm = 1.300;
case_wall_thickness_mm = 2.500;
case_fit_clearance_xy_mm = 0.250;
case_epsilon_mm = 0.050;
case_cut_overshoot_mm = 0.500;

// --- top_bezel_positive_shell dimensions ---
top_bezel_height_mm = 15.000;
top_bezel_face_thickness_mm = 3.000;
top_bezel_skirt_height_mm = top_bezel_height_mm - top_bezel_face_thickness_mm;

// --- top_bezel_inner_cavity_cutout dimensions ---
top_bezel_inner_cavity_x_mm = 2.900;
top_bezel_inner_cavity_y_mm = 2.400;
top_bezel_inner_cavity_width_mm = 70.400;
top_bezel_inner_cavity_depth_mm = 44.700;
top_bezel_inner_cavity_height_mm = top_bezel_skirt_height_mm + case_epsilon_mm;

// --- top_bezel_display_window_cutout dimensions ---
display_window_x_mm = 15.200;
display_window_y_mm = 5.600;
display_window_width_mm = 51.500;
display_window_depth_mm = 38.400;
display_window_corner_radius_mm = 0.800;

// --- top_bezel_side_control_slot_cutouts dimensions ---
side_control_slot_count = 4;
side_control_slot_x_mm = 2.750;
side_control_slot_first_y_mm = 12.100;
side_control_slot_pitch_mm = 7.600;
side_control_slot_width_mm = 8.700;
side_control_slot_depth_mm = 5.900;
side_control_slot_radius_mm = 2.700;

// --- top_bezel_corner_relief_hole_cutouts dimensions ---
corner_relief_hole_diameter_mm = 1.900;
corner_relief_hole_left_x_mm = 6.200;
corner_relief_hole_right_x_mm = 70.850;
corner_relief_hole_front_y_mm = 5.300;
corner_relief_hole_back_y_mm = 44.350;

// --- top_bezel_skirt_alignment_relief_cutouts dimensions ---
skirt_relief_width_mm = 8.000;
skirt_relief_depth_mm = 1.400;
skirt_relief_height_mm = 2.500;
skirt_relief_z_mm = 0.000;
front_skirt_relief_centers_x_mm = [18.800, 38.700, 59.700];
back_skirt_relief_centers_x_mm = [18.800, 38.700, 59.700];
left_skirt_relief_width_mm = 1.800;
left_skirt_relief_depth_mm = 3.800;
left_skirt_relief_centers_y_mm = [15.000, 22.600, 30.200, 37.800];

// --- Preview colors (used only by debug/color-key render modes) ---
color_top_bezel_shell = "gold";
color_inner_cavity_cutout = "dodgerblue";
color_display_window_cutout = "limegreen";
color_side_control_slot_cutouts = "magenta";
color_corner_relief_hole_cutouts = "red";
color_skirt_alignment_relief_cutouts = "cyan";
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

module rounded_slot_box(width_mm, depth_mm, height_mm, radius_mm) {
    linear_extrude(height = height_mm)
        rounded_rect_2d(width_mm, depth_mm, radius_mm);
}

// ===========================================
// POSITIVE GEOMETRY
// ===========================================

/**
 * Top Bezel Positive Shell
 *
 * POSITION:
 *   Origin: [0,0,0]
 *
 * BOUNDING BOX:
 *   Min: [0,0,0]
 *   Max: [76.2,49.523,15]
 *
 * ALIGNMENT:
 *   The normalized source mesh bounding-box minimum maps to this origin.
 *
 * CONNECTS TO:
 *   - ttgo_base_tray: lower skirt seats in the base tray rim.
 */
module top_bezel_positive_shell() {
    rounded_box(case_width_mm, case_depth_mm, top_bezel_height_mm,
                case_corner_radius_mm);
}

// ===========================================
// NEGATIVE CUTOUTS
// ===========================================

module top_bezel_negative_cutouts() {
    top_bezel_inner_cavity_cutout();
    top_bezel_display_window_cutout();
    top_bezel_side_control_slot_cutouts();
    top_bezel_corner_relief_hole_cutouts();
    top_bezel_skirt_alignment_relief_cutouts();
}

/**
 * Inner Cavity Cutout
 *
 * POSITION:
 *   Origin: [2.9,2.4,-0.05]
 *
 * BOUNDING BOX:
 *   Min: [2.9,2.4,-0.05]
 *   Max: [73.3,47.1,12.05]
 *
 * ALIGNMENT:
 *   Opens the underside while leaving the top face plate intact.
 *
 * CONNECTS TO:
 *   - base tray cavity through the mating skirt opening.
 */
module top_bezel_inner_cavity_cutout() {
    translate([top_bezel_inner_cavity_x_mm,
               top_bezel_inner_cavity_y_mm,
               -case_epsilon_mm])
        rounded_box(top_bezel_inner_cavity_width_mm,
                    top_bezel_inner_cavity_depth_mm,
                    top_bezel_inner_cavity_height_mm,
                    case_inner_corner_radius_mm);
}

/**
 * Display Window Cutout
 *
 * POSITION:
 *   Origin: [15.2,5.6,11.95]
 *
 * BOUNDING BOX:
 *   Min: [15.2,5.6,11.95]
 *   Max: [66.7,44.0,15.55]
 *
 * ALIGNMENT:
 *   Through-cut in the top face plate, measured from upper Z slices.
 *
 * CONNECTS TO:
 *   - display glass / visible screen area.
 */
module top_bezel_display_window_cutout() {
    translate([display_window_x_mm,
               display_window_y_mm,
               top_bezel_height_mm - top_bezel_face_thickness_mm - case_epsilon_mm])
        rounded_box(display_window_width_mm,
                    display_window_depth_mm,
                    top_bezel_face_thickness_mm + (2 * case_cut_overshoot_mm),
                    display_window_corner_radius_mm);
}

/**
 * Side Control Slot Cutouts
 *
 * POSITION:
 *   Four rounded rectangular openings near the left side of the top face.
 *
 * BOUNDING BOX:
 *   Each slot is approximately [8.7,5.9,thru].
 *
 * ALIGNMENT:
 *   Centers are spaced along Y using side_control_slot_pitch_mm.
 *
 * CONNECTS TO:
 *   - side button / speaker / finger-access region from the source mesh.
 */
module top_bezel_side_control_slot_cutouts() {
    for (slot_index = [0 : side_control_slot_count - 1]) {
        translate([side_control_slot_x_mm,
                   side_control_slot_first_y_mm + slot_index * side_control_slot_pitch_mm,
                   top_bezel_height_mm - top_bezel_face_thickness_mm - case_epsilon_mm])
            rounded_slot_box(side_control_slot_width_mm,
                             side_control_slot_depth_mm,
                             top_bezel_face_thickness_mm + (2 * case_cut_overshoot_mm),
                             side_control_slot_radius_mm);
    }
}

/**
 * Corner Relief Hole Cutouts
 *
 * POSITION:
 *   Four small circular holes near the top-face corners.
 *
 * BOUNDING BOX:
 *   Diameter 1.9 mm, through the face plate.
 *
 * ALIGNMENT:
 *   Centers are extracted from the z=12 mm mesh cross-section.
 *
 * CONNECTS TO:
 *   - likely screw, locating, or manufacturing relief features.
 */
module top_bezel_corner_relief_hole_cutouts() {
    for (hole_x_mm = [corner_relief_hole_left_x_mm, corner_relief_hole_right_x_mm])
        for (hole_y_mm = [corner_relief_hole_front_y_mm, corner_relief_hole_back_y_mm])
            translate([hole_x_mm,
                       hole_y_mm,
                       top_bezel_height_mm - top_bezel_face_thickness_mm - case_epsilon_mm])
                cylinder(h = top_bezel_face_thickness_mm + (2 * case_cut_overshoot_mm),
                         d = corner_relief_hole_diameter_mm);
}

/**
 * Skirt Alignment Relief Cutouts
 *
 * POSITION:
 *   Small notches in the lower skirt edges.
 *
 * BOUNDING BOX:
 *   Front/back reliefs are skirt_relief_width_mm by skirt_relief_depth_mm.
 *
 * ALIGNMENT:
 *   These approximate the small repeated edge breaks visible in low-Z slices.
 *
 * CONNECTS TO:
 *   - clearance around mating tray details.
 */
module top_bezel_skirt_alignment_relief_cutouts() {
    for (center_x_mm = front_skirt_relief_centers_x_mm)
        translate([center_x_mm - skirt_relief_width_mm / 2,
                   -case_epsilon_mm,
                   skirt_relief_z_mm - case_epsilon_mm])
            cube([skirt_relief_width_mm,
                  skirt_relief_depth_mm + case_epsilon_mm,
                  skirt_relief_height_mm + case_epsilon_mm]);

    for (center_x_mm = back_skirt_relief_centers_x_mm)
        translate([center_x_mm - skirt_relief_width_mm / 2,
                   case_depth_mm - skirt_relief_depth_mm,
                   skirt_relief_z_mm - case_epsilon_mm])
            cube([skirt_relief_width_mm,
                  skirt_relief_depth_mm + case_epsilon_mm,
                  skirt_relief_height_mm + case_epsilon_mm]);

    for (center_y_mm = left_skirt_relief_centers_y_mm)
        translate([-case_epsilon_mm,
                   center_y_mm - left_skirt_relief_depth_mm / 2,
                   top_bezel_height_mm - top_bezel_face_thickness_mm - case_epsilon_mm])
            cube([left_skirt_relief_width_mm + case_epsilon_mm,
                  left_skirt_relief_depth_mm,
                  top_bezel_face_thickness_mm + (2 * case_cut_overshoot_mm)]);
}

// ===========================================
// MAIN ASSEMBLY
// ===========================================

/**
 * TTGO Top Bezel
 *
 * Combines the positive shell with all named negative cutouts.
 */
module ttgo_top_bezel() {
    difference() {
        top_bezel_positive_shell();
        top_bezel_negative_cutouts();
    }
}

// Backward-compatible module name used by earlier docs/builds.
module ttgo_body() {
    ttgo_top_bezel();
}

// ===========================================
// CONNECTION INTERFACES
// ===========================================

function top_bezel_outer_size_mm() =
    [case_width_mm, case_depth_mm, top_bezel_height_mm];

function top_bezel_mate_center_mm() =
    [case_width_mm / 2, case_depth_mm / 2, 0];

function top_bezel_skirt_outer_size_mm() =
    [case_width_mm, case_depth_mm, top_bezel_skirt_height_mm];

function top_bezel_inner_cavity_size_mm() =
    [top_bezel_inner_cavity_width_mm,
     top_bezel_inner_cavity_depth_mm,
     top_bezel_inner_cavity_height_mm];

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
        cube(top_bezel_outer_size_mm());
}

module debug_positive_only() {
    color(color_top_bezel_shell) top_bezel_positive_shell();
}

module debug_negative_only() {
    color(color_inner_cavity_cutout, 0.45) top_bezel_inner_cavity_cutout();
    color(color_display_window_cutout, 0.65) top_bezel_display_window_cutout();
    color(color_side_control_slot_cutouts, 0.70) top_bezel_side_control_slot_cutouts();
    color(color_corner_relief_hole_cutouts, 0.80) top_bezel_corner_relief_hole_cutouts();
    color(color_skirt_alignment_relief_cutouts, 0.70) top_bezel_skirt_alignment_relief_cutouts();
}

module debug_cutouts() {
    color(color_top_bezel_shell, 0.25) top_bezel_positive_shell();
    debug_negative_only();
}

/**
 * Color Key Preview
 *
 * Shows the positive shell and each named negative cutout volume in a distinct
 * color. This is for visual identification only; STL export ignores colors.
 */
module color_key_preview() {
    debug_cutouts();
}

module debug_section_x(x_mm = case_width_mm / 2) {
    intersection() {
        ttgo_top_bezel();
        translate([x_mm - case_epsilon_mm, -case_epsilon_mm, -case_epsilon_mm])
            cube([2 * case_epsilon_mm,
                  case_depth_mm + 2 * case_epsilon_mm,
                  top_bezel_height_mm + 2 * case_epsilon_mm]);
    }
}

module debug_section_y(y_mm = case_depth_mm / 2) {
    intersection() {
        ttgo_top_bezel();
        translate([-case_epsilon_mm, y_mm - case_epsilon_mm, -case_epsilon_mm])
            cube([case_width_mm + 2 * case_epsilon_mm,
                  2 * case_epsilon_mm,
                  top_bezel_height_mm + 2 * case_epsilon_mm]);
    }
}

module validation_source_mesh() {
    translate(-source_body_bbox_min_mm)
        import(source_body_mesh_file, convexity = 10);
}

module validation_overlay() {
    color("steelblue", 0.55) ttgo_top_bezel();
    color(color_source_mesh_overlay, 0.25) validation_source_mesh();
}

module assembly_colored() {
    color(color_top_bezel_shell) ttgo_top_bezel();
}

module assembly_exploded(separation_mm = 30) {
    translate([0, 0, separation_mm]) ttgo_top_bezel();
}

// ===========================================
// DEFAULT RENDER
// ===========================================

// [View Mode]
// Use "model" for printable STL export. Use "color_key" in OpenSCAD Preview
// (F5) to identify named sections; cutouts are voids in the final model, so
// they cannot stay colored in the printable boolean solid.
render_mode = "model"; // [model, color_key, overlay, cutouts, positive, section_x, section_y]

if (render_mode == "color_key") {
    color_key_preview();
} else if (render_mode == "overlay") {
    validation_overlay();
} else if (render_mode == "cutouts") {
    debug_cutouts();
} else if (render_mode == "positive") {
    debug_positive_only();
} else if (render_mode == "section_x") {
    debug_section_x();
} else if (render_mode == "section_y") {
    debug_section_y();
} else {
    ttgo_top_bezel();
}
