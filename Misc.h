#pragma once

#include <array>
#include <cassert>
#include <cstdint>
#include <deque>
#include <functional>
#include <iostream>
#include <queue>
#include <tuple>
#include <vector>

using F32 = float;
using I16 = std::int16_t;
using U32 = std::uint32_t;
using Usize = std::size_t;

template<typename T, Usize S> using Arr = std::array<T, S>;
template<typename T> using Deque = std::deque<T>;
template<typename K, typename V> using HashMap = std::unordered_map<K, V>;
using InputStream = std::istream;
template<typename T1, typename T2> using Pair = std::pair<T1, T2>;
using String = std::string;
template<typename... Ts> using Tuple = std::tuple<Ts...>;
template<typename T> using Vec = std::vector<T>;

template<typename T, typename Cmp=std::less<T>> using Pq = std::priority_queue<T, Vec<T>, Cmp>;

auto inline skip_current_line(InputStream &is,
                              InputStream::int_type delim = '\n') -> void {
  is.ignore(std::numeric_limits<std::streamsize>::max(), delim);
}