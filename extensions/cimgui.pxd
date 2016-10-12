# -*- coding: utf-8 -*-
# distutils: language = c++
# distutils: include_dirs = imgui-cpp
"""
Notes: `✓` marks API element as already mapped in core bindings.
"""
from libcpp cimport bool

from enums cimport ImGuiKey_, ImGuiCol_


cdef extern from "imgui.h":
    # ====
    # Various int typedefs and enumerations
    ctypedef void* ImTextureID
    ctypedef unsigned int ImU32
    ctypedef unsigned int ImGuiID
    ctypedef unsigned short ImWchar
    ctypedef int ImGuiCol
    ctypedef int ImGuiStyleVar
    ctypedef int ImGuiKey
    ctypedef int ImGuiAlign
    ctypedef int ImGuiColorEditMode
    ctypedef int ImGuiMouseCursor
    ctypedef int ImGuiWindowFlags
    ctypedef int ImGuiSetCond
    ctypedef int ImGuiInputTextFlags
    ctypedef int ImGuiSelectableFlags
    ctypedef int ImGuiTreeNodeFlags

    ctypedef struct ImVec2:
        float x
        float y

    ctypedef struct ImVec4:
        float x
        float y
        float z
        float w


    ctypedef struct ImGuiIO:
        # ====
        # source-note: Settings (fill once)
        ImVec2        DisplaySize              # ✓
        float         DeltaTime                # ✓
        float         IniSavingRate            # ✓
        const char*   IniFilename              # ✓
        const char*   LogFilename              # ✓
        float         MouseDoubleClickTime     # ✓
        float         MouseDoubleClickMaxDist  # ✓
        float         MouseDragThreshold       # ✓
        # note: originally KeyMap[ImGuiKey_COUNT]
        # todo: find a way to access enum var here
        int*          KeyMap
        float         KeyRepeatDelay           # ✓
        float         KeyRepeatRate            # ✓
        void*         UserData

        ImFontAtlas*  Fonts                    # ✓
        float         FontGlobalScale          # ✓
        bool          FontAllowUserScaling     # ✓
        ImVec2        DisplayFramebufferScale  # ✓
        ImVec2        DisplayVisibleMin        # ✓
        ImVec2        DisplayVisibleMax        # ✓

        # ====
        # source-note: User Functions
        # note: callbacks may wrap arbitrary Python code
        #       so we need to propagate exceptions from them
        void        (*RenderDrawListsFn)(ImDrawData* data) except *
        const char* (*GetClipboardTextFn)() except *
        void        (*SetClipboardTextFn)(const char* text) except *

        void*       (*MemAllocFn)(size_t sz)
        void        (*MemFreeFn)(void* ptr)
        void        (*ImeSetInputScreenPosFn)(int x, int y) except *
        void*       ImeWindowHandle

        # ====
        # source-note: Input - Fill before calling NewFrame()

        ImVec2      MousePos                   # ✓
        bool        MouseDown[5]               # ✓
        float       MouseWheel                 # ✓
        bool        MouseDrawCursor            # ✓
        bool        KeyCtrl                    # ✓
        bool        KeyShift                   # ✓
        bool        KeyAlt                     # ✓
        bool        KeysDown[512]
        ImWchar     InputCharacters[16+1]

        void        AddInputCharacter(ImWchar c)
        void        AddInputCharactersUTF8(const char* utf8_chars)

        # ====
        # source-note: Output - Retrieve after calling NewFrame(), you can use
        #              them to discard inputs or hide them from the rest of
        #              your application
        bool        WantCaptureMouse           # ✓
        bool        WantCaptureKeyboard        # ✓
        bool        WantTextInput              # ✓
        float       Framerate                  # ✓
        int         MetricsAllocs              # ✓
        int         MetricsRenderVertices      # ✓
        int         MetricsRenderIndices       # ✓
        int         MetricsActiveWindows       # ✓

        # ====
        # source-note: [Internal] ImGui will maintain those fields for you
        ImVec2      MousePosPrev
        ImVec2      MouseDelta
        bool        MouseClicked[5]
        ImVec2      MouseClickedPos[5]
        float       MouseClickedTime[5]
        bool        MouseDoubleClicked[5]
        bool        MouseReleased[5]
        bool        MouseDownOwned[5]
        float       MouseDownDuration[5]
        float       MouseDownDurationPrev[5]
        float       MouseDragMaxDistanceSqr[5]
        float       KeysDownDuration[512]
        float       KeysDownDurationPrev[512]


    cdef cppclass ImVector[T]:
        int        Size
        int        Capacity
        T*         Data


    ctypedef void (*ImDrawCallback)(const ImDrawList* parent_list, const ImDrawCmd* cmd)


    ctypedef struct ImDrawCmd:
        unsigned int   ElemCount               # ✓
        ImVec4         ClipRect                # ✓
        ImTextureID    TextureId               # ✓
        ImDrawCallback UserCallback
        void*          UserCallbackData


    ctypedef unsigned short ImDrawIdx


    ctypedef struct ImDrawVert:
        ImVec2 pos
        ImVec2 uv
        ImU32  col


    ctypedef struct ImDrawList:
        # we mapp only buffer vectors since everything else is internal
        # and right now we dont want to suport it.
        ImVector[ImDrawCmd]  CmdBuffer         # ✓
        ImVector[ImDrawIdx]  IdxBuffer         # ✓
        ImVector[ImDrawVert] VtxBuffer         # ✓


    ctypedef struct ImDrawData:
        bool            Valid                          # ✓
        ImDrawList**    CmdLists                       # ✓
        int             CmdListsCount                  # ✓
        int             TotalVtxCount                  # ✓
        int             TotalIdxCount                  # ✓
        void            DeIndexAllBuffers()            # ✓
        void            ScaleClipRects(const ImVec2&)  # ✓

    ctypedef struct ImFontConfig:
        pass

    ctypedef struct ImFont:
        pass

    ctypedef struct ImFontAtlas:
        void*   TexID                                                         # ✓

        ImFont* AddFontDefault(const ImFontConfig* = NULL)                    # ✓
        void    GetTexDataAsAlpha8(unsigned char**, int*, int*, int* = NULL)  # ✓
        void    GetTexDataAsRGBA32(unsigned char**, int*, int*, int* = NULL)  # ✓

    ctypedef struct ImGuiStorage:
        pass

    cdef cppclass ImGuiStyle:
        float       Alpha                      # ✓
        ImVec2      WindowPadding              # ✓
        ImVec2      WindowMinSize              # ✓
        float       WindowRounding             # ✓
        ImVec2      WindowTitleAlign           # ✓
        float       ChildWindowRounding        # ✓
        ImVec2      FramePadding               # ✓
        float       FrameRounding              # ✓
        ImVec2      ItemSpacing                # ✓
        ImVec2      ItemInnerSpacing           # ✓
        ImVec2      TouchExtraPadding          # ✓
        float       IndentSpacing              # ✓
        float       ColumnsMinSpacing          # ✓
        float       ScrollbarSize              # ✓
        float       ScrollbarRounding          # ✓
        float       GrabMinSize                # ✓
        float       GrabRounding               # ✓
        ImVec2      ButtonTextAlign            # ✓
        ImVec2      DisplayWindowPadding       # ✓
        ImVec2      DisplaySafeAreaPadding     # ✓
        bool        AntiAliasedLines           # ✓
        bool        AntiAliasedShapes          # ✓
        float       CurveTessellationTol       # ✓

        # note: originally Colors[ImGuiCol_COUNT]
        # todo: find a way to access enum var here
        ImVec4*     Colors


