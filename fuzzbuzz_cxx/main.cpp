#include <iostream>
#include <string>

void print_usage() {
    std::puts("usage: fuzzbuzz <number> \n<number> - amount of numbers to evaluate\n");
}

void fuzzbuzz(int n) {
    for (int i{1}; i <= n; ++i) {
        if (i % 15 == 0) {
            std::cout << i << ": FuzzBuzz\n";
        } else if (i % 3 == 0) {
            std::cout << i << ": Fuzz\n";
        } else if (i % 5 == 0) {
            std::cout << i << ": Buzz\n";
        } else {
            std::cout << i << ": " << i << "\n";
        }
    }
}

auto main(int argc, char** argv) -> int {
    if (argc != 2) {
        print_usage();
        return 1;
    }
    int n;
    try {
        n = std::stoi(argv[1]);
    } catch (...) {
        print_usage();
        return 1;
    }
    fuzzbuzz(n);
}
