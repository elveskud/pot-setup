// =====================================================================
//  Stirring lid ("top") + agitators for a spun-aluminium saucepot
//  Parametric OpenSCAD model.  Units: millimetres.
//
//  !! MEASURE YOUR POT AND EDIT THE "POT" SECTION BELOW !!
//  The defaults are ESTIMATES taken from a photo (no scale in the photo).
//
//  Coordinate system: Z = 0 is the plane of the pot rim (underside of lid).
//    +Z is up (motor tower), -Z goes down into the pot.
//
//  Render one part:   openscad -D 'part="lid"' -o lid.stl pot_top.scad
//  part = "lid" | "anchor" | "paddle" | "motor_plate" | "assembly"
// =====================================================================

part      = "assembly";
agitator  = "anchor";      // which agitator the assembly shows: "anchor" | "paddle"
section   = true;          // assembly: cut the pot open to see inside

// ---------------- POT (MEASURE THESE) --------------------------------
pot_id      = 220;   // inside diameter at the rim
pot_depth   = 140;   // rim down to the inside floor
pot_wall    = 3;     // wall thickness at the rim
floor_gap   = 3;     // clearance agitator <-> pot floor
wall_gap    = 3;     // clearance agitator <-> pot wall

// ---------------- LID ------------------------------------------------
lid_t        = 4;    // plate thickness (4 printed / 2-3 if cut from stainless)
lid_over     = 4;    // flange overhang beyond the pot's outer rim edge
spigot_h     = 10;   // centring ring that drops into the pot
spigot_wall  = 3;
spigot_clear = 1.0;  // radial clearance spigot <-> pot bore
vent_d       = 8;
vent_r       = 70;   // vents at +/-Y so steam leaves away from the tower
probe_r      = 78;   // probe port position (angle 225 deg)
probe_ang    = 225;
probe_hole   = 10.2; // for an M10 compression fitting (6 mm probe)
probe_depth  = 75;   // probe tip depth below the rim (must be below liquid level)

// ---------------- DRIVE ----------------------------------------------
shaft_d      = 8;    // 304/316 stainless rod
bush_od      = 12;   // PTFE bushing OD
bush_len     = 25;
gland_h      = 25;   // boss height above the lid plate
gland_od     = 34;
standoff_h   = 90;   // M5 standoffs: lid top -> motor plate underside
standoff_x   = 92;
standoff_y   = 36;
mplate_x     = 200;  // motor plate size
mplate_y     = 90;
mplate_t     = 4;

// ---------------- derived --------------------------------------------
rim_od   = pot_id + 2*pot_wall;
lid_od   = rim_od + 2*lid_over;
spig_od  = pot_id - 2*spigot_clear;
z_bot    = -(pot_depth - floor_gap);       // underside of agitator
R_ag     = pot_id/2 - wall_gap;            // agitator outer radius
hub_h    = 24;
z_top_ag = -(spigot_h + 8);                // top of agitator frame
mplate_z = lid_t + standoff_h;             // underside of motor plate

$fn = 64;

// ======================= LID =========================================
module lid_plate_2d() {            // flat plate outline + holes (laser-cut DXF)
    difference() {
        union() {
            circle(d = lid_od);
            for (s = [-1, 1]) translate([-8, s*(lid_od/2 - 2)]) // finger tabs
                square([16, 18], center = false);
        }
        circle(d = bush_od + 0.2);                       // shaft bushing bore
        for (s = [-1, 1]) translate([0, s*vent_r]) circle(d = vent_d);
        rotate(probe_ang) translate([probe_r, 0]) circle(d = probe_hole);
        for (sx = [-1, 1], sy = [-1, 1])
            translate([sx*standoff_x, sy*standoff_y]) circle(d = 6);  // M5 insert
        for (s = [-1, 1]) translate([0, s*(lid_od/2 + 10)]) circle(d = 8); // tab hole
    }
}

