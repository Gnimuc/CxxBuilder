# CxxBuilder
This is an experimental repo for exploring how to upgrade Cxx.jl's building system to BinaryBuilder/BinaryProvider.

## Usage
Pre-built binaries can be found in the release page: https://github.com/Gnimuc/CxxBuilder/releases

### Build for Linux-x86_64  
1. Download Julia-v1.1 binary: https://julialang-s3.julialang.org/bin/linux/x64/1.1/julia-1.1.0-linux-x86_64.tar.gz
2. Unzip downloaded tarball, create a directory called `JuliaBinary` and move unzipped contents into it
3. Download Julia-v1.1 source: https://github.com/JuliaLang/julia/releases/download/v1.1.0/julia-1.1.0.tar.gz
4. Unzip downloaded tarball, create a directory called `JuliaSource` and move unzipped contents into it
5. Download LLVM binary: https://github.com/staticfloat/LLVMBuilder/releases/download/v6.0.1-4%2Bnowasm/LLVM.v6.0.1.x86_64-linux-gnu-gcc7.tar.gz
6. Create a directory called `LLVM` and move downloaded tarball into it
7. Now, the file hierarchy should look like this:
```
CxxBuilder +
           | libcxxffi
           | patches
           | build_tarballs.jl
           | README.md
           + JuliaBinary +
                         | juliabin +
                                    | bin
                                    | etc
                                    | include
                                    | lib
                                    | ...
           + JuliaSource +
                         | julia +
                                 | base
                                 | contrib
                                 | deps
                                 | doc
                                 | etc
                                 | ...
           + LLVM +
                  | LLVM.v6.0.1.x86_64-linux-gnu-gcc7.tar.gz
```
8. Uncomment the line `# BinaryProvider.Linux(:x86_64; libc=:glibc, compiler_abi=CompilerABI(:gcc7)),` in `build_tarballs.jl`
9. Run `julia --color=yes build_tarballs.jl --verbose`
10. Find the binary in the `products` folder

### Build for MacOS
1. Download Julia-v1.1 binary: https://julialang-s3.julialang.org/bin/mac/x64/1.1/julia-1.1.0-mac64.dmg
2. Open the dmg image, right-click Julia-1.1.app, click `Show Package Contents`⁩, copy `⁨Contents⁩/⁨Resources/julia`⁩ to a new directory called `JuliaBinary`
3. Download Julia-v1.1 source: https://github.com/JuliaLang/julia/releases/download/v1.1.0/julia-1.1.0.tar.gz
4. Unzip downloaded tarball, create a directory called `JuliaSource` and move unzipped contents into it
5. Download LLVM binary: https://github.com/staticfloat/LLVMBuilder/releases/download/v6.0.1-4%2Bnowasm/LLVM.v6.0.1.x86_64-apple-darwin14-gcc7.tar.gz
6. Create a directory called `LLVM` and move downloaded tarball into it
7. Now, the file hierarchy should look like this:
```
CxxBuilder +
           | libcxxffi
           | patches
           | build_tarballs.jl
           | README.md
           + JuliaBinary +
                         | juliabin +
                                    | bin
                                    | etc
                                    | include
                                    | lib
                                    | ...
           + JuliaSource +
                         | julia +
                                 | base
                                 | contrib
                                 | deps
                                 | doc
                                 | etc
                                 | ...
           + LLVM +
                  | LLVM.v6.0.1.x86_64-apple-darwin14-gcc7.tar.gz
```
8. Uncomment the line `# BinaryProvider.MacOS(:x86_64; libc=:glibc, compiler_abi=CompilerABI(:gcc7)),` in `build_tarballs.jl`
9. Run `julia --color=yes build_tarballs.jl --verbose`
10. Find the binary in the `products` folder

### Build for Windows-x86_64
1. Download Julia-v1.1 binary: https://julialang-s3.julialang.org/bin/winnt/x64/1.1/julia-1.1.1-win64.exe
2. Install it on a Windows machine, move those installed files into a folder called `juliabin`⁩, create a new directory called `JuliaBinary` on your Linux machine that runs BB2 and move `juliabin`⁩ into it
3. Download Julia-v1.1 source: https://github.com/JuliaLang/julia/releases/download/v1.1.0/julia-1.1.0.tar.gz
4. Unzip downloaded tarball, create a directory called `JuliaSource` and move unzipped contents into it
5. Download LLVM binary: https://github.com/staticfloat/LLVMBuilder/releases/download/v6.0.1-4%2Bnowasm/LLVM.v6.0.1.x86_64-w64-mingw32-gcc7.tar.gz
6. Create a directory called `LLVM` and move downloaded tarball into it
7. Download dlfcn-win32 v1.2.0 source code from https://github.com/dlfcn-win32/dlfcn-win32/archive/v1.2.0.zip
8. Unzip downloaded tarball, create a directory called `dlfcn` and move unzipped code into it
9. Now, the file hierarchy should look like this:
```
CxxBuilder +
           | libcxxffi
           | patches
           | build_tarballs.jl
           | README.md
           + dlfcn +
                   | dlfcn-win32 +
                                 | cmake-test
                                 | visual-studio
                                 | CMakeLists.txt
                                 | ...
           + JuliaBinary +
                         | juliabin +
                                    | bin
                                    | etc
                                    | include
                                    | lib
                                    | ...
           + JuliaSource +
                         | julia +
                                 | base
                                 | contrib
                                 | deps
                                 | doc
                                 | etc
                                 | ...
           + LLVM +
                  | LLVM.v6.0.1.x86_64-w64-mingw32-gcc7.tar.gz
```
10. Uncomment the line `# BinaryProvider.Windows(:x86_64; compiler_abi=CompilerABI(:gcc7)),` in `build_tarballs.jl`
11. Run `julia --color=yes build_tarballs.jl --verbose`
12. Find the binary in the `products` folder
