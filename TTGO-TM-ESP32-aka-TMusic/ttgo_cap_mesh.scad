/**
 * TTGO-TM ESP32 ("TMusic") — BASE TRAY  [MESH / IMPORT WRAPPER]
 *
 * Despite the file name "cap", this part is the deep BASE TRAY of the
 * enclosure (a hollow box with PCB rails and a top rim lip). It imports the
 * original CATIA-exported STL mesh verbatim, so the geometry is 100% faithful
 * to the source part. For an editable, parametric approximation of the same
 * part, see ttgo_cap.scad.
 *
 * Coordinate System (inherited from the source mesh):
 *   X = Width  (positive = right)
 *   Y = Depth  (positive = back/away from viewer)
 *   Z = Height (positive = up)
 *
 * SOURCE MESH BOUNDING BOX (millimetres):
 *   Min:  [-36.675, -44.423, -20.290]
 *   Max:  [ 39.525,   5.100,   1.860]
 *   Size: [ 76.200,  49.523,  22.150]
 */

// ===========================================
// SOURCE FILE
// ===========================================
cap_mesh_file = "ttgo-cap-2.stl";   // must sit beside this .scad

// Bounding-box constants (from mesh analysis) — used by debug helpers.
cap_mesh_min_mm  = [-36.675, -44.423, -20.290];
cap_mesh_max_mm  = [ 39.525,   5.100,   1.860];
cap_mesh_size_mm = [ 76.200,  49.523,  22.150];

// ===========================================
// PART
// ===========================================

/**
 * Base tray, exactly as exported.
 * POSITION:     mesh-native (origin interior to part)
 * BOUNDING BOX: see cap_mesh_min_mm / cap_mesh_max_mm above
 */
module ttgo_cap_mesh() {
    import(cap_mesh_file, convexity = 10);
}

// ===========================================
// DEBUG / VISUALIZATION
// ===========================================

// Render coordinate axes at origin (length = 50mm).
module debug_axes(length = 50) {
    color("red")   cylinder(h = length, r = 1, $fn = 16);                 // Z
    color("green") rotate([0, 90, 0]) cylinder(h = length, r = 1, $fn = 16); // X
    color("blue")  rotate([-90, 0, 0]) cylinder(h = length, r = 1, $fn = 16); // Y
}

// Transparent bounding box of the imported mesh.
module debug_bounds() {
    color("yellow", 0.2)
        translate(cap_mesh_min_mm)
            cube(cap_mesh_size_mm);
}

// Same mesh, shifted so its bounding-box min sits at the origin
// (corner-origin convention used elsewhere in this project).
module debug_recenter() {
    translate(-cap_mesh_min_mm)
        ttgo_cap_mesh();
}

// ===========================================
// ASSEMBLY (mesh + mesh)
// ===========================================

/**
 * Both meshes shown together in their native coordinates. Because the body
 * (z -3.54..11.46) and the cap (z -20.29..1.86) share the same X/Y datum and
 * overlap around z≈0, importing both in native coords shows them already
 * mated as the closed enclosure.
 */
module assembly_mesh() {
    color("gray")      ttgo_cap_mesh();
    color("steelblue") import("ttgo-body-2.stl", convexity = 10);
}

// ===========================================
// DEFAULT RENDER
// ===========================================
ttgo_cap_mesh();
