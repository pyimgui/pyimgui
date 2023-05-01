#-----------------------------------------------------------------------------
# [SECTION] Commentary
#-----------------------------------------------------------------------------

# Nothing to be mapped here

#-----------------------------------------------------------------------------
# Typical tables call flow: (root level is generally public API):
#-----------------------------------------------------------------------------
# - BeginTable()                               user begin into a table
#    | BeginChild()                            - (if ScrollX/ScrollY is set)
#    | TableBeginInitMemory()                  - first time table is used
#    | TableResetSettings()                    - on settings reset
#    | TableLoadSettings()                     - on settings load
#    | TableBeginApplyRequests()               - apply queued resizing/reordering/hiding requests
#    | - TableSetColumnWidth()                 - apply resizing width (for mouse resize, often requested by previous frame)
#    |    - TableUpdateColumnsWeightFromWidth()- recompute columns weights (of stretch columns) from their respective width
# - TableSetupColumn()                         user submit columns details (optional)
# - TableSetupScrollFreeze()                   user submit scroll freeze information (optional)
#-----------------------------------------------------------------------------
# - TableUpdateLayout() [Internal]             followup to BeginTable(): setup everything: widths, columns positions, clipping rectangles. Automatically called by the FIRST call to TableNextRow() or TableHeadersRow().
#    | TableSetupDrawChannels()                - setup ImDrawList channels
#    | TableUpdateBorders()                    - detect hovering columns for resize, ahead of contents submission
#    | TableDrawContextMenu()                  - draw right-click context menu
#-----------------------------------------------------------------------------
# - TableHeadersRow() or TableHeader()         user submit a headers row (optional)
#    | TableSortSpecsClickColumn()             - when left-clicked: alter sort order and sort direction
#    | TableOpenContextMenu()                  - when right-clicked: trigger opening of the default context menu
# - TableGetSortSpecs()                        user queries updated sort specs (optional, generally after submitting headers)
# - TableNextRow()                             user begin into a new row (also automatically called by TableHeadersRow())
#    | TableEndRow()                           - finish existing row
#    | TableBeginRow()                         - add a new row
# - TableSetColumnIndex() / TableNextColumn()  user begin into a cell
#    | TableEndCell()                          - close existing column/cell
#    | TableBeginCell()                        - enter into current column/cell
# - [...]                                      user emit contents
#-----------------------------------------------------------------------------
# - EndTable()                                 user ends the table
#    | TableDrawBorders()                      - draw outer borders, inner vertical borders
#    | TableMergeDrawChannels()                - merge draw channels if clipping isn't required
#    | EndChild()                              - (if ScrollX/ScrollY is set)
#-----------------------------------------------------------------------------

# Nothing to be mapped here

