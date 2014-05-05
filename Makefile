all: build
 
build:
	clang `xcode-select --print-path`/Toolchains/XcodeDefault.xctoolchain/usr/lib/libclang.dylib -rpath `xcode-select --print-path`/Toolchains/XcodeDefault.xctoolchain/usr/lib libclang.m -o clang-uml

install: build
	cp clang-uml /usr/local/bin/