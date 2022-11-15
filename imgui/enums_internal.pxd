cdef extern from "imgui_internal.h":
    
    ctypedef enum ImGuiItemFlags_:
        ImGuiItemFlags_None                     #
        ImGuiItemFlags_NoTabStop                # false
        ImGuiItemFlags_ButtonRepeat             # false    # Button() will return true multiple times based on io.KeyRepeatDelay and io.KeyRepeatRate settings.
        ImGuiItemFlags_Disabled                 # false    # [BETA] Disable interactions but doesn't affect visuals yet. See github.com/ocornut/imgui/issues/211
        ImGuiItemFlags_NoNav                    # false
        ImGuiItemFlags_NoNavDefaultFocus        # false
        ImGuiItemFlags_SelectableDontClosePopup # false    # MenuItem/Selectable() automatically closes current Popup window
        ImGuiItemFlags_MixedValue               # false    # [BETA] Represent a mixed/indeterminate value, generally multi-selection where values differ. Currently only supported by Checkbox() (later should support all sorts of widgets)
        ImGuiItemFlags_ReadOnly                 # false    # [ALPHA] Allow hovering interactions but underlying value is not changed.
        ImGuiItemFlags_Default_                 #
        
        
    ctypedef enum ImGuiItemStatusFlags_:
        ImGuiItemStatusFlags_None               #
        ImGuiItemStatusFlags_HoveredRect        #
        ImGuiItemStatusFlags_HasDisplayRect     #
        ImGuiItemStatusFlags_Edited             # Value exposed by item was edited in the current frame (should match the bool return value of most widgets)
        ImGuiItemStatusFlags_ToggledSelection   # Set when Selectable(), TreeNode() reports toggling a selection. We can't report "Selected" because reporting the change allows us to handle clipping with less issues.
        ImGuiItemStatusFlags_ToggledOpen        # Set when TreeNode() reports toggling their open state.
        ImGuiItemStatusFlags_HasDeactivated     # Set if the widget/group is able to provide data for the ImGuiItemStatusFlags_Deactivated flag.
        ImGuiItemStatusFlags_Deactivated        # Only valid if ImGuiItemStatusFlags_HasDeactivated is set.

    ctypedef enum ImGuiButtonFlagsPrivate_:
        ImGuiButtonFlags_PressedOnClick         # return true on click (mouse down event)
        ImGuiButtonFlags_PressedOnClickRelease  # [Default] return true on click + release on same item <-- this is what the majority of Button are using
        ImGuiButtonFlags_PressedOnClickReleaseAnywhere # return true on click + release even if the release event is not done while hovering the item
        ImGuiButtonFlags_PressedOnRelease       # return true on release (default requires click+release)
        ImGuiButtonFlags_PressedOnDoubleClick   # return true on double-click (default requires click+release)
        ImGuiButtonFlags_PressedOnDragDropHold  # return true when held into while we are drag and dropping another item (used by e.g. tree nodes, collapsing headers)
        ImGuiButtonFlags_Repeat                 # hold to repeat
        ImGuiButtonFlags_FlattenChildren        # allow interactions even if a child window is overlapping
        ImGuiButtonFlags_AllowItemOverlap       # require previous frame HoveredId to either match id or be null before being usable, use along with SetItemAllowOverlap()
        ImGuiButtonFlags_DontClosePopups        # disable automatically closing parent popup on press // [UNUSED]
        ImGuiButtonFlags_Disabled               # disable interactions
        ImGuiButtonFlags_AlignTextBaseLine      # vertically align button to match text baseline - ButtonEx() only // FIXME: Should be removed and handled by SmallButton(), not possible currently because of DC.CursorPosPrevLine
        ImGuiButtonFlags_NoKeyModifiers         # disable mouse interaction if a key modifier is held
        ImGuiButtonFlags_NoHoldingActiveId      # don't set ActiveId while holding the mouse (ImGuiButtonFlags_PressedOnClick only)
        ImGuiButtonFlags_NoNavFocus             # don't override navigation focus when activated
        ImGuiButtonFlags_NoHoveredOnFocus       # don't report as hovered when nav focus is on this item
        ImGuiButtonFlags_PressedOnMask_         = ImGuiButtonFlags_PressedOnClick | ImGuiButtonFlags_PressedOnClickRelease | ImGuiButtonFlags_PressedOnClickReleaseAnywhere | ImGuiButtonFlags_PressedOnRelease | ImGuiButtonFlags_PressedOnDoubleClick | ImGuiButtonFlags_PressedOnDragDropHold
        ImGuiButtonFlags_PressedOnDefault_      = ImGuiButtonFlags_PressedOnClickRelease
        
    ctypedef enum ImGuiSliderFlagsPrivate_:
        ImGuiSliderFlags_Vertical               # Should this slider be orientated vertically?
        ImGuiSliderFlags_ReadOnly               #
        
    ctypedef enum ImGuiSelectableFlagsPrivate_:
        # NB: need to be in sync with last value of ImGuiSelectableFlags_
        ImGuiSelectableFlags_NoHoldingActiveID      #
        ImGuiSelectableFlags_SelectOnClick          # Override button behavior to react on Click (default is Click+Release)
        ImGuiSelectableFlags_SelectOnRelease        # Override button behavior to react on Release (default is Click+Release)
        ImGuiSelectableFlags_SpanAvailWidth         # Span all avail width even if we declared less for layout purpose. FIXME: We may be able to remove this (added in 6251d379, 2bcafc86 for menus)
        ImGuiSelectableFlags_DrawHoveredWhenHeld    # Always show active when held, even is not hovered. This concept could probably be renamed/formalized somehow.
        ImGuiSelectableFlags_SetNavIdOnHover        # Set Nav/Focus ID on mouse hover (used by MenuItem)
        ImGuiSelectableFlags_NoPadWithHalfSpacing   # Disable padding each side with ItemSpacing * 0.5f

    ctypedef enum ImGuiTreeNodeFlagsPrivate_:
        ImGuiTreeNodeFlags_ClipLabelForTrailingButton
    
    ctypedef enum ImGuiSeparatorFlags_:
        ImGuiSeparatorFlags_None                #
        ImGuiSeparatorFlags_Horizontal          # Axis default to current layout type, so generally Horizontal unless e.g. in a menu bar
        ImGuiSeparatorFlags_Vertical            #
        ImGuiSeparatorFlags_SpanAllColumns      #
    
    ctypedef enum ImGuiTextFlags_:
        ImGuiTextFlags_None
        ImGuiTextFlags_NoWidthForLargeClippedText
    
    ctypedef enum ImGuiTooltipFlags_:
        ImGuiTooltipFlags_None
        ImGuiTooltipFlags_OverridePreviousTooltip  # Override will clear/ignore previously submitted tooltip (defaults to append)
        
    # FIXME: this is in development, not exposed/functional as a generic feature yet.
    # Horizontal/Vertical enums are fixed to 0/1 so they may be used to index ImVec2
    ctypedef enum ImGuiLayoutType_:
        ImGuiLayoutType_Horizontal
        ImGuiLayoutType_Vertical
    
    ctypedef enum ImGuiLogType:
        ImGuiLogType_None
        ImGuiLogType_TTY
        ImGuiLogType_File
        ImGuiLogType_Buffer
        ImGuiLogType_Clipboard
    
    # X/Y enums are fixed to 0/1 so they may be used to index ImVec2
    ctypedef enum ImGuiAxis:
        ImGuiAxis_None
        ImGuiAxis_X
        ImGuiAxis_Y
    
    ctypedef enum ImGuiPlotType:
        ImGuiPlotType_Lines
        ImGuiPlotType_Histogram
    
    ctypedef enum ImGuiInputSource:
        ImGuiInputSource_None
        ImGuiInputSource_Mouse
        ImGuiInputSource_Keyboard
        ImGuiInputSource_Gamepad
        ImGuiInputSource_Nav            # Stored in g.ActiveIdSource only
        ImGuiInputSource_COUNT
    
    # FIXME-NAV: Clarify/expose various repeat delay/rate
    ctypedef enum ImGuiInputReadMode:
        ImGuiInputReadMode_Down
        ImGuiInputReadMode_Pressed
        ImGuiInputReadMode_Released
        ImGuiInputReadMode_Repeat
        ImGuiInputReadMode_RepeatSlow
        ImGuiInputReadMode_RepeatFast
    
    ctypedef enum ImGuiNavHighlightFlags_:
        ImGuiNavHighlightFlags_None         
        ImGuiNavHighlightFlags_TypeDefault  
        ImGuiNavHighlightFlags_TypeThin     
        ImGuiNavHighlightFlags_AlwaysDraw   # Draw rectangular highlight if (g.NavId == id) _even_ when using the mouse.
        ImGuiNavHighlightFlags_NoRounding   
    
    ctypedef enum ImGuiNavDirSourceFlags_:
        ImGuiNavDirSourceFlags_None      
        ImGuiNavDirSourceFlags_Keyboard  
        ImGuiNavDirSourceFlags_PadDPad   
        ImGuiNavDirSourceFlags_PadLStick 
    
    ctypedef enum ImGuiNavMoveFlags_:
        ImGuiNavMoveFlags_None                  #
        ImGuiNavMoveFlags_LoopX                 # On failed request, restart from opposite side
        ImGuiNavMoveFlags_LoopY                 #
        ImGuiNavMoveFlags_WrapX                 # On failed request, request from opposite side one line down (when NavDir==right) or one line up (when NavDir==left)
        ImGuiNavMoveFlags_WrapY                 # This is not super useful for provided for completeness
        ImGuiNavMoveFlags_AllowCurrentNavId     # Allow scoring and considering the current NavId as a move target candidate. This is used when the move source is offset (e.g. pressing PageDown actually needs to send a Up move request, if we are pressing PageDown from the bottom-most item we need to stay in place)
        ImGuiNavMoveFlags_AlsoScoreVisibleSet   # Store alternate result in NavMoveResultLocalVisibleSet that only comprise elements that are already fully visible.
        ImGuiNavMoveFlags_ScrollToEdge          #
    
    ctypedef enum ImGuiNavForward:
        ImGuiNavForward_None
        ImGuiNavForward_ForwardQueued
        ImGuiNavForward_ForwardActive
    
    ctypedef enum ImGuiNavLayer:
        ImGuiNavLayer_Main  # Main scrolling layer
        ImGuiNavLayer_Menu  # Menu layer (access with Alt/ImGuiNavInput_Menu)
        ImGuiNavLayer_COUNT
    
    ctypedef enum ImGuiPopupPositionPolicy:
        ImGuiPopupPositionPolicy_Default
        ImGuiPopupPositionPolicy_ComboBox
        ImGuiPopupPositionPolicy_Tooltip
    
    ctypedef enum ImGuiNextWindowDataFlags_:
        ImGuiNextWindowDataFlags_None               
        ImGuiNextWindowDataFlags_HasPos             
        ImGuiNextWindowDataFlags_HasSize            
        ImGuiNextWindowDataFlags_HasContentSize     
        ImGuiNextWindowDataFlags_HasCollapsed       
        ImGuiNextWindowDataFlags_HasSizeConstraint  
        ImGuiNextWindowDataFlags_HasFocus           
        ImGuiNextWindowDataFlags_HasBgAlpha         
        ImGuiNextWindowDataFlags_HasScroll          
    
    ctypedef enum ImGuiNextItemDataFlags_:
        ImGuiNextItemDataFlags_None     
        ImGuiNextItemDataFlags_HasWidth 
        ImGuiNextItemDataFlags_HasOpen  
    
    ctypedef enum ImGuiOldColumnFlags_:
        # Default: 0
        ImGuiOldColumnFlags_None                   #
        ImGuiOldColumnFlags_NoBorder               # Disable column dividers
        ImGuiOldColumnFlags_NoResize               # Disable resizing columns when clicking on the dividers
        ImGuiOldColumnFlags_NoPreserveWidths       # Disable column width preservation when adjusting columns
        ImGuiOldColumnFlags_NoForceWithinWindow    # Disable forcing columns to fit within window
        ImGuiOldColumnFlags_GrowParentContentsSize # (WIP) Restore pre-1.51 behavior of extending the parent window contents size but _without affecting the columns width at all_. Will eventually remove.
    
    ctypedef enum ImGuiContextHookType:
        ImGuiContextHookType_NewFramePre 
        ImGuiContextHookType_NewFramePost 
        ImGuiContextHookType_EndFramePre 
        ImGuiContextHookType_EndFramePost 
        ImGuiContextHookType_RenderPre 
        ImGuiContextHookType_RenderPost 
        ImGuiContextHookType_Shutdown

    
    ctypedef enum ImGuiTabBarFlagsPrivate_:
        ImGuiTabBarFlags_DockNode                   # Part of a dock node [we don't use this in the master branch but it facilitate branch syncing to keep this around]
        ImGuiTabBarFlags_IsFocused                  #
        ImGuiTabBarFlags_SaveSettings               # FIXME: Settings are handled by the docking system, this only request the tab bar to mark settings dirty when reordering tabs
        
    ctypedef enum ImGuiTabItemFlagsPrivate_:
        ImGuiTabItemFlags_NoCloseButton             # Track whether p_open was set or not (we'll need this info on the next frame to recompute ContentWidth during layout)
        ImGuiTabItemFlags_Button                    # Used by TabItemButton, change the tab item behavior to mimic a button
        
        
        