/* Copyright (C) 2019 Marcos Slomp - All Rights Reserved
 * You may use, distribute and modify this code under the
 * terms of the MIT license.
 */

#ifndef _RENDERDOC_GLUE_H_
#define _RENDERDOC_GLUE_H_

// Before including this header, you may wish to:
// #define RENDERDOC_ENABLED       : to either (0) or (1); if not specified, defaults to (1) -- enabled
// #define RENDERDOC_PATH          : to the location of RenderDoc (DO NOT enclose the path with quotes...);
//                                   defaults to a hard-coded location on my development environment!
// #define RENDERDOC_STDOUT        : to the stream object used for logging messages, warnings and errors
// #define RENDERDOC_CAPTURE_PATH  : to the location where you would like to save the captures; defaults to
//                                   a "RenderDocCaptures" folder relative to the path of this header file
//
// You may also override the following macros:
// RenderDocAssert(exrp)
// RENDERDOC_LIB
// LoadRenderDocLibrary(lib_name)  : takes a (const char*) library filename (full path)
//                                   and returns a (void*) library handle
// GetRenderDocProcAddr(dll,proc)  : takes a (void*) library handle and a (const char*) proc name
//                                   and returns a (void*) proc address

#ifndef RENDERDOC_ENABLED
#define RENDERDOC_ENABLED (1)
#endif//RENDERDOC_ENABLED

#if RENDERDOC_ENABLED

#ifndef RENDERDOC_PATH
#define RENDERDOC_PATH <path-to-renderdoc>
#endif//RENDERDOC_PATH

#ifndef RENDERDOC_CAPTURE_PATH
#define RENDERDOC_CAPTURE_PATH __FILE__ "/../RenderDocCaptures/capture"
#endif//RENDERDOC_CAPTURE_PATH

#ifndef RENDERDOC_AUTOINIT
#define RENDERDOC_AUTOINIT (1)
#endif//RENDERDOC_AUTOINIT

#ifndef RenderDocAssert
    #include <cassert>
    #define RenderDocAssert(expr) assert(expr)
#endif

#ifndef RenderDocPrint
    #include <stdio.h>
    #define RenderDocPrint(msg)                 printf("%s", msg)
#endif//RenderDocPrint

#ifndef RENDERDOC_LIB
    #ifdef _WIN32
        #define RENDERDOC_LIB                   renderdoc.dll
    #else
        // TODO: implement for Linux
        #define RENDERDOC_LIB                   RenderDocAssert(false)
    #endif
#endif//RENDERDOC_LIB

#ifndef LoadRenderDocLibrary
    #ifdef _WIN32
        #include <Windows.h>
        #define LoadRenderDocLibrary(dll)       (void*)LoadLibrary( TEXT(dll) )
    #else
        // TODO: implement for Linux
        #define LoadRenderDocLibrary(dll)       RenderDocAssert(false)
    #endif
#endif//RENDERDOC_LIB

#ifndef GetRenderDocProcAddr
    #ifdef _WIN32
        #include <Windows.h>
        #define GetRenderDocProcAddr(dll,proc)  GetProcAddress((HMODULE)dll, proc)
    #else
        // TODO: implement for Linux
        #define GetRenderDocProcAddr(dll,proc)  RenderDocAssert(false)
    #endif
#endif//RENDERDOC_LIB

#ifndef XSTR
#define XSTR(x) #x
#endif//XSTR

#ifndef STR
#define STR(x) XSTR(x)
#endif//XSTR

#include STR(RENDERDOC_PATH/renderdoc_app.h)

typedef RENDERDOC_API_1_0_0 RENDERDOC_API_CONTEXT;
static RENDERDOC_API_CONTEXT* RenderDocAPI = /*nullptr*/ NULL;

#include <stdio.h>  // sprintf_s
static void RenderDocPrintHandle(void* p)
{
    // TODO: sprintf_s is overkill/invasive here...
    char text [sizeof(void*) * 4] = { 0 };
    sprintf_s(text, sizeof(text), "%p", p);
    RenderDocPrint(text);
}

