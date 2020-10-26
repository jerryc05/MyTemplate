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
        else ()
            message(WARNING "\t[STATIC ANALYZER] clang-tidy NOT FOUND! SKIPPED!")
        endif ()


        set(__CLANG_ANALYZER_ARGS__
                --analyze
                -fcolor-diagnostics
                -Xanalyzer -analyzer-checker=alpha
                -Xanalyzer -analyzer-output=text
                -Xclang -analyzer-config -Xclang aggressive-binary-operation-simplification=true
                )

        get_property(__TARGETS_LIST__
                DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
                PROPERTY BUILDSYSTEM_TARGETS)

        foreach (__TARGET_NAME__ IN LISTS __TARGETS_LIST__)
            get_target_property(__TARGET_SOURCES_LIST__ ${__TARGET_NAME__} SOURCES)

            unset(__TARGET_SOURCES__)
            foreach (__SOURCE_NAME__ IN LISTS __TARGET_SOURCES_LIST__)
                set(__TARGET_SOURCES__ ${__TARGET_SOURCES__} ${CMAKE_CURRENT_SOURCE_DIR}/${__SOURCE_NAME__})
            endforeach ()

            add_custom_command(TARGET ${__TARGET_NAME__}
                    POST_BUILD
                    COMMAND ${CMAKE_CXX_COMPILER} ${__CLANG_ANALYZER_ARGS__} ${__TARGET_SOURCES__}
                    VERBATIM)

            if (__CLANG_TIDY__)
                add_custom_command(TARGET ${__TARGET_NAME__}
                        POST_BUILD
                        COMMAND ${__CLANG_TIDY__} ${__CLANG_TIDY_ARGS__} ${__TARGET_SOURCES__} --
                        VERBATIM)
            endif ()

        endforeach ()
    else ()
        message(SEND_ERROR "\t[STATIC ANALYZER] SWITCH UNIMPLEMENTED FOR THIS COMPILER CURRENTLY")
    endif ()

    if (__CLANG_TIDY__)
        message(CHECK_PASS "ON: clang-tidy @ [${__CLANG_TIDY__}]")
    else()
        message(CHECK_PASS "ON")
    endif ()

else ()
    message(CHECK_FAIL "OFF")
endif ()
message(STATUS "")