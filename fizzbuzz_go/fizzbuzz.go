package main

import (
	"fmt"
	"os"
	"strconv"
)

func print_usage_and_exit() {
	fmt.Println("usage: fizzbuzz <number> \n<number> - amount of numbers to evaluate")
	os.Exit(1)
}

func fizzbuzz(n uint64) {
	for i := uint64(1); i <= n; i++ {
		if i%15 == 0 {
			fmt.Printf("%d: FizzBuzz\n", i)
		} else if i%3 == 0 {
			fmt.Printf("%d: Fizz\n", i)
		} else if i%5 == 0 {
			fmt.Printf("%d: Buzz\n", i)
		} else {
			fmt.Printf("%d: %d\n", i, i)
		}
	}
}

func main() {
	if len(os.Args) != 2 {
		print_usage_and_exit()
	}
	if n, e := strconv.ParseUint(os.Args[1], 10, 32); e != nil {
		print_usage_and_exit()
	} else {
		fizzbuzz(n)
	}
}
