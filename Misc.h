/*
 * Copyright (c) 2019-2020 Ziyan "Jerry" Chen (@jerryc05).
 *                         All rights reserved.
 */

#pragma once

// Annotations
#if (__GNUC__ >= 6) || (__clang_major__ >= 6)
#define MAYBE_UNUSED [[maybe_unused]]
#define NODISCARD    [[nodiscard]]
#define NOEXCEPT     noexcept
#define NORETURN     [[noreturn]]
#else
#define MAYBE_UNUSED
#define NODISCARD
#define NOEXCEPT
#define NORETURN
#endif

// Asserts
#define sassert  static_assert

// Casts
#define ccast    const_cast
#define dcast    dynamic_cast
#define rcast    reinterpret_cast
#define scast    static_cast

// Includes
#include <array>
#include <cassert>
#include <cstddef>
#include <cstdint>
#include <deque>
#include <functional>
#include <iostream>
#include <map>
#include <memory>
#include <queue>
#include <tuple>
#include <unordered_map>
#include <utility>
#include <vector>

// Workarounds
#if (__GNUC__ * 10 + __GNUC_MINOR__ >= 49) || (__clang_major__ * 10 + __clang_minor__ >= 33)

#if (__GNUC__ >= 7) || (__clang_major__ >= 5)
#include <optional>
#include <string_view>
#include <variant>
template<typename... Ts>
using Variant MAYBE_UNUSED = std::variant<Ts...>;
#else
#include <experimental/optional>
#include <experimental/string_view>
#endif
#if (__GNUC__ >= 5) || (__clang_major__ * 10 + __clang_minor__ >= 34)
#include <functional>
template <typename T>
using Fn = std::function<T>;
#endif

template<typename T>
using Optional MAYBE_UNUSED = std::optional<T>;
template<typename T=char>
using Str MAYBE_UNUSED = std::basic_string_view<T, std::char_traits<T>>;
sassert(std::is_same<Str<>, std::string_view>::value);
#endif

// Keywords
#if __GNUC__ || __clang_major__ || _MSC_VER

#if __GNUC__ || __clang_major__
#define CONST_ATTRIB  __attribute__((const))
#define F_INLINE      __attribute__((always_inline))
#define NOINLINE      __attribute__((noinline))
#define PURE_ATTRIB   __attribute__((pure))
#else
#define CONST_ATTRIB
#define F_INLINE      __forceinline
#define NOINLINE      __declspec(noinline)
#define PURE_ATTRIB
#endif

#define RESTRICT      __restrict
#else
#define CONST_ATTRIB
#define F_INLINE      inline
#define NOINLINE
#define RESTRICT
#define PURE_ATTRIB
#endif


using Byte MAYBE_UNUSED = std::byte;
using F32 MAYBE_UNUSED = float;
using F64 MAYBE_UNUSED = double;
using I8 MAYBE_UNUSED = std::int8_t;
using I16 MAYBE_UNUSED = std::int16_t;
using I32 MAYBE_UNUSED = std::int32_t;
using I64 MAYBE_UNUSED = std::int64_t;
using Isize MAYBE_UNUSED = std::ptrdiff_t;
using U8 MAYBE_UNUSED = std::uint8_t;
using U16 MAYBE_UNUSED = std::uint16_t;
using U32 MAYBE_UNUSED = std::uint32_t;
using U64 MAYBE_UNUSED = std::uint64_t;
using Usize MAYBE_UNUSED = std::size_t;


template<typename T, Usize S>
using Arr MAYBE_UNUSED = std::array<T, S>;
using CStr = char[];
template<typename T>
using Deque MAYBE_UNUSED = std::deque<T>;
template<
        typename Key,
        typename Val,
        typename Hash = std::hash<Key>,
        typename KeyEq = std::equal_to<Key>,
        typename Alloc = std::allocator<std::pair<const Key, Val> >
>
using HashMap MAYBE_UNUSED = std::unordered_map<Key, Val, Hash, KeyEq, Alloc>;
sassert(std::is_same<HashMap<int,char>, std::unordered_map<int,char>>::value);
template<typename T1, typename T2>
using Pair MAYBE_UNUSED = std::pair<T1, T2>;
using PcwsConstr = std::piecewise_construct_t;
template<
        typename T,
        typename Cont=std::vector<T>,
        typename Cmp=std::less<typename Cont::value_type>
