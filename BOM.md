# Bill of materials

I could not open edisonstore.ge from my environment (domain blocked), so I have not checked stock or prices there.
Search the store for the **spec**; items marked **(workshop)** are unlikely to be in an electronics store.

## Electronics
| Qty | Part | Key spec | Notes |
|---|---|---|---|
| 1 | Arduino Nano (or clone) | ATmega328P, 5 V | Any 5 V Arduino works |
| 1 | DS18B20 waterproof probe | stainless 6 mm × 30 mm, -55…+125 °C, **PTFE cable** if possible | Adafruit's high-temp version is PTFE-wired, 316 stainless. Many cheap ones use PVC cable: avoid in steam. Upgrade: **PT1000 316 probe + MAX31865** board for better accuracy at 90 °C |
| 1 | 4.7 kΩ resistor | 1/4 W | DS18B20 pull-up |
| 1 | 12 V DC worm-gear motor | 20–60 rpm, ≥6 kg·cm, 8 mm D-shaft, metal gears, self-locking | e.g. "12V 30rpm worm gear motor", E-S Motor 4632WG-370CA (30 rpm, 6 kg·cm, 0.5 A). Verify datasheet. Use **food-grade grease** in the gearbox |
| 1 | Logic-level N-MOSFET | IRLZ44N or similar | Motor switch, PWM from D3 |
| 1 | Schottky diode | 1N5819 / SS34 | Flyback across the motor |
| 1 | 100 Ω and 10 kΩ resistors | | MOSFET gate and pull-down |
| 1 | Active buzzer | 5 V | Loud type, ≥85 dB |
| 1 | Push button | momentary, panel/IP65 | START/STOP |
| 1 | 10 kΩ potentiometer | linear | Speed |
| 1 | Buck converter | 12 V → 5 V, 1 A (LM2596 / MP1584) | Powers the Nano |
| 1 | 12 V DC adapter | 12 V, 3 A | Motor stall current can exceed rated |
| 1 | Fuse holder + 2 A fuse | | On the 12 V input |
| 1 | IP65 enclosure | ~80 × 60 × 40 mm | Fits the box placeholder in the CAD |
| 1 | Cable glands | PG7 | |
| opt | SSD1306 OLED 0.96" I2C | | Set `USE_OLED 1` (needs U8g2 library) |

## Mechanical
| Qty | Part | Spec | Source |
|---|---|---|---|
| 1 | Lid plate | 304 stainless 2–3 mm, laser-cut from `lid_plate_laser_cut.dxf` | (workshop), or print in PP/PA12 from `lid.stl` |
| 1 | Shaft | 304/316 stainless rod Ø8 mm, ~200 mm; bottom 12 mm turned to M6 thread | (workshop) |
| 1 | Anchor / paddle agitator | `anchor.stl` / `paddle.stl`; stainless or PP/PA12 | (workshop) / 3D print |
| 1 | PTFE bushing | 8 mm ID × 12 mm OD × 25 mm, FDA-grade virgin PTFE | (workshop) or plastics supplier |
| 1 | Flexible shaft coupler | 8 mm to 8 mm (match your motor shaft) | online |
| 1 | M6 stainless acorn (dome) nut + washer | A4 | hardware |
| 1 | Probe compression fitting | M10, 6 mm bore, PTFE/FDA ferrule | online |
| 4 | M5 × 90 male–female standoffs | stainless | hardware |
| 4 | M5 heat-set inserts (if printed lid) | | |
| 1 | Motor plate | 4 mm aluminium/stainless, `motor_plate.stl` as template | (workshop) |
| 1 | Slinger disc | Ø40 mm silicone or PTFE, 2 mm | |
| 1–2 m | Silicone or PTFE strip | 3 mm × 3 mm, food-grade | Scraper strips |
| — | Food-grade grease | NSF H1 | Gearbox / bushing |

## Reference links used in research
- [Adafruit-style high-temp DS18B20 (316 stainless, PTFE cable, 125 °C)](https://thepihut.com/products/high-temp-waterproof-ds18b20-digital-temperature-sensor-extras)
- [DS18B20 accuracy ±0.5 °C, -10…+85 °C (Analog Devices)](https://support.analog.com/en-US//knowledgebase/article/000095991)
- [Adafruit MAX31865 PT1000 amplifier](https://www.adafruit.com/products/3648)
- [E-S Motor 12 V 30 rpm worm gear motor](https://robotshop.com/products/e-s-motor-12v-30rpm-reversible-high-torque-worm-gear-dc-motor)
- [Food-safe 3D printing overview](https://jlc3dp.com/blog/food-safe-3d-printing)
- [FDA-compliant PTFE shaft seals (example)](https://ptm-mechatronics.com/en/product/wellendichtring-ptfe-fda-weiss/)
