# -*- coding: utf-8 -*-
import numpy as np

import ctypes
from ctypes import *
import imgui
from imgui.integrations.opengl import BaseOpenGLRenderer

from glumpy import  gloo, gl

from matplotlib import pyplot as plt

from glumpy.log import log

import glfw

from imgui.integrations import compute_fb_scale

class GlumpyRenderer(BaseOpenGLRenderer):
    
    """GLumpy backend for pyimgui. The code borrows heavily from the glfw integration. """

    VERTEX_SHADER_SRC = """
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

    FRAGMENT_SHADER_SRC = """
    #version 330
    uniform sampler2D Texture;
    in vec2 Frag_UV;
    in vec4 Frag_Color;
    out vec4 Out_Color;
    void main() {
        vec4 col = Frag_Color; //original
        Out_Color = col * texture(Texture, Frag_UV.st); //original
        
    }
    """
    
    io = None;
    prog : gloo.Program = None;
    
    def __init__(self, window, attach_callbacks=True ):
        
        #self.io is initialized by super-class
        super(GlumpyRenderer, self).__init__();
    
        self.window = window

        if attach_callbacks:
            glfw.set_key_callback(self.window, self.keyboard_callback)
            glfw.set_cursor_pos_callback(self.window, self.mouse_callback)
            glfw.set_window_size_callback(self.window, self.resize_callback)
            glfw.set_char_callback(self.window, self.char_callback)
            glfw.set_scroll_callback(self.window, self.scroll_callback)

        self.io.display_size = glfw.get_framebuffer_size(self.window)
        #self.io.get_clipboard_text_fn = self._get_clipboard_text
        #self.io.set_clipboard_text_fn = self._set_clipboard_text

        self._map_keys()
        self._gui_time = None

    def _get_clipboard_text(self):
        return glfw.get_clipboard_string(self.window)

    def _set_clipboard_text(self, text):
        glfw.set_clipboard_string(self.window, text)

    def _map_keys(self):
        key_map = self.io.key_map

        key_map[imgui.KEY_TAB] = glfw.KEY_TAB
        key_map[imgui.KEY_LEFT_ARROW] = glfw.KEY_LEFT
        key_map[imgui.KEY_RIGHT_ARROW] = glfw.KEY_RIGHT
        key_map[imgui.KEY_UP_ARROW] = glfw.KEY_UP
        key_map[imgui.KEY_DOWN_ARROW] = glfw.KEY_DOWN
        key_map[imgui.KEY_PAGE_UP] = glfw.KEY_PAGE_UP
        key_map[imgui.KEY_PAGE_DOWN] = glfw.KEY_PAGE_DOWN
        key_map[imgui.KEY_HOME] = glfw.KEY_HOME
        key_map[imgui.KEY_END] = glfw.KEY_END
        key_map[imgui.KEY_INSERT] = glfw.KEY_INSERT
        key_map[imgui.KEY_DELETE] = glfw.KEY_DELETE
        key_map[imgui.KEY_BACKSPACE] = glfw.KEY_BACKSPACE
        key_map[imgui.KEY_SPACE] = glfw.KEY_SPACE
        key_map[imgui.KEY_ENTER] = glfw.KEY_ENTER
        key_map[imgui.KEY_ESCAPE] = glfw.KEY_ESCAPE
        key_map[imgui.KEY_PAD_ENTER] = glfw.KEY_KP_ENTER
        key_map[imgui.KEY_A] = glfw.KEY_A
        key_map[imgui.KEY_C] = glfw.KEY_C
        key_map[imgui.KEY_V] = glfw.KEY_V
        key_map[imgui.KEY_X] = glfw.KEY_X
        key_map[imgui.KEY_Y] = glfw.KEY_Y
        key_map[imgui.KEY_Z] = glfw.KEY_Z

    def keyboard_callback(self, window, key, scancode, action, mods):
        # perf: local for faster access
        io = self.io

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

    def char_callback(self, window, char):
        io = imgui.get_io()

        if 0 < char < 0x10000:
            io.add_input_character(char)

    def resize_callback(self, window, width, height):
        self.io.display_size = width, height

    def mouse_callback(self, *args, **kwargs):
        pass

    def scroll_callback(self, window, x_offset, y_offset):
        self.io.mouse_wheel_horizontal = x_offset
        self.io.mouse_wheel = y_offset

    def process_inputs(self):
        io = imgui.get_io()

        window_size = glfw.get_window_size(self.window)
        fb_size = glfw.get_framebuffer_size(self.window)

        io.display_size = window_size
        io.display_fb_scale = compute_fb_scale(window_size, fb_size)
        io.delta_time = 1.0/60

        if glfw.get_window_attrib(self.window, glfw.FOCUSED):
            io.mouse_pos = glfw.get_cursor_pos(self.window)
        else:
            io.mouse_pos = -1, -1

        io.mouse_down[0] = glfw.get_mouse_button(self.window, 0)
        io.mouse_down[1] = glfw.get_mouse_button(self.window, 1)
        io.mouse_down[2] = glfw.get_mouse_button(self.window, 2)

        current_time = glfw.get_time()

        if self._gui_time:
            io.delta_time = current_time - self._gui_time
        else:
            io.delta_time = 1. / 60.
        if(io.delta_time <= 0.0): io.delta_time = 1./ 1000.

        self._gui_time = current_time
    
    #called first by super-class constructor after self.io is filled
    def _create_device_objects(self):
        self.prog = gloo.Program( self.VERTEX_SHADER_SRC, self.FRAGMENT_SHADER_SRC, version=330 );
       
        if False:
            dtype = [('Color', np.float32, 4),
                     ('Position', np.float32, 2),
                     ('UV', np.float32, 2)];
            v_array = np.zeros(4, dtype).view(gloo.VertexArray)
            # Four colors
            v_array['Color'] = [ (1,0,0,1), (0,1,0,1), (0,0,1,1), (0,0,0,1) ]
            v_array['Position'] = [ (-1,-1),   (-1,+1),   (+1,-1),   (+1,+1)   ]
            v_array['UV'] = [ (0,1),   (0,0),   (1,1),   (1,0)   ]
    
            self.prog.bind( v_array );
            
            
            unitmat = np.eye( 4, dtype=np.float32 );
            self.prog['ProjMtx'] = unitmat;        
          
    
    #called second by super-class constructor
    def refresh_font_texture(self):
        
        self.io.fonts.add_font_default()
        width, height, pixels = self.io.fonts.get_tex_data_as_rgba32();
        
        tex = np.frombuffer( pixels, dtype=np.uint8 ).reshape(height, width,4);
        self.prog['Texture'] = tex;
        
        
    def render( self, draw_data ):
        
        
        # perf: local for faster access
        io = self.io

        display_width, display_height = io.display_size
        fb_width = int(display_width * io.display_fb_scale[0])
        fb_height = int(display_height * io.display_fb_scale[1])

        if fb_width == 0 or fb_height == 0:
            return

        draw_data.scale_clip_rects(*io.display_fb_scale)

        # backup GL state
        # todo: provide cleaner version of this backup-restore code
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
        #gl.glActiveTexture(gl.GL_TEXTURE0)

        gl.glViewport(0, 0, int(fb_width), int(fb_height))

        ortho_projection = (ctypes.c_float * 16)(
             2.0/display_width, 0.0,                   0.0, 0.0,
             0.0,               2.0/-display_height,   0.0, 0.0,
             0.0,               0.0,                  -1.0, 0.0,
            -1.0,               1.0,                   0.0, 1.0
        )

        self.prog["ProjMtx"] = ortho_projection;

        for commands in draw_data.commands_lists:
        
            
            idx_buffer_offset = 0
    
            array_type = c_ubyte * commands.vtx_buffer_size * imgui.VERTEX_SIZE;
            data_carray = array_type.from_address(commands.vtx_buffer_data)
            
            if not ( imgui.VERTEX_BUFFER_POS_OFFSET == 0 and \
                     imgui.VERTEX_BUFFER_UV_OFFSET == 8 and \
                     imgui.VERTEX_BUFFER_COL_OFFSET == 16 ):
                log.error("GlumpyRenderer.render(): imgui vertex buffer layout has changed ! notify the developers ..." );
                
                return;
        
            #TODO: this is a bit convoluted; Imgui delivers uint8 colors, but glumpy wants float32's 
            dtype = [('Position', np.float32, 2),
                     ('UV', np.float32, 2),
                     ('Color', np.uint8, 4)];
            vao_content = np.frombuffer( data_carray, dtype=dtype );
          
            dtype2 = [('Position', np.float32, 2),
                     ('UV', np.float32, 2),
                     ('Color', np.float32, 4)];
            vao_content_f = np.zeros( vao_content.shape, dtype=dtype2 );
            for i,val in enumerate(vao_content):
                vao_content_f[i] = vao_content[i];
                vao_content_f[i]['Color'] /= 255;
                    
             
            v_array = vao_content_f.view(gloo.VertexArray)
            self.prog.bind( v_array );
    
            if imgui.INDEX_SIZE == 1:
                dtype =np.uint8;
            if imgui.INDEX_SIZE == 2:
                dtype =np.uint16;
            if imgui.INDEX_SIZE == 4:
                dtype =np.uint32;
                
            # gl.glBindBuffer(gl.GL_ELEMENT_ARRAY_BUFFER, self._elements_handle)
            # # todo: check this (sizes)
            # gl.glBufferData(gl.GL_ELEMENT_ARRAY_BUFFER, commands.idx_buffer_size * imgui.INDEX_SIZE, ctypes.c_void_p(commands.idx_buffer_data), gl.GL_STREAM_DRAW)
            array_type  = c_ubyte * commands.idx_buffer_size * imgui.INDEX_SIZE;
            data_carray = array_type.from_address(commands.idx_buffer_data);
            idx_content = np.frombuffer( data_carray, dtype=dtype );
            
            for command in commands.commands:
                
                
                # TODO: ImGui Images will not work yet, homogenizing texture id 
                # allocation by imgui/glumpy is likely a larger issue
                #
                #accessing command.texture_id crashes the prog
                #
                #gl.glBindTexture(gl.GL_TEXTURE_2D, command.texture_id )
                
                x, y, z, w = command.clip_rect
                gl.glScissor(int(x), int(fb_height - w), int(z - x), int(w - y))
    
                idx_array = idx_content[idx_buffer_offset:(idx_buffer_offset+command.elem_count)].view(gloo.IndexBuffer);
                self.prog.draw( mode = gl.GL_TRIANGLES, indices = idx_array );
    
                idx_buffer_offset += command.elem_count;
                
    
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
    
        log.debug("----------------------end---------------------------------")  
        
        
    def _invalidate_device_objects(self):
        pass
    