#-----------------------------------------------------------------------------
# TABLE SIZING
#-----------------------------------------------------------------------------
# (Read carefully because this is subtle but it does make sense!)
#-----------------------------------------------------------------------------
# About 'outer_size':
# Its meaning needs to differ slightly depending of if we are using ScrollX/ScrollY flags.
# Default value is ImVec2(0.0f, 0.0f).
#   X
#   - outer_size.x <= 0.0f  ->  Right-align from window/work-rect right-most edge. With -FLT_MIN or 0.0f will align exactly on right-most edge.
#   - outer_size.x  > 0.0f  ->  Set Fixed width.
#   Y with ScrollX/ScrollY disabled: we output table directly in current window
#   - outer_size.y  < 0.0f  ->  Bottom-align (but will auto extend, unless _NoHostExtendY is set). Not meaningful is parent window can vertically scroll.
#   - outer_size.y  = 0.0f  ->  No minimum height (but will auto extend, unless _NoHostExtendY is set)
#   - outer_size.y  > 0.0f  ->  Set Minimum height (but will auto extend, unless _NoHostExtenY is set)
#   Y with ScrollX/ScrollY enabled: using a child window for scrolling
#   - outer_size.y  < 0.0f  ->  Bottom-align. Not meaningful is parent window can vertically scroll.
#   - outer_size.y  = 0.0f  ->  Bottom-align, consistent with BeginChild(). Not recommended unless table is last item in parent window.
#   - outer_size.y  > 0.0f  ->  Set Exact height. Recommended when using Scrolling on any axis.
#-----------------------------------------------------------------------------
# Outer size is also affected by the NoHostExtendX/NoHostExtendY flags.
# Important to that note how the two flags have slightly different behaviors!
#   - ImGuiTableFlags_NoHostExtendX -> Make outer width auto-fit to columns (overriding outer_size.x value). Only available when ScrollX/ScrollY are disabled and Stretch columns are not used.
#   - ImGuiTableFlags_NoHostExtendY -> Make outer height stop exactly at outer_size.y (prevent auto-extending table past the limit). Only available when ScrollX/ScrollY are disabled. Data below the limit will be clipped and not visible.
# In theory ImGuiTableFlags_NoHostExtendY could be the default and any non-scrolling tables with outer_size.y != 0.0f would use exact height.
# This would be consistent but perhaps less useful and more confusing (as vertically clipped items are not easily noticeable)
#-----------------------------------------------------------------------------
# About 'inner_width':
#   With ScrollX disabled:
#   - inner_width          ->  *ignored*
#   With ScrollX enabled:
#   - inner_width  < 0.0f  ->  *illegal* fit in known width (right align from outer_size.x) <-- weird
#   - inner_width  = 0.0f  ->  fit in outer_width: Fixed size columns will take space they need (if avail, otherwise shrink down), Stretch columns becomes Fixed columns.
#   - inner_width  > 0.0f  ->  override scrolling width, generally to be larger than outer_size.x. Fixed column take space they need (if avail, otherwise shrink down), Stretch columns share remaining space!
#-----------------------------------------------------------------------------
# Details:
# - If you want to use Stretch columns with ScrollX, you generally need to specify 'inner_width' otherwise the concept
#   of "available space" doesn't make sense.
# - Even if not really useful, we allow 'inner_width < outer_size.x' for consistency and to facilitate understanding
#   of what the value does.
#-----------------------------------------------------------------------------

# Nothing to be mapped here

#-----------------------------------------------------------------------------
# COLUMNS SIZING POLICIES
#-----------------------------------------------------------------------------
# About overriding column sizing policy and width/weight with TableSetupColumn():
# We use a default parameter of 'init_width_or_weight == -1'.
#   - with ImGuiTableColumnFlags_WidthFixed,    init_width  <= 0 (default)  --> width is automatic
#   - with ImGuiTableColumnFlags_WidthFixed,    init_width  >  0 (explicit) --> width is custom
#   - with ImGuiTableColumnFlags_WidthStretch,  init_weight <= 0 (default)  --> weight is 1.0f
#   - with ImGuiTableColumnFlags_WidthStretch,  init_weight >  0 (explicit) --> weight is custom
# Widths are specified _without_ CellPadding. If you specify a width of 100.0f, the column will be cover (100.0f + Padding * 2.0f)
# and you can fit a 100.0f wide item in it without clipping and with full padding.
#-----------------------------------------------------------------------------
# About default sizing policy (if you don't specify a ImGuiTableColumnFlags_WidthXXXX flag)
#   - with Table policy ImGuiTableFlags_SizingFixedFit      --> default Column policy is ImGuiTableColumnFlags_WidthFixed, default Width is equal to contents width
#   - with Table policy ImGuiTableFlags_SizingFixedSame     --> default Column policy is ImGuiTableColumnFlags_WidthFixed, default Width is max of all contents width
#   - with Table policy ImGuiTableFlags_SizingStretchSame   --> default Column policy is ImGuiTableColumnFlags_WidthStretch, default Weight is 1.0f
#   - with Table policy ImGuiTableFlags_SizingStretchWeight --> default Column policy is ImGuiTableColumnFlags_WidthStretch, default Weight is proportional to contents
# Default Width and default Weight can be overridden when calling TableSetupColumn().
#-----------------------------------------------------------------------------
# About mixing Fixed/Auto and Stretch columns together:
#   - the typical use of mixing sizing policies is: any number of LEADING Fixed columns, followed by one or two TRAILING Stretch columns.
#   - using mixed policies with ScrollX does not make much sense, as using Stretch columns with ScrollX does not make much sense in the first place!
#     that is, unless 'inner_width' is passed to BeginTable() to explicitly provide a total width to layout columns in.
#   - when using ImGuiTableFlags_SizingFixedSame with mixed columns, only the Fixed/Auto columns will match their widths to the maximum contents width.
#   - when using ImGuiTableFlags_SizingStretchSame with mixed columns, only the Stretch columns will match their weight/widths.
#-----------------------------------------------------------------------------
# About using column width:
# If a column is manual resizable or has a width specified with TableSetupColumn():
#   - you may use GetContentRegionAvail().x to query the width available in a given column.
#   - right-side alignment features such as SetNextItemWidth(-x) or PushItemWidth(-x) will rely on this width.
# If the column is not resizable and has no width specified with TableSetupColumn():
#   - its width will be automatic and be the set to the max of items submitted.
#   - therefore you generally cannot have ALL items of the columns use e.g. SetNextItemWidth(-FLT_MIN).
#   - but if the column has one or more item of known/fixed size, this will become the reference width used by SetNextItemWidth(-FLT_MIN).
#-----------------------------------------------------------------------------

