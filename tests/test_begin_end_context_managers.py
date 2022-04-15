import logging
import sys

import pytest
import imgui
from imgui import ImGuiError
import dummy_glfw_init


class _TestException(Exception):
    pass


@pytest.fixture
def context():
    ctx = imgui.get_current_context()
    if ctx is not None:
        imgui.destroy_context(ctx)
    ctx = imgui.create_context()
    io = imgui.get_io()
    io.delta_time = 1.0 / 60.0
    io.display_size = 300, 300

    # setup default font
    io.fonts.get_tex_data_as_rgba32()
    io.fonts.add_font_default()
    io.fonts.texture_id = 0  # set any texture ID to avoid segfaults
    return ctx


@pytest.fixture
def frame(context):
    dummy_glfw_init.create_dummy_glfw_renderer()
    imgui.new_frame()
    yield
    try:
        imgui.render()
    except ImGuiError:
        try:
            imgui.end_frame()
        except ImGuiError:
            pass


# ------- BEGIN/END ----------
def test_begin_okay(frame):
    imgui.begin("Example: empty window")
    imgui.end()


def test_begin_with(frame):
    with imgui.begin("Example: empty window") as window:
        assert isinstance(window.expanded, bool)
        assert isinstance(window.opened, bool)


def test_begin_with_exception(frame):
    # the real test is that the frame cleanup doesn't crash
    with pytest.raises(_TestException):
        with imgui.begin("Example: empty window"):
            raise _TestException


def test_begin_unpacking(frame):
    expanded, opened = imgui.begin("Example: empty window")
    assert isinstance(expanded, bool)
    assert isinstance(opened, bool)
    imgui.end()


def test_begin_equality(frame):
    window = imgui.begin("Example: empty window")
    assert window == window
    assert window == tuple(window)
    imgui.end()

# ------- BEGIN_CHILD/END_CHILD ----------
def test_child_okay(frame):
    imgui.begin("Example: child region")

    imgui.begin_child("region", 150, -50, border=True)
    imgui.text("inside region")
    imgui.end_child()

    imgui.text("outside region")
    imgui.end()


def test_child_with(frame):
    with imgui.begin("Example: child region"):
        with imgui.begin_child("region", 150, -50, border=True):
            imgui.text("inside region")
        imgui.text("outside region")


def test_child_with_exception(frame):
    # the real test is that the frame cleanup doesn't crash
    with pytest.raises(_TestException):
        with imgui.begin("Example: child region"):
            with imgui.begin_child("region", 150, -50, border=True):
                raise _TestException
            imgui.text("outside region")


def test_child_as_bool(frame):
    imgui.begin("Example: child region")
    child = imgui.begin_child("region", 150, -50, border=True)
    assert bool(child) is child.visible
    assert child == child
    assert child == bool(child)
    imgui.end_child()
    imgui.end()


# ------- BEGIN_TOOLTIP/END_TOOLTIP ----------
def test_tooltip_okay(frame):
    imgui.begin("Example: tooltip")
    imgui.button("Click me!")
    if imgui.is_item_hovered():
        imgui.begin_tooltip()
        imgui.text("This button is clickable.")
        imgui.end_tooltip()
    imgui.end()


def test_tooltip_with(frame):
    with imgui.begin("Example: tooltip"):
        imgui.button("Click me!")
        if imgui.is_item_hovered():
            with imgui.begin_tooltip():
                imgui.text("This button is clickable.")


def test_tooltip_with_exception(frame):
    # the real test is that the frame cleanup doesn't crash
    with pytest.raises(_TestException):
        with imgui.begin("Example: tooltip"):
            imgui.button("Click me!")
            with imgui.begin_tooltip():
                raise _TestException


# ------- BEGIN_MAIN_MENU_BAR/END_MAIN_MENU_BAR ----------
def test_main_menu_bar_okay(frame):
    if imgui.begin_main_menu_bar():
        imgui.end_main_menu_bar()
    else:
        assert False


def test_main_menu_bar_with(frame):
    with imgui.begin_main_menu_bar() as menu:
        assert menu.opened is True


def test_main_menu_bar_with_exception(frame):
    # the real test is that the frame cleanup doesn't crash
    with pytest.raises(_TestException):
        with imgui.begin_main_menu_bar():
            raise _TestException


def test_main_menu_bar_as_bool(frame):
    menu = imgui.begin_main_menu_bar()
    assert isinstance(menu.opened, bool)
    assert bool(menu) is menu.opened is True
    assert menu == menu
    assert menu == bool(menu)
    imgui.end_main_menu_bar()


