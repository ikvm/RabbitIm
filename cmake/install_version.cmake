#TODO:发行版本时，需要修改下列值  
SET(MAJOR_VERSION_NUMBER 0)      #主版本
SET(MINOR_VERSION_NUMBER 1)       #次版本
SET(REVISION_VERSION_NUMBER 0)  #修订号

SET(VERSION_NUMBER_STRING "${MAJOR_VERSION_NUMBER}.${MINOR_VERSION_NUMBER}.${REVISION_VERSION_NUMBER}")
IF(BUILD_VERSION)
    SET(VERSION_NUMBER_STRING "${VERSION_NUMBER_STRING}.${BUILD_VERSION}")
ENDIF()

# Project Info
SET(PROJECT_DESCRIPTION  "Rabbit instant messaging")
SET(PROJECT_COPYRIGHT    "Copyright (C) 2014-2015 KangLin studio") #TODO:修改日期
SET(PROJECT_CONTACT      "kl222@126.com")
SET(PROJECT_VENDOR       "KangLin studio")
SET(PROJECT_WEBSITE      "https://github.com/KangLin/rabbitim")
SET(PROJECT_LICENSE      "GPLv2+ License")
SET(PROJECT_VERSION      "${MAJOR_VERSION_NUMBER}.${MINOR_VERSION_NUMBER}.${REVISION_VERSION_NUMBER}")

#更新版本头文件
configure_file(
  ${CMAKE_CURRENT_SOURCE_DIR}/Update/Version.h.template.cmake
  ${CMAKE_CURRENT_SOURCE_DIR}/Version.h
)
#更新更新文件中的版本信息
configure_file(
  ${CMAKE_CURRENT_SOURCE_DIR}/Update/Update.xml.template.cmake
  ${CMAKE_CURRENT_SOURCE_DIR}/Update/Update_${RABBITIM_SYSTEM}.xml
)

OPTION(OPTION_RABBITIM_DOXYGEN "Build statically" OFF)
IF(OPTION_RABBITIM_DOXYGEN)
    #更新 Doxygen 文件中的版本信息
    configure_file(
      ${CMAKE_CURRENT_SOURCE_DIR}/Doxyfile.template.cmake
      ${CMAKE_BINARY_DIR}/Doxyfile
    )
    FIND_PROGRAM(DOXYGEN doxygen)
    IF(DOXYGEN)
        EXECUTE_PROCESS(
                WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
                COMMAND ${DOXYGEN} ${CMAKE_BINARY_DIR}/Doxyfile
                #OUTPUT_VARIABLE BUILD_VERSION  OUTPUT_STRIP_TRAILING_WHITESPACE
        )
    ENDIF(DOXYGEN)
ENDIF(OPTION_RABBITIM_DOXYGEN)

# Compiler Runtime DLLs
#IF(MSVC)
  # Visual Studio
#  set(CMAKE_INSTALL_SYSTEM_RUNTIME_LIBS_SKIP true)
#  include(InstallRequiredSystemLibraries)
#  install(FILES ${CMAKE_INSTALL_SYSTEM_RUNTIME_LIBS} DESTINATION .)
#elseif(MINGW)
  # MinGW
#  get_filename_component(MINGW_DLL_DIR ${CMAKE_CXX_COMPILER} PATH)
#  install(FILES
#    ${MINGW_DLL_DIR}/libgcc_s_dw2-1.dll
#    ${MINGW_DLL_DIR}/libstdc++-6.dll
#    ${MINGW_DLL_DIR}/libwinpthread-1.dll
#    DESTINATION .
#  )
#endif()

