cmake_minimum_required(VERSION 3.16)

set(PROJ_NAME GaiaView)
set(EXEC_NAME ${PROJ_NAME}App)

project(${PROJ_NAME} VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS
                Quick
                Core
                SerialPort)

qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(${EXEC_NAME}
    src/main.cpp
    src/connection/serialportmanager.cpp
)

qt_add_qml_module(${EXEC_NAME}
    URI ${PROJ_NAME}
    VERSION 1.0
    QML_FILES
        qml/Main.qml
        qml/SerialPortWindow.qml
    SOURCES
        include/connection/serialportmanager.h
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(${EXEC_NAME} PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.${EXEC_NAME}
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_include_directories(${EXEC_NAME} PRIVATE
        ${PROJECT_SOURCE_DIR}/include
)

target_link_libraries(${EXEC_NAME} PRIVATE
        Qt6::Quick
        Qt6::Core
        Qt6::SerialPort
)

include(GNUInstallDirs)
install(TARGETS ${EXEC_NAME}
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
