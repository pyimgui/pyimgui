#-------------------------------------------------------------------------
# Warnings
#-------------------------------------------------------------------------

# Nothing to be mapped here

#-------------------------------------------------------------------------
# Data
#-------------------------------------------------------------------------

# Nothing to be mapped here

#-------------------------------------------------------------------------
# [SECTION] Forward Declarations
#-------------------------------------------------------------------------

# Nothing to be mapped here

#-------------------------------------------------------------------------
# [SECTION] Widgets: Text, etc.
#-------------------------------------------------------------------------
# - TextEx() [Internal]
# - TextUnformatted()
# - Text()
# - TextV()
# - TextColored()
# - TextColoredV()
# - TextDisabled()
# - TextDisabledV()
# - TextWrapped()
# - TextWrappedV()
# - LabelText()
# - LabelTextV()
# - BulletText()
# - BulletTextV()
#-------------------------------------------------------------------------

def text_unformatted(str text):
    """Big area text display - the size is defined by it's container.
    Recommended for long chunks of text.

    .. visual-example::
        :title: simple text widget
        :height: 100
        :width: 200
        :auto_layout:

        imgui.begin("Example: unformatted text")
        imgui.text_unformatted("Really ... long ... text")
        imgui.end()

    Args:
        text (str): text to display.

    .. wraps::
        TextUnformatted(const char* text, const char* text_end = NULL)
    """
    cimgui.TextUnformatted(_bytes(text))

def text(str text):
    """Add text to current widget stack.

    .. visual-example::
        :title: simple text widget
        :height: 80
        :auto_layout:

        imgui.begin("Example: simple text")
        imgui.text("Simple text")
        imgui.end()

    Args:
        text (str): text to display.

    .. wraps::
        Text(const char* fmt, ...)
    """
    # note: "%s" required for safety and to favor of Python string formating
    cimgui.Text("%s", _bytes(text))

def text_colored(str text, float r, float g, float b, float a=1.):
    """Add colored text to current widget stack.

    It is a shortcut for:

    .. code-block:: python

        imgui.push_style_color(imgui.COLOR_TEXT, r, g, b, a)
        imgui.text(text)
        imgui.pop_style_color()


    .. visual-example::
        :title: colored text widget
        :height: 100
        :auto_layout:

        imgui.begin("Example: colored text")
        imgui.text_colored("Colored text", 1, 0, 0)
        imgui.end()

    Args:
        text (str): text to display.
        r (float): red color intensity.
        g (float): green color intensity.
        b (float): blue color instensity.
        a (float): alpha intensity.

    .. wraps::
        TextColored(const ImVec4& col, const char* fmt, ...)
    """
    # note: "%s" required for safety and to favor of Python string formating
    cimgui.TextColored(_cast_args_ImVec4(r, g, b, a), "%s", _bytes(text))

def text_disabled(str text):
    """Add disabled(grayed out) text to current widget stack.

    .. visual-example::
        :title: disabled text widget
        :height: 80
        :auto_layout:

        imgui.begin("Example: disabled text")
        imgui.text_disabled("Disabled text")
        imgui.end()

    Args:
        text (str): text to display.

    .. wraps::
        TextDisabled(const char*, ...)
    """
    # note: "%s" required for safety and to favor of Python string formating
    cimgui.TextDisabled("%s", _bytes(text))

def text_wrapped(str text):
    """Add wrappable text to current widget stack.

    .. visual-example::
        :title: Wrappable Text
        :height: 80
        :width: 40
        :auto_layout:

        imgui.begin("Text wrap")
        # Resize the window to see text wrapping
        imgui.text_wrapped("This text will wrap around.")
        imgui.end()

    Args:
        text (str): text to display

    .. wraps::
        TextWrapped(const char* fmt, ...)
    """
    # note: "%s" required for safety and to favor of Python string formating
    cimgui.TextWrapped("%s", _bytes(text))

def label_text(str label, str text):
    """Display text+label aligned the same way as value+label widgets.

    .. visual-example::
        :auto_layout:
        :height: 80
        :width: 300

        imgui.begin("Example: text with label")
        imgui.label_text("my label", "my text")
        imgui.end()

    Args:
        label (str): label to display.
        text (str): text to display.

    .. wraps::
        void LabelText(const char* label, const char* fmt, ...)
    """
    # note: "%s" required for safety and to favor of Python string formating
    cimgui.LabelText(_bytes(label), "%s", _bytes(text))

def bullet_text(str text):
    """Display bullet and text.

    This is shortcut for:

    .. code-block:: python

        imgui.bullet()
        imgui.text(text)

    .. visual-example::
        :auto_layout:
        :height: 100

        imgui.begin("Example: bullet text")
        imgui.bullet_text("Bullet 1")
        imgui.bullet_text("Bullet 2")
        imgui.bullet_text("Bullet 3")
        imgui.end()

    Args:
        text (str): text to display.

    .. wraps::
        void BulletText(const char* fmt, ...)
    """
    # note: "%s" required for safety and to favor of Python string formating
    cimgui.BulletText("%s", _bytes(text))

#-------------------------------------------------------------------------
# [SECTION] Widgets: Main
#-------------------------------------------------------------------------
# - ButtonBehavior() [Internal]
# - Button()
# - SmallButton()
# - InvisibleButton()
# - ArrowButton()
# - CloseButton() [Internal]
# - CollapseButton() [Internal]
# - GetWindowScrollbarID() [Internal]
# - GetWindowScrollbarRect() [Internal]
# - Scrollbar() [Internal]
# - ScrollbarEx() [Internal]
# - Image()
# - ImageButton()
# - Checkbox()
# - CheckboxFlagsT() [Internal]
# - CheckboxFlags()
# - RadioButton()
# - ProgressBar()
# - Bullet()
#-------------------------------------------------------------------------

# See after next comment

#------------------------------------------------------------------------------------------------------------------------------------------------
# with PressedOnClickRelease:             return-value  IsItemHovered()  IsItemActive()  IsItemActivated()  IsItemDeactivated()  IsItemClicked()
#   Frame N+0 (mouse is outside bb)        -             -                -               -                  -                    -
#   Frame N+1 (mouse moves inside bb)      -             true             -               -                  -                    -
#   Frame N+2 (mouse button is down)       -             true             true            true               -                    true
#   Frame N+3 (mouse button is down)       -             true             true            -                  -                    -
#   Frame N+4 (mouse moves outside bb)     -             -                true            -                  -                    -
#   Frame N+5 (mouse moves inside bb)      -             true             true            -                  -                    -
#   Frame N+6 (mouse button is released)   true          true             -               -                  true                 -
#   Frame N+7 (mouse button is released)   -             true             -               -                  -                    -
#   Frame N+8 (mouse moves outside bb)     -             -                -               -                  -                    -
#------------------------------------------------------------------------------------------------------------------------------------------------
# with PressedOnClick:                    return-value  IsItemHovered()  IsItemActive()  IsItemActivated()  IsItemDeactivated()  IsItemClicked()
#   Frame N+2 (mouse button is down)       true          true             true            true               -                    true
#   Frame N+3 (mouse button is down)       -             true             true            -                  -                    -
#   Frame N+6 (mouse button is released)   -             true             -               -                  true                 -
#   Frame N+7 (mouse button is released)   -             true             -               -                  -                    -
#------------------------------------------------------------------------------------------------------------------------------------------------
# with PressedOnRelease:                  return-value  IsItemHovered()  IsItemActive()  IsItemActivated()  IsItemDeactivated()  IsItemClicked()
#   Frame N+2 (mouse button is down)       -             true             -               -                  -                    true
#   Frame N+3 (mouse button is down)       -             true             -               -                  -                    -
#   Frame N+6 (mouse button is released)   true          true             -               -                  -                    -
#   Frame N+7 (mouse button is released)   -             true             -               -                  -                    -
#------------------------------------------------------------------------------------------------------------------------------------------------
# with PressedOnDoubleClick:              return-value  IsItemHovered()  IsItemActive()  IsItemActivated()  IsItemDeactivated()  IsItemClicked()
#   Frame N+0 (mouse button is down)       -             true             -               -                  -                    true
#   Frame N+1 (mouse button is down)       -             true             -               -                  -                    -
#   Frame N+2 (mouse button is released)   -             true             -               -                  -                    -
#   Frame N+3 (mouse button is released)   -             true             -               -                  -                    -
#   Frame N+4 (mouse button is down)       true          true             true            true               -                    true
#   Frame N+5 (mouse button is down)       -             true             true            -                  -                    -
#   Frame N+6 (mouse button is released)   -             true             -               -                  true                 -
#   Frame N+7 (mouse button is released)   -             true             -               -                  -                    -
#------------------------------------------------------------------------------------------------------------------------------------------------
# Note that some combinations are supported,
# - PressedOnDragDropHold can generally be associated with any flag.
# - PressedOnDoubleClick can be associated by PressedOnClickRelease/PressedOnRelease, in which case the second release event won't be reported.
#------------------------------------------------------------------------------------------------------------------------------------------------
# The behavior of the return-value changes when ImGuiButtonFlags_Repeat is set:
#                                         Repeat+                  Repeat+           Repeat+             Repeat+
#                                         PressedOnClickRelease    PressedOnClick    PressedOnRelease    PressedOnDoubleClick
#-------------------------------------------------------------------------------------------------------------------------------------------------
#   Frame N+0 (mouse button is down)       -                        true              -                   true
#   ...                                    -                        -                 -                   -
#   Frame N + RepeatDelay                  true                     true              -                   true
#   ...                                    -                        -                 -                   -
#   Frame N + RepeatDelay + RepeatRate*N   true                     true              -                   true
#-------------------------------------------------------------------------------------------------------------------------------------------------

def button(str label, width=0, height=0):
    """Display button.

    .. visual-example::
        :auto_layout:
        :height: 100

        imgui.begin("Example: button")
        imgui.button("Button 1")
        imgui.button("Button 2")
        imgui.end()

    Args:
        label (str): button label.
        width (float): button width.
        height (float): button height.

    Returns:
        bool: True if clicked.

    .. wraps::
        bool Button(const char* label, const ImVec2& size = ImVec2(0,0))
    """
    return cimgui.Button(_bytes(label), _cast_args_ImVec2(width, height))

def small_button(str label):
    """Display small button (with 0 frame padding).

    .. visual-example::
        :auto_layout:
        :height: 100

        imgui.begin("Example: button")
        imgui.small_button("Button 1")
        imgui.small_button("Button 2")
        imgui.end()

    Args:
        label (str): button label.

    Returns:
        bool: True if clicked.

    .. wraps::
        bool SmallButton(const char* label)
    """
    return cimgui.SmallButton(_bytes(label))

def invisible_button(str identifier, float width, float height, cimgui.ImGuiButtonFlags flags = 0):
    """Create invisible button.

    Flexible button behavior without the visuals, frequently useful to build custom behaviors using the public api (along with IsItemActive, IsItemHovered, etc.)

    .. visual-example::
        :auto_layout:
        :height: 300
        :width: 300

        imgui.begin("Example: invisible button :)")
        imgui.invisible_button("Button 1", 200, 200)
        imgui.small_button("Button 2")
        imgui.end()

    Args:
        identifier (str): Button identifier. Like label on :any:`button()`
            but it is not displayed.
        width (float): button width.
        height (float): button height.
        flags: ImGuiButtonFlags

    Returns:
        bool: True if button is clicked.

    .. wraps::
        bool InvisibleButton(const char* str_id, const ImVec2& size, ImGuiButtonFlags flags = 0)
    """
    return cimgui.InvisibleButton(
        _bytes(identifier),
        _cast_args_ImVec2(width, height),
        flags
    )

def arrow_button(str label, cimgui.ImGuiDir direction = DIRECTION_NONE):
    """Display an arrow button

    .. visual-example::
        :auto_layout:
        :height: 100

        imgui.begin("Arrow button")
        imgui.arrow_button("Button", imgui.DIRECTION_LEFT)
        imgui.end()

    Args:
        label (str): button label.
        direction = imgui direction constant

    Returns:
        bool: True if clicked.

    .. wraps::
        bool ArrowButton(const char*, ImGuiDir)
    """
    if direction == DIRECTION_NONE:
        raise ValueError("Direction wasn't specified.")
    return cimgui.ArrowButton(_bytes(label), direction)

def image(
    texture_id,
    float width,
    float height,
    tuple uv0=(0, 0),
    tuple uv1=(1, 1),
    tuple tint_color=(1, 1, 1, 1),
    tuple border_color=(0, 0, 0, 0),
):
    """Display image.

    .. visual-example::
        :auto_layout:
        :width: 550
        :height: 200

        texture_id = imgui.get_io().fonts.texture_id

        imgui.begin("Example: image display")
        imgui.image(texture_id, 512, 64, border_color=(1, 0, 0, 1))
        imgui.end()

    Args:
        texture_id (object): user data defining texture id. Argument type
            is implementation dependent. For OpenGL it is usually an integer.
        size (Vec2): image display size two-tuple.
        uv0 (Vec2): UV coordinates for 1st corner (lower-left for OpenGL).
            Defaults to ``(0, 0)``.
        uv1 (Vec2): UV coordinates for 2nd corner (upper-right for OpenGL).
            Defaults to ``(1, 1)``.
        tint_color(Vec4): Image tint color. Defaults to white.
        border_color(Vec4): Image border color. Defaults to transparent.

    .. wraps::
        void Image(
            ImTextureID user_texture_id,
            const ImVec2& size,
            const ImVec2& uv0 = ImVec2(0,0),
            const ImVec2& uv1 = ImVec2(1,1),
            const ImVec4& tint_col = ImVec4(1,1,1,1),
            const ImVec4& border_col = ImVec4(0,0,0,0)
        )
    """
    get_current_context()._keepalive_cache.append(texture_id)
    cimgui.Image(
        <void*>texture_id,
        _cast_args_ImVec2(width, height),  # todo: consider inlining
        _cast_tuple_ImVec2(uv0),
        _cast_tuple_ImVec2(uv1),
        _cast_tuple_ImVec4(tint_color),
        _cast_tuple_ImVec4(border_color),
    )

def image_button(
    texture_id,
    float width,
    float height,
    tuple uv0=(0, 0),
    tuple uv1=(1, 1),
    tuple tint_color=(1, 1, 1, 1),
    tuple border_color=(0, 0, 0, 0),
    int frame_padding=-1,
):
    """Display image.

    .. todo:: add example with some preconfigured image

    Args:
        texture_id (object): user data defining texture id. Argument type
            is implementation dependent. For OpenGL it is usually an integer.
        size (Vec2): image display size two-tuple.
        uv0 (Vec2): UV coordinates for 1st corner (lower-left for OpenGL).
            Defaults to ``(0, 0)``.
        uv1 (Vec2): UV coordinates for 2nd corner (upper-right for OpenGL).
            Defaults to ``(1, 1)``.
        tint_color (Vec4): Image tint color. Defaults to white.
        border_color (Vec4): Image border color. Defaults to transparent.
        frame_padding (int): Frame padding (``0``: no padding, ``<0`` default
            padding).

    Returns:
        bool: True if clicked.

    .. wraps::
        bool ImageButton(
            ImTextureID user_texture_id,
            const ImVec2& size,
            const ImVec2& uv0 = ImVec2(0,0),
            const ImVec2& uv1 = ImVec2(1,1),
            int frame_padding = -1,
            const ImVec4& bg_col = ImVec4(0,0,0,0),
            const ImVec4& tint_col = ImVec4(1,1,1,1)
        )
    """
    get_current_context()._keepalive_cache.append(texture_id)
    return cimgui.ImageButton(
        <void*>texture_id,
        _cast_args_ImVec2(width, height),  # todo: consider inlining
        _cast_tuple_ImVec2(uv0),
        _cast_tuple_ImVec2(uv1),
        # note: slightly different order of params than in ImGui::Image()
        frame_padding,
        _cast_tuple_ImVec4(border_color),
        _cast_tuple_ImVec4(tint_color),
    )

def checkbox(str label, cimgui.bool state):
    """Display checkbox widget.

    .. visual-example::
        :auto_layout:
        :width: 400


        # note: these should be initialized outside of the main interaction
        #       loop
        checkbox1_enabled = True
        checkbox2_enabled = False

        imgui.new_frame()
        imgui.begin("Example: checkboxes")

        # note: first element of return two-tuple notifies if there was a click
        #       event in currently processed frame and second element is actual
        #       checkbox state.
        _, checkbox1_enabled = imgui.checkbox("Checkbox 1", checkbox1_enabled)
        _, checkbox2_enabled = imgui.checkbox("Checkbox 2", checkbox2_enabled)

        imgui.text("Checkbox 1 state value: {}".format(checkbox1_enabled))
        imgui.text("Checkbox 2 state value: {}".format(checkbox2_enabled))

        imgui.end()


    Args:
        label (str): text label for checkbox widget.
        state (bool): current (desired) state of the checkbox. If it has to
            change, the new state will be returned as a second item of
            the return value.

    Returns:
        tuple: a ``(clicked, state)`` two-tuple indicating click event and the
        current state of the checkbox.

    .. wraps::
        bool Checkbox(const char* label, bool* v)
    """
    cdef cimgui.bool inout_state = state
    return cimgui.Checkbox(_bytes(label), &inout_state), inout_state

