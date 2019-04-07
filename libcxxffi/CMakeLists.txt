cmake_minimum_required(VERSION 3.8.0)
project(cxxjl)

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

		set(CLANG_BIN_DIRS ${LLVMBUILDER_PREFIX}/bin)
    message(STATUS "CLANG_BIN_DIRS: " ${CLANG_BIN_DIRS})
else()
    message(FATAL_ERROR "please set LLVMBUILDER_PREFIX")
endif()

if(WIN32)
   set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")
endif()

set(CXXJL_TARGET cxxffi)

link_directories(${CLANG_LIB_DIRS})

add_library(${CXXJL_TARGET} SHARED ${CMAKE_CURRENT_SOURCE_DIR}/bootstrap.cpp)

target_include_directories(${CXXJL_TARGET} PUBLIC ${CLANG_INCLUDE_DIRS} ${CLANG_SOURCE_INCLUDE_DIRS})
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

find_library(LLVM_LIBS NAMES LLVM libLLVM libLLVM.dylib libLLVM.so LLVM.dll PATHS ${CLANG_LIB_DIRS} ${CLANG_BIN_DIRS})
message(STATUS "LLVM_LIBS: " ${LLVM_LIBS})

target_link_libraries(${CXXJL_TARGET} ${LLVM_LIBS})
if(APPLE)
	  set(CMAKE_SHARED_LIBRARY_CREATE_CXX_FLAGS "${CMAKE_SHARED_LIBRARY_CREATE_CXX_FLAGS} -undefined dynamic_lookup")
    target_link_libraries(${CXXJL_TARGET} -Wl,-all_load ${CLANG_LIBS} -Wl,-noall_load)
else()
    if(WIN32)
        target_link_libraries(${CXXJL_TARGET} -Wl,--whole-archive ${CLANG_LIBS} -Wl,--no-whole-archive -lversion )
    else()
        target_link_libraries(${CXXJL_TARGET} -Wl,--whole-archive ${CLANG_LIBS} -Wl,--no-whole-archive)
    endif()
endif()

install(TARGETS ${CXXJL_TARGET}
        RUNTIME DESTINATION bin
        LIBRARY DESTINATION lib
        ARCHIVE DESTINATION lib
        PUBLIC_HEADER DESTINATION include)
