const std = @import("std");

pub fn main() !void {
    const stdin = std.io.getStdIn().reader();
    const stdout = std.io.getStdOut().writer();
    var buffer: [100]u8 = undefined;

    while (true) {
        // Print menu
        try stdout.print(
            \\Terminal Menu:
            \\1. Say Hello
            \\2. Add Numbers
            \\3. Exit
            \\Enter choice (1-3):
        , .{});

        // Read user input
        const input = try stdin.readUntilDelimiterOrEof(&buffer, '\n');
        if (input == null) break;

        // Parse choice
        const choice = std.mem.trim(u8, input.?, " ");
        if (choice.len == 0) continue;

        switch (choice[0]) {
            '1' => try sayHello(stdout),
            '2' => try addNumbers(stdin, stdout),
            '3' => {
                try stdout.print("Goodbye!\n", .{});
                break;
            },
            else => try stdout.print("Invalid choice, try again.\n\n", .{}),
        }
    }
}

fn sayHello(stdout: anytype) !void {
    try stdout.print("Hello, World!\n\n", .{});
}

fn addNumbers(stdin: anytype, stdout: anytype) !void {
    var buffer: [100]u8 = undefined;

    try stdout.print("Enter first number: ", .{});
    const num1_str = try stdin.readUntilDelimiterOrEof(&buffer, '\n');
    const num1 = try std.fmt.parseFloat(f32, std.mem.trim(u8, num1_str.?, " "));

    try stdout.print("Enter second number: ", .{});
    const num2_str = try stdin.readUntilDelimiterOrEof(&buffer, '\n');
    const num2 = try std.fmt.parseFloat(f32, std.mem.trim(u8, num2_str.?, " "));

    const result = num1 + num2;
    try stdout.print("Result: {d}\n\n", .{result});
}