cmake_minimum_required(VERSION 3.15)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Wpedantic -std=c++20")

project(breakout CXX)

add_executable(breakout src/main.cpp)
target_link_libraries(breakout raylib)

add_executable(test test/main.cpp)
target_include_directories(test PRIVATE ${CMAKE_SOURCE_DIR}/src)
target_link_libraries(test PRIVATE gtest)
