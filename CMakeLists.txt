cmake_minimum_required(VERSION 2.4)
project(MyTemplate)
message("")

add_executable(MyTemplate main.cpp
        utils/logger.hpp utils/logger.hpp
        utils/env-settings.hpp)


include(${CMAKE_CURRENT_SOURCE_DIR}/CMakeArgs/CMakeLists.txt)