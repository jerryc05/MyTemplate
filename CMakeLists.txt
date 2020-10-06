cmake_minimum_required(VERSION 2.4)
project(MyTemplate)
message("")

add_executable(MyTemplate main.cpp
        utils/logger.hpp utils/logger.hpp
        utils/env-settings.hpp)


set(__USE_ANALYZER__            false)
set(__NO_USE_ADDR_SANITIZER__   false)
set(__USE_THD_SANITIZER__       false)
set(__NO_USE_UB_SANITIZER__     false)

include(${CMAKE_CURRENT_SOURCE_DIR}/CMakeArgs/CMakeLists.txt)