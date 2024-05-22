cmake_minimum_required(VERSION 3.1...3.29)

project(
  FFmpegTestApp
  VERSION 1.0
  LANGUAGES CXX)

if (CMAKE_BUILD_TYPE MATCHES Debug)
  add_definitions (-DDEBUG)
endif (CMAKE_BUILD_TYPE MATCHES Debug)

if (CMAKE_BUILD_TYPE MATCHES Release)
  add_definitions (-DNDEBUG)
endif (CMAKE_BUILD_TYPE MATCHES Release)

set(SOURCE
   ${SOURCE}
   ${CMAKE_CURRENT_SOURCE_DIR}/src/main.cpp
)
set(HEADERS
   ${HEADERS}
   ${CMAKE_CURRENT_SOURCE_DIR}/src/file1.hpp
)

add_executable(FFmpegTestApp ${HEADERS} ${SOURCE})