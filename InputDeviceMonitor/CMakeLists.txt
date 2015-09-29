cmake_minimum_required(VERSION 2.6)

project (InputDeviceMonitor)

find_library(AUDIO_TOOLBOX AudioToolbox)
find_library(FOUNDATION Foundation)

add_executable(InputDeviceMonitor main.m XGInputDeviceMonitor.m)

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fmodules")

target_link_libraries(InputDeviceMonitor ${AUDIO_TOOLBOX} ${FOUNDATION})
