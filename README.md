# CxxBuilder
This is an experimental repo for exploring how to upgrade Cxx.jl's building system to BinaryBuilder/BinaryProvider.

## Usage
Pre-built binaries can be found in the release page: https://github.com/Gnimuc/CxxBuilder/releases

### Build for Linux-x86_64(gcc7)
1. Edit build_tarballs.jl
2. Replace corresponding source URL=>SHA pairs with:
```
# julia binary
"https://github.com/Gnimuc/JuliaBuilder/releases/download/v1.1.1/julia-1.1.1-x86_64-linux-gnu-gcc7.tar.gz" =>
"???",
# LLVM binary
"https://github.com/staticfloat/LLVMBuilder/releases/download/v6.0.1-5%2Bnowasm/LLVM.v6.0.1.x86_64-linux-gnu-gcc7.tar.gz" =>
"6fca2fedc5ae4ead8b2fd62d863e2a556075d4d7de8b8c66cc8feeea6dc33851",
```
3. Run `julia --color=yes build_tarballs.jl --verbose --debug x86_64-linux-gnu-gcc7`

### Build for MacOS(gcc7)
1. Edit build_tarballs.jl
2. Replace corresponding source URL=>SHA pairs with:
```
# julia binary
"https://github.com/Gnimuc/JuliaBuilder/releases/download/v1.1.1/julia-1.1.1-x86_64-apple-darwin14.tar.gz" =>
"c41d6535bc57bb0f96f69b3c44fdc169ec98dd780f8845f65a4d0bb65a4900ee",
# LLVM binary
"https://github.com/staticfloat/LLVMBuilder/releases/download/v6.0.1-5%2Bnowasm/LLVM.v6.0.1.x86_64-apple-darwin14-gcc7.tar.gz" =>
"12ea772128b9f9306188fd9933ad5c26a247e598578fffd6487d6dc4eb417ec8",
```
3. Run `julia --color=yes build_tarballs.jl --verbose --debug x86_64-apple-darwin14-gcc7`

### Build for Windows-x86_64(gcc7)
1. Edit build_tarballs.jl
2. Replace corresponding source URL=>SHA pairs with:
```
# julia binary
"https://github.com/Gnimuc/JuliaBuilder/releases/download/v1.1.1/julia-1.1.1-x86_64-w64-mingw32.tar.gz" =>
"9446377e8fd7b143f2ed1ea7ec6470d25e463b89828b728b226d9e221e5506a5",
# LLVM binary
"https://github.com/staticfloat/LLVMBuilder/releases/download/v6.0.1-5%2Bnowasm/LLVM.v6.0.1.x86_64-w64-mingw32-gcc7.tar.gz" =>
"998a1932884121f15d7d5b2e75fb977695a4d448dd3888c10a18aafa83faf8c9",
```
3. Run `julia --color=yes build_tarballs.jl --verbose --debug x86_64-w64-mingw32-gcc7`
