module main

import os
import strconv

fn print_usage() {
    println("usage: fizzbuzz <number> \n<number> - amount of numbers to evaluate")
}

fn fizzbuzz(f u64) {
    for n in 1 .. (f + 1) {
        if n % 15 == 0 {
            println("$n: FizzBuzz")
        } else if n % 3 == 0 {
            println("$n: Fizz")
        } else if n % 5 == 0 {
            println("$n: Buzz")
        } else {
            println("$n: $n")
        }
    }
}

fn main() {
  if os.args.len < 2 {
    print_usage()
    exit(1)
  }

  n := strconv.parse_uint(os.args[1], 10, 32) or {
    print_usage()
    exit(1)
  }

  fizzbuzz(n)
}
