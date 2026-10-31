// Pot stirrer controller - Arduino Nano (ATmega328P, 5 V)
//
//  * Reads a stainless DS18B20 probe in the food.
//  * START/STOP button runs the agitator (speed from a potentiometer).
//  * At TRIP_C (90 C) the agitator is switched OFF immediately and the buzzer
//    sounds until the user presses the button AND the food is below
//    TRIP_C - REARM_HYST_C.
//  * If the probe is missing / shorted / not answering, it fails SAFE:
//    agitator off + a different beep pattern.
//
//  NOT TESTED ON HARDWARE.  Bench-test with a kettle + reference thermometer
//  before using with food.  This is an alarm/stirrer controller, NOT a
//  safety device for the heat source - it does not switch the stove/burner.
//
//  Libraries: OneWire, DallasTemperature.   (U8x8 OLED optional, see USE_OLED)
//
//  Wiring (Nano):
//    D2  DS18B20 data   (4.7 k pull-up to 5 V)
//    D3  MOSFET gate via 100 ohm (PWM -> motor), 10 k gate pull-down
//    D8  buzzer (active 5 V piezo)       -> if > 25 mA use a 2N2222 transistor
//    D4  START/STOP button to GND (internal pull-up)
//    A0  speed potentiometer wiper (10 k)
//    A4/A5  I2C OLED (optional)

#include <OneWire.h>
#include <DallasTemperature.h>

#define USE_OLED 0
#if USE_OLED
#include <U8x8lib.h>
U8X8_SSD1306_128X64_NONAME_HW_I2C oled(U8X8_PIN_NONE);
#endif

// ---- settings -------------------------------------------------------
const float    TRIP_C          = 90.0;    // alarm + motor stop
const float    REARM_HYST_C    = 5.0;     // must cool below TRIP_C - this to restart
const uint8_t  MIN_PWM         = 70;      // below this a worm-gear motor may stall
const uint8_t  MAX_PWM         = 255;
const uint16_t SOFT_START_MS   = 1500;
const uint32_t SENSOR_TIMEOUT  = 3000;    // ms without a valid reading -> FAULT

const uint8_t PIN_ONEWIRE = 2, PIN_MOTOR = 3, PIN_BTN = 4, PIN_BUZZ = 8, PIN_SPEED = A0;

enum State : uint8_t { IDLE, RUNNING, ALARM, FAULT };
State state = IDLE;

OneWire oneWire(PIN_ONEWIRE);
DallasTemperature sensors(&oneWire);

float    tempC        = NAN;
uint32_t lastValidMs  = 0;
uint32_t tConvStart   = 0;
bool     convPending  = false;
uint32_t runStartMs   = 0;

bool buttonPressedEvent() {            // debounced falling edge
  static bool last = HIGH; static uint32_t t = 0;
  bool now = digitalRead(PIN_BTN);
  bool ev = false;
  if (now != last && millis() - t > 40) { t = millis(); if (now == LOW) ev = true; last = now; }
  return ev;
}

void motorOff() { analogWrite(PIN_MOTOR, 0); }

void motorOn() {
  uint16_t raw = analogRead(PIN_SPEED);
  uint8_t target = map(raw, 0, 1023, MIN_PWM, MAX_PWM);
  uint32_t dt = millis() - runStartMs;
  uint8_t pwm = (dt >= SOFT_START_MS) ? target : map(dt, 0, SOFT_START_MS, MIN_PWM, target);
  analogWrite(PIN_MOTOR, pwm);
}

void buzzer(State s) {
  uint32_t m = millis();
  bool on = false;
  if (s == ALARM)      on = (m % 600) < 300;                    // beep-beep ...
  else if (s == FAULT) on = (m % 2000) < 1500;                  // long tones
  digitalWrite(PIN_BUZZ, on);
}

void readTemp() {
  if (!convPending) { sensors.requestTemperatures(); tConvStart = millis(); convPending = true; }
  else if (millis() - tConvStart >= 800) {                      // 12-bit conversion ~750 ms
    float t = sensors.getTempCByIndex(0);
    convPending = false;
    // -127 = disconnected, 85.0 exactly = power-on default value (ignore a lone one)
    if (t > -55.0 && t < 125.0 && t != DEVICE_DISCONNECTED_C) { tempC = t; lastValidMs = millis(); }
  }
}

void show() {
#if USE_OLED
  static uint32_t last = 0; if (millis() - last < 300) return; last = millis();
  char b[17];
  oled.setFont(u8x8_font_chroma48medium8_r);
  dtostrf(isnan(tempC) ? 0 : tempC, 5, 1, b); oled.drawString(0, 1, b); oled.drawString(6, 1, "C   ");
  oled.drawString(0, 3, state == IDLE ? "IDLE   " : state == RUNNING ? "STIRRING" : state == ALARM ? "!! 90C !!" : "SENSOR!!");
#endif
}

void setup() {
  pinMode(PIN_MOTOR, OUTPUT); motorOff();                       // motor OFF first
  pinMode(PIN_BUZZ, OUTPUT);  digitalWrite(PIN_BUZZ, LOW);
  pinMode(PIN_BTN, INPUT_PULLUP);
  sensors.begin();
  sensors.setResolution(12);
  sensors.setWaitForConversion(false);                          // non-blocking
  lastValidMs = millis();
#if USE_OLED
  oled.begin(); oled.setPowerSave(0);
#endif
  // power-on self-test beep
  digitalWrite(PIN_BUZZ, HIGH); delay(120); digitalWrite(PIN_BUZZ, LOW);
}

void loop() {
  readTemp();
  bool btn = buttonPressedEvent();
  bool sensorOk = (millis() - lastValidMs) < SENSOR_TIMEOUT;

  // ---- safety checks run in EVERY state --------------------------------
  if (!sensorOk) {
    if (state != FAULT) { state = FAULT; motorOff(); }
  } else if (tempC >= TRIP_C && state != ALARM) {
    state = ALARM; motorOff();
  }

  switch (state) {
    case IDLE:
      motorOff();
      if (btn && sensorOk && tempC < TRIP_C) { state = RUNNING; runStartMs = millis(); }
      break;
    case RUNNING:
      motorOn();
      if (btn) { state = IDLE; motorOff(); }
      break;
    case ALARM:                                                 // latched
      motorOff();
      if (btn && tempC < TRIP_C - REARM_HYST_C) state = IDLE;
      break;
    case FAULT:
      motorOff();
      if (btn && sensorOk) state = IDLE;
      break;
  }
  buzzer(state);
  show();
}
