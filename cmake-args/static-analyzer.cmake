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
                    --use-color
                    --checks=*,-android-*,-altera-*,-clang-analyzer*,-darwin-*,-fuchsia-*,-llvm-*,-llvmlibc-*,-objc-*,-zircon-*
                    --format-style=google
                    )
            set(CMAKE_CXX_CLANG_TIDY ${__CLANG_TIDY__} ${__CLANG_TIDY_ARGS__})

        else ()
            message(WARNING "\t[STATIC ANALYZER] clang-tidy NOT FOUND! SKIPPED!")
        endif ()

        #[[


        ]]

        file(READ_SYMLINK ${CMAKE_CXX_COMPILER} __ABS_COMPILER_PATH__)
        if (NOT IS_ABSOLUTE "${__ABS_COMPILER_PATH__}")
            get_filename_component(__COMPILER_DIR__ ${CMAKE_CXX_COMPILER} DIRECTORY)
            set(__ABS_COMPILER_PATH__ "${__COMPILER_DIR__}/${__ABS_COMPILER_PATH__}")
        endif ()
        get_filename_component(__ABS_COMPILER_DIR__ ${__ABS_COMPILER_PATH__} DIRECTORY)

        unset(__SCAN_BUILD__ CACHE)
        find_program(__SCAN_BUILD__ scan-build
                PATHS ${__ABS_COMPILER_DIR__})

        if (__SCAN_BUILD__)
            set(__SCAN_BUILD_ARGS__
                    --force-analyze-debug-code
                    -analyzer-config aggressive-binary-operation-simplification=true
                    -enable-checker alpha
                    -maxloop 16
                    -o ./static-analyzer)

            set(CMAKE_CXX_COMPILER_LAUNCHER ${CMAKE_CXX_COMPILER_LAUNCHER} ${__SCAN_BUILD__} ${__SCAN_BUILD_ARGS__})

        else ()
            message(WARNING " \t[STATIC ANALYZER] scan-build NOT FOUND! SKIPPED!")
        endif ()


    else ()
        message(SEND_ERROR "\t[STATIC ANALYZER] SWITCH UNIMPLEMENTED FOR THIS COMPILER CURRENTLY")
    endif ()

    message(CHECK_PASS "ON")

else ()
    message(CHECK_FAIL "OFF")
endif ()
message(STATUS " ")