#CPACK: General Settings
SET(CPACK_PACKAGE_NAME "${PROJECT_NAME}")
SET(CPACK_PACKAGE_DESCRIPTION_SUMMARY "${PROJECT_DESCRIPTION}")
SET(CPACK_PACKAGE_VERSION_MAJOR "${MAJOR_VERSION_NUMBER}")
SET(CPACK_PACKAGE_VERSION_MINOR "${MINOR_VERSION_NUMBER}")
SET(CPACK_PACKAGE_VERSION_PATCH "${REVISION_VERSION_NUMBER}")
SET(CPACK_PACKAGE_DESCRIPTION "${PROJECT_DESCRIPTION}")
SET(CPACK_PACKAGE_CONTACT "${PROJECT_CONTACT}")
SET(CPACK_PACKAGE_VENDOR "${PROJECT_VENDOR}")
SET(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_SOURCE_DIR}/License.md")
#SET(CPACK_RESOURCE_FILE_README "${CMAKE_SOURCE_DIR}/README.md")

#CPACK: DEB Specific Settings
set(CPACK_DEBIAN_PACKAGE_SECTION "Development")

IF(WIN32)
    SET(CPACK_NSIS_EXECUTABLES_DIRECTORY ".")
    SET(CPACK_NSIS_INSTALLED_ICON_NAME "${PROJECT_NAME}${CMAKE_EXECUTABLE_SUFFIX}")
    SET(CPACK_NSIS_DISPLAY_NAME "${CPACK_PACKAGE_INSTALL_DIRECTORY}${PROJECT_NAME}")
    SET(CPACK_NSIS_MODIFY_PATH ON)
    STRING(REPLACE "/" "\\" CPACK_PACKAGE_ICON "${CMAKE_SOURCE_DIR}/Resource/png/AppIcon.bmp")
    STRING(REPLACE "/" "\\" CPACK_NSIS_MUI_ICON "${CMAKE_SOURCE_DIR}/AppIcon.ico")
    SET(CPACK_NSIS_MUI_UNIICON ${CPACK_NSIS_MUI_ICON})
    SET(CPACK_NSIS_ENABLE_UNINSTALL_BEFORE_INSTALL ON)
    SET(CPACK_NSIS_URL_INFO_ABOUT "https://github.com/KangLin/rabbitim")
    set(CPACK_NSIS_MENU_LINKS
        "${PROJECT_NAME}${CMAKE_EXECUTABLE_SUFFIX}"
        "${PROJECT_NAME}" "${PROJECT_WEBSITE}" "RabbitIm Project Web Site")
    SET(CPACK_NSIS_MUI_FINISHPAGE_RUN "${PROJECT_NAME}${CMAKE_EXECUTABLE_SUFFIX}")
ELSE()
    SET(CPACK_PACKAGE_ICON "${CMAKE_SOURCE_DIR}/AppIcon.ico")
ENDIF()

# RPM 
IF(LINUX OR UNIX)
    INCLUDE(${CMAKE_SOURCE_DIR}/cmake/RpmBuild.cmake)
ENDIF()
IF(RPMBUILD_FOUND AND NOT WIN32 AND NOT ANDROID)
    SET(CPACK_GENERATOR "RPM")
    SET(CPACK_RPM_PACKAGE_SUMMARY "${PROJECT_DESCRIPTION}")
    SET(CPACK_RPM_PACKAGE_NAME "${PROJECT_NAME}")
    SET(CPACK_RPM_PACKAGE_VERSION "${PROJECT_VERSION}")
    SET(CPACK_RPM_PACKAGE_LICENSE "${PROJECT_LICENSE}")
    SET(CPACK_RPM_PACKAGE_GROUP "${PROJECT_NAME}")
    SET(CPACK_RPM_PACKAGE_VENDOR "${PROJECT_NAME}")
    SET(CPACK_RPM_PACKAGE_DESCRIPTION "${PROJECT_DESCRIPTION}")
    SET(CPACK_RPM_PACKAGE_DEPENDS ${RABBITIM_PACKAGE_REQUIRES})
    SET(CPACK_SET_DESTDIR TRUE)
ENDIF(RPMBUILD_FOUND AND NOT WIN32 AND NOT ANDROID)

