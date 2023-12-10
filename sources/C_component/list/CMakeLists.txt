cmake_minimum_required(VERSION 3.20)

project(CList VERSION 0.1 LANGUAGES C)

include_directories(${CMAKE_CURRENT_SOURCE_DIR}/..)

add_library(CList CList.c)
target_link_libraries(CList CSetmem)

if (C_COMPONENT_C_TEST)
    add_executable(test_list test.c)
    target_link_libraries(test_list CList)
endif ()