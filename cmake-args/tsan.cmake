#[[ "-fsanitize=thread" not compatible with neither
            "-fsanitize=address" nor "-fsanitize=pointer-*" ]]
message(CHECK_START "\t[THREAD SANITIZER]")
if (__DBG_SANITIZE_THRD__)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} \
-fsanitize=thread \
")
    message(CHECK_PASS "ON")
else ()
    message(CHECK_FAIL "OFF")
endif ()
message(STATUS "")