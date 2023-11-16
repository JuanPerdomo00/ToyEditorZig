const std = @import("std");

pub fn main() void {
    // pendiente comprender a profundidad
    const allocator = std.heap.page_allocator;
    var args = try std.process.argsAlloc(allocator);
    defer allocator.free(args);
// ============================================================
//
//
    const argCount = try @intCast(u32, args.len);// genera un error, sacado de overflow
    if (argCount != 2) {
        std.debug.print("Uso: {} [nombre_archivo]\n", .{args[0].toString()});
        return;
    }

    // guardamo el archivo 
    const filename = args[1];

    // creamos la entrada en el heap 
    var file = try std.fs.cwd().create(filename);
    defer file.close();


    if (file.kind != .file) {
        std.debug.print("No se pudo crear el archivo\n", .{});
        return;
    }

    const stdin = std.io.getStdIn().inStream(allocator);
    const stdout = std.io.getStdOut().outStream();

    var buffer: [4096]u8 = undefined;
    var bytesRead: usize = 0;

    try file.read(buffer[0..]);
    while (true) {
        const c = try stdin.readByte();

        switch (c) {
            // 's' para guardar el archivo
            's' => {
                try file.seek(std.fs.SeekSet.Absolute, 0);
                try file.write(buffer[0..bytesRead]);

                try stdout.write("\nArchivo guardado.\n");
            },

            // 'c' para cancelar
            'c' => {
                try stdout.write("\nAcción cancelada.\n");
            },

            else => {
                try stdout.write("\nSaliendo del editor.\n");
                return;
            }
        }
    }
}