# Nothing to be mapped here

#-----------------------------------------------------------------------------
# TABLES CLIPPING/CULLING
#-----------------------------------------------------------------------------
# About clipping/culling of Rows in Tables:
# - For large numbers of rows, it is recommended you use ImGuiListClipper to only submit visible rows.
#   ImGuiListClipper is reliant on the fact that rows are of equal height.
#   See 'Demo->Tables->Vertical Scrolling' or 'Demo->Tables->Advanced' for a demo of using the clipper.
# - Note that auto-resizing columns don't play well with using the clipper.
#   By default a table with _ScrollX but without _Resizable will have column auto-resize.
#   So, if you want to use the clipper, make sure to either enable _Resizable, either setup columns width explicitly with _WidthFixed.
#-----------------------------------------------------------------------------
# About clipping/culling of Columns in Tables:
# - Both TableSetColumnIndex() and TableNextColumn() return true when the column is visible or performing
#   width measurements. Otherwise, you may skip submitting the contents of a cell/column, BUT ONLY if you know
#   it is not going to contribute to row height.
#   In many situations, you may skip submitting contents for every columns but one (e.g. the first one).
# - Case A: column is not hidden by user, and at least partially in sight (most common case).
# - Case B: column is clipped / out of sight (because of scrolling or parent ClipRect): TableNextColumn() return false as a hint but we still allow layout output.
# - Case C: column is hidden explicitly by the user (e.g. via the context menu, or _DefaultHide column flag, etc.).
#
#                        [A]         [B]          [C]
#  TableNextColumn():    true        false        false       -> [userland] when TableNextColumn() / TableSetColumnIndex() return false, user can skip submitting items but only if the column doesn't contribute to row height.
#          SkipItems:    false       false        true        -> [internal] when SkipItems is true, most widgets will early out if submitted, resulting is no layout output.
#           ClipRect:    normal      zero-width   zero-width  -> [internal] when ClipRect is zero, ItemAdd() will return false and most widgets will early out mid-way.
#  ImDrawList output:    normal      dummy        dummy       -> [internal] when using the dummy channel, ImDrawList submissions (if any) will be wasted (because cliprect is zero-width anyway).
#
# - We need distinguish those cases because non-hidden columns that are clipped outside of scrolling bounds should still contribute their height to the row.
#   However, in the majority of cases, the contribution to row height is the same for all columns, or the tallest cells are known by the programmer.
#-----------------------------------------------------------------------------
# About clipping/culling of whole Tables:
# - Scrolling tables with a known outer size can be clipped earlier as BeginTable() will return false.
#-----------------------------------------------------------------------------

# Nothing to be mapped here

#-----------------------------------------------------------------------------
# [SECTION] Header mess
#-----------------------------------------------------------------------------

