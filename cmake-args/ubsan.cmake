message(CHECK_START "\t[UNDEF. BHVR. SANITIZER]")
if (__DBG_SANITIZE_UB__)
    set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} \
-fsanitize=undefined \
\
-fsanitize=alignment \
-fsanitize=bool \
-fsanitize=bounds \
-fsanitize=builtin \
-fsanitize=enum \
-fsanitize=float-cast-overflow \
-fsanitize=float-divide-by-zero \
-fsanitize=integer-divide-by-zero \
-fsanitize=nonnull-attribute \
-fsanitize=null \
-fsanitize=pointer-overflow \
-fsanitize=return \
-fsanitize=returns-nonnull-attribute \
-fsanitize=shift -fsanitize=shift-base -fsanitize=shift-exponent \
-fsanitize=signed-integer-overflow \
-fsanitize=unreachable \
-fsanitize=vla-bound \
-fsanitize=vptr \
")
    # "-fsanitize-undefined-trap-on-error" enable this only when libubsan is unavailable

    if (CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
        set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} \
-fsanitize=bounds-strict \
-fsanitize=object-size \
")
        # "-O0" has no effect for object-size sanitizer [clang]

    elseif (CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
        set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} \
-fsanitize=array-bounds \
-fsanitize=function \
-fsanitize=implicit-conversion \
-fsanitize=implicit-integer-arithmetic-value-change \
-fsanitize=implicit-integer-truncation \
-fsanitize=integer \
-fsanitize=nullability \
-fsanitize=unsigned-integer-overflow \
")
    endif ()

    #[[


    ]]

    set(ENV{UBSAN_OPTIONS} "$ENV{UBSAN_OPTIONS}\
:allow_addr2line=1\
:decorate_proc_maps=1\
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
:legacy_pthread_cond=1\
:print_stacktrace=1\
:print_summary=1\
:strict_string_checks=1\
:symbolize=1\
")
    # TODO check "handle_ioctl=1" here
    # [DEL] "verbosity=1" prints too much text

    message(CHECK_PASS "ON")
    message(STATUS "\t[UNDEF. BHVR. SANITIZER] - UBSAN_OPTIONS=$ENV{UBSAN_OPTIONS}")
    message(STATUS "\t                      Copy from here! ---^")
else ()
    message(CHECK_FAIL "OFF")
endif ()
message(STATUS "")