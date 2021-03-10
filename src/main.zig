const uart = @import("uart.zig");
const gpio = @import("gpio.zig");

// This is put in the data section
var ch: u8 = '!';

// This ends up in the bss section
var bss_stuff: [9]u8 = .{ 0, 0, 0, 0, 0, 0, 0, 0, 0 };

pub fn main() void {
    uart.init(115200);
    uart.write("All your codebase are belong to us!\r\n\r\n");

    if (bss_stuff[0] == 0)
        uart.write("Ahh its actually zero!\r\n");

    bss_stuff = "\r\nhello\r\n".*;
    uart.write(&bss_stuff);

    gpio.init(5, .out);

    while (true) {
        uart.write_ch(ch);
        if (ch < '~') {
            ch += 1;
        } else {
            ch = '!';
            uart.write("\r\n");
        }

        gpio.toggle(5);
        delay_cycles(50000);
    }
}

fn delay_cycles(cycles: u32) void {
    var count: u32 = 0;
    while (count < cycles) : (count += 1) {
        asm volatile ("nop");
    }
}
