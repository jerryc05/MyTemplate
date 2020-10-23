message(CHECK_START "\t[LEAK SANITIZER (STANDALONE)]")
if (__DBG_SANITIZE_LEAK_STANDALONE__)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} \
-fsanitize=leak \
")
    message(CHECK_PASS "ON [WARNING: DO NOT USE WITH VALGRIND!]")
else ()
    message(CHECK_FAIL "OFF")
endif ()
message(STATUS "")