def checkbox_flags(str label, unsigned int flags, unsigned int flags_value):
    """Display checkbox widget that handle integer flags (bit fields).

    It is useful for handling window/style flags or any kind of flags
    implemented as integer bitfields.

    .. visual-example::
        :auto_layout:
        :width: 500

        flags = imgui.WINDOW_NO_RESIZE | imgui.WINDOW_NO_MOVE

        imgui.begin("Example: checkboxes for flags", flags=flags)

        clicked, flags = imgui.checkbox_flags(
            "No resize", flags, imgui.WINDOW_NO_RESIZE
        )
        clicked, flags = imgui.checkbox_flags(
            "No move", flags, imgui.WINDOW_NO_MOVE
        )
        clicked, flags = imgui.checkbox_flags(
            "No collapse", flags, imgui.WINDOW_NO_COLLAPSE
        )
        # note: it also allows to use multiple flags at once
        clicked, flags = imgui.checkbox_flags(
            "No resize & no move", flags,
            imgui.WINDOW_NO_RESIZE | imgui.WINDOW_NO_MOVE
        )
        imgui.text("Current flags value: {0:b}".format(flags))
        imgui.end()

    Args:
        label (str): text label for checkbox widget.
        flags (int): current state of the flags associated with checkbox.
            Actual state of checkbox (toggled/untoggled) is calculated from
            this argument and ``flags_value`` argument. If it has to change,
            the new state will be returned as a second item of the return
            value.
        flags_value (int): values of flags this widget can toggle. Represents
            bitmask in flags bitfield. Allows multiple flags to be toggled
            at once (specify using bit OR operator `|`, see example above).

    Returns:
        tuple: a ``(clicked, flags)`` two-tuple indicating click event and the
        current state of the flags controlled with this checkbox.

    .. wraps::
        bool CheckboxFlags(
            const char* label, unsigned int* flags,
            unsigned int flags_value
        )
    """
    cdef unsigned int inout_flags = flags

    return cimgui.CheckboxFlags(_bytes(label), &inout_flags, flags_value), inout_flags

def radio_button(str label, cimgui.bool active):
    """Display radio button widget

    .. visual-example::
        :auto_layout:
        :height: 100

        # note: the variable that contains the state of the radio_button, should be initialized
        #       outside of the main interaction loop
        radio_active = True

        imgui.begin("Example: radio buttons")

        if imgui.radio_button("Radio button", radio_active):
            radio_active = not radio_active

        imgui.end()

    Args:
        label (str): button label.
        active (bool): state of the radio button.

    Returns:
        bool: True if clicked.

    .. wraps::
        bool RadioButton(const char* label, bool active)
    """
    return cimgui.RadioButton(_bytes(label), active)

def progress_bar(float fraction, size = (-FLOAT_MIN,0), str overlay = ""):
    """ Show a progress bar

    .. visual-example::
        :auto_layout:
        :width: 400
        :height: 200

        imgui.begin("Progress bar example")
        imgui.progress_bar(0.7, (100,20), "Overlay text")
        imgui.end()

    Args:
        fraction (float): A floating point number between 0.0 and 1.0
            0.0 means no progress and 1.0 means progress is completed
        size : a tuple (width, height) that sets the width and height
            of the progress bar
        overlay (str): Optional text that will be shown in the progress bar

    .. wraps::
        void ProgressBar(
            float fraction,
            const ImVec2& size_arg = ImVec2(-FLT_MIN, 0),
            const char* overlay = NULL
        )

    """
    cimgui.ProgressBar(fraction, _cast_tuple_ImVec2(size), _bytes(overlay))

def bullet():
    """Display a small circle and keep the cursor on the same line.

    .. advance cursor x position by ``get_tree_node_to_label_spacing()``,
       same distance that TreeNode() uses

    .. visual-example::
        :auto_layout:
        :height: 80

        imgui.begin("Example: bullets")

        for i in range(10):
            imgui.bullet()

        imgui.end()

    .. wraps::
        void Bullet()
    """
    cimgui.Bullet()

#-------------------------------------------------------------------------
# [SECTION] Widgets: Low-level Layout helpers
#-------------------------------------------------------------------------
# - Spacing()
# - Dummy()
# - NewLine()
# - AlignTextToFramePadding()
# - SeparatorEx() [Internal]
# - Separator()
# - SplitterBehavior() [Internal]
# - ShrinkWidths() [Internal]
#-------------------------------------------------------------------------

def spacing():
    """Add vertical spacing beween elements.

    .. visual-example::
        :auto_layout:
        :width: 300

        imgui.begin("Example: vertical spacing")

        imgui.text("Some text with bullets:")
        imgui.bullet_text("Bullet A")
        imgui.bullet_text("Bullet A")

        imgui.spacing(); imgui.spacing()

        imgui.text("Another text with bullets:")
        imgui.bullet_text("Bullet A")
        imgui.bullet_text("Bullet A")

        imgui.end()

    .. wraps::
        void Spacing()
    """
    cimgui.Spacing()

def dummy(width, height):
    """Add dummy element of given size.

    .. visual-example::
        :auto_layout:
        :width: 300

        imgui.begin("Example: dummy elements")

        imgui.text("Some text with bullets:")
        imgui.bullet_text("Bullet A")
        imgui.bullet_text("Bullet B")

        imgui.dummy(0, 50)
        imgui.bullet_text("Text after dummy")

        imgui.end()

    .. wraps::
        void Dummy(const ImVec2& size)
    """
    cimgui.Dummy(_cast_args_ImVec2(width, height))

def new_line():
    """Undo :any:`same_line()` call.

    .. wraps::
        void NewLine()
    """
    cimgui.NewLine()

def align_text_to_frame_padding():
    cimgui.AlignTextToFramePadding()

def separator():
    """Add vertical line as a separator beween elements.

    .. visual-example::
        :auto_layout:
        :width: 300

        imgui.begin("Example: separators")

        imgui.text("Some text with bullets")
        imgui.bullet_text("Bullet A")
        imgui.bullet_text("Bullet A")

        imgui.separator()

        imgui.text("Another text with bullets")
        imgui.bullet_text("Bullet A")
        imgui.bullet_text("Bullet A")

        imgui.end()

    .. wraps::
        void Separator()
    """
    cimgui.Separator()

#-------------------------------------------------------------------------
# [SECTION] Widgets: ComboBox
#-------------------------------------------------------------------------
# - BeginCombo()
# - EndCombo()
# - Combo()
#-------------------------------------------------------------------------

cdef class _BeginEndCombo(object):
    """
    Return value of :func:`begin_combo` exposing ``opened`` boolean attribute.
    See :func:`begin_combo` for an explanation and examples.

    Can be used as a context manager (in a ``with`` statement) to automatically
    call :func:`end_combo` to end the combo created with :func:`begin_combo`
    when the block ends, even if an exception is raised.

    This class is not intended to be instantiated by the user (thus the `_` name prefix).
    It should be obtained as the return value of the :func:`begin_combo` function.
    """

    cdef readonly bool opened

    def __cinit__(self, bool opened):
        self.opened = opened

    def __enter__(self):
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        if self.opened:
            cimgui.EndCombo()

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

def begin_combo(str label, str preview_value, cimgui.ImGuiComboFlags flags = 0):
    """Begin a combo box with control over how items are displayed.

    .. visual-example::
        :width: 200
        :height: 200
        :auto_layout:

        selected = 0
        items = ["AAAA", "BBBB", "CCCC", "DDDD"]
        
        # ...
        
        with imgui.begin("Example: begin combo"):
            with imgui.begin_combo("combo", items[selected]) as combo:
                if combo.opened:
                    for i, item in enumerate(items):
                        is_selected = (i == selected)
                        if imgui.selectable(item, is_selected)[0]:
                            selected = i

                        # Set the initial focus when opening the combo (scrolling + keyboard navigation focus)
                        if is_selected:
                            imgui.set_item_default_focus()
    
    Example::
    
        selected = 0
        items = ["AAAA", "BBBB", "CCCC", "DDDD"]
        
        # ...

        imgui.begin("Example: begin combo")
        if imgui.begin_combo("combo", items[selected]):
            for i, item in enumerate(items):
                is_selected = (i == selected)
                if imgui.selectable(item, is_selected)[0]:
                    selected = i
                    
                # Set the initial focus when opening the combo (scrolling + keyboard navigation focus)                    
                if is_selected:
                    imgui.set_item_default_focus()

            imgui.end_combo()

        imgui.end()

    Args:
        label (str): Identifier for the combo box.
        preview_value (str): String preview for currently selected item.
        flags: Combo flags. See:
            :ref:`list of available flags <combo-flag-options>`.

    Returns:
        _BeginEndCombo: Struct with ``opened`` bool attribute. Use with ``with`` to automatically call :func:`end_combo` when the block ends.`

    .. wraps::
        bool BeginCombo(
            const char* label,
            const char* preview_value,
            ImGuiComboFlags flags = 0
        )
    
    """
    return _BeginEndCombo.__new__(
        _BeginEndCombo,
        cimgui.BeginCombo(
            _bytes(label), _bytes(preview_value), flags
        )
    )

def end_combo():
    """End combo box.
    Only call if ``begin_combo().opened`` is True.

    .. wraps::
        void EndCombo()
    """
    cimgui.EndCombo()

def combo(str label, int current, list items, int height_in_items=-1):
    """Display combo widget.

    .. visual-example::
        :auto_layout:
        :height: 200
        :click: 80 40

        current = 2
        imgui.begin("Example: combo widget")

        clicked, current = imgui.combo(
            "combo", current, ["first", "second", "third"]
        )

        imgui.end()

    Args:
        label (str): combo label.
        current (int): index of selected item.
        items (list): list of string labels for items.
        height_in_items (int): height of dropdown in items. Defaults to -1
            (autosized).

    Returns:
        tuple: a ``(changed, current)`` tuple indicating change of selection and current index of selected item.

    .. wraps::
        bool Combo(
            const char* label, int* current_item,
            const char* items_separated_by_zeros,
            int height_in_items = -1
        )

    """
    cdef int inout_current = current

    in_items = "\0".join(items) + "\0"

    return cimgui.Combo(
        _bytes(label), &inout_current, _bytes(in_items), height_in_items
    ), inout_current

#-------------------------------------------------------------------------
# [SECTION] Data Type and Data Formatting Helpers [Internal]
#-------------------------------------------------------------------------
# - PatchFormatStringFloatToInt()
# - DataTypeGetInfo()
# - DataTypeFormatString()
# - DataTypeApplyOp()
# - DataTypeApplyOpFromText()
# - DataTypeClamp()
# - GetMinimumStepAtDecimalPrecision
# - RoundScalarWithFormat<>()
#-------------------------------------------------------------------------

# Nothing to be mapped here

#-------------------------------------------------------------------------
# [SECTION] Widgets: DragScalar, DragFloat, DragInt, etc.
#-------------------------------------------------------------------------
# - DragBehaviorT<>() [Internal]
# - DragBehavior() [Internal]
# - DragScalar()
# - DragScalarN()
# - DragFloat()
# - DragFloat2()
# - DragFloat3()
# - DragFloat4()
# - DragFloatRange2()
# - DragInt()
# - DragInt2()
# - DragInt3()
# - DragInt4()
# - DragIntRange2()
#-------------------------------------------------------------------------

def drag_scalar(
    str label,
    cimgui.ImGuiDataType data_type,
    bytes data,
    float change_speed,
    bytes min_value = None,
    bytes max_value = None,
    str format = None,
    cimgui.ImGuiSliderFlags flags = 0):
    """Display scalar drag widget.
    Data is passed via ``bytes`` and the type is separatelly given using ``data_type``.
    This is useful to work with specific types (e.g. unsigned 8bit integer, float, double)
    like when interfacing with Numpy.

    Args:
        label (str): widget label
        data_type: ImGuiDataType enum, type of the given data
        data (bytes): data value as a bytes array
        change_speed (float): how fast values change on drag
        min_value (bytes): min value allowed by widget
        max_value (bytes): max value allowed by widget
        format (str): display format string as C-style ``printf``
            format string. **Warning:** highly unsafe. See :any:`drag_int()`.
        flags: ImGuiSlider flags. See:
            :ref:`list of available flags <slider-flag-options>`.

    Returns:
        tuple: a ``(changed, value)`` tuple that contains indicator of
        drag state change and the current drag content.

    .. wraps::
        bool DragScalar(
            const char* label,
            ImGuiDataType data_type,
            void* p_data,
            float v_speed,
            const void* p_min = NULL,
            const void* p_max = NULL,
            const char* format = NULL,
            ImGuiSliderFlags flags = 0
        )
    """

    cdef char* p_data = data
    cdef char* p_min = NULL
    if min_value is not None:
        p_min = min_value
    cdef char* p_max = NULL
    if max_value is not None:
        p_max = max_value
    cdef char* fmt = NULL
    cdef bytes fmt_data;
    if format is not None:
        fmt_data = _bytes(format)
        fmt = fmt_data

    cdef changed = cimgui.DragScalar(
        _bytes(label),
        data_type,
        p_data,
        change_speed,
        p_min,
        p_max,
        fmt,
        flags
    )

    return changed, data

def drag_scalar_N(
    str label,
    cimgui.ImGuiDataType data_type,
    bytes data,
    int components,
    float change_speed,
    bytes min_value = None,
    bytes max_value = None,
    str format = None,
    cimgui.ImGuiSliderFlags flags = 0):
    """Display multiple scalar drag widget.
    Data is passed via ``bytes`` and the type is separatelly given using ``data_type``.
    This is useful to work with specific types (e.g. unsigned 8bit integer, float, double)
    like when interfacing with Numpy.

    Args:
        label (str): widget label
        data_type: ImGuiDataType enum, type of the given data
        data (bytes): data value as a bytes array
        components (int): number of widgets
        change_speed (float): how fast values change on drag
        min_value (bytes): min value allowed by widget
        max_value (bytes): max value allowed by widget
        format (str): display format string as C-style ``printf``
            format string. **Warning:** highly unsafe. See :any:`drag_int()`.
        flags: ImGuiSlider flags. See:
            :ref:`list of available flags <slider-flag-options>`.

    Returns:
        tuple: a ``(changed, value)`` tuple that contains indicator of
        drag state change and the current drag content.

    .. wraps::
        bool DragScalarN(
            const char* label,
            ImGuiDataType data_type,
            void* p_data,
            int components,
            float v_speed,
            const void* p_min = NULL,
            const void* p_max = NULL,
            const char* format = NULL,
            ImGuiSliderFlags flags = 0
        )
    """

    cdef char* p_data = data
    cdef char* p_min = NULL
    if min_value is not None:
        p_min = min_value
    cdef char* p_max = NULL
    if max_value is not None:
        p_max = max_value
    cdef char* fmt = NULL
    cdef bytes fmt_data;
    if format is not None:
        fmt_data = _bytes(format)
        fmt = fmt_data

    cdef changed = cimgui.DragScalarN(
        _bytes(label),
        data_type,
        p_data,
        components,
        change_speed,
        p_min,
        p_max,
        fmt,
        flags
    )

    return changed, data

def drag_float(
    str label, float value,
    float change_speed = 1.0,
    float min_value=0.0,
    float max_value=0.0,
    str format = "%.3f",
    cimgui.ImGuiSliderFlags flags = 0,
    float power = 1. # OBSOLETED in 1.78 (from June 2020)
):
    """Display float drag widget.

    .. todo::
        Consider replacing ``format`` with something that allows
        for safer way to specify display format without loosing the
        functionality of wrapped function.

    .. visual-example::
        :auto_layout:
        :width: 400
        :height: 130

        value = 42.0

        imgui.begin("Example: drag float")
        changed, value = imgui.drag_float(
            "Default", value,
        )
        changed, value = imgui.drag_float(
            "Less precise", value, format="%.1f"
        )
        imgui.text("Changed: %s, Value: %s" % (changed, value))
        imgui.end()

    Args:
        label (str): widget label.
        value (float): drag values,
        change_speed (float): how fast values change on drag.
        min_value (float): min value allowed by widget.
        max_value (float): max value allowed by widget.
        format (str): display format string as C-style ``printf``
            format string. **Warning:** Highly unsafe when used without care.
            May lead to segmentation faults and other memory violation issues.
        flags: SliderFlags flags. See:
            :ref:`list of available flags <slider-flag-options>`.
        power (float): OBSOLETED in ImGui 1.78 (from June 2020)

    Returns:
        tuple: a ``(changed, value)`` tuple that contains indicator of
        widget state change and the current drag value.

    .. wraps::
        bool DragFloat(
            const char* label,
            float* v,
            float v_speed = 1.0f,
            float v_min = 0.0f,
            float v_max = 0.0f,
            const char* format = "%.3f",
            ImGuiSliderFlags flags = 0
        )
    """
    assert (power == 1), "power parameter obsoleted in ImGui 1.78, use imgui.SLIDER_FLAGS_LOGARITHMIC instead"
    cdef float inout_value = value

    return cimgui.DragFloat(
        _bytes(label), &inout_value,
        change_speed, min_value, max_value, _bytes(format), flags
    ), inout_value

def drag_float2(
    str label, float value0, float value1,
    float change_speed = 1.0,
    float min_value=0.0,
    float max_value=0.0,
    str format = "%.3f",
    cimgui.ImGuiSliderFlags flags = 0,
    float power = 1. # OBSOLETED in 1.78 (from June 2020)
):
    """Display float drag widget with 2 values.

    .. visual-example::
        :auto_layout:
        :width: 400
        :height: 130

        values = 88.0, 42.0

        imgui.begin("Example: drag float")
        changed, values = imgui.drag_float2(
            "Default", *values
        )
        changed, values = imgui.drag_float2(
            "Less precise", *values, format="%.1f"
        )
        imgui.text("Changed: %s, Values: %s" % (changed, values))
        imgui.end()

    Args:
        label (str): widget label.
        value0, value1 (float): drag values.
        change_speed (float): how fast values change on drag.
        min_value (float): min value allowed by widget.
        max_value (float): max value allowed by widget.
        format (str): display format string as C-style ``printf``
            format string. **Warning:** highly unsafe. See :any:`drag_float()`.
        flags: SliderFlags flags. See:
            :ref:`list of available flags <slider-flag-options>`.
        power (float): OBSOLETED in ImGui 1.78 (from June 2020)

    Returns:
        tuple: a ``(changed, values)`` tuple that contains indicator of
        widget state change and the tuple of current drag values.

    .. wraps::
        bool DragFloat2(
            const char* label,
            float v[2],
            float v_speed = 1.0f,
            float v_min = 0.0f,
            float v_max = 0.0f,
            const char* format = "%.3f",
            ImGuiSliderFlags flags = 0
        )
    """
    assert (power == 1), "power parameter obsoleted in ImGui 1.78, use imgui.SLIDER_FLAGS_LOGARITHMIC instead"
    cdef float[2] inout_values = [value0, value1]
    return cimgui.DragFloat2(
        _bytes(label), <float*>&inout_values,
        change_speed, min_value, max_value, _bytes(format), flags
    ), (inout_values[0], inout_values[1])

