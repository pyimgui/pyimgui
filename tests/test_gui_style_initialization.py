import inspect

import pytest

import imgui


IMGUI_DATA_DESCRIPTORS = [
    attribute_name for attribute_name in dir(imgui.GuiStyle)
    if inspect.isdatadescriptor(getattr(imgui.GuiStyle, attribute_name))
]


@pytest.fixture
def context():
    ctx = imgui.get_current_context()
    if ctx is not None:
        imgui.destroy_context(ctx)
    ctx = imgui.create_context()
    return ctx



@pytest.fixture(params=IMGUI_DATA_DESCRIPTORS)
def data_descriptor(request):
    if request.param == "colors":
        pytest.skip("'{}' isn't a writable property".format(request.param))
    return request.param


def gui_style_property():
    pass


def test_gui_style_attribute_access_without_create(context, data_descriptor):
    style = imgui.GuiStyle()

    with pytest.raises(RuntimeError):
        setattr(style, data_descriptor, getattr(style, data_descriptor))


def test_gui_style_data_descriptor_symmetry(context, data_descriptor):
    style = imgui.GuiStyle.create()

    value = getattr(style, data_descriptor)
    setattr(style, data_descriptor, getattr(style, data_descriptor))
    assert getattr(style, data_descriptor) == value


def test_gui_style_equality(context):
    assert imgui.get_style() == imgui.get_style()
    assert imgui.get_style() is not imgui.get_style()


def test_gui_style_inequality(context):
    assert imgui.GuiStyle.create() != imgui.GuiStyle.create()
    assert imgui.GuiStyle.create() is not imgui.GuiStyle.create()
