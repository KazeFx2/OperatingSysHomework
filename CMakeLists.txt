cmake_minimum_required(VERSION 3.20)

project(QT_Test VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_ASM_STANDARD_REQUIRED ON)

# set(CMAKE_C_COMPILE_OBJECT ON)

set(TS_FILES)
set(QM_FILES)

set(ICON_RES ${CMAKE_CURRENT_SOURCE_DIR}/src/ico/App.ico)

# set sub_dir
list(APPEND sub_dir FluentUI)

# deal with the 3rd-party lib FluentUI
# set lib output dir
set(FLUENTUI_QML_PLUGIN_DIRECTORY ${CMAKE_BINARY_DIR}/qml/FluentUI CACHE INTERNAL "")
# not to build example
set(FLUENTUI_BUILD_EXAMPLES OFF)

# not to build the example of framelessHelper
set(FRAMELESSHELPER_BUILD_EXAMPLES OFF)

# add sub_dir
foreach (s_dir ${sub_dir})
    add_subdirectory(${s_dir})
endforeach (s_dir)

# Apple device
if (APPLE)
    set(CMAKE_OSX_ARCHITECTURES "arm64;x86_64" CACHE STRING "" FORCE)
endif ()

# set(QML_IMPORT_PATH ${CMAKE_BINARY_DIR})

# get sys path separator
# file(TO_CMAKE_PATH "/" PATH_SEPARATOR)

# get Qt
find_package(QT NAMES Qt6 Qt5 REQUIRED COMPONENTS Core Quick Svg Network LinguistTools Widgets)
find_package(Qt${QT_VERSION_MAJOR} REQUIRED COMPONENTS Core Quick Svg Network LinguistTools Widgets)

# check Qt version
if (QT_VERSION VERSION_GREATER_EQUAL "6.3")
    qt_standard_project_setup()
else ()
    # auto cmake
    set(CMAKE_AUTOMOC ON)
    set(CMAKE_AUTORCC ON)
    set(CMAKE_AUTOUIC ON)
endif ()

# get cmake build dir
file(RELATIVE_PATH BUILD_D ${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_BINARY_DIR})

# add except_prefixes
set(except_dir ${sub_dir})
list(APPEND except_dir ${BUILD_D})
list(APPEND except_dir cmake)
# list(APPEND except_dir sources/C_)

# recurse all cpp/head files
file(GLOB_RECURSE CPP_FILES *.cpp *.h)
foreach (filepath ${CPP_FILES})
    string(REPLACE "${CMAKE_CURRENT_SOURCE_DIR}/" "" filename ${filepath})
    set(__state ON)
    foreach (except ${except_dir})
        string(FIND ${filename} ${except} _state)
        if (${_state} EQUAL 0)
            set(__state OFF)
            break()
        endif ()
    endforeach (except)
    if (__state)
        list(APPEND sources_files ${filename})
    endif ()
endforeach (filepath)

# recurse all *.qml files
file(GLOB_RECURSE QML_PATHS *.qml)
foreach (filepath ${QML_PATHS})
    string(REPLACE "${CMAKE_CURRENT_SOURCE_DIR}/" "" filename ${filepath})
    set(__state ON)
    foreach (except ${except_dir})
        string(FIND ${filename} ${except} _state)
        if (${_state} EQUAL 0)
            set(__state OFF)
            break()
        endif ()
    endforeach (except)
    #        if (${filepath} MATCHES "Qt${QT_VERSION_MAJOR}/")
    #            string(REPLACE "qml-Qt${QT_VERSION_MAJOR}" "qml" filealias ${filename})
    #            set_source_files_properties(${filename} PROPERTIES QT_RESOURCE_ALIAS ${filealias})
    #            list(APPEND qml_files ${filename})
    #        endif ()
    if (__state)
        list(APPEND qml_files ${filename})
    endif ()
endforeach (filepath)

# recurse ts files
file(GLOB_RECURSE TS_PATHS *.ts)
foreach (filepath ${TS_PATHS})
    string(REPLACE "${CMAKE_CURRENT_SOURCE_DIR}/" "" filename ${filepath})
    set(__state ON)
    foreach (except ${except_dir})
        string(FIND ${filename} ${except} _state)
        if (${_state} EQUAL 0)
            set(__state OFF)
            break()
        endif ()
    endforeach (except)
    if (__state)
        list(APPEND TS_FILES ${filename})
    endif ()
