cmake_minimum_required(VERSION 3.8.0)
project(cxxjl)

if(JULIA_SOURCE_PREFIX)
    set(JULIA_SOURCE_INCLUDE_DIRS ${JULIA_SOURCE_PREFIX}/src/support)
    message(STATUS "JULIA_SOURCE_INCLUDE_DIRS: " ${JULIA_SOURCE_INCLUDE_DIRS})
else()
    message(FATAL_ERROR "please set JULIA_SOURCE_PREFIX")
endif()

if(JULIA_BINARY_PREFIX)
    set(JULIA_INCLUDE_DIRS ${JULIA_BINARY_PREFIX}/include/julia)
    message(STATUS "JULIA_INCLUDE_DIRS: " ${JULIA_INCLUDE_DIRS})

    set(JULIA_LIB_DIRS ${JULIA_BINARY_PREFIX}/bin ${JULIA_BINARY_PREFIX}/lib ${JULIA_BINARY_PREFIX}/lib/julia)
    foreach(x IN LISTS JULIA_LIB_DIRS)
        message(STATUS "Julia_LIB_DIRS: " ${x})
    endforeach()
else()
    message(FATAL_ERROR "please set JULIA_BINARY_PREFIX")
endif()

if(LLVM_VERSION)
		message(STATUS "LLVM_VERSION: " ${LLVM_VERSION})
else()
    set(LLVM_VERSION 6.0.1)
		message(STATUS "LLVM_VERSION: " ${LLVM_VERSION})
endif()

if(CLANG_SOURCE_PREFIX)
    message(STATUS "CLANG_SOURCE_PREFIX: " ${CLANG_SOURCE_PREFIX})
else()
    set(CLANG_SOURCE_PREFIX ${CMAKE_CURRENT_SOURCE_DIR}/llvm-${LLVM_VERSION}.src/tools/clang)
    message(STATUS "use default CLANG_SOURCE_PREFIX: " ${CLANG_SOURCE_PREFIX})
endif()
set(CLANG_SOURCE_INCLUDE_DIRS ${CLANG_SOURCE_PREFIX}/include ${CLANG_SOURCE_PREFIX}/lib)
foreach(x IN LISTS CLANG_SOURCE_INCLUDE_DIRS)
    message(STATUS "CLANG_SOURCE_INCLUDE_DIRS: " ${x})
endforeach()

if(LLVMBUILDER_PREFIX)
    set(CLANG_INCLUDE_DIRS ${LLVMBUILDER_PREFIX}/include)
    message(STATUS "CLANG_INCLUDE_DIRS: " ${CLANG_INCLUDE_DIRS})

    set(CLANG_LIB_DIRS ${LLVMBUILDER_PREFIX}/lib)
    message(STATUS "CLANG_LIB_DIRS: " ${CLANG_LIB_DIRS})
else()
    message(FATAL_ERROR "please set LLVMBUILDER_PREFIX")
endif()

if(WIN32)
    find_package(dlfcn-win32 REQUIRED)
    set(CMAKE_DL_LIBS dlfcn-win32::dl)
		message(STATUS "CMAKE_DL_LIBS: " ${CMAKE_DL_LIBS})
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")
endif()

set(CXXJL_TARGET cxxffi)

link_directories(${CLANG_LIB_DIRS} ${JULIA_LIB_DIRS})

add_library(${CXXJL_TARGET} SHARED ${CMAKE_CURRENT_SOURCE_DIR}/bootstrap.cpp)

target_include_directories(${CXXJL_TARGET} PUBLIC ${CLANG_INCLUDE_DIRS} ${CLANG_SOURCE_INCLUDE_DIRS} ${JULIA_INCLUDE_DIRS} ${JULIA_SOURCE_INCLUDE_DIRS})
target_compile_options(${CXXJL_TARGET} PUBLIC -DLLVM_NDEBUG -DLIBRARY_EXPORTS -fno-rtti)

set(CLANG_LIBS clangFrontendTool
	       			 clangBasic
               clangLex
               clangDriver
               clangFrontend
               clangParse
	             clangAST
               clangASTMatchers
               clangSema
               clangAnalysis
               clangEdit
               clangRewriteFrontend
               clangRewrite
               clangSerialization
               clangStaticAnalyzerCheckers
	             clangStaticAnalyzerCore
               clangStaticAnalyzerFrontend
               clangTooling
               clangToolingCore
               clangCodeGen
               clangARCMigrate
               clangFormat)

find_library(JULIA_LIBS NAMES julia libjulia libjulia.dylib libjulia.so libjulia.dll PATHS ${JULIA_LIB_DIRS})
message(STATUS "JULIA_LIBS: " ${JULIA_LIBS})

find_library(LLVM_LIBS NAMES LLVM libLLVM libLLVM.dylib libLLVM.so LLVM.dll PATHS ${JULIA_LIB_DIRS} ${JULIA_BINARY_PREFIX}/bin)
message(STATUS "LLVM_LIBS: " ${LLVM_LIBS})

if(APPLE)
    target_link_libraries(${CXXJL_TARGET} ${JULIA_LIBS} ${LLVM_LIBS})
    target_link_libraries(${CXXJL_TARGET} -Xlinker -all_load ${CLANG_LIBS})
else()
	  target_link_libraries(${CXXJL_TARGET} ${JULIA_LIBS} ${LLVM_LIBS})
    if(WIN32)
			  target_link_libraries(${CXXJL_TARGET} ${CMAKE_DL_LIBS})
        target_link_libraries(${CXXJL_TARGET} -Wl,--whole-archive ${CLANG_LIBS} -Wl,--no-whole-archive)
    else()
        target_link_libraries(${CXXJL_TARGET} -Wl,--whole-archive ${CLANG_LIBS} -Wl,--no-whole-archive)
    endif()
endif()

install(TARGETS ${CXXJL_TARGET}
        RUNTIME DESTINATION bin
        LIBRARY DESTINATION lib
        ARCHIVE DESTINATION lib
        PUBLIC_HEADER DESTINATION include)
