cmake_minimum_required(VERSION 3.16)

project(LauncherUI VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

# 👇 Add Multimedia here
find_package(Qt6 REQUIRED COMPONENTS Quick QuickEffects Multimedia)

qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(appLauncherUI
    main.cpp
)

qt_add_qml_module(appLauncherUI
    URI LauncherUI
    VERSION 1.0
    QML_FILES
        Main.qml
    RESOURCES
        resource.qrc
        QML_FILES
        QML_FILES sounds/StartupOverlay.qml
        QML_FILES sounds/StartupAnim.qml
        QML_FILES sounds/BackgroundAnim.qml
        QML_FILES sounds/WifiTab.qml
        QML_FILES sounds/Customize.qml
        SOURCES
        SOURCES
        SOURCES
        QML_FILES sounds/Wifidetail.qml
        RESOURCES images/main1.png images/main2.png images/main3.png
)

qt_add_resources(appLauncherUI "resource"
    PREFIX "/sounds"
    FILES "sounds/pulse.wav"
)

set_target_properties(appLauncherUI PROPERTIES
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

# 👇 Link Multimedia here too
target_link_libraries(appLauncherUI
    PRIVATE Qt6::Quick Qt6::QuickEffects Qt6::Multimedia
)

include(GNUInstallDirs)
install(TARGETS appLauncherUI
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
