cmake_minimum_required(VERSION 3.15.0)

#set(CMAKE_GENERATOR_PLATFORM Win32)

project(NewInstallerTemplateMSI)

# Enable Unicode Character Set
add_compile_definitions(UNICODE _UNICODE)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Set static runtime before any targets are defined
if(MSVC)
# Force only Release and Debug configurations
set(CMAKE_CONFIGURATION_TYPES "Debug;Release" CACHE STRING "" FORCE)
# Add global compiler definitions for Debug and Release configurations
add_compile_definitions(
    $<$<CONFIG:Debug>:_DEBUG>
    $<$<CONFIG:Release>:NDEBUG>
)
set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>")
else()
set(CMAKE_SHARED_LIBRARY_PREFIX "")
set(CMAKE_SHARED_LIBRARY_SUFFIX ".dll")
# Define the Release and Debug configurations
if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE "Release" CACHE STRING "Choose the type of build." FORCE)
endif()
# Set output directories based on build configuration
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>)
# Set the NDEBUG and _DEBUG macros for Release and Debug configurations
if(CMAKE_BUILD_TYPE STREQUAL "Release")
    add_compile_definitions(NDEBUG)
elseif(CMAKE_BUILD_TYPE STREQUAL "Debug")
    add_compile_definitions(_DEBUG)
endif()
add_link_options(
    "-static-libgcc"
    "-static-libstdc++"
)
endif()



add_library(UnRAR0 SHARED
    msi_log.c
    dll.rc
)
target_link_libraries(UnRAR0
    PRIVATE
    msi
)
if(MSVC)
target_link_options(UnRAR0 PRIVATE
    "/SUBSYSTEM:WINDOWS"
    "/MANIFEST:NO"
)
else()
target_link_options(UnRAR0 PRIVATE
    "-Wl,--subsystem,windows"
)
endif()


add_executable(test_UnRAR0
    test_msi.c
)
target_link_libraries(test_UnRAR0
    PRIVATE
    msi
)
if(MSVC)
target_link_options(test_UnRAR0 PRIVATE
    "/SUBSYSTEM:CONSOLE"
    "/MANIFEST:NO"
)
else()
target_link_options(test_UnRAR0 PRIVATE
    "-Wl,--subsystem,windows"
)
endif()
add_dependencies(test_UnRAR0 UnRAR0)



# Set up the MSI Package project
set(MSI_OUTPUT_DIR "${CMAKE_SOURCE_DIR}/Installer")

# Configure the heatwave.wxs.in file
#configure_file(heatwave.wxs.in heatwave.wxs @ONLY)

# Add a custom target to build the MSI
add_custom_target(Installer_TFMCfW ALL
    COMMAND ${CMAKE_COMMAND} -E make_directory "${MSI_OUTPUT_DIR}"
    COMMAND "C:/Program Files/WiX Toolset v5.0/bin/wix.exe" build "${CMAKE_SOURCE_DIR}/heatwave.wxs" -out "${MSI_OUTPUT_DIR}/Installer_TFMCfW.msi" -ext WixToolset.UI.wixext -ext WixToolset.Util.wixext
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
)
# Make Installer depending on UnRAR0
add_dependencies(Installer_TFMCfW UnRAR0)
# Ensure the output of candle.exe and light.exe is visible in the MSVC build log
set_property(TARGET Installer_TFMCfW PROPERTY ENABLE_EXPORTS TRUE)
