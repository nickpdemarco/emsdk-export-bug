RUST_LIB = target/wasm32-unknown-emscripten/debug/rust_lib.wasm
OUTPUT = main.js

all: $(OUTPUT)

$(RUST_LIB): src/lib.rs Cargo.toml
	RUSTFLAGS="-C link-arg=--no-entry -C link-arg=-sSIDE_MODULE=1" cargo build --target wasm32-unknown-emscripten

$(OUTPUT): main.cpp $(RUST_LIB)
	em++ -s MAIN_MODULE=1 -o $(OUTPUT) main.cpp $(RUST_LIB)

test: $(OUTPUT)
	node $(OUTPUT)

clean:
	cargo clean
	rm -f $(OUTPUT) main.wasm

.PHONY: all test clean
