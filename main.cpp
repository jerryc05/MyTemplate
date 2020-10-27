#include <iostream>

auto main(int argc, char *argv[]) -> int {
#ifndef __DEBUG__
  std::ios::sync_with_stdio(false);
  std::cin.tie(nullptr);
#endif

  std::cout << "Hello, World!" << std::endl;
  std::cout << argc << ',' << argv[0] << std::endl;  // NOLINT
  return 0;
}