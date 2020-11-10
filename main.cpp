/*
 * Copyright (c) 2019-2020 Ziyan "Jerry" Chen (@jerryc05).
 *                         All rights reserved.
 */

#include <iostream>
#include "Misc.h"

auto main(int argc, char *argv[]) -> int {
  // init starter
  {
    // Do not sync with C-style stdio
#ifndef _DEBUG_BUILD
    std::ios::sync_with_stdio(false);
    std::cin.tie(nullptr);
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

  return 0;
}