cmake_minimum_required(VERSION 3.15.0)

#set(CMAKE_GENERATOR_PLATFORM Win32)

project(NewInstallerTemplateMSI)

# Enable Unicode Character Set
add_compile_definitions(UNICODE _UNICODE)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Force only Release and Debug configurations
set(CMAKE_CONFIGURATION_TYPES "Debug;Release" CACHE STRING "" FORCE)

# Add global compiler definitions for Debug and Release configurations
add_compile_definitions(
    $<$<CONFIG:Debug>:_DEBUG>
    $<$<CONFIG:Release>:NDEBUG>
)

# Set static runtime before any targets are defined
set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>")



add_library({{ CUSTOM_DLL_NAME }} SHARED
    msi_log.c
    dll.rc
)
target_link_libraries({{ CUSTOM_DLL_NAME }}
    PRIVATE
    msi
)
target_link_options({{ CUSTOM_DLL_NAME }} PRIVATE
    "/SUBSYSTEM:WINDOWS"
    "/MANIFEST:NO"
)



add_executable(test_{{ CUSTOM_DLL_NAME }}
    test_msi.c
)
target_link_libraries(test_{{ CUSTOM_DLL_NAME }}
    PRIVATE
    msi
)
target_link_options(test_{{ CUSTOM_DLL_NAME }} PRIVATE
    "/SUBSYSTEM:CONSOLE"
    "/MANIFEST:NO"
)
add_dependencies(test_{{ CUSTOM_DLL_NAME }} {{ CUSTOM_DLL_NAME }})



# Set up the MSI Package project
set(MSI_OUTPUT_DIR "${CMAKE_SOURCE_DIR}/Installer")

# Configure the heatwave.wxs.in file
#configure_file(heatwave.wxs.in heatwave.wxs @ONLY)

# Add a custom target to build the MSI
add_custom_target(Installer_{{ CNM }} ALL
    COMMAND ${CMAKE_COMMAND} -E make_directory "${MSI_OUTPUT_DIR}"
    COMMAND "{{ WIX_TOOLSET_EXE }}" build "${CMAKE_SOURCE_DIR}/heatwave.wxs" -out "${MSI_OUTPUT_DIR}/Installer_{{ CNM }}.msi" -ext WixToolset.UI.wixext -ext WixToolset.Util.wixext
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
)
# Make Installer depending on {{ CUSTOM_DLL_NAME }}
add_dependencies(Installer_{{ CNM }} {{ CUSTOM_DLL_NAME }})
# Ensure the output of candle.exe and light.exe is visible in the MSVC build log
set_property(TARGET Installer_{{ CNM }} PROPERTY ENABLE_EXPORTS TRUE)