def drag_float3(
    str label, float value0, float value1, float value2,
    float change_speed = 1.0,
    float min_value=0.0,
    float max_value=0.0,
    str format = "%.3f",
    cimgui.ImGuiSliderFlags flags = 0,
    float power = 1. # OBSOLETED in 1.78 (from June 2020)
):
    """Display float drag widget with 3 values.

    .. visual-example::
        :auto_layout:
        :width: 400
        :height: 130

        values = 88.0, 42.0, 69.0

        imgui.begin("Example: drag float")
        changed, values = imgui.drag_float3(
            "Default", *values
        )
        changed, values = imgui.drag_float3(
            "Less precise", *values, format="%.1f"
        )
        imgui.text("Changed: %s, Values: %s" % (changed, values))
        imgui.end()

    Args:
        label (str): widget label.
        value0, value1, value2 (float): drag values.
        change_speed (float): how fast values change on drag.
        min_value (float): min value allowed by widget.
        max_value (float): max value allowed by widget.
        format (str): display format string as C-style ``printf``
            format string. **Warning:** highly unsafe. See :any:`drag_float()`.
        flags: SliderFlags flags. See:
            :ref:`list of available flags <slider-flag-options>`.
        power (float): OBSOLETED in ImGui 1.78 (from June 2020)

    Returns:
        tuple: a ``(changed, values)`` tuple that contains indicator of
        widget state change and the tuple of current drag values.

    .. wraps::
        bool DragFloat3(
            const char* label,
            float v[3],
            float v_speed = 1.0f,
            float v_min = 0.0f,
            float v_max = 0.0f,
            const char* format = "%.3f",
            ImGuiSliderFlags flags = 0
        )
    """
    assert (power == 1), "power parameter obsoleted in ImGui 1.78, use imgui.SLIDER_FLAGS_LOGARITHMIC instead"
    cdef float[3] inout_values = [value0, value1, value2]
    return cimgui.DragFloat3(
        _bytes(label), <float*>&inout_values,
        change_speed, min_value, max_value, _bytes(format), flags
    ), (inout_values[0], inout_values[1], inout_values[2])

def drag_float4(
    str label, float value0, float value1, float value2, float value3,
    float change_speed = 1.0,
    float min_value=0.0,
    float max_value=0.0,
    str format = "%.3f",
    cimgui.ImGuiSliderFlags flags = 0,
    float power = 1. # OBSOLETED in 1.78 (from June 2020)
):
    """Display float drag widget with 4 values.

    .. visual-example::
        :auto_layout:
        :width: 400
        :height: 130

        values = 88.0, 42.0, 69.0, 0.0

        imgui.begin("Example: drag float")
        changed, values = imgui.drag_float4(
            "Default", *values
        )
        changed, values = imgui.drag_float4(
            "Less precise", *values, format="%.1f"
        )
        imgui.text("Changed: %s, Values: %s" % (changed, values))
        imgui.end()

    Args:
        label (str): widget label.
        value0, value1, value2, value3 (float): drag values.
        change_speed (float): how fast values change on drag.
        min_value (float): min value allowed by widget.
        max_value (float): max value allowed by widget.
        format (str): display format string as C-style ``printf``
            format string. **Warning:** highly unsafe. See :any:`drag_float()`.
        flags: SliderFlags flags. See:
            :ref:`list of available flags <slider-flag-options>`.
        power (float): OBSOLETED in ImGui 1.78 (from June 2020)

    Returns:
        tuple: a ``(changed, values)`` tuple that contains indicator of
        widget state change and the tuple of current drag values.

    .. wraps::
        bool DragFloat4(
            const char* label,
            float v[4],
            float v_speed = 1.0f,
            float v_min = 0.0f,
            float v_max = 0.0f,
            const char* format = "%.3f",
            ImGuiSliderFlags flags = 0
        )
    """
    assert (power == 1), "power parameter obsoleted in ImGui 1.78, use imgui.SLIDER_FLAGS_LOGARITHMIC instead"
    cdef float[4] inout_values = [value0, value1, value2, value3]
    return cimgui.DragFloat4(
        _bytes(label), <float*>&inout_values,
        change_speed, min_value, max_value, _bytes(format), flags
    ), (inout_values[0], inout_values[1], inout_values[2], inout_values[3])

def drag_float_range2(
    str label,
    float current_min,
    float current_max,
    float speed = 1.0,
    float min_value = 0.0,
    float max_value = 0.0,
    str format = "%.3f",
    str format_max = None,
    cimgui.ImGuiSliderFlags flags = 0
    ):
    """Display drag float range widget

    Args:
        label (str): widget label
        current_min (float): current value of minimum
        current_max (float): current value of maximum
        speed (float): widget speed of change
        min_value (float): minimal possible value
        max_value (float): maximal possible value
        format (str): display format
        format_max (str): display format for maximum. If None, ``format`` parameter is used.
        flags: SliderFlags flags. See:
            :ref:`list of available flags <slider-flag-options>`.

    Returns:
        tuple: a (changed, current_min, current_max) tuple, where ``changed`` indicate
               that the value has been updated.

    .. visual-example::
        :auto_layout:
        :width: 400
        :height: 130

        vmin = 0
        vmax = 100

        imgui.begin("Example: drag float range")
        changed, vmin, vmax = imgui.drag_float_range2( "Drag Range", vmin, vmax )
        imgui.text("Changed: %s, Range: (%.2f, %.2f)" % (changed, vmin, vmax))
        imgui.end()


    .. wraps::
        bool DragFloatRange2(
            const char* label,
            float* v_current_min,
            float* v_current_max,
            float v_speed = 1.0f,
            float v_min = 0.0f,
            float v_max = 0.0f,
            const char* format = "%.3f",
            const char* format_max = NULL,
            ImGuiSliderFlags flags = 0
        )
    """

    cdef float inout_current_min = current_min
    cdef float inout_current_max = current_max

    cdef bytes b_format_max;
    cdef char* p_format_max = NULL
    if format_max is not None:
        b_format_max = _bytes(format_max)
        p_format_max = b_format_max

    changed = cimgui.DragFloatRange2(
        _bytes(label),
        &inout_current_min,
        &inout_current_max,
        speed,
        min_value,
        max_value,
        _bytes(format),
        p_format_max,
        flags
    )

    return changed, inout_current_min, inout_current_max

def drag_int(
    str label, int value,
    float change_speed = 1.0,
    int min_value=0,
    int max_value=0,
    str format = "%d",
    cimgui.ImGuiSliderFlags flags = 0
):
    """Display int drag widget.

    .. todo::
        Consider replacing ``format`` with something that allows
        for safer way to specify display format without loosing the
        functionality of wrapped function.

    .. visual-example::
        :auto_layout:
        :width: 400
        :height: 130

        value = 42

        imgui.begin("Example: drag int")
        changed, value = imgui.drag_int("drag int", value,)
        imgui.text("Changed: %s, Value: %s" % (changed, value))
        imgui.end()

    Args:
        label (str): widget label.
        value (int): drag value,
        change_speed (float): how fast values change on drag.
        min_value (int): min value allowed by widget.
        max_value (int): max value allowed by widget.
        format (str): display format string as C-style ``printf``
            format string. **Warning:** Highly unsafe when used without care.
            May lead to segmentation faults and other memory violation issues.
        flags: SliderFlags flags. See:
            :ref:`list of available flags <slider-flag-options>`.

    Returns:
        tuple: a ``(changed, value)`` tuple that contains indicator of
        widget state change and the current drag value.

    .. wraps::
        bool DragInt(
            const char* label,
            int* v,
            float v_speed = 1.0f,
            int v_min = 0.0f,
            int v_max = 0.0f,
            const char* format = "%d",
            ImGuiSliderFlags flags = 0
        )
    """
    cdef int inout_value = value

    return cimgui.DragInt(
        _bytes(label), &inout_value,
        change_speed, min_value, max_value, _bytes(format), flags
    ), inout_value


def drag_int2(
    str label, int value0, int value1,
    float change_speed = 1.0,
    int min_value=0,
    int max_value=0,
    str format = "%d",
    cimgui.ImGuiSliderFlags flags = 0
):
    """Display int drag widget with 2 values.

    .. visual-example::
        :auto_layout:
        :width: 400
        :height: 130

        values = 88, 42

        imgui.begin("Example: drag int")
        changed, values = imgui.drag_int2(
            "drag ints", *values
        )
        imgui.text("Changed: %s, Values: %s" % (changed, values))
        imgui.end()

    Args:
        label (str): widget label.
        value0, value1 (int): drag values.
        change_speed (float): how fast values change on drag.
        min_value (int): min value allowed by widget.
        max_value (int): max value allowed by widget.
        format (str): display format string as C-style ``printf``
            format string. **Warning:** highly unsafe. See :any:`drag_int()`.
        flags: SliderFlags flags. See:
            :ref:`list of available flags <slider-flag-options>`.

    Returns:
        tuple: a ``(changed, values)`` tuple that contains indicator of
        widget state change and the tuple of current drag values.

    .. wraps::
        bool DragInt2(
            const char* label,
            int v[2],
            float v_speed = 1.0f,
            int v_min = 0.0f,
            int v_max = 0.0f,
            const char* format = "%d",
            ImGuiSliderFlags flags = 0
        )
    """
    cdef int[2] inout_values = [value0, value1]
    return cimgui.DragInt2(
        _bytes(label), <int*>&inout_values,
        change_speed, min_value, max_value, _bytes(format), flags
    ), (inout_values[0], inout_values[1])


def drag_int3(
    str label, int value0, int value1, int value2,
    float change_speed = 1.0,
    int min_value=0,
    int max_value=0,
    str format = "%d",
    cimgui.ImGuiSliderFlags flags = 0
):
    """Display int drag widget with 3 values.

    .. visual-example::
        :auto_layout:
        :width: 400
        :height: 130

        values = 88, 42, 69

        imgui.begin("Example: drag int")
        changed, values = imgui.drag_int3(
            "drag ints", *values
        )
        imgui.text("Changed: %s, Values: %s" % (changed, values))
        imgui.end()

    Args:
        label (str): widget label.
        value0, value1 (int): drag values.
        change_speed (float): how fast values change on drag.
        min_value (int): min value allowed by widget.
        max_value (int): max value allowed by widget.
        format (str): display format string as C-style ``printf``
            format string. **Warning:** highly unsafe. See :any:`drag_int()`.
        flags: SliderFlags flags. See:
            :ref:`list of available flags <slider-flag-options>`.

    Returns:
        tuple: a ``(changed, values)`` tuple that contains indicator of
        widget state change and the tuple of current drag values.

    .. wraps::
        bool DragInt3(
            const char* label,
            int v[3],
            float v_speed = 1.0f,
            int v_min = 0.0f,
            int v_max = 0.0f,
            const char* format = "%d",
            ImGuiSliderFlags flags = 0
        )
    """
    cdef int[3] inout_values = [value0, value1, value2]
    return cimgui.DragInt3(
        _bytes(label), <int*>&inout_values,
        change_speed, min_value, max_value, _bytes(format), flags
    ), (inout_values[0], inout_values[1], inout_values[2])


def drag_int4(
    str label, int value0, int value1, int value2, int value3,
    float change_speed = 1.0,
    int min_value=0,
    int max_value=0,
    str format = "%d",
    cimgui.ImGuiSliderFlags flags = 0
):
    """Display int drag widget with 4 values.

    .. visual-example::
        :auto_layout:
        :width: 400
        :height: 130

        values = 88, 42, 69, 0

        imgui.begin("Example: drag int")
        changed, values = imgui.drag_int4(
            "drag ints", *values
        )
        imgui.text("Changed: %s, Values: %s" % (changed, values))
        imgui.end()

    Args:
        label (str): widget label.
        value0, value1 (int): drag values.
        change_speed (float): how fast values change on drag.
        min_value (int): min value allowed by widget.
        max_value (int): max value allowed by widget.
        format (str): display format string as C-style ``printf``
            format string. **Warning:** highly unsafe. See :any:`drag_int()`.
        flags: SliderFlags flags. See:
            :ref:`list of available flags <slider-flag-options>`.

    Returns:
        tuple: a ``(changed, values)`` tuple that contains indicator of
        widget state change and the tuple of current drag values.

    .. wraps::
        bool DragInt4(
            const char* label,
            int v[4],
            float v_speed = 1.0f,
            int v_min = 0.0f,
            int v_max = 0.0f,
            const char* format = "%d",
            ImGuiSliderFlags flags = 0
        )
    """
    cdef int[4] inout_values = [value0, value1, value2, value3]
    return cimgui.DragInt4(
        _bytes(label), <int*>&inout_values,
        change_speed, min_value, max_value, _bytes(format), flags
    ), (inout_values[0], inout_values[1], inout_values[2], inout_values[3])

def drag_int_range2(
    str label,
    int current_min,
    int current_max,
    float speed = 1.0,
    int min_value = 0,
    int max_value = 0,
    str format = "%d",
    str format_max = None,
    cimgui.ImGuiSliderFlags flags = 0
    ):
    """Display drag int range widget

    Args:
        label (str): widget label
        current_min (int): current value of minimum
        current_max (int): current value of maximum
        speed (float): widget speed of change
        min_value (int): minimal possible value
        max_value (int): maximal possible value
        format (str): display format
        format_max (str): display format for maximum. If None, ``format`` parameter is used.
        flags: SliderFlags flags. See:
            :ref:`list of available flags <slider-flag-options>`.

    Returns:
        tuple: a (changed, current_min, current_max) tuple, where ``changed`` indicate
               that the value has been updated.

    .. visual-example::
        :auto_layout:
        :width: 400
        :height: 130

        vmin = 0
        vmax = 100

        imgui.begin("Example: drag float range")
        changed, vmin, vmax = imgui.drag_int_range2( "Drag Range", vmin, vmax )
        imgui.text("Changed: %s, Range: (%d, %d)" % (changed, vmin, vmax))
        imgui.end()


    .. wraps::
        bool DragIntRange2(
            const char* label,
            int* v_current_min,
            int* v_current_max,
            float v_speed = 1.0f,
            int v_min = 0,
            int v_max = 0,
            const char* format = "%d",
            const char* format_max = NULL,
            ImGuiSliderFlags flags = 0
        )
    """

    cdef int inout_current_min = current_min
    cdef int inout_current_max = current_max

    cdef bytes b_format_max;
    cdef char* p_format_max = NULL
    if format_max is not None:
        b_format_max = _bytes(format_max)
        p_format_max = b_format_max

    changed = cimgui.DragIntRange2(
        _bytes(label),
        &inout_current_min,
        &inout_current_max,
        speed,
        min_value,
        max_value,
        _bytes(format),
        p_format_max,
        flags
    )

    return changed, inout_current_min, inout_current_max

#-------------------------------------------------------------------------
# [SECTION] Widgets: SliderScalar, SliderFloat, SliderInt, etc.
#-------------------------------------------------------------------------
# - ScaleRatioFromValueT<> [Internal]
# - ScaleValueFromRatioT<> [Internal]
# - SliderBehaviorT<>() [Internal]
# - SliderBehavior() [Internal]
# - SliderScalar()
# - SliderScalarN()
# - SliderFloat()
# - SliderFloat2()
# - SliderFloat3()
# - SliderFloat4()
# - SliderAngle()
# - SliderInt()
# - SliderInt2()
# - SliderInt3()
# - SliderInt4()
# - VSliderScalar()
# - VSliderFloat()
# - VSliderInt()
#-------------------------------------------------------------------------

def slider_scalar(
    str label,
    cimgui.ImGuiDataType data_type,
    bytes data,
    bytes min_value,
    bytes max_value,
    str format = None,
    cimgui.ImGuiSliderFlags flags = 0):
    """Display scalar slider widget.
    Data is passed via ``bytes`` and the type is separatelly given using ``data_type``.
    This is useful to work with specific types (e.g. unsigned 8bit integer, float, double)
    like when interfacing with Numpy.

    Args:
        label (str): widget label
        data_type: ImGuiDataType enum, type of the given data
        data (bytes): data value as a bytes array
        min_value (bytes): min value allowed by widget
        max_value (bytes): max value allowed by widget
        format (str): display format string as C-style ``printf``
            format string. **Warning:** highly unsafe. See :any:`drag_int()`.
        flags: ImGuiSlider flags. See:
            :ref:`list of available flags <slider-flag-options>`.

    Returns:
        tuple: a ``(changed, value)`` tuple that contains indicator of
        slider state change and the current slider content.

    .. wraps::
        bool SliderScalar(
            const char* label,
            ImGuiDataType data_type,
            void* p_data,
            const void* p_min,
            const void* p_max,
            const char* format = NULL,
            ImGuiSliderFlags flags = 0
        )
    """

    cdef char* p_data = data
    cdef char* p_min = min_value
    cdef char* p_max = max_value

    cdef char* fmt = NULL
    cdef bytes fmt_data;
    if format is not None:
        fmt_data = _bytes(format)
        fmt = fmt_data

    cdef changed = cimgui.SliderScalar(
        _bytes(label),
        data_type,
        p_data,
        p_min,
        p_max,
        fmt,
        flags
    )

    return changed, data

def slider_scalar_N(
    str label,
    cimgui.ImGuiDataType data_type,
    bytes data,
    int components,
    bytes min_value,
    bytes max_value,
    str format = None,
    cimgui.ImGuiSliderFlags flags = 0):
    """Display multiple scalar slider widget.
    Data is passed via ``bytes`` and the type is separatelly given using ``data_type``.
    This is useful to work with specific types (e.g. unsigned 8bit integer, float, double)
    like when interfacing with Numpy.

    Args:
        label (str): widget label
        data_type: ImGuiDataType enum, type of the given data
        data (bytes): data value as a bytes array
        components (int): number of widgets
        min_value (bytes): min value allowed by widget
        max_value (bytes): max value allowed by widget
        format (str): display format string as C-style ``printf``
            format string. **Warning:** highly unsafe. See :any:`drag_int()`.
        flags: ImGuiSlider flags. See:
            :ref:`list of available flags <slider-flag-options>`.

    Returns:
        tuple: a ``(changed, value)`` tuple that contains indicator of
        slider state change and the current slider content.

    .. wraps::
        bool SliderScalarN(
            const char* label,
            ImGuiDataType data_type,
            void* p_data,
            int components,
            const void* p_min,
            const void* p_max,
            const char* format = NULL,
            ImGuiSliderFlags flags = 0
        )
    """

    cdef char* p_data = data
    cdef char* p_min = min_value
    cdef char* p_max = max_value

    cdef char* fmt = NULL
    cdef bytes fmt_data;
    if format is not None:
        fmt_data = _bytes(format)
        fmt = fmt_data

    cdef changed = cimgui.SliderScalarN(
        _bytes(label),
        data_type,
        p_data,
        components,
        p_min,
        p_max,
        fmt,
        flags
    )

    return changed, data

