import glfw
import OpenGL.GL as gl

import imgui
import ctypes


def keyboard_callback(window, key, scancode, action, mods):
    io = imgui.get_io()

    if action == glfw.PRESS:
        io.keys_down[key] = True
    elif action == glfw.RELEASE:
        io.keys_down[key] = False

    io.key_ctrl = (
        io.keys_down[glfw.KEY_LEFT_CONTROL] or
        io.keys_down[glfw.KEY_RIGHT_CONTROL]
    )

    io.key_alt = (
        io.keys_down[glfw.KEY_LEFT_ALT] or
        io.keys_down[glfw.KEY_RIGHT_ALT]
    )

    io.key_shift = (
        io.keys_down[glfw.KEY_LEFT_SHIFT] or
        io.keys_down[glfw.KEY_RIGHT_SHIFT]
    )

    io.key_super = (
        io.keys_down[glfw.KEY_LEFT_SUPER] or
        io.keys_down[glfw.KEY_RIGHT_SUPER]
    )


def char_callback(window, char):
    io = imgui.get_io()

    if 0 < char < 0x10000:
        io.add_input_character(char)


def mouse_callback(*args, **kwargs):
    pass


def resize_callback(*args, **kwargs):
    pass

g_ShaderHandle = None
g_VertHandle = None
g_FragHandle = None

g_AttribLocationTex = None
g_AttribLocationProjMtx = None
g_AttribLocationPosition = None
g_AttribLocationUV = None
g_AttribLocationColor = None

g_VboHandle = None
g_ElementsHandle = None
g_VaoHandle = None


def imp_glfw_new_frame(window):
    global g_FontTexture

    if not g_FontTexture:
        imp_create_device_objects()

    io = imgui.get_io()

    w, h = glfw.get_window_size(window)
    dw, dh = glfw.get_framebuffer_size(window)
    io.display_size = w, h
    io.display_fb_scale = float(dw)/w, float(dh)/h

    io.delta_time = 1.0/60

    if glfw.get_window_attrib(window, glfw.FOCUSED):
        io.mouse_pos = glfw.get_cursor_pos(window)
    else:
        io.mouse_pos = -1, -1

    for i in xrange(3):
        io.mouse_down[i] = glfw.get_mouse_button(window, i)

    imgui.new_frame()


def imp_glfw_init():
    io = imgui.get_io()

    key_map = io.key_map

    key_map[imgui.KEY_TAB] = glfw.KEY_TAB
    key_map[imgui.KEY_LEFT_ARROW] = glfw.KEY_LEFT
    key_map[imgui.KEY_RIGHT_ARROW] = glfw.KEY_RIGHT
    key_map[imgui.KEY_UP_ARROW] = glfw.KEY_UP
    key_map[imgui.KEY_DOWN_ARROW] = glfw.KEY_DOWN
    key_map[imgui.KEY_PAGE_UP] = glfw.KEY_PAGE_UP
    key_map[imgui.KEY_PAGE_DOWN] = glfw.KEY_PAGE_DOWN
    key_map[imgui.KEY_HOME] = glfw.KEY_HOME
    key_map[imgui.KEY_END] = glfw.KEY_END
    key_map[imgui.KEY_DELETE] = glfw.KEY_DELETE
    key_map[imgui.KEY_BACKSPACE] = glfw.KEY_BACKSPACE
    key_map[imgui.KEY_ENTER] = glfw.KEY_ENTER
    key_map[imgui.KEY_ESCAPE] = glfw.KEY_ESCAPE
    key_map[imgui.KEY_A] = glfw.KEY_A
    key_map[imgui.KEY_C] = glfw.KEY_C
    key_map[imgui.KEY_V] = glfw.KEY_V
    key_map[imgui.KEY_X] = glfw.KEY_X
    key_map[imgui.KEY_Y] = glfw.KEY_Y
    key_map[imgui.KEY_Z] = glfw.KEY_Z


