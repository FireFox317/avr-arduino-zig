const arduino = @import("arduino");
const gpio = arduino.gpio;

// Necessary, and has the side effect of pulling in the needed _start method
pub const panic = arduino.start.panicHang;

const LED: u8 = 13;

pub fn main() void {

    gpio.init(LED, .output);

    while(true) {
        gpio.write(LED, .high);
        
        arduino.delayMilliseconds(500);

        gpio.write(LED, .low);
        
        arduino.delayMilliseconds(500);
    }
}
