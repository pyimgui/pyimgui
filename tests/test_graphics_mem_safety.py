"""Note: This tests are potential crashers (may result in segfaults)"""
import pytest
import imgui

def test_texture_id_int_reference(context, io):
    # See issue #248 (https://github.com/pyimgui/pyimgui/issues/248)

    texture_id = 0
    for i in range(0, 1000, 50):
        imgui.new_frame()

        imgui.begin("tests")
        io.fonts.texture_id = texture_id
        imgui.image(texture_id, 640, 480)
        imgui.image_button(texture_id, 200, 50)
        draw_list = imgui.get_background_draw_list()
        draw_list.add_image(texture_id, (20, 35), (180, 80))
        imgui.end()

        texture_id += 1

        imgui.render()
        
        draw_data = imgui.get_draw_data()
        for commands in draw_data.commands_lists:
            for command in commands.commands:
                assert type(command.texture_id) is int


def test_texture_id_keep_type(context, io):
    texture_id = {'dummy': 42}

    imgui.new_frame()
    imgui.image(texture_id, 640, 480)
    imgui.render()
    draw_data = imgui.get_draw_data()
    for commands in draw_data.commands_lists:
        for command in commands.commands:

            # Skip font atlas texture id
            if command.texture_id == io.fonts.texture_id:
                continue

            assert type(command.texture_id) == type(texture_id)