# Nothing to be mapped here

#-----------------------------------------------------------------------------
# [SECTION] Tables: Main code
#-----------------------------------------------------------------------------

cdef class _BeginEndTable(object):
    """
    Return value of :func:`begin_table` exposing ``opened`` boolean attribute.
    See :func:`begin_table` for an explanation and examples.

    Can be used as a context manager (in a ``with`` statement) to automatically call :func:`end_table`
    (if necessary) to end the table created with :func:`begin_table` when the block ends,
    even if an exception is raised.

    This class is not intended to be instantiated by the user (thus the `_` name prefix).
    It should be obtained as the return value of the :func:`begin_table` function.
    """

    cdef readonly bool opened

    def __cinit__(self, bool opened):
        self.opened = opened

    def __enter__(self):
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        if self.opened:
            cimgui.EndTable()

    def __bool__(self):
        """For legacy support, returns ``opened``."""
        return self.opened

    def __repr__(self):
        return "{}(opened={})".format(
            self.__class__.__name__, self.opened
        )

    def __eq__(self, other):
        if other.__class__ is self.__class__:
            return self.opened is other.opened
        return self.opened is other

def begin_table(
    str label,
    int column,
    cimgui.ImGuiTableFlags flags = 0,
    float outer_size_width = 0.0,
    float outer_size_height = 0.0,
    float inner_width = 0.0
    ):
    """

    Returns:
        _BeginEndPopup: Use ``opened`` bool attribute to tell if the table is opened.
        Only call :func:`end_table` if ``opened`` is True.
        Use with ``with`` to automatically call :func:`end_table` if necessary when the block ends.

    .. wraps::
        bool BeginTable(
            const char* str_id,
            int column,
            ImGuiTableFlags flags = 0,
            const ImVec2& outer_size = ImVec2(0.0f, 0.0f),
            float inner_width = 0.0f
        )
    """
    return _BeginEndTable.__new__(
        _BeginEndTable,
        cimgui.BeginTable(
            _bytes(label),
            column,
            flags,
            _cast_args_ImVec2(outer_size_width, outer_size_height),
            inner_width
        )
    )

def end_table():
    """
    End a previously opened table.
    Only call this function if ``begin_table().opened`` is True.

    .. wraps::
        void EndTable()
    """
    cimgui.EndTable()

def table_setup_column(
        str label,
        cimgui.ImGuiTableColumnFlags flags = 0,
        float init_width_or_weight = 0.0,
        cimgui.ImU32 user_id = 0
    ):
    """

    .. wraps::
        void TableSetupColumn(
            const char* label,
            ImGuiTableColumnFlags flags = 0,
            float init_width_or_weight = 0.0f,
            ImU32 user_id  = 0
        )
    """
    cimgui.TableSetupColumn(
        _bytes(label),
        flags,
        init_width_or_weight,
        user_id)

def table_setup_scroll_freeze(int cols, int rows):
    """

    .. wraps::
        void TableSetupScrollFreeze(int cols, int rows)
    """
    cimgui.TableSetupScrollFreeze(cols, rows)

def table_get_column_count():
    """

    .. wraps::
        int TableGetColumnCount()
    """
    return cimgui.TableGetColumnCount()

def table_get_column_name(int column_n = -1):
    """

    .. wraps::
        const char* TableGetColumnName(
            int column_n  = -1
        )
    """
    return _from_bytes(cimgui.TableGetColumnName(column_n))

def table_get_column_flags(int column_n = -1):
    """

    .. wraps::
        ImGuiTableColumnFlags TableGetColumnFlags(
            int column_n = -1
        )
    """
    return cimgui.TableGetColumnFlags(column_n)

def table_set_background_color(
        cimgui.ImGuiTableBgTarget target,
        cimgui.ImU32 color,
        int column_n = -1
    ):
    """

    .. wraps::
        void TableSetBgColor(
            ImGuiTableBgTarget target,
            ImU32 color,
            int column_n  = -1
        )
    """
    cimgui.TableSetBgColor(target, color, column_n)

