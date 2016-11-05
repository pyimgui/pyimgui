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
    # ====
    # Main
    ImGuiIO& GetIO()  # ✓
    ImGuiStyle& GetStyle()  # ✗
    ImDrawData* GetDrawData()  # ✓
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

    # ====
    # Window
    bool Begin(const char*, bool*, ImGuiWindowFlags)  # ✓
    bool Begin(const char*, bool*)  # ✓
    bool Begin(const char*)  # ✓
    # note: following API was deprecated
    # bool Begin(const char*, bool*, const ImVec2&, float, ImGuiWindowFlags)  # ✗
    # bool Begin(const char*, bool*, const ImVec2&, float)  # ✗
    # bool Begin(const char*, bool*, const ImVec2&)  # ✗
    void End()  # ✓
    bool BeginChild(const char*, const ImVec2&, bool, ImGuiWindowFlags)  # ✓
    bool BeginChild(const char*, const ImVec2&, bool)  # ✓
    bool BeginChild(const char*, const ImVec2&)  # ✓
    bool BeginChild(const char*)  # ✓
    bool BeginChild(ImGuiID, const ImVec2&, bool, ImGuiWindowFlags)  # ✓
    bool BeginChild(ImGuiID, const ImVec2&, bool)  # ✓
    bool BeginChild(ImGuiID, const ImVec2&)  # ✓
    bool BeginChild(ImGuiID)  # ✓
    void EndChild()  # ✓
    ImVec2 GetContentRegionMax()  # ✓
    ImVec2 GetContentRegionAvail()  # ✓
    float GetContentRegionAvailWidth()  # ✓
    ImVec2 GetWindowContentRegionMin()  # ✓
    ImVec2 GetWindowContentRegionMax()  # ✓
    float GetWindowContentRegionWidth()  # ✓
    ImDrawList* GetWindowDrawList()  # ✓
    ImVec2 GetWindowPos()  # ✓
    ImVec2 GetWindowSize()  # ✓
    float GetWindowWidth()  # ✓
    float GetWindowHeight()  # ✓
    bool IsWindowCollapsed()  # ✓
    void SetWindowFontScale(float scale)  # ✓

    void SetNextWindowPos(  # ✓ note: overrides ommited
            const ImVec2& pos,
            # note: optional
            ImGuiSetCond cond
    )
    void SetNextWindowPosCenter(  # ✓ note: overrides ommited
            # note: optional
            ImGuiSetCond cond
    )
    void SetNextWindowSize(  # ✓ note: overrides ommited
            const ImVec2& size,
            # note: optional
            ImGuiSetCond cond
    )
    void SetNextWindowSizeConstraints(const ImVec2& size_min, const ImVec2& size_max, ImGuiSizeConstraintCallback custom_callback, void* custom_callback_data)  # ✗
    void SetNextWindowContentSize(const ImVec2& size)  # ✗
    void SetNextWindowContentWidth(float width)  # ✗
    void SetNextWindowCollapsed(  # ✓
            bool collapsed,
            # note: optional
            ImGuiSetCond cond
    )
    void SetNextWindowFocus()  # ✓
    void SetWindowPos(  # ✗
            const ImVec2& pos,
            # note: optional
            ImGuiSetCond cond
    )
    void SetWindowSize(  # ✗
            const ImVec2& size,
            # note: optional
            ImGuiSetCond cond
    )
    void SetWindowCollapsed(  # ✗
            bool collapsed,
            # note: optional
            ImGuiSetCond cond
    )
    void SetWindowFocus()  # ✗
    void SetWindowPos(  # ✗
            const char* name, const ImVec2& pos,
            # note: optional
            ImGuiSetCond cond
    )
    void SetWindowSize(  # ✗
            const char* name, const ImVec2& size, ImGuiSetCond
            cond
    )
    void SetWindowCollapsed(  # ✗
            const char* name, bool collapsed,
            # note: optional
            ImGuiSetCond cond
    )
    void SetWindowFocus(const char* name)  # ✗

    float setScrollX()  # ✗
    float setScrollY()  # ✗
    float setScrollMaxX()  # ✗
    float setScrollMaxY()  # ✗
    void getScrollX(float scroll_x)  # ✗
    void getScrollY(float scroll_y)  # ✗
    void getScrollHere(  # ✗
            # note: optional
            float center_y_ratio
    )
    void getScrollFromPosY(  # ✗
            float pos_y,
            # note: optional
            float center_y_ratio
    )
    void getKeyboardFocusHere(  # ✗
            # note: optional
            int offset
    )
    void getStateStorage(ImGuiStorage* tree)  # ✗
    ImGuiStorage* GetStateStorage()  # ✗

    # ====
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

    # ====
    # Cursor / Layout
    void Separator()  # ✓
    void SameLine(  # ✓
            # note: optional
            float pos_x, float spacing_w)
    void NewLine()  # ✓
    void Spacing()  # ✓
    void Dummy(const ImVec2& size)  # ✓
    void Indent(  # ✓
            # note: optional
            float indent_w
    )
    void Unindent(  # ✓
            # note: optional
            float indent_w
    )
    void BeginGroup()  # ✓
    void EndGroup()  # ✓
    ImVec2 GetCursorPos()  # ✗
    float GetCursorPosX()  # ✗
    float GetCursorPosY()  # ✗
    void SetCursorPos(const ImVec2& local_pos)  # ✗
    void SetCursorPosX(float x)  # ✗
    void SetCursorPosY(float y)  # ✗
    ImVec2 GetCursorStartPos()  # ✗
    ImVec2 GetCursorScreenPos()  # ✗
    void SetCursorScreenPos(const ImVec2& pos)  # ✗
    void AlignFirstTextHeightToWidgets()  # ✗
    float GetTextLineHeight()  # ✗
    float GetTextLineHeightWithSpacing()  # ✗
    float GetItemsLineHeightWithSpacing()  # ✗

    # ====
    # Columns
    void Columns(  # ✗
            # note: optional
            int count, const char* id, bool border
    )
    void NextColumn()  # ✗
    int GetColumnIndex()  # ✗
    float GetColumnOffset(  # ✗
            # note: optional
            int column_index
    )
    void SetColumnOffset(int column_index, float offset_x)  # ✗
    float GetColumnWidth(  # ✗
            # note: optional
            int column_index
    )
    int GetColumnsCount()  # ✗

    # ====
    # ID scopes
    void PushID(const char* str_id)  # ✗
    void PushID(const char* str_id_begin, const char* str_id_end)  # ✗
    void PushID(const void* ptr_id)  # ✗
    void PushID(int int_id)  # ✗
    void PopID()  # ✗
    ImGuiID GetID(const char* str_id)  # ✗
    ImGuiID GetID(const char* str_id_begin, const char* str_id_end)  # ✗
    ImGuiID GetID(const void* ptr_id)  # ✗



    # ====
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
            # note: optional
            const ImVec2& uv0, const ImVec2& uv1, int frame_padding,
            const ImVec4& bg_col, const ImVec4& tint_col
    )
    
    bool ColorButton(  # ✓
            const ImVec4& col,
            # note: optional
            bool small_height, bool outline_border
    )

    # Widgets: images
    void Image(  # ✓
            ImTextureID user_texture_id, const ImVec2& size,
            # note: optional
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
            # note: optional
            int height_in_items
    )
    bool Combo(  # ✗
            const char* label, int* current_item,
            const char* items_separated_by_zeros,
            # note: optional
            int height_in_items
    )
    bool Combo(  # ✗
            const char* label, int* current_item,
            bool (*items_getter)(void* data, int idx,
            const char** out_text), void* data, int items_count,
            # note: optional
            int height_in_items
    )
    # Widgets: color-edits
    bool ColorEdit3(const char* label, float col[3])  # ✗
    bool ColorEdit4(  # ✗
            const char* label, float col[4],
            # note: optional
            bool show_alpha
    )
    #void ColorEditMode(ImGuiColorEditMode mode)  # note: obsoleted

    # Widgets: plots
    void PlotLines(  # ✗
            const char* label, const float* values, int values_count,
            # note: optional
            int values_offset, const char* overlay_text,
            float scale_min, float scale_max, ImVec2 graph_size, int stride
    )
    void PlotLines(  # ✗
            const char* label, float (*values_getter)(void* data, int idx),
            void* data, int values_count,
            # note: optional
            int values_offset, const char* overlay_text, float scale_min,
            float scale_max, ImVec2 graph_size
    )

    void PlotHistogram(  # ✗
            const char* label, const float* values, int values_count,
            # note: optional
            int values_offset, const char* overlay_text, float scale_min,
            float scale_max, ImVec2 graph_size, int stride
    )
    void PlotHistogram(  # ✗
            const char* label, float (*values_getter)(void* data, int idx),
            void* data, int values_count,
            # note: optional
            int values_offset, const char* overlay_text, float scale_min,
            float scale_max, ImVec2 graph_size
    )
    void ProgressBar(  # ✗
            float fraction,
            # note: optional
            const ImVec2& size_arg, const char* overlay
    )

    # Widgets: Drags (tip: ctrl+click on a drag box to input with keyboard. manually input values aren't clamped, can go off-bounds)
    # For all the Float2/Float3/Float4/Int2/Int3/Int4 versions of every functions, remember than a 'float v[3]' function argument is the same as 'float* v'. You can pass address of your first element out of a contiguous set, e.g. &myvector.x
    bool DragFloat(  # ✗
            const char* label, float* v,
            # note: optional
            float v_speed, float v_min, float v_max,
            const char* display_format, float power
    )
    bool DragFloat2(  # ✗
            const char* label, float v[2],
            # note: optional
            float v_speed, float v_min, float v_max,
            const char* display_format, float power
    )
    bool DragFloat3(  # ✗
            const char* label, float v[3],
            # note: optional
            float v_speed, float v_min, float v_max,
            const char* display_format, float power
    )
    bool DragFloat4(  # ✗
            const char* label, float v[4],
            # note: optional
            float v_speed, float v_min, float v_max,
            const char* display_format, float power
    )
    bool DragFloatRange2(  # ✗
            const char* label, float* v_current_min, float* v_current_max,
            # note: optional
            float v_speed, float v_min, float v_max,
            const char* display_format,
            const char* display_format_max, float power
    )
    bool DragInt(  # ✗
            const char* label, int* v,
            # note: optional
            float v_speed, int v_min, int v_max,
            const char* display_format
    )
    bool DragInt2(  # ✗
            const char* label, int v[2],
            # note: optional
            float v_speed, int v_min, int v_max,
            const char* display_format
    )
    bool DragInt3(  # ✗
            const char* label, int v[3],
            # note: optional
            float v_speed, int v_min, int v_max,
            const char* display_format
    )
    bool DragInt4(  # ✗
            const char* label, int v[4],
            # note: optional
            float v_speed, int v_min, int v_max,
            const char* display_format
    )
    bool DragIntRange2(  # ✗
            const char* label, int* v_current_min, int* v_current_max,
            # note: optional
            float v_speed, int v_min, int v_max,
            const char* display_format,
            const char* display_format_max
    )

    # Widgets: Input with Keyboard
    bool InputText(  # ✗
            const char* label, char* buf, size_t buf_size,
            # note: optional
            ImGuiInputTextFlags flags,
            ImGuiTextEditCallback callback, void* user_data
    )
    bool InputTextMultiline(  # ✗
            const char* label, char* buf, size_t buf_size,
            # note: optional
            const ImVec2& size, ImGuiInputTextFlags flags,
            ImGuiTextEditCallback callback, void* user_data
    )
    bool InputFloat(  # ✗
            const char* label, float* v,
            # note: optional
            float step, float step_fast,
            int decimal_precision, ImGuiInputTextFlags extra_flags
    )
    bool InputFloat2(  # ✗
            const char* label, float v[2],
            # note: optional
            int decimal_precision, ImGuiInputTextFlags extra_flags
    )
    bool InputFloat3(  # ✗
            const char* label, float v[3],
            # note: optional
            int decimal_precision, ImGuiInputTextFlags extra_flags
    )
    bool InputFloat4(  # ✗
            const char* label, float v[4],
            # note: optional
            int decimal_precision, ImGuiInputTextFlags extra_flags
    )
    bool InputInt(  # ✗
            const char* label, int* v,
            # note: optional
            int step, int step_fast,
            ImGuiInputTextFlags extra_flags
    )
    bool InputInt2(  # ✗
            const char* label, int v[2],
            # note: optional
            ImGuiInputTextFlags extra_flags
    )
    bool InputInt3(  # ✗
            const char* label, int v[3],
            # note: optional
            ImGuiInputTextFlags extra_flags
    )
    bool InputInt4(  # ✗
            const char* label, int v[4],
            # note: optional
            ImGuiInputTextFlags extra_flags
    )

    # Widgets: Sliders (tip: ctrl+click on a slider to input with keyboard. manually input values aren't clamped, can go off-bounds)
    bool SliderFloat(  # ✗
            const char* label, float* v, float v_min, float v_max,
            # note: optional
            const char* display_format, float power
    )
    bool SliderFloat2(  # ✗
            const char* label, float v[2], float v_min, float v_max,
            # note: optional
            const char* display_format, float power
    )
    bool SliderFloat3(  # ✗
            const char* label, float v[3], float v_min, float v_max,
            # note: optional
            const char* display_format, float power
    )
    bool SliderFloat4(  # ✗
            const char* label, float v[4], float v_min, float v_max,
            # note: optional
            const char* display_format, float power
    )
    bool SliderAngle(  # ✗
            const char* label, float* v_rad,
            # note: optional
            float v_degrees_min, float v_degrees_max
    )
    bool SliderInt(  # ✗
            const char* label, int* v, int v_min, int v_max,
            # note: optional
            const char* display_format
    )
    bool SliderInt2(  # ✗
            const char* label, int v[2], int v_min, int v_max,
            # note: optional
            const char* display_format
    )
    bool SliderInt3(  # ✗
            const char* label, int v[3], int v_min, int v_max,
            # note: optional
            const char* display_format
    )
    bool SliderInt4(  # ✗
            const char* label, int v[4], int v_min, int v_max,
            # note: optional
            const char* display_format
    )
    bool VSliderFloat(  # ✗
            const char* label, const ImVec2& size, float* v,
            float v_min, float v_max,
            # note: optional
            const char* display_format, float power
    )
    bool VSliderInt(  # ✗
            const char* label, const ImVec2& size, int* v, int v_min, int v_max,
            # note: optional
            const char* display_format
    )

    # Widgets: Trees
    bool TreeNode(const char* label)  # ✗
    # bool TreeNode(const char* str_id, const char* fmt, ...)  # ✗
    # bool TreeNode(const void* ptr_id, const char* fmt, ...)  # ✗
    # bool TreeNodeV(const char* str_id, const char* fmt, va_list args)  # ✗
    # bool TreeNodeV(const void* ptr_id, const char* fmt, va_list args)  # ✗
    bool TreeNodeEx(  # ✗
            const char* label,
            # note: optional
            ImGuiTreeNodeFlags flags
    )
    # bool TreeNodeEx(const char* str_id, ImGuiTreeNodeFlags flags, const char* fmt, ...) IM_PRINTFARGS(3)
    # bool TreeNodeEx(const void* ptr_id, ImGuiTreeNodeFlags flags, const char* fmt, ...) IM_PRINTFARGS(3)
    # bool TreeNodeExV(const char* str_id, ImGuiTreeNodeFlags flags, const char* fmt, va_list args)
    # bool TreeNodeExV(const void* ptr_id, ImGuiTreeNodeFlags flags, const char* fmt, va_list args)  # ✗
    void TreePush(  # ✗
            # note: optional
            const char* str_id
    )
    void TreePush(  # ✗
            # note: optional
            const void* ptr_id
    )
    void TreePop()  # ✗
    void TreeAdvanceToLabelPos()  # ✗
    float GetTreeNodeToLabelSpacing()  # ✗
    void SetNextTreeNodeOpen(  # ✗
            bool is_open,
            # note: optional
            ImGuiSetCond cond
    )
    bool CollapsingHeader(  # ✗
            const char* label,
            # note: optional
            ImGuiTreeNodeFlags flags
    )
    bool CollapsingHeader(  # ✗
            const char* label, bool* p_open,
            # note: optional
            ImGuiTreeNodeFlags flags
    )

    # Widgets: Selectable / Lists
    bool Selectable(  # ✗
            const char* label,
            # note: optional
            bool selected, ImGuiSelectableFlags flags,
            const ImVec2& size
    )
    bool Selectable(  # ✗
            const char* label, bool* p_selected,
            # note: optional
            ImGuiSelectableFlags flags, const ImVec2& size
    )
    bool ListBox(  # ✗
            const char* label, int* current_item, const char** items,
            int items_count,
            # note: optional
            int height_in_items
    )
    bool ListBox(  # ✗
            const char* label, int* current_item,
            bool (*items_getter)(void* data, int idx, const char** out_text),
            void* data, int items_count,
            # note: optional
            int height_in_items
    )
    bool ListBoxHeader(  # ✗
            const char* label,
            # note: optional
            const ImVec2& size
    )
    bool ListBoxHeader(  # ✗
            const char* label, int items_count,
            # note: optional
            int height_in_items
    )
    void ListBoxFooter()  # ✗

    # Widgets: Value() Helpers.
    void Value(const char* prefix, bool b)  # ✗
    void Value(const char* prefix, int v)  # ✗
    void Value(const char* prefix, unsigned int v)  # ✗
    void Value(  # ✗
            const char* prefix, float v,
            # note: optional
            const char* float_format
    )
    void ValueColor(const char* prefix, const ImVec4& v)  # ✗
    void ValueColor(const char* prefix, unsigned int v)  # ✗

    # Tooltips
    void SetTooltip(const char* fmt)  # ✗
    # void SetTooltipV(const char* fmt, va_list args)  # ✗
    void BeginTooltip()  # ✗
    void EndTooltip()  # ✗

    # Menus
    bool BeginMainMenuBar()  # ✗
    void EndMainMenuBar()  # ✗
    bool BeginMenuBar()  # ✗
    void EndMenuBar()  # ✗
    bool BeginMenu(  # ✗
            const char* label,
            # note: optional
            bool enabled
    )
    void EndMenu()  # ✗
    bool MenuItem(  # ✗
            const char* label,
            # note: optional
            const char* shortcut, bool selected,
            bool enabled
    )
    bool MenuItem(  # ✗
            const char* label, const char* shortcut, bool* p_selected,
            # note: optional
            bool enabled
    )

    # Popups
    void OpenPopup(const char* str_id)  # ✗
    bool BeginPopup(const char* str_id)  # ✗
    bool BeginPopupModal(  # ✗
            const char* name,
            # note: optional
            bool* p_open, ImGuiWindowFlags extra_flags
    )
    bool BeginPopupContextItem(  # ✗
            const char* str_id,
            # note: optional
            int mouse_button
    )
    bool BeginPopupContextWindow(  # ✗
            bool also_over_items, const char* str_id,
            # note: optional
            int mouse_button
    )
    bool BeginPopupContextVoid(  # ✗
            # note: optional
            const char* str_id, int mouse_button
    )
    void EndPopup()  # ✗
    void CloseCurrentPopup()  # ✗

    # Logging: all text output from interface is redirected to tty/file/clipboard. By default, tree nodes are automatically opened during logging.
    void LogToTTY(  # ✗
            # note: optional
            int max_depth
    )
    void LogToFile(  # ✗
            # note: optional
            int max_depth, const char* filename
    )
    void LogToClipboard(  # ✗
            # note: optional
            int max_depth
    )
    void LogFinish()  # ✗
    void LogButtons()  # ✗
    void LogText(const char*)

    # Clipping
    void PushClipRect(const ImVec2& clip_rect_min, const ImVec2& clip_rect_max, bool intersect_with_current_clip_rect)  # ✗
    void PopClipRect()  # ✗

    # Utilities
    bool IsItemHovered()  # ✗
    bool IsItemHoveredRect()  # ✗
    bool IsItemActive()  # ✗
    bool IsItemClicked(  # ✗
            # note: optional
            int mouse_button
    )
    bool IsItemVisible()  # ✗
    bool IsAnyItemHovered()  # ✗
    bool IsAnyItemActive()  # ✗
    ImVec2 GetItemRectMin()  # ✗
    ImVec2 GetItemRectMax()  # ✗
    ImVec2 GetItemRectSize()  # ✗
    void SetItemAllowOverlap()  # ✗
    bool IsWindowHovered()  # ✗
    bool IsWindowFocused()  # ✗
    bool IsRootWindowFocused()  # ✗
    bool IsRootWindowOrAnyChildFocused()  # ✗
    bool IsRootWindowOrAnyChildHovered()  # ✗
    bool IsRectVisible(const ImVec2& size)  # ✗
    bool IsPosHoveringAnyWindow(const ImVec2& pos)  # ✗
    float GetTime()  # ✗
    int GetFrameCount()  # ✗
    const char* GetStyleColName(ImGuiCol idx)  # ✗
    ImVec2 CalcItemRectClosestPoint(  # ✗
            const ImVec2& pos,
            # note: optional
            bool on_edge, float outward
    )
    ImVec2 CalcTextSize(  # ✗
            const char* text,
            # note: optional
            const char* text_end,
            bool hide_text_after_double_hash,
            float wrap_width
    )
    void CalcListClipping(int items_count, float items_height, int* out_items_display_start, int* out_items_display_end)  # ✗

    bool BeginChildFrame(  # ✗
            ImGuiID id, const ImVec2& size,
            # note: optional
            ImGuiWindowFlags extra_flags
    )
    void EndChildFrame()  # ✗

    ImVec4 ColorConvertU32ToFloat4(ImU32 in_)  # ✗
    ImU32 ColorConvertFloat4ToU32(const ImVec4& in_)  # ✗
    void ColorConvertRGBtoHSV(float r, float g, float b, float& out_h, float& out_s, float& out_v)  # ✗
    void ColorConvertHSVtoRGB(float h, float s, float v, float& out_r, float& out_g, float& out_b)  # ✗

    # Inputs
    int GetKeyIndex(ImGuiKey key)  # ✗
    bool IsKeyDown(int key_index)  # ✗
    bool IsKeyPressed(  # ✗
            int key_index,
            # note: optional
            bool repeat
    )
    bool IsKeyReleased(int key_index)  # ✗
    bool IsMouseDown(int button)  # ✗
    bool IsMouseClicked(  # ✗
            int button,
            # note: optional
            bool repeat
    )
    bool IsMouseDoubleClicked(int button)  # ✗
    bool IsMouseReleased(int button)  # ✗
    bool IsMouseHoveringWindow()  # ✗
    bool IsMouseHoveringAnyWindow()  # ✗
    bool IsMouseHoveringRect(  # ✗
            const ImVec2& r_min, const ImVec2& r_max,
            # note: optional
            bool clip
    )
    bool IsMouseDragging(  # ✗
            # note: optional
            int button, float lock_threshold
    )
    ImVec2 GetMousePos()  # ✗
    ImVec2 GetMousePosOnOpeningCurrentPopup()  # ✗
    ImVec2 GetMouseDragDelta(  # ✗
            # note: optional
            int button, float lock_threshold
    )
    void ResetMouseDragDelta(  # ✗
            # note: optional
            int button
    )
    ImGuiMouseCursor GetMouseCursor()  # ✗
    void SetMouseCursor(ImGuiMouseCursor type)  # ✗
    void CaptureKeyboardFromApp(  # ✗
            # note: optional
            bool capture
    )
    void CaptureMouseFromApp(  # ✗
            # note: optional
            bool capture
    )

    # ====
    # Helpers functions to access functions pointers in ImGui::GetIO()
    # void* MemAlloc(size_t sz)
    # void MemFree(void* ptr)
    const char* GetClipboardText()  # ✗
    void SetClipboardText(const char* text)  # ✗

    # Internal context access - see: imgui.h
    const char*   GetVersion()  # ✗
    ImGuiContext* CreateContext(  # ✗
            # note: optional
            void* (*malloc_fn)(size_t), void (*free_fn)(void*)
    )
    void DestroyContext(ImGuiContext* ctx)  # ✗
    ImGuiContext* GetCurrentContext()  # ✗
    void SetCurrentContext(ImGuiContext* ctx)  # ✗
