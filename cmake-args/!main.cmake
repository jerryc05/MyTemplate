# Highly customized CMake scripts that enables most warnings and optimizations available.
# Copyright (C) github.com/jerryc05 All rights reserved.

cmake_minimum_required(VERSION 3.7)

if (NOT __DEBUG_DEF_NAME__)
    set(__DEBUG_DEF_NAME__ _DEBUG_BUILD)
endif ()
message(STATUS "\t[DEBUG DEFINITION] - [${__DEBUG_DEF_NAME__}]")
message(STATUS "")

#[[
















]]

# Using ccache if possible
message(CHECK_START "[CCACHE] ...")

unset(__CCACHE__ CACHE)
find_program(__CCACHE__ ccache)

if (__CCACHE__)
    set(CMAKE_CXX_COMPILER_LAUNCHER ${CMAKE_CXX_COMPILER_LAUNCHER} ${__CCACHE__})

    # print info
    execute_process(COMMAND ${__CCACHE__} --version
            OUTPUT_VARIABLE __CCACHE_INFO__)
    string(REGEX MATCH "[^\r\n]+"
            __CCACHE_INFO__ ${__CCACHE_INFO__})
    message(CHECK_PASS "OK: ${__CCACHE_INFO__}")

else ()
    message(CHECK_FAIL "NOT FOUND!")
endif ()
message(STATUS "")

#[[
















]]

if (CMAKE_CXX_COMPILER_ID STREQUAL "GNU")  # Last checked version: GCC 10
    message(STATUS "USING COMPILER [GNU GCC]")
    message(STATUS "")


    include(${CMAKE_CURRENT_SOURCE_DIR}/cmake-args/static-analyzer.cmake)
    include(${CMAKE_CURRENT_SOURCE_DIR}/cmake-args/latest-std.cmake)

    #[[


    ]]

    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} \
-fdiagnostics-color=always \
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
-Wunknown-pragmas \
-Wunused-macros \
-Wuseless-cast \
-Wvector-operation-performance \
-Wzero-as-null-pointer-constant \
")
    # [DEL] "-Wmissing-declarations" is not useful in practice
    # [DEL] "Wpadded" is not useful in practice (much too verbose)
    message(STATUS "")

    #[[
















    ]]

    if (CMAKE_BUILD_TYPE MATCHES "Debug")
        message(STATUS "CMAKE IN DEBUG MODE")
        message(STATUS "")

        add_compile_definitions(${__DEBUG_DEF_NAME__})
        set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} \
-O0 -g3 \
\
-fcf-protection=full \
-fexceptions \
-fstack-protector-all \
-ftrapv \
")

        include(${CMAKE_CURRENT_SOURCE_DIR}/cmake-args/asan.cmake)
        include(${CMAKE_CURRENT_SOURCE_DIR}/cmake-args/lsan-standalone.cmake)
        include(${CMAKE_CURRENT_SOURCE_DIR}/cmake-args/msan.cmake)
        include(${CMAKE_CURRENT_SOURCE_DIR}/cmake-args/tsan.cmake)
        include(${CMAKE_CURRENT_SOURCE_DIR}/cmake-args/ubsan.cmake)

        # todo cfi sanitizer, safe-stack

        #[[
















        ]]


    elseif (CMAKE_BUILD_TYPE MATCHES "Release")
        message(STATUS "CMAKE IN RELEASE MODE")
        message(STATUS "")

        include(ProcessorCount)
        ProcessorCount(__N_CORES__)

        set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} \
-Ofast -march=native \
\
-fdelete-dead-exceptions \
-ffinite-loops \
-fgcse-las -fgcse-sm \
-fipa-pta -fira-loop-pressure \
-fisolate-erroneous-paths-attribute \
-floop-nest-optimize \
-floop-parallelize-all \
-flto \
-fmodulo-sched -fmodulo-sched-allow-regmoves \
-fno-exceptions \
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
-s \
")

        #[[


        ]]

        message(CHECK_START "\t[HACKED MATH]")
        if (__REL_USE_HACKED_MATH__)
            set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} \
-ffast-math \
")
            message(CHECK_PASS "ON")
        else ()
            message(CHECK_FAIL "OFF")
        endif ()
        message(STATUS "")


    endif ()
    message(STATUS "")

    #[[
















    ]]

    include(${CMAKE_CURRENT_SOURCE_DIR}/cmake-args/add-sanitizer-options.cmake)

    message(STATUS "CXX_FLAGS: [${CMAKE_CXX_FLAGS}]")
    message(STATUS "CXX_FLAGS_DEBUG: [${CMAKE_CXX_FLAGS_DEBUG}]")
    message(STATUS "CXX_FLAGS_RELEASE: [${CMAKE_CXX_FLAGS_RELEASE}]")
    message(STATUS "")

    #[[
















    ]]

