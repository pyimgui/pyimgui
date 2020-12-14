# -*- coding: utf-8 -*-
# distutils: language = c++
# distutils: include_dirs = imgui-cpp
"""
Notes:
   `✓` marks API element as already mapped in core bindings.
   `✗` marks API element as "yet to be mapped
"""
from libcpp cimport bool

from enums cimport ImGuiKey_, ImGuiCol_, ImGuiSliderFlags_


cdef extern from "imgui.h":
    # ====
    # Forward declarations
    ctypedef struct ImDrawChannel
    ctypedef struct ImDrawCmd
    ctypedef struct ImDrawData
    ctypedef struct ImDrawList
    ctypedef struct ImDrawListSharedData
    ctypedef struct ImDrawListSplitter
    ctypedef struct ImDrawVert
    ctypedef struct ImFont
    ctypedef struct ImFontAtlas
    ctypedef struct ImFontConfig
    ctypedef struct ImFontGlyph
    ctypedef struct ImFontGlyphRangesBuilder
    ctypedef struct ImColor
    ctypedef struct ImGuiContext
    ctypedef struct ImGuiIO
    ctypedef struct ImGuiInputTextCallbackData
    ctypedef struct ImGuiListClipper
    ctypedef struct ImGuiOnceUponAFrame
    ctypedef struct ImGuiPayload
    ctypedef struct ImGuiSizeCallbackData
    ctypedef struct ImGuiStorage
    # ctypedef struct ImGuiStyle  # declared later
    ctypedef struct ImGuiTextBuffer
    ctypedef struct ImGuiTextFilter
    
    # ====
    # Enums/Flags
    ctypedef int ImGuiCol
    ctypedef int ImGuiCond
    ctypedef int ImGuiDataType
    ctypedef int ImGuiDir
    ctypedef int ImGuiKey
    ctypedef int ImGuiNavInput
    ctypedef int ImGuiMouseButton
    ctypedef int ImGuiMouseCursor
    ctypedef int ImGuiStyleVar
    ctypedef int ImDrawCornerFlags
    ctypedef int ImDrawListFlags
    ctypedef int ImFontAtlasFlags
    ctypedef int ImGuiBackendFlags
    ctypedef int ImGuiButtonFlags
    ctypedef int ImGuiColorEditFlags
    ctypedef int ImGuiConfigFlags
    ctypedef int ImGuiComboFlags
    ctypedef int ImGuiDragDropFlags
    ctypedef int ImGuiFocusedFlags
    ctypedef int ImGuiHoveredFlags
    ctypedef int ImGuiInputTextFlags
    ctypedef int ImGuiKeyModFlags
    ctypedef int ImGuiPopupFlags
    ctypedef int ImGuiSelectableFlags
    ctypedef int ImGuiSliderFlags
    ctypedef int ImGuiTabBarFlags
    ctypedef int ImGuiTabItemFlags
    ctypedef int ImGuiTreeNodeFlags
    ctypedef int ImGuiWindowFlags
    # ctypedef int ImGuiColumnsFlags # REMOVED

    # ====
    # Various int typedefs and enumerations
    ctypedef void* ImTextureID
    ctypedef unsigned int ImGuiID
    ctypedef int (*ImGuiInputTextCallback)(ImGuiInputTextCallbackData *data);
    ctypedef void (*ImGuiSizeCallback)(ImGuiSizeCallbackData* data);
    
    # ====
    # Decoded character types
    ctypedef unsigned short ImWchar16
    ctypedef unsigned int ImWchar32
    ctypedef unsigned short ImWchar
    
    # ====
    # Basic scalar data types
    ctypedef signed char         ImS8 
    ctypedef unsigned char       ImU8 
    ctypedef signed short        ImS16
    ctypedef unsigned short      ImU16
    ctypedef signed int          ImS32
    ctypedef unsigned int        ImU32
    ctypedef signed   long long  ImS64
    ctypedef unsigned long long  ImU64
    
    
    # ====
    # 2D vector
    ctypedef struct ImVec2:
        float x
        float y
    
    # ====
    # 4D vector
    ctypedef struct ImVec4:
        float x
        float y
        float z
        float w
    
    ctypedef struct ImGuiIO:
    
        # ====
        # Configuration (fill once)
        ImGuiConfigFlags   ConfigFlags # ✗
        ImGuiBackendFlags  BackendFlags # ✗
        ImVec2        DisplaySize # ✓
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
        ImFont*       FontDefault # ✗
        ImVec2        DisplayFramebufferScale  # ✓
        #ImVec2        DisplayVisibleMin  # ✓ # DEPRECIATED
        #ImVec2        DisplayVisibleMax  # ✓ # DEPRECIATED
        
        # Miscellaneous options
        bool          MouseDrawCursor  # ✓
        bool          ConfigMacOSXBehaviors  # ✓
        bool          ConfigInputTextCursorBlink  # ✓
        #bool          ConfigResizeWindowsFromEdges  # ✓ # RENAMED
        bool          ConfigWindowsResizeFromEdges # ✓
        bool          ConfigWindowsMoveFromTitleBarOnly # ✗
        float         ConfigWindowsMemoryCompactTimer # ✗
        
        # ====
        # Platform Functions
        # Platform/Render
        const char* BackendPlatformName # ✗
        const char* BackendRendererName # ✗
        void*       BackendPlatformUserData # ✗
        void*       BackendRendererUserData # ✗
        void*       BackendLanguageUserData # ✗
        
        # Optional: Access OS clipboard
        # note: callbacks may wrap arbitrary Python code so we need to
        #       propagate exceptions from them (as well as C++ exceptions)
        const char* (*GetClipboardTextFn)(void* user_data) except +  # ✓
        void        (*SetClipboardTextFn)(void* user_data, const char* text) except +  # ✓
        void*       ClipboardUserData  # ✗
        
        # Optional: Notify OS Input Method Editor of the screen position of your cursor for text input position
        void        (*ImeSetInputScreenPosFn)(int x, int y) except +  # ✗
        void*       ImeWindowHandle  # ✗

        # ====
        # Input - Fill before calling NewFrame()
        ImVec2      MousePos  # ✓
        bool        MouseDown[5]  # ✓
        float       MouseWheel  # ✓
        float       MouseWheelH  # ✓
        bool        KeyCtrl  # ✓
        bool        KeyShift  # ✓
        bool        KeyAlt  # ✓
        bool        KeySuper  # ✓
        bool        KeysDown[512]  # ✓
        # note: originally NavInputs[ImGuiNavInput_COUNT]
        # todo: find a way to access enum var here
        ImWchar*    NavInputs  # ✗

        # Functions
        void        AddInputCharacter(ImWchar c) except +  # ✓
        void        AddInputCharacterUTF16(ImWchar16 c) except + # ✗
        void        AddInputCharactersUTF8(const char* utf8_chars) except +  # ✓
        void        ClearInputCharacters() except +  # ✓

        # ====
        # Output - Updated by NewFrame() or EndFrame()/Render()
        bool        WantCaptureMouse  # ✓
        bool        WantCaptureKeyboard  # ✓
        bool        WantTextInput  # ✓
        bool        WantSetMousePos  # ✓
        bool        WantSaveIniSettings  # ✓
        bool        NavActive  # ✓
        bool        NavVisible  # ✓
        float       Framerate  # ✓
        int         MetricsRenderVertices  # ✓
        int         MetricsRenderIndices  # ✓
        int         MetricsRenderWindows # ✗
        int         MetricsActiveWindows  # ✓
        int         MetricsActiveAllocations # ✗
        ImVec2      MouseDelta  # ✓

    cdef cppclass ImVector[T]:
        int        Size
        int        Capacity
        T*         Data


    ctypedef void (*ImDrawCallback)(const ImDrawList* parent_list, const ImDrawCmd* cmd)  # ✗

    ctypedef struct ImDrawCmd:  # ✓
        ImVec4         ClipRect  # ✓
        ImTextureID    TextureId  # ✓
        unsigned int   VtxOffset # ✗
        unsigned int   IdxOffset # ✗
        unsigned int   ElemCount  # ✓
        ImDrawCallback UserCallback  # ✗
        void*          UserCallbackData  # ✗


    # note: this is redefined in config-cpp/py_imconfig.h
    # (see: https://github.com/swistakm/pyimgui/issues/138)
    # (see: https://github.com/ocornut/imgui/issues/1188)
    ctypedef unsigned int ImDrawIdx


    ctypedef struct ImDrawVert:  # ✗
        ImVec2 pos  # ✗
        ImVec2 uv  # ✗
        ImU32  col  # ✗

    ctypedef struct ImDrawList:
        # we map only buffer vectors since everything else is internal
        # and right now we dont want to suport it.
        ImVector[ImDrawCmd]  CmdBuffer  # ✓
        ImVector[ImDrawIdx]  IdxBuffer  # ✓
        ImVector[ImDrawVert] VtxBuffer  # ✓
        ImDrawListFlags      Flags # ✗
        
        void PushClipRect( # ✗
            ImVec2 clip_rect_min, 
            ImVec2 clip_rect_max, 
            # note: optional
            bool intersect_with_current_clip_rect # = false
        ) except + 
        void PushClipRectFullScreen() except + # ✗
        void PopClipRect() except + # ✗
        void PushTextureID(ImTextureID texture_id) except + # ✗
        void PopTextureID() except + # ✗
        

        void AddLine(
            const ImVec2& a,
            const ImVec2& b,
            ImU32 col,
            # note: optional
            float thickness            # = 1.0f
        ) except +  # ✓


        void AddRect(
            const ImVec2& a,
            const ImVec2& b,
            ImU32 col,
            # note: optional
            float rounding,             # = 0.0f,
            ImDrawCornerFlags rounding_corners_flags, # = ImDrawCornerFlags_All,
            float thickness             # = 1.0f
        ) except +  # ✓


        void AddRectFilled(
            const ImVec2& a,
            const ImVec2& b,
            ImU32 col,
            # note: optional
            float rounding,            # = 0.0f
            ImDrawCornerFlags rounding_corners_flags # = ImDrawCornerFlags_All
        ) except +  # ✓
        
        void AddRectFilledMultiColor( # ✗
            const ImVec2& p_min, 
            const ImVec2& p_max, 
            ImU32 col_upr_left, 
            ImU32 col_upr_right, 
            ImU32 col_bot_right, 
            ImU32 col_bot_left
        ) except +
        
        void AddQuad( # ✗
            const ImVec2& p1, 
            const ImVec2& p2, 
            const ImVec2& p3, 
            const ImVec2& p4, 
            ImU32 col, 
            # note:optional
            float thickness         # = 1.0f
        ) except +
        
        void AddQuadFilled( # ✗
            const ImVec2& p1, 
            const ImVec2& p2, 
            const ImVec2& p3, 
            const ImVec2& p4, 
            ImU32 col
        ) except +
        
        void AddTriangle( # ✗
            const ImVec2& p1, 
            const ImVec2& p2, 
            const ImVec2& p3, 
            ImU32 col, 
            # note:optional
            float thickness         # = 1.0f
        ) except +
        
        void AddTriangleFilled( # ✗
            const ImVec2& p1, 
            const ImVec2& p2, 
            const ImVec2& p3, 
            ImU32 col
        ) except +
    
        void  AddCircle(
           const ImVec2& centre,
           float radius,
           ImU32 col,
           # note:optional
           int num_segments,           # = 0        # UPDATE
           float thickness             # = 1.0f
        ) except +  # ✓


        void AddCircleFilled(
           const ImVec2& centre,
           float radius,
           ImU32 col,
           # note:optional
           int num_segments            # = 0        # UPDATE
        ) except +  # ✓
        
        void AddNgon( # ✗
            const ImVec2& center, 
            float radius, 
            ImU32 col, 
            int num_segments, 
            # note:optional
            float thickness            # = 1.0f
        ) except +
        
        void AddNgonFilled( # ✗
            const ImVec2& center, 
            float radius, 
            ImU32 col, 
            int num_segments
        ) except +
    
        void AddText( # ✓
           const ImVec2& pos,
           ImU32 col,
           const char* text_begin,
           # note:optional
           const char* text_end        # = NULL
        ) except + 
        
        #void AddText( # ✗
        #    const ImFont* font, 
        #    float font_size, 
        #    const ImVec2& pos, 
        #    ImU32 col, 
        #    const char* text_begin, 
        #    # note:optional
        #    const char* text_end,       # = NULL
        #    float wrap_width,           # = 0.0f
        #    const ImVec4* cpu_fine_clip_rect # = NULL
        #) except +


        void AddPolyline(
            const ImVec2* points,
            int num_points,
            ImU32 col,
            bool closed,
            float thickness
        ) except +  # ✓
        
        void AddConvexPolyFilled( # ✗
            const ImVec2* points, 
            int num_points, 
            ImU32 col
        ) except +
        
        void AddBezierCurve( # ✗
            const ImVec2& p1, 
            const ImVec2& p2, 
            const ImVec2& p3, 
            const ImVec2& p4, 
            ImU32 col, 
            float thickness, 
            # note:optional
            int num_segments        # = 0
        ) except +
        
        # Image primitives
        void AddImage(
           ImTextureID user_texture_id,
           const ImVec2& a,
           const ImVec2& b,
           # note:optional
           const ImVec2& uv_a,         # = ImVec2(0,0)
           const ImVec2& uv_b,         # = ImVec2(1,1)
           ImU32 col                   # = 0xFFFFFFFF
        ) except +  # ✓
        
        void AddImageQuad( # ✗
            ImTextureID user_texture_id, 
            const ImVec2& p1, 
            const ImVec2& p2, 
            const ImVec2& p3, 
            const ImVec2& p4, 
            # note:optional
            const ImVec2& uv1,      # = ImVec2(0, 0)
            const ImVec2& uv2,      # = ImVec2(1, 0)
            const ImVec2& uv3,      # = ImVec2(1, 1)
            const ImVec2& uv4,      # = ImVec2(0, 1)
            ImU32 col               # = 0xFFFFFFFF
        ) except +
        
        void AddImageRounded( # ✗
            ImTextureID user_texture_id, 
            const ImVec2& p_min, 
            const ImVec2& p_max, 
            const ImVec2& uv_min, 
            const ImVec2& uv_max, 
            ImU32 col, 
            float rounding, 
            # note:optional
            ImDrawCornerFlags rounding_corners # = ImDrawCornerFlags_All
        ) except +

        # Stateful path API, add points then finish with PathFillConvex() or PathStroke()
        void PathClear() except + # ✗
        void PathLineTo(const ImVec2& pos) except + # ✗
        void PathLineToMergeDuplicate(const ImVec2& pos) except + # ✗
        void PathFillConvex(ImU32 col) except + # ✗
        void PathStroke( # ✗
            ImU32 col, 
            bool closed, 
            # note: optional
            float thickness         # = 1.0f
        ) except +
        void PathArcTo( # ✗
            const ImVec2& center, 
            float radius, 
            float a_min, 
            float a_max, 
            # note: optional
            int num_segments        # = 10
        ) except +
        void PathArcToFast( # ✗
            const ImVec2& center, 
            float radius, 
            int a_min_of_12, 
            int a_max_of_12
        ) except +
        void PathBezierCurveTo( # ✗
            const ImVec2& p2, 
            const ImVec2& p3, 
            const ImVec2& p4, 
            # note: optional
            int num_segments        # = 0
        ) except +
        void PathRect( # ✗ 
            const ImVec2& rect_min, 
            const ImVec2& rect_max, 
            # note: optional
            float rounding,         # = 0.0f
            ImDrawCornerFlags rounding_corners # = ImDrawCornerFlags_All
        ) except +

        # Advanced
        void AddCallback(ImDrawCallback callback, void* callback_data) except + # ✗
        void AddDrawCmd() except + # ✗
        ImDrawList* CloneOutput() except + # ✗
        
        # Advanced: Channels
        void ChannelsSplit(int channels_count) except + # ✓
        void ChannelsMerge() except + # ✓
        void ChannelsSetCurrent(int idx) except + # ✓
        
        # Advanced: Primitives allocations
        void PrimReserve(int idx_count, int vtx_count) except + # ✗
        void PrimUnreserve(int idx_count, int vtx_count) except + # ✗
        void PrimRect(const ImVec2& a, const ImVec2& b, ImU32 col) except + # ✗
        void PrimRectUV(const ImVec2& a, const ImVec2& b, const ImVec2& uv_a, const ImVec2& uv_b, ImU32 col) except + # ✗
        void PrimQuadUV(const ImVec2& a, const ImVec2& b, const ImVec2& c, const ImVec2& d, const ImVec2& uv_a, const ImVec2& uv_b, const ImVec2& uv_c, const ImVec2& uv_d, ImU32 col) except + # ✗
        inline void  PrimWriteVtx(const ImVec2& pos, const ImVec2& uv, ImU32 col) except + # ✗
        inline void  PrimWriteIdx(ImDrawIdx idx) except + # ✗
        inline void  PrimVtx(const ImVec2& pos, const ImVec2& uv, ImU32 col) except + # ✗


    ctypedef struct ImDrawData:  # ✓
        bool            Valid  # ✓
        ImDrawList**    CmdLists  # ✓
        int             CmdListsCount  # ✓
        int             TotalIdxCount  # ✓
        int             TotalVtxCount  # ✓
        ImVec2          DisplayPos # ✗
        ImVec2          DisplaySize # ✗
        ImVec2          FramebufferScale # ✗
        
        void            DeIndexAllBuffers() except +  # ✓
        void            ScaleClipRects(const ImVec2&) except +  # ✓
        
    ctypedef struct ImFontAtlasCustomRect: # TODO
        pass

    ctypedef struct ImFontConfig:
        void*           FontData # ✗
        int             FontDataSize # ✗
        bool            FontDataOwnedByAtlas # ✗
        int             FontNo # ✗
        float           SizePixels # ✗
        int             OversampleH # ✗
        int             OversampleV # ✗
        bool            PixelSnapH # ✗
        ImVec2          GlyphExtraSpacing # ✗
        ImVec2          GlyphOffset # ✗
        const ImWchar*  GlyphRanges # ✗
        float           GlyphMinAdvanceX # ✗
        float           GlyphMaxAdvanceX # ✗
        bool            MergeMode # ✗
        unsigned int    RasterizerFlags # ✗
        float           RasterizerMultiply # ✗
        ImWchar         EllipsisChar # ✗
        
        # ImFontConfig()  # ✗
        

    ctypedef struct ImFont: # TODO
        pass

    ctypedef struct ImFontAtlas:  # ✓
        
        bool                Locked # ✗
        ImFontAtlasFlags    Flags # ✗
        void*               TexID  # ✓
        int                 TexDesiredWidth # ✗
        int                 TexGlyphPadding # ✗

        ImFont* AddFont(const ImFontConfig* font_cfg) except + # ✗
        
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
        ImFont* AddFontFromMemoryTTF( # ✗
            void* font_data, 
            int font_size, 
            float size_pixels, 
            # note: optional
            const ImFontConfig* font_cfg,       # = NULL
            const ImWchar* glyph_ranges         # = NULL
        ) except +
        ImFont* AddFontFromMemoryCompressedTTF( # ✗
            const void* compressed_font_data, 
            int compressed_font_size, 
            float size_pixels, 
            # note: optional
            const ImFontConfig* font_cfg,       # = NULL
            const ImWchar* glyph_ranges         # = NULL
        ) except +
        ImFont* AddFontFromMemoryCompressedBase85TTF( # ✗
            const char* compressed_font_data_base85, 
            float size_pixels, 
            # note: optional
            const ImFontConfig* font_cfg,       # = NULL
            const ImWchar* glyph_ranges         # = NULL
        ) except +

        void ClearInputData() except +  # ✓
        void ClearTexData() except +  # ✓
        void ClearFonts() except +  # ✓
        void Clear() except +  # ✓
        
        
        bool Build() except + # ✗
        void GetTexDataAsAlpha8(unsigned char**, int*, int*, int* = NULL) except +  # ✓
        void GetTexDataAsRGBA32(unsigned char**, int*, int*, int* = NULL) except +  # ✓
        bool IsBuilt() except + # ✗
        void SetTexID(ImTextureID id) except + # ✗

        const ImWchar* GetGlyphRangesDefault() except +  # ✓
        const ImWchar* GetGlyphRangesKorean() except +  # ✓
        const ImWchar* GetGlyphRangesJapanese() except +  # ✓
        const ImWchar* GetGlyphRangesChineseFull() except +  # ✓
        const ImWchar* GetGlyphRangesChineseSimplifiedCommon() except +  # ✓
        const ImWchar* GetGlyphRangesCyrillic() except +  # ✓
        const ImWchar* GetGlyphRangesThai() except + # ✗
        const ImWchar* GetGlyphRangesVietnamese() except + # ✗
        
        # ====
        # [BETA] Custom Rectangles/Glyphs API
        int AddCustomRectRegular(int width, int height)  except + # ✗
        int AddCustomRectFontGlyph( # ✗
            ImFont* font, ImWchar id, 
            int width, int height, 
            float advance_x, 
            # note: optional
            const ImVec2& offset            # = ImVec2(0, 0)
        ) except +
        ImFontAtlasCustomRect* GetCustomRectByIndex(int index) except + # ✗

    ctypedef struct ImGuiStorage: # TODO
        pass

    cdef cppclass ImGuiStyle:
        float       Alpha  # ✓
        ImVec2      WindowPadding  # ✓
        float       WindowRounding  # ✓
        float       WindowBorderSize  # ✓
        ImVec2      WindowMinSize  # ✓
        ImVec2      WindowTitleAlign  # ✓
        ImGuiDir    WindowMenuButtonPosition # ✗
        float       ChildRounding  # ✓
        float       ChildBorderSize  # ✓
        float       PopupRounding  # ✓
        float       PopupBorderSize  # ✓
        ImVec2      FramePadding  # ✓
        float       FrameRounding  # ✓
        float       FrameBorderSize  # ✓
        ImVec2      ItemSpacing  # ✓
        ImVec2      ItemInnerSpacing  # ✓
        ImVec2      TouchExtraPadding  # ✓
        float       IndentSpacing  # ✓
        float       ColumnsMinSpacing  # ✓
        float       ScrollbarSize  # ✓
        float       ScrollbarRounding  # ✓
        float       GrabMinSize  # ✓
        float       GrabRounding  # ✓
        float       LogSliderDeadzone # ✗
        float       TabRounding # ✗
        float       TabBorderSize # ✗
        float       TabMinWidthForCloseButton # ✗
        ImGuiDir    ColorButtonPosition # ✗
        ImVec2      ButtonTextAlign  # ✓
        ImVec2      SelectableTextAlign # ✗
        ImVec2      DisplayWindowPadding  # ✓
        ImVec2      DisplaySafeAreaPadding  # ✓
        float       MouseCursorScale   # ✓
        bool        AntiAliasedLines  # ✓
        bool        AntiAliasedLinesUseTex # ✗
        bool        AntiAliasedFill  # ✓
        float       CurveTessellationTol  # ✓
        float       CircleSegmentMaxError

        # note: originally Colors[ImGuiCol_COUNT]
        # todo: find a way to access enum var here
        ImVec4*     Colors
        
        void ScaleAllSizes(float scale_factor) except + # ✗

    ctypedef struct ImGuiPayload:
        void* Data  # ✓
        int   DataSize  # ✓

    ctypedef struct ImGuiContext:
        pass

