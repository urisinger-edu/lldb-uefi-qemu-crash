# lldb-zig-bug

To replicate, you need QEMU, Zig, and (obviously) LLDB installed.

Open QEMU by running:
```bash
zig build run
```

The only thing this does is print the base address to the screen, then wait in an infinite loop.

If you want QEMU to open a GDB server, run:
```bash
zig build run -- -s
```

You can then run LLDB with the following commands:
```bash
target create --no-dependents ./zig-out/EFI/BOOT/bootx64.efi --symfile ./zig-out/EFI/BOOT/bootx64.pdb
target modules load --file bootx64.efi --slide <image-base>
gdb-remote 1234
```
