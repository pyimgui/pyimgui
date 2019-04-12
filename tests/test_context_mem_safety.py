"""Note: This tests are potential crashers (may result in segfaults)"""
import pytest

import imgui


@pytest.fixture()
def no_context():
    ctx = imgui.get_current_context()
    if ctx is not None:
        imgui.destroy_context(ctx)


def test_get_current_context_no_context(no_context):
    assert imgui.get_current_context() is None


def test_create_context_no_context(no_context):
    ctx = imgui.create_context()
    assert ctx is not None
    assert imgui.get_current_context() is not None


def test_create_context_ctx_object_identity(no_context):
    ctx = imgui.create_context()
    assert ctx is not None
    assert ctx == imgui.get_current_context()


def test_destroy_empty_context(no_context):
    with pytest.raises(RuntimeError):
        imgui.destroy_context()


def test_destroy_destroyed_context(no_context):
    ctx = imgui.create_context()
    assert ctx is not None

    imgui.destroy_context(ctx)

    with pytest.raises(RuntimeError):
        imgui.destroy_context(ctx)


def test_set_current_context_destroyed(no_context):
    ctx = imgui.create_context()
    assert ctx is not None

    imgui.destroy_context(ctx)

    imgui.set_current_context(ctx)
    assert imgui.get_current_context() is None
