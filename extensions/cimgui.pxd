# distutils: language = c++
# distutils: include_dirs = imgui-cpp

from libcpp cimport bool

from enums cimport ImGuiKey_


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
        ImVec2        DisplaySize
        float         DeltaTime
        float         IniSavingRate
        const char*   IniFilename
        const char*   LogFilename
        float         MouseDoubleClickTime
        float         MouseDoubleClickMaxDist
        float         MouseDragThreshold
        # note: originally KeyMap[ImGuiKey_COUNT]
        # todo: find a way to access enum var here
        int*          KeyMap
        float         KeyRepeatDelay
        float         KeyRepeatRate
        void*         UserData

        ImFontAtlas*  Fonts
        float         FontGlobalScale
        bool          FontAllowUserScaling
        ImVec2        DisplayFramebufferScale
        ImVec2        DisplayVisibleMin
        ImVec2        DisplayVisibleMax

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

        ImVec2      MousePos
        bool        MouseDown[5]
        float       MouseWheel
        bool        MouseDrawCursor
        bool        KeyCtrl
        bool        KeyShift
        bool        KeyAlt
        bool        KeysDown[512]
        ImWchar     InputCharacters[16+1]

        void        AddInputCharacter(ImWchar c)
        void        AddInputCharactersUTF8(const char* utf8_chars)

        # ====
        # source-note: Output - Retrieve after calling NewFrame(), you can use
        #              them to discard inputs or hide them from the rest of
        #              your application
        bool        WantCaptureMouse
        bool        WantCaptureKeyboard
        bool        WantTextInput
        float       Framerate
        int         MetricsAllocs
        int         MetricsRenderVertices
        int         MetricsRenderIndices
        int         MetricsActiveWindows

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


    ctypedef struct ImGuiStyle:
        pass


    ctypedef void (*ImDrawCallback)(const ImDrawList* parent_list, const ImDrawCmd* cmd)


    ctypedef struct ImDrawCmd:
        unsigned int ElemCount
        ImVec4       ClipRect
        ImTextureID  TextureId
        ImDrawCallback UserCallback
        void*        UserCallbackData


    ctypedef unsigned short ImDrawIdx


    ctypedef struct ImDrawVert:
        ImVec2 pos
        ImVec2 uv
        ImU32  col


    ctypedef struct ImDrawList:
        ImVector[ImDrawCmd]  CmdBuffer
        ImVector[ImDrawIdx]  IdxBuffer
        ImVector[ImDrawVert] VtxBuffer



    ctypedef struct ImDrawData:
        bool            Valid
        ImDrawList**    CmdLists
        int             CmdListsCount
        int             TotalVtxCount
        int             TotalIdxCount
        void            DeIndexAllBuffers()
        void            ScaleClipRects(const ImVec2& sc)

    ctypedef struct ImFontConfig:
        pass

    ctypedef struct ImFont:
        pass

    ctypedef struct ImFontAtlas:
        void*   TexID

        ImFont* AddFontDefault(const ImFontConfig* font_cfg = NULL)
        void    GetTexDataAsAlpha8(unsigned char** out_pixels, int* out_width, int* out_height, int* out_bytes_per_pixel = NULL)
        void    GetTexDataAsRGBA32(unsigned char** out_pixels, int* out_width, int* out_height, int* out_bytes_per_pixel = NULL)

    ctypedef struct ImGuiStorage:
        pass

    ctypedef struct ImGuiStyle:
        pass


cdef extern from "imgui.h" namespace "ImGui":

    # Main
    ImGuiIO&       GetIO()
    ImGuiStyle&    GetStyle()
    ImDrawData*    GetDrawData()
    void           NewFrame()

    # note: Render runs callbacks that may be arbitrary Python code
    #       so we need to propagate exceptions from them
    void           Render() except *

    void           Shutdown()
    void           ShowUserGuide()

    void           ShowStyleEditor(ImGuiStyle* ref)
    void           ShowTestWindow(bool* opened)
    void           ShowTestWindow()
    void           ShowMetricsWindow(bool* opened)
    void           ShowMetricsWindow()

    # Window
    bool           Begin(const char* name, bool* p_open, ImGuiWindowFlags flags)
    bool           Begin(const char* name, bool* p_open)
    bool           Begin(const char* name)

    bool           Begin(const char* name, bool* p_open, const ImVec2& size_on_first_use, float bg_alpha, ImGuiWindowFlags flags)
    bool           Begin(const char* name, bool* p_open, const ImVec2& size_on_first_use, float bg_alpha)
    bool           Begin(const char* name, bool* p_open, const ImVec2& size_on_first_use)

    # defaults: const ImVec2& size = ImVec2(0,0), bool border = false, ImGuiWindowFlags extra_flags)
    bool           BeginChild(const char* str_id, const ImVec2& size, bool border, ImGuiWindowFlags extra_flags)
    bool           BeginChild(const char* str_id, const ImVec2& size, bool border)
    bool           BeginChild(const char* str_id, const ImVec2& size)
    bool           BeginChild(const char* str_id)

    bool           BeginChild(ImGuiID id, const ImVec2& size, bool border, ImGuiWindowFlags extra_flags)
    bool           BeginChild(ImGuiID id, const ImVec2& size, bool border)
    bool           BeginChild(ImGuiID id, const ImVec2& size)
    bool           BeginChild(ImGuiID id)

    void           EndChild()

    void           SetWindowFontScale(float scale)
    ImVec2         GetWindowPos()
    ImVec2         GetWindowSize()
    float          GetWindowWidth()
    float          GetWindowHeight()
    bool           IsWindowCollapsed()

    ## Widgets
    void Text(const char* text)
