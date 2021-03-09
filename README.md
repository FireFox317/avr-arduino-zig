# AVR Arduino Zig

This project can build code that can be run on an Arduino Uno, using only Zig as its **only** dependency. 

Currently only `avrdude` is an external dependency that is needed to program the chip.

## Build instructions

* `zig build` creates the executable.
* `zig build upload -Dtty=/dev/ttyACM0` uploads the code to an Arduino connected to `/dev/ttyACM0`.
* `zig build monitor -Dtty=/dev/ttyACM0` shows the serial monitor using `screen`.  
* `zig build objdump` shows the disassembly (`avr-objdump` has to be installed).