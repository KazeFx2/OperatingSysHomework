cmake_minimum_required(VERSION 3.20)

project(CList VERSION 0.1 LANGUAGES C)

include_directories(${CMAKE_CURRENT_SOURCE_DIR})

add_library(CList CList.c)

option(C_COMPONENT_C_LIST_TEST "build CList test" ON)

if(C_COMPONENT_C_LIST_TEST)
    add_executable(test test.c CList)
endif ()