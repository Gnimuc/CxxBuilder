# copied and tweaked from https://github.com/staticfloat/LLVMBuilder
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
using BinaryBuilder

# Collection of sources required to build LLVM
llvm_ver = "6.0.1"
sources = [
    "http://releases.llvm.org/$(llvm_ver)/llvm-$(llvm_ver).src.tar.xz" =>
    "b6d6c324f9c71494c0ccaf3dac1f16236d970002b42bb24a6c9e1634f7d0f4e2",
    "http://releases.llvm.org/$(llvm_ver)/cfe-$(llvm_ver).src.tar.xz" =>
    "7c243f1485bddfdfedada3cd402ff4792ea82362ff91fbdac2dae67c6026b667",
    "http://releases.llvm.org/$(llvm_ver)/compiler-rt-$(llvm_ver).src.tar.xz" =>
    "f4cd1e15e7d5cb708f9931d4844524e4904867240c306b06a4287b22ac1c99b9",
    "http://releases.llvm.org/$(llvm_ver)/libcxx-$(llvm_ver).src.tar.xz" =>
    "7654fbc810a03860e6f01a54c2297a0b9efb04c0b9aa0409251d9bdb3726fc67",
    "http://releases.llvm.org/$(llvm_ver)/libcxxabi-$(llvm_ver).src.tar.xz" =>
    "209f2ec244a8945c891f722e9eda7c54a5a7048401abd62c62199f3064db385f",
    "http://releases.llvm.org/$(llvm_ver)/polly-$(llvm_ver).src.tar.xz" =>
    "e7765fdf6c8c102b9996dbb46e8b3abc41396032ae2315550610cf5a1ecf4ecc",
    "http://releases.llvm.org/$(llvm_ver)/libunwind-$(llvm_ver).src.tar.xz" =>
    "a8186c76a16298a0b7b051004d0162032b9b111b857fbd939d71b0930fd91b96",
    "http://releases.llvm.org/$(llvm_ver)/lld-$(llvm_ver).src.tar.xz" =>
    "e706745806921cea5c45700e13ebe16d834b5e3c0b7ad83bf6da1f28b0634e11",
    "patches",
	# julia source
    "https://github.com/JuliaLang/julia/releases/download/v1.3.0/julia-1.3.0.tar.gz" =>
	"5e1bfa62b99921ec8f437a31e834802d8d357ab679611ed336bd6e214ea0ce75",
	# dlfcn-win32 source
    "https://github.com/dlfcn-win32/dlfcn-win32/archive/v1.2.0.tar.gz" =>
	"f18a412e84d8b701e61a78252411fe8c72587f52417c1ef21ca93604de1b9c55",
    # libcxxffi source
	"libcxxffi",
	"https://github.com/Gnimuc/JuliaBuilder/releases/download/v1.3.0/julia-1.3.0-x86_64-linux-gnu.tar.gz" =>
	"44099e27a3d9ebdaf9d67bfdaf745c3899654c24877c76cbeff9cade5ed79139",
    # LLVM binary
	"https://github.com/staticfloat/LLVMBuilder/releases/download/v6.0.1-7%2Bnowasm/LLVM.v6.0.1.x86_64-linux-gnu-gcc7.tar.gz" =>
	"f2c335eb912720a5b3318f909eda1650973043beb033dfb3adc0f7d150b91bf6",
]

# Since we kind of do this LLVM setup twice, this is the shared setup start:
script_setup = raw"""
# We want to exit the program if errors occur.
set -o errexit

cd $WORKSPACE/srcdir/

# First, move our other projects into llvm/projects
for f in *.src; do
    # Don't symlink llvm itself into llvm/projects...
    if [[ ${f} == llvm-*.src ]]; then
        continue
    fi

    # clang lives in tools/clang and not projects/cfe
    if [[ ${f} == cfe-*.src ]]; then
        mv $(pwd)/${f} $(echo llvm-*.src)/tools/clang
    elif [[ ${f} == polly-*.src ]]; then
        mv $(pwd)/${f} $(echo llvm-*.src)/tools/polly
    elif [[ ${f} == lld-*.src ]]; then
        mv $(pwd)/${f} $(echo llvm-*.src)/tools/lld
    else
        mv $(pwd)/${f} $(echo llvm-*.src)/projects/${f%-*}
    fi
done

# Next, boogie on down to llvm town
cd llvm-*.src

# Update config.guess/config.sub stuff
# update_configure_scripts

# Apply all our patches
for f in $WORKSPACE/srcdir/llvm_patches/*.patch; do
    echo "Applying patch ${f}"
    patch -p1 < ${f}
done
"""

