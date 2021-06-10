# AVR Arduino Zig

This project can build code that can be run on an Arduino Uno, using only Zig as its **only** dependency. 

Currently only `avrdude` is an external dependency that is needed to program the chip.

## Build instructions

* `zig build` creates the executable.
* `zig build upload -Dtty=/dev/ttyACM0` uploads the code to an Arduino connected to `/dev/ttyACM0`.
* `zig build monitor -Dtty=/dev/ttyACM0` shows the serial monitor using `screen`.  
* `zig build objdump` shows the disassembly (`avr-objdump` has to be installed).


## Debug and development

* `avr-nm --size-sort --reverse-sort -td zig-out/bin/blink` shows sorted symbol sizes
https://arduino.stackexchange.com/a/13219/77598

## Board info


- original api: https://github.com/arduino/ArduinoCore-API
- pins: https://github.com/arduino/ArduinoCore-avr/blob/24e6edd475c287cdafee0a4db2eb98927ce3cf58/variants/standard/pins_arduino.h

- libraries: 
    * https://github.com/arduino-libraries/LiquidCrystal

- delay & delayMicros avr efficient implementation example:
    https://github.com/arduino/ArduinoCore-avr/blob/24e6edd475c287cdafee0a4db2eb98927ce3cf58/cores/arduino/wiring.c
    ArduinoCore-avr/cores/arduino/wiring.cs
