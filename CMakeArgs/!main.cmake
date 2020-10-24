# Highly customized CMake scripts that enables most warnings and optimizations available.
# Copyright (C) github.com/jerryc05 All rights reserved.

# Using ccache if possible
message(CHECK_START "Finding [CCACHE] ...")
find_program(__CCACHE__ ccache)

if (__CCACHE__)
    set_property(GLOBAL PROPERTY RULE_LAUNCH_COMPILE "${__CCACHE__}")
    set_property(GLOBAL PROPERTY RULE_LAUNCH_CUSTOM "${__CCACHE__}")
    set_property(GLOBAL PROPERTY RULE_LAUNCH_LINK "${__CCACHE__}")

    # print info
    execute_process(COMMAND ${__CCACHE__} --version
            OUTPUT_VARIABLE __CCACHE_INFO__)
    string(REGEX MATCH "[^\r\n]+"
            __CCACHE_INFO__ ${__CCACHE_INFO__})
    message(CHECK_PASS "OK! ${__CCACHE_INFO__}")

else ()
    message(CHECK_FAIL "NOT FOUND!")
endif ()
message(STATUS "")

#[[
















]]

if (CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    message(STATUS "USING [GNU GCC]")
    message(STATUS "")

    message(CHECK_START "\t[STATIC ANALYZER]")
    if (__USE_ANALYZER__)
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} \
--param=analyzer-bb-explosion-factor=20 \
--param=analyzer-max-recursion-depth=10 \
-fanalyzer \
-Wanalyzer-too-complex \
")
        message(CHECK_PASS "ON")
    else ()
        message(CHECK_FAIL "OFF")
    endif ()
    message(STATUS "")

    #[[


    ]]

    message(CHECK_START "\t[USE LATEST C++ STD]")
    if (__USE_LATEST_CPP_STD__)
        execute_process(COMMAND ${CMAKE_CXX_COMPILER} -v --help
                OUTPUT_VARIABLE __LATEST_CPP_STD__
                ERROR_QUIET)
        string(REGEX MATCHALL "-std=gnu\\+\\+[^9 ]+"
                __LATEST_CPP_STD__ ${__LATEST_CPP_STD__})
        list(GET __LATEST_CPP_STD__ -1 __LATEST_CPP_STD__)
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${__LATEST_CPP_STD__}")
        message(CHECK_PASS "ON: [${__LATEST_CPP_STD__}]")
    else ()
        message(CHECK_FAIL "OFF")
    endif ()

    #[[


    ]]

    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} \
-Wall \
-Wextra \
\
-Walloc-zero -Walloca \
-Wcast-align \
-Wcast-qual \
-Wconversion \
-Wdisabled-optimization \
-Wdouble-promotion \
-Wduplicated-branches \
-Wduplicated-cond \
-Weffc++ \
-Werror=return-type \
-Wextra-semi \
-Wfloat-equal \
-Wformat=2 \
-Wformat-nonliteral \
-Wformat-security \
-Wformat-signedness \
-Wformat-y2k \
-Winit-list-lifetime \
-Winline \
-Winvalid-offsetof \
-Winvalid-pch \
-Wliteral-suffix \
-Wmismatched-tags \
-Wmissing-format-attribute \
-Wmissing-include-dirs \
-Wmultichar \
-Wnoexcept \
-Wnoexcept-type \
-Wnon-virtual-dtor \
-Wnull-dereference \
-Wold-style-cast \
-Woverloaded-virtual \
-Wpacked \
-Wpadded \
-Wpedantic \
-Wpointer-arith \
-Wredundant-decls \
-Wredundant-tags \
-Wregister \
-Wreorder \
-Wscalar-storage-order \
-Wshadow \
-Wshift-overflow=2 \
-Wsign-conversion \
-Wsign-promo \
-Wstrict-null-sentinel \
-Wsuggest-attribute=cold \
-Wsuggest-attribute=const \
-Wsuggest-attribute=format \
-Wsuggest-attribute=malloc \
-Wsuggest-attribute=noreturn \
-Wsuggest-attribute=pure \
-Wsuggest-final-methods \
-Wsuggest-final-types \
-Wsuggest-override \
-Wswitch-default \
-Wswitch-enum \
-Wundef \
-Wunused-macros \
-Wuseless-cast \
-Wzero-as-null-pointer-constant \
")
    # "-Wmissing-declarations" disabled due to convenience
    message(STATUS "")

    #[[
















    ]]

    if (CMAKE_BUILD_TYPE MATCHES "Debug")
        message(STATUS "CMAKE IN DEBUG MODE")
        message(STATUS "")

        add_compile_definitions(__DEBUG__)
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -O0 -g3 \
-fcf-protection=full \
-fexceptions \
-fstack-protector-all \
-ftrapv \
-Wunknown-pragmas \
-Wvector-operation-performance \
")

        include(${CMAKE_CURRENT_SOURCE_DIR}/CMakeArgs/asan.cmake)
        include(${CMAKE_CURRENT_SOURCE_DIR}/CMakeArgs/lsan-standalone.cmake)
        include(${CMAKE_CURRENT_SOURCE_DIR}/CMakeArgs/msan.cmake)
        include(${CMAKE_CURRENT_SOURCE_DIR}/CMakeArgs/ubsan.cmake)
        include(${CMAKE_CURRENT_SOURCE_DIR}/CMakeArgs/tsan.cmake)

        # todo cfi sanitizer, safe-stack

        #[[
















        ]]


    elseif (CMAKE_BUILD_TYPE MATCHES "Release")
        message(STATUS "CMAKE IN RELEASE MODE")
        message(STATUS "")

        include(ProcessorCount)
        ProcessorCount(__N_CORES__)

        #        todo floating point flags
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Ofast -march=native \
-fassociative-math \
-fdelete-dead-exceptions \
-ffast-math \
-ffinite-loops \
-ffinite-math-only \
-fgcse-las -fgcse-sm \
-fipa-pta -fira-loop-pressure \
-fisolate-erroneous-paths-attribute \
-floop-nest-optimize \
-floop-parallelize-all \
-flto \
-fmodulo-sched -fmodulo-sched-allow-regmoves \
-fno-math-errno \
-fno-exceptions \
-fno-signed-zeros -fno-trapping-math \
-freciprocal-math \
-fsched-pressure \
-fsched-spec-load -fsched-spec-load-dangerous \
-fsched-stalled-insns=0 -fsched-stalled-insns-dep \
-fsched2-use-superblocks \
-fschedule-insns \
-fsel-sched-pipelining -fsel-sched-pipelining-outer-loops \
-fselective-scheduling -fselective-scheduling2 \
-fsplit-wide-types-early \
-fstrict-enums \
-ftree-lrs -ftree-parallelize-loops=${__N_CORES__} -ftree-vectorize \
-funroll-loops \
-fvariable-expansion-in-unroller \
-funsafe-math-optimizations \
-s \
")
        # "-fsanitize-undefined-trap-on-error" enable this only when libubsan is available
        # "-fsanitize-coverage=trace-pc" needs kernel support
    endif ()
    message(STATUS "")

    #[[
















    ]]

    message(STATUS "CXX_FLAGS: [${CMAKE_CXX_FLAGS}]")
    message(STATUS "")

    #[[
















    ]]

