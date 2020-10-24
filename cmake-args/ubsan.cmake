message(CHECK_START "\t[UNDEF. BHVR. SANITIZER]")
if (__DBG_SANITIZE_UB__)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} \
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
-fsanitize=object-size \
-fsanitize=pointer-overflow \
-fsanitize=return \
-fsanitize=returns-nonnull-attribute \
-fsanitize=shift -fsanitize=shift-base -fsanitize=shift-exponent \
-fsanitize=signed-integer-overflow \
-fsanitize=unreachable \
-fsanitize=vla-bound \
-fsanitize=vptr \
")
    # "-O0" has no effect for object-size sanitizer [clang]
    # "-fsanitize-undefined-trap-on-error" enable this only when libubsan is available

    if (CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} \
-fsanitize=bounds-strict \
")
    elseif (CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} \
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

    message(CHECK_PASS "ON")
else ()
    message(CHECK_FAIL "OFF")
endif ()
message(STATUS "")