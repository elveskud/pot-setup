# Stirring lid for a spun-aluminium saucepot

A lid ("top") with a motor-driven agitator, a food-contact temperature probe,
and a controller that **beeps and stops the agitator at 90 °C**.

```
cad/pot_top.scad            parametric OpenSCAD model (edit the POT section!)
cad/stl/                    lid, anchor agitator, paddle agitator, motor plate (STL) + lid_plate_laser_cut.dxf
cad/renders/                assembly pictures
firmware/pot_controller/    Arduino Nano sketch (untested on hardware)
BOM.md                      parts list with specs to search for
```

## IMPORTANT: the dimensions are estimates
The photo has no scale. The model assumes **inside diameter 220 mm, depth 140 mm,
wall 3 mm**. Measure and edit the `POT` block at the top of `cad/pot_top.scad`:

1. Inside diameter at the rim (and 10 mm below the rim)
2. Inside depth (rim to floor)
3. Rim wall thickness, and whether the rim is rolled/flared
4. Where the two bail handles attach (the lid has finger tabs at ±Y; rotate if they clash)

Re-export: `./build.sh`  (needs `openscad`).

## How it works
- **Lid**: flat plate resting on the rim, with a 10 mm spigot ring that centres it in the bore, two steam vents (at ±Y, away from the electronics), a probe port, and a gland boss for the shaft.
- **Shaft**: 8 mm 304/316 stainless rod runs through a PTFE bushing in the lid. A slinger disc stops condensate running up the shaft. A flexible coupler joins it to the gearmotor shaft, so the motor sits **90 mm above the lid** out of the hottest steam.
- **Agitators** (swap by unscrewing one acorn nut): **anchor** (sweeps floor and wall, with grooves for silicone/PTFE scraper strips; best for sauces, milk, custard) and **paddle** (open pitched blades; lower drag for soups and liquids). Both clear the probe.
- **Probe**: 6 mm stainless probe through an M10 compression fitting, tip 75 mm below the rim. Keep the tip **below the liquid surface and clear of the pot wall/floor**.
- **Controller**: see `firmware/`. Probe fault (unplugged/shorted) also stops the agitator and sounds a different tone.

## Things you should know before building
1. **Food-contact materials.** Parts that touch food should be 304/316 stainless, PTFE (FDA grade), or food-grade silicone. The anchor/paddle are drawn as one-piece parts; make them in **stainless (laser cut + welded/bent, or CNC)** or print them in **PP or PA12** with a manufacturer food-contact declaration. **Do not use PETG** (softens around 80 °C) **or PLA/ABS** for hot parts. Printed surfaces have layer crevices that hold bacteria; prefer metal for a reusable food tool.
2. **Sensor accuracy at 90 °C.** The DS18B20 is only specified to ±0.5 °C up to +85 °C; above that the error band is wider (about ±2 °C per vendor listings; verify in the datasheet). For a precise 90 °C trip use a PT1000 probe with a MAX31865 board (see BOM). Either way, calibrate against a reference thermometer in a hot water bath.
3. **This is not a heat-source safety device.** It stops the agitator and beeps. It does not switch the stove.
4. **Heat/steam.** Mount the electronics box and motor on the tower, never on the lid. Use an IP65 enclosure and keep mains voltage out of it (12 V DC supply only).
5. **Motor** dimensions in the CAD are a *placeholder envelope*. Replace with the dimensions of the gearmotor you buy and adjust the mounting holes in `motor_plate()`.
6. The lid is about 232 mm across: too big for many printers. Use the supplied `lid_plate_laser_cut.dxf` (2–3 mm stainless) and make the spigot ring from a rolled strip, or print the lid in segments.

## Status
Model renders clean (lid, anchor, paddle, motor plate are valid solids). Firmware and electronics have **not** been built or tested.


## Alternative: clamp-on stirrer (Stirmate-style, fully 3D-printable)
`cad/clamp_stirrer.scad` is a lid-free version: a printed clamp hooks over the pot rim, an arm carries a
37 mm gearmotor to the pot centre, a split-hub blade (two identical printed halves) clamps a 6 mm rod, a
and a small box on the arm holds a PWM speed controller. It is agitator only: no probe or alarm (`with_probe = true` in the CAD adds an optional probe tube).
Parts list and print notes: **BOM_clamp.md**. Preview: `cad/renders/clamp_side.png`.
**Status:** CAD exports as valid solids, but nothing was printed or built. Verify the motor mounting pattern
and measure your pot (`POT` block) before printing. The blade top is 7 mm below the probe tube bottom
and the jaws; keep that clearance if you change heights.
