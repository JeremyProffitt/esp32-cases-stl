/**
 * Line-art view generator (2D projection outlines) for the TTGO drawing sheets.
 *
 * Renders a thin outline of an orthographic projection of a component, so every
 * through-feature shows as a crisp line. Elevation views (front / right) project
 * a thin wall SLAB so face features (e.g. the bezel side ports) appear even
 * though they do not pierce the whole part.
 *
 * Usage (from tools/):
 *   openscad -o out.png --projection=o --camera=0,0,0,0,0,0 --viewall --autocenter \
 *            -D 'part="body"' -D 'view="top"' draw2d.scad
 *
 * part: "body" | "cap"      view: "top" | "front" | "right"
 */
use <../TTGO-TM-ESP32-aka-TMusic/ttgo_body.scad>
use <../TTGO-TM-ESP32-aka-TMusic/ttgo_cap.scad>

$fn = 96;
part = "body";
view = "top";
lw   = 0.5;     // outline line width (mm)

module P() { if (part == "body") ttgo_body(); else ttgo_cap(); }

module flat() {
    if (view == "top")
        projection() P();
    else if (view == "front")
        // thin slab at the front wall (y = 0..~3.5) so face holes project
        projection() rotate([-90, 0, 0]) intersection() { P(); translate([-5, -1, -5]) cube([90, 3.5, 40]); }
    else if (view == "right")
        // thin slab at the right wall, rotated to landscape (depth horizontal)
        rotate([0, 0, 90]) projection() rotate([0, 90, 0]) intersection() { P(); translate([71.2, -5, -5]) cube([10, 60, 40]); }
}

rotate([90, 0, 0])
    linear_extrude(1)
        difference() { flat(); offset(-lw) flat(); }
