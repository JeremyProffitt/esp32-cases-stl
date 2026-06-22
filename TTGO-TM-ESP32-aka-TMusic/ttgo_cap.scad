/**
 * TTGO-TM ESP32 ("TMusic") — BASE TRAY  [PARAMETRIC REBUILD]
 *
 * Editable, parametric APPROXIMATION of the base tray (named "cap" in the
 * source files) hand-modelled from OpenSCAD primitives. This is NOT
 * geometry-exact: the source part is a dense organic CATIA mesh. For an exact
 * reproduction, use ttgo_cap_mesh.scad (which imports the original STL).
 *
 * What this approximates: a deep rounded-rectangle box with constant-thickness
 * walls and floor, two internal PCB slide-rails on the long walls, a stepped
 * rim (rabbet) around the top edge that the bezel seats into, and a small
 * notch in one rim corner for a cable / connector.
 *
 * Coordinate System:
 *   X = Width  (positive = right)
 *   Y = Depth  (positive = back/away from viewer)
 *   Z = Height (positive = up)
 *
 * Origin: Front-left corner of the tray, at the bottom outer face (z = 0).
 *
 * ===========================================
 * COMPONENT INDEX
 * ===========================================
 *
 * | Component       | Origin [X,Y,Z]   | Size [W,D,H]      | Notes                      |
 * |-----------------|------------------|-------------------|----------------------------|
 * | tray_shell      | [0, 0, 0]        | [76.2, 49.5, 22.15]| Hollow rounded box        |
 * | rim_rabbet      | top edge         | step 1.5 x 5      | Ledge the bezel sits into  |
 * | pcb_rails (x2)  | long walls       | [30, 1.5, 1.5]    | PCB slide guides           |
 * | corner_notch    | rear-right rim   | [6, wall, 5]      | Cable / connector relief   |
 */

// ===========================================
// DIMENSIONS (all values in millimetres)
// ===========================================

// --- Global / Shared (match across body + cap) ---
case_width_mm        = 76.2;   // X footprint
case_depth_mm        = 49.5;   // Y footprint
corner_radius_mm     = 3;      // Outer corner fillet radius
wall_thickness_mm    = 2.5;    // Common wall thickness

// --- tray_shell dimensions ---
tray_height_mm       = 22.15;  // Z total height of the tray
tray_floor_mm        = 2.5;    // Floor thickness

// --- rim_rabbet dimensions (stepped ledge for the bezel) ---
rim_height_mm        = 5;      // Height of the rim region from the top down
rim_step_mm          = 1.5;    // How far the outer wall steps inward at the rim

// --- pcb_rails dimensions (internal slide guides on long walls) ---
pcb_rail_length_mm   = 30;     // X length
pcb_rail_thick_mm    = 1.5;    // Y protrusion into cavity
pcb_rail_height_mm   = 1.5;    // Z height
pcb_rail_z_mm        = 12;     // Z of rail underside
pcb_rail_x_mm        = 23;     // X start of the rail

// --- corner_notch dimensions ---
corner_notch_width_mm  = 6;    // X
corner_notch_depth_mm  = 5;    // Z down from rim top

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
 * Base Tray
 *
 * POSITION:     Origin [0, 0, 0]
 * BOUNDING BOX: [0,0,0] to [76.2, 49.5, 22.15]
 *
 * Construction:
 *   - Solid rounded outer shell.
 *   - Hollowed to leave walls (wall_thickness_mm) and a floor (tray_floor_mm).
 *   - A rabbet (rim_step_mm x rim_height_mm) cut around the top outer edge so
 *     the bezel's lip seats flush.
 *   - Two PCB rails added on the inner long walls.
 *   - A notch cut into the rear-right rim corner.
 */
module ttgo_cap() {
    difference() {
        union() {
            difference() {
                // Outer shell
                rounded_box(case_width_mm, case_depth_mm, tray_height_mm, corner_radius_mm);

                // Inner cavity (open top)
                translate([wall_thickness_mm, wall_thickness_mm, tray_floor_mm])
                    rounded_box(case_width_mm - 2 * wall_thickness_mm,
                                case_depth_mm - 2 * wall_thickness_mm,
                                tray_height_mm,  // overshoot top, leaves open mouth
                                max(0.1, corner_radius_mm - wall_thickness_mm));

                // Rim rabbet: remove a thin outer ring at the top so the bezel
                // lip drops into a recessed ledge. The outer ring is oversized
                // by 1mm beyond the shell so its faces are not coincident with
                // the shell wall (avoids render z-fighting; result identical).
                difference() {
                    translate([-1, -1, tray_height_mm - rim_height_mm])
                        rounded_box(case_width_mm + 2, case_depth_mm + 2,
                                    rim_height_mm + 1, corner_radius_mm);
                    translate([rim_step_mm, rim_step_mm,
                               tray_height_mm - rim_height_mm - 0.01])
                        rounded_box(case_width_mm - 2 * rim_step_mm,
                                    case_depth_mm - 2 * rim_step_mm,
                                    rim_height_mm + 0.03,
                                    max(0.1, corner_radius_mm - rim_step_mm));
                }
            }

            // Internal PCB slide-rails on both long (X-running) walls
            for (yc = [wall_thickness_mm,
                       case_depth_mm - wall_thickness_mm - pcb_rail_thick_mm])
                translate([pcb_rail_x_mm, yc, pcb_rail_z_mm])
                    cube([pcb_rail_length_mm, pcb_rail_thick_mm, pcb_rail_height_mm]);
        }

        // Corner notch in the rear-right rim (cable / connector relief)
        translate([case_width_mm - corner_notch_width_mm, case_depth_mm - wall_thickness_mm - 0.01,
                   tray_height_mm - corner_notch_depth_mm])
            cube([corner_notch_width_mm + 0.01, wall_thickness_mm + 0.02,
                  corner_notch_depth_mm + 0.01]);
    }
}

// ===========================================
// CONNECTION INTERFACES
// ===========================================

// Top of the rim where the bezel seats (corner-origin coordinates).
function ttgo_cap_rim_center() = [case_width_mm/2, case_depth_mm/2, tray_height_mm];

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
        cube([case_width_mm, case_depth_mm, tray_height_mm]);
}

module assembly_colored() {
    color("gray") ttgo_cap();
}

// ===========================================
// DEFAULT RENDER
// ===========================================
ttgo_cap();
