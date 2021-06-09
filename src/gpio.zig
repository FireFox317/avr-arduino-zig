const MMIO = @import("mmio.zig").MMIO;

 const PINB = MMIO(0x23, u8, packed struct {
    PINB0: u1 = 0,
    PINB1: u1 = 0,
    PINB2: u1 = 0,
    PINB3: u1 = 0,
    PINB4: u1 = 0,
    PINB5: u1 = 0,
    PINB6: u1 = 0,
    PINB7: u1 = 0,
});

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

 const PINC = MMIO(0x26, u8, packed struct {
    PINC0: u1 = 0,
    PINC1: u1 = 0,
    PINC2: u1 = 0,
    PINC3: u1 = 0,
    PINC4: u1 = 0,
    PINC5: u1 = 0,
    PINC6: u1 = 0,
    PINC7: u1 = 0,
});

const DDRC = MMIO(0x27, u8, packed struct {
    DDC0: u1 = 0,
    DDC1: u1 = 0,
    DDC2: u1 = 0,
    DDC3: u1 = 0,
    DDC4: u1 = 0,
    DDC5: u1 = 0,
    DDC6: u1 = 0,
    DDC7: u1 = 0,
});

const PORTC = MMIO(0x28, u8, packed struct {
    PORTC0: u1 = 0,
    PORTC1: u1 = 0,
    PORTC2: u1 = 0,
    PORTC3: u1 = 0,
    PORTC4: u1 = 0,
    PORTC5: u1 = 0,
    PORTC6: u1 = 0,
    PORTC7: u1 = 0,
});

const PIND = MMIO(0x29, u8, packed struct {
    PIND0: u1 = 0,
    PIND1: u1 = 0,
    PIND2: u1 = 0,
    PIND3: u1 = 0,
    PIND4: u1 = 0,
    PIND5: u1 = 0,
    PIND6: u1 = 0,
    PIND7: u1 = 0,
});

const DDRD = MMIO(0x2A, u8, packed struct {
    DDD0: u1 = 0,
    DDD1: u1 = 0,
    DDD2: u1 = 0,
    DDD3: u1 = 0,
    DDD4: u1 = 0,
    DDD5: u1 = 0,
    DDD6: u1 = 0,
    DDD7: u1 = 0,
});

const PORTD = MMIO(0x2B, u8, packed struct {
    PORTD0: u1 = 0,
    PORTD1: u1 = 0,
    PORTD2: u1 = 0,
    PORTD3: u1 = 0,
    PORTD4: u1 = 0,
    PORTD5: u1 = 0,
    PORTD6: u1 = 0,
    PORTD7: u1 = 0,
});

pub fn init(comptime pin: comptime_int, comptime mode: enum { input, output, input_pullup }) void {
    switch (pin) {
        0...7 => {
            var val = DDRD.readInt();
            if (mode == .output) {
                val |= 1 << (pin - 0);
            } else {
                val &= ~@as(u8, 1 << (pin - 0));
            }
            DDRD.writeInt(val);
        },
        8...13 => {
            var val = DDRB.readInt();
            if (mode == .output) {
                val |= 1 << (pin - 8);
            } else {
                val &= ~@as(u8, 1 << (pin - 8));
            }
            DDRB.writeInt(val);
        },
        14...19 => {
            var val = DDRC.readInt();
            if (mode == .output) {
                val |= 1 << (pin - 14);
            } else {
                val &= ~@as(u8, 1 << (pin - 14));
            }
            DDRC.writeInt(val);
        },
        else => @compileError("Only port B, C and D are available yet (arduino pins 0 through 19)."),
    }

    if (mode == .input_pullup) {
        write(pin, .high);
    } else {
        write(pin, .low);
    }
}

pub fn read(comptime pin: comptime_int) bool {
    switch (pin) {
        0...7 => {
            var val = PIND.readInt();
            return (val & (1 << (pin - 0))) != 0;
        },
        8...13 => {
            var val = PINB.readInt();
            return (val & (1 << (pin - 8))) != 0;
        },
        14...19 => {
            var val = PINC.readInt();
            return (val & (1 << (pin - 14))) != 0;
        },
        else => @compileError("Only port B, C and D are available yet (arduino pins 0 through 19)."),
    }
}

pub fn write(comptime pin: comptime_int, comptime value: enum { low, high }) void {
    switch (pin) {
        0...7 => {
            var val = PORTD.readInt();
            if (value == .high) {
                val |= 1 << (pin - 0);
            } else {
                val &= ~@as(u8, 1 << (pin - 0));
            }
            PORTD.writeInt(val);
        },
        8...13 => {
            var val = PORTB.readInt();
            if (value == .high) {
                val |= 1 << (pin - 8);
            } else {
                val &= ~@as(u8, 1 << (pin - 8));
            }
            PORTB.writeInt(val);
        },
        14...19 => {
            var val = PORTC.readInt();
            if (value == .high) {
                val |= 1 << (pin - 14);
            } else {
                val &= ~@as(u8, 1 << (pin - 14));
            }
            PORTC.writeInt(val);
        },
        else => @compileError("Only port B, C and D are available yet (arduino pins 0 through 19)."),
    }
}

pub fn toggle(comptime pin: comptime_int) void {
    switch (pin) {
        0...7 => {
            var val = PORTD.readInt();
            val ^= 1 << (pin - 0);
            PORTD.writeInt(val);
        },
        8...13 => {
            var val = PORTB.readInt();
            val ^= 1 << (pin - 8);
            PORTB.writeInt(val);
        },
        14...19 => {
            var val = PORTC.readInt();
            val ^= 1 << (pin - 14);
            PORTC.writeInt(val);
        },
        else => @compileError("Only port B, C and D are available yet (arduino pins 0 through 19)."),
    }
}
