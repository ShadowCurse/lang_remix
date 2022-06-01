use std::env;
use std::process;

fn print_usage() {
    println!("usage: fuzzbuzz <number> \n<number> - amount of numbers to evaluate");
}

fn fuzzbuzz(n: u32) {
    for n in 1..(n + 1) {
        if n % 15 == 0 {
            println!("{n}: FuzzBuzz");
        } else if n % 3 == 0 {
            println!("{n}: Fuzz");
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
        fuzzbuzz(n);
    } else {
        print_usage();
        process::exit(1);
    }
}
