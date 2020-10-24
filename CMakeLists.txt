cmake_minimum_required(VERSION 2.4)
project(MyTemplate)
message("")

add_executable(MyTemplate main.cpp
        utils/logger.hpp utils/logger.hpp
        utils/env-settings.hpp)


# ===== BEGIN OF CMAKE TEMPLATE =====

#set(__USE_ANALYZER__                    ON)
set(__USE_LATEST_CPP_STD__              ON)
set(__REL_USE_HACKED_MATH__             ON)


# At most one of the following three
#set(__DBG_SANITIZE_ADDR__               ON)
#set(__DBG_SANITIZE_MEMORY__             ON) # Linux only
#set(__DBG_SANITIZE_THRD__               ON) # [IN PROGRESS]

set(__DBG_SANITIZE_LEAK_STANDALONE__    ON)
set(__DBG_SANITIZE_UB__                 ON)



include(${CMAKE_CURRENT_SOURCE_DIR}/cmake-args/!main.cmake)


# Compatibility with Windows systems
#set(CMAKE_EXECUTABLE_SUFFIX ".exe")