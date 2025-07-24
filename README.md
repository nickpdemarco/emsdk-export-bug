# emsdk-rust-dylib-bug Minimal Example

This is a minimal example demonstrating the interaction between Rust cdylib and C++ when targeting WebAssembly/Emscripten.

## Structure

- `main.cpp` - C++ main function that calls exported Rust functions
- `src/lib.rs` - Rust library that exports C-compatible functions, including one that panics
- `Cargo.toml` - Rust crate configuration for cdylib output
- `Makefile` - Build orchestration using Emscripten toolchain

## Requirements

- Rust with `wasm32-unknown-emscripten` target installed
- Emscripten SDK (emsdk) activated
- Node.js for running the generated JavaScript

## Setup

Install the required Rust target:
```bash
rustup target add wasm32-unknown-emscripten
```

Make sure emsdk is activated in your shell.

## Building

```bash
make all
```

This will:
1. Build the Rust library targeting wasm32-unknown-emscripten
2. Compile main.cpp with em++
3. Link them together into `main.js`

## Running

```bash
make test
```

Or manually:
```bash
node main.js
```

## The Bug Demonstrated

This example demonstrates a specific issue with `cdylib` compilation for the `wasm32-unknown-emscripten` target:

### Issue 1: cdylib fails to compile
When building a Rust `cdylib` for `wasm32-unknown-emscripten`, the build fails with:
```
wasm-ld: error: ... undefined symbol: main
```

This occurs because Emscripten expects a standalone executable but we're trying to create a library.

### Issue 2: Missing Rust Standard Library Symbols
Even when we extract the individual object files and try to link them manually with C++, we get undefined symbol errors for Rust standard library functions:

- `std::io::stdio::_print::h8e461f7443ba4911` (println! macro)
- `core::panicking::panic_cannot_unwind::h7720a7e27993209d` (panic handling)
- `core::ffi::c_str::CStr::to_str::hd65a8640f2e814a1` (C string conversion)
- `core::panicking::panic_fmt::h51f7a7a0a47b752b` (panic formatting)

These symbols would normally be included when linking the complete Rust standard library, but are missing when trying to create a `cdylib` for WebAssembly/Emscripten.

## Reproducing the Bug

```bash
make test
```

This will:
1. Attempt to build the Rust `cdylib` (fails as expected)
2. Extract the generated object files
3. Try to link them with C++ code (fails with missing symbols)

## Expected vs Actual Behavior

**Expected**: The `cdylib` should compile successfully and be linkable with C++ code, including all necessary Rust standard library symbols for panic handling and I/O.

**Actual**: The compilation fails, and even manual linking of object files results in missing standard library symbols.

## Summary

This minimal example successfully reproduces the emsdk-rust-dylib bug where:

1. **`cdylib` compilation fails** for `wasm32-unknown-emscripten` target due to missing `main` symbol
2. **Manual object file linking fails** due to missing Rust standard library symbols
3. **Panic-related symbols are missing** which prevents proper error handling in the linked code

The bug prevents the normal workflow of creating a Rust dynamic library that can be consumed by C++/Emscripten projects, forcing developers to use workarounds or alternative approaches.

## Files Generated

- Individual Rust object files in `target/wasm32-unknown-emscripten/debug/deps/`
- Error logs showing the missing symbols
- No successful final executable due to the bug
