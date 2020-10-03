# CMakeLists.txt in CMakeArgs that enables most warnings and optimizations available.
# Copyright (C) github.com/jerryc05 All rights reserved.


if (CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    message("Adding GCC Flags...")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} \
-std=gnu++2a \
-fanalyzer \
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
    message("")


    #[[
















    ]]

    if (CMAKE_BUILD_TYPE MATCHES "Debug")
        message("CMAKE IN DEBUG MODE")
        add_compile_definitions(__DEBUG__=true)
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -O0 -g3 \
-fexceptions \
-fstack-protector-all \
-ftrapv \
-Wunknown-pragmas \
-Wvector-operation-performance \
")

        #[[ "-fsanitize=thread" not compatible with neither
            "-fsanitize=address" nor "-fsanitize=pointer-*" ]]
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} \
-fsanitize=address \
-fsanitize=pointer-compare \
-fsanitize=pointer-subtract \
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
        # "-fsanitize-undefined-trap-on-error" enable this only when libubsan is available
        # "-fsanitize-coverage=trace-pc" needs kernel support


        #[[
















        ]]


    elseif (CMAKE_BUILD_TYPE MATCHES "Release")
        message("CMAKE IN RELEASE MODE")
        add_compile_definitions(__DEBUG__=false)

        include(ProcessorCount)
        ProcessorCount(N_CORES)
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Ofast -march=native \
-fassociative-math \
-fdelete-dead-exceptions \
-ffinite-loops -ffinite-math-only \
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
-fsplit-wide-types-early \
-fstrict-enums \
-ftree-lrs -ftree-parallelize-loops=${N_CORES} -ftree-vectorize \
-funroll-loops \
-fvariable-expansion-in-unroller \
-funsafe-math-optimizations \
-s \
")
    endif ()
    message("")


    message("CXX_FLAGS: [${CMAKE_CXX_FLAGS}]")
    message("")

else ()
    message("Flags currently not tuned for compiler: [${CMAKE_CXX_COMPILER_ID}]")
endif ()


























