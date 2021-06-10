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

 //Not exactly microseconds :c
pub fn delayMicroseconds(comptime microseconds: comptime_int) void {
    var count: u32 = 0;
    while (count < microseconds * 2) : (count += 1) {
        asm volatile ("nop");
    }
}