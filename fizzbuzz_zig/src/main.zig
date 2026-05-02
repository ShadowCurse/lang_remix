const std = @import("std");

fn print_usage() void {
    std.debug.print("usage: fizzbuzz <number> \n<number> - amount numbers to process\n", .{});
}

fn fizzbuzz(n: u32) void {
    var curr: u32 = 1;
    while (curr <= n) : (curr += 1) {
        if (curr % 15 == 0) {
            std.debug.print("{}: FizzBuzz\n", .{curr});
        } else if (curr % 3 == 0) {
            std.debug.print("{}: Fizz\n", .{curr});
        } else if (curr % 5 == 0) {
            std.debug.print("{}: Buzz\n", .{curr});
        } else {
            std.debug.print("{}: {}\n", .{ curr, curr });
        }
    }
}

pub fn main(init: std.process.Init.Minimal) void {
    if (init.args.vector.len != 2) {
        print_usage();
        std.process.exit(1);
    }

    const n = std.fmt.parseInt(u32, std.mem.span(init.args.vector[1]), 10) catch {
        print_usage();
        std.process.exit(1);
    };

    fizzbuzz(n);
}
