# -*- coding: utf-8 -*-
from sdl2 import *
import OpenGL.GL as gl

import imgui
import ctypes


class SDL2Impl(object):
    """Basic SDL2 integration implementation."""

    def __init__(self, window):
        self.window = window

        self.io = imgui.get_io()

        self._shader_handle = None
        self._vert_handle = None
        self._fragment_handle = None

        self._attrib_location_tex = None
        self._attrib_proj_mtx = None
        self._attrib_location_position = None
        self._attrib_location_uv = None
        self._attrib_location_color = None

        self._vbo_handle = None
        self._elements_handle = None
        self._vao_handle = None

        self._font_texture = None

        self.mouse_pressed = [False, False, False]
        self.mouse_wheel = 0.0
        self.gui_time = 0.0

    def enable(self):
        time = SDL_GetTicks()
        current_time = time / 1000.0
        self.io.delta_time = (current_time - self.gui_time) if self.gui_time > 0.0 else (1.0 / 60.0)
        self.gui_time = current_time
        s_w = ctypes.pointer(ctypes.c_int(0))
        s_h = ctypes.pointer(ctypes.c_int(0))
        SDL_GetWindowSize(self.window, s_w, s_h)
        w = s_w.contents.value
        h = s_h.contents.value

        self.io.display_size = w, h

        # setup default font
        self.io.fonts.get_tex_data_as_rgba32()
        self.io.fonts.add_font_default()

        self._create_device_objects()
        self._map_keys()

        self.io.render_callback = self.render

    def _map_keys(self):
        key_map = self.io.key_map

        key_map[imgui.KEY_TAB] = SDLK_TAB
        key_map[imgui.KEY_LEFT_ARROW] = SDL_SCANCODE_LEFT
        key_map[imgui.KEY_RIGHT_ARROW] = SDL_SCANCODE_RIGHT
        key_map[imgui.KEY_UP_ARROW] = SDL_SCANCODE_UP
        key_map[imgui.KEY_DOWN_ARROW] = SDL_SCANCODE_DOWN
        key_map[imgui.KEY_PAGE_UP] = SDL_SCANCODE_PAGEUP
        key_map[imgui.KEY_PAGE_DOWN] = SDL_SCANCODE_PAGEDOWN
        key_map[imgui.KEY_HOME] = SDL_SCANCODE_HOME
        key_map[imgui.KEY_END] = SDL_SCANCODE_END
        key_map[imgui.KEY_DELETE] = SDLK_DELETE
        key_map[imgui.KEY_BACKSPACE] = SDLK_BACKSPACE
        key_map[imgui.KEY_ENTER] = SDLK_RETURN
        key_map[imgui.KEY_ESCAPE] = SDLK_ESCAPE
        key_map[imgui.KEY_A] = SDLK_a
        key_map[imgui.KEY_C] = SDLK_c
        key_map[imgui.KEY_V] = SDLK_v
        key_map[imgui.KEY_X] = SDLK_x
        key_map[imgui.KEY_Y] = SDLK_y
        key_map[imgui.KEY_Z] = SDLK_z

    def process_event(self, event):
        io = self.io

        if event.type == SDL_MOUSEWHEEL:
            if event.wheel.y > 0:
                self.mouse_wheel = 1
            if event.wheel.y < 0:
                self.mouse_wheel = -1
            return True

        if event.type == SDL_MOUSEBUTTONDOWN:
            if event.button.button == SDL_BUTTON_LEFT:
                self.mouse_pressed[0] = True
            if event.button.button == SDL_BUTTON_RIGHT:
                self.mouse_pressed[1] = True
            if event.button.button == SDL_BUTTON_MIDDLE:
                self.mouse_pressed[2] = True
            return True

        if event.type == SDL_KEYUP or event.type == SDL_KEYDOWN:
            key = event.key.keysym.sym & ~SDLK_SCANCODE_MASK
            if key < SDL_NUM_SCANCODES:
                io.keys_down[key] = event.type == SDL_KEYDOWN
            io.key_shift = ((SDL_GetModState() & KMOD_SHIFT) != 0)
            io.key_ctrl = ((SDL_GetModState() & KMOD_CTRL) != 0)
            io.key_alt = ((SDL_GetModState() & KMOD_ALT) != 0)
            if 0 < key < 0x10000 and event.type == SDL_KEYDOWN:
                io.add_input_character(key)
            return True

    def new_frame(self):
        if not self._font_texture:
            self._create_device_objects()

        io = imgui.get_io()

        s_w = ctypes.pointer(ctypes.c_int(0))
        s_h = ctypes.pointer(ctypes.c_int(0))
        SDL_GetWindowSize(self.window, s_w, s_h)
        w = s_w.contents.value
        h = s_h.contents.value

        io.display_size = w, h
        io.display_fb_scale = 1, 1

        io.delta_time = 1.0 / 60

        mx = ctypes.pointer(ctypes.c_int(0))
        my = ctypes.pointer(ctypes.c_int(0))
        mouse_mask = SDL_GetMouseState(mx, my)
        if SDL_GetWindowFlags(self.window) & SDL_WINDOW_MOUSE_FOCUS:
            io.mouse_pos = mx.contents.value, my.contents.value
        else:
            io.mouse_pos = -1, -1

        io.mouse_down[0] = self.mouse_pressed[0] or (mouse_mask & SDL_BUTTON(SDL_BUTTON_LEFT)) != 0
        io.mouse_down[1] = self.mouse_pressed[1] or (mouse_mask & SDL_BUTTON(SDL_BUTTON_RIGHT)) != 0
        io.mouse_down[2] = self.mouse_pressed[2] or (mouse_mask & SDL_BUTTON(SDL_BUTTON_MIDDLE)) != 0
        self.mouse_pressed = [False, False, False]

        io.mouse_wheel = self.mouse_wheel

        imgui.new_frame()

    def render(self, draw_data):
        # perf: local for faster access
        io = self.io

        display_width, display_height = self.io.display_size
        fb_width = int(display_width * io.display_fb_scale[0])
        fb_height = int(display_height * io.display_fb_scale[1])

        if fb_width == 0 or fb_height == 0:
            return ''

        draw_data.scale_clip_rects(*io.display_fb_scale)

        last_program = gl.glGetIntegerv(gl.GL_CURRENT_PROGRAM)
        last_texture = gl.glGetIntegerv(gl.GL_TEXTURE_BINDING_2D)
        last_active_texture = gl.glGetIntegerv(gl.GL_ACTIVE_TEXTURE)
        last_array_buffer = gl.glGetIntegerv(gl.GL_ARRAY_BUFFER_BINDING)
        last_element_array_buffer = gl.glGetIntegerv(gl.GL_ELEMENT_ARRAY_BUFFER_BINDING)
        last_vertex_array = gl.glGetIntegerv(gl.GL_VERTEX_ARRAY_BINDING)
        last_blend_src = gl.glGetIntegerv(gl.GL_BLEND_SRC)
        last_blend_dst = gl.glGetIntegerv(gl.GL_BLEND_DST)
        last_blend_equation_rgb = gl.glGetIntegerv(gl.GL_BLEND_EQUATION_RGB)
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

        gl.glUseProgram(self._shader_handle)
        gl.glUniform1i(self._attrib_location_tex, 0)
        gl.glUniformMatrix4fv(self._attrib_proj_mtx, 1, gl.GL_FALSE, ortho_projection)
        gl.glBindVertexArray(self._vao_handle)

        for commands in draw_data.commands_lists:
            idx_buffer_offset = 0

            gl.glBindBuffer(gl.GL_ARRAY_BUFFER, self._vbo_handle)
            # todo: check this (sizes)
            gl.glBufferData(gl.GL_ARRAY_BUFFER, commands.vtx_buffer_size * imgui.VERTEX_SIZE, ctypes.c_void_p(commands.vtx_buffer_data), gl.GL_STREAM_DRAW)

            gl.glBindBuffer(gl.GL_ELEMENT_ARRAY_BUFFER, self._elements_handle)
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

    def shutdown(self):
        self.invalidate_device_objects()
        imgui.shutdown()

    def invalidate_device_objects(self):
        if self._vao_handle > -1:
            gl.glDeleteVertexArrays(1, self._vao_handle)
        if self._vbo_handle > -1:
            gl.glDeleteBuffers(1, self._vbo_handle)
        if self._elements_handle > -1:
            gl.glDeleteBuffers(1, self._elements_handle)
        self._vao_handle = self._vbo_handle = self._elements_handle = 0

        gl.glDeleteProgram(self._shader_handle)
        self._shader_handle = 0

        if self._font_texture > -1:
            gl.glDeleteTextures(self._font_texture)
        self.io.fonts.texture_id = 0
        self._font_texture = 0

    def _create_device_objects(self):
        vertex_shader_src = """
        #version 330

        uniform mat4 ProjMtx;
        in vec2 Position;
        in vec2 UV;
        in vec4 Color;
        out vec2 Frag_UV;
        out vec4 Frag_Color;

        void main() {
            Frag_UV = UV;
            Frag_Color = Color;

            gl_Position = ProjMtx * vec4(Position.xy, 0, 1);
        }
        """

        fragment_shader_src = """
        #version 330

        uniform sampler2D Texture;
        in vec2 Frag_UV;
        in vec4 Frag_Color;
        out vec4 Out_Color;

        void main() {
            Out_Color = Frag_Color * texture(Texture, Frag_UV.st);
        }
        """

        # save state
        last_texture = gl.glGetIntegerv(gl.GL_TEXTURE_BINDING_2D)
        last_array_buffer = gl.glGetIntegerv(gl.GL_ARRAY_BUFFER_BINDING)

        last_vertex_array = gl.glGetIntegerv(gl.GL_VERTEX_ARRAY_BINDING)

        self._shader_handle = gl.glCreateProgram()
        # note: no need to store shader parts handles after linking
        vertex_shader = gl.glCreateShader(gl.GL_VERTEX_SHADER)
        fragment_shader = gl.glCreateShader(gl.GL_FRAGMENT_SHADER)

        gl.glShaderSource(vertex_shader, vertex_shader_src)
        gl.glShaderSource(fragment_shader, fragment_shader_src)
        gl.glCompileShader(vertex_shader)
        gl.glCompileShader(fragment_shader)

        gl.glAttachShader(self._shader_handle, vertex_shader)
        gl.glAttachShader(self._shader_handle, fragment_shader)

        gl.glLinkProgram(self._shader_handle)

        # todo: remove shader parts after linking

        self._attrib_location_tex = gl.glGetUniformLocation(self._shader_handle, "Texture")
        self._attrib_proj_mtx = gl.glGetUniformLocation(self._shader_handle, "ProjMtx")
        self._attrib_location_position = gl.glGetAttribLocation(self._shader_handle, "Position")
        self._attrib_location_uv = gl.glGetAttribLocation(self._shader_handle, "UV")
        self._attrib_location_color = gl.glGetAttribLocation(self._shader_handle, "Color")

        self._vbo_handle = gl.glGenBuffers(1)
        self._elements_handle = gl.glGenBuffers(1)

        self._vao_handle = gl.glGenVertexArrays(1)
        gl.glBindVertexArray(self._vao_handle)
        gl.glBindBuffer(gl.GL_ARRAY_BUFFER, self._vbo_handle)

        gl.glEnableVertexAttribArray(self._attrib_location_position)
        gl.glEnableVertexAttribArray(self._attrib_location_uv)
        gl.glEnableVertexAttribArray(self._attrib_location_color)

        gl.glVertexAttribPointer(self._attrib_location_position, 2, gl.GL_FLOAT, gl.GL_FALSE, imgui.VERTEX_SIZE, ctypes.c_void_p(imgui.VERTEX_BUFFER_POS_OFFSET))
        gl.glVertexAttribPointer(self._attrib_location_uv, 2, gl.GL_FLOAT, gl.GL_FALSE, imgui.VERTEX_SIZE, ctypes.c_void_p(imgui.VERTEX_BUFFER_UV_OFFSET))
        gl.glVertexAttribPointer(self._attrib_location_color, 4, gl.GL_UNSIGNED_BYTE, gl.GL_TRUE, imgui.VERTEX_SIZE, ctypes.c_void_p(imgui.VERTEX_BUFFER_COL_OFFSET))

        self._create_font_texture()

        # restore state
        gl.glBindTexture(gl.GL_TEXTURE_2D, last_texture)
        gl.glBindBuffer(gl.GL_ARRAY_BUFFER, last_array_buffer)
        gl.glBindVertexArray(last_vertex_array)

    def _create_font_texture(self):
        # save texture state
        last_texture = gl.glGetIntegerv(gl.GL_TEXTURE_BINDING_2D)

        width, height, pixels = self.io.fonts.get_tex_data_as_rgba32()
        self._font_texture = gl.glGenTextures(1)

        gl.glBindTexture(gl.GL_TEXTURE_2D, self._font_texture)
        gl.glTexParameteri(gl.GL_TEXTURE_2D, gl.GL_TEXTURE_MIN_FILTER, gl.GL_LINEAR)
        gl.glTexParameteri(gl.GL_TEXTURE_2D, gl.GL_TEXTURE_MAG_FILTER, gl.GL_LINEAR)
        gl.glTexImage2D(gl.GL_TEXTURE_2D, 0, gl.GL_RGBA, width, height, 0, gl.GL_RGBA, gl.GL_UNSIGNED_BYTE, pixels)

        self.io.fonts.texture_id = self._font_texture
        gl.glBindTexture(gl.GL_TEXTURE_2D, last_texture)
