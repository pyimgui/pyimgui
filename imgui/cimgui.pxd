# -*- coding: utf-8 -*-
# distutils: language = c++
# distutils: include_dirs = imgui-cpp
"""
Notes:
   `✓` marks API element as already mapped in core bindings.
   `✗` marks API element as "yet to be mapped
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
        ImVec2        DisplaySize  # ✓
        float         DeltaTime  # ✓
        float         IniSavingRate  # ✓
        const char*   IniFilename  # ✓
        const char*   LogFilename  # ✓
        float         MouseDoubleClickTime  # ✓
        float         MouseDoubleClickMaxDist  # ✓
        float         MouseDragThreshold  # ✓
        # note: originally KeyMap[ImGuiKey_COUNT]
        # todo: find a way to access enum var here
        int*          KeyMap
        float         KeyRepeatDelay  # ✓
        float         KeyRepeatRate  # ✓
        void*         UserData

        ImFontAtlas*  Fonts  # ✓
        float         FontGlobalScale  # ✓
        bool          FontAllowUserScaling  # ✓
        ImVec2        DisplayFramebufferScale  # ✓
        ImVec2        DisplayVisibleMin  # ✓
        ImVec2        DisplayVisibleMax  # ✓

        # ====
        # source-note: User Functions
        # note: callbacks may wrap arbitrary Python code so we need to
        #       propagate exceptions from them (as well as C++ exceptions)
        void        (*RenderDrawListsFn)(ImDrawData* data) except +  # ✗
        const char* (*GetClipboardTextFn)() except +  # ✗
        void        (*SetClipboardTextFn)(const char* text) except +  # ✗

        void*       (*MemAllocFn)(size_t sz)  # ✗
        void        (*MemFreeFn)(void* ptr)  # ✗
        void        (*ImeSetInputScreenPosFn)(int x, int y) except +  # ✗
        void*       ImeWindowHandle  # ✗

        # ====
        # source-note: Input - Fill before calling NewFrame()

        ImVec2      MousePos  # ✓
        bool        MouseDown[5]  # ✓
        float       MouseWheel  # ✓
        bool        MouseDrawCursor  # ✓
        bool        KeyCtrl  # ✓
        bool        KeyShift  # ✓
        bool        KeyAlt  # ✓
        bool        KeySuper  # ✓
        bool        KeysDown[512]  # ✓
        ImWchar     InputCharacters[16+1]  # ✗

        void        AddInputCharacter(ImWchar c)  # ✓
        void        AddInputCharactersUTF8(const char* utf8_chars)  # ✗
        void        ClearInputCharacters()  # ✗

        # ====
        # source-note: Output - Retrieve after calling NewFrame(), you can use
        #              them to discard inputs or hide them from the rest of
        #              your application
        bool        WantCaptureMouse  # ✓
        bool        WantCaptureKeyboard  # ✓
        bool        WantTextInput  # ✓
        float       Framerate  # ✓
        int         MetricsAllocs  # ✓
        int         MetricsRenderVertices  # ✓
        int         MetricsRenderIndices  # ✓
        int         MetricsActiveWindows  # ✓

        # ====
        # source-note: [Internal] ImGui will maintain those fields for you
        ImVec2      MousePosPrev  # ✗
        ImVec2      MouseDelta  # ✗
        bool        MouseClicked[5]  # ✗
        ImVec2      MouseClickedPos[5]  # ✗
        float       MouseClickedTime[5]  # ✗
        bool        MouseDoubleClicked[5]  # ✗
        bool        MouseReleased[5]  # ✗
        bool        MouseDownOwned[5]  # ✗
        float       MouseDownDuration[5]  # ✗
        float       MouseDownDurationPrev[5]  # ✗
        float       MouseDragMaxDistanceSqr[5]  # ✗
        float       KeysDownDuration[512]  # ✗
        float       KeysDownDurationPrev[512]  # ✗


    cdef cppclass ImVector[T]:
        int        Size
        int        Capacity
        T*         Data


    ctypedef void (*ImDrawCallback)(const ImDrawList* parent_list, const ImDrawCmd* cmd)  # ✗


    ctypedef struct ImDrawCmd:  # ✓
        unsigned int   ElemCount  # ✓
        ImVec4         ClipRect  # ✓
        ImTextureID    TextureId  # ✓
        ImDrawCallback UserCallback  # ✗
        void*          UserCallbackData  # ✗


    ctypedef unsigned short ImDrawIdx


    ctypedef struct ImDrawVert:  # ✗
        ImVec2 pos  # ✗
        ImVec2 uv  # ✗
        ImU32  col  # ✗


    ctypedef struct ImDrawList:
        # we mapp only buffer vectors since everything else is internal
        # and right now we dont want to suport it.
        ImVector[ImDrawCmd]  CmdBuffer  # ✓
        ImVector[ImDrawIdx]  IdxBuffer  # ✓
        ImVector[ImDrawVert] VtxBuffer  # ✓


    ctypedef struct ImDrawData:  # ✓
        bool            Valid  # ✓
        ImDrawList**    CmdLists  # ✓
        int             CmdListsCount  # ✓
        int             TotalVtxCount  # ✓
        int             TotalIdxCount  # ✓
        void            DeIndexAllBuffers()  # ✓
        void            ScaleClipRects(const ImVec2&)  # ✓

    ctypedef struct ImFontConfig:
        pass

    ctypedef struct ImFont:
        pass

    ctypedef struct ImFontAtlas:  # ✓
        void*   TexID  # ✓

        ImFont* AddFontDefault(const ImFontConfig* = NULL)  # ✓
        void GetTexDataAsAlpha8(unsigned char**, int*, int*, int* = NULL)  # ✓
        void GetTexDataAsRGBA32(unsigned char**, int*, int*, int* = NULL)  # ✓

    ctypedef struct ImGuiStorage:
        pass

    cdef cppclass ImGuiStyle:
        float       Alpha  # ✓
        ImVec2      WindowPadding  # ✓
        ImVec2      WindowMinSize  # ✓
        float       WindowRounding  # ✓
        ImVec2      WindowTitleAlign  # ✓
        float       ChildWindowRounding  # ✓
        ImVec2      FramePadding  # ✓
        float       FrameRounding  # ✓
        ImVec2      ItemSpacing  # ✓
        ImVec2      ItemInnerSpacing  # ✓
        ImVec2      TouchExtraPadding  # ✓
        float       IndentSpacing  # ✓
        float       ColumnsMinSpacing  # ✓
        float       ScrollbarSize  # ✓
        float       ScrollbarRounding  # ✓
        float       GrabMinSize  # ✓
        float       GrabRounding  # ✓
        ImVec2      ButtonTextAlign  # ✓
        ImVec2      DisplayWindowPadding  # ✓
        ImVec2      DisplaySafeAreaPadding  # ✓
        bool        AntiAliasedLines  # ✓
        bool        AntiAliasedShapes  # ✓
        float       CurveTessellationTol  # ✓

        # note: originally Colors[ImGuiCol_COUNT]
        # todo: find a way to access enum var here
        ImVec4*     Colors

    ctypedef struct ImGuiContext:
        pass

cdef extern from "imgui.h" namespace "ImGui":

    # Main
    ImGuiIO& GetIO()  # ✓
    ImGuiStyle& GetStyle()  # ✗
    ImDrawData* GetDrawData()  # ✗
    void NewFrame()  # ✓

    # note: Render runs callbacks that may be arbitrary Python code
    #       so we need to propagate exceptions from them
    void Render() except +  # ✓

    void Shutdown()  # ✓
    void ShowUserGuide()  # ✓

    void ShowStyleEditor(ImGuiStyle*)  # ✓
    void ShowStyleEditor()  # ✓

    void ShowTestWindow(bool*)  # ✓
    void ShowTestWindow()  # ✓

    void ShowMetricsWindow(bool*)  # ✓
    void ShowMetricsWindow()  # ✓

    # Window
    bool Begin(const char*, bool*, ImGuiWindowFlags)  # ✓
    bool Begin(const char*, bool*)  # ✓
    bool Begin(const char*)  # ✓

    # note: following API was deprecated
    # bool Begin(const char*, bool*, const ImVec2&, float, ImGuiWindowFlags)  # ✗
    # bool Begin(const char*, bool*, const ImVec2&, float)  # ✗
    # bool Begin(const char*, bool*, const ImVec2&)  # ✗

    void End()  # ✓

    # defaults: const ImVec2& size = ImVec2(0,0), bool border = false, ImGuiWindowFlags extra_flags)
    bool BeginChild(const char*, const ImVec2&, bool, ImGuiWindowFlags)  # ✗
    bool BeginChild(const char*, const ImVec2&, bool)  # ✓
    bool BeginChild(const char*, const ImVec2&)  # ✓
    bool BeginChild(const char*)  # ✓

    bool BeginChild(ImGuiID, const ImVec2&, bool, ImGuiWindowFlags)  # ✗
    bool BeginChild(ImGuiID, const ImVec2&, bool)  # ✓
    bool BeginChild(ImGuiID, const ImVec2&)  # ✓
    bool BeginChild(ImGuiID)  # ✓

    void EndChild()  # ✓

    ImVec2 GetContentRegionMax()  # ✗
    ImVec2 GetContentRegionAvail()  # ✗
    float GetContentRegionAvailWidth()  # ✗
    ImVec2 GetWindowContentRegionMin()  # ✗
    ImVec2 GetWindowContentRegionMax()  # ✗
    float GetWindowContentRegionWidth()  # ✗
    ImDrawList* GetWindowDrawList()  # ✗
    ImVec2 GetWindowPos()  # ✓
    ImVec2 GetWindowSize()  # ✓
    float GetWindowWidth()  # ✓
    float GetWindowHeight()  # ✓
    bool IsWindowCollapsed()  # ✗
    void SetWindowFontScale(float scale)  # ✗

    void SetNextWindowPos(  # ✓ note: overrides ommited
            const ImVec2& pos,
            # note: with defaults
            ImGuiSetCond cond
    )
    void SetNextWindowPosCenter(  # ✓ note: overrides ommited
            # note: with defaults
            ImGuiSetCond cond
    )
    void SetNextWindowSize(  # ✓ note: overrides ommited
            const ImVec2& size,
            # note: with defaults
            ImGuiSetCond cond
    )

    # void SetNextWindowSizeConstraints(const ImVec2& size_min, const ImVec2& size_max, ImGuiSizeConstraintCallback custom_callback, void* custom_callback_data)  # ✗

    void SetNextWindowContentSize(const ImVec2& size)  # ✗
    void SetNextWindowContentWidth(float width)  # ✗
    void SetNextWindowCollapsed(  # ✗
            bool collapsed,
            # note: with defaults
            ImGuiSetCond cond
    )

    void SetNextWindowFocus()  # ✗
    void SetWindowPos(  # ✗
            const ImVec2& pos,
            # note: with defaults
            ImGuiSetCond cond
    )
    void SetWindowSize(  # ✗
            const ImVec2& size,
            # note: with defaults
            ImGuiSetCond cond
    )
    void SetWindowCollapsed(  # ✗
            bool collapsed,
            # note: with defaults
            ImGuiSetCond cond
    )
    void SetWindowFocus()  # ✗
    void SetWindowPos(  # ✗
            const char* name, const ImVec2& pos,
            # note: with defaults
            ImGuiSetCond cond
    )
    void SetWindowSize(  # ✗
            const char* name, const ImVec2& size, ImGuiSetCond
            cond
    )
    void SetWindowCollapsed(  # ✗
            const char* name, bool collapsed,
            # note: with defaults
            ImGuiSetCond cond
    )
    void SetWindowFocus(const char* name)  # ✗

    void SetWindowFontScale(float)  # ✓
    ImVec2 GetWindowPos()  # ✓
    ImVec2 GetWindowSize()  # ✓
    float GetWindowWidth()  # ✓
    float GetWindowHeight()  # ✓
    bool IsWindowCollapsed()  # ✓

    # Widgets
    # Widgets: text
    void Text(const char*)  # ✓
    void TextColored(const ImVec4&, const char*)  # ✓
    void TextDisabled(const char*)  # ✗
    void TextWrapped(const char*)  # ✗
    void TextUnformatted(const char*)  # ✗
    void LabelText(const char*, const char*)  # ✓
    void Bullet()  # ✓
    void BulletText(const char*)  # ✓

    # Widgets: buttons
    bool Button(const char*, const ImVec2& size)  # ✓
    bool Button(const char*)  # ✓
    bool SmallButton(const char*)  # ✓
    bool InvisibleButton(const char*, const ImVec2& size)  # ✓
    bool ImageButton(  # ✓
            ImTextureID user_texture_id, const ImVec2& size,
            # note: with defaults
            const ImVec2& uv0, const ImVec2& uv1, int frame_padding,
            const ImVec4& bg_col, const ImVec4& tint_col
    )
    
    bool ColorButton(  # ✓
            const ImVec4& col,
            # note: with defaults
            bool small_height, bool outline_border
    )

    # Widgets: images
    void Image(  # ✓
            ImTextureID user_texture_id, const ImVec2& size,
            # note: with defaults
            const ImVec2& uv0, const ImVec2& uv1, const ImVec4& tint_col,
            const ImVec4& border_col
    )                           
    # Widgets: checkboxes etc.
    bool Checkbox(const char* label, bool* v)  # ✗
    bool CheckboxFlags(
            const char* label, unsigned int* flags, unsigned int flags_value
    )  # ✗
    bool RadioButton(const char* label, bool active)  # ✗
    bool RadioButton(const char* label, int* v, int v_button)  # ✗
    # Widgets: combos
    bool Combo(  # ✗
            const char* label, int* current_item,
            const char** items, int items_count,
            # note: with defaults
            int height_in_items
    )
    bool Combo(  # ✗
            const char* label, int* current_item,
            const char* items_separated_by_zeros,
            # note: with defaults
            int height_in_items
    )
    bool Combo(  # ✗
            const char* label, int* current_item,
            bool (*items_getter)(void* data, int idx,
            const char** out_text), void* data, int items_count,
            # note: with defaults
            int height_in_items
    )
    # Widgets: color-edits
    bool ColorEdit3(const char* label, float col[3])  # ✗
    bool ColorEdit4(  # ✗
            const char* label, float col[4],
            # note: with defaults
            bool show_alpha
    )
    #void ColorEditMode(ImGuiColorEditMode mode)  # note: obsoleted

    # Widgets: plots
    void PlotLines(  # ✗
            const char* label, const float* values, int values_count,
            # note: with defaults
            int values_offset, const char* overlay_text,
            float scale_min, float scale_max, ImVec2 graph_size, int stride
    )
    void PlotLines(  # ✗
            const char* label, float (*values_getter)(void* data, int idx),
            void* data, int values_count,
            # note: with defaults
            int values_offset, const char* overlay_text, float scale_min,
            float scale_max, ImVec2 graph_size
    )

    void PlotHistogram(  # ✗
            const char* label, const float* values, int values_count,
            # note: with defaults
            int values_offset, const char* overlay_text, float scale_min,
            float scale_max, ImVec2 graph_size, int stride
    )
    void PlotHistogram(  # ✗
            const char* label, float (*values_getter)(void* data, int idx),
            void* data, int values_count,
            # note: with defaults
            int values_offset, const char* overlay_text, float scale_min,
            float scale_max, ImVec2 graph_size
    )
    void ProgressBar(  # ✗
            float fraction,
            # note: with defaults
            const ImVec2& size_arg, const char* overlay
    )

    # Parameters stacks (shared)
    void PushFont(ImFont*)  # ✗
    void PopFont()  # ✗

    void PushStyleColor(ImGuiCol, const ImVec4&)  # ✗
    void PopStyleColor(int)  # ✗

    void PushStyleVar(ImGuiStyleVar, float) except +  # ✓
    void PushStyleVar(ImGuiStyleVar, const ImVec2&) except +  # ✓

    void PopStyleVar(int) except +  # ✓

    ImFont* GetFont()  # ✗
    float GetFontSize()  # ✗

    ImVec2 GetFontTexUvWhitePixel()  # ✗

    ImU32 GetColorU32(ImGuiCol, float)  # ✗
    ImU32 GetColorU32(const ImVec4& col)  # ✗
