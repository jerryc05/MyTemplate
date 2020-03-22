#include <iostream>

int main([[maybe_unused]] int argc, char *argv[]) {
#ifndef NDEBUG
  // debug mode
#else
  // non-debug mode
  std::ios::sync_with_stdio(false);
#endif

  std::cout << "Hello, World!" << std::endl;
  std::cout << argc << ',' << argv[0] << std::endl;
  return 0;
}
