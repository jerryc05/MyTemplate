message(CHECK_START "\t[ADDRESS SANITIZER]")
if (__DBG_SANITIZE_ADDR__)
    set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} \
-fno-common \
-fno-omit-frame-pointer \
-fno-optimize-sibling-calls \
-fsanitize-address-use-after-scope \
-fsanitize=address \
-fsanitize=pointer-compare \
-fsanitize=pointer-subtract \
")
    # any optimization level will fail leak check

    if (CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
        set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} \
-fsanitize-address-globals-dead-stripping \
-fsanitize-address-poison-custom-array-cookie \
-fsanitize-address-use-odr-indicator \
")
    endif ()

    #[[


    ]]

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
    # [MSG] "check_initialization_order=1" is not supported on MacOS
    # [BUG] "handle_ioctl=1" does not work properly?
    # [DEL] "print_module_map=1" prints too much text
    # [DEL] "print_stats=1" prints too much text

    # "ASAN_SYMBOLIZER_PATH" seems unnecessary if compiled with "-g"

    message(CHECK_PASS "ON [WARNING: DO NOT USE WITH VALGRIND!] \n\n\tASAN_OPTIONS=$ENV{ASAN_OPTIONS}")
else ()
    message(CHECK_FAIL "OFF")
endif ()
message(STATUS "")

# [MSG] "-fsanitize-undefined-trap-on-error" enable this only when libubsan is available
# [DEL] "-fsanitize-coverage=trace-pc" needs kernel support