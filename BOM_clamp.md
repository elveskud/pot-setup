# Clamp-on stirrer: parts list

Controller firmware is unchanged: `firmware/pot_controller/` (Arduino Nano, 90 °C alarm + motor stop).
Prices/stock not checked: search a shop for the **spec**.

## Electronics
| Qty | Part | Spec | Notes |
|---|---|---|---|
| 1 | Arduino Nano (or clone) | ATmega328P, 5 V | |
| 1 | Gearmotor, 37 mm | **12 V DC brushed, 30–60 rpm output, ≥ 15 kg·cm rated (stall ≥ 30), 6 mm D-shaft, 12 mm boss, 6 × M3 holes on 31 mm circle** | The CAD motor plate matches this common "37D" pattern. **Check your motor's datasheet** and edit `m_pcd`, `m_boss_d`. No encoder needed. |
| 1 | DS18B20 waterproof probe | 316 stainless **6 mm × 30 mm**, PTFE cable | The tube in the clamp is sized for this probe. For ±0.5 °C near 90 °C use PT1000 + MAX31865 instead |
| 1 | 4.7 kΩ resistor | 1/4 W | DS18B20 pull-up (D2 → 5 V) |
| 1 | Logic-level N-MOSFET | IRLZ44N | Motor switch, PWM on D3 |
| 1 | 100 Ω + 10 kΩ resistors | | Gate resistor / gate pull-down |
| 1 | Schottky diode | 1N5819 or SS34 | Flyback across motor |
| 1 | Capacitor 470 µF 25 V + 100 nF ceramic | | 12 V rail smoothing; 100 nF across motor terminals |
| 1 | Buck converter 12 V → 5 V | 1 A (Mini560 / LM2596 / MP1584) | Powers the Nano from the 12 V rail |
| 1 | Active buzzer | 5 V, ≥ 85 dB | D8 (add a 2N2222 + 1 kΩ if it draws > 25 mA) |
| 1 | Momentary push button | 12 mm panel mount | START/STOP, D4 to GND |
| 1 | 10 kΩ linear potentiometer + knob | 6 mm shaft | Speed, A0 |
| 1 | 12 V DC power supply | **12 V, 3 A**, 5.5 × 2.1 mm barrel plug | Stall current can exceed rated current |
| 1 | DC barrel jack, panel mount | 5.5 × 2.1 mm, 11 mm hole | |
| 1 | Inline fuse holder + 2–3 A fuse | | On the 12 V input |
| 2 | Cable gland PG7 | 12.5 mm hole | Motor cable, probe cable |
| 1 | Perfboard + wire + screw terminals / JST-XH | | |
| opt | SSD1306 0.96" I2C OLED | | Set `USE_OLED 1` in firmware |
| opt | Battery instead of mains | 3S Li-ion pack (11.1 V, ≥ 3 Ah) with BMS and 12.6 V charger | Use only a protected pack, not bare cells. Not tested here |

Wiring is in the header of `firmware/pot_controller/pot_controller.ino`.

## Mechanical / hardware
| Qty | Part | Notes |
|---|---|---|
| 1 | Stainless rod Ø6 mm, 304/316, **~200 mm** | Cut to `pot_depth + arm_z − 5`. Optional: drill a Ø3 mm cross hole 20 mm from the lower end |
| 1 | Rigid shaft coupler 6 mm → 6 mm | Set-screw type, ~25 mm long |
| 1 | M6 thumb screw, 30–40 mm + M6 nut | Clamp screw. Add a silicone/rubber pad on the tip |
| 6 | M3 × 10 screws | Motor to arm (heads sit in counterbores under the arm). **Do not use longer: the motor's threaded holes are shallow** |
| 2 | M4 × 20 screws + 2 M4 nuts | Box to arm (nuts sit in hex traps under the arm) |
| 4 | M4 × 25 screws + 4 M4 nuts | Blade halves clamp the rod |
| 1 | Dowel / roll pin Ø3 × 26 mm stainless (optional) | Cross pin through hub and rod |
| 4 | M3 heat-set inserts + 4 M3 × 8 screws | Box lid |
| — | Silicone pads, cable ties, food-grade (NSF H1) grease | |

## Print settings
| Part | Qty | Orientation | Material |
|---|---|---|---|
| `clamp_arm` | 1 | **On its side** (the profile lies flat on the bed, 40 mm tall), no supports | PETG or ASA, 4+ walls, 40–50 % infill. Bores and the M6 hole may need a touch of cleanup |
| `blade_half` | 2 | Flat face (y = 0) on the bed | PP, PA12 or similar, 4+ walls, 100 % infill near the hub |
| `box_base`, `box_lid` | 1 each | Open side up / flat | PETG |

The second `blade_half` needs no mirroring: the assembly rotates it 180°.

**Food contact.** The blades, the rod, the probe tube and the inner clamp jaw are in or near the food. Print them in food-safe material (PP/PA12 with a manufacturer declaration, or order in nylon from a print service), or use stainless blades. Layer lines trap residue, so wash well and keep prints for occasional home use only. Do not use PLA, ABS or PETG for anything that sits in hot liquid.
