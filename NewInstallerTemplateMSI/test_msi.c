#define WIN32_LEAN_AND_MEAN
#include "Windows.h"

#include <msi.h>
#include <msiquery.h>

#include <stdio.h>



typedef UINT (__stdcall *OnInstall_ptr)(MSIHANDLE hInstall);
typedef UINT (__stdcall *OnUnInstall_ptr)(MSIHANDLE hInstall);



int main()
{
    HMODULE hMod = LoadLibraryW(L"{{ CUSTOM_DLL_NAME }}.dll");

    if (hMod)
    {
        UINT res_OnInstall = ERROR_SUCCESS;
        OnInstall_ptr OnInstall_fp = (OnInstall_ptr)GetProcAddress(hMod, "OnInstall");

        if (OnInstall_fp)
        {
            res_OnInstall = OnInstall_fp((MSIHANDLE)0);

            if (res_OnInstall != ERROR_SUCCESS) {
                return res_OnInstall;
            }
        }

        UINT res_OnUnInstall = ERROR_SUCCESS;
        OnUnInstall_ptr OnUnInstall_fp = (OnUnInstall_ptr)GetProcAddress(hMod, "OnUnInstall");

        if (OnUnInstall_fp)
        {
            res_OnUnInstall = OnUnInstall_fp((MSIHANDLE)0);

            if (res_OnUnInstall != ERROR_SUCCESS) {
                return res_OnUnInstall;
            }
        }

        return 0;
    }

    return __LINE__;
}
