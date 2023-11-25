cmake_minimum_required(VERSION 3.20)

project(C_Lib VERSION 0.1 LANGUAGES C)

option(C_COMPONENT_C_TEST "build C test" ON)

include_directories(${CMAKE_CURRENT_SOURCE_DIR})

add_library(CSetmem setmem.c)

add_subdirectory(list)

add_subdirectory(rbtree)

add_subdirectory(bootmem)