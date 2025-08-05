qt_standard_project_setup(REQUIRES 6.8)

find_package(Qt6 REQUIRED COMPONENTS Core)

qt_add_executable(${EXEC_NAME}
    main.cpp
    connection/SerialPortManager.cpp
)

target_link_libraries(GaiaViewApp PRIVATE Qt6::Core)

file(GLOB_RECURSE QML_FILES RELATIVE "${CMAKE_CURRENT_SOURCE_DIR}" "../qml/*.qml")

foreach(qml_file IN LISTS QML_FILES)
    get_filename_component(qml_name ${qml_file} NAME)
    set_source_files_properties(
        ${qml_file}
        PROPERTIES QT_RESOURCE_ALIAS ${qml_name}
    )
endforeach()

qt_add_qml_module(${EXEC_NAME}
    URI ${EXEC_NAME}
    VERSION 1.0
    QML_FILES
        ${QML_FILES}
        SOURCES connection/SerialPortManager.cpp
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(${EXEC_NAME} PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appSensorView
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(${EXEC_NAME}
    PRIVATE
        Qt6::Core
        Qt6::Quick
        Qt6::SerialPort
)

include(GNUInstallDirs)
install(TARGETS ${EXEC_NAME}
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
