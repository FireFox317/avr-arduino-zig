const main = @import("main.zig");
const vectors = @import("vectors.zig");

pub export fn _start() callconv(.Naked) noreturn {
    // At startup the stack pointer is at the end of RAM
    // so, no need to set it manually!

    // Reference this such that the file is analyzed and the vectors
    // are added.
    _ = vectors;

    main.main();
    while (true) {}
}

pub fn panic(msg: []const u8, error_return_trace: ?*@import("builtin").StackTrace) noreturn {
    while (true) {}
}
