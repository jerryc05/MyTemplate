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
#include <map>
#include <memory>
#include <optional>
#include <experimental/optional>
#include <queue>
#include <tuple>
#include <unordered_map>
#include <utility>
#include <variant>
#include <vector>

#define _ccast const_cast
#define _rcast reinterpret_cast
#define _scast static_cast

using F32 = float;
using I16 = std::int16_t;
using U32 = std::uint32_t;
using Usize = std::size_t;

#if (__GNUC__ >= 6) || (__clang_major__ >= 6)
#define _maybe_unused [[maybe_unused]]
#define _nodiscard    [[nodiscard]]
#define _noexcept     noexcept
#define _noreturn     [[noreturn]]
#else
#define _maybe_unused
#define _nodiscard
#define _noexcept
#define _noreturn
#endif

#if __GNUC__ || __clang_major__ || _MSC_VER
#define _restrict __restrict
#else
#define _restrict
#endif


template<typename T, Usize S>
using Arr = std::array<T, S>;
template<typename T>
using Deque = std::deque<T>;
template<
        typename Key,
        typename Val,
        typename Hash = std::hash<Key>,
        typename KeyEq = std::equal_to<Key>,
        typename Alloc = std::allocator<std::pair<const Key, Val> >
>
using HashMap = std::unordered_map<Key, Val, Hash, KeyEq, Alloc>;
using InputStream = std::istream;
template<typename T>
using Optional = std::optional<T>;
template<typename T1, typename T2>
using Pair = std::pair<T1, T2>;
template<
        typename T,
        typename Cont=std::vector<T>,
        typename Cmp=std::less<typename Cont::value_type>
>
using Pq = std::priority_queue<T, Cont, Cmp>;
using String = std::string;
template<
        typename Key,
        typename Val,
        typename Cmp = std::less<Key>,
        typename Alloc = std::allocator<std::pair<const Key, Val> >
>
using TreeMap = std::map<Key, Val, Cmp, Alloc>;
template<typename... Ts>
using Tuple = std::tuple<Ts...>;
template<typename... Ts>
using Variant = std::variant<Ts...>;
template<typename T, typename Alloc = std::allocator<T>>
using Vec = std::vector<T, Alloc>;


auto inline skip_current_line(InputStream &is,
                              InputStream::int_type delim = '\n') {
  is.ignore(std::numeric_limits<std::streamsize>::max(), delim);
}