#-------------------------------------------------------------------------
# [SECTION] Tables: Row changes
#-------------------------------------------------------------------------
# - TableGetRowIndex()
# - TableNextRow()
# - TableBeginRow() [Internal]
# - TableEndRow() [Internal]
#-------------------------------------------------------------------------

def table_get_row_index():
    """

    .. wraps::
        int TableGetRowIndex()
    """
    return cimgui.TableGetRowIndex()

def table_next_row(
        cimgui.ImGuiTableRowFlags row_flags = 0,
        float min_row_height = 0.0
    ):
    """

    .. wraps::
        void TableNextRow(
            ImGuiTableRowFlags row_flags = 0,
            float min_row_height = 0.0f
        )
    """
    cimgui.TableNextRow(row_flags, min_row_height)

#-------------------------------------------------------------------------
# [SECTION] Tables: Columns changes
#-------------------------------------------------------------------------
# - TableGetColumnIndex()
# - TableSetColumnIndex()
# - TableNextColumn()
# - TableBeginCell() [Internal]
# - TableEndCell() [Internal]
#-------------------------------------------------------------------------

def table_get_column_index():
    """

    .. wraps::
        int TableGetColumnIndex()
    """
    return cimgui.TableGetColumnIndex()

def table_set_column_index(int column_n):
    """

    .. wraps::
        bool TableSetColumnIndex(int column_n)
    """
    return cimgui.TableSetColumnIndex(column_n)

def table_next_column():
    """

    .. wraps::
        bool TableNextColumn()
    """
    return cimgui.TableNextColumn()

#-------------------------------------------------------------------------
# [SECTION] Tables: Columns width management
#-------------------------------------------------------------------------
# - TableGetMaxColumnWidth() [Internal]
# - TableGetColumnWidthAuto() [Internal]
# - TableSetColumnWidth()
# - TableSetColumnWidthAutoSingle() [Internal]
# - TableSetColumnWidthAutoAll() [Internal]
# - TableUpdateColumnsWeightFromWidth() [Internal]
#-------------------------------------------------------------------------

# Nothing to be mapped here

#-------------------------------------------------------------------------
# [SECTION] Tables: Drawing
#-------------------------------------------------------------------------
# - TablePushBackgroundChannel() [Internal]
# - TablePopBackgroundChannel() [Internal]
# - TableSetupDrawChannels() [Internal]
# - TableMergeDrawChannels() [Internal]
# - TableDrawBorders() [Internal]
#-------------------------------------------------------------------------

# Nothing to be mapped here

#-------------------------------------------------------------------------
# [SECTION] Tables: Sorting
#-------------------------------------------------------------------------
# - TableGetSortSpecs()
# - TableFixColumnSortDirection() [Internal]
# - TableGetColumnNextSortDirection() [Internal]
# - TableSetColumnSortDirection() [Internal]
# - TableSortSpecsSanitize() [Internal]
# - TableSortSpecsBuild() [Internal]
#-------------------------------------------------------------------------

cdef class _ImGuiTableColumnSortSpecs(object):
    cdef cimgui.ImGuiTableColumnSortSpecs* _ptr

    def __init__(self):
        pass

    def _require_pointer(self):
        if self._ptr == NULL:
            raise RuntimeError(
                "%s improperly initialized" % self.__class__.__name__
            )

    @staticmethod
    cdef from_ptr(cimgui.ImGuiTableColumnSortSpecs* ptr):
        if ptr == NULL:
            return None
        instance = _ImGuiTableColumnSortSpecs()
        instance._ptr = ptr
        return instance
    
    @property
    def column_user_id(self):
        self._require_pointer()
        return self._ptr.ColumnUserID
    
    @column_user_id.setter
    def column_user_id(self, cimgui.ImGuiID column_user_id):
        self._require_pointer()
        self._ptr.ColumnUserID = column_user_id
    
    @property
    def column_index(self):
        self._require_pointer()
        return self._ptr.ColumnIndex
    
    @column_index.setter
    def column_index(self, cimgui.ImS16 column_index):
        self._require_pointer()
        self._ptr.ColumnIndex = column_index
    
    @property
    def sort_order(self):
        self._require_pointer()
        return self._ptr.SortOrder
    
    @sort_order.setter
    def sort_order(self, cimgui.ImS16 sort_order):
        self._require_pointer()
        self._ptr.SortOrder = sort_order
    
    @property
    def sort_direction(self):
        self._require_pointer()
        return self._ptr.SortDirection
    
    @sort_direction.setter
    def sort_direction(self, cimgui.ImGuiSortDirection sort_direction):
        self._require_pointer()
        self._ptr.SortDirection = sort_direction
    
