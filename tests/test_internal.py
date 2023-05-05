import imgui.internal


def test_get_item_id_interactive_item(frame):
    with imgui.begin("window"):
        expected = imgui.get_id("text")
        imgui.button("text")
        actual = imgui.internal.get_item_id()
        assert actual == expected


def test_get_item_id_noninteractive_item(frame):
    with imgui.begin("window"):
        expected = 0
        imgui.text("text")
        actual = imgui.internal.get_item_id()
        assert actual == expected
