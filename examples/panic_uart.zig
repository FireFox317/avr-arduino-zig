const arduino = @import("arduino");

// Necessary, and has the side effect of pulling in the needed _start method
pub const panic = arduino.start.panicLogUart;

pub fn main() void {
    arduino.uart.init(arduino.CPU_FREQ, 115200); // needed for panic logging

    var x: u8 = 255;
    x += 1; // PANIC!
}