# Debian packages
IF(LINUX OR UNIX)
    INCLUDE (${CMAKE_SOURCE_DIR}/cmake/DpkgBuild.cmake)
ENDIF()
IF(DPKG_FOUND AND NOT WIN32 AND NOT ANDROID)
    SET(CPACK_GENERATOR "DEB")
    SET(CPACK_DEBIAN_PACKAGE_NAME "${CPACK_PACKAGE_NAME}")
    SET(CPACK_DEBIAN_PACKAGE_VERSION "${PROJECT_VERSION}")
    SET(CPACK_DEBIAN_PACKAGE_DESCRIPTION "${PROJECT_DESCRIPTION}")
    SET(CPACK_DEBIAN_PACKAGE_MAINTAINER "${PROJECT_VENDOR} <${PROJECT_CONTACT}>")
    SET(CPACK_DEBIAN_PACKAGE_PRIORITY "optional")
    SET(CPACK_DEBIAN_PACKAGE_DEBUG OFF)
    SET(RABBITIM_PACKAGE_REQUIRES "libavcodec-dev, libavformat-dev, libavutil-dev, libswscale-dev, libc6 (>= 2.14), libcurl3 (>= 7.16.2), libegl1-mesa (>= 7.8.1) | libegl1-x11, libfontconfig1 (>= 2.9.0), libfreetype6 (>= 2.3.5), libgcc1 (>= 1:4.1.1), libgl1-mesa-glx | libgl1, libglib2.0-0 (>= 2.22.0), libgtk2.0-0 (>= 2.24.0), libice6 (>= 1:1.0.0), libicu52 (>= 52~m1-1~), libpango-1.0-0 (>= 1.14.0), libpulse0 (>= 1:0.99.1), libsm6, libssl1.0.0 (>= 1.0.0), libstdc++6 (>= 4.6), libvpx1 (>= 1.0.0), libx11-6, libx11-xcb1, libxcb1, libxi6 (>= 2:1.2.99.4), libxrender1")
    SET(CPACK_DEBIAN_PACKAGE_DEPENDS "${RABBITIM_PACKAGE_REQUIRES}")
    SET(CPACK_DEBIAN_PACKAGE_SECTION "Applications/Network/Communication")
    SET(CPACK_SET_DESTDIR TRUE)

    #configure_file(
    #  ${CMAKE_CURRENT_SOURCE_DIR}/debian/control.template.cmake
    #  ${PROJECT_BINARY_DIR}/control
    #  @ONLY
    #)
    SET(CONTROL_EXTRA "${CMAKE_SOURCE_DIR}/debian/menu")
    #SET(CONTROL_EXTRA "${CONTROL_EXTRA};${PROJECT_BINARY_DIR}/control")
    SET(CONTROL_EXTRA 
            "${CONTROL_EXTRA};${CMAKE_SOURCE_DIR}/debian/preinst;${CMAKE_SOURCE_DIR}/debian/postinst")
    SET(CONTROL_EXTRA 
            "${CONTROL_EXTRA};${CMAKE_SOURCE_DIR}/debian/prerm;${CMAKE_SOURCE_DIR}/debian/postrm")
    SET(CPACK_DEBIAN_PACKAGE_CONTROL_EXTRA "${CONTROL_EXTRA}")
ENDIF(DPKG_FOUND AND NOT WIN32 AND NOT ANDROID)

# Mac App Bundle
IF(APPLE)
    SET(CPACK_GENERATOR "DragNDrop")
    # Libraries are bundled directly
    SET(CPACK_COMPONENT_LIBRARIES_HIDDEN TRUE)
    # Bundle Properties
    SET(MACOSX_BUNDLE_BUNDLE_NAME "${PROJECT_NAME}")
    SET(MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION})
    SET(MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION})
    SET(MACOSX_BUNDLE_LONG_VERSION_STRING "Version ${PROJECT_VERSION}")
ENDIF(APPLE)

include(CPack)