def slider_float(
    str label,
    float value,
    float min_value,
    float max_value,
    str format = "%.3f",
    cimgui.ImGuiSliderFlags flags = 0,
    float power=1.0 # OBSOLETED in 1.78 (from June 2020)
):
    """Display float slider widget.
    Manually input values aren't clamped and can go off-bounds.

    .. visual-example::
        :auto_layout:
        :width: 400
        :height: 130

        value = 88.2

        imgui.begin("Example: slider float")
        changed, value = imgui.slider_float(
            "slide floats", value,
            min_value=0.0, max_value=100.0,
            format="%.0f"
        )
        imgui.text("Changed: %s, Value: %s" % (changed, value))
        imgui.end()

    Args:
        label (str): widget label.
        value (float): slider values.
        min_value (float): min value allowed by widget.
        max_value (float): max value allowed by widget.
        format (str): display format string as C-style ``printf``
            format string. **Warning:** highly unsafe.
            See :any:`slider_float()`.
        flags: SliderFlags flags. See:
            :ref:`list of available flags <slider-flag-options>`.
        power (float): OBSOLETED in ImGui 1.78 (from June 2020)

    Returns:
        tuple: a ``(changed, values)`` tuple that contains indicator of
        widget state change and the current slider value.

    .. wraps::
        bool SliderFloat(
            const char* label,
            float v,
            float v_min,
            float v_max,
            const char* format = "%.3f",
            ImGuiSliderFlags flags = 0
        )
    """
    assert (power == 1), "power parameter obsoleted in ImGui 1.78, use imgui.SLIDER_FLAGS_LOGARITHMIC instead"
    cdef float inout_value = value
    return cimgui.SliderFloat(
        _bytes(label), <float*>&inout_value,
        min_value, max_value, _bytes(format), flags
    ), inout_value


def slider_float2(
    str label,
    float value0, float value1,
    float min_value,
    float max_value,
    str format = "%.3f",
    cimgui.ImGuiSliderFlags flags = 0,
    float power=1.0 # OBSOLETED in 1.78 (from June 2020)
):
    """Display float slider widget with 2 values.
    Manually input values aren't clamped and can go off-bounds.

    .. visual-example::
        :auto_layout:
        :width: 400
        :height: 130

        values = 88.2, 42.6

        imgui.begin("Example: slider float2")
        changed, values = imgui.slider_float2(
            "slide floats", *values,
            min_value=0.0, max_value=100.0,
            format="%.0f"
        )
        imgui.text("Changed: %s, Values: %s" % (changed, values))
        imgui.end()
    
    Args:
        label (str): widget label.
        value0, value1 (float): slider values.
        min_value (float): min value allowed by widget.
        max_value (float): max value allowed by widget.
        format (str): display format string as C-style ``printf``
            format string. **Warning:** highly unsafe.
            See :any:`slider_float()`.
        flags: SliderFlags flags. See:
            :ref:`list of available flags <slider-flag-options>`.
        power (float): OBSOLETED in ImGui 1.78 (from June 2020)

    Returns:
        tuple: a ``(changed, values)`` tuple that contains indicator of
        widget state change and the tuple of current slider values.

    .. wraps::
        bool SliderFloat2(
            const char* label,
            float v[2],
            float v_min,
            float v_max,
            const char* format = "%.3f",
            ImGuiSliderFlags flags = 0
        )
    
    """
    assert (power == 1), "power parameter obsoleted in ImGui 1.78, use imgui.SLIDER_FLAGS_LOGARITHMIC instead"
    cdef float[2] inout_values = [value0, value1]
    return cimgui.SliderFloat2(
        _bytes(label), <float*>&inout_values,
        min_value, max_value, _bytes(format), flags
    ), (inout_values[0], inout_values[1])


def slider_float3(
    str label,
    float value0, float value1, float value2,
    float min_value,
    float max_value,
    str format = "%.3f",
    cimgui.ImGuiSliderFlags flags = 0,
    float power=1.0 # OBSOLETED in 1.78 (from June 2020)
):
    """Display float slider widget with 3 values.
    Manually input values aren't clamped and can go off-bounds.

    .. visual-example::
        :auto_layout:
        :width: 400
        :height: 130

        values = 88.2, 42.6, 69.1

        imgui.begin("Example: slider float3")
        changed, values = imgui.slider_float3(
            "slide floats", *values,
            min_value=0.0, max_value=100.0,
            format="%.0f"
        )
        imgui.text("Changed: %s, Values: %s" % (changed, values))
        imgui.end()

    Args:
        label (str): widget label.
        value0, value1, value2 (float): slider values.
        min_value (float): min value allowed by widget.
        max_value (float): max value allowed by widget.
        format (str): display format string as C-style ``printf``
            format string. **Warning:** highly unsafe.
            See :any:`slider_float()`.
        flags: SliderFlags flags. See:
            :ref:`list of available flags <slider-flag-options>`.
        power (float): OBSOLETED in ImGui 1.78 (from June 2020)

    Returns:
        tuple: a ``(changed, values)`` tuple that contains indicator of
        widget state change and the tuple of current slider values.

    .. wraps::
        bool SliderFloat3(
            const char* label,
            float v[3],
            float v_min,
            float v_max,
            const char* format = "%.3f",
            ImGuiSliderFlags flags = 0
        )
    """
    assert (power == 1), "power parameter obsoleted in ImGui 1.78, use imgui.SLIDER_FLAGS_LOGARITHMIC instead"
    cdef float[3] inout_values = [value0, value1, value2]
    return cimgui.SliderFloat3(
        _bytes(label), <float*>&inout_values,
        min_value, max_value, _bytes(format), flags
    ), (inout_values[0], inout_values[1], inout_values[2])


def slider_float4(
    str label,
    float value0, float value1, float value2, float value3,
    float min_value,
    float max_value,
    str format = "%.3f",
    cimgui.ImGuiSliderFlags flags = 0,
    float power=1.0 # OBSOLETED in 1.78 (from June 2020)
):
    """Display float slider widget with 4 values.
    Manually input values aren't clamped and can go off-bounds.

    .. visual-example::
        :auto_layout:
        :width: 400
        :height: 130

        values = 88.2, 42.6, 69.1, 0.3

        imgui.begin("Example: slider float4")
        changed, values = imgui.slider_float4(
            "slide floats", *values,
            min_value=0.0, max_value=100.0,
            format="%.0f"
        )
        imgui.text("Changed: %s, Values: %s" % (changed, values))
        imgui.end()

    Args:
        label (str): widget label.
        value0, value1, value2, value3 (float): slider values.
        min_value (float): min value allowed by widget.
        max_value (float): max value allowed by widget.
        format (str): display format string as C-style ``printf``
            format string. **Warning:** highly unsafe.
            See :any:`slider_float()`.
        flags: SliderFlags flags. See:
            :ref:`list of available flags <slider-flag-options>`.
        power (float): OBSOLETED in ImGui 1.78 (from June 2020)

    Returns:
        tuple: a ``(changed, values)`` tuple that contains indicator of
        widget state change and the tuple of current slider values.

    .. wraps::
        bool SliderFloat4(
            const char* label,
            float v[4],
            float v_min,
            float v_max,
            const char* format = "%.3f",
            ImGuiSliderFlags flags = 0
        )
    """
    assert (power == 1), "power parameter obsoleted in ImGui 1.78, use imgui.SLIDER_FLAGS_LOGARITHMIC instead"
    cdef float[4] inout_values = [value0, value1, value2, value3]
    return cimgui.SliderFloat4(
        _bytes(label), <float*>&inout_values,
        min_value, max_value, _bytes(format), flags
    ), (inout_values[0], inout_values[1], inout_values[2], inout_values[3])

def slider_angle(
    str label,
    float rad_value,
    float value_degrees_min = -360.0,
    float value_degrees_max = 360,
    str format = "%.0f deg",
    cimgui.ImGuiSliderFlags flags = 0):
    """Display angle slider widget.

    .. visual-example::
        :auto_layout:
        :width: 400
        :height: 130

        radian = 3.1415/4

        imgui.begin("Example: slider angle")
        changed, radian = imgui.slider_angle(
            "slider angle", radian,
            value_degrees_min=0.0, value_degrees_max=180.0)
        imgui.text("Changed: %s, Value: %s" % (changed, radian))
        imgui.end()

    Args:
        labal (str): widget label
        rad_value (float): slider value in radian
        value_degrees_min (float): min value allowed in degrees
        value_degrees_max (float): max value allowed in degrees
        format (str): display format string as C-style ``printf``
            format string. **Warning:** highly unsafe.
        flags: SliderFlags flags. See:
            :ref:`list of available flags <slider-flag-options>`.

    Returns:
        tuple: a ``(changed, rad_value)`` tuple that contains indicator of
        widget state change and the current slider value in radian.


    .. wraps::
        bool SliderAngle(
            const char* label,
            float* v_rad, float
            v_degrees_min = -360.0f,
            float v_degrees_max = +360.0f,
            const char* format = "%.0f deg",
            ImGuiSliderFlags flags = 0
        )

    """
    cdef float inout_r_value = rad_value
    return cimgui.SliderAngle(
        _bytes(label), <float*>&inout_r_value,
        value_degrees_min, value_degrees_max,
        _bytes(format), flags
    ), inout_r_value

def slider_int(
    str label,
    int value,
    int min_value,
    int max_value,
    str format = "%.f",
    cimgui.ImGuiSliderFlags flags = 0
):
    """Display int slider widget

    .. visual-example::
        :auto_layout:
        :width: 400
        :height: 130

        value = 88

        imgui.begin("Example: slider int")
        changed, values = imgui.slider_int(
            "slide ints", value,
            min_value=0, max_value=100,
            format="%d"
        )
        imgui.text("Changed: %s, Values: %s" % (changed, value))
        imgui.end()

    Args:
        label (str): widget label.
        value (int): slider value.
        min_value (int): min value allowed by widget.
        max_value (int): max value allowed by widget.
        format (str): display format string as C-style ``printf``
            format string. **Warning:** highly unsafe.
            See :any:`slider_int()`.
        flags: SliderFlags flags. See:
            :ref:`list of available flags <slider-flag-options>`.

    Returns:
        tuple: a ``(changed, value)`` tuple that contains indicator of
        widget state change and the slider value.

    .. wraps::
        bool SliderInt(
            const char* label,
            int v,
            int v_min,
            int v_max,
            const char* format = "%.3f",
            ImGuiSliderFlags flags = 0
        )
    """
    cdef int inout_value = value
    return cimgui.SliderInt(
        _bytes(label), <int*>&inout_value,
        min_value, max_value, _bytes(format), flags
    ), inout_value


def slider_int2(
    str label,
    int value0, int value1,
    int min_value,
    int max_value,
    str format = "%.f",
    cimgui.ImGuiSliderFlags flags = 0
):
    """Display int slider widget with 2 values.

    .. visual-example::
        :auto_layout:
        :width: 400
        :height: 130

        values = 88, 27

        imgui.begin("Example: slider int2")
        changed, values = imgui.slider_int2(
            "slide ints2", *values,
            min_value=0, max_value=100,
            format="%d"
        )
        imgui.text("Changed: %s, Values: %s" % (changed, values))
        imgui.end()

    Args:
        label (str): widget label.
        value0, value1 (int): slider values.
        min_value (int): min value allowed by widget.
        max_value (int): max value allowed by widget.
        format (str): display format string as C-style ``printf``
            format string. **Warning:** highly unsafe.
            See :any:`slider_int()`.
        flags: SliderFlags flags. See:
            :ref:`list of available flags <slider-flag-options>`.

    Returns:
        tuple: a ``(changed, values)`` tuple that contains indicator of
        widget state change and the tuple of current slider values.

    .. wraps::
        bool SliderInt2(
            const char* label,
            int v[2],
            int v_min,
            int v_max,
            const char* format = "%.3f",
            ImGuiSliderFlags flags = 0
        )
    """
    cdef int[2] inout_values = [value0, value1]
    return cimgui.SliderInt2(
        _bytes(label), <int*>&inout_values,
        min_value, max_value, _bytes(format), flags
    ), (inout_values[0], inout_values[1])


def slider_int3(
    str label,
    int value0, int value1, int value2,
    int min_value,
    int max_value,
    str format = "%.f",
    cimgui.ImGuiSliderFlags flags = 0
):
    """Display int slider widget with 3 values.

    .. visual-example::
        :auto_layout:
        :width: 400
        :height: 130

        values = 88, 27, 3

        imgui.begin("Example: slider int3")
        changed, values = imgui.slider_int3(
            "slide ints3", *values,
            min_value=0, max_value=100,
            format="%d"
        )
        imgui.text("Changed: %s, Values: %s" % (changed, values))
        imgui.end()

    Args:
        label (str): widget label.
        value0, value1, value2 (int): slider values.
        min_value (int): min value allowed by widget.
        max_value (int): max value allowed by widget.
        format (str): display format string as C-style ``printf``
            format string. **Warning:** highly unsafe.
            See :any:`slider_int()`.
        flags: SliderFlags flags. See:
            :ref:`list of available flags <slider-flag-options>`.

    Returns:
        tuple: a ``(changed, values)`` tuple that contains indicator of
        widget state change and the tuple of current slider values.

    .. wraps::
        bool SliderInt3(
            const char* label,
            int v[3],
            int v_min,
            int v_max,
            const char* format = "%.3f",
            ImGuiSliderFlags flags = 0
        )
    """
    cdef int[3] inout_values = [value0, value1, value2]
    return cimgui.SliderInt3(
        _bytes(label), <int*>&inout_values,
        min_value, max_value, _bytes(format), flags
    ), (inout_values[0], inout_values[1], inout_values[2])


def slider_int4(
    str label,
    int value0, int value1, int value2, int value3,
    int min_value,
    int max_value,
    str format = "%.f",
    cimgui.ImGuiSliderFlags flags = 0
):
    """Display int slider widget with 4 values.

    .. visual-example::
        :auto_layout:
        :width: 400
        :height: 130

        values = 88, 42, 69, 0

        imgui.begin("Example: slider int4")
        changed, values = imgui.slider_int4(
            "slide ints", *values,
            min_value=0, max_value=100, format="%d"
        )
        imgui.text("Changed: %s, Values: %s" % (changed, values))
        imgui.end()

    Args:
        label (str): widget label.
        value0, value1, value2, value3 (int): slider values.
        min_value (int): min value allowed by widget.
        max_value (int): max value allowed by widget.
        format (str): display format string as C-style ``printf``
            format string. **Warning:** highly unsafe.
            See :any:`slider_int()`.
        flags: SliderFlags flags. See:
            :ref:`list of available flags <slider-flag-options>`.

    Returns:
        tuple: a ``(changed, values)`` tuple that contains indicator of
        widget state change and the tuple of current slider values.

    .. wraps::
        bool SliderInt4(
            const char* label,
            int v[4],
            int v_min,
            int v_max,
            const char* format = "%.3f",
            ImGuiSliderFlags flags = 0
        )
    """
    cdef int[4] inout_values = [value0, value1, value2, value3]
    return cimgui.SliderInt4(
        _bytes(label), <int*>&inout_values,
        min_value, max_value, _bytes(format), flags
    ), (inout_values[0], inout_values[1], inout_values[2], inout_values[3])

def v_slider_scalar(
    str label,
    float width,
    float height,
    cimgui.ImGuiDataType data_type,
    bytes data,
    bytes min_value,
    bytes max_value,
    str format = None,
    cimgui.ImGuiSliderFlags flags = 0):
    """Display vertical scalar slider widget.
    Data is passed via ``bytes`` and the type is separatelly given using ``data_type``.
    This is useful to work with specific types (e.g. unsigned 8bit integer, float, double)
    like when interfacing with Numpy.

    Args:
        label (str): widget label
        width (float): width of the slider
        height (float): height of the slider
        data_type: ImGuiDataType enum, type of the given data
        data (bytes): data value as a bytes array
        min_value (bytes): min value allowed by widget
        max_value (bytes): max value allowed by widget
        format (str): display format string as C-style ``printf``
            format string. **Warning:** highly unsafe. See :any:`drag_int()`.
        flags: ImGuiSlider flags. See:
            :ref:`list of available flags <slider-flag-options>`.

    Returns:
        tuple: a ``(changed, value)`` tuple that contains indicator of
        slider state change and the current slider content.

    .. wraps::
        bool VSliderScalar(
            const char* label,
            const ImVec2& size,
            ImGuiDataType data_type,
            void* p_data,
            const void* p_min,
            const void* p_max,
            const char* format = NULL,
            ImGuiSliderFlags flags = 0
        )
    """

    cdef char* p_data = data
    cdef char* p_min = min_value
    cdef char* p_max = max_value

    cdef char* fmt = NULL
    cdef bytes fmt_data;
    if format is not None:
        fmt_data = _bytes(format)
        fmt = fmt_data

    cdef changed = cimgui.VSliderScalar(
        _bytes(label),
        _cast_args_ImVec2(width, height),
        data_type,
        p_data,
        p_min,
        p_max,
        fmt,
        flags
    )

    return changed, data

