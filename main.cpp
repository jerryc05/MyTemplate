#include <iostream>

int main(int argc, char *argv[]) {
#ifndef NDEBUG
  // debug mode
#else
  // non-debug mode
  std::ios::sync_with_stdio(false);
#endif

  std::cout << "Hello, World!" << std::endl;
  std::cout << argc << ',' << argv << std::endl;
  return 0;
}