module lid() {
    difference() {
        union() {
            // flange plate
            linear_extrude(lid_t) union() {
                circle(d = lid_od);
                for (s = [-1, 1]) hull() {
                    translate([0, s*(lid_od/2 + 4)]) circle(d = 22);
                    translate([0, s*(lid_od/2 - 6)]) circle(d = 22);
                }
            }
            // centring spigot (drops inside the pot)
            translate([0, 0, -spigot_h])
                difference() {
                    cylinder(d = spig_od, h = spigot_h);
                    translate([0, 0, -1]) cylinder(d = spig_od - 2*spigot_wall, h = spigot_h + 2);
                }
            // gland boss around the shaft
            cylinder(d = gland_od, h = lid_t + gland_h);
            // standoff pads
            for (sx = [-1, 1], sy = [-1, 1])
                translate([sx*standoff_x, sy*standoff_y, 0]) cylinder(d = 16, h = lid_t + 6);
            // probe boss
            rotate(probe_ang) translate([probe_r, 0, 0]) cylinder(d = 20, h = lid_t + 8);
        }
        // shaft / bushing bore
        translate([0, 0, -1]) cylinder(d = bush_od + 0.2, h = lid_t + gland_h + 2);
        // steam vents
        for (s = [-1, 1]) translate([0, s*vent_r, -1]) cylinder(d = vent_d, h = lid_t + 2);
        // probe hole
        rotate(probe_ang) translate([probe_r, 0, -1]) cylinder(d = probe_hole, h = lid_t + 10);
        // M5 heat-set insert holes (blind, from the top)
        for (sx = [-1, 1], sy = [-1, 1])
            translate([sx*standoff_x, sy*standoff_y, lid_t + 6 - 8]) cylinder(d = 6.2, h = 9);
        // finger-tab holes
        for (s = [-1, 1]) translate([0, s*(lid_od/2 + 6), -1]) cylinder(d = 8, h = lid_t + 2);
    }
}

// ======================= MOTOR PLATE =================================
module motor_plate() {
    difference() {
        linear_extrude(mplate_t) offset(r = 6) offset(delta = -6)
            square([mplate_x, mplate_y], center = true);
        translate([0, 0, -1]) cylinder(d = 14, h = mplate_t + 2);          // shaft clearance
        for (sx = [-1, 1], sy = [-1, 1])
            translate([sx*standoff_x, sy*standoff_y, -1]) cylinder(d = 5.5, h = mplate_t + 2);
        // motor mounting holes (adjust to your gearmotor drawing)
        for (dx = [-18, 18], dy = [-12, 12])
            translate([dx, dy, -1]) cylinder(d = 3.4, h = mplate_t + 2);
        // electronics box mounting
        for (dx = [24, 78], dy = [-22, 22])
            translate([dx, dy, -1]) cylinder(d = 4.2, h = mplate_t + 2);
    }
}

// ======================= AGITATORS ===================================
module d_bore() {        // 8 mm D-flat bore
    intersection() {
        cylinder(d = shaft_d + 0.3, h = 100, center = true);
        translate([-10, -10, -50]) cube([10 + (shaft_d - 0.8)/2 + 0.15, 20, 100]);
    }
}

module hub() {
    difference() {
        cylinder(d = 26, h = hub_h);
        translate([0, 0, hub_h/2]) d_bore();
        translate([0, 0, -1]) cylinder(d = 13, h = 10);            // acorn-nut counterbore
    }
}

// Anchor: bottom sweep bar + two wall-following bars, scraper grooves.
module anchor() {
    bar_w = 14;  bar_h = 9;  wall_t = 8;
    translate([0, 0, z_bot]) {
        difference() {
            union() {
                hub();
                for (s = [-1, 1]) {
                    // bottom sweep bar (from hub to wall)
                    hull() {
                        translate([s*10 - (s < 0 ? 0 : 0), -bar_w/2, 0]) cube([1, bar_w, bar_h]);
                        translate([s*(R_ag - wall_t), -bar_w/2, 0]) cube([1, bar_w, bar_h]);
                    }
                    // wall bar: curved to follow the pot wall
                    intersection() {
                        translate([s > 0 ? 0 : -R_ag - 1, -bar_w/2, 0])
                            cube([R_ag + 1, bar_w, z_top_ag - z_bot]);
                        difference() {
                            cylinder(r = R_ag, h = z_top_ag - z_bot);
                            translate([0, 0, -1]) cylinder(r = R_ag - wall_t, h = z_top_ag - z_bot + 2);
                        }
                    }
                    // chamfer gusset hub-side -> bar -> wall
                    hull() {
                        translate([s*(R_ag - wall_t - 1), -bar_w/2, 0]) cube([1, bar_w, bar_h]);
                        translate([s*(R_ag - wall_t - 1), -bar_w/2, bar_h + 22]) cube([1, bar_w, 1]);
                        translate([s*(R_ag - wall_t - 14), -bar_w/2, 0]) cube([1, bar_w, bar_h]);
                    }
                }
            }
            // scraper-strip grooves (press in 3 mm silicone / PTFE strip)
            for (s = [-1, 1]) {
                translate([s*(R_ag - 3), 0, 14]) cube([4, 3, z_top_ag - z_bot], center = true);
                translate([s*(R_ag/2), 0, 1.4]) cube([R_ag - 24, 3, 3], center = true);
            }
            translate([0, 0, hub_h/2]) d_bore();
            translate([0, 0, -1]) cylinder(d = 13, h = 10);
        }
    }
}

