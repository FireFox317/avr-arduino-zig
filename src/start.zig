const main = @import("main.zig");
const atmega328p = @import("atmega328p.zig");
const uart = @import("uart.zig");
const std = @import("std");
const builtin = std.builtin;

comptime {
    std.debug.assert(std.mem.eql(u8, "RESET", std.meta.fields(atmega328p.VectorTable)[0].name));
    var asm_str: []const u8 = ".section .vectors\njmp _start\n";

    const has_interrupts = @hasDecl(main, "interrupts");
    if (has_interrupts) {
        if (@hasDecl(main.interrupts, "RESET"))
            @compileError("Not allowed to overload the reset vector");

        for (std.meta.declarations(main.interrupts)) |decl| {
            if (!@hasField(atmega328p.VectorTable, decl.name)) {
                var msg: []const u8 = "There is no such interrupt as '" ++ decl.name ++ "'. ISRs the 'interrupts' namespace must be one of:\n";
                for (std.meta.fields(atmega328p.VectorTable)) |field| {
                    if (!std.mem.eql(u8, "RESET", field.name)) {
                        msg = msg ++ "    " ++ field.name ++ "\n";
                    }
                }

                @compileError(msg);
            }
        }
    }

    for (std.meta.fields(atmega328p.VectorTable)[1..]) |field| {
        const new_insn = if (has_interrupts) overload: {
            if (@hasDecl(main.interrupts, field.name)) {
                const handler = @field(main.interrupts, field.name);
                const calling_convention = switch (@typeInfo(@TypeOf(@field(main.interrupts, field.name)))) {
                    .Fn => |info| info.calling_convention,
                    else => @compileError("Declarations in 'interrupts' namespace must all be functions. '" ++ field.name ++ "' is not a function"),
                };

                const exported_fn = switch (calling_convention) {
                    .Unspecified => struct {
                        fn wrapper() callconv(.C) void {
                            //if (calling_convention == .Unspecified) // TODO: workaround for some weird stage1 bug
                            @call(.{ .modifier = .always_inline }, handler, .{});
                        }
                    }.wrapper,
                    else => @compileError("Just leave interrupt handlers with an unspecified calling convention"),
                };

                const options = .{ .name = field.name, .linkage = .Strong };
                @export(exported_fn, options);
                break :overload "jmp " ++ field.name;
            } else {
                break :overload "jmp _unhandled_vector";
            }
        } else "jmp _unhandled_vector";

        asm_str = asm_str ++ new_insn ++ "\n";
    }
    asm (asm_str);
}

export fn _unhandled_vector() void {
    while (true) {}
}

pub export fn _start() noreturn {
    // At startup the stack pointer is at the end of RAM
    // so, no need to set it manually!

    copy_data_to_ram();
    clear_bss();

    main.main();
    while (true) {}
}

fn copy_data_to_ram() void {
    asm volatile (
        \\  ; load Z register with the address of the data in flash
        \\  ldi r30, lo8(__data_load_start)
        \\  ldi r31, hi8(__data_load_start)
        \\  ; load X register with address of the data in ram
        \\  ldi r26, lo8(__data_start)
        \\  ldi r27, hi8(__data_start)
        \\  ; load address of end of the data in ram
        \\  ldi r24, lo8(__data_end)
        \\  ldi r25, hi8(__data_end)
        \\  rjmp .L2
        \\
        \\.L1:
        \\  lpm r18, Z+ ; copy from Z into r18 and increment Z
        \\  st X+, r18  ; store r18 at location X and increment X
        \\
        \\.L2:
        \\  cp r26, r24
        \\  cpc r27, r25 ; check and branch if we are at the end of data
        \\  brne .L1
    );
    // Probably a good idea to add clobbers here, but compiler doesn't seem to care
}

fn clear_bss() void {
    asm volatile (
        \\  ; load X register with the beginning of bss section
        \\  ldi r26, lo8(__bss_start)
        \\  ldi r27, hi8(__bss_start)
        \\  ; load end of the bss in registers
        \\  ldi r24, lo8(__bss_end)
        \\  ldi r25, hi8(__bss_end)
        \\  ldi r18, 0x00
        \\  rjmp .L4
        \\
        \\.L3:
        \\  st X+, r18
        \\
        \\.L4:
        \\  cp r26, r24
        \\  cpc r27, r25 ; check and branch if we are at the end of bss
        \\  brne .L3
    );
    // Probably a good idea to add clobbers here, but compiler doesn't seem to care
}

pub fn panic(msg: []const u8, error_return_trace: ?*builtin.StackTrace, _: ?usize) noreturn {
    // Currently assumes that the uart is initialized in main().
    uart.write("PANIC: ");
    uart.write(msg);

    // TODO: print stack trace (addresses), which can than be turned into actual source line
    //       numbers on the connected machine.
    _ = error_return_trace;
    while (true) {}
}
