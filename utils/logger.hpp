#ifndef LOGGER_HPP
#define LOGGER_HPP

#include <iostream>

using std::cout, std::cerr, std::ostream;

[[maybe_unused]] ostream &log_e();

[[maybe_unused]] ostream &log_i();

#ifndef NDEBUG
[[maybe_unused]] ostream &log_d();
#endif

#endif //LOGGER_HPP