def v_slider_float(
    str label,
    float width,
    float height,
    float value,
    float min_value,
    float max_value,
    str format = "%.f",
    cimgui.ImGuiSliderFlags flags = 0
):
    """Display vertical float slider widget with the specified width and
    height.

    .. visual-example::
        :auto_layout:
        :width: 400
        :height: 130

        width = 20
        height = 100
        value = 88

        imgui.begin("Example: vertical slider float")
        changed, values = imgui.v_slider_float(
            "vertical slider float",
            width, height, value,
            min_value=0, max_value=100,
            format="%0.3f", flags=imgui.SLIDER_FLAGS_NONE
        )
        imgui.text("Changed: %s, Values: %s" % (changed, values))
        imgui.end()

    Args:
        label (str): widget label.
        value (float): slider value.
        min_value (float): min value allowed by widget.
        max_value (float): max value allowed by widget.
        format (str): display format string as C-style ``printf``
            format string. **Warning:** highly unsafe.
            See :any:`slider_float()`.
        flags: SliderFlags flags. See:
            :ref:`list of available flags <slider-flag-options>`.

    Returns:
        tuple: a ``(changed, value)`` tuple that contains indicator of
        widget state change and the slider value.

    .. wraps::
        bool VSliderFloat(
            const char* label,
            const ImVec2& size,
            float v,
            float v_min,
            floatint v_max,
            const char* format = "%.3f",
            ImGuiSliderFlags flags = 0
        )
    """
    cdef float inout_value = value
    return cimgui.VSliderFloat(
        _bytes(label), _cast_args_ImVec2(width, height),
        <float*>&inout_value,
        min_value, max_value, _bytes(format), flags
    ), inout_value

def v_slider_int(
    str label,
    float width,
    float height,
    int value,
    int min_value,
    int max_value,
    str format = "%d",
    cimgui.ImGuiSliderFlags flags = 0
):
    """Display vertical int slider widget with the specified width and height.

    .. visual-example::
        :auto_layout:
        :width: 400
        :height: 130

        width = 20
        height = 100
        value = 88

        imgui.begin("Example: vertical slider int")
        changed, values = imgui.v_slider_int(
            "vertical slider int",
            width, height, value,
            min_value=0, max_value=100,
            format="%d"
        )
        imgui.text("Changed: %s, Values: %s" % (changed, values))
        imgui.end()

    Args:
        label (str): widget label.
        value (int): slider value.
        min_value (int): min value allowed by widget.
        max_value (int): max value allowed by widget.
        format (str): display format string as C-style ``printf``
            format string. **Warning:** highly unsafe.
            See :any:`slider_int()`.
        flags: SliderFlags flags. See:
            :ref:`list of available flags <slider-flag-options>`.

    Returns:
        tuple: a ``(changed, value)`` tuple that contains indicator of
        widget state change and the slider value.

    .. wraps::
        bool VSliderInt(
            const char* label,
            const ImVec2& size,
            int v,
            int v_min,
            int v_max,
            const char* format = "%.3f",
            ImGuiSliderFlags flags = 0
        )
    """
    cdef int inout_value = value
    return cimgui.VSliderInt(
        _bytes(label), _cast_args_ImVec2(width, height),
        <int*>&inout_value,
        min_value, max_value, _bytes(format), flags
    ), inout_value

#-------------------------------------------------------------------------
# [SECTION] Widgets: InputScalar, InputFloat, InputInt, etc.
#-------------------------------------------------------------------------
# - ImParseFormatFindStart() [Internal]
# - ImParseFormatFindEnd() [Internal]
# - ImParseFormatTrimDecorations() [Internal]
# - ImParseFormatPrecision() [Internal]
# - TempInputTextScalar() [Internal]
# - InputScalar()
# - InputScalarN()
# - InputFloat()
# - InputFloat2()
# - InputFloat3()
# - InputFloat4()
# - InputInt()
# - InputInt2()
# - InputInt3()
# - InputInt4()
# - InputDouble()
#-------------------------------------------------------------------------

def input_scalar(
    str label,
    cimgui.ImGuiDataType data_type,
    bytes data,
    bytes step = None,
    bytes step_fast = None,
    str format = None,
    cimgui.ImGuiInputTextFlags flags = 0):
    """Display scalar input widget.
    Data is passed via ``bytes`` and the type is separatelly given using ``data_type``.
    This is useful to work with specific types (e.g. unsigned 8bit integer, float, double)
    like when interfacing with Numpy.

    Args:
        label (str): widget label
        data_type: ImGuiDataType enum, type of the given data
        data (bytes): data value as a bytes array
        step (bytes): incremental step
        step_fast (bytes): fast incremental step
        format (str): format string
        flags: InputText flags. See:
            :ref:`list of available flags <inputtext-flag-options>`.

    Returns:
        tuple: a ``(changed, value)`` tuple that contains indicator of
        input state change and the current input content.

    .. wraps::
        bool InputScalar(
            const char* label,
            ImGuiDataType data_type,
            void* p_data,
            const void* p_step = NULL,
            const void* p_step_fast = NULL,
            const char* format = NULL,
            ImGuiInputTextFlags flags = 0
        )
    """

    cdef char* p_data = data
    cdef char* p_step = NULL
    if step is not None:
        p_step = step
    cdef char* p_step_fast = NULL
    if step_fast is not None:
        p_step_fast = step_fast
    cdef char* fmt = NULL
    cdef bytes fmt_data;
    if format is not None:
        fmt_data = _bytes(format)
        fmt = fmt_data

    cdef changed = cimgui.InputScalar(
        _bytes(label),
        data_type,
        p_data,
        p_step,
        p_step_fast,
        fmt,
        flags
    )

    return changed, data

def input_scalar_N(
    str label,
    cimgui.ImGuiDataType data_type,
    bytes data,
    int components,
    bytes step = None,
    bytes step_fast = None,
    str format = None,
    cimgui.ImGuiInputTextFlags flags = 0):
    """Display multiple scalar input widget.
    Data is passed via ``bytes`` and the type is separatelly given using ``data_type``.
    This is useful to work with specific types (e.g. unsigned 8bit integer, float, double)
    like when interfacing with Numpy.

    Args:
        label (str): widget label
        data_type: ImGuiDataType enum, type of the given data
        data (bytes): data value as a bytes array
        components (int): number of components to display
        step (bytes): incremental step
        step_fast (bytes): fast incremental step
        format (str): format string
        flags: InputText flags. See:
            :ref:`list of available flags <inputtext-flag-options>`.

    Returns:
        tuple: a ``(changed, value)`` tuple that contains indicator of
        input state change and the current input content.

    .. wraps::
        bool InputScalarN(
            const char* label,
            ImGuiDataType data_type,
            void* p_data,
            int components,
            const void* p_step = NULL,
            const void* p_step_fast = NULL,
            const char* format = NULL,
            ImGuiInputTextFlags flags = 0
        )
    """

    cdef char* p_data = data
    cdef char* p_step = NULL
    if step is not None:
        p_step = step
    cdef char* p_step_fast = NULL
    if step_fast is not None:
        p_step_fast = step_fast
    cdef char* fmt = NULL
    cdef bytes fmt_data;
    if format is not None:
        fmt_data = _bytes(format)
        fmt = fmt_data

    cdef changed = cimgui.InputScalarN(
        _bytes(label),
        data_type,
        p_data,
        components,
        p_step,
        p_step_fast,
        fmt,
        flags
    )

    return changed, data

def input_float(
    str label,
    float value,
    float step=0.0,
    float step_fast=0.0,
    str format = "%.3f",
    cimgui.ImGuiInputTextFlags flags=0
):
    """Display float input widget.

    .. visual-example::
        :auto_layout:
        :width: 400
        :height: 100

        float_val = 0.4
        imgui.begin("Example: float input")
        changed, float_val = imgui.input_float('Type coefficient:', float_val)
        imgui.text('You wrote: %f' % float_val)
        imgui.end()

    Args:
        label (str): widget label.
        value (float): textbox value
        step (float): incremental step
        step_fast (float): fast incremental step
        format = (str): format string
        flags: InputText flags. See:
            :ref:`list of available flags <inputtext-flag-options>`.

    Returns:
        tuple: a ``(changed, value)`` tuple that contains indicator of
        textbox state change and the current textbox content.

    .. wraps::
        bool InputFloat(
            const char* label,
            float* v,
            float step = 0.0f,
            float step_fast = 0.0f,
            const char* format = "%.3f",
            ImGuiInputTextFlags extra_flags = 0
        )
    """
    cdef float inout_value = value

    return cimgui.InputFloat(
        _bytes(label), &inout_value, step,
        step_fast, _bytes(format), flags
    ), inout_value

def input_float2(
    str label,
    float value0, float value1,
    str format = "%.3f",
    cimgui.ImGuiInputTextFlags flags=0
):
    """Display two-float input widget.

    .. visual-example::
        :auto_layout:
        :width: 400
        :height: 100

        values = 0.4, 3.2
        imgui.begin("Example: two float inputs")
        changed, values = imgui.input_float2('Type here:', *values)
        imgui.text("Changed: %s, Values: %s" % (changed, values))
        imgui.end()

    Args:
        label (str): widget label.
        value0, value1 (float): input values.
        format = (str): format string
        flags: InputText flags. See:
            :ref:`list of available flags <inputtext-flag-options>`.

    Returns:
        tuple: a ``(changed, values)`` tuple that contains indicator of
        textbox state change and the tuple of current values.

    .. wraps::
        bool InputFloat2(
            const char* label,
            float v[2],
            const char* format = "%.3f",
            ImGuiInputTextFlags extra_flags = 0
        )
    """
    cdef float[2] inout_values = [value0, value1]

    return cimgui.InputFloat2(
        _bytes(label), <float*>&inout_values,
        _bytes(format), flags
    ), (inout_values[0], inout_values[1])

def input_float3(
    str label,
    float value0, float value1, float value2,
    str format = "%.3f",
    cimgui.ImGuiInputTextFlags flags=0
):
    """Display three-float input widget.

    .. visual-example::
        :auto_layout:
        :width: 400
        :height: 100

        values = 0.4, 3.2, 29.3
        imgui.begin("Example: three float inputs")
        changed, values = imgui.input_float3('Type here:', *values)
        imgui.text("Changed: %s, Values: %s" % (changed, values))
        imgui.end()

    Args:
        label (str): widget label.
        value0, value1, value2 (float): input values.
        format = (str): format string
        flags: InputText flags. See:
            :ref:`list of available flags <inputtext-flag-options>`.

    Returns:
        tuple: a ``(changed, values)`` tuple that contains indicator of
        textbox state change and the tuple of current values.

    .. wraps::
        bool InputFloat3(
            const char* label,
            float v[3],
            const char* format = "%.3f",
            ImGuiInputTextFlags extra_flags = 0
        )
    """
    cdef float[3] inout_values = [value0, value1, value2]

    return cimgui.InputFloat3(
        _bytes(label), <float*>&inout_values,
        _bytes(format), flags
    ), (inout_values[0], inout_values[1], inout_values[2])

def input_float4(
    str label,
    float value0, float value1, float value2, float value3,
    str format = "%.3f",
    cimgui.ImGuiInputTextFlags flags=0
):
    """Display four-float input widget.

    .. visual-example::
        :auto_layout:
        :width: 400
        :height: 100

        values = 0.4, 3.2, 29.3, 12.9
        imgui.begin("Example: four float inputs")
        changed, values = imgui.input_float4('Type here:', *values)
        imgui.text("Changed: %s, Values: %s" % (changed, values))
        imgui.end()

    Args:
        label (str): widget label.
        value0, value1, value2, value3 (float): input values.
        format = (str): format string
        flags: InputText flags. See:
            :ref:`list of available flags <inputtext-flag-options>`.

    Returns:
        tuple: a ``(changed, values)`` tuple that contains indicator of
        textbox state change and the tuple of current values.

    .. wraps::
        bool InputFloat4(
            const char* label,
            float v[4],
            const char* format = "%.3f",
            ImGuiInputTextFlags extra_flags = 0
        )
    """
    cdef float[4] inout_values = [value0, value1, value2, value3]

    return cimgui.InputFloat4(
        _bytes(label), <float*>&inout_values,
        _bytes(format), flags
    ), (inout_values[0], inout_values[1], inout_values[2], inout_values[3])

def input_int(
    str label,
    int value,
    int step=1,
    int step_fast=100,
    cimgui.ImGuiInputTextFlags flags=0
):
    """Display integer input widget.

    .. visual-example::
        :auto_layout:
        :width: 400
        :height: 100

        int_val = 3
        imgui.begin("Example: integer input")
        changed, int_val = imgui.input_int('Type multiplier:', int_val)
        imgui.text('You wrote: %i' % int_val)
        imgui.end()

    Args:
        label (str): widget label.
        value (int): textbox value
        step (int): incremental step
        step_fast (int): fast incremental step
        flags: InputText flags. See:
            :ref:`list of available flags <inputtext-flag-options>`.

    Returns:
        tuple: a ``(changed, value)`` tuple that contains indicator of
        textbox state change and the current textbox content.

    .. wraps::
        bool InputInt(
            const char* label,
            int* v,
            int step = 1,
            int step_fast = 100,
            ImGuiInputTextFlags extra_flags = 0
        )
    """
    cdef int inout_value = value

    return cimgui.InputInt(
        _bytes(label), &inout_value, step, step_fast, flags
    ), inout_value


def input_int2(
    str label,
    int value0, int value1,
    cimgui.ImGuiInputTextFlags flags=0
):
    """Display two-integer input widget.

    .. visual-example::
        :auto_layout:
        :width: 400
        :height: 100

        values = 4, 12
        imgui.begin("Example: two int inputs")
        changed, values = imgui.input_int2('Type here:', *values)
        imgui.text("Changed: %s, Values: %s" % (changed, values))
        imgui.end()

    Args:
        label (str): widget label.
        value0, value1 (int): textbox values
        flags: InputText flags. See:
            :ref:`list of available flags <inputtext-flag-options>`.

    Returns:
        tuple: a ``(changed, value)`` tuple that contains indicator of
        textbox state change and the current textbox content.

    .. wraps::
        bool InputInt2(
            const char* label,
            int v[2],
            ImGuiInputTextFlags extra_flags = 0
        )
    """
    cdef int[2] inout_values = [value0, value1]

    return cimgui.InputInt2(
        _bytes(label), <int*>&inout_values, flags
    ), [inout_values[0], inout_values[1]]


def input_int3(
    str label,
    int value0, int value1, int value2,
    cimgui.ImGuiInputTextFlags flags=0
):
    """Display three-integer input widget.

    .. visual-example::
        :auto_layout:
        :width: 400
        :height: 100

        values = 4, 12, 28
        imgui.begin("Example: three int inputs")
        changed, values = imgui.input_int3('Type here:', *values)
        imgui.text("Changed: %s, Values: %s" % (changed, values))
        imgui.end()

    Args:
        label (str): widget label.
        value0, value1, value2 (int): textbox values
        flags: InputText flags. See:
            :ref:`list of available flags <inputtext-flag-options>`.

    Returns:
        tuple: a ``(changed, value)`` tuple that contains indicator of
        textbox state change and the current textbox content.

    .. wraps::
        bool InputInt3(
            const char* label,
            int v[3],
            ImGuiInputTextFlags extra_flags = 0
        )
    """
    cdef int[3] inout_values = [value0, value1, value2]

    return cimgui.InputInt3(
        _bytes(label), <int*>&inout_values, flags
    ), [inout_values[0], inout_values[1], inout_values[2]]


def input_int4(
    str label,
    int value0, int value1, int value2, int value3,
    cimgui.ImGuiInputTextFlags flags=0
):
    """Display four-integer input widget.

    .. visual-example::
        :auto_layout:
        :width: 400
        :height: 100

        values = 4, 12, 28, 73
        imgui.begin("Example: four int inputs")
        changed, values = imgui.input_int4('Type here:', *values)
        imgui.text("Changed: %s, Values: %s" % (changed, values))
        imgui.end()

    Args:
        label (str): widget label.
        value0, value1, value2, value3 (int): textbox values
        flags: InputText flags. See:
            :ref:`list of available flags <inputtext-flag-options>`.

    Returns:
        tuple: a ``(changed, value)`` tuple that contains indicator of
        textbox state change and the current textbox content.

    .. wraps::
        bool InputInt4(
            const char* label,
            int v[4],
            ImGuiInputTextFlags extra_flags = 0
        )
    """
    cdef int[4] inout_values = [value0, value1, value2, value3]

    return cimgui.InputInt4(
        _bytes(label), <int*>&inout_values, flags
    ), [inout_values[0], inout_values[1], inout_values[2], inout_values[3]]

def input_double(
    str label,
    double value,
    double step=0.0,
    double step_fast=0.0,
    str format = "%.6f",
    cimgui.ImGuiInputTextFlags flags=0
):
    """Display double input widget.

    .. visual-example::
        :auto_layout:
        :width: 400
        :height: 100

        double_val = 3.14159265358979323846
        imgui.begin("Example: double input")
        changed, double_val = imgui.input_double('Type multiplier:', double_val)
        imgui.text('You wrote: %i' % double_val)
        imgui.end()

    Args:
        label (str): widget label.
        value (double): textbox value
        step (double): incremental step
        step_fast (double): fast incremental step
        format = (str): format string
        flags: InputText flags. See:
            :ref:`list of available flags <inputtext-flag-options>`.

    Returns:
        tuple: a ``(changed, value)`` tuple that contains indicator of
        textbox state change and the current textbox content.

    .. wraps::
        bool InputDouble(
            const char* label,
            double* v,
            double step = 0.0,
            double step_fast = 0.0,
            _bytes(format),
            ImGuiInputTextFlags extra_flags = 0
        )
    """
    cdef double inout_value = value

    return cimgui.InputDouble(
        _bytes(label), &inout_value, step, step_fast, _bytes(format), flags
    ), inout_value

#-------------------------------------------------------------------------
# [SECTION] Widgets: InputText, InputTextMultiline, InputTextWithHint
#-------------------------------------------------------------------------
# - InputText()
# - InputTextWithHint()
# - InputTextMultiline()
# - InputTextEx() [Internal]
#-------------------------------------------------------------------------

