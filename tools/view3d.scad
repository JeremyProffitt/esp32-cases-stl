/**
 * Shaded 3D view wrapper for the TTGO drawing sheets (isometric panel).
 *
 * Usage (from tools/):
 *   openscad -o iso.png --projection=o --camera=0,0,0,55,0,25 --viewall --autocenter \
 *            -D 'part="body"' view3d.scad
 *
 * part: "body" | "cap"
 */
use <../TTGO-TM-ESP32-aka-TMusic/ttgo_body.scad>
use <../TTGO-TM-ESP32-aka-TMusic/ttgo_cap.scad>

$fn = 72;
part = "body";

if (part == "body") ttgo_body(); else ttgo_cap();
