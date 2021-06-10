const arduino = @import("arduino");
const std = @import("std");

// Necessary, and has the side effect of pulling in the needed _start method
pub const panic = arduino.start.panicLogUart;

pub fn main() void {
    arduino.lcd.begin();
    arduino.lcd.writeLines("  Hello", "    World!!");
}