def input_text(
    str label,
    str value,
    int buffer_length = -1,
    cimgui.ImGuiInputTextFlags flags=0,
    object callback = None,
    user_data = None
):
    """Display text input widget.

    The ``buffer_length`` is the maximum allowed length of the content. It is the size in bytes, which may not correspond to the number of characters.
    If set to -1, the internal buffer will have an adaptive size, which is equivalent to using the ``imgui.INPUT_TEXT_CALLBACK_RESIZE`` flag.
    When a callback is provided, it is called after the internal buffer has been resized.

    .. visual-example::
        :auto_layout:
        :width: 400
        :height: 100

        text_val = 'Please, type the coefficient here.'
        imgui.begin("Example: text input")
        changed, text_val = imgui.input_text('Coefficient:', text_val)
        imgui.text('You wrote:')
        imgui.same_line()
        imgui.text(text_val)
        imgui.end()

    Args:
        label (str): widget label.
        value (str): textbox value
        buffer_length (int): length of the content buffer
        flags: InputText flags. See:
            :ref:`list of available flags <inputtext-flag-options>`.
        callback (callable): a callable that is called depending on choosen flags.
            Callable takes an imgui._ImGuiInputTextCallbackData object as argument
            Callable should return None or integer
        user_data: Any data that the user want to use in the callback.

    Returns:
        tuple: a ``(changed, value)`` tuple that contains indicator of
        textbox state change and the current text contents.

    .. wraps::
        bool InputText(
            const char* label,
            char* buf,
            size_t buf_size,
            ImGuiInputTextFlags flags = 0,
            ImGuiInputTextCallback callback = NULL,
            void* user_data = NULL
        )
    """

    _value_bytes = _bytes(value)
    cdef int _buffer_length = buffer_length+1
    if buffer_length < 0:
        _buffer_length = len(_value_bytes)+1
        flags = flags | enums.ImGuiInputTextFlags_CallbackResize
    _input_text_shared_buffer.reserve_memory(_buffer_length)
    strncpy(_input_text_shared_buffer.buffer, _value_bytes, _buffer_length)

    cdef _callback_user_info _user_info = _callback_user_info()
    cdef cimgui.ImGuiInputTextCallback _callback = NULL
    cdef void *_user_data = NULL
    if callback is not None:
        _callback = _ImGuiInputTextCallback
        _user_info.populate(callback, user_data)
        _user_data = <void*>_user_info
    elif flags & enums.ImGuiInputTextFlags_CallbackResize:
        _callback = _ImGuiInputTextOnlyResizeCallback
        _user_data = <void*>_user_info

    changed = cimgui.InputText(
        _bytes(label), _input_text_shared_buffer.buffer, _buffer_length, flags, _callback, _user_data
    )
    _buffer_length = strlen(_input_text_shared_buffer.buffer)
    output = _from_bytes(_input_text_shared_buffer.buffer[:_buffer_length])

    return changed, output

def input_text_multiline(
    str label,
    str value,
    int buffer_length = -1,
    float width=0,
    float height=0,
    cimgui.ImGuiInputTextFlags flags=0,
    object callback = None,
    user_data = None
):
    """Display multiline text input widget.

    The ``buffer_length`` is the maximum allowed length of the content. It is the size in bytes, which may not correspond to the number of characters.
    If set to -1, the internal buffer will have an adaptive size, which is equivalent to using the ``imgui.INPUT_TEXT_CALLBACK_RESIZE`` flag.
    When a callback is provided, it is called after the internal buffer has been resized.

    .. visual-example::
        :auto_layout:
        :width: 400
        :height: 200

        text_val = 'Type the your message here.'
        imgui.begin("Example: text input")
        changed, text_val = imgui.input_text_multiline(
            'Message:',
            text_val,
            2056
        )
        imgui.text('You wrote:')
        imgui.same_line()
        imgui.text(text_val)
        imgui.end()

    Args:
        label (str): widget label.
        value (str): textbox value
        buffer_length (int): length of the content buffer
        width (float): width of the textbox
        height (float): height of the textbox
        flags: InputText flags. See:
            :ref:`list of available flags <inputtext-flag-options>`.
        callback (callable): a callable that is called depending on choosen flags.
            Callable takes an imgui._ImGuiInputTextCallbackData object as argument
            Callable should return None or integer
        user_data: Any data that the user want to use in the callback.

    Returns:
        tuple: a ``(changed, value)`` tuple that contains indicator of
        textbox state change and the current text contents.

    .. wraps::
        bool InputTextMultiline(
            const char* label,
            char* buf,
            size_t buf_size,
            const ImVec2& size = ImVec2(0,0),
            ImGuiInputTextFlags flags = 0,
            ImGuiInputTextCallback callback = NULL,
            void* user_data = NULL
        )
    """

    _value_bytes = _bytes(value)
    cdef int _buffer_length = buffer_length+1
    if buffer_length < 0:
        _buffer_length = len(_value_bytes)+1
        flags = flags | enums.ImGuiInputTextFlags_CallbackResize
    _input_text_shared_buffer.reserve_memory(_buffer_length)
    strncpy(_input_text_shared_buffer.buffer, _value_bytes, _buffer_length)

    cdef _callback_user_info _user_info = _callback_user_info()
    cdef cimgui.ImGuiInputTextCallback _callback = NULL
    cdef void *_user_data = NULL
    if callback is not None:
        _callback = _ImGuiInputTextCallback
        _user_info.populate(callback, user_data)
        _user_data = <void*>_user_info
    elif flags & enums.ImGuiInputTextFlags_CallbackResize:
        _callback = _ImGuiInputTextOnlyResizeCallback
        _user_data = <void*>_user_info

    changed = cimgui.InputTextMultiline(
        _bytes(label), _input_text_shared_buffer.buffer, _buffer_length,
        _cast_args_ImVec2(width, height), flags,
        _callback, _user_data
    )
    _buffer_length = strlen(_input_text_shared_buffer.buffer)
    output = _from_bytes(_input_text_shared_buffer.buffer[:_buffer_length])

    return changed, output

def input_text_with_hint(
    str label,
    str hint,
    str value,
    int buffer_length = -1,
    cimgui.ImGuiInputTextFlags flags = 0,
    object callback = None,
    user_data = None):
    """Display a text box, if the text is empty a hint on how to fill the box is given.

    The ``buffer_length`` is the maximum allowed length of the content. It is the size in bytes, which may not correspond to the number of characters.
    If set to -1, the internal buffer will have an adaptive size, which is equivalent to using the ``imgui.INPUT_TEXT_CALLBACK_RESIZE`` flag.
    When a callback is provided, it is called after the internal buffer has been resized.

    Args:
        label (str): Widget label
        hing (str): Hint displayed if text value empty
        value (str): Text value
        buffer_length (int): Length of the content buffer
        flags: InputText flags. See:
            :ref:`list of available flags <inputtext-flag-options>`.
        callback (callable): a callable that is called depending on choosen flags.
            Callable takes an imgui._ImGuiInputTextCallbackData object as argument
            Callable should return None or integer
        user_data: Any data that the user want to use in the callback.

    Returns:
        tuple: a ``(changed, value)`` tuple that contains indicator of
        textbox state change and the current text contents.

    .. visual-example::
        :auto_layout:
        :width: 400
        :height: 200

        text_val = ''
        imgui.begin("Example Text With hing")
        changed, text_val = imgui.input_text_with_hint(
            'Email', 'your@email.com',
            text_val, 255)
        imgui.end()

    .. wraps::
        bool InputTextWithHint(
            const char* label,
            const char* hint,
            char* buf,
            size_t buf_size,
            ImGuiInputTextFlags flags = 0,
            ImGuiInputTextCallback callback = NULL,
            void* user_data = NULL
        )
    """

    _value_bytes = _bytes(value)
    cdef int _buffer_length = buffer_length+1
    if buffer_length < 0:
        _buffer_length = len(_value_bytes)+1
        flags = flags | enums.ImGuiInputTextFlags_CallbackResize
    _input_text_shared_buffer.reserve_memory(_buffer_length)
    strncpy(_input_text_shared_buffer.buffer, _value_bytes, _buffer_length)

    cdef _callback_user_info _user_info = _callback_user_info()
    cdef cimgui.ImGuiInputTextCallback _callback = NULL
    cdef void *_user_data = NULL
    if callback is not None:
        _callback = _ImGuiInputTextCallback
        _user_info.populate(callback, user_data)
        _user_data = <void*>_user_info
    elif flags & enums.ImGuiInputTextFlags_CallbackResize:
        _callback = _ImGuiInputTextOnlyResizeCallback
        _user_data = <void*>_user_info

    changed = cimgui.InputTextWithHint(
        _bytes(label), _bytes(hint), _input_text_shared_buffer.buffer, _buffer_length,
        flags, _callback, _user_data
    )
    _buffer_length = strlen(_input_text_shared_buffer.buffer)
    output = _from_bytes(_input_text_shared_buffer.buffer[:_buffer_length])

    return changed, output

cdef int _ImGuiInputTextCallback(cimgui.ImGuiInputTextCallbackData* data):
    cdef _ImGuiInputTextCallbackData callback_data = _ImGuiInputTextCallbackData.from_ptr(data)
    callback_data._require_pointer()
    
    if data.EventFlag == enums.ImGuiInputTextFlags_CallbackResize:
        if data.BufSize != _input_text_shared_buffer.size:
            _input_text_shared_buffer.reserve_memory(data.BufSize)
            data.Buf = _input_text_shared_buffer.buffer

    cdef ret = (<_callback_user_info>callback_data._ptr.UserData).callback_fn(callback_data)
    return ret if ret is not None else 0

cdef int _ImGuiInputTextOnlyResizeCallback(cimgui.ImGuiInputTextCallbackData* data):
    # This callback is used internally if user asks for buffer resizing but does not provide any python callback function.

    if data.EventFlag == enums.ImGuiInputTextFlags_CallbackResize:
        if data.BufSize != _input_text_shared_buffer.size:
            _input_text_shared_buffer.reserve_memory(data.BufSize)
            data.Buf = _input_text_shared_buffer.buffer

    return 0
    
cdef class _ImGuiInputTextCallbackData(object):
    
    cdef cimgui.ImGuiInputTextCallbackData* _ptr

    def __init__(self):
        pass

    @staticmethod
    cdef from_ptr(cimgui.ImGuiInputTextCallbackData* ptr):
        if ptr == NULL:
            return None

        instance = _ImGuiInputTextCallbackData()
        instance._ptr = ptr
        return instance

    def _require_pointer(self):
        if self._ptr == NULL:
            raise RuntimeError(
                "%s improperly initialized" % self.__class__.__name__
            )

        return self._ptr != NULL
        
    @property
    def event_flag(self):
        self._require_pointer()
        return self._ptr.EventFlag
    
    @property
    def flags(self):
        self._require_pointer()
        return self._ptr.Flags
        
    @property
    def user_data(self):
        self._require_pointer()
        return (<_callback_user_info>self._ptr.UserData).user_data
    
    @property
    def event_char(self):
        self._require_pointer()
        return chr(self._ptr.EventChar)
    
    @event_char.setter
    def event_char(self, str event_char):
        self._require_pointer()
        self._ptr.EventChar = ord(event_char)
    
    @property
    def event_key(self):
        self._require_pointer()
        return self._ptr.EventKey
    
    @property
    def buffer(self):
        self._require_pointer()
        return _from_bytes(self._ptr.Buf)
    
    @buffer.setter
    def buffer(self, str buffer):
        self._require_pointer()
        _buffer = _bytes(buffer)
        _buffer_length = len(_buffer)
        if _buffer_length < self._ptr.BufSize:
            # Note: When copying several characters at once, there is this
            #       one frame where _ptr.BufSize is not yet updated (bug?).
            #       thus we skip it here.
            strncpy(self._ptr.Buf, _buffer, _buffer_length)
            self._ptr.BufTextLen = _buffer_length
            self._ptr.BufDirty = True

    @property
    def buffer_text_length(self):
        self._require_pointer()
        return self._ptr.BufTextLen
    
    @property
    def buffer_size(self):
        self._require_pointer()
        return self._ptr.BufSize
    
    @property
    def buffer_dirty(self):
        self._require_pointer()
        return self._ptr.BufDirty
        
    @buffer_dirty.setter
    def buffer_dirty(self, bool dirty):
        self._require_pointer()
        self._ptr.BufDirty = dirty
    
    @property
    def cursor_pos(self):
        self._require_pointer()
        return self._ptr.CursorPos
        
    @cursor_pos.setter
    def cursor_pos(self, int pos):
        self._require_pointer()
        self._ptr.CursorPos = pos
    
    @property
    def selection_start(self):
        self._require_pointer()
        return self._ptr.SelectionStart
        
    @selection_start.setter
    def selection_start(self, int start):
        self._require_pointer()
        self._ptr.SelectionStart = start
    
    @property
    def selection_end(self):
        self._require_pointer()
        return self._ptr.SelectionEnd
        
    @selection_end.setter
    def selection_end(self, int end):
        self._require_pointer()
        self._ptr.SelectionEnd = end
    
    def delete_chars(self, int pos, int bytes_count):
        self._require_pointer()
        self._ptr.DeleteChars(pos, bytes_count)
        
    def insert_chars(self, int pos, str text):
        self._require_pointer()
        self._ptr.InsertChars(pos, _bytes(text))
    
    def select_all(self):
        self._require_pointer()
        self._ptr.SelectAll()
    
    def clear_selection(self):
        self._require_pointer()
        self._ptr.ClearSelection()
        
    def has_selection(self):
        self._require_pointer()
        return self._ptr.HasSelection()

#-------------------------------------------------------------------------
# [SECTION] Widgets: ColorEdit, ColorPicker, ColorButton, etc.
#-------------------------------------------------------------------------
# - ColorEdit3()
# - ColorEdit4()
# - ColorPicker3()
# - RenderColorRectWithAlphaCheckerboard() [Internal]
# - ColorPicker4()
# - ColorButton()
# - SetColorEditOptions()
# - ColorTooltip() [Internal]
# - ColorEditOptionsPopup() [Internal]
# - ColorPickerOptionsPopup() [Internal]
#-------------------------------------------------------------------------

def color_edit3(str label, float r, float g, float b, cimgui.ImGuiColorEditFlags flags = 0):
    """Display color edit widget for color without alpha value.

    .. visual-example::
        :auto_layout:
        :width: 300

        # note: the variable that contains the color data, should be initialized
        #       outside of the main interaction loop
        color_1 = 1., .0, .5
        color_2 = 0., .8, .3

        imgui.begin("Example: color edit without alpha")

        # note: first element of return two-tuple notifies if the color was changed
        #       in currently processed frame and second element is current value
        #       of color
        changed, color_1 = imgui.color_edit3("Color 1", *color_1)
        changed, color_2 = imgui.color_edit3("Color 2", *color_2)

        imgui.end()

    Args:
        label (str): color edit label.
        r (float): red color intensity.
        g (float): green color intensity.
        b (float): blue color instensity.
        flags (ImGuiColorEditFlags): Color edit flags.  Zero for none.

    Returns:
        tuple: a ``(bool changed, float color[3])`` tuple that contains indicator of color
        change and current value of color

    .. wraps::
        bool ColorEdit3(const char* label, float col[3], ImGuiColorEditFlags flags = 0)
    """

    cdef float[3] inout_color = [r, g, b]

    return cimgui.ColorEdit3(
        _bytes(label), <float *>(&inout_color), flags
    ), (inout_color[0], inout_color[1], inout_color[2])


def color_edit4(str label, float r, float g, float b, float a, cimgui.ImGuiColorEditFlags flags = 0):
    """Display color edit widget for color with alpha value.

    .. visual-example::
        :auto_layout:
        :width: 400

        # note: the variable that contains the color data, should be initialized
        #       outside of the main interaction loop
        color = 1., .0, .5, 1.

        imgui.begin("Example: color edit with alpha")

        # note: first element of return two-tuple notifies if the color was changed
        #       in currently processed frame and second element is current value
        #       of color and alpha
        _, color = imgui.color_edit4("Alpha", *color)
        _, color = imgui.color_edit4("No alpha", *color, imgui.COLOR_EDIT_NO_ALPHA)

        imgui.end()

    Args:
        label (str): color edit label.
        r (float): red color intensity.
        g (float): green color intensity.
        b (float): blue color instensity.
        a (float): alpha intensity.
        flags (ImGuiColorEditFlags): Color edit flags.  Zero for none.

    Returns:
        tuple: a ``(bool changed, float color[4])`` tuple that contains indicator of color
        change and current value of color and alpha

    .. wraps::
        ColorEdit4(
            const char* label, float col[4], ImGuiColorEditFlags flags
        )
    """
    cdef float[4] inout_color = [r, g, b, a]

    return cimgui.ColorEdit4(
        _bytes(label), <float *>(&inout_color), flags
    ), (inout_color[0], inout_color[1], inout_color[2], inout_color[3])

def color_button(
        str desc_id,
        float r, float g, float b, a=1.,
        flags=0,
        float width=0, float height=0,
):
    """Display colored button.

    .. visual-example::
        :auto_layout:
        :height: 150

        imgui.begin("Example: color button")
        imgui.color_button("Button 1", 1, 0, 0, 1, 0, 10, 10)
        imgui.color_button("Button 2", 0, 1, 0, 1, 0, 10, 10)
        imgui.color_button("Wide Button", 0, 0, 1, 1, 0, 20, 10)
        imgui.color_button("Tall Button", 1, 0, 1, 1, 0, 10, 20)
        imgui.end()

    Args:
        #r (float): red color intensity.
        #g (float): green color intensity.
        #b (float): blue color instensity.
        #a (float): alpha intensity.
        #ImGuiColorEditFlags: Color edit flags.  Zero for none.
        #width (float): Width of the color button
        #height (float): Height of the color button

    Returns:
        bool: True if button is clicked.

    .. wraps::
        bool ColorButton(
            const char* desc_id,
            const ImVec4& col,
            ImGuiColorEditFlags flags,
            ImVec2 size
        )
    """
    return cimgui.ColorButton(
        _bytes(desc_id), _cast_args_ImVec4(r, g, b, a), flags, _cast_args_ImVec2(width, height)
    )

