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
#if __cplusplus >= 201703
/**/#include <optional>
#else
/**/#include <experimental/optional>
#endif
#include <queue>
#include <tuple>
#include <unordered_map>
#include <utility>
#include <variant>
#include <vector>

#define _ccast    const_cast
#define _dcast    dynamic_cast
#define _rcast    reinterpret_cast
#define _scast    static_cast
#define _sassert  static_assert

#if (__GNUC__ >= 6) || (__clang_major__ >= 6)
/**/#define _maybe_unused [[maybe_unused]]
/**/#define _nodiscard    [[nodiscard]]
/**/#define _noexcept     noexcept
/**/#define _noreturn     [[noreturn]]
#else
/**/#define _maybe_unused
/**/#define _nodiscard
/**/#define _noexcept
/**/#define _noreturn
#endif

#if __GNUC__ || __clang_major__ || _MSC_VER
/**/#define _restrict __restrict
/**/#if __GNUC__ || __clang_major__
/**//**/#define _inline_always  __attribute__((always_inline))
/**//**/#define _inline_never   __attribute__((noinline))
/**/#else
/**//**/#define _inline_always  __declspec(noinline)
/**/#endif
#else
/**/#define _restrict
/**/#define _inline_always inline_restrict
/**/#define _inline_never
#endif


using F32 = float;
using I8 = std::int8_t;
using I16 = std::int16_t;
using I32 = std::int32_t;
using I64 = std::int64_t;
using U8 = std::uint8_t;
using U16 = std::uint16_t;
using U32 = std::uint32_t;
using U64 = std::uint64_t;
using Usize = std::size_t;


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

template<typename Char>
_inline_always auto skip_current_line(
        std::basic_istream<Char> &is,
        typename std::basic_istream<Char>::int_type delim = '\n') {
  is.ignore(std::numeric_limits<std::streamsize>::max(), delim);
}