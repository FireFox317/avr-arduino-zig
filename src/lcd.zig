const gpio = @import("gpio.zig");
const cpu = @import("cpu.zig");

const rs_pin = 12;
const en_pin = 11;
const data_pins = [4]comptime_int{ 5, 4, 3, 2 };

const cols = 16;
const rows = 2;

const Control = struct {
    const clear_display: u8 = 0x01;
    const return_home: u8 = 0x02;
    const entry_mode_set: u8 = 0x04;
    const display_control: u8 = 0x08;
    const cursor_shift: u8 = 0x10;
    const function_set: u8 = 0x20;
    const set_CGRAM_address: u8 = 0x40;
    const set_DDRAM_address: u8 = 0x80;
};

const Flags = struct {
    const entry_right = 0x00;
    const entry_left = 0x02;
    const entry_shift_inc = 0x01;
    const entry_shift_dec = 0x00;

    const blink: u8 = 0x01;
    const cursor: u8 = 0x02;
    const display_on: u8 = 0x04;

    const move_right: u8 = 0x04;
    const display_move: u8 = 0x08;

    const lcd_2lines: u8 = 0x08;
};

const CurrentDisp = struct {
    var function: u8 = undefined;
    var mode: u8 = undefined;
    var control: u8 = undefined;
};

pub fn begin() void {
    CurrentDisp.function = Flags.lcd_2lines;
    CurrentDisp.mode = 0;
    CurrentDisp.control = 0;

    gpio.init(en_pin, .output);
    gpio.init(rs_pin, .output);

    inline for (data_pins) |pin| {
        gpio.init(pin, .output);
    }

    cpu.delayMilliseconds(45);

    gpio.write(en_pin, .low);
    gpio.write(rs_pin, .low);

    write4bits(0x3);
    cpu.delayMilliseconds(5);

    write4bits(0x3);
    cpu.delayMilliseconds(5);

    write4bits(0x3);
    cpu.delayMicroseconds(120);

    write4bits(0x2);

    command(Control.function_set | CurrentDisp.function);

    displayOn();

    clear();
}

pub fn clear() void {
    command(Control.set_DDRAM_address);
    command(Control.clear_display);
    cpu.delayMilliseconds(2);
}

pub fn displayOn() void {
    CurrentDisp.control |= Flags.display_on;
    command(Control.display_control | CurrentDisp.control);
}

pub fn write(value: u8) void {
    gpio.write(rs_pin, .high);
    write4bitsTwice(value);
}

pub fn writeU16(value: u16) void {
    var val = value;
    var i: u3 = 0;
    while (i < 4) : (i += 1) {
        const nibble = @truncate(u8, (val & 0xf000) >> 12);
        switch (nibble) {
            0...9 => write('0' + nibble),
            else => write('a' - 10 + nibble),
        }
        val <<= 4;
    }
}

pub fn writeLines(line1: []const u8, line2: []const u8) void {
    for (line1) |c|
        write(c);
    command(Control.set_DDRAM_address | 0x40);
    for (line2) |c|
        write(c);
}


pub fn setCursor(col: u8, row: u8) void {
    var c = col;
    if (col > 15) c = 15;

    var off: u8 = 0;
    if (row > 0) off = 0x40;

    command(Control.set_DDRAM_address | (c + off));
}

pub fn writePanic(msg: []const u8) void {
    begin();

    for ("Panic! Msg:") |c|
        write(c);

    const short = if (msg.len > 16) msg[0..16] else msg;
    command(Control.set_DDRAM_address | 0x40);

    for (msg) |c|
        write(c);
}

fn command(value: u8) void {
    gpio.write(rs_pin, .low);
    write4bitsTwice(value);
}

fn write4bits(value: u4) void {
    inline for (data_pins) |pin, i| {
        if ((value >> i) & 1 != 0) {
            gpio.write(pin, .high);
        } else {
            gpio.write(pin, .low);
        }
    }

    pulseEnable();
}

fn write4bitsTwice(value: u8) void {
    write4bits(@truncate(u4, (value >> 4) & 0xf));
    write4bits(@truncate(u4, value & 0xf));
}

fn pulseEnable() void {
    gpio.write(en_pin, .low);
    cpu.delayMicroseconds(1);
    gpio.write(en_pin, .high);
    cpu.delayMicroseconds(1);
    gpio.write(en_pin, .low);
    cpu.delayMicroseconds(100);
}
