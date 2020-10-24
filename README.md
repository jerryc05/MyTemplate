# MyTemplate

This is a personal template/starter-files/starter-repo for `C++` development.

Use at your **OWN** risk.

## Usage and Examples

### Table of Contents

- [First things first](#first-things-first)

- [High-level switches](#high-level-switches)

  - [Non-sanitizer flags](#non-sanitizer-flags)

  - [Sanitizer flags](#sanitizer-flags)

### First things first

1. Copy *everything* in file `CMakeLists.txt` after the line: `===== BEGIN OF CMAKE TEMPLATE =====` accordingly.

2. Copy *everything* in folder `cmake-args` (with the folder itself) accordingly.

### High-level switches

#### Non-sanitizer flags

- `__USE_ANALYZER__`: Use compiler-builtin static analyzer. `Default: OFF`.
  - Pros: Catch simple mistakes at compile time easily.
  - Cons: 
    - **SIGNIFICANTLY** slows down compilation time, 
    - Might not work for big projects. 

- `__USE_LATEST_CPP_STD__`: Compile with the latest `C++` std available. `Default: ON`.
  - Pros: Compile with the latest std automatically.
  - Cons: *Refer to incompatibilities between `C++` stds*

- `__REL_USE_HACKED_MATH__`: Compile with aggressive/hacky/dirty math optimizations on **RELEASE** mode. `Default: ON`.
  - Pros: Might speed up arithmetic calculation.
  - Cons: Might break IEEE 754 floating-point implementation std.

#### Sanitizer flags