# ------- BEGIN_MENU_BAR/END_MENU_BAR ----------
def test_menu_bar_okay(frame):
    flags = imgui.WINDOW_MENU_BAR
    imgui.begin("Child Window - File Browser", flags=flags)

    if imgui.begin_menu_bar():
        imgui.end_menu_bar()
    else:
        assert False
    imgui.end()


def test_menu_bar_with(frame):
    flags = imgui.WINDOW_MENU_BAR
    with imgui.begin("Child Window - File Browser", flags=flags):
        with imgui.begin_menu_bar():
            pass


def test_menu_bar_with_exception(frame):
    # the real test is that the frame cleanup doesn't crash
    with pytest.raises(_TestException):
        flags = imgui.WINDOW_MENU_BAR
        with imgui.begin("Child Window - File Browser", flags=flags):
            with imgui.begin_menu_bar():
                raise _TestException


def test_menu_bar_as_bool(frame):
    flags = imgui.WINDOW_MENU_BAR
    imgui.begin("Child Window - File Browser", flags=flags)
    menu = imgui.begin_menu_bar()
    assert isinstance(menu.opened, bool)
    assert bool(menu) is menu.opened is True
    assert menu == menu
    assert menu == bool(menu)
    imgui.end_menu_bar()
    imgui.end()


# ------- BEGIN_TAB_BAR/END_TAB_BAR ----------
def test_tab_bar_okay(frame):
    imgui.begin("Example Tab Bar")
    if imgui.begin_tab_bar("MyTabBar"):
        imgui.end_tab_bar()
    imgui.end()


def test_tab_bar_with(frame):
    with imgui.begin("Example Tab Bar"):
        with imgui.begin_tab_bar("MyTabBar"):
            pass


def test_tab_bar_with_exception(frame):
    # the real test is that the frame cleanup doesn't crash
    with pytest.raises(_TestException):
        with imgui.begin("Example Tab Bar"):
            with imgui.begin_tab_bar("MyTabBar"):
                raise _TestException


def test_tab_bar_as_bool(frame):
    imgui.begin("Example Tab Bar")
    tab_bar = imgui.begin_tab_bar("MyTabBar")
    assert bool(tab_bar) is tab_bar.opened is True
    assert tab_bar == tab_bar
    assert tab_bar == bool(tab_bar)
    imgui.end_tab_bar()
    imgui.end()


# ------- BEGIN_TAB_ITEM/END_TAB_ITEM ----------
def test_tab_item_okay(frame):
    imgui.begin("Example Tab Bar")
    if imgui.begin_tab_bar("MyTabBar"):
        if imgui.begin_tab_item("Item 1")[0]:
            imgui.text("Here is the tab content!")
            imgui.end_tab_item()
        imgui.end_tab_bar()
    imgui.end()


def test_tab_item_with(frame):
    with imgui.begin("Example Tab Bar"):
        with imgui.begin_tab_bar("MyTabBar") as tab_bar:
            if tab_bar.opened:
                with imgui.begin_tab_item("Item 1") as item:
                    if item.selected:
                        pass


def test_tab_item_with_exception(frame):
    # the real test is that the frame cleanup doesn't crash
    with pytest.raises(_TestException):
        with imgui.begin("Example Tab Bar"):
            with imgui.begin_tab_bar("MyTabBar") as tab_bar:
                if tab_bar.opened:
                    with imgui.begin_tab_item("Item 1") as item:
                        raise _TestException


def test_tab_item_as_bool(frame):
    imgui.begin("Example Tab Bar")
    tab_bar = imgui.begin_tab_bar("MyTabBar")
    assert tab_bar.opened
    item = imgui.begin_tab_item("Item 1")
    assert bool(item) is item.selected is True
    assert item.opened is False
    assert item == item
    assert item == tuple(item)
    imgui.end_tab_item()
    imgui.end_tab_bar()
    imgui.end()


# ------- BEGIN_MENU/END_MENU ----------
def test_menu_okay(frame):
    flags = imgui.WINDOW_MENU_BAR
    imgui.begin("Child Window - File Browser", flags=flags)

    if imgui.begin_menu_bar():
        if imgui.begin_menu('File'):
            imgui.menu_item('Close')
            imgui.end_menu()
        imgui.end_menu_bar()
    imgui.end()


def test_menu_with(frame):
    flags = imgui.WINDOW_MENU_BAR
    with imgui.begin("Child Window - File Browser", flags=flags):
        with imgui.begin_menu_bar() as menu_bar:
            if menu_bar.opened:
                with imgui.begin_menu('File'):
                    pass


