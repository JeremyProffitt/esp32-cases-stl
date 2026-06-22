/**
 * TTGO-TM ESP32 ("TMusic") — FRONT BEZEL  [PARAMETRIC REBUILD]
 *
 * Editable, parametric APPROXIMATION of the front bezel hand-modelled from
 * OpenSCAD primitives. This is NOT geometry-exact: the source part is a dense
 * organic CATIA mesh. For an exact reproduction, use ttgo_body_mesh.scad
 * (which imports the original STL verbatim).
 *
 * What this approximates: a rounded-rectangle bezel frame with a large
 * rectangular display window, a row of finger / speaker slots plus a round
 * button hole on the right short edge, port cut-outs on the front long edge,
 * and an internal lip on the underside that seats into the cap's rim.
 *
 * Coordinate System:
 *   X = Width  (positive = right)
 *   Y = Depth  (positive = back/away from viewer)
 *   Z = Height (positive = up)
 *
 * Origin: Front-left corner of the bezel, at its lowest face (z = 0).
 *
 * ===========================================
 * COMPONENT INDEX
 * ===========================================
 *
 * | Component         | Origin [X,Y,Z]     | Size [W,D,H]        | Notes                       |
 * |-------------------|--------------------|---------------------|-----------------------------|
 * | bezel_shell       | [0, 0, 0]          | [76.2, 49.5, 15]    | Rounded outer body          |
 * | display_window    | [4, 4, -]          | [44, 41.5, thru]    | Main rectangular opening    |
 * | finger_slots (x5) | right panel        | [2.4, 9, thru]      | Speaker / vent slots        |
 * | button_hole       | right panel        | d = 5               | Round button opening        |
 * | side_ports (x2)   | front long edge    | [11, thru, 6]       | USB / SD edge cut-outs      |
 */

// ===========================================
// DIMENSIONS (all values in millimetres)
// ===========================================

// --- Global / Shared (match across body + cap) ---
case_width_mm        = 76.2;   // X footprint
case_depth_mm        = 49.5;   // Y footprint
corner_radius_mm     = 3;      // Outer corner fillet radius
wall_thickness_mm    = 2.5;    // Common wall thickness

// --- bezel_shell dimensions ---
bezel_height_mm      = 15;     // Z total height of the bezel
bezel_face_mm        = 3;      // Thickness of the top face plate (where window is cut)
bezel_skirt_mm       = bezel_height_mm - bezel_face_mm; // Outer skirt height (mates cap)

// --- display_window dimensions ---
display_window_width_mm  = 44;   // X
display_window_depth_mm  = 41.5; // Y
display_window_x_mm      = 4;    // Origin X (from left)
display_window_y_mm      = 4;    // Origin Y (from front)

// --- finger_slots dimensions (row on right short edge) ---
finger_slot_count        = 5;
finger_slot_width_mm     = 2.4;  // X width of each slot
finger_slot_length_mm    = 9;    // Y length of each slot
finger_slot_pitch_mm     = 4.6;  // Centre-to-centre spacing along X
finger_slot_x0_mm        = 55;   // X centre of first slot
finger_slot_y_mm         = 30;   // Y centre of the slot row

// --- button_hole dimensions ---
button_hole_diameter_mm  = 5;
button_hole_x_mm         = 67;   // X centre
button_hole_y_mm         = 14;   // Y centre

// --- side_ports dimensions (cut into the front long edge, y = 0) ---
side_port_width_mm       = 11;   // X length of each port
side_port_height_mm      = 6;    // Z height of each port
side_port_z_mm           = 2;    // Z of port bottom
side_port_x1_mm          = 14;   // X centre of port 1
side_port_x2_mm          = 34;   // X centre of port 2

$fn = 48;

// ===========================================
// HELPERS
// ===========================================

// A rounded-rectangle prism: footprint [w,d] with vertical edge radius r,
// extruded to height h. Lower-front-left corner at the origin.
module rounded_box(w, d, h, r) {
    linear_extrude(height = h)
        offset(r = r)
            offset(r = -r)
                square([w, d]);
}

// ===========================================
// COMPONENTS
// ===========================================

/**
 * Front Bezel
 *
 * POSITION:     Origin [0, 0, 0]
 * BOUNDING BOX: [0,0,0] to [76.2, 49.5, 15]
 *
 * Construction:
 *   - Solid rounded outer shell.
 *   - Hollowed from below, leaving a top face plate (bezel_face_mm) and an
 *     internal lip skirt (bezel_lip_height_mm) inset by bezel_lip_inset_mm.
 *   - Display window, finger slots and button hole cut through the face.
 *   - Two port cut-outs in the front long wall.
 */
module ttgo_body() {
    difference() {
        // Outer shell
        rounded_box(case_width_mm, case_depth_mm, bezel_height_mm, corner_radius_mm);

        // Hollow underside (open bottom), leaving the top face plate intact.
        // The surrounding outer walls form the skirt / lip that mates the cap.
        translate([wall_thickness_mm, wall_thickness_mm, -0.01])
            rounded_box(case_width_mm  - 2 * wall_thickness_mm,
                        case_depth_mm  - 2 * wall_thickness_mm,
                        bezel_height_mm - bezel_face_mm + 0.01,
                        max(0.1, corner_radius_mm - wall_thickness_mm));

        // Display window (through the face)
        translate([display_window_x_mm, display_window_y_mm, -1])
            rounded_box(display_window_width_mm, display_window_depth_mm,
                        bezel_height_mm + 2, 1.5);

        // Finger / speaker slots (rounded-end vertical slots)
        for (i = [0 : finger_slot_count - 1])
            translate([finger_slot_x0_mm + i * finger_slot_pitch_mm,
                       finger_slot_y_mm, -1])
                hull() {
                    translate([0, -finger_slot_length_mm/2 + finger_slot_width_mm/2, 0])
                        cylinder(h = bezel_height_mm + 2, d = finger_slot_width_mm);
                    translate([0,  finger_slot_length_mm/2 - finger_slot_width_mm/2, 0])
                        cylinder(h = bezel_height_mm + 2, d = finger_slot_width_mm);
                }

        // Round button hole
        translate([button_hole_x_mm, button_hole_y_mm, -1])
            cylinder(h = bezel_height_mm + 2, d = button_hole_diameter_mm);

        // Side ports in the front long wall (y = 0)
        for (xc = [side_port_x1_mm, side_port_x2_mm])
            translate([xc - side_port_width_mm/2, -1, side_port_z_mm])
                cube([side_port_width_mm, wall_thickness_mm + 2, side_port_height_mm]);
    }
}

// ===========================================
// CONNECTION INTERFACES
// ===========================================

// The bezel's internal lip plane that seats onto the cap rim.
// Returns the bezel's lowest face centre (corner-origin coordinates).
function ttgo_body_mate_center() = [case_width_mm/2, case_depth_mm/2, 0];

// ===========================================
// DEBUG / VISUALIZATION
// ===========================================

module debug_axes(length = 50) {
    color("red")   cylinder(h = length, r = 1, $fn = 16);                  // Z
    color("green") rotate([0, 90, 0]) cylinder(h = length, r = 1, $fn = 16); // X
    color("blue")  rotate([-90, 0, 0]) cylinder(h = length, r = 1, $fn = 16); // Y
}

module debug_bounds() {
    color("yellow", 0.2)
        cube([case_width_mm, case_depth_mm, bezel_height_mm]);
}

module assembly_colored() {
    color("steelblue") ttgo_body();
}

// ===========================================
// DEFAULT RENDER
// ===========================================
ttgo_body();
