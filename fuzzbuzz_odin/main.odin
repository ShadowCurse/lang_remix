package main

import "core:fmt"
import "core:os"
import "core:strconv"

print_usage :: proc() {
	fmt.println("usage: fuzzbuzz <number> \n<number> - amount of numbers to evaluate")
}

fuzzbuzz :: proc(n: uint) {
	for n in 1 ..< (n + 1) {
		if n % 15 == 0 {
			fmt.printf("%d: FuzzBuzz\n", n)
		} else if n % 3 == 0 {
			fmt.printf("%d: Fuzz\n", n)
		} else if n % 5 == 0 {
			fmt.printf("%d: Buzz\n", n)
		} else {
			fmt.printf("%d: %d\n", n, n)
		}
	}
}

main :: proc() {
	args := os.args

	if len(args) < 2 {
		print_usage()
		os.exit(1)
	}

	if n, ok := strconv.parse_uint(args[1], 10); ok {
		fuzzbuzz(n)
	} else {
		print_usage()
		os.exit(1)
	}
}
