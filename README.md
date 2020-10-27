# MyTemplate

This is a personal template/starter-files/starter-repo for `C++` development.

Use at your **OWN** risk.

## Table of Contents


1. [First things first](#first-things-first)
2. [Recommended tools](#recommended-tools)
    - [Ccache](#ccache)
    - [Ninja](#ninja)
    - [LLVM Clang](#llvm-clang)
    - [Clang-Tidy](#clang-tidy)
3. [High-level switches](#high-level-switches)
    - [Non-sanitizer flags](#non-sanitizer-flags)
    - [Sanitizer flags](#sanitizer-flags)
        - [Address sanitizer]()
        - [Memory sanitizer]()
        - [Thread sanitizer]()
4. [Misc](#misc)
    - [Why I dropped MSAN](#why-i-dropped-msan)
    - [Sanitizer vs Valgrind](#sanitizer-vs-valgrind)


## First things first

1. Copy *everything* in file `CMakeLists.txt` between the line: `===== BEGIN OF CMAKE ARGS TEMPLATE =====` and the line `===== BEGIN OF TARGET CREATION =====` accordingly.

2. Copy *everything* in folder `cmake-args` (including the folder itself) accordingly.

3. Make sure all target creation commands (e.g. `add_executable()`) are below the line: `===== BEGIN OF TARGET CREATION =====`.

## Recommended tools

### [Ccache](https://ccache.dev/)

#### Download & Install

- [Windows](https://ccache.dev/download.html)
- MacOS(brew): `brew install ccache`
- Linux(apt): `apt install ccache`

#### How to enable **Ccache**

- *No action needed if you followed [First things first](#first-things-first).*


### [Ninja](https://ninja-build.org/)

#### Download & Install

- MacOS(brew): `brew install ninja`
- Linux(apt): `apt install ninja-build`
- [Other pre-built packages](https://github.com/ninja-build/ninja/wiki/Pre-built-Ninja-packages)
- [Zipped binary](https://github.com/ninja-build/ninja/releases)

#### How to enable **Ninja**

- *CLion*:
    - Settings/Preferences
    - Build, Execution, Deployment
    - CMake
    - Profiles (right panel)
    - Append `-GNinja` to CMake options of every profile (notice spaces between args)


### [LLVM Clang](https://llvm.org/)

*Pro tip:* LLVM Clang is different from Apple Clang (comes with XCode in MacOS) in many ways (e.g. Apple Clang lacks sanitizers).

#### Download & Install

- MacOS(brew): `brew install llvm`
- Linux(apt): `apt install clang`
- [Zipped binary](https://releases.llvm.org/download.html)

#### How to enable **Clang**

- *CLion*:
    - Follow [this link](https://www.jetbrains.com/help/clion/how-to-create-toolchain-in-clion.html)
    - *Pro tip*: You might want to set **C/C++ Compiler** to `clang/clang++` respectively to use Clang.
    - *Pro tip*: Make sure you are using Clang from **LLVM**, not **Apple**. 
    - *Pro tip*: If you followed [First things first](#first-things-first), CMake will print `USING COMPILER [<compiler_name>]` to stdout.


### [Clang-Tidy](https://clang.llvm.org/extra/clang-tidy/)

#### Download & Install

- Linux(apt): `apt install clang-tidy`

*Pro tip*: Clang-tidy usually comes with Clang altogether and no additional installation is required.

#### How to enable **Clang-Tidy**

- *No action needed if you followed [First things first](#first-things-first).*


## High-level switches

### Non-sanitizer flags

- `__USE_ANALYZER__`: Use compiler-builtin static analyzer. 
    - `Default: OFF`.
	- Pros: 
	    - Catch known mistakes at compile time.
	    - Warns about bad practices/styles. \[Clang-Tidy only\]
	- Cons:
  	    - **SIGNIFICANTLY** slows down compilation time,
        - Might not work for big projects.

- `__USE_LATEST_CPP_STD__`: Compile with the latest `C++` std available. 
    - `Default: ON`.
    - Pros: Compile with the latest std automatically.
    - Cons: *Refer to incompatibilities between `C++` stds*

- `__REL_USE_HACKED_MATH__`: Compile with aggressive/hacky/dirty math optimizations in **RELEASE** mode. 
    - `Default: ON`.
    - Pros: Might speed up arithmetic calculation.
    - Cons: Might break IEEE 754 floating-point implementation std.

### Sanitizer flags

*Pro tip*: Sanitizers will be effective in **DEBUG** mode only.

- `__DBG_SANITIZE_ADDR__`: Compile with **Address Sanitizer**. 
    - `Default: ON`.
    - Pros:
        - Catch memory errors in runtime without sacrificing much performance.
        - Works with IDE debuggers.
    - Cons:
        - Not compatible with `Valgrind`.
        - Not compatible with either `Memory` or `Thread` sanitizer.


- ~~`__DBG_SANITIZE_MEMORY__`: Compile with **Memory Sanitizer**.~~ 
    - `Default: OFF | Support: DROPPED`.
    - Pros:
        - Catch uninitialized memory reads in runtime without sacrificing much performance.
        - Works with IDE debuggers.
    - Cons:
        - Not compatible with `Valgrind`.
        - Not compatible with either `Memory` or `Thread` sanitizer.
        - Only supported on `Linux` and `*BSD`.
        - Produces false positives if **ANY** part of the code isn't built with `MSAN` (e.g. `C++ Std Lib`).


- `__DBG_SANITIZE_THRD__`: Compile with **Thread Sanitizer**. 
    - `Default: OFF | Support: WIP`.
    - Pros:
        - Catch data races in runtime without sacrificing much performance.
        - Works with IDE debuggers.
    - Cons:
        - Not compatible with `Valgrind`.
        - Not compatible with either `Address` or `Memory` sanitizer.




<!-- todo

__DBG_SANITIZE_LEAK_STANDALONE__
__DBG_SANITIZE_UB__

-->

## Misc

### Why I dropped MSAN

See:
-   [Handling external code](https://clang.llvm.org/docs/MemorySanitizer.html#id10).
-   [Using instrumented libraries](https://github.com/google/sanitizers/wiki/MemorySanitizer#using-instrumented-libraries).


### Sanitizer vs Valgrind

Reference: [Memory/Address Sanitizer vs Valgrind](https://stackoverflow.com/questions/47251533/memory-address-sanitizer-vs-valgrind)

#### Sanitizer

- Much faster.
- Much smaller memory overhead.
- Can detect more errors (e.g. non-heap overflows)
- Works with IDE debuggers.

#### Valgrind

- Detects most of ASAN & MSAN & TSAN at the same time.


### Common FAQ

#### 1. Misuse with Valgrind:
Q: When I run Valgrind, I am stuck at something like ` Warning: set address range perms: ...`.

A: Kill Valgrind (or memcheck) immediately , or Valgrind will use up all system resources and run forever.

A: A useful command for `*ix` systems is: `ps | grep -F valgrind | grep -v grep | awk '{print "kill -9 " $1}'`. You need to pipe its output to `sh`.

A: Sanitizers (except UBSAN) are incompatible with Valgrind.

#### 2. Leak check option in ASAN:
Q: ASAN/LSAN does not catch memory leak on MacOS.

A: You have 2 options:
- \[RECOMMENDED\] Follow ASAN runtime flags settings above.
- \[NOT RECOMMENDED\] Disable ASAN and run with LSAN instead (other ASAN checks will also be disabled).
