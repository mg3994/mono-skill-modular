cmake_minimum_required(VERSION 3.10.2)
project(dartnative_device_info LANGUAGES CXX)

add_library(dartnative_device_info SHARED
    src/main/cpp/device_info_bridge.cpp
)

target_link_libraries(dartnative_device_info
    log
)
