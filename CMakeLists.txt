cmake_minimum_required(VERSION 2.4)
project(MyTemplate)
message("")

add_executable(MyTemplate main.cpp
        utils/logger.hpp utils/logger.hpp
        utils/env-settings.hpp)


if (CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    message("Adding GCC Flags...")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} \
-fdelete-dead-exceptions \
-fstrict-enums \
-ftrapv \
-funroll-loops \
-std=gnu++2a \
-Wall \
-Wcast-align \
-Wconversion \
-Wctor-dtor-privacy \
-Wdelete-non-virtual-dtor \
-Wdeprecated-copy \
-Wdisabled-optimization \
-Wdouble-promotion \
-Wduplicated-branches \
-Wduplicated-cond \
-Wextra \
-Wfloat-equal \
-Winit-self \
-Winline \
-Wlogical-op \
-Wnon-virtual-dtor \
-Wnull-dereference \
-Wold-style-cast \
-Woverloaded-virtual \
-Wpadded \
-Wpedantic \
-Wpointer-arith \
-Wredundant-decls \
-Wshadow \
-Wsign-conversion \
-Wundef \
-Wuseless-cast \
-Wwrite-strings \
")
endif ()
message("")

if (CMAKE_BUILD_TYPE MATCHES "Debug")
    message("CMAKE IN DEBUG MODE")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -O0")
    add_compile_definitions(__DEBUG__)

elseif (CMAKE_BUILD_TYPE MATCHES "Release")
    message("CMAKE IN RELEASE MODE")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Ofast -march=native")
    add_compile_definitions(__RELEASE__)

    if (NOT ${CMAKE_SYSTEM_NAME} STREQUAL "Darwin")
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -s")
    endif ()
endif ()
message("")

message("CXX_FLAGS: [${CMAKE_CXX_FLAGS}]")
message("")
