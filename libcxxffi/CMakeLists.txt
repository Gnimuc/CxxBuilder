cmake_minimum_required(VERSION 3.11.0)
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
endif()

find_library(CLANGFRONTENDTOOL NAMES clangFrontendTool PATHS ${CLANG_LIB_DIRS})
message(STATUS "clangFrontendTool: " ${CLANGFRONTENDTOOL})

find_library(CLANGBASIC NAMES clangBasic PATHS ${CLANG_LIB_DIRS})
message(STATUS "clangBasic: " ${CLANGBASIC})

find_library(CLANGLEX NAMES clangLex PATHS ${CLANG_LIB_DIRS})
message(STATUS "clangLex: " ${CLANGLEX})

find_library(CLANGDRIVER NAMES clangDriver PATHS ${CLANG_LIB_DIRS})
message(STATUS "clangDriver: " ${CLANGDRIVER})

find_library(CLANGPARSE NAMES clangParse PATHS ${CLANG_LIB_DIRS})
message(STATUS "clangParse: " ${CLANGPARSE})

find_library(CLANGAST NAMES clangAST PATHS ${CLANG_LIB_DIRS})
message(STATUS "clangAST: " ${CLANGAST})

find_library(CLANGASTMATERS NAMES clangASTMatchers PATHS ${CLANG_LIB_DIRS})
message(STATUS "clangASTMatchers: " ${CLANGASTMATERS})

find_library(CLANGSEMA NAMES clangSema PATHS ${CLANG_LIB_DIRS})
message(STATUS "clangSema: " ${CLANGSEMA})

find_library(CLANGANALYSIS NAMES clangAnalysis PATHS ${CLANG_LIB_DIRS})
message(STATUS "clangAnalysis: " ${CLANGANALYSIS})

find_library(CLANGEDIT NAMES clangEdit PATHS ${CLANG_LIB_DIRS})
message(STATUS "clangEdit: " ${CLANGEDIT})

find_library(CLANGREWRITEFRONTEND NAMES clangRewriteFrontend PATHS ${CLANG_LIB_DIRS})
message(STATUS "clangRewriteFrontend: " ${CLANGREWRITEFRONTEND})

find_library(CLANGREWRITE NAMES clangRewrite PATHS ${CLANG_LIB_DIRS})
message(STATUS "clangRewrite: " ${CLANGREWRITE})

find_library(CLANGSERIALIZATION NAMES clangSerialization PATHS ${CLANG_LIB_DIRS})
message(STATUS "clangSerialization: " ${CLANGSERIALIZATION})

find_library(CLANGSTATICANALYZERCHECKERS NAMES clangStaticAnalyzerCheckers PATHS ${CLANG_LIB_DIRS})
message(STATUS "clangStaticAnalyzerCheckers: " ${CLANGSTATICANALYZERCHECKERS})

find_library(CLANGSTATICANALYZERCORE NAMES clangStaticAnalyzerCore PATHS ${CLANG_LIB_DIRS})
message(STATUS "clangStaticAnalyzerCore: " ${CLANGSTATICANALYZERCORE})

find_library(CLANGSTATICANALYZERFRONTEND NAMES clangStaticAnalyzerFrontend PATHS ${CLANG_LIB_DIRS})
message(STATUS "clangStaticAnalyzerFrontend: " ${CLANGSTATICANALYZERFRONTEND})

find_library(CLANGTOOLING NAMES clangTooling PATHS ${CLANG_LIB_DIRS})
message(STATUS "clangTooling: " ${CLANGTOOLING})

find_library(CLANGTOOLINGCORE NAMES clangToolingCore PATHS ${CLANG_LIB_DIRS})
message(STATUS "clangToolingCore: " ${CLANGTOOLINGCORE})

find_library(CLANGCODEGEN NAMES clangCodeGen PATHS ${CLANG_LIB_DIRS})
message(STATUS "clangCodeGen: " ${CLANGCODEGEN})

find_library(CLANGARCMIGRATE NAMES clangARCMigrate PATHS ${CLANG_LIB_DIRS})
message(STATUS "clangARCMigrate: " ${CLANGARCMIGRATE})

find_library(CLANGFORMAT NAMES clangFormat PATHS ${CLANG_LIB_DIRS})
message(STATUS "clangFormat: " ${CLANGFORMAT})

find_library(JULIA_LIBS NAMES julia libjulia libjulia.dylib libjulia.so libjulia.dll PATHS ${JULIA_LIB_DIRS})
message(STATUS "JULIA_LIBS: " ${JULIA_LIBS})

