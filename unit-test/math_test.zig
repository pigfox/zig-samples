const std = @import("std");
const math = @import("math.zig");

const allocator = std.heap.page_allocator;

// Custom logging for function calls
fn logFunctionCall(func_name: []const u8) void {
    std.debug.print("Function called: {s}\n", .{func_name});
}

test "basic arithmetic - addition" {
    const start_time = std.time.nanoTimestamp();
    std.debug.print("Starting addition test...\n", .{});

    logFunctionCall("math.add(2, 3)");
    try std.testing.expectEqual(@as(i32, 5), math.add(2, 3));

    logFunctionCall("math.add(-1, 1)");
    try std.testing.expectEqual(@as(i32, 0), math.add(-1, 1));

    logFunctionCall("math.add(-2, -3)");
    try std.testing.expectEqual(@as(i32, -5), math.add(-2, -3)); // Corrected expected value

    const duration = std.time.nanoTimestamp() - start_time;
    std.debug.print("Addition test completed in {d}ns\n", .{duration});
}

test "basic arithmetic - multiplication" {
    const start_time = std.time.nanoTimestamp();
    std.debug.print("Starting multiplication test...\n", .{});

    logFunctionCall("math.multiply(2, 3)");
    try std.testing.expectEqual(@as(i32, 6), math.multiply(2, 3));

    logFunctionCall("math.multiply(2, -2)");
    try std.testing.expectEqual(@as(i32, -4), math.multiply(2, -2));

    logFunctionCall("math.multiply(5, 0)");
    try std.testing.expectEqual(@as(i32, 0), math.multiply(5, 0));

    const duration = std.time.nanoTimestamp() - start_time;
    std.debug.print("Multiplication test completed in {d}ns\n", .{duration});
}

test "edge cases - addition" {
    const start_time = std.time.nanoTimestamp();
    std.debug.print("Starting edge case addition test...\n", .{});

    logFunctionCall("math.add(std.math.maxInt(i32) - 1, 1)");
    try std.testing.expectEqual(@as(i32, std.math.maxInt(i32)), math.add(std.math.maxInt(i32) - 1, 1));

    logFunctionCall("math.add(std.math.minInt(i32) + 1, -1)");
    try std.testing.expectEqual(@as(i32, std.math.minInt(i32)), math.add(std.math.minInt(i32) + 1, -1));

    const duration = std.time.nanoTimestamp() - start_time;
    std.debug.print("Edge case addition test completed in {d}ns\n", .{duration});
}
