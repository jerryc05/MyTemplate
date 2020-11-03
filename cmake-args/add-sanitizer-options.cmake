# Copyright (c) 2019-2020 Ziyan "Jerry" Chen (@jerryc05).
#                         All rights reserved.

if (__INCLUDE_SANITIZER_OPTIONS__ AND
        EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/cmake-args/sanitizer-options.cpp)

    get_property(__TARGETS__ DIRECTORY ${dir} PROPERTY BUILDSYSTEM_TARGETS)
    foreach(__TARGET__ ${__TARGETS__})
        target_sources(${__TARGET__} PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/cmake-args/sanitizer-options.cpp)
    endforeach()

else ()
    MESSAGE(SEND_ERROR "\t[SANITIZER OPTIONS] FAILED TO FIND FILE CONTAINING SANITIZER OPTIONS!")
endif ()