cdef class _ImGuiTableColumnSortSpecs_array(object):
    
    cdef cimgui.ImGuiTableSortSpecs* _ptr
    cdef size_t idx
    
    def __init__(self):
        self.idx = 0
        pass

    def _require_pointer(self):
        if self._ptr == NULL:
            raise RuntimeError(
                "%s improperly initialized" % self.__class__.__name__
            )

    @staticmethod
    cdef from_ptr(cimgui.ImGuiTableSortSpecs* ptr):
        if ptr == NULL:
            return None
        instance = _ImGuiTableColumnSortSpecs_array()
        instance._ptr = ptr
        return instance
    
    cdef _get_item(self, size_t idx):
        self._require_pointer()
        if idx >= self._ptr.SpecsCount:
            raise ValueError("Out of bound access to idx %i of an array of size %i" % (idx, self._ptr.SpecsCount))
        cdef size_t offset = idx*sizeof(cimgui.ImGuiTableColumnSortSpecs)
        cdef size_t pointer = <size_t>self._ptr.Specs + offset
        return _ImGuiTableColumnSortSpecs.from_ptr(<cimgui.ImGuiTableColumnSortSpecs *>pointer)
    
    def __getitem__(self, idx):
        return self._get_item(idx)
    
    def __iter__(self):
        self.idx = 0
        return self
        
    def __next__(self):
        if self.idx < self._ptr.SpecsCount:
            item = self._get_item(self.idx)
            self.idx += 1
            return item
        else:
            raise StopIteration
    
    #def __setitem__(self, idx):
    #    self._table_sort_specs._require_pointer()

cdef class _ImGuiTableSortSpecs(object):
    cdef cimgui.ImGuiTableSortSpecs* _ptr
    cdef _ImGuiTableColumnSortSpecs_array specs
    
    def __init__(self):
        #self.specs = _ImGuiTableColumnSortSpecs_array(self)
        pass

    def _require_pointer(self):
        if self._ptr == NULL:
            raise RuntimeError(
                "%s improperly initialized" % self.__class__.__name__
            )

    @staticmethod
    cdef from_ptr(cimgui.ImGuiTableSortSpecs* ptr):
        if ptr == NULL:
            return None
        instance = _ImGuiTableSortSpecs()
        instance._ptr = ptr
        instance.specs = _ImGuiTableColumnSortSpecs_array.from_ptr(ptr)
        return instance
    
    @property
    def specs(self):
        return self.specs
    
    @property
    def specs_count(self):
        self._require_pointer()
        return self._ptr.SpecsCount
    
    @property
    def specs_dirty(self):
        self._require_pointer()
        return self._ptr.SpecsDirty
    
    @specs_dirty.setter
    def specs_dirty(self, cimgui.bool specs_dirty):
        self._require_pointer()
        self._ptr.SpecsDirty = specs_dirty

def table_get_sort_specs():
    """

    .. wraps::
        ImGuiTableSortSpecs* TableGetSortSpecs()
    """
    cdef cimgui.ImGuiTableSortSpecs* imgui_sort_spec = cimgui.TableGetSortSpecs()
    if imgui_sort_spec == NULL:
        return None
    else:
        return _ImGuiTableSortSpecs.from_ptr(imgui_sort_spec)

#-------------------------------------------------------------------------
# [SECTION] Tables: Headers
#-------------------------------------------------------------------------
# - TableGetHeaderRowHeight() [Internal]
# - TableHeadersRow()
# - TableHeader()
#-------------------------------------------------------------------------