def imp_create_device_objects():
    io = imgui.get_io()

    global g_ShaderHandle
    global g_VertHandle
    global g_FragHandle

    global g_AttribLocationTex
    global g_AttribLocationProjMtx
    global g_AttribLocationPosition
    global g_AttribLocationUV
    global g_AttribLocationColor

    global g_VboHandle
    global g_ElementsHandle
    global g_VaoHandle

    # save state
    last_texture = gl.glGetIntegerv(gl.GL_TEXTURE_BINDING_2D)
    last_array_buffer = gl.glGetIntegerv(gl.GL_ARRAY_BUFFER_BINDING)
    last_vertex_array = gl.glGetIntegerv(gl.GL_VERTEX_ARRAY_BINDING)

    vertex_shader = """
        #version 330
        uniform mat4 ProjMtx;
        in vec2 Position;
        in vec2 UV;
        in vec4 Color;
        out vec2 Frag_UV;
        out vec4 Frag_Color;
        void main()
        {
            Frag_UV = UV;
            Frag_Color = Color;
            gl_Position = ProjMtx * vec4(Position.xy, 0, 1);
        }
    """

    fragment_shader = """
        #version 330
        uniform sampler2D Texture;
        in vec2 Frag_UV;
        in vec4 Frag_Color;
        out vec4 Out_Color;
        void main()
        {
            Out_Color = Frag_Color * texture(Texture, Frag_UV.st);
        }
    """
    g_ShaderHandle = gl.glCreateProgram()
    g_VertHandle = gl.glCreateShader(gl.GL_VERTEX_SHADER)
    g_FragHandle = gl.glCreateShader(gl.GL_FRAGMENT_SHADER)

    gl.glShaderSource(g_VertHandle, vertex_shader)
    gl.glShaderSource(g_FragHandle, fragment_shader)
    gl.glCompileShader(g_VertHandle)
    gl.glCompileShader(g_FragHandle)

    gl.glAttachShader(g_ShaderHandle, g_VertHandle)
    gl.glAttachShader(g_ShaderHandle, g_FragHandle)

    gl.glLinkProgram(g_ShaderHandle)

    g_AttribLocationTex = gl.glGetUniformLocation(g_ShaderHandle, "Texture")
    g_AttribLocationProjMtx = gl.glGetUniformLocation(g_ShaderHandle, "ProjMtx")
    g_AttribLocationPosition = gl.glGetAttribLocation(g_ShaderHandle, "Position")
    g_AttribLocationUV = gl.glGetAttribLocation(g_ShaderHandle, "UV")
    g_AttribLocationColor = gl.glGetAttribLocation(g_ShaderHandle, "Color")

    g_VboHandle = gl.glGenBuffers(1)
    g_ElementsHandle = gl.glGenBuffers(1)

    g_VaoHandle = gl.glGenVertexArrays(1)
    gl.glBindVertexArray(g_VaoHandle)
    gl.glBindBuffer(gl.GL_ARRAY_BUFFER, g_VboHandle)
    gl.glEnableVertexAttribArray(g_AttribLocationPosition)
    gl.glEnableVertexAttribArray(g_AttribLocationUV)
    gl.glEnableVertexAttribArray(g_AttribLocationColor)

    gl.glVertexAttribPointer(g_AttribLocationPosition, 2, gl.GL_FLOAT, gl.GL_FALSE, imgui.VERTEX_SIZE, ctypes.c_void_p(imgui.VERTEX_BUFFER_POS_OFFSET))
    gl.glVertexAttribPointer(g_AttribLocationUV, 2, gl.GL_FLOAT, gl.GL_FALSE, imgui.VERTEX_SIZE, ctypes.c_void_p(imgui.VERTEX_BUFFER_UV_OFFSET))
    gl.glVertexAttribPointer(g_AttribLocationColor, 4, gl.GL_UNSIGNED_BYTE, gl.GL_TRUE, imgui.VERTEX_SIZE, ctypes.c_void_p(imgui.VERTEX_BUFFER_COL_OFFSET))

    imp_create_font_texture()

    # restore state
    gl.glBindTexture(gl.GL_TEXTURE_2D, last_texture)
    gl.glBindBuffer(gl.GL_ARRAY_BUFFER, last_array_buffer)
    gl.glBindVertexArray(last_vertex_array)


g_FontTexture = None


