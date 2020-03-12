cmake_minimum_required(VERSION 2.4)
project(MyTemplate)
message("")

if (CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    message("Adding GCC Flags...")
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} \
    -std=gnu++2a \
    -ftrapv \
    -Waggregate-return \
    -Wall \
    -Wcast-align \
    -Wconversion \
    -Wextra \
    -Wfloat-equal \
    -Winit-self \
    -Wno-unused-parameter \
    -Wpointer-arith \
    -Wshadow \
    -Wswitch-default \
    -Wswitch-enum \
    -Wundef \
    -Wwrite-strings \
    ")
endif ()
message("")

if (CMAKE_BUILD_TYPE MATCHES Debug)
    message("CMAKE IN DEBUG MODE")
    set(CMAKE_CXX_FLAGS "${CMAKE_C_FLAGS} -Og")
elseif (CMAKE_BUILD_TYPE MATCHES Release)
    message("CMAKE IN RELEASE MODE")
    set(CMAKE_CXX_FLAGS "${CMAKE_C_FLAGS} -Ofast")
endif ()
message("")

add_executable(MyTemplate main.cpp)