def test_menu_with_exception(frame):
    # the real test is that the frame cleanup doesn't crash
    with pytest.raises(_TestException):
        flags = imgui.WINDOW_MENU_BAR
        with imgui.begin("Child Window - File Browser", flags=flags):
            with imgui.begin_menu_bar() as menu_bar:
                if menu_bar.opened:
                    with imgui.begin_menu('File'):
                        raise _TestException


def test_menu_as_bool(frame):
    flags = imgui.WINDOW_MENU_BAR
    imgui.begin("Child Window - File Browser", flags=flags)
    menu_bar = imgui.begin_menu_bar()
    assert menu_bar.opened
    menu = imgui.begin_menu('File')
    assert isinstance(menu.opened, bool)
    assert bool(menu) is menu.opened is False
    assert menu == menu
    assert menu == bool(menu)
    imgui.end_menu_bar()
    imgui.end()


# ------- BEGIN_POPUP{,_CONTEXT_ITEM,_CONTEXT_WINDOW,_CONTEXT_VOID}/END_POPUP ----------
def test_popup_okay(frame):
    imgui.begin("Example: simple popup")
    imgui.open_popup("select-popup")
    if imgui.begin_popup("select-popup"):
        imgui.end_popup()
    imgui.end()


def test_popup_with(frame):
    with imgui.begin("Example: simple popup"):
        imgui.open_popup("select-popup")
        with imgui.begin_popup("select-popup"):
            pass


def test_popup_with_exception(frame):
    # the real test is that the frame cleanup doesn't crash
    with pytest.raises(_TestException):
        with imgui.begin("Example: simple popup"):
            imgui.open_popup("select-popup")
            with imgui.begin_popup("select-popup"):
                raise _TestException


def test_popup_as_bool(frame):
    imgui.begin("Example: simple popup")
    imgui.open_popup("select-popup")
    popup = imgui.begin_popup("select-popup")
    assert isinstance(popup.opened, bool)
    assert bool(popup) is popup.opened is True
    assert popup == popup
    assert popup == bool(popup)
    imgui.end_popup()
    imgui.end()


def test_popup_context_item_isinstance(frame):
    imgui.begin("Example: popup context view")
    imgui.text("Right-click to set value.")
    item = imgui.begin_popup_context_item("Item Context Menu")
    assert isinstance(item, imgui.core._BeginEndPopup)
    assert item.opened is False
    assert item == item
    assert item == bool(item)
    imgui.end()


def test_popup_context_window_isinstance(frame):
    imgui.begin("Example: popup context window")
    window = imgui.begin_popup_context_window()
    assert isinstance(window, imgui.core._BeginEndPopup)
    assert window.opened is False
    assert window == window
    assert window == bool(window)
    imgui.end()


def test_popup_context_void_isinstance(frame):
    window = imgui.begin_popup_context_void()
    assert isinstance(window, imgui.core._BeginEndPopup)
    assert window.opened is False
    assert window == window
    assert window == bool(window)


# ------- BEGIN_POPUP_MODAL/END_POPUP_MODAL ----------
def test_popup_modal_okay(frame):
    imgui.begin("Example: simple popup modal")
    imgui.open_popup("select-popup")
    if imgui.begin_popup_modal("select-popup")[0]:
        imgui.end_popup()
    imgui.end()


def test_popup_modal_with(frame):
    with imgui.begin("Example: simple popup modal"):
        imgui.open_popup("select-popup")
        with imgui.begin_popup_modal("select-popup"):
            pass


def test_popup_modal_with_exception(frame):
    # the real test is that the frame cleanup doesn't crash
    with pytest.raises(_TestException):
        with imgui.begin("Example: simple popup modal"):
            imgui.open_popup("select-popup")
            with imgui.begin_popup_modal("select-popup"):
                raise _TestException


def test_popup_modal_as_bool(frame):
    imgui.begin("Example: simple popup modal")
    imgui.open_popup("select-popup")
    popup = imgui.begin_popup_modal("select-popup")
    assert popup.opened is True
    assert popup.visible is False
    opened, visible = popup
    assert opened is popup.opened is popup[0]
    assert visible is popup.visible is popup[1]
    assert popup == popup
    assert popup == tuple(popup)
    imgui.end_popup()
    imgui.end()


# ------- BEGIN_DRAG_DROP_SOURCE/END_DRAG_DROP_SOURCE ----------
def test_drag_drop_source_okay(frame):
    imgui.begin("Example: drag and drop")
    imgui.button('source')
    if imgui.begin_drag_drop_source():
        imgui.set_drag_drop_payload('itemtype', b'payload')
        imgui.end_drag_drop_source()
    imgui.end()


