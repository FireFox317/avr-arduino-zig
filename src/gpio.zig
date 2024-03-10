const regs = @import("atmega328p.zig").registers;

const MODE = enum { in, out };

// PORTB: pins D8 to D13
fn init_portb(pin: u3, comptime dir: MODE) void {
    regs.PORTB.DDRB.* = @as(u8, @intFromEnum(dir)) << pin;
}

pub fn toggle_portb(comptime pin: u3) void {
    var val = regs.PORTB.PORTB.*;
    val ^= 1 << pin;
    regs.PORTB.PORTB.* = val;
}

// PORTD: pins D0 TO D7
fn init_portd(pin: u3, comptime dir: MODE) void {
    regs.PORTD.DDRD.* = @as(u8, @intFromEnum(dir)) << pin;
}

pub fn toggle_portd(comptime pin: u3) void {
    var val = regs.PORTD.PORTD.*;
    val ^= 1 << pin;
    regs.PORTD.PORTD.* = val;
}

// TODO: PORTC: analog pins

pub const PIN = enum {
    D0,
    D1,
    D2,
    D3,
    D4,
    D5,
    D6,
    D7,
    D8,
    D9,
    D10,
    D11,
    D12,
    D13,
    A0,
    A1,
    A3,
    A4,
    A5,
};

pub fn init(comptime pin: PIN, comptime dir: MODE) void {
    const i = @intFromEnum(pin);
    if (i <= 7) {
        init_portd(@as(u3, @intCast(i)), dir);
    } else if (i >= 8 and i <= 13) {
        init_portb(@as(u3, @intCast(i - 8)), dir);
    }
}

pub fn toggle(comptime pin: PIN) void {
    const i = comptime @intFromEnum(pin);
    if (i <= 7) {
        toggle_portd(@as(u3, @intCast(i)));
    } else if (i >= 8 and i <= 13) {
        toggle_portb(@as(u3, @intCast(i - 8)));
    }
}
