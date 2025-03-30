const std = @import("std");

pub fn main() !void {
    // Removed allocator since it's not used
    const address = try std.net.Address.parseIp("127.0.0.1", 8080);
    var listener = try address.listen(.{
        .reuse_address = true,
    });
    defer listener.deinit();

    std.debug.print("Server listening on http://127.0.0.1:8080\n", .{});

    while (true) {
        const connection = try listener.accept();
        defer connection.stream.close();

        try handleConnection(connection.stream);
    }
}

fn handleConnection(stream: std.net.Stream) !void {
    var buffer: [1024]u8 = undefined;

    const request_size = try stream.read(&buffer);
    if (request_size == 0) return;

    const response =
        "HTTP/1.1 200 OK\r\n" ++
            "Content-Type: text/plain\r\n" ++
            "Content-Length: 13\r\n" ++
            "\r\n" ++
            "Hello, World!";

    try stream.writeAll(response);
}