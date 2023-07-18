import pytest

import imgui


@pytest.fixture
def context():
    ctx = imgui.get_current_context()
    if ctx is not None:
        imgui.destroy_context(ctx)
    ctx = imgui.create_context()
    return ctx


@pytest.fixture
def io():
    # setup io
    io = imgui.get_io()
    io.delta_time = 1.0 / 60.0
    io.display_size = 300, 300

    # setup default font
    io.fonts.add_font_default()
    io.fonts.get_tex_data_as_rgba32()
    io.fonts.texture_id = 42  # set any texture ID to avoid segfaults

    return io


@pytest.fixture
def frame(context, io):
    imgui.new_frame()
    yield
    try:
        imgui.render()
    except imgui.ImGuiError:
        try:
            imgui.end_frame()
        except imgui.ImGuiError:
            pass
