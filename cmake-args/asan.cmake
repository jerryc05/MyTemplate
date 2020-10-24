message(CHECK_START "\t[ADDRESS SANITIZER]")
if (__DBG_SANITIZE_ADDR__)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} \
-fno-common \
-fno-omit-frame-pointer \
-fno-optimize-sibling-calls \
-fsanitize-address-use-after-scope \
-fsanitize=address \
-fsanitize=pointer-compare \
-fsanitize=pointer-subtract \
")
    # any optimization level will fail leak check

    set(ENV{ASAN_OPTIONS} "$ENV{ASAN_OPTIONS}\
:allow_addr2line=1\
:check_initialization_order=1\
:check_printf=1\
:detect_deadlocks=1\
:detect_invalid_pointer_pairs=2\
:detect_leaks=1\
:detect_stack_use_after_return=1\
:exitcode=1\
:handle_abort=1\
:handle_segv=1\
:handle_sigbus=1\
:handle_sigfpe=1\
:handle_sigill=1\
:handle_sigtrap=1\
:intercept_intrin=1\
:intercept_memcmp=1\
:intercept_memmem=1\
:intercept_send=1\
:intercept_stat=1\
:intercept_strchr=1\
:intercept_strlen=1\
:intercept_strndup=1\
:intercept_strpbrk=1\
:intercept_strspn=1\
:intercept_strstr=1\
:intercept_strtok=1\
:leak_check_at_exit=1\
:print_summary=1\
:strict_init_order=1\
:strict_string_checks=1\
:symbolize=1\
:unmap_shadow_on_exit=1\
:windows_hook_rtl_allocators=1\
")
    # "check_initialization_order=1" is not supported on MacOS
    # "handle_ioctl=1" does not work properly?
    # "print_module_map=1" prints too much text
    # "print_stats=1" prints too much text

    if (CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
        message(CHECK_START "\t[ADDRESS SANITIZER SYMBOLIZER")
        get_filename_component(__COMPILER_DIR__ ${CMAKE_CXX_COMPILER} DIRECTORY)
        find_file(__SYMBOLIZER_PATH__ llvm-symbolizer
                PATH ${__COMPILER_DIR__})
        # todo parse /usr/lib/llvm*/llvm-symbolizer
        if (__SYMBOLIZER_PATH__)
            set(ENV{ASAN_SYMBOLIZER_PATH} "$ENV{ASAN_SYMBOLIZER_PATH}\
:__SYMBOLIZER_PATH__\
")
            message(CHECK_PASS "ON [${__SYMBOLIZER_PATH__}]")
        else()
            message(CHECK_FAIL "OFF")
        endif ()
    endif ()

    message(CHECK_PASS "ON [WARNING: DO NOT USE WITH VALGRIND!] [$ENV{ASAN_OPTIONS}]")
    message(CHECK_PASS "ON ASAN_OPTIONS=[$ENV{ASAN_OPTIONS}]")
else ()
    message(CHECK_FAIL "OFF")
endif ()
message(STATUS "")