elseif (CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
    message(STATUS "USING [LLVM Clang]")
    message(STATUS "")

    #[[message(CHECK_START "\t[STATIC ANALYZER]")
    if (__USE_ANALYZER__)
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} \
--param=analyzer-bb-explosion-factor=20 \
--param=analyzer-max-recursion-depth=10 \
-fanalyzer \
-Wanalyzer-too-complex \
")
        message(CHECK_PASS "ON")
    else ()
        message(CHECK_FAIL "OFF")
    endif ()
    message(STATUS "")]]

    #[[


    ]]

    #[[message(CHECK_START "\t[USE LATEST C++ STD]")
    if (__USE_LATEST_CPP_STD__)
        execute_process(COMMAND ${CMAKE_CXX_COMPILER} -v --help
                OUTPUT_VARIABLE __LATEST_CPP_STD__
                ERROR_QUIET)
        string(REGEX MATCHALL "-std=gnu\\+\\+[^9 ]+"
                __LATEST_CPP_STD__ ${__LATEST_CPP_STD__})
        list(GET __LATEST_CPP_STD__ -1 __LATEST_CPP_STD__)
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${__LATEST_CPP_STD__}")
        message(CHECK_PASS "ON: [${__LATEST_CPP_STD__}]")
    else ()
        message(CHECK_FAIL "OFF")
    endif ()]]


    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} \
-Wall \
-Wextra \
\
\
")
    message(STATUS "")

    #[[
















    ]]

    if (CMAKE_BUILD_TYPE MATCHES "Debug")
        message(STATUS "CMAKE IN DEBUG MODE")
        message(STATUS "")

        add_compile_definitions(__DEBUG__)

        include(${CMAKE_CURRENT_SOURCE_DIR}/CMakeArgs/Asan.cmake)
        include(${CMAKE_CURRENT_SOURCE_DIR}/CMakeArgs/LsanStandalone.cmake)
        include(${CMAKE_CURRENT_SOURCE_DIR}/CMakeArgs/Msan.cmake)
        include(${CMAKE_CURRENT_SOURCE_DIR}/CMakeArgs/Ubsan.cmake)
        include(${CMAKE_CURRENT_SOURCE_DIR}/CMakeArgs/Tsan.cmake)

        #[[


        ]]

        message(CHECK_START "\t[C.F.I. SANITIZER]") # todo
        if (__DBG_SANITIZE_CFI__)
            set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} \
-fsanitize-cfi-cross-dso \
")
            # "-fsanitize-cfi-icall-generalize-pointers" is not compatible
            # with "-fsanitize-cfi-cross-dso"
            message(CHECK_PASS "ON")
        else ()
            message(CHECK_FAIL "OFF")
        endif ()
        message(STATUS "")

        # todo -fsanitize=safe-stack

        #[[
















        ]]


    elseif (CMAKE_BUILD_TYPE MATCHES "Release")
        message(STATUS "CMAKE IN RELEASE MODE")
        message(STATUS "")

        include(ProcessorCount)
        ProcessorCount(__N_CORES__)

        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Ofast -march=native \
")

        #[[


        ]]

        message(CHECK_START "\t[HACKED MATH]")
        if (__REL_USE_HACKED_MATH__)
            set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} \
-ffast-math \
-ffp-model=fast \
-funsafe-math-optimizations \
")
            message(CHECK_PASS "ON")
        else ()
            message(CHECK_FAIL "OFF")
        endif ()
        message(STATUS "")

        #[[


        ]]

    endif ()
    message(STATUS "")

    #[[
















    ]]

    message(STATUS "CXX_FLAGS: [${CMAKE_CXX_FLAGS}]")
    message(STATUS "")

    #[[
















    ]]

else ()
    message(WARNING "Flags currently not tuned for compiler: [${CMAKE_CXX_COMPILER_ID}]")
endif ()