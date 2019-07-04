JULIA_SOURCE_INCLUDE_DIRS := $(JULIA_SOURCE_PREFIX)/src/support

JULIA_INCLUDE_DIRS := $(JULIA_BINARY_PREFIX)/include/julia
CLANG_SOURCE_INCLUDE_DIRS := /workspace/srcdir/llvm-6.0.1.src/tools/clang/include
CLANG_SOURCE_INCLUDE_DIRS += /workspace/srcdir/llvm-6.0.1.src/tools/clang/lib
CLANG_INCLUDE_DIRS := $(LLVMBUILDER_PREFIX)/include

JULIA_LIBS := $(JULIA_BINARY_PREFIX)/bin/libjulia.dll
LLVM_LIBS := $(JULIA_BINARY_PREFIX)/bin/LLVM.dll

JULIA_LIB_DIRS := $(JULIA_BINARY_PREFIX)/bin
JULIA_LIB_DIRS += $(JULIA_BINARY_PREFIX)/lib
JULIA_LIB_DIRS += $(JULIA_BINARY_PREFIX)/lib/julia
CLANG_LIB_DIRS := $(LLVMBUILDER_PREFIX)/lib $(LLVMBUILDER_PREFIX)/bin

LIB_DIRS := $(JULIA_LIB_DIRS) $(CLANG_LIB_DIRS) $(WORKSPACE)/destdir/lib $(WORKSPACE)/destdir/bin
LIBS = $(addprefix -L,$(LIB_DIRS))

CLANG_LIBS := clangFrontendTool clangBasic clangLex clangDriver clangFrontend clangParse
CLANG_LIBS += clangAST clangASTMatchers clangSema clangAnalysis clangEdit
CLANG_LIBS += clangRewriteFrontend clangRewrite clangSerialization clangStaticAnalyzerCheckers
CLANG_LIBS += clangStaticAnalyzerCore clangStaticAnalyzerFrontend clangTooling clangToolingCore
CLANG_LIBS += clangCodeGen clangARCMigrate clangFormat
LINKED_LIBS = $(addprefix -l,$(CLANG_LIBS))

INCLUDE_DIRS := $(JULIA_SOURCE_INCLUDE_DIRS) $(JULIA_INCLUDE_DIRS) $(CLANG_SOURCE_INCLUDE_DIRS) $(CLANG_INCLUDE_DIRS) $(WORKSPACE)/destdir/include
INCLUDES = $(addprefix -I,$(INCLUDE_DIRS))

DEFS := -DLLVM_NDEBUG -DLIBRARY_EXPORTS
FLAGS = -std=c++11 -fno-rtti -fPIC -O0 -g

all: build/libcxxffi.dll

build:
	@mkdir -p $(CURDIR)/build

build/bootstrap.o: bootstrap.cpp | build
	$(CXX) $(DEFS) $(FLAGS) $(INCLUDES) -c bootstrap.cpp -o $@

build/libcxxffi.dll: build/bootstrap.o | build
	$(CXX) -shared -fPIC $(LIBS) -o $@ -ljulia -lLLVM -Wl,--export-all-symbols -lclang -Wl,--whole-archive $(LINKED_LIBS) -Wl,--no-whole-archive $< -llibdl -lversion -Wl,-no-undefined -Wl,--enable-runtime-pseudo-reloc

destdir/bin:
	@mkdir -p /workspace/destdir/bin