// Paddle: two open pitched blades with windows (low drag for soups/liquids).
module paddle() {
    blade_h = 60;  blade_t = 5;  pitch = 35;
    translate([0, 0, z_bot]) {
        difference() {
            union() {
                hub();
                for (s = [-1, 1]) rotate(s > 0 ? 0 : 180)
                    translate([10, 0, 2 + blade_h/2*sin(pitch) + 0.5*blade_t])
                        rotate([pitch, 0, 0])
                            difference() {
                                translate([0, -blade_h/2, 0])
                                    cube([R_ag - 10 - 4, blade_h, blade_t]);
                                for (i = [0:2])
                                    translate([18 + i*26, 0, -1]) cylinder(d = 16, h = blade_t + 2);
                            }
                // bottom stiffening rib
                translate([-(R_ag - 6), -5, 0]) cube([2*(R_ag - 6), 10, 6.3]);
            }
            translate([0, 0, hub_h/2]) d_bore();
            translate([0, 0, -1]) cylinder(d = 13, h = 10);
        }
    }
}

// ======================= PURCHASED PARTS (for the assembly view) =====
module shaft()  { translate([0, 0, z_bot + 1]) cylinder(d = shaft_d, h = 60 - z_bot - 1); }
module bushing() {
    translate([0, 0, lid_t + gland_h - bush_len])
        difference() { cylinder(d = bush_od, h = bush_len); translate([0,0,-1]) cylinder(d = shaft_d, h = bush_len + 2); }
}
module slinger() { translate([0, 0, lid_t + gland_h + 3]) cylinder(d = 40, h = 2); }
module coupler() { translate([0, 0, 50]) cylinder(d = 19, h = 26); }
module motor() {            // PLACEHOLDER envelope of a right-angle worm gearmotor
    translate([0, 0, mplate_z + mplate_t]) {
        translate([-23, -16, 0]) cube([46, 32, 34]);
        translate([-23, 0, 17]) rotate([0, -90, 0]) cylinder(d = 32, h = 60);
    }
    translate([0, 0, 66]) cylinder(d = shaft_d, h = mplate_z + 5 - 66);
}
module ebox() { translate([14, -30, mplate_z + mplate_t]) cube([74, 60, 40]); }
module probe() {
    rotate(probe_ang) translate([probe_r, 0, 0]) {
        translate([0, 0, -probe_depth]) cylinder(d = 6, h = probe_depth + lid_t + 25);
        cylinder(d = 14, h = lid_t + 8);
    }
}
module standoffs() {
    for (sx = [-1, 1], sy = [-1, 1])
        translate([sx*standoff_x, sy*standoff_y, lid_t + 6]) cylinder(d = 8, h = standoff_h - 6);
}
module pot() {
    difference() {
        translate([0, 0, -pot_depth - 3]) cylinder(d = rim_od, h = pot_depth + 3);
        translate([0, 0, -pot_depth]) cylinder(d = pot_id, h = pot_depth + 1);
    }
}

module assembly() {
    color("#c9ccd1") difference() {
        pot();
        if (section) translate([-300, -300, -300]) cube([600, 300, 600]);
    }
    color("#b6bcc4", 0.9) lid();
    color("#8c97a3") motor_plate_placed();
    color("#d8dde3") standoffs();
    color("#2b2f36") motor();
    color("#2f6fb3") ebox();
    color("#e0a526") if (agitator == "anchor") anchor(); else paddle();
    color("#eceff3") shaft();
    color("#f4f4ef") { bushing(); slinger(); }
    color("#9aa3ad") coupler();
    color("#d6452f") probe();
}
module motor_plate_placed() { translate([0, 0, mplate_z]) motor_plate(); }

// ======================= dispatch ====================================
if (part == "lid") lid();
else if (part == "anchor") anchor();
else if (part == "paddle") paddle();
else if (part == "motor_plate") motor_plate();
else if (part == "lid_2d") lid_plate_2d();
else assembly();