cdef extern from "imgui.h" namespace "ImGui":
    # ====
    # Context creation and access
    ImGuiContext* CreateContext(  # ✓
            # note: optional
            ImFontAtlas* shared_font_atlas
    ) except +
    void DestroyContext(# ✓
            # note: optional
            ImGuiContext* ctx
    ) except +  
    ImGuiContext* GetCurrentContext() except +  # ✓
    void SetCurrentContext(ImGuiContext* ctx) except +  # ✓

    # ====
    # Main
    ImGuiIO& GetIO() except +  # ✓
    ImGuiStyle& GetStyle() except +  # ✓
    void NewFrame() except +  # ✓
    void EndFrame() except +  # ✓
    # note: Render runs callbacks that may be arbitrary Python code
    #       so we need to propagate exceptions from them
    void Render() except +  # ✓
    ImDrawData* GetDrawData() except +  # ✓
    
    # TODO: Shouldn't this be elsewhere? Member of ImGuiStyle
    void ScaleAllSizes(float scale_factor) except +  # ✗
    
    # ====
    # Demo, Debug, Information
    void ShowDemoWindow(bool* p_open) except +  # ✓
    void ShowDemoWindow() except +  # ✓
    void ShowMetricsWindow(bool* p_open) except +  # ✓
    void ShowMetricsWindow() except +  # ✓
    void ShowStyleEditor(ImGuiStyle* ref) except +  # ✓
    void ShowStyleEditor() except +  # ✓
    bool ShowStyleSelector(const char* label) except +  # ✓
    void ShowFontSelector(const char*) except +  # ✓
    void ShowUserGuide() except +  # ✓
    const char* GetVersion() except +  # ✓

    # ====
    # Styles
    void StyleColorsDark(ImGuiStyle* dst) except +  # ✓
    void StyleColorsClassic(ImGuiStyle* dst) except +  # ✓
    void StyleColorsLight(ImGuiStyle* dst) except +  # ✓

    # ====
    # Window
    bool Begin(const char*, bool* p_open, ImGuiWindowFlags) except + # ✓
    # note: following API was deprecated
    # bool Begin(const char*, bool*, const ImVec2&, float, ImGuiWindowFlags)
    void End() except +  # ✓
    
    # ====
    # Child Windows
    bool BeginChild(const char*, const ImVec2&, bool, ImGuiWindowFlags) except +  # ✓
    bool BeginChild(const char*, const ImVec2&, bool) except +  # ✓
    bool BeginChild(const char*, const ImVec2&) except +  # ✓
    bool BeginChild(const char*) except +  # ✓
    bool BeginChild(ImGuiID, const ImVec2&, bool, ImGuiWindowFlags) except +  # ✓
    bool BeginChild(ImGuiID, const ImVec2&, bool) except +  # ✓
    bool BeginChild(ImGuiID, const ImVec2&) except +  # ✓
    bool BeginChild(ImGuiID) except +  # ✓
    void EndChild() except +  # ✓

    # ====
    # Windows Utilities
    bool IsWindowAppearing() except +  # ✓
    bool IsWindowCollapsed() except +  # ✓
    bool IsWindowFocused(ImGuiFocusedFlags flags) except +  # ✓
    bool IsWindowHovered(ImGuiFocusedFlags flags) except +  # ✓
    ImDrawList* GetWindowDrawList() except +  # ✓
    ImDrawList* GetOverlayDrawList() except + # ✓ # OBSOLETED in 1.69 (from Mar 2019)
    ImVec2 GetWindowPos() except +  # ✓
    ImVec2 GetWindowSize() except +  # ✓
    float GetWindowWidth() except +  # ✓
    float GetWindowHeight() except +  # ✓
    
    void SetNextWindowPos(  # ✓ note: overrides ommited
            const ImVec2& pos,
            # note: optional
            ImGuiCond cond,
            const ImVec2& pivot
    ) except +
    void SetNextWindowSize(  # ✓ note: overrides ommited
            const ImVec2& size,
            # note: optional
            ImGuiCond cond
    ) except +
    void SetNextWindowSizeConstraints(  # ✓
            const ImVec2& size_min,
            const ImVec2& size_max,
            ImGuiSizeCallback custom_callback,
            void* custom_callback_data
    ) except +
    void SetNextWindowContentSize(const ImVec2& size) except +  # ✓
    void SetNextWindowCollapsed(  # ✓
            bool collapsed,
            # note: optional
            ImGuiCond cond
    ) except +
    void SetNextWindowFocus() except +  # ✓
    void SetNextWindowBgAlpha(float alpha) except +  # ✓
    void SetWindowPos(  # ✓
            const ImVec2& pos,
            # note: optional
            ImGuiCond cond
    ) except +
    void SetWindowSize(  # ✓
            const ImVec2& size,
            # note: optional
            ImGuiCond cond
    ) except +
    void SetWindowCollapsed(  # ✓
            bool collapsed,
            # note: optional
            ImGuiCond cond
    ) except +
    void SetWindowFocus() except +  # ✓
    void SetWindowFontScale(float scale) except +  # ✓
    void SetWindowPos(  # ✓
            const char* name, const ImVec2& pos,
            # note: optional
            ImGuiCond cond
    ) except +
    void SetWindowSize(  # ✓
            const char* name, const ImVec2& size, ImGuiCond
            cond
    ) except +
    void SetWindowCollapsed(  # ✓
            const char* name, bool collapsed,
            # note: optional
            ImGuiCond cond
    ) except +
    void SetWindowFocus(const char* name) except +  # ✓
    
    # ====
    # Content region
    ImVec2 GetContentRegionMax() except +  # ✓
    ImVec2 GetContentRegionAvail() except +  # ✓
    float GetContentRegionAvailWidth() except +  # ✓ # OBSOLETED in 1.70 (from May 2019)
    ImVec2 GetWindowContentRegionMin() except +  # ✓
    ImVec2 GetWindowContentRegionMax() except +  # ✓
    float GetWindowContentRegionWidth() except +  # ✓

    # ====
    # Windows Scrolling
    float GetScrollX() except +  # ✓
    float GetScrollY() except +  # ✓
    float GetScrollMaxX() except +  # ✓
    float GetScrollMaxY() except +  # ✓
    void SetScrollX(float scroll_x) except +  # ✓
    void SetScrollY(float scroll_y) except +  # ✓
    void SetScrollHere(  # ✓ # OBSOLETED in 1.66 (from Sep 2018)
            # note: optional
            float center_y_ratio
    ) except +
    void SetScrollHereX(float center_x_ratio) except + # ✓
    void SetScrollHereY(float center_y_ratio) except + # ✓
    void SetScrollFromPosX( # ✓
            float local_x, 
            # note: optional
            float center_x_ratio
    ) except +
    void SetScrollFromPosY(  # ✓
            float local_y,
            # note: optional
            float center_y_ratio
    ) except +

    # ====
    # Parameters stacks (shared)
    void PushFont(ImFont*) except +  # ✓
    void PopFont() except +  # ✓
    void PushStyleColor(ImGuiCol idx, ImU32 col) except +  # ✗
    void PushStyleColor(ImGuiCol idx, const ImVec4&) except +  # ✓
    void PopStyleColor(int) except +  # ✓
    void PushStyleVar(ImGuiStyleVar, float) except +  # ✓
    void PushStyleVar(ImGuiStyleVar, const ImVec2&) except +  # ✓
    void PopStyleVar(int) except +  # ✓
    ImVec4& GetStyleColorVec4(ImGuiCol idx) except +  # ✓
    ImFont* GetFont() except +  # ✗
    float GetFontSize() except +  # ✓
    ImVec2 GetFontTexUvWhitePixel() except +  # ✓
    ImU32 GetColorU32(ImGuiCol, float) except +  # ✓
    ImU32 GetColorU32(const ImVec4& col) except +  # ✓
    ImU32 GetColorU32(ImU32 col) except +  # ✓

    # ====
    # Parameters stacks (current window)
    void PushItemWidth(float item_width) except +  # ✓
    void PopItemWidth() except +  # ✓
    void SetNextItemWidth(float item_width) except + # ✗
    float CalcItemWidth() except +  # ✓
    void PushTextWrapPos(float wrap_local_pos_x) except +  # ✓
    void PopTextWrapPos() except +  # ✓
    void PushAllowKeyboardFocus(bool allow_keyboard_focus) except +  # ✓
    void PopAllowKeyboardFocus() except +  # ✓
    void PushButtonRepeat(bool repeat) except +  # ✓
    void PopButtonRepeat() except +  # ✓

    # ====
    # Cursor / Layout
    void Separator() except +  # ✓
    void SameLine(  # ✓
            # note: optional
            float offset_from_start_x, float spacing # API CHANGE
    ) except +
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
    ImVec2 GetCursorPos() except +  # ✓
    float GetCursorPosX() except +  # ✓
    float GetCursorPosY() except +  # ✓
    void SetCursorPos(const ImVec2& local_pos) except +  # ✓
    void SetCursorPosX(float local_x) except +  # ✓
    void SetCursorPosY(float local_y) except +  # ✓
    ImVec2 GetCursorStartPos() except +  # ✓
    ImVec2 GetCursorScreenPos() except +  # ✓
    void SetCursorScreenPos(const ImVec2& pos) except +  # ✓
    void AlignTextToFramePadding() except +  # ✓
    float GetTextLineHeight() except +  # ✓
    float GetTextLineHeightWithSpacing() except +  # ✓
    float GetFrameHeight() except +  # ✓
    float GetFrameHeightWithSpacing() except +  # ✓

    # ====
    # ID stack/scopes
    void PushID(const char* str_id) except +  # ✓
    void PushID(const char* str_id_begin, const char* str_id_end) except +  # ✗
    void PushID(const void* ptr_id) except +  # ✗
    void PushID(int int_id) except +  # ✗
    void PopID() except +  # ✓
    ImGuiID GetID(const char* str_id) except +  # ✓
    ImGuiID GetID(const char* str_id_begin, const char* str_id_end) except +  # ✗
    ImGuiID GetID(const void* ptr_id) except +  # ✗

    # ====
    # Widgets: Text
    void TextUnformatted(const char*) except +  # ✓
    void Text(const char*, ...) except +  # ✓
    # TextV ?
    void TextColored(const ImVec4&, const char*, ...) except +  # ✓
    # TextColoredV ?
    void TextDisabled(const char*, ...) except +  # ✓
    # TextDisabledV ?
    void TextWrapped(const char*, ...) except +  # ✓
    # TextWrappedV ?
    void LabelText(const char*, const char*, ...) except +  # ✓
    # LabelTextV ?
    void BulletText(const char*, ...) except +  # ✓
    # BulletTextV ?

    # ====
    # Widgets: Main
    bool Button(const char*, const ImVec2& size) except +  # ✓
    bool Button(const char*) except +  # ✓
    bool SmallButton(const char*) except +  # ✓
    bool InvisibleButton(const char*, const ImVec2& size) except +  # ✓
    bool ArrowButton(const char*, ImGuiDir) except +  # ✓
    void Image(  # ✓
            ImTextureID user_texture_id, const ImVec2& size,
            # note: optional
            const ImVec2& uv0, const ImVec2& uv1, const ImVec4& tint_col,
            const ImVec4& border_col
    ) except +  
    bool ImageButton(  # ✓
            ImTextureID user_texture_id, const ImVec2& size,
            # note: optional
            const ImVec2& uv0, const ImVec2& uv1, int frame_padding,
            const ImVec4& bg_col, const ImVec4& tint_col
    ) except +
    bool Checkbox(const char* label, bool* v) except +  # ✓
    bool CheckboxFlags(  # ✓
            const char* label, unsigned int* flags, unsigned int flags_value
    ) except +
    bool RadioButton(const char* label, bool active) except +  # ✓
    # note: probably no reason to support it
    bool RadioButton(const char* label, int* v, int v_button) except +  # ✓
    void ProgressBar(  # ✓
            float fraction,
            # note: optional
            const ImVec2& size_arg, const char* overlay
    ) except +  
    void Bullet() except +  # ✓

    # ====
    # Widgets: Combo Box
    bool BeginCombo( # ✗
            const char* label, 
            const char* preview_value, 
            ImGuiComboFlags flags
    ) except + 
    bool EndCombo() except + # ✗
    bool Combo(  # ✓
            const char* label, int* current_item,
            const char* items_separated_by_zeros,
            # note: optional
            int popup_max_height_in_items
    ) except +  
    # note: we only implemented the null-separated version that is fully
    #       compatible with following. Probably no reason to support it
    bool Combo(  # ✓
            const char* label, int* current_item,
            const char** items, int items_count,
            # note: optional
            int popup_max_height_in_items
    ) except +
    bool Combo(  # ✗
            const char* label, int* current_item,
            bool (*items_getter)(void* data, int idx, const char** out_text),
            void* data, int items_count,
            # note: optional
            int popup_max_height_in_items
    ) except +  
    
    # ====
    # Widgets: Drag Sliders
    # manually input values aren't clamped, can go off-bounds) except +  # For all the Float2/Float3/Float4/Int2/Int3/Int4 versions of every
    # functions, remember than a 'float v[3]' function argument is the same
    # as 'float* v'. You can pass address of your first element out of a
    # contiguous set, e.g. &myvector.x
    bool DragFloat( # ✗
            const char* label, float* v, 
            # note: optional
            float v_speed, float v_min, float v_max, 
            const char* format, ImGuiSliderFlags flags
    ) except +
    bool DragFloat(  # ✓ # OBSOLETED in 1.78 (from June 2020)
            const char* label, float* v,
            # note: optional
            float v_speed, float v_min, float v_max,
            const char* format, float power
    ) except +
    bool DragFloat2( # ✗
            const char* label, float v[2], 
            # note: optional
            float v_speed, float v_min, float v_max, 
            const char* format, ImGuiSliderFlags flags
    ) except +
    bool DragFloat2(  # ✓ # OBSOLETED in 1.78 (from June 2020)
            const char* label, float v[2],
            # note: optional
            float v_speed, float v_min, float v_max,
            const char* format, float power
    ) except +
    bool DragFloat3( # ✗
            const char* label, float v[3], 
            # note: optional
            float v_speed, float v_min, float v_max, 
            const char* format, ImGuiSliderFlags flags
    ) except +
    bool DragFloat3(  # ✓ # OBSOLETED in 1.78 (from June 2020)
            const char* label, float v[3],
            # note: optional
            float v_speed, float v_min, float v_max,
            const char* format, float power
    ) except +
    bool DragFloat4( # ✗
            const char* label, float v[4], 
            # note: optional
            float v_speed, float v_min, float v_max, 
            const char* format, ImGuiSliderFlags flags
    ) except +
    bool DragFloat4(  # ✓ # OBSOLETED in 1.78 (from June 2020)
            const char* label, float v[4],
            # note: optional
            float v_speed, float v_min, float v_max,
            const char* format, float power
    ) except +
    bool DragFloatRange2( # ✗
            const char* label, float* v_current_min, float* v_current_max, 
            # note: optional
            float v_speed, float v_min, float v_max, 
            const char* format, 
            const char* format_max, 
            ImGuiSliderFlags flags
    ) except +
    bool DragFloatRange2(  # ✗
            const char* label, float* v_current_min, float* v_current_max,
            # note: optional
            float v_speed, float v_min, float v_max,
            const char* format,
            const char* format_max, float power
    ) except +
    bool DragInt(  # ✓
            const char* label, int* v,
            # note: optional
            float v_speed, int v_min, int v_max,
            const char* format,
            ImGuiSliderFlags flags # NEW
    ) except +
    bool DragInt2(  # ✓
            const char* label, int v[2],
            # note: optional
            float v_speed, int v_min, int v_max,
            const char* format,
            ImGuiSliderFlags flags # NEW
    ) except +
    bool DragInt3(  # ✓
            const char* label, int v[3],
            # note: optional
            float v_speed, int v_min, int v_max,
            const char* format,
            ImGuiSliderFlags flags # NEW
    ) except +
    bool DragInt4(  # ✓
            const char* label, int v[4],
            # note: optional
            float v_speed, int v_min, int v_max,
            const char* format,
            ImGuiSliderFlags flags # NEW
    ) except +
    bool DragIntRange2(  # ✗
            const char* label, int* v_current_min, int* v_current_max,
            # note: optional
            float v_speed, int v_min, int v_max,
            const char* format,
            const char* format_max,
            ImGuiSliderFlags flags # NEW
    ) except +  # Widgets: Input with Keyboard
    bool DragScalar( # ✗
            const char* label, 
            ImGuiDataType data_type, 
            void* p_data, 
            float v_speed, 
            # note: optional
            const void* p_min, const void* p_max, 
            const char* format, ImGuiSliderFlags flags
    ) except +
    bool DragScalar(  # ✗ # OBSOLETED in 1.78 (from June 2020)
            const char* label,
            ImGuiDataType data_type, void* v,
            float v_speed,
            # note: optional
            const void* v_min,
            const void* v_max,
            const char* format,
            float power
    )
    bool DragScalarN( # ✗
            const char* label, 
            ImGuiDataType data_type, 
            void* p_data, 
            int components, 
            float v_speed, 
            # note: optional
            const void* p_min, const void* p_max, 
            const char* format, ImGuiSliderFlags flags
    ) except +
    bool DragScalarN(  # ✗ # OBSOLETED in 1.78 (from June 2020)
            const char* label,
            ImGuiDataType data_type, void* v,
            int components, float v_speed,
            # note: optional
            const void* v_min,
            const void* v_max,
            const char* format,
            float power)
    
    # ====
    # Widgets: Regular Sliders
    #  manually input values aren't clamped, can go off-bounds)
    bool SliderFloat(  # ✗
            const char* label, float* v, float v_min, float v_max,
            # note: optional
            const char* format, ImGuiSliderFlags flags
    ) except +
    bool SliderFloat(  # ✓ # OBSOLETED in 1.78 (from June 2020)
            const char* label, float* v, float v_min, float v_max,
            # note: optional
            const char* format, float power
    ) except +
    bool SliderFloat2(  # ✗
            const char* label, float v[2], float v_min, float v_max,
            # note: optional
            const char* format, ImGuiSliderFlags flags
    ) except +
    bool SliderFloat2(  # ✓ # OBSOLETED in 1.78 (from June 2020)
            const char* label, float v[2], float v_min, float v_max,
            # note: optional
            const char* format, float power
    ) except +
    bool SliderFloat3(  # ✗
            const char* label, float v[3], float v_min, float v_max,
            # note: optional
            const char* format, ImGuiSliderFlags flags
    ) except +
    bool SliderFloat3(  # ✓ # OBSOLETED in 1.78 (from June 2020)
            const char* label, float v[3], float v_min, float v_max,
            # note: optional
            const char* format, float power
    ) except +
    bool SliderFloat4(  # ✗
            const char* label, float v[4], float v_min, float v_max,
            # note: optional
            const char* format, ImGuiSliderFlags flags
    ) except +
    bool SliderFloat4(  # ✓ # OBSOLETED in 1.78 (from June 2020)
            const char* label, float v[4], float v_min, float v_max,
            # note: optional
            const char* format, float power
    ) except +
    bool SliderAngle(  # ✗
            const char* label, float* v_rad,
            # note: optional
            float v_degrees_min, float v_degrees_max,
            const char* format, ImGuiSliderFlags flags
    ) except +
    bool SliderInt(  # ✓
            const char* label, int* v, int v_min, int v_max,
            # note: optional
            const char* format,
            ImGuiSliderFlags flags # NEW
    ) except +
    bool SliderInt2(  # ✓
            const char* label, int v[2], int v_min, int v_max,
            # note: optional
            const char* format,
            ImGuiSliderFlags flags # NEW
    ) except +
    bool SliderInt3(  # ✓
            const char* label, int v[3], int v_min, int v_max,
            # note: optional
            const char* format,
            ImGuiSliderFlags flags # NEW
    ) except +
    bool SliderInt4(  # ✓
            const char* label, int v[4], int v_min, int v_max,
            # note: optional
            const char* format,
            ImGuiSliderFlags flags # NEW
    ) except +
    bool SliderScalar( # ✗
            const char* label, ImGuiDataType data_type,
            void* v, const void* v_min, const void* v_max,
            # note: optional
            const char* format, ImGuiSliderFlags flags);
    bool SliderScalarN( # ✗
            const char* label, ImGuiDataType data_type,
            void *v,
            int components, const void* v_min, const void* v_max,
            # note: optional
            const char* format, ImGuiSliderFlags flags);
    bool VSliderFloat(  # ✓
            const char* label, const ImVec2& size, float* v,
            float v_min, float v_max,
            # note: optional
            const char* format, ImGuiSliderFlags flags
    ) except +
    bool VSliderInt(  # ✓
            const char* label, const ImVec2& size, int* v, int v_min, int v_max,
            # note: optional
            const char* format,
            ImGuiSliderFlags flags # NEW
    ) except +  # Widgets: Trees
    bool VSliderScalar(  # ✗
            const char* label, const ImVec2& size, ImGuiDataType data_type, void* v, const void* v_min, const void* v_max,
            # note: optional
            const char* format,
            ImGuiSliderFlags flags
    ) except +
    
    # ====
    # Widgets: Input with Keyboard
    bool InputText(  # ✓
            const char* label, char* buf, size_t buf_size,
            # note: optional
            ImGuiInputTextFlags flags,
            ImGuiInputTextCallback callback, void* user_data
    ) except +
    bool InputTextMultiline(  # ✓
            const char* label, char* buf, size_t buf_size,
            # note: optional
            const ImVec2& size, ImGuiInputTextFlags flags,
            ImGuiInputTextCallback callback, void* user_data
    ) except +
    bool InputTextWithHint( # ✗
            const char* label, const char* hint, char* buf, 
            size_t buf_size, 
            # note: optional
            ImGuiInputTextFlags flags, 
            ImGuiInputTextCallback callback, void* user_data
    ) except +
    bool InputFloat(  # ✗
            const char* label, float* v,
            # note: optional
            float step, float step_fast,
            const char* format,
            ImGuiInputTextFlags flags
    ) except +
    bool InputFloat(  # ✓ # OBSOLETED in 1.61 (between Apr 2018 and Aug 2018)
            const char* label, float* v,
            # note: optional
            float step, float step_fast,
            const char* format,
            ImGuiInputTextFlags extra_flags
    ) except +
    bool InputFloat2(  # ✗
            const char* label, float v[2],
            # note: optional
            const char* format,
            ImGuiInputTextFlags flags
    ) except +
    bool InputFloat2(  # ✓ # OBSOLETED in 1.61 (between Apr 2018 and Aug 2018)
            const char* label, float v[2],
            # note: optional
            const char* format,
            ImGuiInputTextFlags extra_flags
    ) except +
    bool InputFloat3(  # ✗
            const char* label, float v[3],
            # note: optional
            const char* format,
            ImGuiInputTextFlags flags
    ) except +
    bool InputFloat3(  # ✓ # OBSOLETED in 1.61 (between Apr 2018 and Aug 2018)
            const char* label, float v[3],
            # note: optional
            const char* format,
            ImGuiInputTextFlags extra_flags
    ) except +
    bool InputFloat4(  # ✗
            const char* label, float v[4],
            # note: optional
            const char* format,
            ImGuiInputTextFlags flags
    ) except +
    bool InputFloat4(  # ✓ # OBSOLETED in 1.61 (between Apr 2018 and Aug 2018)
            const char* label, float v[4],
            # note: optional
            const char* format,
            ImGuiInputTextFlags extra_flags
    ) except +
    bool InputInt(  # ✓
            const char* label, int* v,
            # note: optional
            int step, int step_fast,
            ImGuiInputTextFlags flags
    ) except +
    bool InputInt2(  # ✓
            const char* label, int v[2],
            # note: optional
            ImGuiInputTextFlags flags
    ) except +
    bool InputInt3(  # ✓
            const char* label, int v[3],
            # note: optional
            ImGuiInputTextFlags flags
    ) except +
    bool InputInt4(  # ✓
            const char* label, int v[4],
            # note: optional
            ImGuiInputTextFlags flags
    ) except +  
    bool InputDouble(  # ✓
            const char* label, double v,
            # note: optional
            double step, int step_fast,
            const char* format,
            ImGuiInputTextFlags flags
    ) except +
    bool InputScalar( # ✗
            const char* label, ImGuiDataType data_type, void* p_data, 
            # note: optional
            const void* p_step, 
            const void* p_step_fast, 
            const char* format, 
            ImGuiInputTextFlags flags
    ) except +
    bool InputScalar(  # ✗ # OBSOLETED in 1.78 (from June 2020)
            const char* label, ImGuiDataType data_type, void* v,
            # note: optional
            const void* step,
            const void* step_fast,
            const char* format,
            ImGuiInputTextFlags extra_flags
    ) except +
    bool InputScalarN( # ✗
            const char* label, ImGuiDataType data_type, 
            void* p_data, int components, 
            # note: optional
            const void* p_step, 
            const void* p_step_fast, 
            const char* format, 
            ImGuiInputTextFlags flags
    ) except +
    bool InputScalarN(  # ✗ # OBSOLETED in 1.78 (from June 2020)
            const char* label, ImGuiDataType data_type,
            void* v, int components,
            # note: optional
            const void* step,
            const void* step_fast,
            const char* format,
            ImGuiInputTextFlags extra_flags
    ) except +
    
    # ====
    # Widgets: Color Editor/Picker
    bool ColorEdit3( # ✓
            const char* label, 
            float col[3],
            # note: optional
            ImGuiColorEditFlags flags # NEW
    ) except + 
    bool ColorEdit4(  # ✓
            const char* label, float col[4],
            # note: optional
            ImGuiColorEditFlags flags # API CHANGE
    ) except +  
    #void ColorEditMode(ImGuiColorEditMode mode) except +  # note: obsoleted
    bool ColorPicker3( # ✗
            const char* label, float col[3], 
            # note: optional
            ImGuiColorEditFlags flags
    ) except + 
    bool ColorPicker4( # ✗
            const char* label, float col[4], 
            # note: optional
            ImGuiColorEditFlags flags, 
            const float* ref_col
    ) except +
    bool ColorButton(  # ✓
            const char *desc_id,
            const ImVec4& col,
            # note: optional
            ImGuiColorEditFlags flags,
            ImVec2 size
    ) except + 
    void SetColorEditOptions(ImGuiColorEditFlags flags) except + # ✗

    # ====
    # Widgets: Trees
    bool TreeNode(const char* label) except +  # ✓
    # bool TreeNode(const char* str_id, const char* fmt, ...) except +  # ✗
    # bool TreeNode(const void* ptr_id, const char* fmt, ...) except +  # ✗
    # bool TreeNodeV(const char* str_id, const char* fmt, va_list args) except +  # ✗
    # bool TreeNodeV(const void* ptr_id, const char* fmt, va_list args) except +  # ✗
    bool TreeNodeEx(  # ✓
            const char* label,
            # note: optional
            ImGuiTreeNodeFlags flags
    ) except +  
    # bool TreeNodeEx(const char* str_id, ImGuiTreeNodeFlags flags, const char* fmt, ...) except +  # ✗
    # bool TreeNodeEx(const void* ptr_id, ImGuiTreeNodeFlags flags, const char* fmt, ...) except +  # ✗
    # bool TreeNodeExV(const char* str_id, ImGuiTreeNodeFlags flags, const char* fmt, va_list args) except +  # ✗
    # bool TreeNodeExV(const void* ptr_id, ImGuiTreeNodeFlags flags, const char* fmt, va_list args) except +  # ✗
    void TreePush(  # ✗
            # note: optional
            const char* str_id
    ) except +
    void TreePush(  # ✗
            # note: optional
            const void* ptr_id
    ) except +
    void TreePop() except +  # ✓
    void TreeAdvanceToLabelPos() except +  # ✗ # OBSOLETED in 1.72 (from April 2019)
    float GetTreeNodeToLabelSpacing() except +  # ✗
    void SetNextTreeNodeOpen(  # ✗ # OBSOLETED in 1.72 (from April 2019)
            bool is_open,
            # note: optional
            ImGuiCond cond
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
    ) except +  
    void SetNextItemOpen( # ✗
            bool is_open, 
            # note: open
            ImGuiCond cond
    ) except +
    
    # ====
    # Widgets: Selectable
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

    # ====
    # Widgets: List Boxes
    bool ListBox(  # ✓
            const char* label, int* current_item, const char* items[],
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

    # ====
    # Widgets: Data Plotting
    void PlotLines( # ✓
            const char* label, const float* values, int values_count,
            # note: optional
            int values_offset,        # = 0
            const char* overlay_text, # = NULL
            float scale_min,          # = FLT_MAX
            float scale_max,          # = FLT_MAX
            ImVec2 graph_size,        # = ImVec2(0,0)
            int stride                # = sizeof(float))
    ) except +
    void PlotLines( # ✗
            const char* label, 
            float(*values_getter)(void* data, int idx), 
            void* data, int values_count, 
            # note: optional
            int values_offset, 
            const char* overlay_text, 
            float scale_min, 
            float scale_max, 
            ImVec2 graph_size
    ) except +
    void PlotHistogram(  # ✓
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

    # ====
    # Widgets: Value() Helpers.
    void Value(const char* prefix, bool b) except +  # ✗
    void Value(const char* prefix, int v) except +  # ✗
    void Value(const char* prefix, unsigned int v) except +  # ✗
    void Value(  # ✗
            const char* prefix, float v,
            # note: optional
            const char* float_format
    ) except +
    
    # NOT FOUND
    # void ValueColor(const char* prefix, const ImVec4& v) except +  # ✗
    # void ValueColor(const char* prefix, unsigned int v) except +  # ✗

    # ====
    # Widgets: Menus
    bool BeginMenuBar() except +  # ✓
    void EndMenuBar() except +  # ✓
    bool BeginMainMenuBar() except +  # ✓
    void EndMainMenuBar() except +  # ✓
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
    ) except +
    
    # ====
    # Tooltips
    void BeginTooltip() except +  # ✓
    void EndTooltip() except +  # ✓
    void SetTooltip(const char* fmt, ...) except +  # ✓
    # void SetTooltipV(const char* fmt, va_list args) except +  # ✗
    
    # ====
    # Popups, Modals
    bool BeginPopup(const char* str_id, ImGuiWindowFlags flags) except +  # ✓
    bool BeginPopupModal(  # ✓
            const char* name,
            # note: optional
            bool* p_open, ImGuiWindowFlags extra_flags
    ) except +
    void EndPopup() except +  # ✓
    void OpenPopup( # ✓
            const char* str_id,
            # note: optional
            ImGuiPopupFlags popup_flags # NEW
    ) except + 
    bool OpenPopupOnItemClick( # ✗
            const char* str_id, 
            # note: optional
            ImGuiPopupFlags popup_flags
    ) except +
    void CloseCurrentPopup() except +  # ✓
    bool BeginPopupContextItem(  # ✓
            # note: optional
            const char* str_id,
            ImGuiPopupFlags popup_flags # API CHANGE
    ) except +
    bool BeginPopupContextWindow( # ✗
            # note: optional
            const char* str_id, 
            ImGuiPopupFlags popup_flags
    ) except +
    bool BeginPopupContextWindow(  # ✓ OBSOLETED in 1.77 (from June 2020)
            const char* str_id,
            int mouse_button,
            # note: optional
            bool also_over_items
    ) except +
    bool BeginPopupContextVoid(  # ✗
            # note: optional
            const char* str_id, 
            ImGuiPopupFlags popup_flags
    ) except +
    bool IsPopupOpen( # ✗
            const char* str_id,
            # note: optional
            ImGuiPopupFlags flags
    ) except + 

    # ====
    # Columns
    void Columns(  # ✓
            # note: optional
            int count, const char* id, bool border
    ) except +
    void NextColumn() except +  # ✓
    int GetColumnIndex() except +  # ✓
    float GetColumnWidth(  # ✓
            # note: optional
            int column_index
    ) except +
    void SetColumnWidth(int column_index, float width) except +  # ✓
    float GetColumnOffset(  # ✓
            # note: optional
            int column_index
    ) except +
    void SetColumnOffset(int column_index, float offset_x) except +  # ✓
    int GetColumnsCount() except +  # ✓
    
    # ====
    # Tab Bars, Tabs
    bool BeginTabBar( # ✗
            const char* str_id, 
            # note: optional
            ImGuiTabBarFlags flags
    ) except +
    void EndTabBar() except + # ✗                                                        // only call EndTabBar() if BeginTabBar() returns true!
    bool BeginTabItem( # ✗
            const char* label, 
            # note: optional
            bool* p_open, 
            ImGuiTabItemFlags flags
    ) except +
    void EndTabItem() except + # ✗
    bool TabItemButton(
            const char* label, 
            # note: optional
            ImGuiTabItemFlags flags
    ) except +
    void SetTabItemClosed(const char* tab_or_docked_window_label) except + # ✗
    
    # ====
    # Logging/Capture
    # Logging: all text output from interface is redirected to
    # tty/file/clipboard. By default, tree nodes are automatically opened
    #  during logging.
    void LogToTTY(  # ✗
            # note: optional
            int auto_open_depth
    ) except +
    void LogToFile(  # ✗
            # note: optional
            int auto_open_depth, const char* filename
    ) except +
    void LogToClipboard(  # ✗
            # note: optional
            int auto_open_depth
    ) except +
    void LogFinish() except +  # ✗
    void LogButtons() except +  # ✗
    void LogText(const char* fmt, ...) except +  # ✗

    # ====
    # Drag and Drop
    # - [BETA API] API may evolve!
    bool BeginDragDropSource(ImGuiDragDropFlags flags) except +  # ✓
    bool SetDragDropPayload(const char* type, const void* data, size_t size, ImGuiCond cond) except +  # ✓
    void EndDragDropSource() except +  # ✓
    bool BeginDragDropTarget() except +  # ✓
    const ImGuiPayload* AcceptDragDropPayload(const char* type, ImGuiDragDropFlags flags) except +  # ✓
    void EndDragDropTarget() except +  # ✓
    const ImGuiPayload* GetDragDropPayload() except + # ✗

    # ====
    # Clipping
    void PushClipRect(const ImVec2& clip_rect_min, const ImVec2& clip_rect_max, bool intersect_with_current_clip_rect) except +  # ✗
    void PopClipRect() except +  # ✗

    # ====
    # Focus, Activation
    void SetItemDefaultFocus() except +  # ✓
    void SetKeyboardFocusHere(int offset) except +  # ✓

    # ====
    # Item/Widgets Utilities
    bool IsItemHovered(ImGuiHoveredFlags flags) except +  # ✓
    bool IsItemActive() except +  # ✓
    bool IsItemFocused() except +  # ✓
    bool IsItemClicked(  # ✓
            # note: optional
            ImGuiMouseButton mouse_button # API CHANGE
    ) except +
    bool IsItemVisible() except +  # ✓
    bool IsItemEdited() except + # ✗
    bool IsItemActivated() except + # ✗
    bool IsItemDeactivated() except + # ✗
    bool IsItemDeactivatedAfterEdit() except + # ✗
    bool IsItemToggledOpen() except + # ✗
    bool IsAnyItemHovered() except +  # ✓
    bool IsAnyItemActive() except +  # ✓
    bool IsAnyItemFocused() except +  # ✓
    ImVec2 GetItemRectMin() except +  # ✓
    ImVec2 GetItemRectMax() except +  # ✓
    ImVec2 GetItemRectSize() except +  # ✓
    void SetItemAllowOverlap() except +  # ✓
    
    # ====
    # Miscellaneous Utilities
    bool IsRectVisible(const ImVec2& size) except +  # ✓
    bool IsRectVisible(const ImVec2& rect_min, const ImVec2& rect_max) except +  # ✗
    double GetTime() except +  # ✓
    int GetFrameCount() except +  # ✗
    ImDrawList* GetBackgroundDrawList() except +  # ✗
    ImDrawList* GetForegroundDrawList() except +  # ✗
    ImDrawList* GetOverlayDrawList() except +  # ✗ # OBSOLETED in 1.69 (from Mar 2019)
    ImDrawListSharedData* GetDrawListSharedData() except +  # ✗
    const char* GetStyleColorName(ImGuiCol idx) except +  # ✓
    void SetStateStorage(ImGuiStorage* storage) except +  # ✗
    ImGuiStorage* GetStateStorage() except +  # ✗
    void CalcListClipping(int items_count, float items_height, int* out_items_display_start, int* out_items_display_end) except +  # ✗
    bool BeginChildFrame(  # ✗
            ImGuiID id, const ImVec2& size,
            # note: optional
            ImGuiWindowFlags flags
    ) except +
    void EndChildFrame() except +  # ✗

    # Text Utilities
    ImVec2 CalcTextSize(  # ✓
            const char* text,
            # note: optional
            const char* text_end,
            bool hide_text_after_double_hash,
            float wrap_width
    ) except +

    # ====
    # Color Utilities
    ImVec4 ColorConvertU32ToFloat4(ImU32 in_) except +  # ✗
    ImU32 ColorConvertFloat4ToU32(const ImVec4& in_) except +  # ✗
    void ColorConvertRGBtoHSV(float r, float g, float b, float& out_h, float& out_s, float& out_v) except +  # ✗
    void ColorConvertHSVtoRGB(float h, float s, float v, float& out_r, float& out_g, float& out_b) except +  # ✗

    # ====
    # Inputs Utilities: Keyboard
    int GetKeyIndex(ImGuiKey key) except +  # ✓
    bool IsKeyDown(int key_index) except +  # ✓
    bool IsKeyPressed(  # ✓
            int key_index,
            # note: optional
            bool repeat
    ) except +
    bool IsKeyReleased(int key_index) except +  # ✓
    int GetKeyPressedAmount(int key_index, float repeat_delay, float rate) except +  # ✗
    void CaptureKeyboardFromApp(  # ✗
            # note: optional
            bool want_capture_keyboard_value
    ) except +
    
    # ====
    # Inputs Utilities: Mouse
    bool IsMouseDown(int button) except +  # ✓
    bool IsMouseClicked(  # ✓
            int button,
            # note: optional
            bool repeat
    ) except +
    bool IsMouseDoubleClicked(int button) except +  # ✓
    bool IsMouseReleased(int button) except +  # ✓
    bool IsMouseHoveringRect(  # ✓
            const ImVec2& r_min, const ImVec2& r_max,
            # note: optional
            bool clip
    ) except +
    bool IsMousePosValid(const ImVec2* mouse_pos) except +  # ✗
    bool IsAnyMouseDown() except +  # ✗
    ImVec2 GetMousePos() except +  # ✓
    ImVec2 GetMousePosOnOpeningCurrentPopup() except +  # ✗
    bool IsMouseDragging(  # ✓
            # note: optional
            int button, float lock_threshold
    ) except +
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
    void CaptureMouseFromApp(  # ✗
            # note: optional
            bool want_capture_mouse_value
    ) except +
    
    # ====
    # Clipboard Utilities
    const char* GetClipboardText() except +  # ✗
    void SetClipboardText(const char* text) except +  # ✗

    # ====
    # Settings/.Ini Utilities
    void LoadIniSettingsFromDisk(  # ✗
            const char* ini_filename
    ) except +
    void LoadIniSettingsFromMemory(  # ✗
            const char* ini_data,
            # note: optional
            size_t ini_size
    ) except +
    void SaveIniSettingsToDisk(  # ✗
            const char* ini_filename
    ) except +
    const char* SaveIniSettingsToMemory(  # ✗
            # note: optional
            size_t* out_ini_size
    ) except +
    
    # ====
    # Debug Utilities
    bool DebugCheckVersionAndDataLayout(const char* version_str, size_t sz_io, size_t sz_style, size_t sz_vec2, size_t sz_vec4, size_t sz_drawvert) except +  # ✓
    
    # ====
    # Memory Allocators
    void SetAllocatorFunctions( # ✗
            void* (*alloc_func)(size_t sz, void* user_data), 
            void (*free_func)(void* ptr, void* user_data), 
            # note: optional
            void* user_data
    ) except +
    void* MemAlloc(size_t size) except + # ✗
    void MemFree(void* ptr) except + # ✗

    