endforeach (filepath)

# recurse qrc files
file(GLOB_RECURSE QRC_PATHS *.qrc)
foreach (filepath ${QRC_PATHS})
    string(REPLACE "${CMAKE_CURRENT_SOURCE_DIR}/" "" filename ${filepath})
    set(__state ON)
    foreach (except ${except_dir})
        string(FIND ${filename} ${except} _state)
        if (${_state} EQUAL 0)
            set(__state OFF)
            break()
        endif ()
    endforeach (except)
    if (__state)
        list(APPEND qrc_files ${filename})
    endif ()
endforeach (filepath)

# recurse res files
file(GLOB_RECURSE RES_PATHS *.png *.jpg *.svg *.ico *.ttf *.webp *.obj qmldir)
foreach (filepath ${RES_PATHS})
    string(REPLACE "${CMAKE_CURRENT_SOURCE_DIR}/" "" filename ${filepath})
    set(__state ON)
    foreach (except ${except_dir})
        string(FIND ${filename} ${except} _state)
        if (${_state} EQUAL 0)
            set(__state OFF)
            break()
        endif ()
    endforeach (except)
    if (__state)
        list(APPEND resource_files ${filename})
    endif ()
endforeach (filepath)

set(C_COMPONENT_C_TEST ON)
add_subdirectory(sources/C_component)

# add executable
if (WIN32)
    add_executable(QT_Test
            ${sources_files}
            ${qml_files}
            ${resource_files}
            main.rc
    )
    configure_file(${ICON_RES} ${CMAKE_CURRENT_BINARY_DIR}/icon.ico COPYONLY)
else ()
    # TO DO
    add_executable(QT_Test
            ${sources_files}
    )
endif ()

set_source_files_properties(${TS_FILES}
        PROPERTIES OUTPUT_LOCATION ${CMAKE_CURRENT_SOURCE_DIR}
)

# add_custom_target(ts DEPENDS ${TS_FILES})

if (QT_VERSION VERSION_GREATER_EQUAL "6.0")
    # TO DO
    # qt_add_translation(QM_FILES
    #                        # ${source_files}
    #                        ${qml_files}
    #                        ${TS_FILES})
else ()
    qt5_create_translation(QM_FILES
            # ${source_files}
            ${qml_files}
            ${TS_FILES})
endif ()

#set_source_files_properties(${QM_FILES}
#        PROPERTIES OUTPUT_LOCATION ${CMAKE_CURRENT_SOURCE_DIR}
#)

add_custom_target(ts DEPENDS ${TS_FILES})
add_custom_target(qm DEPENDS ${QM_FILES})

# target .qrc
if (QT_VERSION VERSION_GREATER_EQUAL "6.2")
    # add qml module
    # TO DO
    qt_add_qml_module(example
            URI "QT_Test"
            VERSION 1.0
            QML_FILES ${qml_files}
            RESOURCES ${resource_files}
            RESOURCE_PREFIX "/"
    )
else ()
    # TO DO
    #    target_include_directories(QT_Test PRIVATE
    #            ${CMAKE_CURRENT_SOURCE_DIR}
    #    )
    target_sources(QT_Test PRIVATE ${qrc_files})
endif ()

# add heads
# import component head filed, or cpp class that generated by QML_NAMED_ELEMENT
# will push an error that can not find head files
target_include_directories(QT_Test PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/sources
        ${CMAKE_CURRENT_SOURCE_DIR}/FluentUI/src
)

# set attr...
set_target_properties(QT_Test PROPERTIES
        MACOSX_BUNDLE_GUI_IDENTIFIER kaze.qt_test.com
        MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
        MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
        MACOSX_BUNDLE TRUE
        WIN32_EXECUTABLE TRUE
)

# lib link
target_link_libraries(QT_Test PRIVATE
        Qt${QT_VERSION_MAJOR}::Quick
        Qt${QT_VERSION_MAJOR}::Svg
        Qt${QT_VERSION_MAJOR}::Network
        # dynamic link
        fluentuiplugin
        CList
)

# installation
install(TARGETS QT_Test
        BUNDLE DESTINATION .
        LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
        RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
