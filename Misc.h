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

// Workarounds
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

// Casts
#define _ccast    const_cast
#define _dcast    dynamic_cast
#define _rcast    reinterpret_cast
#define _scast    static_cast

// Asserts
#define _sassert  static_assert

// Annotations
#if (__GNUC__ >= 6) || (__clang_major__ >= 6)
/**/#define MAYBE_UNUSED [[maybe_unused]]
/**/#define NODISCARD    [[nodiscard]]
/**/#define NOEXCEPT     noexcept
/**/#define NORETURN     [[noreturn]]
#else
/**/#define MAYBE_UNUSED
/**/#define NODISCARD
/**/#define NOEXCEPT
/**/#define NORETURN
#endif

// Keywords
#if __GNUC__ || __clang_major__ || _MSC_VER
/**/#define RESTRICT __restrict
/**/#if __GNUC__ || __clang_major__
/**//**/#define INLINE_ALWAYS  __attribute__((always_inline))
/**//**/#define INLINE_NEVER   __attribute__((noinline))
/**/#else
/**//**/#define INLINE_ALWAYS  __declspec(noinline)
/**/#endif
#else
/**/#define RESTRICT
/**/#define INLINE_ALWAYS inline_restrict
/**/#define INLINE_NEVER
#endif


using F32 MAYBE_UNUSED = float;
using F64 MAYBE_UNUSED = double;
using I8 MAYBE_UNUSED = std::int8_t;
using I16 MAYBE_UNUSED = std::int16_t;
using I32 MAYBE_UNUSED = std::int32_t;
using I64 MAYBE_UNUSED = std::int64_t;
using U8 MAYBE_UNUSED = std::uint8_t;
using U16 MAYBE_UNUSED = std::uint16_t;
using U32 MAYBE_UNUSED = std::uint32_t;
using U64 MAYBE_UNUSED = std::uint64_t;
using Usize MAYBE_UNUSED = std::size_t;


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
INLINE_ALWAYS auto skip_current_line(
        std::basic_istream<Char> &is,
        typename std::basic_istream<Char>::int_type delim = '\n') {
  is.ignore(std::numeric_limits<std::streamsize>::max(), delim);
}