def imp_create_font_texture():
    global g_FontTexture

    # save texture state
    last_texture = gl.glGetIntegerv(gl.GL_TEXTURE_BINDING_2D)

    io = imgui.get_io()

    width, height, pixels = io.fonts.get_tex_data_as_rgba32()
    g_FontTexture = gl.glGenTextures(1)

    gl.glBindTexture(gl.GL_TEXTURE_2D, g_FontTexture)
    gl.glTexParameteri(gl.GL_TEXTURE_2D, gl.GL_TEXTURE_MIN_FILTER, gl.GL_LINEAR)
    gl.glTexParameteri(gl.GL_TEXTURE_2D, gl.GL_TEXTURE_MAG_FILTER, gl.GL_LINEAR)
    gl.glTexImage2D(gl.GL_TEXTURE_2D, 0, gl.GL_RGBA, width, height, 0, gl.GL_RGBA, gl.GL_UNSIGNED_BYTE, pixels)

    io.fonts.texture_id = g_FontTexture
    gl.glBindTexture(gl.GL_TEXTURE_2D, last_texture)


def imp_glwf_render(draw_data):
    io = imgui.get_io()
    display_width, display_height = io.display_size
    fb_width = int(display_width * io.display_fb_scale[0])
    fb_height = int(display_height * io.display_fb_scale[1])

    if fb_width == 0 or fb_height == 0:
        return

    draw_data.scale_clip_rects(*io.display_fb_scale)

    # backup GL state
    last_program = gl.glGetIntegerv(gl.GL_CURRENT_PROGRAM)
    last_texture = gl.glGetIntegerv(gl.GL_TEXTURE_BINDING_2D)
    last_active_texture = gl.glGetIntegerv(gl.GL_ACTIVE_TEXTURE)
    last_array_buffer = gl.glGetIntegerv(gl.GL_ARRAY_BUFFER_BINDING)
    last_element_array_buffer = gl.glGetIntegerv(gl.GL_ELEMENT_ARRAY_BUFFER_BINDING)
    last_vertex_array = gl.glGetIntegerv(gl.GL_VERTEX_ARRAY_BINDING)
    last_blend_src = gl.glGetIntegerv(gl.GL_BLEND_SRC)
    last_blend_dst = gl.glGetIntegerv(gl.GL_BLEND_DST)
    last_blend_equation_rgb = gl. glGetIntegerv(gl.GL_BLEND_EQUATION_RGB)
    last_blend_equation_alpha = gl.glGetIntegerv(gl.GL_BLEND_EQUATION_ALPHA)
    last_viewport = gl.glGetIntegerv(gl.GL_VIEWPORT)
    last_scissor_box = gl.glGetIntegerv(gl.GL_SCISSOR_BOX)
    last_enable_blend = gl.glIsEnabled(gl.GL_BLEND)
    last_enable_cull_face = gl.glIsEnabled(gl.GL_CULL_FACE)
    last_enable_depth_test = gl.glIsEnabled(gl.GL_DEPTH_TEST)
    last_enable_scissor_test = gl.glIsEnabled(gl.GL_SCISSOR_TEST)

    gl.glEnable(gl.GL_BLEND)
    gl.glBlendEquation(gl.GL_FUNC_ADD)
    gl.glBlendFunc(gl.GL_SRC_ALPHA, gl.GL_ONE_MINUS_SRC_ALPHA)
    gl.glDisable(gl.GL_CULL_FACE)
    gl.glDisable(gl.GL_DEPTH_TEST)
    gl.glEnable(gl.GL_SCISSOR_TEST)
    gl.glActiveTexture(gl.GL_TEXTURE0)

    gl.glViewport(0, 0, int(fb_width), int(fb_height))

    ortho_projection = [
        [ 2.0/display_width, 0.0,                   0.0, 0.0],
        [ 0.0,               2.0/-display_height,   0.0, 0.0],
        [ 0.0,               0.0,                  -1.0, 0.0],
        [-1.0,               1.0,                   0.0, 1.0]
    ]

    gl.glUseProgram(g_ShaderHandle)
    gl.glUniform1i(g_AttribLocationTex, 0)
    gl.glUniformMatrix4fv(g_AttribLocationProjMtx, 1, gl.GL_FALSE, ortho_projection)
    gl.glBindVertexArray(g_VaoHandle)

    for commands in draw_data.commands_lists:
        idx_buffer_offset = 0

        gl.glBindBuffer(gl.GL_ARRAY_BUFFER, g_VboHandle)
        # todo: check this (sizes)
        gl.glBufferData(gl.GL_ARRAY_BUFFER, commands.vtx_buffer_size * imgui.VERTEX_SIZE, ctypes.c_void_p(commands.vtx_buffer_data), gl.GL_STREAM_DRAW)

        gl.glBindBuffer(gl.GL_ELEMENT_ARRAY_BUFFER, g_ElementsHandle)
        # todo: check this (sizes)
        gl.glBufferData(gl.GL_ELEMENT_ARRAY_BUFFER, commands.idx_buffer_size * imgui.INDEX_SIZE, ctypes.c_void_p(commands.idx_buffer_data), gl.GL_STREAM_DRAW)

        # todo: allow to iterate over _CmdList
        for command in commands.commands:
            gl.glBindTexture(gl.GL_TEXTURE_2D, command.texture_id)

            # todo: use named tuple
            x, y, w, z = command.clip_rect
            gl.glScissor(int(x), int(fb_height - w), int(z - x), int(w - y))

            if imgui.INDEX_SIZE == 2:
                gltype = gl.GL_UNSIGNED_SHORT
            else:
                gltype = gl.GL_UNSIGNED_INT

            gl.glDrawElements(gl.GL_TRIANGLES, command.elem_count, gltype, ctypes.c_void_p(idx_buffer_offset))

            idx_buffer_offset += command.elem_count * imgui.INDEX_SIZE

    # restore modified GL state
    gl.glUseProgram(last_program)
    gl.glActiveTexture(last_active_texture)
    gl.glBindTexture(gl.GL_TEXTURE_2D, last_texture)
    gl.glBindVertexArray(last_vertex_array)
    gl.glBindBuffer(gl.GL_ARRAY_BUFFER, last_array_buffer)
    gl.glBindBuffer(gl.GL_ELEMENT_ARRAY_BUFFER, last_element_array_buffer)
    gl.glBlendEquationSeparate(last_blend_equation_rgb, last_blend_equation_alpha)
    gl.glBlendFunc(last_blend_src, last_blend_dst)

    if last_enable_blend:
        gl.glEnable(gl.GL_BLEND)
    else:
        gl.glDisable(gl.GL_BLEND)

    if last_enable_cull_face:
        gl.glEnable(gl.GL_CULL_FACE)
    else:
        gl.glDisable(gl.GL_CULL_FACE)

    if last_enable_depth_test:
        gl.glEnable(gl.GL_DEPTH_TEST)
    else:
        gl.glDisable(gl.GL_DEPTH_TEST)

    if last_enable_scissor_test:
        gl.glEnable(gl.GL_SCISSOR_TEST)
    else:
        gl.glDisable(gl.GL_SCISSOR_TEST)

    gl.glViewport(last_viewport[0], last_viewport[1], last_viewport[2], last_viewport[3])
    gl.glScissor(last_scissor_box[0], last_scissor_box[1], last_scissor_box[2], last_scissor_box[3])


