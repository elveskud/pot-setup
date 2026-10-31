// =====================================================================
//  Clamp-on pot stirrer (Stirmate-style) - 3D-printable, parametric
//  Units: mm.  Coordinates: Z = 0 is the plane of the pot rim,
//  +Z up, pot centre axis is X = 0, Y = 0.  The clamp sits at -X.
//
//  !! MEASURE YOUR POT (POT block).  Defaults are the same ESTIMATES as
//  the lid design.  Motor dimensions are for a generic 37 mm gearmotor
//  (6 mm D shaft, 12 mm boss, 6x M3 on a 31 mm circle): VERIFY vs datasheet.
//
//  Parts (print each once unless noted):
//    clamp_arm   - rim clamp + riser + arm + motor plate   (prints on its SIDE)
//    box_base, box_lid  - controller enclosure (bolts to the arm)
//    blade_half  - agitator half, print 2x (identical: one is flipped)
//  render:  openscad -D 'part="clamp_arm"' -o clamp_arm.stl clamp_stirrer.scad
//  part = "assembly" | "clamp_arm" | "box_base" | "box_lid" | "blade_half"
// =====================================================================
part    = "assembly";
section = true;                 // assembly: cut the pot open

// ---------------- POT (MEASURE) --------------------------------------
pot_id     = 220;   // inside diameter at the rim
pot_depth  = 140;   // rim to inside floor
pot_wall   = 3;     // wall thickness at the rim
rim_bead   = 2;     // how far a rolled rim sticks out past the wall (0 if none)
floor_gap  = 3;     // blade <-> floor
wall_gap   = 3;     // blade <-> wall

// ---------------- CLAMP / ARM ---------------------------------------
w          = 40;    // part width (Y)
jaw_t      = 10;    // outer jaw thickness (holds M6 nut trap)
in_jaw_t   = 6;     // inner jaw thickness
jaw_d      = 40;    // how far the jaws hang below the rim
bridge_t   = 8;     // bridge over the rim
riser_t    = 16;
arm_z      = 60;    // underside of arm above the rim
arm_t      = 10;
arm_end    = 22;    // arm tip x (motor sits at x = 0)
screw_z    = -22;   // clamp screw height (M6 thumb screw)

// probe tube (6 mm x 30 mm stainless probe drops in from the top)
probe_tip  = 60;    // depth of probe TIP below the rim (must be under liquid)
probe_len  = 30;
probe_d    = 6.4;

// ---------------- MOTOR (37 mm gearmotor, verify) -------------------
m_pcd      = 31;    // M3 bolt circle
m_boss_d   = 14;    // clearance for the 12 mm gearbox boss
m_screw_d  = 3.4;

// ---------------- AGITATOR -------------------------------------------
rod_d      = 6;
hub_h      = 34;
blade_h    = 66;    // wall blade height; keep tip below the jaws/probe tube

// ---------------- derived --------------------------------------------
R_o    = pot_id/2 + pot_wall;
xo1    = -(R_o + rim_bead);           // inner face of outer jaw
xo0    = xo1 - jaw_t;
xi0    = -pot_id/2 + 1;               // inner jaw, inside the bore
xi1    = xi0 + in_jaw_t;
arm_top= arm_z + arm_t;
z_bot  = -(pot_depth - floor_gap);
R_ag   = pot_id/2 - wall_gap;
probe_x= xi1 + 14;                    // probe tube centre (stays off the hot wall)
$fn = 48;

// ======================= CLAMP ARM ===================================
module profile() {                    // side profile in the XZ plane (2D x,z)
  union() {
    translate([xo0, -jaw_d])          square([jaw_t, jaw_d + 0.5 + bridge_t]); // outer jaw
    translate([xi0, -jaw_d])          square([in_jaw_t, jaw_d + 0.5 + bridge_t]); // inner jaw
    translate([xo0, 0.5])             square([xi1 - xo0, bridge_t]);          // bridge
    translate([xo0, 0.5])             square([riser_t, arm_top - 0.5]);       // riser
    translate([xo0, arm_z])           square([arm_end - xo0, arm_t]);         // arm
    polygon([[xo0+riser_t, arm_z],[xo0+riser_t+50, arm_z],[xo0+riser_t, arm_z-50]]); // gusset
    // probe tube block (full width keeps it printable without supports)
    translate([probe_x-8, -probe_tip-4]) square([16, probe_tip+4 - 25]);
    translate([xi1-1, -probe_tip-4]) square([probe_x-8-xi1+2, probe_tip+4-25]);   // web tying tube to the inner jaw
  }
}

module clamp_arm() {
  difference() {
    translate([0, w/2, 0]) rotate([90,0,0]) linear_extrude(w) profile();
    // M6 clamp screw through outer jaw + hex nut trap on outside face
    translate([xo0-1, 0, screw_z]) rotate([0,90,0]) cylinder(d=6.5, h=jaw_t+2);
    translate([xo0-1, 0, screw_z]) rotate([0,90,0]) cylinder(d=11.6, h=1+5.5, $fn=6);
    // motor plate: boss clearance + 6 x M3 with counterbores from below
    translate([0,0,arm_z-1]) cylinder(d=m_boss_d, h=arm_t+2);
    for (a=[0:60:359]) rotate(a) translate([m_pcd/2,0,arm_z-1]) {
      cylinder(d=m_screw_d, h=arm_t+2);
      cylinder(d=6.6, h=1+5);
    }
    // box mounting: 2 x M4, nut traps on the underside
    for (x=[-98,-30]) translate([x,0,arm_z-1]) {
      cylinder(d=4.4, h=arm_t+2);
      cylinder(d=8.4, h=1+3.6, $fn=6);
    }
    // probe tube bore (open top) + lip at bottom so the probe tip pokes out
    translate([probe_x,0,-probe_tip])      cylinder(d=probe_d, h=probe_len+probe_len);
    translate([probe_x,0,-probe_tip-5])    cylinder(d=4.6, h=10);
    // cable zip-tie slot beside the tube top
    translate([probe_x-8-1,-3,-30]) cube([2,6,6]);
  }
}