elseif (CMAKE_CXX_COMPILER_ID STREQUAL "Clang")  # Last checked version: Clang 11
    message(STATUS "USING COMPILER [LLVM Clang]")
    message(STATUS "")


    include(${CMAKE_CURRENT_SOURCE_DIR}/cmake-args/static-analyzer.cmake)
    include(${CMAKE_CURRENT_SOURCE_DIR}/cmake-args/latest-std.cmake)

    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} \
-fcoroutines-ts \
-fdouble-square-bracket-attributes \
-fexperimental-new-pass-manager \
-fenable-matrix \
-fforce-enable-int128 \
-fmodules-ts \
-frelaxed-template-template-args \
-fsized-deallocation \
-fzvector \
\
-fcolor-diagnostics \
-Wall \
-Wextra \
\
-Wabstract-vbase-init \
-Walloca \
-Wanon-enum-enum-conversion \
-Warc-repeated-use-of-weak \
-Warray-bounds-pointer-arithmetic \
-Wassign-enum \
-Watomic-implicit-seq-cst \
-Watomic-properties \
-Wauto-import \
-Wbad-function-cast \
-Wcast-align \
-Wcast-qual \
-Wclass-varargs \
-Wcomma \
-Wconditional-uninitialized \
-Wconsumed \
-Wconversion \
-Wcovered-switch-default \
-Wcstring-format-directive \
-Wctad-maybe-unsupported \
-Wdeprecated \
-Wdirect-ivar-access \
-Wdisabled-macro-expansion \
-Wdivision-by-zero \
-Wdocumentation \
-Wdocumentation-pedantic \
-Wdollar-in-identifier-extension \
-Wdouble-promotion \
-Wdtor-name \
-Wduplicate-decl-specifier \
-Wduplicate-enum \
-Wduplicate-method-arg \
-Wduplicate-method-match \
-Wdynamic-exception-spec \
-Weffc++ \
-Wembedded-directive \
-Wexit-time-destructors \
-Wexpansion-to-defined \
-Wexplicit-ownership-type \
-Wextra-semi \
-Wextra-semi-stmt \
-Wfixed-enum-extension \
-Wflexible-array-extensions \
-Wfloat-equal \
-Wformat-pedantic \
-Wformat-type-confusion \
-Wformat=2 \
-Wfour-char-constants \
-Wgcc-compat \
-Wglobal-constructors \
-Wheader-hygiene \
-Widiomatic-parentheses \
-Wimplicit-fallthrough \
-Wimplicit-retain-self \
-Wimport-preprocessor-directive-pedantic \
-Winvalid-or-nonexistent-directory \
-Wkeyword-macro \
-Wloop-analysis \
-Wmain \
-Wmax-tokens \
-Wmethod-signatures \
-Wmicrosoft \
-Wmisexpect \
-Wmissing-field-initializers \
-Wmissing-method-return-type \
-Wmissing-noreturn \
-Wmissing-variable-declarations \
-Wnon-modular-include-in-module \
-Wnon-virtual-dtor \
-Wnonportable-system-include-path \
-Wnullability-extension \
-Wnullable-to-nonnull-conversion \
-Wold-style-cast \
-Wopenmp \
-Wover-aligned \
-Woverlength-strings \
-Woverriding-method-mismatch \
-Wpacked \
-Wpointer-arith \
-Wpoison-system-directories \
-Wpragmas \
-Wquoted-include-in-framework-header \
-Wreceiver-forward-class \
-Wredundant-parens \
-Wreserved-id-macro \
-Wselector \
-Wshadow-all \
-Wshift-sign-overflow \
-Wsigned-enum-bitfield \
-Wspir-compat \
-Wstatic-in-inline \
-Wstrict-potentially-direct-selector \
-Wstrict-prototypes \
-Wstrict-selector-match \
-Wsuggest-destructor-override \
-Wsuggest-override \
-Wsuper-class-method-mismatch \
-Wswitch-enum \
-Wtautological-constant-in-range-compare \
-Wthread-safety \
-Wthread-safety-beta \
-Wthread-safety-negative \
-Wthread-safety-verbose \
-Wtype-limits \
-Wundeclared-selector \
-Wundef \
-Wundef-prefix \
-Wundefined-func-template \
-Wundefined-internal-type \
-Wundefined-reinterpret-cast \
-Wunguarded-availability \
-Wunreachable-code-aggressive \
-Wunsupported-dll-base-class-template \
-Wunused-exception-parameter \
-Wunused-macros \
-Wunused-member-function \
-Wunused-template \
-Wused-but-marked-unused \
-Wvariadic-macros \
-Wvector-conversion \
-Wweak-template-vtables \
-Wweak-vtables \
-Wwritable-strings \
-Wzero-as-null-pointer-constant \
")
    #[[
    Clang 12 new args:
-Wcompound-token-split \
    ]]

    # [BUG] "-fexperimental-new-constant-interpreter" will produce error with <iostream>
    # [DEL] "-fignore-exceptions" might not be what we want.
    # [DEL] "-fmodules" will conflict with any variabe named "module".
    # [DEL] "-fms-compatibility" might not be what we want.
    # [DEL] "-Wpadded" is not useful in practice (much too verbose)
    # [EXP] "-fglobal-isel -fexperimental-isel" not stable
    # [WTF] "-fallow-unsupported" wtf is this?
    # [WTF] "-fassume-sane-operator-new" wtf is this?
    # [WTF] "-fast" wtf is this?
    # [WTF] "-fastcp" wtf is this?
    # [WTF] "-fastf" wtf is this?
    # [WTF] "-fautolink" wtf is this?
    # [WTF] "-fbuiltin" wtf is this?
    # [WTF] "-fexperimental-relative-c++-abi-vtables" wtf is this?

    # CLion Settings/Preferences | Languages & Frameworks | C/C++ | Clangd
    # CLion Settings/Preferences | Editor | Inspections, C/C++ | General | Clang-Tidy
    message(STATUS "")

    #[[
















    ]]

    if (CMAKE_BUILD_TYPE MATCHES "Debug")
        message(STATUS "CMAKE IN DEBUG MODE")
        message(STATUS "")

        add_compile_definitions(${__DEBUG_DEF_NAME__})
        set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} \
-O0 -g3 \
\
-fcf-protection=full \
-fcxx-exceptions \
-fexceptions \
-fstack-clash-protection \
-fstack-protector-all \
-ftrapv \
")

        include(${CMAKE_CURRENT_SOURCE_DIR}/cmake-args/asan.cmake)
        include(${CMAKE_CURRENT_SOURCE_DIR}/cmake-args/lsan-standalone.cmake)
        include(${CMAKE_CURRENT_SOURCE_DIR}/cmake-args/msan.cmake)
        include(${CMAKE_CURRENT_SOURCE_DIR}/cmake-args/tsan.cmake)
        include(${CMAKE_CURRENT_SOURCE_DIR}/cmake-args/ubsan.cmake)

        #[[


        ]]

        message(CHECK_START "\t[C.F.I. SANITIZER]") # todo
        if (__DBG_SANITIZE_CFI__)
            set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} \
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

        set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} \
-Ofast -march=native \
\
-finline-functions \
-finline-hint-functions \
-flto=full \
-fmerge-all-constants \
-fno-cxx-exceptions \
-fno-exceptions \
-foptimize-sibling-calls \
-fslp-vectorize -ftree-slp-vectorize \
-fstrict-enums \
-fstrict-vtable-pointers \
-funroll-loops \
-fvirtual-function-elimination \
-fwhole-program-vtables \
-mllvm --inline-threshold=1000 \
-mllvm --polly \
-mllvm --polly-2nd-level-tiling \
-mllvm --polly-ast-detect-parallel \
-mllvm --polly-ast-use-context \
-mllvm --polly-check-parallel \
-mllvm --polly-check-vectorizable \
-mllvm --polly-delicm-compute-known  \
-mllvm --polly-delicm-partial-writes \
-mllvm --polly-delinearize \
-mllvm --polly-detect-full-functions \
-mllvm --polly-detect-reductions \
-mllvm --polly-enable-delicm \
-mllvm --polly-enable-mse \
-mllvm --polly-enable-optree \
-mllvm --polly-enable-prune-unprofitable \
-mllvm --polly-enable-simplify \
-mllvm --polly-optimized-scops \
-mllvm --polly-optree-analyze-known \
-mllvm --polly-optree-normalize-phi \
-mllvm --polly-parallel \
-mllvm --polly-precise-fold-accesses \
-mllvm --polly-register-tiling \
-mllvm --polly-run-dce \
-mllvm --polly-run-inliner \
-mllvm --polly-tiling \
-mllvm --polly-vectorizer=polly \
-s \
")

        #[[


        ]]

        message(CHECK_START "\t[HACKED MATH]")
        if (__REL_USE_HACKED_MATH__)
            set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} \
-ffast-math \
-ffp-model=fast \
-funsafe-math-optimizations \
")
            message(CHECK_PASS "ON")
        else ()
            set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} \
-fno-fast-math \
")
            message(CHECK_FAIL "OFF")
        endif ()
        message(STATUS "")

        #[[


        ]]

    endif ()
    message(STATUS "")

    #[[
















    ]]

    include(${CMAKE_CURRENT_SOURCE_DIR}/cmake-args/add-sanitizer-options.cmake)

    message(STATUS "CXX_FLAGS: [${CMAKE_CXX_FLAGS}]")
    message(STATUS "CXX_FLAGS_DEBUG: [${CMAKE_CXX_FLAGS_DEBUG}]")
    message(STATUS "CXX_FLAGS_RELEASE: [${CMAKE_CXX_FLAGS_RELEASE}]")
    message(STATUS "")

    #[[
















    ]]

else ()
    message(WARNING "Flags currently not tuned for compiler: [${CMAKE_CXX_COMPILER_ID}]")
endif ()