cdef extern from "imgui.h" namespace "ImGui":

    # Main
    ImGuiIO&       GetIO()                      # ✓
    ImGuiStyle&    GetStyle()
    ImDrawData*    GetDrawData()
    void           NewFrame()                   # ✓

    # note: Render runs callbacks that may be arbitrary Python code
    #       so we need to propagate exceptions from them
    void           Render() except *            # ✓

    void           Shutdown()                   # ✓
    void           ShowUserGuide()              # ✓

    void           ShowStyleEditor(ImGuiStyle*) # ✓
    void           ShowStyleEditor()            # ✓

    void           ShowTestWindow(bool*)        # ✓
    void           ShowTestWindow()             # ✓

    void           ShowMetricsWindow(bool*)     # ✓
    void           ShowMetricsWindow()          # ✓

    # Window
    bool           Begin(const char*, bool*, ImGuiWindowFlags) # ✓
    bool           Begin(const char*, bool*)                   # ✓
    bool           Begin(const char*)                          # ✓

    # note: following API was deprecated
    # bool           Begin(const char*, bool*, const ImVec2&, float, ImGuiWindowFlags)
    # bool           Begin(const char*, bool*, const ImVec2&, float)
    # bool           Begin(const char*, bool*, const ImVec2&)

    void           End()                       # ✓

    # defaults: const ImVec2& size = ImVec2(0,0), bool border = false, ImGuiWindowFlags extra_flags)
    bool           BeginChild(const char*, const ImVec2&, bool, ImGuiWindowFlags)  # ✓
    bool           BeginChild(const char*, const ImVec2&, bool)                    # ✓
    bool           BeginChild(const char*, const ImVec2&)                          # ✓
    bool           BeginChild(const char*)                                         # ✓

    bool           BeginChild(ImGuiID, const ImVec2&, bool, ImGuiWindowFlags)      # ✓
    bool           BeginChild(ImGuiID, const ImVec2&, bool)                        # ✓
    bool           BeginChild(ImGuiID, const ImVec2&)                              # ✓
    bool           BeginChild(ImGuiID)                                             # ✓

    void           EndChild()                                                      # ✓

    void           SetWindowFontScale(float)   # ✓
    ImVec2         GetWindowPos()              # ✓
    ImVec2         GetWindowSize()             # ✓
    float          GetWindowWidth()            # ✓
    float          GetWindowHeight()           # ✓
    bool           IsWindowCollapsed()         # ✓

    ## Widgets
    void          Text(const char*)                        # ✓
    void          TextColored(const ImVec4&, const char*)  # ✓