def test_drag_drop_source_with(frame):
    with imgui.begin("Example: drag and drop"):
        imgui.button('source')
        with imgui.begin_drag_drop_source():
            pass


def test_drag_drop_source_with_exception(frame):
    # the real test is that the frame cleanup doesn't crash
    with pytest.raises(_TestException):
        with imgui.begin("Example: drag and drop"):
            imgui.button('source')
            with imgui.begin_drag_drop_source():
                raise _TestException


def test_drag_drop_source_as_bool(frame):
    imgui.begin("Example: drag and drop")
    imgui.button('source')
    src = imgui.begin_drag_drop_source()
    assert bool(src) is src.dragging is False
    assert src == src
    assert src == bool(src)
    imgui.end()


# ------- BEGIN_DRAG_DROP_TARGET/END_DRAG_DROP_TARGET ----------
def test_drag_drop_target_okay(frame):
    imgui.begin("Example: drag and drop")
    imgui.button('dest')
    if imgui.begin_drag_drop_target():
        payload = imgui.accept_drag_drop_payload('itemtype')
        imgui.end_drag_drop_target()
    imgui.end()


def test_drag_drop_target_with(frame):
    with imgui.begin("Example: drag and drop"):
        imgui.button('dest')
        with imgui.begin_drag_drop_target():
            pass


def test_drag_drop_target_with_exception(frame):
    # the real test is that the frame cleanup doesn't crash
    with pytest.raises(_TestException):
        with imgui.begin("Example: drag and drop"):
            imgui.button('dest')
            with imgui.begin_drag_drop_target():
                raise _TestException


def test_drag_drop_target_as_bool(frame):
    imgui.begin("Example: drag and drop")
    imgui.button('dest')
    target = imgui.begin_drag_drop_target()
    assert bool(target) is target.hovered is False
    assert target == target
    assert target == bool(target)
    imgui.end()


# ------- BEGIN_GROUP/END_GROUP ----------
def test_group_okay(frame):
    imgui.begin("Example: item groups")
    imgui.begin_group()
    imgui.text("First group (buttons):")
    imgui.end_group()
    imgui.end()


def test_group_with(frame):
    with imgui.begin("Example: item groups"):
        with imgui.begin_group():
            imgui.text("First group (buttons):")


def test_group_with_exception(frame):
    # the real test is that the frame cleanup doesn't crash
    with pytest.raises(_TestException):
        with imgui.begin("Example: item groups"):
            with imgui.begin_group():
                raise _TestException


# ------- BEGIN_LIST_BOX/END_LIST_BOX ----------
def test_list_box_okay(frame):
    imgui.begin("Example: custom listbox")
    if imgui.begin_list_box("List", 200, 100):
        imgui.selectable("Selected", True)
        imgui.selectable("Not Selected", False)
        imgui.end_list_box()
    imgui.end()


def test_list_box_with(frame):
    with imgui.begin("Example: custom listbox"):
        with imgui.begin_list_box("List", 200, 100):
            pass


def test_list_box_with_exception(frame):
    # the real test is that the frame cleanup doesn't crash
    with pytest.raises(_TestException):
        with imgui.begin("Example: custom listbox"):
            with imgui.begin_list_box("List", 200, 100):
                raise _TestException


def test_list_box_as_bool(frame):
    imgui.begin("Example: custom listbox")
    list_box = imgui.begin_list_box("List", 200, 100)
    assert bool(list_box) is list_box.opened is True
    assert list_box == list_box
    assert list_box == bool(list_box)
    imgui.end_list_box()
    imgui.end()


# ------- BEGIN_TABLE/END_TABLE ----------
def test_table_okay(frame):
    imgui.begin("Example: table")
    if imgui.begin_table("data", 2):
        imgui.end_table()
    imgui.end()


def test_table_with(frame):
    with imgui.begin("Example: table"):
        with imgui.begin_table("data", 2):
            pass


def test_table_with_exception(frame):
    # the real test is that the frame cleanup doesn't crash
    with pytest.raises(_TestException):
        with imgui.begin("Example: table"):
            with imgui.begin_table("data", 2):
                raise _TestException


def test_table_as_bool(frame):
    imgui.begin("Example: table")
    table = imgui.begin_table("data", 2)
    assert bool(table) is table.opened is True
    assert table == table
    assert table == bool(table)
    imgui.end_table()
    imgui.end()
