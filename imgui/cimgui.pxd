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
    #ctypedef struct ImDrawList # declared later
    ctypedef struct ImDrawListSharedData
    #ctypedef struct ImDrawListSplitter # declared later
    ctypedef struct ImDrawVert
    ctypedef struct ImFont
    ctypedef struct ImFontAtlas
    #ctypedef struct ImFontConfig # declared later
    ctypedef struct ImFontGlyph
    ctypedef struct ImFontGlyphRangesBuilder
    #ctypedef struct ImColor  # declared later
    ctypedef struct ImGuiContext
    ctypedef struct ImGuiIO
    ctypedef struct ImGuiInputTextCallbackData
    ctypedef struct ImGuiListClipper
    ctypedef struct ImGuiOnceUponAFrame
    ctypedef struct ImGuiPayload
    ctypedef struct ImGuiPlatformIO
    ctypedef struct ImGuiPlatformMonitor
    ctypedef struct ImGuiSizeCallbackData
    ctypedef struct ImGuiWindowClass
    ctypedef struct ImGuiStorage
    # ctypedef struct ImGuiStyle  # declared later
    ctypedef struct ImGuiTableSortSpecs
    ctypedef struct ImGuiTableColumnSortSpecs
    ctypedef struct ImGuiTextBuffer
    ctypedef struct ImGuiTextFilter
    # ctypedef struct ImGuiViewport # declared later
    ctypedef struct ImGuiWindowClass

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
    ctypedef int ImGuiSortDirection
    ctypedef int ImGuiStyleVar
    ctypedef int ImGuiTableBgTarget
    ctypedef int ImDrawCornerFlags # OBSOLETED in 1.82 (from Mars 2021)
    ctypedef int ImDrawFlags
    ctypedef int ImDrawListFlags
    ctypedef int ImFontAtlasFlags
    ctypedef int ImGuiViewportFlags
    ctypedef int ImGuiBackendFlags
    ctypedef int ImGuiButtonFlags
    ctypedef int ImGuiColorEditFlags
    ctypedef int ImGuiConfigFlags
    ctypedef int ImGuiComboFlags
    ctypedef int ImGuiDockNodeFlags
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
    ctypedef int ImGuiTableFlags
    ctypedef int ImGuiTableColumnFlags
    ctypedef int ImGuiTableRowFlags
    ctypedef int ImGuiTreeNodeFlags
    ctypedef int ImGuiWindowFlags
    # ctypedef int ImGuiColumnsFlags # DEPRECIATED

    # ====
    # Various int typedefs and enumerations
    ctypedef void* ImTextureID
    ctypedef unsigned int ImGuiID
    ctypedef int (*ImGuiInputTextCallback)(ImGuiInputTextCallbackData *data);
    ctypedef void (*ImGuiSizeCallback)(ImGuiSizeCallbackData* data);
    ctypedef void* (*ImGuiMemAllocFunc)(size_t sz, void* user_data);
    ctypedef void (*ImGuiMemFreeFunc)(void* ptr, void* user_data);
    
    # ==== # TODO: Find a way to check IMGUI_USE_WCHAR32 define
    # Decoded character types
    ctypedef unsigned short ImWchar16
    ctypedef unsigned int ImWchar32
    
    # note: Default is ImWchar16, 
    #       if IMGUI_USE_WCHAR32 is set in imconfig.h 
    #           - ImWchar should be a ImWchar32
    #           - IM_UNICODE_CODEPOINT_MAX should be 0x10FFFF    
    ctypedef ImWchar32 ImWchar 
    cdef enum: # No const in cython
        IM_UNICODE_CODEPOINT_MAX = 0x10FFFF
    
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
        ImGuiConfigFlags   ConfigFlags # ✓
        ImGuiBackendFlags  BackendFlags # ✓
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

        # Docking options (when ImGuiConfigFlags_DockingEnable is set)
        bool        ConfigDockingNoSplit              # ✗      # = false          # Simplified docking mode: disable window splitting, so docking is limited to merging multiple windows together into tab-bars.
        bool        ConfigDockingWithShift            # ✗      # = false          # Enable docking with holding Shift key (reduce visual noise, allows dropping in wider space)
        bool        ConfigDockingAlwaysTabBar         # ✗      # = false          # [BETA] [FIXME: This currently creates regression with auto-sizing and general overhead] Make every single floating window display within a docking node.
        bool        ConfigDockingTransparentPayload   # ✗      # = false          # [BETA] Make window or viewport transparent when docking and only display docking boxes on the target viewport. Useful if rendering of multiple viewport cannot be synced. Best used with ConfigViewportsNoAutoMerge.

        # Viewport options (when ImGuiConfigFlags_ViewportsEnable is set)
        bool        ConfigViewportsNoAutoMerge       # ✗       # = false;         # Set to make all floating imgui windows always create their own viewport. Otherwise, they are merged into the main host viewports when overlapping it. May also set ImGuiViewportFlags_NoAutoMerge on individual viewport.
        bool        ConfigViewportsNoTaskBarIcon     # ✗       # = false          # Disable default OS task bar icon flag for secondary viewports. When a viewport doesn't want a task bar icon, ImGuiViewportFlags_NoTaskBarIcon will be set on it.
        bool        ConfigViewportsNoDecoration      # ✗       # = true           # Disable default OS window decoration flag for secondary viewports. When a viewport doesn't want window decorations, ImGuiViewportFlags_NoDecoration will be set on it. Enabling decoration can create subsequent issues at OS levels (e.g. minimum window size).
        bool        ConfigViewportsNoDefaultParent   # ✗       # = false          # Disable default OS parenting to main viewport for secondary viewports. By default, viewports are marked with ParentViewportId = <main_viewport>, expecting the platform backend to setup a parent/child relationship between the OS windows (some backend may ignore this). Set to true if you want the default to be 0, then all viewports will be top-level OS windows.

        
        # Miscellaneous options
        bool          MouseDrawCursor  # ✓
        bool          ConfigMacOSXBehaviors  # ✓
        bool          ConfigInputTextCursorBlink  # ✓
        bool          ConfigDragClickToInputText # ✓
        #bool          ConfigResizeWindowsFromEdges  # ✓ # RENAMED
        bool          ConfigWindowsResizeFromEdges # ✓
        bool          ConfigWindowsMoveFromTitleBarOnly # ✓
        float         ConfigMemoryCompactTimer # ✓ # RENAMED
        
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
        
        # NOTE: This is not in 'docking' branch...
        # Optional: Notify OS Input Method Editor of the screen position of your cursor for text input position
        # void        (*ImeSetInputScreenPosFn)(int x, int y) except +  # ✗  # TODO: Callback
        # void*       ImeWindowHandle  # ✗

        # ====
        # Input - Fill before calling NewFrame()
        ImVec2      MousePos  # ✓
        bool        MouseDown[5]  # ✓
        float       MouseWheel  # ✓
        float       MouseWheelH  # ✓
        ImGuiID     MouseHoveredViewport # ✗
        bool        KeyCtrl  # ✓
        bool        KeyShift  # ✓
        bool        KeyAlt  # ✓
        bool        KeySuper  # ✓
        bool        KeysDown[512]  # ✓
        # note: originally NavInputs[ImGuiNavInput_COUNT]
        # todo: find a way to access enum var here
        float*    NavInputs  # ✓

        # Functions
        void        AddInputCharacter(unsigned int c) except +  # ✓
        void        AddInputCharacterUTF16(ImWchar16 c) except + # ✓
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
        int         MetricsRenderWindows # ✓
        int         MetricsActiveWindows  # ✓
        int         MetricsActiveAllocations # ✓
        ImVec2      MouseDelta  # ✓
    
    ctypedef struct ImGuiInputTextCallbackData: # ✓
        ImGuiInputTextFlags EventFlag       # Read-only # ✓
        ImGuiInputTextFlags Flags           # Read-only # ✓
        void*               UserData        # Read-only # ✓
        ImWchar             EventChar       # Read-write # ✓
        ImGuiKey            EventKey        # Read-only # ✓
        char*               Buf             # Read-write # ✓
        int                 BufTextLen      # Read-write # ✓
        int                 BufSize         # Read-only # ✓
        bool                BufDirty        # Write # ✓
        int                 CursorPos       # Read-write # ✓
        int                 SelectionStart  # Read-write # ✓
        int                 SelectionEnd    # Read-write # ✓

        ImGuiInputTextCallbackData() except +
        void DeleteChars(int pos, int bytes_count) except + # ✓
        void InsertChars(int pos, const char* text, const char* text_end = NULL) except + # ✓
        void SelectAll() except + # ✓
        void ClearSelection() except + # ✓
        bool HasSelection() except + # ✓
    
    ctypedef struct ImGuiSizeCallbackData: # ✓
        void*   UserData        # Read-only # ✓
        ImVec2  Pos             # Read-only # ✓
        ImVec2  CurrentSize     # Read-only # ✓
        ImVec2  DesiredSize     # Read-write # ✓
    
    cdef cppclass ImVector[T]:
        int        Size
        int        Capacity
        T*         Data
        
    ctypedef struct ImGuiListClipper: # ✗
        int     DisplayStart # ✗
        int     DisplayEnd # ✗
        
        void Begin( # ✗
            int items_count, 
            # note: optional
            float items_height      #= -1.0f
        ) except +
        void End() except + # ✗
        bool Step() except + # ✗
        
    cdef cppclass ImColor: # ✗
        ImVec4              Value # ✗
        
        ImColor(int r, int g, int b, int a = 255) except + # ✗
        ImColor() except + # ✗
        ImColor(ImU32 rgba) except + # ✗
        ImColor(float r, float g, float b, float a = 1.0) except + # ✗
        ImColor(const ImVec4& col) except + # ✗
        
        #operator ImU32() except + # ✗
        #operator ImVec4() except + # ✗

    ctypedef void (*ImDrawCallback)(const ImDrawList* parent_list, const ImDrawCmd* cmd)  # ✗ # TODO: Callback

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


    ctypedef struct ImDrawVert: # ✗
        ImVec2 pos  # ✗
        ImVec2 uv  # ✗
        ImU32  col  # ✗
        
    ctypedef struct ImDrawChannel: # ✗
        ImVector[ImDrawCmd]         _CmdBuffer # ✗
        ImVector[ImDrawIdx]         _IdxBuffer # ✗
        
    cdef cppclass ImDrawListSplitter: # ✗
        int                         _Current # ✗
        int                         _Count # ✗
        ImVector[ImDrawChannel]     _Channels # ✗
        
        ImDrawListSplitter() # ✗
        # ~ImDrawListSplitter() # ✗
        
        void Clear() except + # ✗
        void ClearFreeMemory() except + # ✗
        void Split(ImDrawList* draw_list, int count) except + # ✗
        void Merge(ImDrawList* draw_list) except + # ✗
        void SetCurrentChannel(ImDrawList* draw_list, int channel_idx) except + # ✗
    
    cdef cppclass ImDrawList:
        # we map only buffer vectors since everything else is internal
        # and right now we dont want to suport it.
        ImVector[ImDrawCmd]  CmdBuffer  # ✓
        ImVector[ImDrawIdx]  IdxBuffer  # ✓
        ImVector[ImDrawVert] VtxBuffer  # ✓
        ImDrawListFlags      Flags # ✓
        
        ImDrawList(const ImDrawListSharedData* shared_data) # ✗
        
        void PushClipRect( # ✓
            ImVec2 clip_rect_min, 
            ImVec2 clip_rect_max, 
            # note: optional
            bool intersect_with_current_clip_rect # = false
        ) except + 
        void PushClipRectFullScreen() except + # ✓
        void PopClipRect() except + # ✓
        void PushTextureID(ImTextureID texture_id) except + # ✓
        void PopTextureID() except + # ✓
        ImVec2 GetClipRectMin() except + # ✓
        ImVec2 GetClipRectMax() except + # ✓

        void AddLine( # ✓
            const ImVec2& a,
            const ImVec2& b,
            ImU32 col,
            # note: optional
            float thickness            # = 1.0f
        ) except + 


        void AddRect( # ✓
            const ImVec2& a,
            const ImVec2& b,
            ImU32 col,
            # note: optional
            float rounding,             # = 0.0f,
            ImDrawFlags flags,          # = 0,
            float thickness             # = 1.0f
        ) except + 


        void AddRectFilled( # ✓
            const ImVec2& a,
            const ImVec2& b,
            ImU32 col,
            # note: optional
            float rounding,             # = 0.0f
            ImDrawFlags flags           # = 0
        ) except + 
        
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
    
        void  AddCircle( # ✓
           const ImVec2& centre,
           float radius,
           ImU32 col,
           # note:optional
           int num_segments,           # = 0        
           float thickness             # = 1.0f
        ) except + 


        void AddCircleFilled( # ✓
           const ImVec2& centre,
           float radius,
           ImU32 col,
           # note:optional
           int num_segments            # = 0      
        ) except + 
        
        void AddNgon( # ✓
            const ImVec2& center, 
            float radius, 
            ImU32 col, 
            int num_segments, 
            # note:optional
            float thickness            # = 1.0f
        ) except +
        
        void AddNgonFilled( # ✓
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
        
        void AddText( # ✗
            const ImFont* font, 
            float font_size, 
            const ImVec2& pos, 
            ImU32 col, 
            const char* text_begin, 
            # note:optional
            const char* text_end,       # = NULL
            float wrap_width,           # = 0.0f
            const ImVec4* cpu_fine_clip_rect # = NULL
        ) except +

        void AddPolyline( # ✓
            const ImVec2* points,
            int num_points,
            ImU32 col,
            ImDrawFlags flags,
            float thickness
        ) except + 
        
        void AddConvexPolyFilled( # ✗
            const ImVec2* points, 
            int num_points, 
            ImU32 col
        ) except +
        
        void AddBezierCubic( # ✗
            const ImVec2& p1, 
            const ImVec2& p2, 
            const ImVec2& p3, 
            const ImVec2& p4, 
            ImU32 col, 
            float thickness, 
            # note: optional
            int num_segments        # = 0
        ) except +
        
        void  AddBezierQuadratic( # ✗
            const ImVec2& p1, 
            const ImVec2& p2, 
            const ImVec2& p3, 
            ImU32 col, 
            float thickness, 
            # note: optional
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
            ImDrawFlags flags # = 0
        ) except +

        # Stateful path API, add points then finish with PathFillConvex() or PathStroke()
        void PathClear() except + # ✗
        void PathLineTo(const ImVec2& pos) except + # ✗
        void PathLineToMergeDuplicate(const ImVec2& pos) except + # ✗
        void PathFillConvex(ImU32 col) except + # ✗
        void PathStroke( # ✗
            ImU32 col, 
            # note: optional
            ImDrawFlags flags,      # = 0
            float thickness         # = 1.0f
        ) except +
        void PathArcTo( # ✗
            const ImVec2& center, 
            float radius, 
            float a_min, 
            float a_max, 
            # note: optional
            int num_segments        # = 0
        ) except +
        void PathArcToFast( # ✗
            const ImVec2& center, 
            float radius, 
            int a_min_of_12, 
            int a_max_of_12
        ) except +
        void PathBezierCubicCurveTo( # ✗
            const ImVec2& p2, 
            const ImVec2& p3, 
            const ImVec2& p4, 
            # note: optional
            int num_segments        # = 0
        ) except +
        void  PathBezierQuadraticCurveTo( # ✗
            const ImVec2& p2, 
            const ImVec2& p3, 
            # note: optional
            int num_segments        # = 0
        ) except +    
        void PathRect( # ✗ 
            const ImVec2& rect_min, 
            const ImVec2& rect_max, 
            # note: optional
            float rounding,         # = 0.0f
            ImDrawFlags flags       # = 0
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
        void PrimReserve(int idx_count, int vtx_count) except + # ✓
        void PrimUnreserve(int idx_count, int vtx_count) except + # ✓
        void PrimRect(const ImVec2& a, const ImVec2& b, ImU32 col) except + # ✓
        void PrimRectUV(const ImVec2& a, const ImVec2& b, const ImVec2& uv_a, const ImVec2& uv_b, ImU32 col) except + # ✓
        void PrimQuadUV(const ImVec2& a, const ImVec2& b, const ImVec2& c, const ImVec2& d, const ImVec2& uv_a, const ImVec2& uv_b, const ImVec2& uv_c, const ImVec2& uv_d, ImU32 col) except + # ✓
        inline void  PrimWriteVtx(const ImVec2& pos, const ImVec2& uv, ImU32 col) except + # ✓
        inline void  PrimWriteIdx(ImDrawIdx idx) except + # ✓
        inline void  PrimVtx(const ImVec2& pos, const ImVec2& uv, ImU32 col) except + # ✓


    ctypedef struct ImDrawData:  # ✓
        bool            Valid  # ✓
        ImDrawList**    CmdLists  # ✓
        int             CmdListsCount  # ✓
        int             TotalIdxCount  # ✓
        int             TotalVtxCount  # ✓
        ImVec2          DisplayPos # ✓
        ImVec2          DisplaySize # ✓
        ImVec2          FramebufferScale # ✓
        ImGuiViewport*  OwnerViewport # ✗
        
        void            DeIndexAllBuffers() except +  # ✓
        void            ScaleClipRects(const ImVec2&) except +  # ✓

    cdef cppclass ImFontConfig:
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
        
        ImFontConfig()  # ✗
        
    ctypedef struct ImFontGlyph: # ✗
        unsigned int    Codepoint # bitfield : 31 # ✗
        unsigned int    Visible # bitfield   : 1 # ✗
        float           AdvanceX # ✗
        float           X0 # ✗
        float           Y0 # ✗
        float           X1 # ✗
        float           Y1 # ✗
        float           U0 # ✗
        float           V0 # ✗
        float           U1 # ✗
        float           V1 # ✗
    
    ctypedef struct ImFontGlyphRangesBuilder: # ✗
        ImVector[ImU32] UsedChars 
        
        # ImFontGlyphRangesBuilder() # ✗
        void Clear() except + # ✗
        bool GetBit(size_t n) except + # ✗
        void SetBit(size_t n) except + # ✗
        void AddChar(ImWchar c) except + # ✗
        void AddText( # ✗
                const char* text, 
                # note: optional
                const char* text_end        # = NULL
        ) except +
        void AddRanges(const ImWchar* ranges) except + # ✗
        void BuildRanges(ImVector[ImWchar]* out_ranges) except + # ✗
        
    ctypedef struct ImFontAtlasCustomRect: # ✗        
        unsigned short  Width, Height;  # ✗
        unsigned short  X, Y;           # ✗
        unsigned int    GlyphID;        # ✗
        float           GlyphAdvanceX;  # ✗
        ImVec2          GlyphOffset;    # ✗
        ImFont*         Font;           # ✗
        ImFontAtlasCustomRect() except + # ✗
        bool IsPacked() except + # ✗
        
 
    ctypedef struct ImFont: # ✗
        
        # Members: Hot ~20/24 bytes (for CalcTextSize)
        ImVector[float]             IndexAdvanceX # ✗
        float                       FallbackAdvanceX# ✗
        float                       FontSize # ✗
        
        # Members: Hot ~28/40 bytes (for CalcTextSize + render loop)
        ImVector[ImWchar]           IndexLookup # ✗
        ImVector[ImFontGlyph]       Glyphs # ✗
        const ImFontGlyph*          FallbackGlyph # ✗
        
        # Members: Cold ~32/40 bytes
        ImFontAtlas*                ContainerAtlas # ✗
        const ImFontConfig*         ConfigData # ✗
        short                       ConfigDataCount # ✗
        ImWchar                     FallbackChar # ✗
        ImWchar                     EllipsisChar # ✗
        bool                        DirtyLookupTables # ✗
        float                       Scale # ✗
        float                       Ascent # ✗
        float                       Descent # ✗
        int                         MetricsTotalSurface # ✗
        ImU8                        Used4kPagesMap[(IM_UNICODE_CODEPOINT_MAX+1)/4096/8] # ✗
        
        # Methods
        const ImFontGlyph*FindGlyph(ImWchar c) except + # ✗
        const ImFontGlyph*FindGlyphNoFallback(ImWchar c) except + # ✗
        float GetCharAdvance(ImWchar c) except + # ✗
        bool IsLoaded() except + # ✗
        const char* GetDebugName() except + # ✗
        
        ImVec2 CalcTextSizeA( # ✗
                float size, 
                float max_width, 
                float wrap_width, 
                const char* text_begin, 
                # note: optional
                const char* text_end,           # = NULL, 
                const char** remaining          # = NULL
        ) except +
        const char* CalcWordWrapPositionA( # ✗
                float scale, 
                const char* text, 
                const char* text_end, 
                float wrap_width
        ) except +
        void RenderChar( # ✗ 
                ImDrawList* draw_list, 
                float size, 
                ImVec2 pos, 
                ImU32 col, 
                ImWchar c
        ) except +
        void RenderText( # ✗
                ImDrawList* draw_list, 
                float size, 
                ImVec2 pos, 
                ImU32 col, 
                const ImVec4& clip_rect, 
                const char* text_begin, 
                const char* text_end, 
                # note: optional
                float wrap_width,               # = 0.0f, 
                bool cpu_fine_clip              # = false
        ) except +

    ctypedef struct ImFontAtlas:  # ✓ 
        ImFontAtlasFlags    Flags # ✗
        void*               TexID  # ✓
        int                 TexDesiredWidth # ✗
        int                 TexGlyphPadding # ✗
        bool                Locked # ✗
        
        # Internals
        int                 TexWidth  # ✓
        int                 TexHeight  # ✓

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
        const ImWchar* GetGlyphRangesThai() except + # ✓
        const ImWchar* GetGlyphRangesVietnamese() except + # ✓
        
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

    ctypedef struct ImGuiStorage: # ✗
        pass

    cdef cppclass ImGuiStyle:
        float       Alpha  # ✓
        ImVec2      WindowPadding  # ✓
        float       WindowRounding  # ✓
        float       WindowBorderSize  # ✓
        ImVec2      WindowMinSize  # ✓
        ImVec2      WindowTitleAlign  # ✓
        ImGuiDir    WindowMenuButtonPosition # ✓
        float       ChildRounding  # ✓
        float       ChildBorderSize  # ✓
        float       PopupRounding  # ✓
        float       PopupBorderSize  # ✓
        ImVec2      FramePadding  # ✓
        float       FrameRounding  # ✓
        float       FrameBorderSize  # ✓
        ImVec2      ItemSpacing  # ✓
        ImVec2      ItemInnerSpacing  # ✓
        ImVec2      CellPadding # ✓
        ImVec2      TouchExtraPadding  # ✓
        float       IndentSpacing  # ✓
        float       ColumnsMinSpacing  # ✓
        float       ScrollbarSize  # ✓
        float       ScrollbarRounding  # ✓
        float       GrabMinSize  # ✓
        float       GrabRounding  # ✓
        float       LogSliderDeadzone # ✓
        float       TabRounding # ✓
        float       TabBorderSize # ✓
        float       TabMinWidthForCloseButton # ✓
        ImGuiDir    ColorButtonPosition # ✓
        ImVec2      ButtonTextAlign  # ✓
        ImVec2      SelectableTextAlign # ✓
        ImVec2      DisplayWindowPadding  # ✓
        ImVec2      DisplaySafeAreaPadding  # ✓
        float       MouseCursorScale   # ✓
        bool        AntiAliasedLines  # ✓
        bool        AntiAliasedLinesUseTex # ✓
        bool        AntiAliasedFill  # ✓
        float       CurveTessellationTol  # ✓
        float       CircleTessellationMaxError # ✓

        # note: originally Colors[ImGuiCol_COUNT]
        # todo: find a way to access enum var here
        ImVec4*     Colors
        
        void ScaleAllSizes(float scale_factor) except + # ✗

    ctypedef struct ImGuiWindowClass: # ✗
        ImGuiID             ClassId # ✗
        ImGuiID             ParentViewportId # ✗
        ImGuiViewportFlags  ViewportFlagsOverrideSet # ✗
        ImGuiViewportFlags  ViewportFlagsOverrideClear # ✗
        ImGuiTabItemFlags   TabItemFlagsOverrideSet # ✗
        ImGuiDockNodeFlags  DockNodeFlagsOverrideSet # ✗
        ImGuiDockNodeFlags  DockNodeFlagsOverrideClear # ✗
        bool                DockingAlwaysTabBar # ✗
        bool                DockingAllowUnclassed # ✗
        ImGuiWindowClass() except + # ✗


    ctypedef struct ImGuiPayload: # ✗
        void* Data  # ✓
        int   DataSize  # ✓
        
        bool IsDataType(const char* type) except + # ✗
        bool IsPreview() except + # ✗
        bool IsDelivery() except + # ✗
    
    ctypedef struct ImGuiTableColumnSortSpecs: # ✓
        ImGuiID ColumnUserID # ✓
        ImS16 ColumnIndex # ✓
        ImS16 SortOrder # ✓
        ImGuiSortDirection SortDirection # ✓
        
        ImGuiTableColumnSortSpecs() except +  # ✗
    
    ctypedef struct ImGuiTableSortSpecs: # ✓
        const ImGuiTableColumnSortSpecs* Specs # ✓
        int SpecsCount # ✓
        bool SpecsDirty # ✓
        
        ImGuiTableSortSpecs() except + # ✗
    
    ctypedef struct ImGuiContext:
        pass
        
    ctypedef struct ImGuiViewport:  # ✓
        ImGuiID             ID # ✗
        ImGuiViewportFlags  Flags  # ✓
        ImVec2              Pos  # ✓
        ImVec2              Size  # ✓
        ImVec2              WorkPos # ✓
        ImVec2              WorkSize # ✓
        float               DpiScale # ✗
        ImGuiID             ParentViewportId # ✗
        ImDrawData*         DrawData # ✗
        
        void*               RendererUserData # ✗
        void*               PlatformUserData # ✗
        void*               PlatformHandle # ✗
        void*               PlatformHandleRaw # ✗
        bool                PlatformRequestMove # ✗
        bool                PlatformRequestResize # ✗
        bool                PlatformRequestClose # ✗
        
        ImVec2 GetCenter() except + # ✓
        ImVec2 GetWorkCenter() except + # ✓

    ctypedef struct ImGuiPlatformIO: # ✗
        pass
    ctypedef struct ImGuiPlatformMonitor: # ✗
        pass

cdef extern from "imgui.h" namespace "ImGui":

    # ====
    # Context creation and access
    ImGuiContext* CreateContext(  # ✓
            # note: optional
            ImFontAtlas* shared_font_atlas          # = NULL
    ) except +
    void DestroyContext(# ✓
            # note: optional
            ImGuiContext* ctx                       # = NULL
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
    void ShowAboutWindow(bool* p_open) except + # ✓
    void ShowAboutWindow() except + # ✓
    void ShowStyleEditor(ImGuiStyle* ref) except +  # ✓
    void ShowStyleEditor() except +  # ✓
    bool ShowStyleSelector(const char* label) except +  # ✓
    void ShowFontSelector(const char*) except +  # ✓
    void ShowUserGuide() except +  # ✓
    const char* GetVersion() except +  # ✓

    # ====
    # Styles
    void StyleColorsDark(ImGuiStyle* dst) except +  # ✓
    void StyleColorsLight(ImGuiStyle* dst) except +  # ✓
    void StyleColorsClassic(ImGuiStyle* dst) except +  # ✓

    # ====
    # Window
    bool Begin( # ✓
            const char* name, 
            # note: optional
            bool* p_open,               # = NULL    
            ImGuiWindowFlags            # = 0
    ) except + 
    # bool Begin(const char*, bool*, const ImVec2&, float, ImGuiWindowFlags) # DEPRECIATED
    void End() except +  # ✓
    
    # ====
    # Child Windows
    bool BeginChild( # ✓
            const char* str_id,
            # note: optional
            const ImVec2& size,         # = ImVec2(0,0)
            bool border,                # = False    
            ImGuiWindowFlags flags      # = 0
    ) except +
    # bool BeginChild(const char*, const ImVec2&, bool) except +  # ✓  # NOT NECESSARY ?
    # bool BeginChild(const char*, const ImVec2&) except +  # ✓  # NOT NECESSARY ?
    # bool BeginChild(const char*) except +  # ✓ # NOT NECESSARY ?
    bool BeginChild( # ✓
            ImGuiID id, 
            # note: optional
            const ImVec2& size,         # = ImVec2(0,0)
            bool border,                # = False
            ImGuiWindowFlags flags      # = 0
    ) except +
    # bool BeginChild(ImGuiID, const ImVec2&, bool) except +  # ✓ # NOT NECESSARY ?
    # bool BeginChild(ImGuiID, const ImVec2&) except +  # ✓ # NOT NECESSARY ?
    # bool BeginChild(ImGuiID) except +  # ✓ # NOT NECESSARY ?
    void EndChild() except +  # ✓

    # ====
    # Windows Utilities
    bool IsWindowAppearing() except +  # ✓
    bool IsWindowCollapsed() except +  # ✓
    bool IsWindowFocused( # ✓
            # note: optional
            ImGuiFocusedFlags flags     # = 0
    ) except +
    bool IsWindowHovered( # ✓
            # note: optional
            ImGuiFocusedFlags flags     # = 0
    ) except +
    ImDrawList* GetWindowDrawList() except +  # ✓
    float GetWindowDpiScale() except + # ✗
    ImVec2 GetWindowPos() except +  # ✓
    ImVec2 GetWindowSize() except +  # ✓
    float GetWindowWidth() except +  # ✓
    float GetWindowHeight() except +  # ✓
    ImGuiViewport* GetWindowViewport() except + # ✗
    
    void SetNextWindowPos(  # ✓ note: overrides ommited
            const ImVec2& pos,
            # note: optional
            ImGuiCond cond,             # = 0
            const ImVec2& pivot         # = ImVec2(0, 0)
    ) except +
    void SetNextWindowSize(  # ✓ note: overrides ommited
            const ImVec2& size,
            # note: optional
            ImGuiCond cond              # = 0    
    ) except +
    void SetNextWindowSizeConstraints(  # ✓
            const ImVec2& size_min,
            const ImVec2& size_max,
            # note: optional
            ImGuiSizeCallback custom_callback,  # = NULL
            void* custom_callback_data  # = NULL
    ) except +
    void SetNextWindowContentSize(const ImVec2& size) except +  # ✓
    void SetNextWindowCollapsed(  # ✓
            bool collapsed,
            # note: optional
            ImGuiCond cond              # = 0
    ) except +
    void SetNextWindowFocus() except +  # ✓
    void SetNextWindowBgAlpha(float alpha) except +  # ✓
    void SetNextWindowViewport(ImGuiID viewport_id) except + # ✗
    void SetWindowPos(  # ✓
            const ImVec2& pos,
            # note: optional
            ImGuiCond cond              # = 0
    ) except +
    void SetWindowSize(  # ✓
            const ImVec2& size,
            # note: optional
            ImGuiCond cond              # = 0
    ) except +
    void SetWindowCollapsed(  # ✓
            bool collapsed,
            # note: optional
            ImGuiCond cond              # = 0
    ) except +
    void SetWindowFocus() except +  # ✓
    void SetWindowFontScale(float scale) except +  # ✓
    void SetWindowPos(  # ✓
            const char* name, const ImVec2& pos,
            # note: optional
            ImGuiCond cond              # = 0
    ) except +
    void SetWindowSize(  # ✓
            const char* name, const ImVec2& size, ImGuiCond
            cond                        # = 0
    ) except +
    void SetWindowCollapsed(  # ✓
            const char* name, bool collapsed,
            # note: optional
            ImGuiCond cond              # = 0
    ) except +
    void SetWindowFocus(const char* name) except +  # ✓
    
    # ====
    # Content region
    ImVec2 GetContentRegionAvail() except +  # ✓
    ImVec2 GetContentRegionMax() except +  # ✓
    ImVec2 GetWindowContentRegionMin() except +  # ✓
    ImVec2 GetWindowContentRegionMax() except +  # ✓
    float GetWindowContentRegionWidth() except +  # ✓

    # ====
    # Windows Scrolling
    float GetScrollX() except +  # ✓
    float GetScrollY() except +  # ✓
    void SetScrollX(float scroll_x) except +  # ✓
    void SetScrollY(float scroll_y) except +  # ✓
    float GetScrollMaxX() except +  # ✓
    float GetScrollMaxY() except +  # ✓
    # void SetScrollHere(  # ✓ # OBSOLETED in 1.66 (from Sep 2018) # REMOVED in 1.82 (from Mars 2021)
    #        # note: optional
    #        float center_y_ratio        # = 0.5    
    #) except +
    void SetScrollHereX( # ✓
            # note: optional
            float center_x_ratio        # = 0.5
    ) except +
    void SetScrollHereY( # ✓
            # note: optional
            float center_y_ratio        # = 0.5
    ) except + 
    void SetScrollFromPosX( # ✓
            float local_x, 
            # note: optional
            float center_x_ratio        # = 0.5
    ) except +
    void SetScrollFromPosY(  # ✓
            float local_y,
            # note: optional
            float center_y_ratio        # = 0.5
    ) except +

    # ====
    # Parameters stacks (shared)
    void PushFont(ImFont*) except +  # ✓
    void PopFont() except +  # ✓
    void PushStyleColor(ImGuiCol idx, ImU32 col) except +  # ✗
    void PushStyleColor(ImGuiCol idx, const ImVec4&) except +  # ✓
    void PopStyleColor( # ✓
            # note: optional
            int count                   # = 1
    ) except +
    void PushStyleVar(ImGuiStyleVar, float) except +  # ✓
    void PushStyleVar(ImGuiStyleVar, const ImVec2&) except +  # ✓
    void PopStyleVar( # ✓
            # note: optional
            int count                   # = 1
    ) except +
    
    void PushAllowKeyboardFocus(bool allow_keyboard_focus) except +  # ✓
    void PopAllowKeyboardFocus() except +  # ✓
    void PushButtonRepeat(bool repeat) except +  # ✓
    void PopButtonRepeat() except +  # ✓

    # ====
    # Parameters stacks (current window)
    void PushItemWidth(float item_width) except +  # ✓
    void PopItemWidth() except +  # ✓
    void SetNextItemWidth(float item_width) except + # ✓
    float CalcItemWidth() except +  # ✓
    void PushTextWrapPos( # ✓
            # note: optional
            float wrap_local_pos_x      # = 0.0
    ) except +
    void PopTextWrapPos() except +  # ✓
    
    # ===
    # Style read access
    ImFont* GetFont() except +  # ✗
    float GetFontSize() except +  # ✓
    ImVec2 GetFontTexUvWhitePixel() except +  # ✓
    ImU32 GetColorU32( # ✓
            ImGuiCol idx, 
            # note: optional
            float alpha_mul             # = 1.0
    ) except +
    ImU32 GetColorU32(const ImVec4& col) except +  # ✓
    ImU32 GetColorU32(ImU32 col) except +  # ✓
    ImVec4& GetStyleColorVec4(ImGuiCol idx) except +  # ✓

    # ====
    # Cursor / Layout
    void Separator() except +  # ✓
    void SameLine(  # ✓
            # note: optional
            float offset_from_start_x,  # = 0.0
            float spacing               # = -1.0 # API CHANGE
    ) except +
    void NewLine() except +  # ✓
    void Spacing() except +  # ✓
    void Dummy(const ImVec2& size) except +  # ✓
    void Indent(  # ✓
            # note: optional
            float indent_w              # = 0.0
    ) except +
    void Unindent(  # ✓
            # note: optional
            float indent_w              # = 0.0
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
    bool Button( # ✓
            const char* label, 
            # note: optional
            const ImVec2& size          # = ImVec2(0,0)
    ) except +
    bool Button(const char* label) except +  # ✓
    bool SmallButton(const char*) except +  # ✓
    bool InvisibleButton( # ✓
            const char* str_id, 
            const ImVec2& size, 
            # note: optional
            ImGuiButtonFlags flags      # = 0
    ) except +
    bool ArrowButton(const char* str_id, ImGuiDir dir) except +  # ✓
    void Image(  # ✓
            ImTextureID user_texture_id, 
            const ImVec2& size,
            # note: optional
            const ImVec2& uv0,          # = ImVec2(0,0)
            const ImVec2& uv1,          # = ImVec2(1,1)
            const ImVec4& tint_col,     # = ImVec4(1,1,1,1)
            const ImVec4& border_col    # = ImVec4(0,0,0,0)
    ) except +  
    bool ImageButton(  # ✓
            ImTextureID user_texture_id, 
            const ImVec2& size,
            # note: optional
            const ImVec2& uv0,          # = ImVec2(0,0)
            const ImVec2& uv1,          # = ImVec2(1,1)
            int frame_padding,          # = -1
            const ImVec4& bg_col,       # = ImVec4(0,0,0,0)
            const ImVec4& tint_col      # = ImVec4(1,1,1,1)
    ) except +
    bool Checkbox(const char* label, bool* v) except +  # ✓
    bool CheckboxFlags( const char* label, int* flags, int flags_value ) except + # ✗
    bool CheckboxFlags(  # ✓
            const char* label, unsigned int* flags, unsigned int flags_value
    ) except +
    bool RadioButton(const char* label, bool active) except +  # ✓
    # note: probably no reason to support it
    bool RadioButton(const char* label, int* v, int v_button) except +  # ✓
    void ProgressBar(  # ✓
            float fraction,
            # note: optional
            const ImVec2& size_arg,     # = ImVec2(-FLT_MIN, 0)
            const char* overlay         # = NULL
    ) except +  
    void Bullet() except +  # ✓

    # ====
    # Widgets: Combo Box
    bool BeginCombo( # ✗
            const char* label, 
            const char* preview_value, 
            # note: optional
            ImGuiComboFlags flags       # = 0
    ) except + 
    bool EndCombo() except + # ✗
    bool Combo(  # ✓
            const char* label, 
            int* current_item,
            const char* items_separated_by_zeros,
            # note: optional
            int popup_max_height_in_items # = -1
    ) except +  
    # note: we only implemented the null-separated version that is fully
    #       compatible with following. Probably no reason to support it
    bool Combo(  # ✓
            const char* label, 
            int* current_item,
            const char** items, 
            int items_count,
            # note: optional
            int popup_max_height_in_items # = -1
    ) except +
    bool Combo(  # ✗
            const char* label, 
            int* current_item,
            bool (*items_getter)(void* data,  # TODO: Callback
            int idx, 
            const char** out_text),
            void* data, int items_count,
            # note: optional
            int popup_max_height_in_items # = -1
    ) except +  
    
    # ====
    # Widgets: Drag Sliders
    # manually input values aren't clamped, can go off-bounds) except +  # For all the Float2/Float3/Float4/Int2/Int3/Int4 versions of every
    # functions, remember than a 'float v[3]' function argument is the same
    # as 'float* v'. You can pass address of your first element out of a
    # contiguous set, e.g. &myvector.x
    bool DragFloat( # ✓
            const char* label, 
            float* v, 
            # note: optional
            float v_speed,          # = 1.0
            float v_min,            # = 0.0
            float v_max,            # = 0.0
            const char* format,     # = "%.3f"
            ImGuiSliderFlags flags  # = 0
    ) except +
    bool DragFloat2( # ✓
            const char* label, 
            float v[2], 
            # note: optional
            float v_speed,          # = 1.0 
            float v_min,            # = 0.0
            float v_max,            # = 0.0
            const char* format,     # = "%.3f"
            ImGuiSliderFlags flags  # = 0
    ) except +
    bool DragFloat3( # ✓
            const char* label, 
            float v[3], 
            # note: optional
            float v_speed,          # = 1.0
            float v_min,            # = 0.0
            float v_max,            # = 0.0
            const char* format,     # = "%.3f"
            ImGuiSliderFlags flags  # = 0
    ) except +
    bool DragFloat4( # ✓
            const char* label, 
            float v[4], 
            # note: optional
            float v_speed,          # = 1.0
            float v_min,            # = 0.0
            float v_max,            # = 0.0
            const char* format,     # = "%.3f"
            ImGuiSliderFlags flags  # = 0
    ) except +
    bool DragFloatRange2( # ✓
            const char* label, float* v_current_min, float* v_current_max, 
            # note: optional
            float v_speed,          # = 1.0
            float v_min,            # = 0.0
            float v_max,            # = 0.0
            const char* format,     # = "%.3f"
            const char* format_max, # = NULL
            ImGuiSliderFlags flags  # = 0
    ) except +
    bool DragInt(  # ✓
            const char* label, 
            int* v,
            # note: optional
            float v_speed,          # = 1.0
            int v_min,              # = 0
            int v_max,              # = 0
            const char* format,     # = "%d"
            ImGuiSliderFlags flags  # = 0
    ) except +
    bool DragInt2(  # ✓
            const char* label, 
            int v[2],
            # note: optional
            float v_speed,          # = 1.0
            int v_min,              # = 0
            int v_max,              # = 0
            const char* format,     # = "%d"
            ImGuiSliderFlags flags  # = 0
    ) except +
    bool DragInt3(  # ✓
            const char* label, 
            int v[3],
            # note: optional
            float v_speed,          # = 1.0 
            int v_min,              # = 0
            int v_max,              # = 0
            const char* format,     # = "%d"
            ImGuiSliderFlags flags  # = 0
    ) except +
    bool DragInt4(  # ✓
            const char* label, 
            int v[4],
            # note: optional
            float v_speed,          # = 1.0 
            int v_min,              # = 0
            int v_max,              # = 0
            const char* format,     # = "%d"
            ImGuiSliderFlags flags  # = 0
    ) except +
    bool DragIntRange2(  # ✓
            const char* label, 
            int* v_current_min, 
            int* v_current_max,
            # note: optional
            float v_speed,          # = 1.0
            int v_min,              # = 0
            int v_max,              # = 0
            const char* format,     # = "%d"
            const char* format_max, # = NULL
            ImGuiSliderFlags flags  # = 0
    ) except +  # Widgets: Input with Keyboard
    bool DragScalar( # ✓
            const char* label, 
            ImGuiDataType data_type, 
            void* p_data, 
            float v_speed, 
            # note: optional
            const void* p_min,      # = NULL
            const void* p_max,      # = NULL
            const char* format,     # = NULL    
            ImGuiSliderFlags flags  # = 0
    ) except +
    bool DragScalarN( # ✓
            const char* label, 
            ImGuiDataType data_type, 
            void* p_data, 
            int components, 
            float v_speed, 
            # note: optional
            const void* p_min,      # = NULL
            const void* p_max,      # = NULL
            const char* format,     # = NULL
            ImGuiSliderFlags flags  # = 0
    ) except +
    
    # ====
    # Widgets: Regular Sliders
    #  manually input values aren't clamped, can go off-bounds)
    bool SliderFloat(  # ✓
            const char* label, float* v, float v_min, float v_max,
            # note: optional
            const char* format,     # = "%.3f"
            ImGuiSliderFlags flags  # = 0
    ) except +
    bool SliderFloat2(  # ✓
            const char* label, float v[2], float v_min, float v_max,
            # note: optional
            const char* format,     # = "%.3f"
            ImGuiSliderFlags flags  # = 0
    ) except +
    bool SliderFloat3(  # ✓
            const char* label, float v[3], float v_min, float v_max,
            # note: optional
            const char* format,     # = "%.3f"
            ImGuiSliderFlags flags  # = 0
    ) except +
    bool SliderFloat4(  # ✓
            const char* label, float v[4], float v_min, float v_max,
            # note: optional
            const char* format,     # = "%.3f"
            ImGuiSliderFlags flags  # = 0
    ) except +
    bool SliderAngle(  # ✓
            const char* label, float* v_rad,
            # note: optional
            float v_degrees_min,    # = -360.0
            float v_degrees_max,    # = 360.0
            const char* format,     # = "%.0f deg"
            ImGuiSliderFlags flags  # = 0
    ) except +
    bool SliderInt(  # ✓
            const char* label, int* v, int v_min, int v_max,
            # note: optional
            const char* format,     # = "%d"
            ImGuiSliderFlags flags  # = 0
    ) except +
    bool SliderInt2(  # ✓
            const char* label, int v[2], int v_min, int v_max,
            # note: optional
            const char* format,     # = "%d"
            ImGuiSliderFlags flags  # = 0
    ) except +
    bool SliderInt3(  # ✓
            const char* label, int v[3], int v_min, int v_max,
            # note: optional
            const char* format,     # = "%d"
            ImGuiSliderFlags flags  # = 0
    ) except +
    bool SliderInt4(  # ✓
            const char* label, int v[4], int v_min, int v_max,
            # note: optional
            const char* format,     # = "%d"
            ImGuiSliderFlags flags  # = 0
    ) except +
    bool SliderScalar( # ✓
            const char* label, ImGuiDataType data_type,
            void* v, const void* v_min, const void* v_max,
            # note: optional
            const char* format,     # = NULL
            ImGuiSliderFlags flags  # = 0
    ) except +
    bool SliderScalarN( # ✓
            const char* label, ImGuiDataType data_type,
            void *v,
            int components, const void* v_min, const void* v_max,
            # note: optional
            const char* format,     # = NULL
            ImGuiSliderFlags flags  # = 0
    ) except +
    bool VSliderFloat(  # ✓
            const char* label, const ImVec2& size, float* v,
            float v_min, float v_max,
            # note: optional
            const char* format,     # = "%.3f"
            ImGuiSliderFlags flags  # = 0
    ) except +
    bool VSliderInt(  # ✓
            const char* label, const ImVec2& size, int* v, int v_min, int v_max,
            # note: optional
            const char* format,     # = "%d"
            ImGuiSliderFlags flags  # = 0       # NEW
    ) except +  # Widgets: Trees
    bool VSliderScalar(  # ✓
            const char* label, 
            const ImVec2& size, 
            ImGuiDataType data_type, void* v
            , const void* v_min, const void* v_max,
            # note: optional
            const char* format,     # = NULL
            ImGuiSliderFlags flags  # = 0
    ) except +
    
    # ====
    # Widgets: Input with Keyboard
    bool InputText(  # ✓
            const char* label, char* buf, size_t buf_size,
            # note: optional
            ImGuiInputTextFlags flags,          # = 0
            ImGuiInputTextCallback callback,    # = NULL
            void* user_data                     # = NULL
    ) except +
    bool InputTextMultiline(  # ✓
            const char* label, char* buf, size_t buf_size,
            # note: optional
            const ImVec2& size,                 # = ImVec2(0,0)
            ImGuiInputTextFlags flags,          # = 0
            ImGuiInputTextCallback callback,    # = NULL
            void* user_data                     # = NULL
    ) except +
    bool InputTextWithHint( # ✓
            const char* label, const char* hint, char* buf, 
            size_t buf_size, 
            # note: optional
            ImGuiInputTextFlags flags,          # = 0
            ImGuiInputTextCallback callback,    # = NULL
            void* user_data                     # = NULL    
    ) except +
    bool InputFloat(  # ✓
            const char* label, float* v,
            # note: optional
            float step,                         # = 0.0f
            float step_fast,                    # = 0.0f
            const char* format,                 # = "%.3f"
            ImGuiInputTextFlags flags           # = 0
    ) except +
    bool InputFloat2(  # ✓
            const char* label, float v[2],
            # note: optional
            const char* format,                 # = "%.3f"
            ImGuiInputTextFlags flags           # = 0
    ) except +
    bool InputFloat3(  # ✓
            const char* label, float v[3],
            # note: optional
            const char* format,                 # = "%.3f"
            ImGuiInputTextFlags flags           # = 0
    ) except +
    bool InputFloat4(  # ✓
            const char* label, float v[4],
            # note: optional
            const char* format,                 # = "%.3f"
            ImGuiInputTextFlags flags           # = 0
    ) except +
    bool InputInt(  # ✓
            const char* label, int* v,
            # note: optional
            int step,                           # = 1
            int step_fast,                      # = 100
            ImGuiInputTextFlags flags           # = 0
    ) except +
    bool InputInt2(  # ✓
            const char* label, int v[2],
            # note: optional
            ImGuiInputTextFlags flags           # = 0
    ) except +
    bool InputInt3(  # ✓
            const char* label, int v[3],
            # note: optional
            ImGuiInputTextFlags flags           # = 0
    ) except +
    bool InputInt4(  # ✓
            const char* label, int v[4],
            # note: optional
            ImGuiInputTextFlags flags           # = 0
    ) except +  
    bool InputDouble(  # ✓
            const char* label, 
            double* v,
            # note: optional
            double step,                        # = 0.0
            double step_fast,                   # = 0.0
            const char* format,                 # = "%.6f"
            ImGuiInputTextFlags flags           # = 0
    ) except +
    bool InputScalar( # ✓
            const char* label, ImGuiDataType data_type, void* p_data, 
            # note: optional
            const void* p_step,                 # = NULL
            const void* p_step_fast,            # = NULL
            const char* format,                 # = NULL
            ImGuiInputTextFlags flags           # = 0
    ) except +
    bool InputScalarN( # ✓
            const char* label, ImGuiDataType data_type, 
            void* p_data, int components, 
            # note: optional
            const void* p_step,                 # = NULL
            const void* p_step_fast,            # = NULL
            const char* format,                 # = NULL
            ImGuiInputTextFlags flags           # = 0
    ) except +
    
    # ====
    # Widgets: Color Editor/Picker
    bool ColorEdit3( # ✓
            const char* label, 
            float col[3],
            # note: optional
            ImGuiColorEditFlags flags           # = 0   # NEW
    ) except + 
    bool ColorEdit4(  # ✓
            const char* label, float col[4],
            # note: optional
            ImGuiColorEditFlags flags           # = 0   # API CHANGE
    ) except +  
    #void ColorEditMode(ImGuiColorEditMode mode) except +  # note: obsoleted
    bool ColorPicker3( # ✗
            const char* label, float col[3], 
            # note: optional
            ImGuiColorEditFlags flags           # = 0
    ) except + 
    bool ColorPicker4( # ✗
            const char* label, float col[4], 
            # note: optional
            ImGuiColorEditFlags flags,          # = 0
            const float* ref_col                # = NULL
    ) except +
    bool ColorButton(  # ✓
            const char *desc_id,
            const ImVec4& col,
            # note: optional
            ImGuiColorEditFlags flags,          # = 0
            ImVec2 size                         # = ImVec2(0,0)
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
            ImGuiTreeNodeFlags flags            # = 0
    ) except +  
    # bool TreeNodeEx(const char* str_id, ImGuiTreeNodeFlags flags, const char* fmt, ...) except +  # ✗
    # bool TreeNodeEx(const void* ptr_id, ImGuiTreeNodeFlags flags, const char* fmt, ...) except +  # ✗
    # bool TreeNodeExV(const char* str_id, ImGuiTreeNodeFlags flags, const char* fmt, va_list args) except +  # ✗
    # bool TreeNodeExV(const void* ptr_id, ImGuiTreeNodeFlags flags, const char* fmt, va_list args) except +  # ✗
    void TreePush(const char* str_id) except + # ✗
    void TreePush(  # ✗
            # note: optional
            const void* ptr_id                  # = NULL
    ) except +
    void TreePop() except +  # ✓
    void TreeAdvanceToLabelPos() except +  # ✗ # OBSOLETED in 1.72 (from April 2019)
    float GetTreeNodeToLabelSpacing() except +  # ✓
    bool CollapsingHeader(  # ✓
            const char* label,
            # note: optional
            ImGuiTreeNodeFlags flags            # = 0
    ) except +
    bool CollapsingHeader(  # ✓
            const char* label, bool* p_visible,
            # note: optional
            ImGuiTreeNodeFlags flags            # = 0
    ) except +  
    void SetNextItemOpen( # ✓
            bool is_open, 
            # note: open
            ImGuiCond cond                      # = 0
    ) except +
    void SetNextTreeNodeOpen(  # ✗ # OBSOLETED in 1.72 (from April 2019)
            bool is_open,
            # note: optional
            ImGuiCond cond
    ) except +
    
    # ====
    # Widgets: Selectable
    bool Selectable(  # ✓
            const char* label,
            # note: optional
            bool selected,                      # = False
            ImGuiSelectableFlags flags,         # = 0
            const ImVec2& size                  # = ImVec2(0,0)
    ) except +
    bool Selectable(  # ✓
            const char* label, bool* p_selected,
            # note: optional
            ImGuiSelectableFlags flags,         #= 0
            const ImVec2& size                  # = ImVec2(0,0)
    ) except +

    # ====
    # Widgets: List Boxes
    bool ListBox(  # ✓
            const char* label, int* current_item, const char* items[],
            int items_count,
            # note: optional
            int height_in_items                 # = -1
    ) except +
    bool ListBox(  # ✗
            const char* label, int* current_item,
            bool (*items_getter)(void* data, int idx, const char** out_text), # TODO: Callback
            void* data, int items_count,
            # note: optional
            int height_in_items                 # = -1
    ) except +
    
    bool BeginListBox( # ✓
            const char* label, 
            # note: optional
            const ImVec2& size                  # = ImVec2(0,0)
    ) except +
    #bool ListBoxHeader(  # OBSOLETED in 1.81 (from February 2021)
    #        const char* label,
    #        # note: optional
    #        const ImVec2& size                  # = ImVec2(0,0)
    #) except +
    #bool ListBoxHeader(  # REMOVED in 1.81 (from February 2021)
    #        const char* label, int items_count,
    #        # note: optional
    #        int height_in_items                 # = -1
    #) except +
    void EndListBox() except + # ✓
    #void ListBoxFooter() except +  # OBSOLETED in 1.81 (from February 2021)

    # ====
    # Widgets: Data Plotting
    void PlotLines( # ✓
            const char* label, const float* values, int values_count,
            # note: optional
            int values_offset,          # = 0
            const char* overlay_text,   # = NULL
            float scale_min,            # = FLT_MAX
            float scale_max,            # = FLT_MAX
            ImVec2 graph_size,          # = ImVec2(0,0)
            int stride                  # = sizeof(float))
    ) except +
    void PlotLines( # ✗
            const char* label, 
            float(*values_getter)(void* data, int idx), # TODO: Callback
            void* data, int values_count, 
            # note: optional
            int values_offset,          # = 0
            const char* overlay_text,   # = NULL
            float scale_min,            # = FLT_MAX
            float scale_max,            # = FLT_MAX
            ImVec2 graph_size           # = ImVec2(0,0)
    ) except + 
    void PlotHistogram(  # ✓
            const char* label, const float* values, int values_count,
            # note: optional
            int values_offset,          # = 0
            const char* overlay_text,   # = NULL
            float scale_min,            # = FLT_MAX
            float scale_max,            # = FLT_MAX
            ImVec2 graph_size,          # = ImVec2(0,0)
            int stride                  # = sizeof(float)
    ) except +
    void PlotHistogram(  # ✗
            const char* label, 
            float (*values_getter)(void* data, int idx), # TODO: Callback
            void* data, int values_count,
            # note: optional
            int values_offset,          # = 0
            const char* overlay_text,   # = NULL
            float scale_min,            # = FLT_MAX
            float scale_max,            # = FLT_MAX
            ImVec2 graph_size           # = ImVec2(0,0)
    ) except +

    # ====
    # Widgets: Value() Helpers.
    void Value(const char* prefix, bool b) except +  # ✗
    void Value(const char* prefix, int v) except +  # ✗
    void Value(const char* prefix, unsigned int v) except +  # ✗
    void Value(  # ✗
            const char* prefix, float v,
            # note: optional
            const char* float_format    # = NULL    
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
            bool enabled                # = true
    ) except +
    void EndMenu() except +  # ✓
    bool MenuItem(  # ✓
            const char* label,
            # note: optional
            const char* shortcut,       # = NULL    
            bool selected,              # = false
            bool enabled                # = true
    ) except +
    bool MenuItem(  # ✓
            const char* label, const char* shortcut, bool* p_selected,
            # note: optional
            bool enabled                # = true
    ) except +
    
    # ====
    # Tooltips
    void BeginTooltip() except +  # ✓
    void EndTooltip() except +  # ✓
    void SetTooltip(const char* fmt, ...) except +  # ✓
    # void SetTooltipV(const char* fmt, va_list args) except +  # ✗
    
    # ====
    # Popups, Modals
    bool BeginPopup( # ✓
            const char* str_id, 
            # note: optional
            ImGuiWindowFlags flags       # = 0
    ) except +
    bool BeginPopupModal(  # ✓
            const char* name,
            # note: optional
            bool* p_open,                # = NULL 
            ImGuiWindowFlags extra_flags # = 0
    ) except +
    void EndPopup() except +  # ✓
    void OpenPopup( # ✓
            const char* str_id,
            # note: optional
            ImGuiPopupFlags popup_flags # = 0
    ) except + 
    void OpenPopupOnItemClick( # ✓
            # note: optional
            const char* str_id,         # = NULL 
            ImGuiPopupFlags popup_flags # = 1
    ) except +
    void CloseCurrentPopup() except +  # ✓
    bool BeginPopupContextItem(  # ✓
            # note: optional
            const char* str_id,         # = NULL
            ImGuiPopupFlags popup_flags # = 1
    ) except +
    bool BeginPopupContextWindow( # ✓
            # note: optional
            const char* str_id,         # = NULL 
            ImGuiPopupFlags popup_flags # = 1
    ) except +
    bool BeginPopupContextVoid(  # ✓
            # note: optional
            const char* str_id,         # = NULL
            ImGuiPopupFlags popup_flags # = 1
    ) except +
    bool IsPopupOpen( # ✓
            const char* str_id,
            # note: optional
            ImGuiPopupFlags flags       # = 0
    ) except + 
    
    # ====
    # Tables
    # [BETA API] API may evolve slightly!
    bool BeginTable( # ✓
            const char* str_id, 
            int column, 
            # note: optional
            ImGuiTableFlags flags,      # = 0
            const ImVec2& outer_size,   # = ImVec2(0.0f, 0.0f)
            float inner_width           # = 0.0f
    ) except +
    void EndTable() except + # ✓
    void TableNextRow( # ✓
            # note: optional
            ImGuiTableRowFlags row_flags,   # = 0
            float min_row_height            # = 0.0f
    ) except +
    bool TableNextColumn() except + # ✓
    bool TableSetColumnIndex(int column_n) except + # ✓
    
    void TableSetupColumn( # ✓
            const char* label, 
            # note: optional
            ImGuiTableColumnFlags flags,    # = 0
            float init_width_or_weight,     # = 0.0f
            ImGuiID user_id                 # = 0
    ) except +
    void TableSetupScrollFreeze(int cols, int rows) except + # ✓
    void TableHeadersRow() except + # ✓
    void TableHeader(const char* label) except + # ✓
    
    ImGuiTableSortSpecs* TableGetSortSpecs() except + # ✓
    
    int TableGetColumnCount() except + # ✓
    int TableGetColumnIndex() except + # ✓
    int TableGetRowIndex() except + # ✓
    const char* TableGetColumnName( # ✓
            # note: optional
            int column_n                    # = -1
    ) except +        
    ImGuiTableColumnFlags TableGetColumnFlags( # ✓
            # note: optional
            int column_n                    # = -1
    ) except +
    void TableSetBgColor( # ✓
            ImGuiTableBgTarget target, 
            ImU32 color, 
            # note: optional
            int column_n                    # = -1
    ) except + 
    
    
    # ====
    # Columns
    # Legacy Columns API (2020: prefer using Tables!)
    void Columns(  # ✓
            # note: optional
            int count,                  # = 1
            const char* id,             # = NULL
            bool border                 # = true
    ) except +
    void NextColumn() except +  # ✓
    int GetColumnIndex() except +  # ✓
    float GetColumnWidth(  # ✓
            # note: optional
            int column_index            # = -1
    ) except +
    void SetColumnWidth(int column_index, float width) except +  # ✓
    float GetColumnOffset(  # ✓
            # note: optional
            int column_index            # = -1
    ) except +
    void SetColumnOffset(int column_index, float offset_x) except +  # ✓
    int GetColumnsCount() except +  # ✓
    
    # ====
    # Tab Bars, Tabs
    # Note: Tabs are automatically created by the docking system. Use this to create tab bars/tabs yourself without docking being involved.
    bool BeginTabBar( # ✓
            const char* str_id, 
            # note: optional
            ImGuiTabBarFlags flags      # = 0    
    ) except +
    void EndTabBar() except + # ✓                                                        // only call EndTabBar() if BeginTabBar() returns true!
    bool BeginTabItem( # ✓
            const char* label, 
            # note: optional
            bool* p_open,               # = NULL
            ImGuiTabItemFlags flags     # = 0
    ) except +
    void EndTabItem() except + # ✓
    bool TabItemButton( # ✓
            const char* label, 
            # note: optional
            ImGuiTabItemFlags flags     # = 0
    ) except +
    void SetTabItemClosed(const char* tab_or_docked_window_label) except + # ✓
    

    # ====
    # Docking
    # [BETA API] Enable with io.ConfigFlags |= ImGuiConfigFlags_DockingEnable.
    # Note: You can use most Docking facilities without calling any API. You DO NOT need to call DockSpace() to use Docking!
    # - To dock windows: if io.ConfigDockingWithShift == false (default) drag window from their title bar.
    # - To dock windows: if io.ConfigDockingWithShift == true: hold SHIFT anywhere while moving windows.
    # About DockSpace:
    # - Use DockSpace() to create an explicit dock node _within_ an existing window. See Docking demo for details.
    # - DockSpace() needs to be submitted _before_ any window they can host. If you use a dockspace, submit it early in your app.
    void DockSpace(
            ImGuiID id, 
            # note: optional
            const ImVec2& size,                  # = ImVec2(0, 0)
            ImGuiDockNodeFlags flags,            # = 0
            const ImGuiWindowClass* window_class # = NULL
    ) except + # ✓
    ImGuiID DockSpaceOverViewport(
            # note: optional
            const ImGuiViewport* viewport,        # = NULL
            ImGuiDockNodeFlags flags,             # = 0
            const ImGuiWindowClass* window_class  # = NULL
    ) except + # ✗
    # set next window dock id (FIXME-DOCK)
    void SetNextWindowDockID(
            ImGuiID dock_id, 
            # note: optional
            ImGuiCond cond      #= 0
    ) except + # ✗
    # set next window class (rare/advanced uses: provide hints to the platform backend via altered viewport flags and parent/child info)
    void SetNextWindowClass(const ImGuiWindowClass* window_class) except + # ✗
    ImGuiID GetWindowDockID() except + # ✗
    bool IsWindowDocked() except + # ✗

    # ====
    # Logging/Capture
    # Logging: all text output from interface is redirected to
    # tty/file/clipboard. By default, tree nodes are automatically opened
    #  during logging.
    void LogToTTY(  # ✗
            # note: optional
            int auto_open_depth         # = -1
    ) except +
    void LogToFile(  # ✗
            # note: optional
            int auto_open_depth,        # = -1
            const char* filename        # = NULL
    ) except +
    void LogToClipboard(  # ✗
            # note: optional
            int auto_open_depth         # = -1
    ) except +
    void LogFinish() except +  # ✗
    void LogButtons() except +  # ✗
    void LogText(const char* fmt, ...) except +  # ✗
    # void LogTextV(const char* fmt, va_list args) except + # ✗

    # ====
    # Drag and Drop
    bool BeginDragDropSource( # ✓
            # note: optional
            ImGuiDragDropFlags flags    # = 0
    ) except +
    bool SetDragDropPayload( # ✓
            const char* type, 
            const void* data, 
            size_t size, 
            # note: optional
            ImGuiCond cond              # = 0
    ) except +  
    void EndDragDropSource() except +  # ✓
    bool BeginDragDropTarget() except +  # ✓
    const ImGuiPayload* AcceptDragDropPayload( # ✓
            const char* type, 
            # note:optional
            ImGuiDragDropFlags flags    # = 0
    ) except + 
    void EndDragDropTarget() except +  # ✓
    const ImGuiPayload* GetDragDropPayload() except + # ✓

    # ====
    # Clipping
    void PushClipRect(const ImVec2& clip_rect_min, const ImVec2& clip_rect_max, bool intersect_with_current_clip_rect) except +  # ✓
    void PopClipRect() except +  # ✓

    # ====
    # Focus, Activation
    void SetItemDefaultFocus() except +  # ✓
    void SetKeyboardFocusHere( # ✓
            # note: optional
            int offset
    ) except +

    # ====
    # Item/Widgets Utilities
    bool IsItemHovered( # ✓
            # note: optional
            ImGuiHoveredFlags flags
    ) except + 
    bool IsItemActive() except +  # ✓
    bool IsItemFocused() except +  # ✓
    bool IsItemClicked(  # ✓
            # note: optional
            ImGuiMouseButton mouse_button # = 0
    ) except +
    bool IsItemVisible() except +  # ✓
    bool IsItemEdited() except + # ✓
    bool IsItemActivated() except + # ✓
    bool IsItemDeactivated() except + # ✓
    bool IsItemDeactivatedAfterEdit() except + # ✓
    bool IsItemToggledOpen() except + # ✓
    bool IsAnyItemHovered() except +  # ✓
    bool IsAnyItemActive() except +  # ✓
    bool IsAnyItemFocused() except +  # ✓
    ImVec2 GetItemRectMin() except +  # ✓
    ImVec2 GetItemRectMax() except +  # ✓
    ImVec2 GetItemRectSize() except +  # ✓
    void SetItemAllowOverlap() except +  # ✓
    
    # ====
    # Viewports
    ImGuiViewport* GetMainViewport() except + # ✓
    
    # ====
    # Miscellaneous Utilities
    bool IsRectVisible(const ImVec2& size) except +  # ✓
    bool IsRectVisible(const ImVec2& rect_min, const ImVec2& rect_max) except +  # ✗
    double GetTime() except +  # ✓
    int GetFrameCount() except +  # ✗
    ImDrawList* GetBackgroundDrawList() except +  # ✓
    ImDrawList* GetForegroundDrawList() except +  # ✓
    ImDrawList* GetBackgroundDrawList(ImGuiViewport* viewport) except +  # ✗
    ImDrawList* GetForegroundDrawList(ImGuiViewport* viewport) except +  # ✗
    ImDrawListSharedData* GetDrawListSharedData() except +  # ✗
    const char* GetStyleColorName(ImGuiCol idx) except +  # ✓
    void SetStateStorage(ImGuiStorage* storage) except +  # ✗
    ImGuiStorage* GetStateStorage() except +  # ✗
    void CalcListClipping(int items_count, float items_height, int* out_items_display_start, int* out_items_display_end) except +  # ✗
    bool BeginChildFrame(  # ✗
            ImGuiID id, const ImVec2& size,
            # note: optional
            ImGuiWindowFlags flags              # = 0
    ) except +
    void EndChildFrame() except +  # ✗

    # Text Utilities
    ImVec2 CalcTextSize(  # ✓
            const char* text,
            # note: optional
            const char* text_end,               # = NULL    
            bool hide_text_after_double_hash,   # = false
            float wrap_width                    # = -1.0
    ) except +

    # ====
    # Color Utilities
    ImVec4 ColorConvertU32ToFloat4(ImU32 in_) except +  # ✓
    ImU32 ColorConvertFloat4ToU32(const ImVec4& in_) except +  # ✓
    void ColorConvertRGBtoHSV(float r, float g, float b, float& out_h, float& out_s, float& out_v) except +  # ✓
    void ColorConvertHSVtoRGB(float h, float s, float v, float& out_r, float& out_g, float& out_b) except +  # ✓

    # ====
    # Inputs Utilities: Keyboard
    int GetKeyIndex(ImGuiKey key) except +  # ✓
    bool IsKeyDown(int key_index) except +  # ✓
    bool IsKeyPressed(  # ✓
            int key_index,
            # note: optional
            bool repeat                         # = True
    ) except +
    bool IsKeyReleased(int key_index) except +  # ✓
    int GetKeyPressedAmount(int key_index, float repeat_delay, float rate) except +  # ✗
    void CaptureKeyboardFromApp(  # ✗
            # note: optional
            bool want_capture_keyboard_value    # = True
    ) except +
    
    # ====
    # Inputs Utilities: Mouse
    bool IsMouseDown(int button) except +  # ✓
    bool IsMouseClicked(  # ✓
            int button,
            # note: optional
            bool repeat             # = False
    ) except +
    bool IsMouseDoubleClicked(int button) except +  # ✓
    bool IsMouseReleased(int button) except +  # ✓
    bool IsMouseHoveringRect(  # ✓
            const ImVec2& r_min, const ImVec2& r_max,
            # note: optional
            bool clip               # = True
    ) except +
    bool IsMousePosValid(const ImVec2* mouse_pos) except +  # ✗
    bool IsAnyMouseDown() except +  # ✗
    ImVec2 GetMousePos() except +  # ✓
    ImVec2 GetMousePosOnOpeningCurrentPopup() except +  # ✗
    bool IsMouseDragging(  # ✓
            int button,
            # note: optional
            float lock_threshold        # = -1.0f
    ) except +
    ImVec2 GetMouseDragDelta(  # ✓
            # note: optional
            int button,                 # = 0
            float lock_threshold        # = -1.0f
    ) except +
    void ResetMouseDragDelta(  # ✓
            # note: optional
            int button                  # = 0
    ) except +
    ImGuiMouseCursor GetMouseCursor() except +  # ✓
    void SetMouseCursor(ImGuiMouseCursor type) except +  # ✓
    void CaptureMouseFromApp(  # ✓
            # note: optional
            bool want_capture_mouse_value   # = True
    ) except +
    
    # ====
    # Clipboard Utilities
    const char* GetClipboardText() except +  # ✓
    void SetClipboardText(const char* text) except +  # ✓

    # ====
    # Settings/.Ini Utilities
    void LoadIniSettingsFromDisk(  # ✓
            const char* ini_filename
    ) except +
    void LoadIniSettingsFromMemory(  # ✓
            const char* ini_data,
            # note: optional
            size_t ini_size                 # = 0    
    ) except +
    void SaveIniSettingsToDisk(  # ✓
            const char* ini_filename
    ) except +
    const char* SaveIniSettingsToMemory(  # ✓
            # note: optional
            size_t* out_ini_size            # = NULL
    ) except +
    
    # ====
    # Debug Utilities
    bool DebugCheckVersionAndDataLayout(const char* version_str, size_t sz_io, size_t sz_style, size_t sz_vec2, size_t sz_vec4, size_t sz_drawvert) except +  # ✓
    
    # ====
    # Memory Allocators
    void SetAllocatorFunctions( # ✗
            void* (*alloc_func)(size_t sz, void* user_data),  # TODO: Callback
            void (*free_func)(void* ptr, void* user_data),  # TODO: Callback
            # note: optional
            void* user_data                 # = NULL
    ) except +
    void GetAllocatorFunctions( # ✗
        ImGuiMemAllocFunc* p_alloc_func, # TODO: Callback
        ImGuiMemFreeFunc* p_free_func, # TODO: Callback
        void** p_user_data
    ) except +
    void* MemAlloc(size_t size) except + # ✗
    void MemFree(void* ptr) except + # ✗


    # ====
    # (Optional) Platform/OS interface for multi-viewport support
    # Read comments around the ImGuiPlatformIO structure for more details.
    # Note: You may use GetWindowViewport() to get the current viewport of the current window.
    ImGuiPlatformIO& GetPlatformIO() except + # ✗
    void UpdatePlatformWindows() except + # ✗
    void RenderPlatformWindowsDefault(
        # note: optional
        void* platform_render_arg,       # = NULL
        void* renderer_render_arg        # = NULL
    ) except + # ✗
    void DestroyPlatformWindows() except + # ✗
    ImGuiViewport* FindViewportByID(ImGuiID id) except + # ✗
    ImGuiViewport* FindViewportByPlatformHandle(void* platform_handle) except + # ✗
    
    