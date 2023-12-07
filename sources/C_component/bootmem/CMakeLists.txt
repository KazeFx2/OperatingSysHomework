cmake_minimum_required(VERSION 3.20)

project(CBootMem VERSION 0.1 LANGUAGES C)

include_directories(${CMAKE_CURRENT_SOURCE_DIR}/..)

add_library(CBootMem bootmem.c)

if (C_COMPONENT_C_TEST)
    add_executable(test_bootmem test.c)
    target_link_libraries(test_bootmem CBootMem CList CRbtree CSetmem)
endif ()