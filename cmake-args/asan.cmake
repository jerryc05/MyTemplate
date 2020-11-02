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
\
-g3 \
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
:decorate_proc_maps=1\
:detect_container_overflow=1\
:detect_invalid_pointer_pairs=2\
:detect_leaks=1\
:detect_stack_use_after_return=1\
:exitcode=1\
:fast_unwind_on_check=1\
:fast_unwind_on_fatal=1\
:fast_unwind_on_malloc=1\
:handle_abort=1\
:handle_segv=1\
:handle_sigbus=1\
:handle_sigfpe=1\
:handle_sigill=1\
:handle_sigtrap=1\
:intercept_tls_get_addr=1\
:leak_check_at_exit=1\
:print_summary=1\
:strict_init_order=1\
:strict_memcmp=0\
:strict_string_checks=1\
:symbolize=1\
:unmap_shadow_on_exit=1\
:windows_hook_rtl_allocators=1\
")
    # [MSG] "check_initialization_order=1" is not supported on MacOS
    # [BUG] "handle_ioctl=1" does not work properly?
    # [DEL] "print_module_map=1" prints too much text
    # [DEL] "print_stats=1" prints too much text
    # [DEL] "verbosity=1" prints too much text

    # "ASAN_SYMBOLIZER_PATH" seems unnecessary if compiled with "-g"

    message(CHECK_PASS "ON [WARNING: DO NOT USE WITH VALGRIND!]")
    message(STATUS "\t[ADDRESS SANITIZER] - ASAN_OPTIONS=$ENV{ASAN_OPTIONS}")
    message(STATUS "\t                Copy from here! ---^")
else ()
    message(CHECK_FAIL "OFF")
endif ()
message(STATUS "")

# [MSG] "-fsanitize-undefined-trap-on-error" enable this only when libubsan is available
# [DEL] "-fsanitize-coverage=trace-pc" needs kernel support