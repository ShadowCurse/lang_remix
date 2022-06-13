use std::env;
use std::process;

fn print_usage() {
    println!("usage: fizzbuzz <number> \n<number> - amount of numbers to evaluate");
}

fn fizzbuzz(n: u32) {
    for n in 1..(n + 1) {
        if n % 15 == 0 {
            println!("{n}: FizzBuzz");
        } else if n % 3 == 0 {
            println!("{n}: Fizz");
        } else if n % 5 == 0 {
            println!("{n}: Buzz");
        } else {
            println!("{n}: {n}");
        }
    }
}

fn main() {
    let mut args = env::args();

    if args.len() != 2 {
        print_usage();
        process::exit(1);
    }

    if let Ok(n) = args.nth(1).unwrap().parse::<u32>() {
        fizzbuzz(n);
    } else {
        print_usage();
        process::exit(1);
    }
}