def table_headers_row():
    """

    .. wraps::
        void TableHeadersRow()
    """
    cimgui.TableHeadersRow()

def table_header(str label):
    """

    .. wraps::
        void TableHeader(const char* label)
    """
    cimgui.TableHeader(_bytes(label))

#-------------------------------------------------------------------------
# [SECTION] Tables: Context Menu
#-------------------------------------------------------------------------
# - TableOpenContextMenu() [Internal]
# - TableDrawContextMenu() [Internal]
#-------------------------------------------------------------------------

# Nothing to be mapped here

#-------------------------------------------------------------------------
# [SECTION] Tables: Settings (.ini data)
#-------------------------------------------------------------------------
# FIXME: The binding/finding/creating flow are too confusing.
#-------------------------------------------------------------------------
# - TableSettingsInit() [Internal]
# - TableSettingsCalcChunkSize() [Internal]
# - TableSettingsCreate() [Internal]
# - TableSettingsFindByID() [Internal]
# - TableGetBoundSettings() [Internal]
# - TableResetSettings()
# - TableSaveSettings() [Internal]
# - TableLoadSettings() [Internal]
# - TableSettingsHandler_ClearAll() [Internal]
# - TableSettingsHandler_ApplyAll() [Internal]
# - TableSettingsHandler_ReadOpen() [Internal]
# - TableSettingsHandler_ReadLine() [Internal]
# - TableSettingsHandler_WriteAll() [Internal]
# - TableSettingsInstallHandler() [Internal]
#-------------------------------------------------------------------------
# [Init] 1: TableSettingsHandler_ReadXXXX()   Load and parse .ini file into TableSettings.
# [Main] 2: TableLoadSettings()               When table is created, bind Table to TableSettings, serialize TableSettings data into Table.
# [Main] 3: TableSaveSettings()               When table properties are modified, serialize Table data into bound or new TableSettings, mark .ini as dirty.
# [Main] 4: TableSettingsHandler_WriteAll()   When .ini file is dirty (which can come from other source), save TableSettings into .ini file.
#-------------------------------------------------------------------------

# Nothing to be mapped here

#-------------------------------------------------------------------------
# [SECTION] Tables: Garbage Collection
#-------------------------------------------------------------------------
# - TableRemove() [Internal]
# - TableGcCompactTransientBuffers() [Internal]
# - TableGcCompactSettings() [Internal]
#-------------------------------------------------------------------------

# Nothing to be mapped here

#-------------------------------------------------------------------------
# [SECTION] Tables: Debugging
#-------------------------------------------------------------------------
# - DebugNodeTable() [Internal]
#-------------------------------------------------------------------------

# Nothing to be mapped here

#-------------------------------------------------------------------------
# [SECTION] Columns, BeginColumns, EndColumns, etc.
# (This is a legacy API, prefer using BeginTable/EndTable!)
#-------------------------------------------------------------------------
# FIXME: sizing is lossy when columns width is very small (default width may turn negative etc.)
#-------------------------------------------------------------------------
# - SetWindowClipRectBeforeSetChannel() [Internal]
# - GetColumnIndex()
# - GetColumnsCount()
# - GetColumnOffset()
# - GetColumnWidth()
# - SetColumnOffset()
# - SetColumnWidth()
# - PushColumnClipRect() [Internal]
# - PushColumnsBackground() [Internal]
# - PopColumnsBackground() [Internal]
# - FindOrCreateColumns() [Internal]
# - GetColumnsID() [Internal]
# - BeginColumns()
# - NextColumn()
# - EndColumns()
# - Columns()
#-------------------------------------------------------------------------

def get_column_index():
    """Returns the current column index.

    For a complete example see :func:`columns()`.

    Legacy Columns API (2020: prefer using Tables!)

    Returns:
        int: the current column index.

    .. wraps::
        int GetColumnIndex()
    """
    return cimgui.GetColumnIndex()

