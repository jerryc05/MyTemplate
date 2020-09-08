#include <iostream>

int main(int argc, char *argv[]) {
#ifndef NDEBUG
  // debug mode
#else
  // non-debug mode
  std::ios::sync_with_stdio(false);
  std::cin.tie(nullptr);
#endif

  std::cout << "Hello, World!" << std::endl;
  std::cout << argc << ',' << argv[0] << std::endl;
  return 0;
}