def main():
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

    # Make the window's context current
    glfw.make_context_current(window)
    glfw.set_key_callback(window, keyboard_callback)
    glfw.set_cursor_pos_callback(window, mouse_callback)
    glfw.set_window_size_callback(window, resize_callback)
    glfw.set_char_callback(window, char_callback)

    # IMGUI io initialization
    io = imgui.get_io()
    io.display_size = width, height
    io.delta_time = 1.0 / 60.0
    io.render_callback = imp_glwf_render

    io.fonts.get_tex_data_as_rgba32()
    io.fonts.add_font_default()

    imp_create_device_objects()
    imp_glfw_init()

    def scroll_callback(window, x_offset, y_offset):
        io.mouse_wheel = y_offset

    glfw.set_scroll_callback(window, scroll_callback)

    opened = True
    style = imgui.GuiStyle()

    while not glfw.window_should_close(window):
        glfw.poll_events()
        imp_glfw_new_frame(window)

        imgui.show_user_guide()
        imgui.show_test_window()

        if opened:
            expanded, opened = imgui.begin("fooo", True)
            imgui.text("Bar")
            imgui.text_colored("Eggs", 0.2, 1., 0.)
            imgui.end()

        with imgui.styled(imgui.STYLE_ALPHA, 1):
            imgui.show_metrics_window()

        imgui.show_style_editor(style)

        width, height = glfw.get_framebuffer_size(window)

        gl.glViewport(0, 0, int(width), int(height))
        gl.glClearColor(114/255., 144/255., 154/255., 1)
        gl.glClear(gl.GL_COLOR_BUFFER_BIT)
        #
        imgui.render()
        glfw.swap_buffers(window)

    glfw.terminate()


if __name__ == "__main__":
    main()