def get_columns_count():
    """Get count of the columns in the current table.

    For a complete example see :func:`columns()`.

    Legacy Columns API (2020: prefer using Tables!)

    Returns:
        int: columns count.

    .. wraps::
        int GetColumnsCount()
    """
    return cimgui.GetColumnsCount()

def get_column_offset(int column_index=-1):
    """Returns position of column line (in pixels, from the left side of the
    contents region). Pass -1 to use current column, otherwise 0 to
    :func:`get_columns_count()`. Column 0 is usually 0.0f and not resizable
    unless you call this method.

    For a complete example see :func:`columns()`.

    Legacy Columns API (2020: prefer using Tables!)

    Args:
        column_index (int): index of the column to get the offset for.

    Returns:
        float: the position in pixels from the left side.

    .. wraps::
        float GetColumnOffset(int column_index = -1)
    """
    return cimgui.GetColumnOffset(column_index)

def get_column_width(int column_index=-1):
    """Return the column width.

    For a complete example see :func:`columns()`.

    Legacy Columns API (2020: prefer using Tables!)

    Args:
        column_index (int): index of the column to get the width for.

    .. wraps::
        float GetColumnWidth(int column_index = -1)
    """
    return cimgui.GetColumnWidth(column_index)

def set_column_offset(int column_index, float offset_x):
    """Set the position of column line (in pixels, from the left side of the
    contents region). Pass -1 to use current column.

    For a complete example see :func:`columns()`.

    Legacy Columns API (2020: prefer using Tables!)

    Args:
        column_index (int): index of the column to get the offset for.
        offset_x (float): offset in pixels.

    .. wraps::
        void SetColumnOffset(int column_index, float offset_x)
    """
    cimgui.SetColumnOffset(column_index, offset_x)

def set_column_width(int column_index, float width):
    """Set the position of column line (in pixels, from the left side of the
    contents region). Pass -1 to use current column.

    For a complete example see :func:`columns()`.

    Legacy Columns API (2020: prefer using Tables!)

    Args:
        column_index (int): index of the column to set the width for.
        width (float): width in pixels.

    .. wraps::
        void SetColumnWidth(int column_index, float width)
    """
    cimgui.SetColumnWidth(column_index, width)

def next_column():
    """Move to the next column drawing.

    For a complete example see :func:`columns()`.

    Legacy Columns API (2020: prefer using Tables!)

    .. wraps::
        void NextColumn()
    """
    cimgui.NextColumn()

def columns(int count=1, str identifier=None, bool border=True):
    """Setup number of columns. Use an identifier to distinguish multiple
    column sets. close with ``columns(1)``.

    Legacy Columns API (2020: prefer using Tables!)

    .. visual-example::
        :auto_layout:
        :width: 500
        :height: 300

        imgui.begin("Example: Columns - File list")
        imgui.columns(4, 'fileLlist')
        imgui.separator()
        imgui.text("ID")
        imgui.next_column()
        imgui.text("File")
        imgui.next_column()
        imgui.text("Size")
        imgui.next_column()
        imgui.text("Last Modified")
        imgui.next_column()
        imgui.separator()
        imgui.set_column_offset(1, 40)

        imgui.next_column()
        imgui.text('FileA.txt')
        imgui.next_column()
        imgui.text('57 Kb')
        imgui.next_column()
        imgui.text('12th Feb, 2016 12:19:01')
        imgui.next_column()

        imgui.next_column()
        imgui.text('ImageQ.png')
        imgui.next_column()
        imgui.text('349 Kb')
        imgui.next_column()
        imgui.text('1st Mar, 2016 06:38:22')
        imgui.next_column()

        imgui.columns(1)
        imgui.end()

    Args:
        count (int): Columns count.
        identifier (str): Table identifier.
        border (bool): Display border, defaults to ``True``.

    .. wraps::
        void Columns(
            int count = 1,
            const char* id = NULL,
            bool border = true
        )
    """
    if identifier is None:
        cimgui.Columns(count, NULL, border)
    else:
        cimgui.Columns(count, _bytes(identifier), border)

#-------------------------------------------------------------------------

# Nothing to be mapped here
