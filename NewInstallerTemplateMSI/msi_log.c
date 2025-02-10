#include <windows.h>
#include <msi.h>
#include <msiquery.h>
#include <stdio.h>



// Entry point for the custom action
UINT __declspec(dllexport) __stdcall OnUnInstall(MSIHANDLE hInstall) {
    MessageBoxW(NULL, L"Entry OnUnInstall ERROR_SUCCESS", L"v{{ VERMSI }}", MB_OK);
    return ERROR_SUCCESS;
}

// Entry point for the custom action
UINT __declspec(dllexport) __stdcall OnInstall(MSIHANDLE hInstall) {
    MessageBoxW(NULL, L"Entry OnInstall ERROR_SUCCESS", L"v{{ VERMSI }}", MB_OK);
    return ERROR_SUCCESS;
}

// DllMain is required for the DLL to be loaded by MSI
BOOL APIENTRY DllMain(HMODULE hModule, DWORD ul_reason_for_call, LPVOID lpReserved) {
    return TRUE;
}
