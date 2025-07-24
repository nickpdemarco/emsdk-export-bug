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

This should yield:

```
node main.js
//this-repo/main.js:4572
  function __ZN102_$LT$std..panicking..begin_panic_handler..FormatStringPayload$u20$as$u20$core..panic..PanicPayload$GT$3get17hecee4b43e7ecbd58E(...args
                          ^

SyntaxError: Unexpected token '.'
    at wrapSafe (node:internal/modules/cjs/loader:1281:20)
    at Module._compile (node:internal/modules/cjs/loader:1321:27)
    at Module._extensions..js (node:internal/modules/cjs/loader:1416:10)
    at Module.load (node:internal/modules/cjs/loader:1208:32)
    at Module._load (node:internal/modules/cjs/loader:1024:12)
    at Function.executeUserEntryPoint [as runMain] (node:internal/modules/run_main:174:12)
    at node:internal/main/run_main_module:28:49

Node.js v20.15.1
make: *** [test] Error 1
```
