const std = @import("std");

pub fn main() !void {
    const address = try std.net.Address.parseIp("127.0.0.1", 8080);
    var listener = try address.listen(.{
        .reuse_address = true,
    });
    defer listener.deinit();

    std.debug.print("Server listening on http://127.0.0.1:8080\n", .{});

    // Thread counter for demonstration
    var thread_count: usize = 0;

    while (true) {
        const connection = try listener.accept();
        // Spawn a new thread for each connection
        const thread = try std.Thread.spawn(.{}, handleConnection, .{connection.stream});
        thread_count += 1;
        std.debug.print("Spawned thread #{}, total active: {}\n", .{thread_count, std.Thread.getCurrentId()});

        // Detach the thread so it runs independently
        thread.detach();
    }
}

fn handleConnection(stream: std.net.Stream) !void {
    // Ensure stream is closed when we're done
    defer stream.close();

    var buffer: [1024]u8 = undefined;

    // Read request
    const request_size = try stream.read(&buffer);
    if (request_size == 0) return;

    // Include thread ID in response
    const thread_id = std.Thread.getCurrentId();
    const response = try std.fmt.allocPrint(
        std.heap.page_allocator,
        "HTTP/1.1 200 OK\r\n" ++
            "Content-Type: text/plain\r\n" ++
            "Content-Length: 24\r\n" ++
            "\r\n" ++
            "Hello from thread #{}!", .{thread_id}
    );
    defer std.heap.page_allocator.free(response);

    // Write response
    try stream.writeAll(response);
}