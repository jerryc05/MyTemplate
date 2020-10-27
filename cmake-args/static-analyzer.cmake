message(CHECK_START "\t[STATIC ANALYZER]")
if (__USE_ANALYZER__)

    if (CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} \
--param=analyzer-bb-explosion-factor=20 \
--param=analyzer-max-recursion-depth=10 \
-fanalyzer \
-Wanalyzer-too-complex \
")

    elseif (CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
        unset(__CLANG_TIDY__ CACHE)
        find_program(__CLANG_TIDY__ clang-tidy)

        if (__CLANG_TIDY__)
            set(__CLANG_TIDY_ARGS__
                    --allow-enabling-analyzer-alpha-checkers
                    --checks=*,-android-*,-altera-*,-darwin-*,-fuchsia-*,-google-runtime-references,-llvm-*,-llvmlibc-*,-objc-*,-zircon-*
                    --format-style=google
                    --use-color

                    --extra-arg=-Xclang
                    --extra-arg=-analyzer-config
                    --extra-arg=-Xclang
                    --extra-arg=aggressive-binary-operation-simplification=true,c++-shared_ptr-inlining=true,unroll-loops=true,widen-loops=true
                    )
            set(CMAKE_CXX_CLANG_TIDY ${__CLANG_TIDY__} ${__CLANG_TIDY_ARGS__})

        else ()
            message(WARNING "\t[STATIC ANALYZER] clang-tidy NOT FOUND! SKIPPED!")
        endif ()

    else ()
        message(SEND_ERROR "\t[STATIC ANALYZER] SWITCH UNIMPLEMENTED FOR THIS COMPILER CURRENTLY")
    endif ()

    message(CHECK_PASS "ON")

else ()
    message(CHECK_FAIL "OFF")
endif ()
message(STATUS " ")