"""
Calls to `imgui.new_frame()` fail is no backend is initialized, we get the error below:
    imgui.core.ImGuiError: ImGui assertion error (g.IO.Fonts->IsBuilt() && "Font Atlas not built!
    Make sure you called ImGui_ImplXXXX_NewFrame() function for renderer backend,
    which should call io.Fonts->GetTexDataAsRGBA32() / GetTexDataAsAlpha8()") at imgui-cpp/imgui.cpp:8604

dummy_glfw_init provides only one function: create_dummy_glfw_renderer() that will instantiate a glfw renderer backend.
"""
import glfw
import OpenGL.GL as gl
from imgui.integrations.glfw import GlfwRenderer



def _impl_glfw_init():
    width, height = 1280, 720
    window_name = "minimal ImGui/GLFW3 example"

    if not glfw.init():
        print("Could not initialize OpenGL context")
        exit(1)

    # OS X supports only forward-compatible core profiles from 3.2
    glfw.window_hint(glfw.CONTEXT_VERSION_MAJOR, 3)
    glfw.window_hint(glfw.CONTEXT_VERSION_MINOR, 3)
    glfw.window_hint(glfw.OPENGL_PROFILE, glfw.OPENGL_CORE_PROFILE)

    glfw.window_hint(glfw.OPENGL_FORWARD_COMPAT, gl.GL_TRUE)

    # Create a windowed mode window and its OpenGL context
    window = glfw.create_window(
        int(width), int(height), window_name, None, None
    )
    glfw.make_context_current(window)

    if not window:
        glfw.terminate()
        print("Could not initialize Window")
        exit(1)

    return window


_DUMMY_GLFW_WINDOW = None


def create_dummy_glfw_renderer():
    global _DUMMY_GLFW_WINDOW
    if _DUMMY_GLFW_WINDOW is None:
        _DUMMY_GLFW_WINDOW = _impl_glfw_init()
    glfw_renderer = GlfwRenderer(_DUMMY_GLFW_WINDOW)
