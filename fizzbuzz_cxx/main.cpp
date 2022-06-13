#include <cstdlib>
#include <iostream>
#include <string>

void print_usage_and_exit() {
  std::puts(
      "usage: fizzbuzz <number> \n<number> - amount of numbers to evaluate\n");
  exit(1);
}

void fizzbuzz(int n) {
  for (int i{1}; i <= n; ++i) {
    if (i % 15 == 0) {
      std::cout << i << ": FizzBuzz\n";
    } else if (i % 3 == 0) {
      std::cout << i << ": Fizz\n";
    } else if (i % 5 == 0) {
      std::cout << i << ": Buzz\n";
    } else {
      std::cout << i << ": " << i << "\n";
    }
  }
}

auto main(int argc, char** argv) -> int {
  if (argc != 2) {
    print_usage_and_exit();
  }
  int n;
  try {
    n = std::stoi(argv[1]);
    if (n < 0) {
      print_usage_and_exit();
    }
  } catch (...) {
    print_usage_and_exit();
  }
  fizzbuzz(n);
}
