# Clamp-on stirrer (agitator only): parts list

No probe, no alarm, no Arduino: a motor, a speed knob and a power switch.
Prices/stock not checked: search a shop for the **spec**.

## Electronics
| Qty | Part | Spec | Notes |
|---|---|---|---|
| 1 | Gearmotor, 37 mm | **12 V DC brushed, 30–60 rpm output, ≥ 15 kg·cm rated, 6 mm D-shaft, 12 mm boss, 6 × M3 holes on 31 mm circle** | Check your motor's datasheet and edit `m_pcd`, `m_boss_d` in the CAD if it differs |
| 1 | PWM DC motor speed controller module | 12 V, ≥ 5 A, with on-board potentiometer (the common "DC 6–28 V 5–10 A PWM motor controller") | Replaces the Arduino. Desolder the board pot and wire a panel pot if the board's knob won't fit the lid; or just use the small box and mount the module inside |
| 1 | 10 kΩ–100 kΩ panel potentiometer + knob | 6 mm shaft | Only if the module has a pin header for an external pot; otherwise skip |
| 1 | Switch, 12 mm round panel mount | SPST on/off, ≥ 5 A at 12 V | In the 12 V line |
| 1 | 12 V DC power supply | **12 V, 3 A**, 5.5 × 2.1 mm plug | Stall current can exceed rated current |
| 1 | DC barrel jack, panel mount | 5.5 × 2.1 mm, 11 mm hole | |
| 1 | Inline fuse holder + 3 A fuse | | On the 12 V input |
| 1 | PG7 cable gland | 12.5 mm hole | Motor cable out of the box |
| — | Wire (18–20 AWG), crimp/screw terminals, 100 nF ceramic capacitor across the motor terminals | | |
| opt | Battery instead of mains | 3S Li-ion pack (11.1 V, ≥ 3 Ah) with BMS + charger | Protected pack only. Not tested here |

Wiring: supply → fuse → switch → PWM module → motor.

## Mechanical / hardware
| Qty | Part | Notes |
|---|---|---|
| 1 | Stainless rod Ø6 mm, 304/316 | Length = **pot depth + 50 mm** (e.g. 140 mm deep → 190 mm), cut for the arm at its lowest position. Raise the arm for deeper pots |
| 1 | **Vertical post: Ø12 mm rod, aluminium or stainless, 260 mm** | The arm slides on it. Must be a smooth round rod, 11.9–12.0 mm |
| 3 | M5 thumb screws (≈ 20 mm) + 3 M5 nuts | 1 locks the post in the clamp, 2 lock the sliding arm (hex nut traps are in the CAD) |
| 1 | Rigid shaft coupler 6 mm → 6 mm | Set-screw type, ~25 mm long |
| 1 | M6 thumb screw, **40–45 mm** + M6 nut | Rim clamp screw (the outer jaw is 24 mm thick). Add a silicone/rubber pad on the tip |
| 6 | M3 × 10 screws | Motor to arm (heads sit in counterbores under the arm). **Do not use longer: the motor's threaded holes are shallow** |
| 2 | M4 × 20 screws + 2 M4 nuts | Box to arm (nuts sit in hex traps under the arm) |
| 4 | M4 × 25 screws + 4 M4 nuts | Blade halves clamp the rod |
| 1 | Dowel / roll pin Ø3 × 26 mm stainless (optional) | Cross pin through hub and rod |
| 4 | M3 heat-set inserts + 4 M3 × 8 screws | Box lid |
| — | Silicone pads, cable ties, food-grade (NSF H1) grease | |

## Print settings
| Part | Qty | Orientation | Material |
|---|---|---|---|
| `clamp_arm` (rim clamp + post socket) | 1 | **On its side** (the profile lies flat on the bed, 40 mm tall), no supports | **ABS**, 4+ walls, 40–50 % infill. Bores and the M6 hole may need a touch of cleanup |
| `arm_slide` (sliding arm + motor plate) | 1 | **On its side**, no supports | **ABS**, 5 walls, 50 % infill |
| `blade_half` | 2 | Flat face (y = 0) on the bed | PP, PA12 or similar, 4+ walls, 100 % infill near the hub |
| `box_base`, `box_lid` | 1 each | Open side up / flat | ABS |

The second `blade_half` needs no mirroring: the assembly rotates it 180°.

**Food contact.** The blades, the rod and the inner clamp jaw are in or near the food. Print them in food-safe material (PP/PA12 with a manufacturer declaration, or order in nylon from a print service), or use stainless blades. Layer lines trap residue, so wash well and keep prints for occasional home use only. Do not use PLA, ABS or PETG for anything that sits in hot liquid.