static bool InitRenderDoc()
{
    // already initialized?
    if (RenderDocAPI)
    {
        return(true);
    }

    /*auto*/ void* hRenderDocLib = LoadRenderDocLibrary( STR(RENDERDOC_PATH/RENDERDOC_LIB) );
    RenderDocAssert(hRenderDocLib);
    RenderDocPrint("RenderDocGlue: Loaded runtime library 'renderdoc.dll' at location ");
    RenderDocPrintHandle(hRenderDocLib);
    RenderDocPrint("\n");
    pRENDERDOC_GetAPI RENDERDOC_GetAPI = (pRENDERDOC_GetAPI)GetRenderDocProcAddr(hRenderDocLib, "RENDERDOC_GetAPI");
    RenderDocAssert(RENDERDOC_GetAPI);

    /*auto*/ int status = RENDERDOC_GetAPI(eRENDERDOC_API_Version_1_0_0, (void**)&RenderDocAPI);
    RenderDocAssert(1 == status);
    RenderDocAssert(RenderDocAPI);

    const char* CaptureSaveLocation = RENDERDOC_CAPTURE_PATH;
    RenderDocAPI->SetLogFilePathTemplate(CaptureSaveLocation);
    RenderDocAPI->SetFocusToggleKeys(NULL, 0);
    RenderDocAPI->SetCaptureKeys(NULL, 0);
    RenderDocAPI->MaskOverlayBits(eRENDERDOC_Overlay_None, eRENDERDOC_Overlay_None);
    int result = 1;
    result &= RenderDocAPI->SetCaptureOptionU32(eRENDERDOC_Option_CaptureCallstacks, false);
    result &= RenderDocAPI->SetCaptureOptionU32(eRENDERDOC_Option_RefAllResources,   true);
    result &= RenderDocAPI->SetCaptureOptionU32(eRENDERDOC_Option_SaveAllInitials,   true);
    //result &= RenderDocAPI->SetCaptureOptionU32(eRENDERDOC_Option_HookIntoChildren,  true);
    RenderDocAssert(result == 1);

    return(true);
}

// auto-init RenderDoc as soon as the program is executed:
#if RENDERDOC_AUTOINIT
static const bool bRenderDocInitialized = InitRenderDoc();
#endif

static void StartCapturingGPUActivity(void* device = NULL)
{
    RenderDocAPI->StartFrameCapture(device, NULL);
}

static void FinishCapturingGPUActivity(void* device = NULL)
{
    RenderDocAPI->EndFrameCapture(device, NULL);

    // find the latest capture and launch it with the RenderDoc UI:
    // (Beware! Here There be Dragons! Pretty darn horrendous API...)
    static const int LogFileMaxLen = 512;
    char LogFileBuffers [2][LogFileMaxLen] = { { } };

    const char* NewestCapture = /*nullptr*/ NULL;
    for (uint32_t Index = 0; ; ++Index)
    {
        uint64_t Timestamp = 0;
        uint32_t LogFileLen = LogFileMaxLen;
        char* LogFile = LogFileBuffers[Index % 2];
        /*auto*/ unsigned int result = RenderDocAPI->GetCapture(Index, LogFile, &LogFileLen, &Timestamp);
        bool HasCapture = (0 != result);
        if (!HasCapture)
        {
            break;
        }
        NewestCapture = LogFile;
    }

    if (NewestCapture)
    {
        RenderDocPrint("RenderDocGlue: frame captured to file '");
        RenderDocPrint(NewestCapture);
        RenderDocPrint("'\n");
        if (!RenderDocAPI->IsRemoteAccessConnected())
        {
            RenderDocAPI->LaunchReplayUI(false, NewestCapture);
        }
    }
}

#else

static void StartCapturingGPUActivity()  { }
static void FinishCapturingGPUActivity() { }

#endif//DEBUG_WITH_RENDERDOC

#endif//_RENDERDOC_GLUE_H_
