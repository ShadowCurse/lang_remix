const std = @import("std");
const stdout = std.io.getStdOut().writer();
const allocator = std.testing.allocator;

fn print_usage() !void {
    try stdout.print("usage: fuzzbuzz <number> \n<number> - amount numbers to process\n", .{});
}

fn get_args_len() usize {
    var args_iter = std.process.args();
    var argc: usize = 0;
    while (args_iter.skip()) {
        argc += 1;
    }
    return argc;
}

const ParseError = error{
    InvalidChar,
    Overflow,
};

fn char_to_digit(char: u8) !u8 {
    return switch (char) {
        '0'...'9' => char - '0',
        'a'...'z' => char - 'a' + 10,
        'A'...'Z' => char - 'A' + 10,
        else => ParseError.InvalidChar,
    };
}

fn str_to_number(comptime T: type, str: []const u8, radix: u8) !T {
    var number: T = 0;
    for (str) |c| {
        const digit = try char_to_digit(c);

        if (digit > radix) {
            return ParseError.InvalidChar;
        }

        if (@mulWithOverflow(T, number, radix, &number)) {
            return ParseError.Overflow;
        }

        if (@addWithOverflow(T, number, digit, &number)) {
            return ParseError.Overflow;
        }
    }

    return number;
}

fn fuzzbuzz(n: u32) !void {
    var curr: u32 = 1;
    while (curr <= n) : (curr += 1) {
        if (curr % 15 == 0) {
            try stdout.print("{}: FuzzBuzz\n", .{curr});
        } else if (curr % 3 == 0) {
            try stdout.print("{}: Fuzz\n", .{curr});
        } else if (curr % 5 == 0) {
            try stdout.print("{}: Buzz\n", .{curr});
        } else {
            try stdout.print("{}: {}\n", .{ curr, curr });
        }
    }
}

pub fn main() !void {
    const argc = get_args_len();
    if (argc != 2) {
        try print_usage();
        std.process.exit(1);
    }

    var args_iter = std.process.args();
    const arg_num = 1;
    var curr_arg: u8 = 0;
    while (curr_arg < arg_num and args_iter.skip()) : (curr_arg += 1) {}
    const arg = try args_iter.next(allocator).?;
    defer allocator.free(arg);

    const n = str_to_number(u32, arg, 10) catch {
        try print_usage();
        std.process.exit(1);
    };
    try fuzzbuzz(n);
}

test "parse u32" {
    const res = try str_to_number(u32, "1234", 10);
    try std.testing.expect(res == 1234);
}

test "parse u32 negative" {
    const res = str_to_number(u32, "-1234", 10);
    try std.testing.expectError(ParseError.InvalidChar, res);
}

test "parse u32 invalid" {
    const res = str_to_number(u32, "qwer", 10);
    try std.testing.expectError(ParseError.InvalidChar, res);
}
