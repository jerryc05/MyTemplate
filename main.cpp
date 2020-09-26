#include <iostream>

#ifdef NDEBUG
  #define __RELEASE__
#else
  #define __DEBUG__
#endif

int main(int argc, char *argv[]) {

#ifdef __RELEASE__
  std::ios::sync_with_stdio(false);
  std::cin.tie(nullptr);
#endif

  std::cout << "Hello, World!" << std::endl;
  std::cout << argc << ',' << argv[0] << std::endl;
  return 0;
}
