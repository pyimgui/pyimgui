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
    # Forward declarations
    ctypedef struct ImDrawChannel
    ctypedef struct ImDrawCmd
    ctypedef struct ImDrawData
    ctypedef struct ImDrawList
    ctypedef struct ImDrawVert
    ctypedef struct ImFont
    ctypedef struct ImFontAtlas
    ctypedef struct ImFontConfig
    ctypedef struct ImColor
    ctypedef struct ImGuiIO
    ctypedef struct ImGuiOnceUponAFrame
    ctypedef struct ImGuiStorage
    # ctypedef struct ImGuiStyle  # declared later
    ctypedef struct ImGuiTextFilter
    ctypedef struct ImGuiTextBuffer
    ctypedef struct ImGuiTextEditCallbackData
    ctypedef struct ImGuiSizeConstraintCallbackData
    ctypedef struct ImGuiListClipper
    ctypedef struct ImGuiContext

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
    ctypedef int (*ImGuiTextEditCallback)(ImGuiTextEditCallbackData *data);
    ctypedef void (*ImGuiSizeConstraintCallback)(ImGuiSizeConstraintCallbackData* data);

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

        void*       (*MemAllocFn)(size_t sz) except +  # ✗
        void        (*MemFreeFn)(void* ptr) except +  # ✗
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

        void        AddInputCharacter(ImWchar c) except +  # ✓
        void        AddInputCharactersUTF8(const char* utf8_chars) except +  # ✗
        void        ClearInputCharacters() except +  # ✗

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
        void            DeIndexAllBuffers() except +  # ✓
        void            ScaleClipRects(const ImVec2&) except +  # ✓

    ctypedef struct ImFontConfig:
        pass

    ctypedef struct ImFont:
        pass

    ctypedef struct ImFontAtlas:  # ✓
        void*   TexID  # ✓

        ImFont* AddFontDefault(  # ✓
                   # note: optional
                   const ImFontConfig* font_cfg
        ) except +
        ImFont* AddFontFromFileTTF(  # ✓
                    const char* filename, float size_pixels,
                    # note: optional
                    const ImFontConfig* font_cfg,
                    const ImWchar* glyph_ranges
        ) except +
        void GetTexDataAsAlpha8(unsigned char**, int*, int*, int* = NULL) except +  # ✓
        void GetTexDataAsRGBA32(unsigned char**, int*, int*, int* = NULL) except +  # ✓

        void ClearTexData() except +  # ✓
        void ClearInputData() except +  # ✓
        void ClearFonts() except +  # ✓
        void Clear() except +  # ✓

        const ImWchar* GetGlyphRangesDefault() except +  # ✓
        const ImWchar* GetGlyphRangesKorean() except +  # ✓
        const ImWchar* GetGlyphRangesJapanese() except +  # ✓
        const ImWchar* GetGlyphRangesChinese() except +  # ✓
        const ImWchar* GetGlyphRangesCyrillic() except +  # ✓


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
    # ====
    # Main
    ImGuiIO& GetIO()  # ✓
    ImGuiStyle& GetStyle() except +  # ✗
    ImDrawData* GetDrawData() except +  # ✓
    void NewFrame() except +  # ✓
    # note: Render runs callbacks that may be arbitrary Python code
    #       so we need to propagate exceptions from them
    void Render() except +  # ✓
    void Shutdown() except +  # ✓
    void ShowUserGuide() except +  # ✓
    void ShowStyleEditor(ImGuiStyle*) except +  # ✓
    void ShowStyleEditor() except +  # ✓
    void ShowTestWindow(bool*) except +  # ✓
    void ShowTestWindow() except +  # ✓
    void ShowMetricsWindow(bool*) except +  # ✓
    void ShowMetricsWindow() except +  # ✓

    # ====
    # Window
    bool Begin(const char*, bool*, ImGuiWindowFlags) except + # ✓
    # note: following API was deprecated
    # bool Begin(const char*, bool*, const ImVec2&, float, ImGuiWindowFlags)
    void End() except +  # ✓
    bool BeginChild(const char*, const ImVec2&, bool, ImGuiWindowFlags) except +  # ✓
    bool BeginChild(const char*, const ImVec2&, bool) except +  # ✓
    bool BeginChild(const char*, const ImVec2&) except +  # ✓
    bool BeginChild(const char*) except +  # ✓
    bool BeginChild(ImGuiID, const ImVec2&, bool, ImGuiWindowFlags) except +  # ✓
    bool BeginChild(ImGuiID, const ImVec2&, bool) except +  # ✓
    bool BeginChild(ImGuiID, const ImVec2&) except +  # ✓
    bool BeginChild(ImGuiID) except +  # ✓
    void EndChild() except +  # ✓
    ImVec2 GetContentRegionMax() except +  # ✓
    ImVec2 GetContentRegionAvail() except +  # ✓
    float GetContentRegionAvailWidth() except +  # ✓
    ImVec2 GetWindowContentRegionMin() except +  # ✓
    ImVec2 GetWindowContentRegionMax() except +  # ✓
    float GetWindowContentRegionWidth() except +  # ✓
    ImDrawList* GetWindowDrawList() except +  # ✓
    ImVec2 GetWindowPos() except +  # ✓
    ImVec2 GetWindowSize() except +  # ✓
    float GetWindowWidth() except +  # ✓
    float GetWindowHeight() except +  # ✓
    bool IsWindowCollapsed() except +  # ✓
    void SetWindowFontScale(float scale) except +  # ✓

    void SetNextWindowPos(  # ✓ note: overrides ommited
            const ImVec2& pos,
            # note: optional
            ImGuiSetCond cond
    ) except +
    void SetNextWindowPosCenter(  # ✓ note: overrides ommited
            # note: optional
            ImGuiSetCond cond
    ) except +
    void SetNextWindowSize(  # ✓ note: overrides ommited
            const ImVec2& size,
            # note: optional
            ImGuiSetCond cond
    ) except +
    void SetNextWindowSizeConstraints(  # ✗
            const ImVec2& size_min,
            const ImVec2& size_max,
            ImGuiSizeConstraintCallback custom_callback,
            void* custom_callback_data
    ) except +
    void SetNextWindowContentSize(const ImVec2& size) except +  # ✗
    void SetNextWindowContentWidth(float width) except +  # ✗
    void SetNextWindowCollapsed(  # ✓
            bool collapsed,
            # note: optional
            ImGuiSetCond cond
    ) except +
    void SetNextWindowFocus() except +  # ✓
    void SetWindowPos(  # ✗
            const ImVec2& pos,
            # note: optional
            ImGuiSetCond cond
    ) except +
    void SetWindowSize(  # ✗
            const ImVec2& size,
            # note: optional
            ImGuiSetCond cond
    ) except +
    void SetWindowCollapsed(  # ✗
            bool collapsed,
            # note: optional
            ImGuiSetCond cond
    ) except +
    void SetWindowFocus() except +  # ✗
    void SetWindowPos(  # ✗
            const char* name, const ImVec2& pos,
            # note: optional
            ImGuiSetCond cond
    ) except +
    void SetWindowSize(  # ✗
            const char* name, const ImVec2& size, ImGuiSetCond
            cond
    ) except +
    void SetWindowCollapsed(  # ✗
            const char* name, bool collapsed,
            # note: optional
            ImGuiSetCond cond
    ) except +
    void SetWindowFocus(const char* name) except +  # ✗

    float setScrollX() except +  # ✗
    float setScrollY() except +  # ✗
    float setScrollMaxX() except +  # ✗
    float setScrollMaxY() except +  # ✗
    void getScrollX(float scroll_x) except +  # ✗
    void getScrollY(float scroll_y) except +  # ✗
    void getScrollHere(  # ✗
            # note: optional
            float center_y_ratio
    ) except +
    void getScrollFromPosY(  # ✗
            float pos_y,
            # note: optional
            float center_y_ratio
    ) except +
    void getKeyboardFocusHere(  # ✗
            # note: optional
            int offset
    ) except +
    void getStateStorage(ImGuiStorage* tree) except +  # ✗
    ImGuiStorage* GetStateStorage() except +  # ✗

    # ====
    # Parameters stacks (shared)
    void PushFont(ImFont*) except +  # ✓
    void PopFont() except +  # ✓
    void PushStyleColor(ImGuiCol, const ImVec4&) except +  # ✓
    void PopStyleColor(int) except +  # ✓
    void PushStyleVar(ImGuiStyleVar, float) except +  # ✓
    void PushStyleVar(ImGuiStyleVar, const ImVec2&) except +  # ✓
    void PopStyleVar(int) except +  # ✓
    ImFont* GetFont() except +  # ✗
    float GetFontSize() except +  # ✗
    ImVec2 GetFontTexUvWhitePixel() except +  # ✗
    ImU32 GetColorU32(ImGuiCol, float) except +  # ✗
    ImU32 GetColorU32(const ImVec4& col) except +  # ✗

    # ====
    # Parameters stacks (current window)
    void PushItemWidth(float item_width) except +  # ✓
    void PopItemWidth() except +  # ✓
    float CalcItemWidth() except +  # ✓
    void PushTextWrapPos(float wrap_pos_x) except +  # ✓
    void PopTextWrapPos() except +  # ✓
    void PushAllowKeyboardFocus(bool v) except +  # ✗
    void PopAllowKeyboardFocus() except +  # ✗
    void PushButtonRepeat(bool repeat) except +  # ✗
    void PopButtonRepeat() except +  # ✗

    # ====
    # Cursor / Layout
    void Separator() except +  # ✓
    void SameLine(  # ✓
            # note: optional
            float pos_x, float spacing_w)
    void NewLine() except +  # ✓
    void Spacing() except +  # ✓
    void Dummy(const ImVec2& size) except +  # ✓
    void Indent(  # ✓
            # note: optional
            float indent_w
    ) except +
    void Unindent(  # ✓
            # note: optional
            float indent_w
    ) except +
    void BeginGroup() except +  # ✓
    void EndGroup() except +  # ✓
    ImVec2 GetCursorPos() except +  # ✗
    float GetCursorPosX() except +  # ✗
    float GetCursorPosY() except +  # ✗
    void SetCursorPos(const ImVec2& local_pos) except +  # ✗
    void SetCursorPosX(float x) except +  # ✗
    void SetCursorPosY(float y) except +  # ✗
    ImVec2 GetCursorStartPos() except +  # ✗
    ImVec2 GetCursorScreenPos() except +  # ✗
    void SetCursorScreenPos(const ImVec2& pos) except +  # ✗
    void AlignFirstTextHeightToWidgets() except +  # ✗
    float GetTextLineHeight() except +  # ✗
    float GetTextLineHeightWithSpacing() except +  # ✗
    float GetItemsLineHeightWithSpacing() except +  # ✗

    # ====
    # Columns
    void Columns(  # ✓
            # note: optional
            int count, const char* id, bool border
    ) except +
    void NextColumn() except +  # ✓
    int GetColumnIndex() except +  # ✓
    float GetColumnOffset(  # ✓
            # note: optional
            int column_index
    ) except +
    void SetColumnOffset(int column_index, float offset_x) except +  # ✓
    float GetColumnWidth(  # ✓
            # note: optional
            int column_index
    ) except +
    int GetColumnsCount() except +  # ✓

    # ====
    # ID scopes
    void PushID(const char* str_id) except +  # ✗
    void PushID(const char* str_id_begin, const char* str_id_end) except +  # ✗
    void PushID(const void* ptr_id) except +  # ✗
    void PushID(int int_id) except +  # ✗
    void PopID() except +  # ✗
    ImGuiID GetID(const char* str_id) except +  # ✗
    ImGuiID GetID(const char* str_id_begin, const char* str_id_end) except +  # ✗
    ImGuiID GetID(const void* ptr_id) except +  # ✗



    # ====
    # Widgets
    # Widgets: text
    void Text(const char*, ...) except +  # ✓
    void TextColored(const ImVec4&, const char*, ...) except +  # ✓
    void TextDisabled(const char*, ...) except +  # ✗
    void TextWrapped(const char*, ...) except +  # ✗
    void TextUnformatted(const char*) except +  # ✓
    void LabelText(const char*, const char*, ...) except +  # ✓
    void Bullet() except +  # ✓
    void BulletText(const char*, ...) except +  # ✓

    # Widgets: buttons
    bool Button(const char*, const ImVec2& size) except +  # ✓
    bool Button(const char*) except +  # ✓
    bool SmallButton(const char*) except +  # ✓
    bool InvisibleButton(const char*, const ImVec2& size) except +  # ✓
    bool ImageButton(  # ✓
            ImTextureID user_texture_id, const ImVec2& size,
            # note: optional
            const ImVec2& uv0, const ImVec2& uv1, int frame_padding,
            const ImVec4& bg_col, const ImVec4& tint_col
    ) except +
    
    bool ColorButton(  # ✓
            const ImVec4& col,
            # note: optional
            bool small_height, bool outline_border
    ) except +  # Widgets: images
    void Image(  # ✓
            ImTextureID user_texture_id, const ImVec2& size,
            # note: optional
            const ImVec2& uv0, const ImVec2& uv1, const ImVec4& tint_col,
            const ImVec4& border_col
    ) except +  # Widgets: checkboxes etc.
    bool Checkbox(const char* label, bool* v) except +  # ✓
    bool CheckboxFlags(  # ✓
            const char* label, unsigned int* flags, unsigned int flags_value
    ) except +
    bool RadioButton(const char* label, bool active) except +  # ✓
    # note: probably no reason to support it
    bool RadioButton(const char* label, int* v, int v_button) except +  # ✓

    # Widgets: combos
    bool Combo(  # ✓
            const char* label, int* current_item,
            const char* items_separated_by_zeros,
            # note: optional
            int height_in_items
    ) except +  # note: we only implemented the null-separated version that is fully
    #       compatible with following. Probably no reason to support it
    bool Combo(  # ✓
            const char* label, int* current_item,
            const char** items, int items_count,
            # note: optional
            int height_in_items
    ) except +
    bool Combo(  # ✗
            const char* label, int* current_item,
            bool (*items_getter)(void* data, int idx, const char** out_text),
            void* data, int items_count,
            # note: optional
            int height_in_items
    ) except +  # Widgets: color-edits
    bool ColorEdit3(const char* label, float col[3]) except +  # ✓
    bool ColorEdit4(  # ✓
            const char* label, float col[4],
            # note: optional
            bool show_alpha
    ) except +  #void ColorEditMode(ImGuiColorEditMode mode) except +  # note: obsoleted

    # Widgets: plots
    void PlotLines(  # ✗
            const char* label, const float* values, int values_count,
            # note: optional
            int values_offset, const char* overlay_text,
            float scale_min, float scale_max, ImVec2 graph_size, int stride
    ) except +
    void PlotLines(  # ✗
            const char* label, float (*values_getter)(void* data, int idx),
            void* data, int values_count,
            # note: optional
            int values_offset, const char* overlay_text, float scale_min,
            float scale_max, ImVec2 graph_size
    ) except +

    void PlotHistogram(  # ✗
            const char* label, const float* values, int values_count,
            # note: optional
            int values_offset, const char* overlay_text, float scale_min,
            float scale_max, ImVec2 graph_size, int stride
    ) except +
    void PlotHistogram(  # ✗
            const char* label, float (*values_getter)(void* data, int idx),
            void* data, int values_count,
            # note: optional
            int values_offset, const char* overlay_text, float scale_min,
            float scale_max, ImVec2 graph_size
    ) except +
    void ProgressBar(  # ✗
            float fraction,
            # note: optional
            const ImVec2& size_arg, const char* overlay
    ) except +  # Widgets: Drags (tip: ctrl+click on a drag box to input with keyboard.
    # manually input values aren't clamped, can go off-bounds) except +  # For all the Float2/Float3/Float4/Int2/Int3/Int4 versions of every
    # functions, remember than a 'float v[3]' function argument is the same
    # as 'float* v'. You can pass address of your first element out of a
    # contiguous set, e.g. &myvector.x
    bool DragFloat(  # ✓
            const char* label, float* v,
            # note: optional
            float v_speed, float v_min, float v_max,
            const char* display_format, float power
    ) except +
    bool DragFloat2(  # ✓
            const char* label, float v[2],
            # note: optional
            float v_speed, float v_min, float v_max,
            const char* display_format, float power
    ) except +
    bool DragFloat3(  # ✓
            const char* label, float v[3],
            # note: optional
            float v_speed, float v_min, float v_max,
            const char* display_format, float power
    ) except +
    bool DragFloat4(  # ✓
            const char* label, float v[4],
            # note: optional
            float v_speed, float v_min, float v_max,
            const char* display_format, float power
    ) except +
    bool DragFloatRange2(  # ✗
            const char* label, float* v_current_min, float* v_current_max,
            # note: optional
            float v_speed, float v_min, float v_max,
            const char* display_format,
            const char* display_format_max, float power
    ) except +
    bool DragInt(  # ✓
            const char* label, int* v,
            # note: optional
            float v_speed, int v_min, int v_max,
            const char* display_format
    ) except +
    bool DragInt2(  # ✓
            const char* label, int v[2],
            # note: optional
            float v_speed, int v_min, int v_max,
            const char* display_format
    ) except +
    bool DragInt3(  # ✓
            const char* label, int v[3],
            # note: optional
            float v_speed, int v_min, int v_max,
            const char* display_format
    ) except +
    bool DragInt4(  # ✓
            const char* label, int v[4],
            # note: optional
            float v_speed, int v_min, int v_max,
            const char* display_format
    ) except +
    bool DragIntRange2(  # ✗
            const char* label, int* v_current_min, int* v_current_max,
            # note: optional
            float v_speed, int v_min, int v_max,
            const char* display_format,
            const char* display_format_max
    ) except +  # Widgets: Input with Keyboard
    bool InputText(  # ✓
            const char* label, char* buf, size_t buf_size,
            # note: optional
            ImGuiInputTextFlags flags,
            ImGuiTextEditCallback callback, void* user_data
    ) except +
    bool InputTextMultiline(  # ✓
            const char* label, char* buf, size_t buf_size,
            # note: optional
            const ImVec2& size, ImGuiInputTextFlags flags,
            ImGuiTextEditCallback callback, void* user_data
    ) except +
    bool InputFloat(  # ✓
            const char* label, float* v,
            # note: optional
            float step, float step_fast,
            int decimal_precision, ImGuiInputTextFlags extra_flags
    ) except +
    bool InputFloat2(  # ✓
            const char* label, float v[2],
            # note: optional
            int decimal_precision, ImGuiInputTextFlags extra_flags
    ) except +
    bool InputFloat3(  # ✓
            const char* label, float v[3],
            # note: optional
            int decimal_precision, ImGuiInputTextFlags extra_flags
    ) except +
    bool InputFloat4(  # ✓
            const char* label, float v[4],
            # note: optional
            int decimal_precision, ImGuiInputTextFlags extra_flags
    ) except +
    bool InputInt(  # ✓
            const char* label, int* v,
            # note: optional
            int step, int step_fast,
            ImGuiInputTextFlags extra_flags
    ) except +
    bool InputInt2(  # ✓
            const char* label, int v[2],
            # note: optional
            ImGuiInputTextFlags extra_flags
    ) except +
    bool InputInt3(  # ✓
            const char* label, int v[3],
            # note: optional
            ImGuiInputTextFlags extra_flags
    ) except +
    bool InputInt4(  # ✓
            const char* label, int v[4],
            # note: optional
            ImGuiInputTextFlags extra_flags
    ) except +  # Widgets: Sliders (tip: ctrl+click on a slider to input with keyboard.
    #  manually input values aren't clamped, can go off-bounds)
    bool SliderFloat(  # ✓
            const char* label, float* v, float v_min, float v_max,
            # note: optional
            const char* display_format, float power
    ) except +
    bool SliderFloat2(  # ✓
            const char* label, float v[2], float v_min, float v_max,
            # note: optional
            const char* display_format, float power
    ) except +
    bool SliderFloat3(  # ✓
            const char* label, float v[3], float v_min, float v_max,
            # note: optional
            const char* display_format, float power
    ) except +
    bool SliderFloat4(  # ✓
            const char* label, float v[4], float v_min, float v_max,
            # note: optional
            const char* display_format, float power
    ) except +
    bool SliderAngle(  # ✗
            const char* label, float* v_rad,
            # note: optional
            float v_degrees_min, float v_degrees_max
    ) except +
    bool SliderInt(  # ✓
            const char* label, int* v, int v_min, int v_max,
            # note: optional
            const char* display_format
    ) except +
    bool SliderInt2(  # ✓
            const char* label, int v[2], int v_min, int v_max,
            # note: optional
            const char* display_format
    ) except +
    bool SliderInt3(  # ✓
            const char* label, int v[3], int v_min, int v_max,
            # note: optional
            const char* display_format
    ) except +
    bool SliderInt4(  # ✓
            const char* label, int v[4], int v_min, int v_max,
            # note: optional
            const char* display_format
    ) except +
    bool VSliderFloat(  # ✓
            const char* label, const ImVec2& size, float* v,
            float v_min, float v_max,
            # note: optional
            const char* display_format, float power
    ) except +
    bool VSliderInt(  # ✓
            const char* label, const ImVec2& size, int* v, int v_min, int v_max,
            # note: optional
            const char* display_format
    ) except +  # Widgets: Trees
    bool TreeNode(const char* label) except +  # ✓
    # bool TreeNode(const char* str_id, const char* fmt, ...) except +  # ✗
    # bool TreeNode(const void* ptr_id, const char* fmt, ...) except +  # ✗
    # bool TreeNodeV(const char* str_id, const char* fmt, va_list args) except +  # ✗
    # bool TreeNodeV(const void* ptr_id, const char* fmt, va_list args) except +  # ✗
    bool TreeNodeEx(  # ✓
            const char* label,
            # note: optional
            ImGuiTreeNodeFlags flags
    ) except +  # bool TreeNodeEx(const char* str_id, ImGuiTreeNodeFlags flags, const char* fmt, ...) IM_PRINTFARGS(3) except +  # bool TreeNodeEx(const void* ptr_id, ImGuiTreeNodeFlags flags, const char* fmt, ...) IM_PRINTFARGS(3) except +  # bool TreeNodeExV(const char* str_id, ImGuiTreeNodeFlags flags, const char* fmt, va_list args) except +  # bool TreeNodeExV(const void* ptr_id, ImGuiTreeNodeFlags flags, const char* fmt, va_list args) except +  # ✗
    void TreePush(  # ✗
            # note: optional
            const char* str_id
    ) except +
    void TreePush(  # ✗
            # note: optional
            const void* ptr_id
    ) except +
    void TreePop() except +  # ✓
    void TreeAdvanceToLabelPos() except +  # ✗
    float GetTreeNodeToLabelSpacing() except +  # ✗
    void SetNextTreeNodeOpen(  # ✗
            bool is_open,
            # note: optional
            ImGuiSetCond cond
    ) except +
    bool CollapsingHeader(  # ✓
            const char* label,
            # note: optional
            ImGuiTreeNodeFlags flags
    ) except +
    bool CollapsingHeader(  # ✓
            const char* label, bool* p_open,
            # note: optional
            ImGuiTreeNodeFlags flags
    ) except +  # Widgets: Selectable / Lists
    bool Selectable(  # ✓
            const char* label,
            # note: optional
            bool selected, ImGuiSelectableFlags flags,
            const ImVec2& size
    ) except +
    bool Selectable(  # ✓
            const char* label, bool* p_selected,
            # note: optional
            ImGuiSelectableFlags flags, const ImVec2& size
    ) except +
    bool ListBox(  # ✓
            const char* label, int* current_item, const char** items,
            int items_count,
            # note: optional
            int height_in_items
    ) except +
    bool ListBox(  # ✗
            const char* label, int* current_item,
            bool (*items_getter)(void* data, int idx, const char** out_text),
            void* data, int items_count,
            # note: optional
            int height_in_items
    ) except +
    bool ListBoxHeader(  # ✓
            const char* label,
            # note: optional
            const ImVec2& size
    ) except +
    bool ListBoxHeader(  # ✗
            const char* label, int items_count,
            # note: optional
            int height_in_items
    ) except +
    void ListBoxFooter() except +  # ✓

    # Widgets: Value() Helpers.
    void Value(const char* prefix, bool b) except +  # ✗
    void Value(const char* prefix, int v) except +  # ✗
    void Value(const char* prefix, unsigned int v) except +  # ✗
    void Value(  # ✗
            const char* prefix, float v,
            # note: optional
            const char* float_format
    ) except +
    void ValueColor(const char* prefix, const ImVec4& v) except +  # ✗
    void ValueColor(const char* prefix, unsigned int v) except +  # ✗

    # Tooltips
    void SetTooltip(const char* fmt, ...) except +  # ✓
    # void SetTooltipV(const char* fmt, va_list args) except +  # ✗
    void BeginTooltip() except +  # ✓
    void EndTooltip() except +  # ✓

    # Menus
    bool BeginMainMenuBar() except +  # ✓
    void EndMainMenuBar() except +  # ✓
    bool BeginMenuBar() except +  # ✓
    void EndMenuBar() except +  # ✓
    bool BeginMenu(  # ✓
            const char* label,
            # note: optional
            bool enabled
    ) except +
    void EndMenu() except +  # ✓
    bool MenuItem(  # ✓
            const char* label,
            # note: optional
            const char* shortcut, bool selected,
            bool enabled
    ) except +
    bool MenuItem(  # ✓
            const char* label, const char* shortcut, bool* p_selected,
            # note: optional
            bool enabled
    ) except +  # Popups
    void OpenPopup(const char* str_id) except +  # ✓
    bool BeginPopup(const char* str_id) except +  # ✓
    bool BeginPopupModal(  # ✓
            const char* name,
            # note: optional
            bool* p_open, ImGuiWindowFlags extra_flags
    ) except +
    bool BeginPopupContextItem(  # ✓
            const char* str_id,
            # note: optional
            int mouse_button
    ) except +
    bool BeginPopupContextWindow(  # ✓
            bool also_over_items, const char* str_id,
            # note: optional
            int mouse_button
    ) except +
    bool BeginPopupContextVoid(  # ✓
            # note: optional
            const char* str_id, int mouse_button
    ) except +
    void EndPopup() except +  # ✓
    void CloseCurrentPopup() except +  # ✓

    # Logging: all text output from interface is redirected to
    # tty/file/clipboard. By default, tree nodes are automatically opened
    #  during logging.
    void LogToTTY(  # ✗
            # note: optional
            int max_depth
    ) except +
    void LogToFile(  # ✗
            # note: optional
            int max_depth, const char* filename
    ) except +
    void LogToClipboard(  # ✗
            # note: optional
            int max_depth
    ) except +
    void LogFinish() except +  # ✗
    void LogButtons() except +  # ✗
    void LogText(const char*, ...) except +  # ✗

    # Clipping
    void PushClipRect(const ImVec2& clip_rect_min, const ImVec2& clip_rect_max, bool intersect_with_current_clip_rect) except +  # ✗
    void PopClipRect() except +  # ✗

    # Utilities
    bool IsItemHovered() except +  # ✓
    bool IsItemHoveredRect() except +  # ✓
    bool IsItemActive() except +  # ✓
    bool IsItemClicked(  # ✓
            # note: optional
            int mouse_button
    ) except +
    bool IsItemVisible() except +  # ✓
    bool IsAnyItemHovered() except +  # ✓
    bool IsAnyItemActive() except +  # ✓
    ImVec2 GetItemRectMin() except +  # ✓
    ImVec2 GetItemRectMax() except +  # ✓
    ImVec2 GetItemRectSize() except +  # ✓
    void SetItemAllowOverlap() except +  # ✓
    bool IsWindowHovered() except +  # ✓
    bool IsWindowFocused() except +  # ✓
    bool IsRootWindowFocused() except +  # ✓
    bool IsRootWindowOrAnyChildFocused() except +  # ✓
    bool IsRootWindowOrAnyChildHovered() except +  # ✓
    bool IsRectVisible(const ImVec2& size) except +  # ✓
    bool IsPosHoveringAnyWindow(const ImVec2& pos) except +  # ✓
    float GetTime() except +  # ✗
    int GetFrameCount() except +  # ✗
    const char* GetStyleColName(ImGuiCol idx) except +  # ✗
    ImVec2 CalcItemRectClosestPoint(  # ✗
            const ImVec2& pos,
            # note: optional
            bool on_edge, float outward
    ) except +
    ImVec2 CalcTextSize(  # ✗
            const char* text,
            # note: optional
            const char* text_end,
            bool hide_text_after_double_hash,
            float wrap_width
    ) except +
    void CalcListClipping(int items_count, float items_height, int* out_items_display_start, int* out_items_display_end) except +  # ✗

    bool BeginChildFrame(  # ✗
            ImGuiID id, const ImVec2& size,
            # note: optional
            ImGuiWindowFlags extra_flags
    ) except +
    void EndChildFrame() except +  # ✗

    ImVec4 ColorConvertU32ToFloat4(ImU32 in_) except +  # ✗
    ImU32 ColorConvertFloat4ToU32(const ImVec4& in_) except +  # ✗
    void ColorConvertRGBtoHSV(float r, float g, float b, float& out_h, float& out_s, float& out_v) except +  # ✗
    void ColorConvertHSVtoRGB(float h, float s, float v, float& out_r, float& out_g, float& out_b) except +  # ✗

    # Inputs
    int GetKeyIndex(ImGuiKey key) except +  # ✓
    bool IsKeyDown(int key_index) except +  # ✓
    bool IsKeyPressed(  # ✓
            int key_index,
            # note: optional
            bool repeat
    ) except +
    bool IsKeyReleased(int key_index) except +  # ✓
    bool IsMouseDown(int button) except +  # ✓
    bool IsMouseClicked(  # ✓
            int button,
            # note: optional
            bool repeat
    ) except +
    bool IsMouseDoubleClicked(int button) except +  # ✓
    bool IsMouseReleased(int button) except +  # ✓
    bool IsMouseHoveringWindow() except +  # ✓
    bool IsMouseHoveringAnyWindow() except +  # ✓
    bool IsMouseHoveringRect(  # ✓
            const ImVec2& r_min, const ImVec2& r_max,
            # note: optional
            bool clip
    ) except +
    bool IsMouseDragging(  # ✓
            # note: optional
            int button, float lock_threshold
    ) except +
    ImVec2 GetMousePos() except +  # ✓
    ImVec2 GetMousePosOnOpeningCurrentPopup() except +  # ✗
    ImVec2 GetMouseDragDelta(  # ✓
            # note: optional
            int button, float lock_threshold
    ) except +
    void ResetMouseDragDelta(  # ✓
            # note: optional
            int button
    ) except +
    ImGuiMouseCursor GetMouseCursor() except +  # ✓
    void SetMouseCursor(ImGuiMouseCursor type) except +  # ✓
    void CaptureKeyboardFromApp(  # ✗
            # note: optional
            bool capture
    ) except +
    void CaptureMouseFromApp(  # ✗
            # note: optional
            bool capture
    ) except +  # ====
    # Helpers functions to access functions pointers in ImGui::GetIO() except +  # void* MemAlloc(size_t sz) except +  # void MemFree(void* ptr)
    const char* GetClipboardText() except +  # ✗
    void SetClipboardText(const char* text) except +  # ✗

    # Internal context access - see: imgui.h
    const char*   GetVersion() except +  # ✗
    ImGuiContext* CreateContext(  # ✗
            # note: optional
            void* (*malloc_fn)(size_t), void (*free_fn)(void*)
    ) except +
    void DestroyContext(ImGuiContext* ctx) except +  # ✗
    ImGuiContext* GetCurrentContext() except +  # ✗
    void SetCurrentContext(ImGuiContext* ctx) except +  # ✗
