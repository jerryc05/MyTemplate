# Copyright (c) 2019-2020 Ziyan "Jerry" Chen (@jerryc05).
#                         All rights reserved.

if (__INCLUDE_SANITIZER_OPTIONS__)

    if (EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/cmake-args/sanitizer-options.cpp)

        set(__SANITIZER_OPT_LIB_NAME__ san_opts)

        add_library(${__SANITIZER_OPT_LIB_NAME__} OBJECT
                ${CMAKE_CURRENT_SOURCE_DIR}/cmake-args/sanitizer-options.cpp)

        # before add_executable()
        link_libraries(${__SANITIZER_OPT_LIB_NAME__})

        # after add_executable()
        get_property(__TARGETS__ DIRECTORY
                PROPERTY BUILDSYSTEM_TARGETS)
        list(REMOVE_ITEM __TARGETS__ ${__SANITIZER_OPT_LIB_NAME__})

        foreach (__TARGET__ ${__TARGETS__})
            target_link_libraries(${__TARGET__} ${__SANITIZER_OPT_LIB_NAME__})
        endforeach ()

        unset(__SANITIZER_OPT_LIB_NAME__)

    else ()
        MESSAGE(SEND_ERROR "\t[SANITIZER OPTIONS] FAILED TO FIND FILE CONTAINING SANITIZER OPTIONS!")
    endif ()

endif ()