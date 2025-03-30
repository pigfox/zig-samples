const std = @import("std");

pub fn main() !void {
const thread_count = 5; // Number of concurrent requests

    // Array to hold our threads
    var threads: [thread_count]std.Thread = undefined;

// Spawn threads
    for (0..thread_count) |i| {
threads[i] = try std.Thread.spawn(.{}, makeRequest, .{i});
}

// Wait for all threads to complete
    for (threads) |thread| {
thread.join();
}
}

fn makeRequest(thread_num: usize) !void {
// Connect to the server
    const address = try std.net.Address.parseIp("127.0.0.1", 8080);
var client = try std.net.tcpConnectToAddress(address);
defer client.close();

// Simple HTTP GET request
    const request =
"GET / HTTP/1.1\r\n" ++
"Host: 127.0.0.1:8080\r\n" ++
"\r\n";

// Send request
    try client.writeAll(request);

// Read response
    var buffer: [1024]u8 = undefined;
const response_size = try client.read(&buffer);

// Null-terminate the response for printing
    const response = buffer[0..response_size];

// Print response with thread number
    std.debug.print("Thread #{} received: {s}\n", .{thread_num, response});
}