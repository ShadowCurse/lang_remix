use os;
use fmt;
use strconv;

fn print_usage() void = {
    fmt::printf(
        "usage: fizzbuzz <number> \n<number> - amount of numbers to evaluate\n",
    )!;
};

fn fizzbuzz(n: u32) void = {
    for (let i: u32 = 1; i < n + 1; i += 1) {
        if (i % 15 == 0) {
            fmt::printf("{}: FizzBuzz\n", i)!;
        } else if (i % 3 == 0) {
            fmt::printf("{}: Fizz\n", i)!;
        } else if (i % 5 == 0) {
            fmt::printf("{}: Buzz\n", i)!;
        } else {
            fmt::printf("{}: {}\n", i, i)!;
        };
    };
};

export fn main() void = {
    const args = os::args;

    if (len(args) < 2) {
        print_usage();
        os::exit(1);
    };

    match (strconv::stou32(args[1], 10)) {
        case let n: u32 =>
	        fizzbuzz(n);
	case =>
        	print_usage();
        	os::exit(1);
    };
};