// ======================= ELECTRONICS BOX ==============================
bx_l = 84; bx_w = 58; bx_h = 30; bx_wall = 2.4;
bx_x = -64;                                  // box centre x on the arm
module box_base() {
  difference() {
    union() {
      difference() {
        translate([-bx_l/2,-bx_w/2,0]) cube([bx_l,bx_w,bx_h]);
        translate([-bx_l/2+bx_wall,-bx_w/2+bx_wall,bx_wall]) cube([bx_l-2*bx_wall,bx_w-2*bx_wall,bx_h]);
      }
      for (sx=[-1,1],sy=[-1,1]) translate([sx*(bx_l/2-5),sy*(bx_w/2-5),0]) cylinder(d=8,h=bx_h); // M3 lid posts
    }
    for (sx=[-1,1],sy=[-1,1]) translate([sx*(bx_l/2-5),sy*(bx_w/2-5),bx_h-12]) cylinder(d=4.2,h=13); // M3 heat-set
    for (x=[-34,34]) translate([x,0,-1]) cylinder(d=4.4,h=bx_wall+2);              // M4 to arm
    translate([bx_l/2-6,-14,12]) rotate([0,90,0]) cylinder(d=12.5,h=10);           // PG7 gland: motor
    translate([bx_l/2-6, 14,12]) rotate([0,90,0]) cylinder(d=12.5,h=10);           // PG7 gland: probe
    translate([-bx_l/2-1, 0,14]) rotate([0,90,0]) cylinder(d=11,h=10);             // DC barrel jack
  }
}
module box_lid() {
  difference() {
    translate([-bx_l/2,-bx_w/2,0]) cube([bx_l,bx_w,bx_wall]);
    for (sx=[-1,1],sy=[-1,1]) translate([sx*(bx_l/2-5),sy*(bx_w/2-5),-1]) cylinder(d=3.4,h=bx_wall+2);
    translate([-20, 12,-1]) cylinder(d=7.2,h=bx_wall+2);    // speed pot (6 mm shaft)
    translate([ 0, 12,-1]) cylinder(d=12.2,h=bx_wall+2);    // START/STOP button
    for (i=[0:2],j=[0:2]) translate([18+i*5,-12+j*5,-1]) cylinder(d=2,h=bx_wall+2); // buzzer holes
    translate([-30,-12,-1]) cylinder(d=3.4,h=bx_wall+2);    // spare / LED
  }
}

// ======================= AGITATOR HALF ================================
// Two identical halves clamp the 6 mm rod; the second is the first rotated 180 deg.
module blade_profile() polygon([[0,0],[R_ag,0],[R_ag,blade_h],[R_ag-12,blade_h],
                                [R_ag-12,16],[45,16],[13,34],[0,34]]);
module blade_half() {
  difference() {
    union() {
      translate([-14,0,0]) cube([28,13,hub_h]);                       // hub half-block
      translate([0,6,0]) rotate([90,0,0]) linear_extrude(6) blade_profile(); // blade plate
    }
    translate([0,0,-1]) cylinder(d=rod_d+0.3,h=hub_h+2);              // rod groove
    for (z=[9,25]) {
      // M4 clamp bolts along Y; head recess at +x, nut trap at -x (mate flips them)
      translate([ 9.5,-1,z]) rotate([-90,0,0]) cylinder(d=4.4,h=16);
      translate([-9.5,-1,z]) rotate([-90,0,0]) cylinder(d=4.4,h=16);
      translate([ 9.5, 9,z]) rotate([-90,0,0]) cylinder(d=8,h=5);
      translate([-9.5, 9,z]) rotate([-90,0,0]) cylinder(d=8.3,h=5,$fn=6);
    }
    translate([0,-1,hub_h/2]) rotate([-90,0,0]) cylinder(d=3.2,h=16);  // 3 mm cross pin
  }
}

// ======================= ASSEMBLY (visual) ============================
module assembly() {
  color("silver",0.35) difference() {                                  // pot
    translate([0,0,-pot_depth]) cylinder(d=pot_id+2*pot_wall,h=pot_depth);
    translate([0,0,-pot_depth+pot_wall]) cylinder(d=pot_id,h=pot_depth);
    if (section) translate([-300,0,-pot_depth-1]) cube([600,300,pot_depth+2]);
  }
  color("orange") clamp_arm();
  color("seagreen") translate([bx_x,0,arm_top]) { box_base();
    translate([0,0,bx_h]) box_lid(); }
  color("dimgray") translate([0,0,arm_top]) cylinder(d=37,h=100);      // motor
  color("steelblue") translate([0,0,z_bot+1]) cylinder(d=rod_d,h=arm_z-12-z_bot); // rod
  color("tomato") translate([0,0,z_bot]) { blade_half();
    rotate(180) blade_half(); }
  color("white") translate([probe_x,0,-probe_tip]) cylinder(d=6,h=probe_len); // probe
}

if (part=="assembly")   assembly();
if (part=="clamp_arm")  clamp_arm();
if (part=="box_base")   box_base();
if (part=="box_lid")    box_lid();
if (part=="blade_half") blade_half();
