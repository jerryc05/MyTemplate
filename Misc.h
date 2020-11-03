/*
 * Copyright (c) 2019-2020 Ziyan "Jerry" Chen (@jerryc05).
 *                         All rights reserved.
 */

#pragma once

#include <array>
#include <cassert>
#include <cstdint>
#include <deque>
#include <functional>
#include <iostream>
#include <queue>
#include <tuple>
#include <unordered_map>
#include <vector>

#define _ccast const_cast
#define _rcast reinerpret_cast
#define _scast static_cast

using F32 = float;
using I16 = std::int16_t;
using U32 = std::uint32_t;
using Usize = std::size_t;

#if (__GNUC__ >= 6) || (__clang_major__ >= 6)
#define _nodiscard    [[nodiscard]]
#define _maybe_unused [[maybe_unused]]
#else
#define _nodiscard
#define _maybe_unused
#endif

template<typename T, Usize S>
using Arr = std::array<T, S>;
template<typename T>
using Deque = std::deque<T>;
template<typename K, typename V>
using HashMap = std::unordered_map<K, V>;
using InputStream = std::istream;
template<typename T1, typename T2>
using Pair = std::pair<T1, T2>;
using String = std::string;
template<typename... Ts>
using Tuple = std::tuple<Ts...>;
template<typename T>
using Vec = std::vector<T>;

template<typename T, typename Cmp=std::less<T>>
using Pq = std::priority_queue<T, Vec<T>, Cmp>;

auto inline skip_current_line(InputStream &is,
                              InputStream::int_type delim = '\n') -> void {
  is.ignore(std::numeric_limits<std::streamsize>::max(), delim);
}