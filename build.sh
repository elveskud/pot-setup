#!/usr/bin/env bash
# Re-export all STL/DXF from cad/pot_top.scad (requires openscad).
set -euo pipefail
cd "$(dirname "$0")/cad"
mkdir -p stl
for p in lid anchor paddle motor_plate; do
  openscad -D "part=\"$p\"" -o "stl/$p.stl" pot_top.scad
done
openscad -D 'part="lid_2d"' -o stl/lid_plate_laser_cut.dxf pot_top.scad

# clamp-on stirrer parts
for p in clamp_arm box_base box_lid blade_half; do
  openscad -D "part=\"$p\"" -o stl/$p.stl clamp_stirrer.scad
done
