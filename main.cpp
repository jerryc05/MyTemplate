/*
 * Copyright (c) 2019-2020 Ziyan "Jerry" Chen (@jerryc05).
 *                         All rights reserved.
 */

#include <iostream>
#include "Misc.h"

auto main(int argc, char *argv[]) -> int {
  // init starter
  {
    // handle signals
    std::signal(SIGABRT, stackTraceSigHandler<>);
    std::signal(SIGFPE, stackTraceSigHandler<>);
    std::signal(SIGILL, stackTraceSigHandler<>);
    std::signal(SIGINT, stackTraceSigHandler<>);
    std::signal(SIGSEGV, stackTraceSigHandler<>);
    std::signal(SIGTERM, stackTraceSigHandler<>);

    // Do not sync with C-style stdio
#ifndef DEBUG_MODE
    std::ios::sync_with_stdio(false);
    std::cin.tie(nullptr);
    std::cout.tie(nullptr);
#endif

    // Read `bool` as `true` and `false`
    std::cin >> std::boolalpha;
    std::cout << std::boolalpha;
  }

  // TODO Delete the following lines
  std::cout << "Hello, World!" << std::endl;
  for (int i = 0; i < argc; ++i) {
    std::cout << "argv[" << i << "]: " << argv[i] << std::endl;
  }

  /* This will "prevent" memory leak, but will also prevent calling destructors.
     Make sure to wrap all other codes in a curly bracket before calling `exit()`.  */
  // std::exit(0);

  return 0;
}