const std = @import("std");

const uefi = std.os.uefi;

fn uefi_write(context: void, bytes: []const u8) error{}!usize {
    _ = context;

    for (bytes) |byte| {
        // Convert UTF-8 to UTF-16 and output each character
        var char = [_:0]u16{ @as(u16, byte), 0 };
        _ = uefi.system_table.con_out.?.outputString(&char);
    }

    return bytes.len;
}

const UefiWriter = std.io.Writer(void, error{}, uefi_write);

const stdout: UefiWriter = .{ .context = undefined };

pub fn main() void {
    var loaded_image: *uefi.protocols.LoadedImageProtocol = undefined;
    const guid: uefi.Guid = uefi.protocols.LoadedImageProtocol.guid;
    _ = uefi.system_table.boot_services.?.handleProtocol(uefi.handle, @alignCast(&guid), @ptrCast(&loaded_image));

    _ = uefi.system_table.con_out.?.clearScreen();
    stdout.print("Image base: 0x{x}\n", .{@intFromPtr(loaded_image.*.image_base)}) catch unreachable;

    var wait = true;
    while (wait) {
        asm volatile ("pause");
    }
}