>
using Pq MAYBE_UNUSED = std::priority_queue<T, Cont, Cmp>;
sassert(std::is_same<Pq<int>, std::priority_queue<int>>::value);
template<
        typename T=char,
        typename Alloc=std::allocator<T>
>
using String MAYBE_UNUSED = std::basic_string<T, std::char_traits<T>, Alloc>;
sassert(std::is_same<String<>, std::string>::value);
template<
        typename Key,
        typename Val,
        typename Cmp = std::less<Key>,
        typename Alloc = std::allocator<std::pair<const Key, Val> >
>
using TreeMap MAYBE_UNUSED = std::map<Key, Val, Cmp, Alloc>;
sassert(std::is_same<TreeMap<int,char>, std::map<int,char>>::value);
template<typename... Ts>
using Tuple MAYBE_UNUSED = std::tuple<Ts...>;
template<typename T, typename Alloc = std::allocator<T>>
using Vec MAYBE_UNUSED = std::vector<T, Alloc>;
sassert(std::is_same<Vec<int>, std::vector<int>>::value);

template<typename Char>
MAYBE_UNUSED F_INLINE void skipCurrentLine(
        std::basic_istream<Char> &is,
        typename std::basic_istream<Char>::int_type delim = '\n') {
  is.ignore(std::numeric_limits<std::streamsize>::max(), delim);
}

template<typename T>
MAYBE_UNUSED F_INLINE Arr<Byte, sizeof(T)> allocUninit() {
  Arr<Byte, sizeof(T)> arr;
  return arr;
}

// Memory Resource
#if (__GNUC__ >= 6) || (__clang_major__ * 10 + __clang_minor__ >= 35)

#if (__GNUC__ >= 9) || (__clang_major__ >= 9)
#include <memory_resource>
#else
#include <experimental/memory_resource>
#endif

using MonoBufRes = std::pmr::monotonic_buffer_resource;
template<typename T>
using PmrAlloc = std::pmr::polymorphic_allocator<T>;

class MyNewDelRes : public std::pmr::memory_resource {
private:
  void *do_allocate(Usize size, Usize alignment) override;

  void do_deallocate(void *ptr, Usize size, Usize alignment) override;

  NODISCARD bool do_is_equal(const std::pmr::memory_resource &other) const NOEXCEPT override;
};

void *
MyNewDelRes::do_allocate(Usize size, Usize alignment) {
  std::cout << "Al  locating " << size << '\n';
  return std::pmr::new_delete_resource()->allocate(size, alignment);
}

void
MyNewDelRes::do_deallocate(void *ptr, Usize size, Usize alignment) {
  std::cout << "Deallocating " << size << ": [";

  for (Usize i = 0; i < size; ++i) {
    std::cout << scast<char *>(ptr)[i];
  }
  std::cout << "]\n";

  return std::pmr::new_delete_resource()->deallocate(ptr, size, alignment);
}

NODISCARD bool
MyNewDelRes::do_is_equal(const std::pmr::memory_resource &other) const NOEXCEPT {
  return std::pmr::new_delete_resource()->is_equal(other);
}


template<Usize capacity>
void pmrExample() {
  MyNewDelRes mem;
  std::pmr::set_default_resource(&mem);

  Byte       buf[capacity];
  MonoBufRes res(std::data(buf), std::size(buf));

  using PmrStr = String<char, PmrAlloc<char>>;
  Vec<PmrStr, PmrAlloc<PmrStr>> v(4, &res);  // Do this!
  Vec<PmrStr, PmrAlloc<PmrStr>> v2({"This will be heap-allocated!"}, &res);  // Don't do this!

  v.emplace_back("This will be stack-allocated!");  // Do this!
  v.push_back("This will be heap-allocated!");  // Don't do this!

  PmrStr s1("This will be stack-allocated!", &res);  // Do this!
  PmrStr s2("This will be heap-allocated!");  // Don't do this!
}

#endif

