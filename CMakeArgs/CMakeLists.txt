# CMakeLists.txt in CMakeArgs that enables most warnings and optimizations available.
# Copyright (C) github.com/jerryc05 All rights reserved.

# Parsing args
option(__USE_ANALYZER__             "STATIC ANALYZER"           OFF)
option(__NO_USE_ADDR_SANITIZER__    "NO ADDR SANITIZER"         OFF)
option(__NO_USE_UB_SANITIZER__      "NO UNDEF. BHVR. SANITIZER" OFF)
if (NOT __NO_USE_ADDR_SANITIZER__)
    set(__USE_THD_SANITIZER__                                   OFF)
endif ()
option(__NO_GCC6_COMPAT_FLAGS__     "GCC6 COMPAT. FLAGS"        OFF)

#[[
















]]

# Using ccache if possible
message(CHECK_START "Finding [CCACHE] ...")
find_program(__CCACHE__ ccache)

if (__CCACHE__)
    set(CMAKE_C_COMPILER_LAUNCHER "${__CCACHE__}")
    set(CMAKE_CXX_COMPILER_LAUNCHER "${__CCACHE__}")

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
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fanalyzer")
        message(CHECK_PASS "ON")
    else ()
        message(CHECK_FAIL "OFF")
    endif ()

    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} \
-std=gnu++2a \
-Wall \
-Wextra \
\
-Walloc-zero -Walloca \
-Wanalyzer-too-complex \
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
-fexceptions \
-fstack-protector-all \
-ftrapv \
-Wunknown-pragmas \
-Wvector-operation-performance \
")

        #[[


        ]]

        message(CHECK_START "\t[ADDRESS SANITIZER]")
        if (NOT __NO_USE_ADDR_SANITIZER__)
            set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} \
-fsanitize=address \
-fsanitize=pointer-compare \
-fsanitize=pointer-subtract")
            message(CHECK_PASS "ON")
        else ()
            message(CHECK_FAIL "OFF")
        endif ()
        message(STATUS "")

        #[[


        ]]

        #[[ "-fsanitize=thread" not compatible with neither
            "-fsanitize=address" nor "-fsanitize=pointer-*" ]]
        message(CHECK_START "\t[THREAD SANITIZER]")
        if (__USE_THD_SANITIZER__)
            set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fsanitize=thread")
            message(CHECK_PASS "ON")
        else ()
            message(CHECK_FAIL "OFF")
        endif ()
        message(STATUS "")

        #[[


        ]]

        message(CHECK_START "\t[UNDEF. BHVR. SANITIZER]")
        if (NOT __NO_USE_UB_SANITIZER__)
            set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} \
-fsanitize=leak \
-fsanitize=undefined \
-fsanitize=shift -fsanitize=shift-exponent -fsanitize=shift-base \
-fsanitize=integer-divide-by-zero \
-fsanitize=unreachable \
-fsanitize=vla-bound \
-fsanitize=null \
-fsanitize=return \
-fsanitize=signed-integer-overflow \
-fsanitize=bounds -fsanitize=bounds-strict \
-fsanitize=alignment \
-fsanitize=object-size \
-fsanitize=float-divide-by-zero -fsanitize=float-cast-overflow \
-fsanitize=nonnull-attribute -fsanitize=returns-nonnull-attribute \
-fsanitize=bool \
-fsanitize=enum \
-fsanitize=vptr \
-fsanitize=pointer-overflow \
-fsanitize=builtin \
-fsanitize-address-use-after-scope \
-fsanitize-coverage=trace-cmp \
")
            message(CHECK_PASS "ON")
            # "-fsanitize-undefined-trap-on-error" enable this only when libubsan is available
            # "-fsanitize-coverage=trace-pc" needs kernel support
        else ()
            message(CHECK_FAIL "OFF")
        endif ()
        message(STATUS "")

        #[[
















        ]]


    elseif (CMAKE_BUILD_TYPE MATCHES "Release")
        message(STATUS "CMAKE IN RELEASE MODE")
        message(STATUS "")

        include(ProcessorCount)
        ProcessorCount(__N_CORES__)

        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Ofast -march=native \
-fassociative-math \
-fdelete-dead-exceptions \
-ffinite-math-only \
-fgcse-las -fgcse-sm \
-fipa-pta -fira-loop-pressure \
-fisolate-erroneous-paths-attribute \
-floop-nest-optimize \
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
-fstrict-enums \
-ftree-lrs -ftree-parallelize-loops=${__N_CORES__} -ftree-vectorize \
-funroll-loops \
-fvariable-expansion-in-unroller \
-funsafe-math-optimizations \
-s \
")

        #[[


        ]]

        message(CHECK_START "\t[GCC6 NON-COMPAT. FLAGS]")
        if (NOT __NO_GCC6_COMPAT_FLAGS__)
            set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} \
-ffinite-loops \
-fsplit-wide-types-early \
")
            message(CHECK_PASS "ON")
            # "-fsanitize-undefined-trap-on-error" enable this only when libubsan is available
            # "-fsanitize-coverage=trace-pc" needs kernel support
        else ()
            message(CHECK_FAIL "OFF")
        endif ()
        message(STATUS "")


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