#-------------------------------------------------------------------------
# [SECTION] Widgets: TreeNode, CollapsingHeader, etc.
#-------------------------------------------------------------------------
# - TreeNode()
# - TreeNodeV()
# - TreeNodeEx()
# - TreeNodeExV()
# - TreeNodeBehavior() [Internal]
# - TreePush()
# - TreePop()
# - GetTreeNodeToLabelSpacing()
# - SetNextItemOpen()
# - CollapsingHeader()
#-------------------------------------------------------------------------

def tree_node(str text, cimgui.ImGuiTreeNodeFlags flags=0):
    """Draw a tree node.

    Returns 'true' if the node is drawn, call :func:`tree_pop()` to finish.

    .. visual-example::
        :auto_layout:
        :height: 100
        :width: 200
        :click: 80 40

        imgui.begin("Example: tree node")
        if imgui.tree_node("Expand me!", imgui.TREE_NODE_DEFAULT_OPEN):
            imgui.text("Lorem Ipsum")
            imgui.tree_pop()
        imgui.end()

    Args:
        text (str): Tree node label
        flags: TreeNode flags. See:
            :ref:`list of available flags <treenode-flag-options>`.

    Returns:
        bool: True if tree node is displayed (opened).

    .. wraps::
        bool TreeNode(const char* label)
        bool TreeNodeEx(const char* label, ImGuiTreeNodeFlags flags = 0)
    """
    return cimgui.TreeNodeEx(_bytes(text), flags)

def tree_pop():
    """Called to clear the tree nodes stack and return back the identation.

    For a tree example see :func:`tree_node()`.
    Same as calls to :func:`unindent()` and :func:`pop_id()`.

    .. wraps::
        void TreePop()
    """
    cimgui.TreePop()

def get_tree_node_to_label_spacing():
    """Horizontal distance preceding label when using ``tree_node*()``
    or ``bullet() == (g.FontSize + style.FramePadding.x*2)`` for a
    regular unframed TreeNode

    Returns:
        float: spacing

    .. visual-example::
        :auto_layout:
        :height: 100
        :width: 200

        imgui.begin("TreeNode")
        imgui.text("<- 0px offset here")
        if imgui.tree_node("Expand me!", imgui.TREE_NODE_DEFAULT_OPEN):
            imgui.text("<- %.2fpx offset here" % imgui.get_tree_node_to_label_spacing())
            imgui.tree_pop()
        imgui.end()

    .. wraps::
        float GetTreeNodeToLabelSpacing()
    """
    return cimgui.GetTreeNodeToLabelSpacing()

def set_next_item_open(bool is_open, cimgui.ImGuiCond condition = 0):
    """Set next TreeNode/CollapsingHeader open state.

    Args:
        is_open (bool):
        condition (:ref:`condition flag <condition-options>`): defines on which
            condition value should be set. Defaults to :any:`imgui.NONE`.

    .. wraps::
        void SetNextItemOpen(bool is_open, ImGuiCond cond = 0)
    """
    cimgui.SetNextItemOpen(is_open, condition)

def collapsing_header(
    str text,
    visible=None,
    cimgui.ImGuiTreeNodeFlags flags=0
):
    """Collapsable/Expandable header view.

    Returns 'true' if the header is open. Doesn't indent or push to stack,
    so no need to call any pop function.

    .. visual-example::
        :auto_layout:
        :height: 100
        :width: 200
        :click: 80 40

        visible = True

        imgui.begin("Example: collapsing header")
        expanded, visible = imgui.collapsing_header("Expand me!", visible)

        if expanded:
            imgui.text("Now you see me!")
        imgui.end()

    Args:
        text (str): Tree node label
        visible (bool or None): Force visibility of a header. If set to True
            shows additional (X) close button. If set to False header is not
            visible at all. If set to None header is always visible and close
            button is not displayed.
        flags: TreeNode flags. See:
            :ref:`list of available flags <treenode-flag-options>`.

    Returns:
        tuple: a ``(expanded, visible)`` two-tuple indicating if item was
        expanded and whether the header is visible or not (only if ``visible``
        input argument is True/False).

    .. wraps::
        bool CollapsingHeader(const char* label, ImGuiTreeNodeFlags flags = 0)

        bool CollapsingHeader(
            const char* label,
            bool* p_visible,
            ImGuiTreeNodeFlags flags = 0
        )
    """
    cdef cimgui.bool inout_opened = visible
    if visible is None:
        clicked = cimgui.CollapsingHeader(_bytes(text), NULL, flags)
    else:
        clicked = cimgui.CollapsingHeader(_bytes(text), &inout_opened, flags)
    return clicked, None if visible is None else inout_opened

#-------------------------------------------------------------------------
# [SECTION] Widgets: Selectable
#-------------------------------------------------------------------------
# - Selectable()
#-------------------------------------------------------------------------

def selectable(
    str label,
    selected=False,
    cimgui.ImGuiTreeNodeFlags flags=0,
    width=0,
    height=0
):
    """Selectable text. Returns 'true' if the item is pressed.

    Width of 0.0 will use the available width in the parent container.
    Height of 0.0 will use the available height in the parent container.

    .. visual-example::
        :auto_layout:
        :height: 200
        :width: 200
        :click: 80 40

        selected = [False, False]
        imgui.begin("Example: selectable")
        _, selected[0] = imgui.selectable(
            "1. I am selectable", selected[0]
        )
        _, selected[1] = imgui.selectable(
            "2. I am selectable too", selected[1]
        )
        imgui.text("3. I am not selectable")
        imgui.end()

    Args:
        label (str): The label.
        selected (bool): defines if item is selected or not.
        flags: Selectable flags. See:
            :ref:`list of available flags <selectable-flag-options>`.
        width (float): button width.
        height (float): button height.

    Returns:
        tuple: a ``(opened, selected)`` two-tuple indicating if item was
        clicked by the user and the current state of item.

    .. wraps::
        bool Selectable(
            const char* label,
            bool selected = false,
            ImGuiSelectableFlags flags = 0,
            const ImVec2& size = ImVec2(0,0)
        )

        bool Selectable(
            const char* label,
            bool* selected,
            ImGuiSelectableFlags flags = 0,
            const ImVec2& size = ImVec2(0,0)
        )
    """
    cdef cimgui.bool inout_selected = selected
    return cimgui.Selectable(
        _bytes(label),
        &inout_selected,
        flags,
        _cast_args_ImVec2(width, height)), inout_selected

#-------------------------------------------------------------------------
# [SECTION] Widgets: ListBox
#-------------------------------------------------------------------------
# - BeginListBox()
# - EndListBox()
# - ListBox()
#-------------------------------------------------------------------------

cdef class _BeginEndListBox(object):
    """
    Return value of :func:`begin_list_box` exposing ``opened`` boolean attribute.
    See :func:`begin_list_box` for an explanation and examples.

    Can be used as a context manager (in a ``with`` statement) to automatically call :func:`end_list_box`
    (if necessary) to end the list box created with :func:`begin_list_box` when the block ends,
    even if an exception is raised.

    This class is not intended to be instantiated by the user (thus the `_` name prefix).
    It should be obtained as the return value of the :func:`begin_list_box` function.
    """

    cdef readonly bool opened

    def __cinit__(self, bool opened):
        self.opened = opened

    def __enter__(self):
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        if self.opened:
            cimgui.EndListBox()

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


def begin_list_box(
    str label,
    width = 0,
    height = 0
):
    """Open a framed scrolling region.

    For use if you want to reimplement :func:`listbox` with custom data
    or interactions. You need to call :func:`end_list_box` at the end
    if ``opened`` is True, or use ``with`` to do so automatically.

    .. visual-example::
        :auto_layout:
        :height: 200
        :width: 200
        :click: 80 40

        with imgui.begin("Example: custom listbox"):
            with imgui.begin_list_box("List", 200, 100) as list_box:
                if list_box.opened:
                    imgui.selectable("Selected", True)
                    imgui.selectable("Not Selected", False)

    Example::
        imgui.begin("Example: custom listbox")

        if imgui.begin_list_box("List", 200, 100).opened:

            imgui.selectable("Selected", True)
            imgui.selectable("Not Selected", False)

            imgui.end_list_box()

        imgui.end()

    Args:
        label (str): The label.
        width (float): Button width. w > 0.0f: custom; w < 0.0f or -FLT_MIN: right-align; w = 0.0f (default): use current ItemWidth
        height (float): Button height. h > 0.0f: custom; h < 0.0f or -FLT_MIN: bottom-align; h = 0.0f (default): arbitrary default height which can fit ~7 items

    Returns:
        _BeginEndListBox: Use ``opened`` bool attribute to tell if the item is opened or closed.
        Only call :func:`end_list_box` if ``opened`` is True.
        Use with ``with`` to automatically call :func:`end_list_box` if necessary when the block ends.

    .. wraps::
        bool BeginListBox(
            const char* label,
            const ImVec2& size = ImVec2(0,0)
        )

    """
    return _BeginEndListBox.__new__(
        _BeginEndListBox,
        cimgui.BeginListBox(
            _bytes(label),
            _cast_args_ImVec2(width, height)
        )
    )

def listbox_header( # OBSOLETED in 1.81 (from February 2021)
    str label,
    width=0,
    height=0
):
    """*Obsoleted in imgui v1.81 from February 2021, refer to :func:`begin_list_box()`*

    For use if you want to reimplement :func:`listbox()` with custom data
    or interactions. You need to call :func:`listbox_footer()` at the end.

    Args:
        label (str): The label.
        width (float): button width.
        height (float): button height.

    Returns:
        opened (bool): If the item is opened or closed.

    .. wraps::
        bool ListBoxHeader(
            const char* label,
            const ImVec2& size = ImVec2(0,0)
        )
    """
    return begin_list_box(label, width, height)

def end_list_box():
    """

    Closing the listbox, previously opened by :func:`begin_list_box()`.
    Only call if ``begin_list_box().opened`` is True.

    See :func:`begin_list_box()` for usage example.

    .. wraps::
        void EndListBox()
    """
    cimgui.EndListBox()

def listbox(
    str label,
    int current,
    list items,
    int height_in_items=-1
):
    """Show listbox widget.

    .. visual-example::
        :auto_layout:
        :height: 100
        :width: 200

        current = 2
        imgui.begin("Example: listbox widget")

        clicked, current = imgui.listbox(
            "List", current, ["first", "second", "third"]
        )

        imgui.end()

    Args:
        label (str): The label.
        current (int): index of selected item.
        items (list): list of string labels for items.
        height_in_items (int): height of dropdown in items. Defaults to -1
            (autosized).

    Returns:
        tuple: a ``(changed, current)`` tuple indicating change of selection
        and current index of selected item.

    .. wraps::
        bool ListBox(
            const char* label,
            int* current_item,
            const char* items[],
            int items_count,
            int height_in_items = -1
        )

    """

    cdef int inout_current = current
    cdef const char** in_items = <const char**> malloc(len(items) * sizeof(char*))

    for index, item in enumerate(items):
        in_items[index] = strdup(_bytes(item))

    opened = cimgui.ListBox(
        _bytes(label),
        &inout_current,
        in_items,
        <int>len(items),
        height_in_items
    )

    for i in range(len(items)):
        free(<char*>in_items[i])

    free(in_items)

    return opened, inout_current

def listbox_footer(): # OBSOLETED in 1.81 (from February 2021)
    """*Obsoleted in imgui v1.81 from February 2021, refer to :func:`end_list_box()`*

    Closing the listbox, previously opened by :func:`listbox_header()`.

    See :func:`listbox_header()` for usage example.

    .. wraps::
        void ListBoxFooter()
    """
    end_list_box()

#-------------------------------------------------------------------------
# [SECTION] Widgets: PlotLines, PlotHistogram
#-------------------------------------------------------------------------
# - PlotEx() [Internal]
# - PlotLines()
# - PlotHistogram()
#-------------------------------------------------------------------------
# Plot/Graph widgets are not very good.
# Consider writing your own, or using a third-party one, see:
# - ImPlot https:# - others https:#-------------------------------------------------------------------------

def plot_lines(
        str label not None,
        const float[:] values not None,
        int values_count  = -1,
        int values_offset = 0,
        str overlay_text = None,
        float scale_min = FLOAT_MAX,
        float scale_max = FLOAT_MAX,
        graph_size = (0, 0),
        int stride = sizeof(float),
    ):

    """
    Plot a 1D array of float values.

    Args:
        label (str): A plot label that will be displayed on the plot's right
            side. If you want the label to be invisible, add :code:`"##"`
            before the label's text: :code:`"my_label" -> "##my_label"`

        values (array of floats): the y-values.
            It must be a type that supports Cython's Memoryviews,
            (See: http://docs.cython.org/en/latest/src/userguide/memoryviews.html)
            for example a numpy array.

        overlay_text (str or None, optional): Overlay text.

        scale_min (float, optional): y-value at the bottom of the plot.
        scale_max (float, optional): y-value at the top of the plot.

        graph_size (tuple of two floats, optional): plot size in pixels.
            **Note:** In ImGui 1.49, (-1,-1) will NOT auto-size the plot.
            To do that, use :func:`get_content_region_available` and pass
            in the right size.

    **Note:** These low-level parameters are exposed if needed for
    performance:

    * **values_offset** (*int*): Index of first element to display
    * **values_count** (*int*): Number of values to display. -1 will use the
        entire array.
    * **stride** (*int*): Number of bytes to move to read next element.

    .. visual-example::
        :auto_layout:
        :width: 400
        :height: 130

        from array import array
        from math import sin
        # NOTE: this example will not work under py27 due do incompatible
        # implementation of array and memoryview().
        plot_values = array('f', [sin(x * 0.1) for x in range(100)])

        imgui.begin("Plot example")
        imgui.plot_lines("Sin(t)", plot_values)
        imgui.end()

    .. wraps::
            void PlotLines(
                const char* label, const float* values, int values_count,

                int values_offset = 0,
                const char* overlay_text = NULL,
                float scale_min = FLT_MAX,
                float scale_max = FLT_MAX,
                ImVec2 graph_size = ImVec2(0,0),
                int stride = sizeof(float)
            )
    """
    if values_count == -1:
        values_count = <int>values.shape[0]

    # Would be nicer as something like
    #   _bytes(overlay_text) if overlay_text is not None else NULL
    # but then Cython complains about either types or pointers to temporary references.
    cdef const char* overlay_text_ptr = NULL
    cdef bytes overlay_text_b
    if overlay_text is not None:
        overlay_text_b = _bytes(overlay_text) # must be assigned to a variable
        overlay_text_ptr = overlay_text_b # auto-convert bytes to char*

    cimgui.PlotLines(
        _bytes(label), &values[0], values_count,
        values_offset,
        overlay_text_ptr,
        scale_min, scale_max,
        _cast_tuple_ImVec2(graph_size),
        stride
    )

def plot_histogram(
        str label not None,
        const float[:] values not None,
        int values_count  = -1,
        int values_offset = 0,
        str overlay_text = None,
        float scale_min = FLT_MAX,
        float scale_max = FLT_MAX,
        graph_size = (0, 0),
        int stride = sizeof(float),
    ):
    """
    Plot a histogram of float values.

    Args:
        label (str): A plot label that will be displayed on the plot's right
            side. If you want the label to be invisible, add :code:`"##"`
            before the label's text: :code:`"my_label" -> "##my_label"`

        values (array of floats): the y-values.
            It must be a type that supports Cython's Memoryviews,
            (See: http://docs.cython.org/en/latest/src/userguide/memoryviews.html)
            for example a numpy array.

        overlay_text (str or None, optional): Overlay text.

        scale_min (float, optional): y-value at the bottom of the plot.
        scale_max (float, optional): y-value at the top of the plot.

        graph_size (tuple of two floats, optional): plot size in pixels.
            **Note:** In ImGui 1.49, (-1,-1) will NOT auto-size the plot.
            To do that, use :func:`get_content_region_available` and pass
            in the right size.

    **Note:** These low-level parameters are exposed if needed for
    performance:

    * **values_offset** (*int*): Index of first element to display
    * **values_count** (*int*): Number of values to display. -1 will use the
        entire array.
    * **stride** (*int*): Number of bytes to move to read next element.

    .. visual-example::
        :auto_layout:
        :width: 400
        :height: 130

        from array import array
        from random import random

        # NOTE: this example will not work under py27 due do incompatible
        # implementation of array and memoryview().
        histogram_values = array('f', [random() for _ in range(20)])

        imgui.begin("Plot example")
        imgui.plot_histogram("histogram(random())", histogram_values)
        imgui.end()

    .. wraps::
            void PlotHistogram(
                const char* label, const float* values, int values_count,
                # note: optional
                int values_offset,
                const char* overlay_text,
                float scale_min,
                float scale_max,
                ImVec2 graph_size,
                int stride
            )
    """
    if values_count == -1:
        values_count = <int>values.shape[0]

    # Would be nicer as something like
    #   _bytes(overlay_text) if overlay_text is not None else NULL
    # but then Cython complains about either types or pointers to temporary references.
    cdef const char* overlay_text_ptr = NULL
    cdef bytes overlay_text_b

    if overlay_text is not None:
        overlay_text_b = _bytes(overlay_text) # must be assigned to a variable
        overlay_text_ptr = overlay_text_b # auto-convert bytes to char*

    cimgui.PlotHistogram(
        _bytes(label), &values[0], values_count,
        values_offset,
        overlay_text_ptr,
        scale_min, scale_max,
        _cast_tuple_ImVec2(graph_size),
        stride
    )

#-------------------------------------------------------------------------
# [SECTION] Widgets: Value helpers
# Those is not very useful, legacy API.
#-------------------------------------------------------------------------
# - Value()
#-------------------------------------------------------------------------

# Nothing to be mapped here

#-------------------------------------------------------------------------
# [SECTION] MenuItem, BeginMenu, EndMenu, etc.
#-------------------------------------------------------------------------
# - ImGuiMenuColumns [Internal]
# - BeginMenuBar()
# - EndMenuBar()
# - BeginMainMenuBar()
# - EndMainMenuBar()
# - BeginMenu()
# - EndMenu()
# - MenuItem()
#-------------------------------------------------------------------------

