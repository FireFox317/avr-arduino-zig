comptime {
    asm (
        \\.section .vectors
        \\ jmp _start
        \\ jmp _unhandled_vector
        \\ jmp _unhandled_vector
        \\ jmp _unhandled_vector
        \\ jmp _unhandled_vector
        \\ jmp _unhandled_vector
        \\ jmp _unhandled_vector
        \\ jmp _unhandled_vector
        \\ jmp _unhandled_vector
        \\ jmp _unhandled_vector
        \\ jmp _unhandled_vector
        \\ jmp _unhandled_vector
        \\ jmp _unhandled_vector
        \\ jmp _unhandled_vector
        \\ jmp _unhandled_vector
        \\ jmp _unhandled_vector
        \\ jmp _unhandled_vector
        \\ jmp _unhandled_vector
        \\ jmp _unhandled_vector
        \\ jmp _unhandled_vector
        \\ jmp _unhandled_vector
        \\ jmp _unhandled_vector
        \\ jmp _unhandled_vector
        \\ jmp _unhandled_vector
        \\ jmp _unhandled_vector
        \\ jmp _unhandled_vector
    );
}

export fn _unhandled_vector() callconv(.Naked) noreturn {
    while (true) {}
}
