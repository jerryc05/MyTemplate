cmake_minimum_required(VERSION 2.4)
project(MyTemplate)
message("")

add_executable(MyTemplate main.cpp
        utils/logger.hpp utils/logger.hpp
        utils/env-settings.hpp)


#set(__USE_ANALYZER__            ON)
set(__USE_LATEST_CPP_STD__      ON)
set(__USE_ADDR_SANITIZER__      ON)
set(__USE_POINTER_SANITIZER__   ON)
set(__USE_LEAK_SANITIZER__      ON)
set(__USE_UB_SANITIZER__        ON)
set(__COVERAGE_SANITIZERS__     ON)
#set(__USE_THD_SANITIZER__       ON)

include(${CMAKE_CURRENT_SOURCE_DIR}/CMakeArgs/MoreArgs.cmake)

#set(CMAKE_EXECUTABLE_SUFFIX ".exe")