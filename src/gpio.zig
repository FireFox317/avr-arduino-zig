const MMIO = @import("mmio.zig").MMIO;

const DDRB = MMIO(0x24, u8, packed struct {
    DDB0: u1 = 0,
    DDB1: u1 = 0,
    DDB2: u1 = 0,
    DDB3: u1 = 0,
    DDB4: u1 = 0,
    DDB5: u1 = 0,
    DDB6: u1 = 0,
    DDB7: u1 = 0,
});

const PORTB = MMIO(0x25, u8, packed struct {
    PORTB0: u1 = 0,
    PORTB1: u1 = 0,
    PORTB2: u1 = 0,
    PORTB3: u1 = 0,
    PORTB4: u1 = 0,
    PORTB5: u1 = 0,
    PORTB6: u1 = 0,
    PORTB7: u1 = 0,
});

/// For now only supports PORTB
pub fn init(comptime pin: u8, comptime dir: enum { in = 0, out }) void {
    DDRB.write_int(@as(u8, @enumToInt(dir)) << pin);
}

pub fn toggle(comptime pin: u8) void {
    var val = PORTB.read_int();
    val ^= 1 << pin;
    PORTB.write_int(val);
}