cdef class _BeginEndMenuBar(object):
    """
    Return value of :func:`begin_menu_bar` exposing ``opened`` (displayed) boolean attribute.
    See :func:`begin_menu_bar` for an explanation and examples.

    Can be used as a context manager (in a ``with`` statement) to automatically call :func:`end_menu_bar`
    (if necessary) to end the menu bar created with :func:`begin_menu_bar` when the block ends,
    even if an exception is raised.

    This class is not intended to be instantiated by the user (thus the `_` name prefix).
    It should be obtained as the return value of the :func:`begin_menu_bar` function.
    """

    cdef readonly bool opened

    def __cinit__(self, bool opened):
        self.opened = opened

    def __enter__(self):
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        if self.opened:
            cimgui.EndMenuBar()

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

def begin_menu_bar():
    """Append new menu menu bar to current window.

    This function is different from :func:`begin_main_menu_bar`, as this is
    child-window specific. Use with ``with`` to automatically call
    :func:`end_menu_bar` if necessary.
    Otherwise, only call :func:`end_menu_bar` if ``opened`` is True.

    **Note:** this requires :ref:`WINDOW_MENU_BAR <window-flag-options>` flag
    to be set for the current window. Without this flag set the
    ``begin_menu_bar()`` function will always return ``False``.

    .. visual-example::
        :auto_layout:
        :click: 25 30

        flags = imgui.WINDOW_MENU_BAR

        with imgui.begin("Child Window - File Browser", flags=flags):
            with imgui.begin_menu_bar() as menu_bar:
                if menu_bar.opened:
                    with imgui.begin_menu('File') as file_menu:
                        if file_menu.opened:
                            imgui.menu_item('Close')

    Example::

        flags = imgui.WINDOW_MENU_BAR

        imgui.begin("Child Window - File Browser", flags=flags)

        if imgui.begin_menu_bar().opened:
            if imgui.begin_menu('File').opened:
                imgui.menu_item('Close')
                imgui.end_menu()

            imgui.end_menu_bar()

        imgui.end()

    Returns:
        _BeginEndMenuBar: Use ``opened`` to tell if menu bar is displayed (opened).
        Only call :func:`end_menu_bar` if ``opened`` is True.
        Use with ``with`` to automatically call :func:`end_menu_bar` if necessary when the block ends.

    .. wraps::
        bool BeginMenuBar()
    """
    return _BeginEndMenuBar.__new__(
        _BeginEndMenuBar,
        cimgui.BeginMenuBar()
    )

def end_menu_bar():
    """Close menu bar context.

    Only call this function if ``begin_menu_bar().opened`` is True.

    For practical example how to use this function see documentation of
    :func:`begin_menu_bar`.

    .. wraps::
        void EndMenuBar()
    """
    cimgui.EndMenuBar()

cdef class _BeginEndMainMenuBar(object):
    """
    Return value of :func:`begin_main_menu_bar` exposing ``opened`` (displayed) boolean attribute.
    See :func:`begin_main_menu_bar` for an explanation and examples.

    Can be used as a context manager (in a ``with`` statement) to automatically call :func:`end_main_menu_bar`
    (if necessary) to end the main menu bar created with :func:`begin_main_menu_bar` when the block ends,
    even if an exception is raised.

    This class is not intended to be instantiated by the user (thus the `_` name prefix).
    It should be obtained as the return value of the :func:`begin_main_menu_bar` function.
    """

    cdef readonly bool opened

    def __cinit__(self, bool opened):
        self.opened = opened

    def __enter__(self):
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        if self.opened:
            cimgui.EndMainMenuBar()

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

def begin_main_menu_bar():
    """Create new full-screen menu bar.

    Use with ``with`` to automatically call :func:`end_main_menu_bar` if necessary.
    Otherwise, only call :func:`end_main_menu_bar` if ``opened`` is True.

    .. visual-example::
        :auto_layout:
        :height: 100
        :width: 200
        :click: 10 10

        with imgui.begin_main_menu_bar() as main_menu_bar:
            if main_menu_bar.opened:
                # first menu dropdown
                with imgui.begin_menu('File', True) as file_menu:
                    if file_menu.opened:
                        imgui.menu_item('New', 'Ctrl+N', False, True)
                        imgui.menu_item('Open ...', 'Ctrl+O', False, True)

                        # submenu
                        with imgui.begin_menu('Open Recent', True) as open_recent_menu:
                            if open_recent_menu.opened:
                                imgui.menu_item('doc.txt', None, False, True)

    Example::

        if imgui.begin_main_menu_bar().opened:
            # first menu dropdown
            if imgui.begin_menu('File', True).opened:
                imgui.menu_item('New', 'Ctrl+N', False, True)
                imgui.menu_item('Open ...', 'Ctrl+O', False, True)

                # submenu
                if imgui.begin_menu('Open Recent', True).opened:
                    imgui.menu_item('doc.txt', None, False, True)
                    imgui.end_menu()

                imgui.end_menu()

            imgui.end_main_menu_bar()

    Returns:
        _BeginEndMainMenuBar: Use ``opened`` to tell if main menu bar is displayed (opened).
        Only call :func:`end_main_menu_bar` if ``opened`` is True.
        Use with ``with`` to automatically call :func:`end_main_menu_bar` if necessary when the block ends.

    .. wraps::
        bool BeginMainMenuBar()
    """
    return _BeginEndMainMenuBar.__new__(
        _BeginEndMainMenuBar,
        cimgui.BeginMainMenuBar()
    )

def end_main_menu_bar():
    """Close main menu bar context.

    Only call this function if the ``end_main_menu_bar().opened`` is True.

    For practical example how to use this function see documentation of
    :func:`begin_main_menu_bar`.

    .. wraps::
        bool EndMainMenuBar()
    """
    cimgui.EndMainMenuBar()

cdef class _BeginEndMenu(object):
    """
    Return value of :func:`begin_menu` exposing ``opened`` boolean attribute.
    See :func:`begin_menu` for an explanation and examples.

    Can be used as a context manager (in a ``with`` statement) to automatically call :func:`end_menu`
    (if necessary) to end the menu created with :func:`begin_menu` when the block ends,
    even if an exception is raised.

    This class is not intended to be instantiated by the user (thus the `_` name prefix).
    It should be obtained as the return value of the :func:`begin_menu` function.
    """

    cdef readonly bool opened

    def __cinit__(self, bool opened):
        self.opened = opened

    def __enter__(self):
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        if self.opened:
            cimgui.EndMenu()

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

def begin_menu(str label, enabled=True):
    """Create new expandable menu in current menu bar.

    Use with ``with`` to automatically call :func:`end_menu` if necessary.
    Otherwise, only call :func:`end_menu` if ``opened`` is True.

    For practical example how to use this function, please see documentation
    of :func:`begin_main_menu_bar` or :func:`begin_menu_bar`.

    Args:
        label (str): label of the menu.
        enabled (bool): define if menu is enabled or disabled.

    Returns:
        _BeginEndMenu: Use ``opened`` to tell if the menu is displayed (opened).
        Only call :func:`end_menu` if ``opened`` is True.
        Use with ``with`` to automatically call :func:`end_menu` if necessary when the block ends.

    .. wraps::
        bool BeginMenu(
            const char* label,
            bool enabled
        )
    """
    return _BeginEndMenu.__new__(
        _BeginEndMenu,
        cimgui.BeginMenu(_bytes(label), enabled)
    )

def end_menu():
    """Close menu context.

    Only call this function if ``begin_menu().opened`` returns True.

    For practical example how to use this function, please see documentation
    of :func:`begin_main_menu_bar` or :func:`begin_menu_bar`.

    .. wraps::
        void EndMenu()
    """
    cimgui.EndMenu()

def menu_item(
    str label, str shortcut=None, cimgui.bool selected=False, enabled=True
):
    """Create a menu item.

    Item shortcuts are displayed for convenience but not processed by ImGui at
    the moment. Using ``selected`` argument it is possible to show and trigger
    a check mark next to the menu item label.

    For practical example how to use this function, please see documentation
    of :func:`begin_main_menu_bar` or :func:`begin_menu_bar`.

    Args:
        label (str): label of the menu item.
        shortcut (str): shortcut text of the menu item.
        selected (bool): define if menu item is selected.
        enabled (bool): define if menu item is enabled or disabled.

    Returns:
        tuple: a ``(clicked, state)`` two-tuple indicating if item was
        clicked by the user and the current state of item (visibility of
        the check mark).

    .. wraps::
        MenuItem(
            const char* label,
            const char* shortcut,
            bool* p_selected,
            bool enabled = true
        )
    """
    cdef cimgui.bool inout_selected = selected

    # note: wee need to split this into two separate calls depending
    #       on the value of shortcut in order to support None instead
    #       of empty strings.
    if shortcut is None:
        clicked = cimgui.MenuItem(
            _bytes(label),
            NULL,
            &inout_selected,
            <bool>enabled
        )
    else:
        clicked = cimgui.MenuItem(
            _bytes(label),
            _bytes(shortcut),
            &inout_selected,
            <bool>enabled
        )
    return clicked, inout_selected

#-------------------------------------------------------------------------
# [SECTION] Widgets: BeginTabBar, EndTabBar, etc.
#-------------------------------------------------------------------------
# - BeginTabBar()
# - BeginTabBarEx() [Internal]
# - EndTabBar()
# - TabBarLayout() [Internal]
# - TabBarCalcTabID() [Internal]
# - TabBarCalcMaxTabWidth() [Internal]
# - TabBarFindTabById() [Internal]
# - TabBarRemoveTab() [Internal]
# - TabBarCloseTab() [Internal]
# - TabBarScrollClamp() [Internal]
# - TabBarScrollToTab() [Internal]
# - TabBarQueueChangeTabOrder() [Internal]
# - TabBarScrollingButtons() [Internal]
# - TabBarTabListPopupButton() [Internal]
#-------------------------------------------------------------------------

cdef class _BeginEndTabBar(object):
    """
    Return value of :func:`begin_tab_bar` exposing ``opened`` boolean attribute.
    See :func:`begin_tab_bar` for an explanation and examples.

    Can be used as a context manager (in a ``with`` statement) to automatically call :func:`end_tab_bar`
    (if necessary) to end the tar bar created with :func:`begin_tab_bar` when the block ends,
    even if an exception is raised.

    This class is not intended to be instantiated by the user (thus the `_` name prefix).
    It should be obtained as the return value of the :func:`begin_tab_bar` function.
    """

    cdef readonly bool opened

    def __cinit__(self, bool opened):
        self.opened = opened

    def __enter__(self):
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        if self.opened:
            cimgui.EndTabBar()

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

def begin_tab_bar(str identifier, cimgui.ImGuiTabBarFlags flags = 0):
    """Create and append into a TabBar

    Args:
        identifier(str): String identifier of the tab window
        flags: ImGuiTabBarFlags flags. See:
            :ref:`list of available flags <tabbar-flag-options>`.

    Returns:
        _BeginEndTabBar: Use ``opened`` bool attribute to tell if the Tab Bar is open.
        Only call :func:`end_tab_bar` if ``opened`` is True.
        Use with ``with`` to automatically call :func:`end_tab_bar` if necessary when the block ends.

    .. wraps::
        bool BeginTabBar(const char* str_id, ImGuiTabBarFlags flags = 0)

    """
    return _BeginEndTabBar.__new__(
        _BeginEndTabBar,
        cimgui.BeginTabBar(_bytes(identifier), flags)
    )

def end_tab_bar():
    """End a previously opened tab bar.
    Only call this function if ``begin_tab_bar().opened`` is True.

    .. wraps::
        void EndTabBar()
    """
    cimgui.EndTabBar()

#-------------------------------------------------------------------------
# [SECTION] Widgets: BeginTabItem, EndTabItem, etc.
#-------------------------------------------------------------------------
# - BeginTabItem()
# - EndTabItem()
# - TabItemButton()
# - TabItemEx() [Internal]
# - SetTabItemClosed()
# - TabItemCalcSize() [Internal]
# - TabItemBackground() [Internal]
# - TabItemLabelAndCloseButton() [Internal]
#-------------------------------------------------------------------------

cdef class _BeginEndTabItem(object):
    """
    Return value of :func:`begin_tab_item` exposing ``selected`` and ``opened`` boolean attributes.
    See :func:`begin_tab_item` for an explanation of these attributes and examples.

    For legacy support, the attributes can also be accessed by unpacking or indexing into this object.

    Can be used as a context manager (in a ``with`` statement) to automatically call :func:`end_tab_item`
    to end the tab item created with :func:`begin_tab_item` when the block ends, even if an exception is raised.

    This class is not intended to be instantiated by the user (thus the `_` name prefix).
    It should be obtained as the return value of the :func:`begin_tab_item` function.
    """

    cdef readonly bool selected
    cdef readonly bool opened

    def __cinit__(self, bool selected, bool opened):
        self.selected = selected
        self.opened = opened

    def __enter__(self):
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        if self.selected:
            cimgui.EndTabItem()

    def __getitem__(self, item):
        """For legacy support, returns ``(selected, opened)[item]``."""
        return (self.selected, self.opened)[item]

    def __iter__(self):
        """For legacy support, returns ``iter((selected, opened))``."""
        return iter((self.selected, self.opened))

    def __repr__(self):
        return "{}(selected={}, opened={})".format(
            self.__class__.__name__, self.selected, self.opened
        )

    def __eq__(self, other):
        if other.__class__ is self.__class__:
            return (self.selected, self.opened) == (other.selected, other.opened)
        return (self.selected, self.opened) == other

def begin_tab_item(str label, opened = None, cimgui.ImGuiTabItemFlags flags = 0):
    """Create a Tab.

    .. visual-example::
        :auto_layout:
        :width: 300

        opened_state = True

        #...

        with imgui.begin("Example Tab Bar"):
            with imgui.begin_tab_bar("MyTabBar") as tab_bar:
                if tab_bar.opened:
                    with imgui.begin_tab_item("Item 1") as item1:
                        if item1.selected:
                            imgui.text("Here is the tab content!")

                    with imgui.begin_tab_item("Item 2") as item2:
                        if item2.selected:
                            imgui.text("Another content...")

                    with imgui.begin_tab_item("Item 3", opened=opened_state) as item3:
                        opened_state = item3.opened
                        if item3.selected:
                            imgui.text("Hello Saylor!")

    Example::

        opened_state = True

        #...

        imgui.begin("Example Tab Bar")
        if imgui.begin_tab_bar("MyTabBar"):

            if imgui.begin_tab_item("Item 1").selected:
                imgui.text("Here is the tab content!")
                imgui.end_tab_item()

            if imgui.begin_tab_item("Item 2").selected:
                imgui.text("Another content...")
                imgui.end_tab_item()

            selected, opened_state = imgui.begin_tab_item("Item 3", opened=opened_state)
            if selected:
                imgui.text("Hello Saylor!")
                imgui.end_tab_item()

            imgui.end_tab_bar()
        imgui.end()

    Args:
        label (str): Label of the tab item
        removable (bool): If True, the tab item can be removed
        flags: ImGuiTabItemFlags flags. See:
            :ref:`list of available flags <tabitem-flag-options>`.

    Returns:
        _BeginEndTabItem: ``(selected, opened)`` struct of bools. If tab item is selected
        ``selected==True``. The value of ``opened`` is always True for
        non-removable and open tab items but changes state to False on close
        button click for removable tab items.
        Only call :func:`end_tab_item` if ``selected`` is True.
        Use with ``with`` to automatically call :func:`end_tab_item` if necessary when the block ends.

    .. wraps::
        bool BeginTabItem(
            const char* label,
            bool* p_open = NULL,
            ImGuiTabItemFlags flags = 0
        )
    """
    cdef cimgui.bool inout_opened = opened
    return _BeginEndTabItem.__new__(
        _BeginEndTabItem,
        cimgui.BeginTabItem(
            _bytes(label),
            &inout_opened if opened is not None else NULL, flags
        ),
        inout_opened
    )

def end_tab_item():
    """End a previously opened tab item.
    Only call this function if ``begin_tab_item().selected`` is True.

    .. wraps::
        void EndTabItem()
    """
    cimgui.EndTabItem()

def tab_item_button(str label, cimgui.ImGuiTabItemFlags flags = 0):
    """Create a Tab behaving like a button.
    Cannot be selected in the tab bar.

    Args:
        label (str): Label of the button
        flags: ImGuiTabItemFlags flags. See:
            :ref:`list of available flags <tabitem-flag-options>`.

    Returns:
        (bool): Return true when clicked.

    .. visual-example:
        :auto_layout:
        :width: 300

        imgui.begin("Example Tab Bar")
        if imgui.begin_tab_bar("MyTabBar"):

            if imgui.begin_tab_item("Item 1")[0]:
                imgui.text("Here is the tab content!")
                imgui.end_tab_item()

            if imgui.tab_item_button("Click me!"):
                print('Clicked!')

            imgui.end_tab_bar()
        imgui.end()

    .. wraps::
        bool TabItemButton(const char* label, ImGuiTabItemFlags flags = 0)
    """
    return cimgui.TabItemButton(_bytes(label), flags)

def set_tab_item_closed(str tab_or_docked_window_label):
    """Notify TabBar or Docking system of a closed tab/window ahead (useful to reduce visual flicker on reorderable tab bars).
    For tab-bar: call after BeginTabBar() and before Tab submissions.
    Otherwise call with a window name.

    Args:
        tab_or_docked_window_label (str): Label of the targeted tab or docked window

    .. visual-example:
        :auto_layout:
        :width: 300

        imgui.begin("Example Tab Bar")
        if imgui.begin_tab_bar("MyTabBar"):

            if imgui.begin_tab_item("Item 1")[0]:
                imgui.text("Here is the tab content!")
                imgui.end_tab_item()

            if imgui.begin_tab_item("Item 2")[0]:
                imgui.text("This item won't whow !")
                imgui.end_tab_item()

            imgui.set_tab_item_closed("Item 2")

            imgui.end_tab_bar()
        imgui.end()

    .. wraps:
        void SetTabItemClosed(const char* tab_or_docked_window_label)
    """
    cimgui.SetTabItemClosed(_bytes(tab_or_docked_window_label))

