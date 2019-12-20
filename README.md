# CxxBuilder
This is an experimental repo for exploring how to upgrade Cxx.jl's building system to BinaryBuilder/BinaryProvider.

## Usage
Pre-built binaries can be found in the release page: https://github.com/Gnimuc/CxxBuilder/releases

### Build for Linux-x86_64(gcc7)
1. Edit build_tarballs.jl
2. Replace corresponding source URL=>SHA pairs with:
```
# julia binary
"https://github.com/Gnimuc/JuliaBuilder/releases/download/v1.3.0/julia-1.3.0-x86_64-linux-gnu.tar.gz" =>
"44099e27a3d9ebdaf9d67bfdaf745c3899654c24877c76cbeff9cade5ed79139",
# LLVM binary
"https://github.com/staticfloat/LLVMBuilder/releases/download/v6.0.1-7%2Bnowasm/LLVM.v6.0.1.x86_64-linux-gnu-gcc7.tar.gz" =>
"f2c335eb912720a5b3318f909eda1650973043beb033dfb3adc0f7d150b91bf6",
```
3. Run `julia --color=yes build_tarballs.jl --verbose --debug x86_64-linux-gnu-gcc7`

### Build for MacOS(gcc7)
1. Edit build_tarballs.jl
2. Replace corresponding source URL=>SHA pairs with:
```
# julia binary
"https://github.com/Gnimuc/JuliaBuilder/releases/download/v1.3.0/julia-1.3.0-x86_64-apple-darwin14.tar.gz" =>
"f2e5359f03314656c06e2a0a28a497f62e78f027dbe7f5155a5710b4914439b1",
# LLVM binary
"https://github.com/staticfloat/LLVMBuilder/releases/download/v6.0.1-7%2Bnowasm/LLVM.v6.0.1.x86_64-apple-darwin14-gcc7.tar.gz" =>
"801c50b0bf3a9cebb680257d4bf043c39bab5fb50ec13c1a5c36a4b69b8a6e8c",
```
3. Run `julia --color=yes build_tarballs.jl --verbose --debug x86_64-apple-darwin14-gcc7`

### Build for Windows-x86_64(gcc7)
1. Edit build_tarballs.jl
2. Replace corresponding source URL=>SHA pairs with:
```
# julia binary
"https://github.com/Gnimuc/JuliaBuilder/releases/download/v1.3.0/julia-1.3.0-x86_64-w64-mingw32.tar.gz" =>
"c7b2db68156150d0e882e98e39269301d7bf56660f4fc2e38ed2734a7a8d1551",
# LLVM binary
"https://github.com/staticfloat/LLVMBuilder/releases/download/v6.0.1-7%2Bnowasm/LLVM.v6.0.1.x86_64-w64-mingw32-gcc7.tar.gz" =>
"74811cb50b41ac40bc69548811063ae595ea5ec8f77108e9a2a2f7c22196376f",
```
3. Run `julia --color=yes build_tarballs.jl --verbose --debug x86_64-w64-mingw32-gcc7`