find_library(LLVM_LIBS NAMES LLVM libLLVM libLLVM.dylib libLLVM.so LLVM.dll PATHS ${JULIA_LIB_DIRS} ${JULIA_BINARY_PREFIX}/bin)
message(STATUS "LLVM_LIBS: " ${LLVM_LIBS})


set(CLANG_LIBS ${CLANGFRONTENDTOOL}
	       ${CLANGBASIC}
               ${CLANGLEX}
               ${CLANGDRIVER}
               ${CLANGFRONTEND}
	       ${CLANGPARSE}
               ${CLANGAST}
               ${CLANGASTMATERS}
               ${CLANGSEMA}
               ${CLANGANALYSIS}
               ${CLANGEDIT}
               ${CLANGREWRITEFRONTEND}
               ${CLANGREWRITE}
               ${CLANGSERIALIZATION}
               ${CLANGSTATICANALYZERCHECKERS}
	       ${CLANGSTATICANALYZERCORE}
               ${CLANGSTATICANALYZERFRONTEND}
               ${CLANGTOOLING}
               ${CLANGTOOLINGCORE}
               ${CLANGCODEGEN}
               ${CLANGARCMIGRATE}
               ${CLANGFORMAT})

set(CMAKE_POSITION_INDEPENDENT_CODE ON)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -O0 -std=c++11 -fno-rtti -fPIC")
set(CMAKE_SHARED_LINKER_FLAGS "-Wl,--export-all-symbols")

set(BOOTSTRAP_TARGET bootstrap)
set(CXXJL_TARGET cxxffi)


add_library(${BOOTSTRAP_TARGET} OBJECT ${CMAKE_CURRENT_SOURCE_DIR}/bootstrap.cpp)
target_include_directories(${BOOTSTRAP_TARGET} PUBLIC ${CLANG_INCLUDE_DIRS} ${CLANG_SOURCE_INCLUDE_DIRS} ${JULIA_INCLUDE_DIRS} ${JULIA_SOURCE_INCLUDE_DIRS} ${DLFCN_WIN32_PREFIX})
target_compile_definitions(${BOOTSTRAP_TARGET} PUBLIC -DLLVM_NDEBUG -DLIBRARY_EXPORTS)


add_library(${CXXJL_TARGET} SHARED $<TARGET_OBJECTS:${BOOTSTRAP_TARGET}>)
#add_library(${CXXJL_TARGET} SHARED)
#target_link_libraries(${CXXJL_TARGET} PRIVATE ${BOOTSTRAP_TARGET})
if(APPLE)
    target_link_libraries(${CXXJL_TARGET} PRIVATE ${JULIA_LIBS} ${LLVM_LIBS})
    target_link_libraries(${CXXJL_TARGET} PRIVATE -Xlinker -all_load ${CLANG_LIBS})
elseif(WIN32)
    set(CXXJLLINK_FLAGS "${LINK_FLAGS} -l${JULIA_LIBS} -l${LLVM_LIBS} -Wl,-whole-archive -l${CLANGFRONTENDTOOL} -l${CLANGBASIC} -l${CLANGLEX} -l${CLANGDRIVER} -l${CLANGFRONTEND} -l${CLANGPARSE} -l${CLANGAST} -l${CLANGASTMATERS} -l${CLANGSEMA} -l${CLANGANALYSIS} -l${CLANGEDIT} -l${CLANGREWRITEFRONTEND} -l${CLANGREWRITE} -l${CLANGSERIALIZATION} -l${CLANGSTATICANALYZERCHECKERS} -l${CLANGSTATICANALYZERCORE} -l${CLANGSTATICANALYZERFRONTEND} -l${CLANGTOOLING} -l${CLANGTOOLINGCORE} -l${CLANGCODEGEN} -l${CLANGARCMIGRATE} -l${CLANGFORMAT} -Wl,--no-whole-archive -lversion")
    set_target_properties(${CXXJL_TARGET} PROPERTIES LINK_FLAGS ${CXXJLLINK_FLAGS})
    target_link_libraries(${CXXJL_TARGET} ${CMAKE_DL_LIBS})
else()
	target_link_libraries(${CXXJL_TARGET} PRIVATE ${JULIA_LIBS} ${LLVM_LIBS})
    target_link_libraries(${CXXJL_TARGET} PRIVATE -Wl,--whole-archive ${CLANG_LIBS} )
endif()

install(TARGETS ${CXXJL_TARGET}
        RUNTIME DESTINATION bin
        LIBRARY DESTINATION lib
        ARCHIVE DESTINATION lib
        PUBLIC_HEADER DESTINATION include)
