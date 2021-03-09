const uart = @import("uart.zig");
const gpio = @import("gpio.zig");

pub fn main() void {
    uart.init(115200);
    uart.write("hello!\r\n");

    gpio.init(5, .out);

    while (true) {
        uart.write(".");
        gpio.toggle(5);
        delay_cycles(200000);
    }
}

fn delay_cycles(cycles: u32) void {
    var count: u32 = 0;
    while (count < cycles) : (count += 1) {
        asm volatile ("nop");
    }
}
