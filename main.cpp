#include <iostream>

auto main(int argc, char *argv[]) -> int {
  // Do not sync with C-style stdio
  {
#ifndef __DEBUG__
    std::ios::sync_with_stdio(false);
    std::cin.tie(nullptr);
#endif
  }
  // Read `bool` as `true` and `false`
  {
    std::cin >> std::boolalpha;
    std::cout << std::boolalpha;
  }

  std::cout << "Hello, World!" << std::endl;
  std::cout << argc << ',' << argv[0] << std::endl;  // NOLINT
  return 0;
}