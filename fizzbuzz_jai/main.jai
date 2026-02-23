print_usage :: () {
    print("usage: fizzbuzz <number> \n<number> - amount of numbers to evaluate\n");
}

fizzbuzz :: (n: u32) {
    for i: 1..n {
        if i % 15 == 0 {
            print("%: FizzBuzz\n", i);
        } else if i % 3 == 0 {
            print("%: Fizz\n", i);
        } else if i % 5 == 0 {
            print("%: Buzz\n", i);
        } else {
            print("%: %\n", i, i);
        }
    }
}

main :: () {
    args := get_command_line_arguments();

    if args.count < 2 {
        print_usage();
        exit(1);
    }

    n, success := parse_int(*args[1], u32);
    if success {
        fizzbuzz(n);
    } else {
        print_usage();
        exit(1);
    }
}

#import "Basic";
#import "String";
#import "Command_Line";
