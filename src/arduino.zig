pub const start = @import("start.zig");
pub const gpio = @import("gpio.zig");
pub const uart = @import("uart.zig");

pub const CPU_FREQ = 16_000_000;

pub fn delayCycles(cycles: u32) void {
    var count: u32 = 0;
    while (count < cycles) : (count += 1) {
        asm volatile ("nop");
    }
}

pub fn delayMilliseconds(comptime ms: comptime_int) void {
    delayCycles(ms * CPU_FREQ / 10_000);
}
