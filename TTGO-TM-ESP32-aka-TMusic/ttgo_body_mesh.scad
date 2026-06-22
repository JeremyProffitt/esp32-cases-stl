/**
 * TTGO-TM ESP32 ("TMusic") — FRONT BEZEL  [MESH / IMPORT WRAPPER]
 *
 * This file imports the original CATIA-exported STL mesh verbatim, so the
 * geometry is 100% faithful to the source part. Use this when you need an
 * exact reproduction (e.g. final print). For an editable, parametric
 * approximation of the same part, see ttgo_body.scad.
 *
 * Coordinate System (inherited from the source mesh — NOT the project corner
 * convention; the parametric file ttgo_body.scad uses the corner convention):
 *   X = Width  (positive = right)
 *   Y = Depth  (positive = back/away from viewer)
 *   Z = Height (positive = up)
 *
 * SOURCE MESH BOUNDING BOX (millimetres):
 *   Min:  [-36.675, -44.423, -3.540]
 *   Max:  [ 39.525,   5.100, 11.460]
 *   Size: [ 76.200,  49.523, 15.000]
 *
 * The mesh origin is roughly inside the part (CATIA digitised-shape origin),
 * not at a corner. debug_recenter() below shifts the part so its bounding-box
 * min sits at the origin if you prefer corner-origin coordinates.
 */

// ===========================================
// SOURCE FILE
// ===========================================
body_mesh_file = "ttgo-body-2.stl";   // must sit beside this .scad

// Bounding-box constants (from mesh analysis) — used by debug helpers.
body_mesh_min_mm  = [-36.675, -44.423, -3.540];
body_mesh_max_mm  = [ 39.525,   5.100, 11.460];
body_mesh_size_mm = [ 76.200,  49.523, 15.000];

// ===========================================
// PART
// ===========================================

/**
 * Front bezel, exactly as exported.
 * POSITION:     mesh-native (origin interior to part)
 * BOUNDING BOX: see body_mesh_min_mm / body_mesh_max_mm above
 */
module ttgo_body_mesh() {
    import(body_mesh_file, convexity = 10);
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
        translate(body_mesh_min_mm)
            cube(body_mesh_size_mm);
}

// Same mesh, shifted so its bounding-box min sits at the origin
// (corner-origin convention used elsewhere in this project).
module debug_recenter() {
    translate(-body_mesh_min_mm)
        ttgo_body_mesh();
}

// ===========================================
// DEFAULT RENDER
// ===========================================
ttgo_body_mesh();