# Next, build libcxxffi
script = script_setup * raw"""
# build libcxxffi
cd $WORKSPACE/srcdir/

if [[ ${target} == *mingw32* ]]; then
    cd $WORKSPACE/srcdir/dlfcn-win32-1.2.0
    mkdir build && cd build
    cmake .. -DCMAKE_INSTALL_PREFIX=$prefix -DCMAKE_TOOLCHAIN_FILE=$CMAKE_TARGET_TOOLCHAIN
    make -j${nproc} VERBOSE=1
    make install VERBOSE=1
fi

# use CMake on all platforms except Windows
if [[ "${target}" == *linux* ]] || [[ "${target}" == *apple* ]] || [[ "${target}" == *freebsd* ]]; then
	mkdir build && cd build
	CMAKE_FLAGS="-DCMAKE_INSTALL_PREFIX=$prefix -DCMAKE_TOOLCHAIN_FILE=$CMAKE_TARGET_TOOLCHAIN"
	CMAKE_FLAGS="${CMAKE_FLAGS} -DJULIA_SOURCE_PREFIX=$WORKSPACE/srcdir/julia-1.3.0"
	CMAKE_FLAGS="${CMAKE_FLAGS} -DJULIA_BINARY_PREFIX=$WORKSPACE/srcdir/juliabin"
	CMAKE_FLAGS="${CMAKE_FLAGS} -DLLVMBUILDER_PREFIX=$WORKSPACE/srcdir"
	cmake .. ${CMAKE_FLAGS}
	make -j${nproc} VERBOSE=1
	make install VERBOSE=1
fi

# use Make on Windows
if [[ ${target} == *mingw32* ]]; then
    cd $WORKSPACE/srcdir/
    make -j${nproc} VERBOSE=1 -f Windows.Makefile JULIA_SOURCE_PREFIX=$WORKSPACE/srcdir/julia-1.3.0 JULIA_BINARY_PREFIX=$WORKSPACE/srcdir/juliabin LLVMBUILDER_PREFIX=$WORKSPACE/srcdir
    cp -r ./build/* /workspace/destdir/bin/
fi

# copy LLVM/Clang assets
mkdir -p ${prefix}/src/clang-6.0.1/include
mkdir -p ${prefix}/src/llvm-6.0.1/include
mkdir -p ${prefix}/build/clang-6.0.1/lib/clang/6.0.1/include
mkdir -p ${prefix}/build/clang-6.0.1/include
mkdir -p ${prefix}/build/llvm-6.0.1/include
cp -r $WORKSPACE/srcdir/llvm-6.0.1.src/tools/clang/include/* ${prefix}/src/clang-6.0.1/include/
cp -r $WORKSPACE/srcdir/llvm-6.0.1.src/include/* ${prefix}/src/llvm-6.0.1/include/
cp -r $WORKSPACE/srcdir/include/* ${prefix}/build/llvm-6.0.1/include/
cp -r $WORKSPACE/srcdir/lib/* ${prefix}/lib/
cp -r $WORKSPACE/srcdir/lib/clang/6.0.1/include/* ${prefix}/build/clang-6.0.1/lib/clang/6.0.1/include/
cp -r ${prefix}/build/llvm-6.0.1/include/* ${prefix}/build/clang-6.0.1/include/

# generate clang_constants.jl
cd $WORKSPACE/srcdir
make -f GenerateConstants.Makefile BASE_LLVM_BIN=$WORKSPACE/srcdir BASE_JULIA_BIN=$WORKSPACE/srcdir/juliabin BASE_JULIA_SRC=$WORKSPACE/srcdir/julia LLVM_VERSION=6.0.1
cp $WORKSPACE/srcdir/clang_constants.jl ${prefix}/

# copy mingw headers
if [[ ${target} == *mingw32* ]] && [[ ${nbits} == 64 ]]; then
    cp -r $WORKSPACE/srcdir/bin/* ${prefix}/bin
    mkdir -p ${prefix}/mingw/include
    mkdir -p ${prefix}/mingw/sys-root/include
    cp -r /opt/x86_64-w64-mingw32/x86_64-w64-mingw32/include/* ${prefix}/mingw/include/
    cp -r /opt/x86_64-w64-mingw32/x86_64-w64-mingw32/sys-root/include/* ${prefix}/mingw/sys-root/include/
fi

if [[ ${target} == *mingw32* ]] && [[ ${nbits} == 32 ]]; then
    cp -r $WORKSPACE/srcdir/bin/* ${prefix}/bin
    mkdir -p ${prefix}/mingw/include
    mkdir -p ${prefix}/mingw/sys-root/include
    cp -r /opt/i686-w64-mingw32/i686-w64-mingw32/include/* ${prefix}/mingw/include/
    cp -r /opt/i686-w64-mingw32/i686-w64-mingw32/sys-root/include/* ${prefix}/mingw/sys-root/include/
fi

"""

platforms = supported_platforms()

# The products that we will ensure are always built
products = [
    # libraries
    LibraryProduct("libcxxffi",  :libcxxffi)
]

build_tarballs(ARGS, "libcxxffi", v"0.0.0", sources, script, platforms, products, [], preferred_gcc_version=v"7")
