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
  std::cout << argc << ',' << argv[0] << std::endl;

  return 0;
}