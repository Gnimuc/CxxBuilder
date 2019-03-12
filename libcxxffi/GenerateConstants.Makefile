JULIA_SRC := $(subst \,/,$(BASE_JULIA_SRC))
JULIA_BIN := $(subst \,/,$(BASE_JULIA_BIN))
LLVM_BIN := $(subst \,/,$(BASE_LLVM_BIN))

PRINT_PERL = echo '$(subst ','\'',$(1))'; $(1)

clang_constants.jl: cenumvals.jl.h
	@$(call PRINT_PERL, $(CPP) -E -Illvm-$(LLVM_VERSION).src/tools/clang -I$(LLVM_BIN)/include cenumvals.jl.h > $@)
