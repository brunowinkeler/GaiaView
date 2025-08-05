cmake_minimum_required(VERSION 3.16)

set(PROJ_NAME GaiaView)
set(EXEC_NAME ${PROJ_NAME}App)

project(${PROJ_NAME} VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

find_package(Qt6 REQUIRED COMPONENTS Core Quick SerialPort)

add_subdirectory(src)
