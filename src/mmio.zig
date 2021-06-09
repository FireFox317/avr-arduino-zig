pub fn MMIO(comptime addr: usize, comptime IntT: type, comptime PackedT: type) type {

    return struct {

        pub fn ptr() *volatile IntT {
            return @intToPtr(*volatile IntT, addr);
        }

        pub fn read() PackedT {
            const intVal = ptr().*;
            return @bitCast(PackedT, intVal);
        }

        pub fn write(val: PackedT) void {
            const intVal = @bitCast(IntT, val);
            ptr().* = intVal;
        }

        pub fn readInt() IntT {
            return ptr().*;
        }

        pub fn writeInt(val: IntT) void {
            ptr().* = val;
        }
    };
}
