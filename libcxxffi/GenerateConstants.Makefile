PRINT_PERL = echo '$(subst ','\'',$(1))'; $(1)

clang_constants.jl: cenumvals.jl.h
	@$(call PRINT_PERL, $(CPP) -E -Ijulia/src/support -Ijuliabin/include -DJULIA cenumvals.jl.h > $@)
