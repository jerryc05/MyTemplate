/*
 * Copyright (c) 2019-2020 Ziyan "Jerry" Chen (@jerryc05).
 *                         All rights reserved.
 */

#pragma once

#if !defined(DEBUG_MODE) && !defined(NDEBUG)
#   define NDEBUG
#endif
#ifdef NDEBUG
#   undef DEBUG_MODE
#endif



// Annotations
#if (__GNUC__ >= 6) || (__clang_major__ >= 6)
#   define MAYBE_UNUSED [[maybe_unused]]
#   define NODISCARD    [[nodiscard]]
#   define NOEXCEPT     noexcept
#   define NORETURN     [[noreturn]]
#else
#   define MAYBE_UNUSED
#   define NODISCARD
#   define NOEXCEPT
#   define NORETURN
#endif




// Asserts & Casts
#define ccast    const_cast
#define dcast    dynamic_cast
#define rcast    reinterpret_cast
#define scast    static_cast
#define sassert  static_assert

#ifndef NDEBUG
#   define ASSERT_3(cond, msg, os) \
      do {  if (!(cond)) { \
              (os) << __FILE__ << ':' << __LINE__ << '\t' \
                   << "Assertion `" #cond "` failed: " << (msg) << std::endl; \
              exit(1); } \
      } while (false)
#else
#   define ASSERT_3(cond, msg, os) do {} while (false)
#endif

#define ASSERT_2(cond, msg)                   ASSERT_3(cond, msg, std::cerr)
#define ASSERT_1(cond)                        ASSERT_2(cond, "")

#define ASSERT_N(_, cond, msg, os, func, ...) func

#define ASSERT(...)                           ASSERT_N(,##__VA_ARGS__,\
                                                ASSERT_3(__VA_ARGS__),\
                                                ASSERT_2(__VA_ARGS__),\
                                                ASSERT_1(__VA_ARGS__),\
                                                ASSERT_0(__VA_ARGS__)\
                                              )




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
#if (__GNUC__ >= 7) || (__clang_major__ * 10 + __clang_minor__ >= 39)
#   include <optional>
#   include <string_view>
#   include <variant>
template<typename T>
using Optional MAYBE_UNUSED = std::optional<T>;
template<typename T=char>
using Str MAYBE_UNUSED = std::basic_string_view<T, std::char_traits<T>>;
sassert(std::is_same<Str<>, std::string_view>::value);
template<typename... Ts>
using Variant MAYBE_UNUSED = std::variant<Ts...>;

#   if (__GNUC__ * 10 + __GNUC_MINOR__ > 47) || (__clang_major__ * 10 + __clang_minor__ >= 34)
#       include <functional>
template<typename T>
using Fn = std::function<T>;
#   endif

#endif

// Keywords
#if __GNUC__ || __clang_major__ || _MSC_VER
#   if __GNUC__ || __clang_major__
#       define CONST_ATTRIB __attribute__((const))
#       define F_INLINE     __attribute__((always_inline))
#       define NOINLINE     __attribute__((noinline))
#       define PURE_ATTRIB  __attribute__((pure))
#   else
#       define CONST_ATTRIB
#       define F_INLINE     __forceinline
#       define NOINLINE     __declspec(noinline)
#       define PURE_ATTRIB
#   endif
#   define RESTRICT         __restrict

#else
#   define CONST_ATTRIB
#   define F_INLINE         inline
#   define NOINLINE
#   define RESTRICT
#   define PURE_ATTRIB
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
sassert(std::is_same<HashMap<int, char>, std::unordered_map<int, char>>::value);
template<typename T1, typename T2>
using Pair MAYBE_UNUSED = std::pair<T1, T2>;
using PcwsCstrt = std::piecewise_construct_t;
constexpr const static PcwsCstrt &pcwsCstrt MAYBE_UNUSED = std::piecewise_construct;
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
sassert(std::is_same<TreeMap<int, char>, std::map<int, char>>::value);
template<typename... Ts>
using Tuple MAYBE_UNUSED = std::tuple<Ts...>;
template<typename T, typename Alloc = std::allocator<T>>
using Vec MAYBE_UNUSED = std::vector<T, Alloc>;
sassert(std::is_same<Vec<int>, std::vector<int>>::value);



template<typename Char>
MAYBE_UNUSED F_INLINE void
skipCurrentLine(
        std::basic_istream<Char> &is,
        typename std::basic_istream<Char>::int_type delim = '\n',
        std::streamsize maxLen = std::numeric_limits<std::streamsize>::max()) {
  is.ignore(maxLen, delim);
}

template<typename T>
MAYBE_UNUSED F_INLINE Arr<Byte, sizeof(T)>
allocUninit() {
  Arr<Byte, sizeof(T)> arr;
  return arr;
}

template<typename T, typename... Args>
MAYBE_UNUSED F_INLINE T *
initInPlace(void * RESTRICT addr, Args &&... args) {
  return new(addr) T(args ...);
}

MAYBE_UNUSED void
lateInitExample() {
  using T = Vec<int>;
  auto rawBytesOfT = allocUninit<T>();

  // do anything here

  // do NOT use reference if you want the compiler to destruct `T`
  auto useThisAsT = *initInPlace<T>(
          &rawBytesOfT, std::initializer_list<T::value_type>{1, 2, 3});
  sassert(std::is_same<decltype(useThisAsT), T>::value);

  // do use reference if you want destruct `T` manually
  auto &useThisAsTRef = *initInPlace<T>(
          &rawBytesOfT, std::initializer_list<T::value_type>{1, 2, 3});
  sassert(std::is_same<decltype(useThisAsTRef), T&>::value);

  // do anything here

  // you must manually destruct `T` reference
  useThisAsTRef.~T();

  // `useThisAsT` automatically destructed here
}



// Memory Resource
#if (__GNUC__ >= 9) || (__clang_major__ >= 9)
#   include <memory_resource>
using MonoBufRes = std::pmr::monotonic_buffer_resource;
template<typename T>
using PmrAlloc = std::pmr::polymorphic_allocator<T>;


class MyNewDelResExample : public std::pmr::memory_resource {
private:
  void *do_allocate(Usize size, Usize alignment) override;

  void do_deallocate(void *ptr, Usize size, Usize alignment) override;

  NODISCARD bool do_is_equal(const std::pmr::memory_resource &other) const NOEXCEPT override;
};

void *
MyNewDelResExample::do_allocate(Usize size, Usize alignment) {
  std::cout << "Al  locating " << size << '\n';
  return std::pmr::new_delete_resource()->allocate(size, alignment);
}

void
MyNewDelResExample::do_deallocate(void *ptr, Usize size, Usize alignment) {
  std::cout << "Deallocating " << size << ": [";

  auto       charPtr = rcast<char *>(ptr);
  for (Usize i       = 0; i < size; ++i) {
    std::cout << charPtr[i];
  }
  std::cout << "]\n";

  return std::pmr::new_delete_resource()->deallocate(ptr, size, alignment);
}

NODISCARD bool
MyNewDelResExample::do_is_equal(const std::pmr::memory_resource &other) const NOEXCEPT {
  return std::pmr::new_delete_resource()->is_equal(other);
}


template<Usize capacity>
MAYBE_UNUSED void
pmrContainerExample() {
  MyNewDelResExample mem;
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
