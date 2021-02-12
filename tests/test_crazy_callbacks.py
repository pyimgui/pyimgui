# -*- coding: utf-8 -*-
import glfw
import OpenGL.GL as gl

import imgui
from imgui.integrations.glfw import GlfwRenderer

class callable_class(object):
    def __init__(self, data):
        data.user_data.setSize(data.desired_size)

class foo(object):
    
    def __init__(self):
        self.size = (0,0)
    
    def method(self, data):
        self.size = data.desired_size
    
    @staticmethod
    def static_method(data):
        data.user_data.setSize(data.desired_size)
    
    def __call__(self, data):
        self.size = data.desired_size
    
def generate_lambda():
    return (lambda data : data.user_data.setSize(data.desired_size))

def generate_closure():
    counter = [0]
    def callback(data):
        counter[0] += 1
        data.user_data.setSize(data.desired_size)
        data.user_data.setCounter(counter[0])
    return callback

def my_decorator(func):
    counter = [0]
    def inner(*args, **kwargs):
        counter[0] += 1
        if counter[0] in (10,100,1000):
            print('Decorator counter is %i!' % counter[0])
        func(*args, **kwargs)
    return inner
    
@my_decorator
def my_func(data):
    data.user_data.setSize(data.desired_size)

def text_edit_callback(data):
    if(data.event_flag == imgui.INPUT_TEXT_CALLBACK_EDIT):
        print('EDIT')
        print('user_data:', data.user_data)
        print('event_flag:', data.event_flag)
        print('flags:', data.flags)
        print('event_char:', data.event_char)
        print('cursor_pos:', data.cursor_pos)
        print('selection_start:', data.selection_start)
        print('selection_end:', data.selection_end)
        
        print('buf:', data.buffer)
        print('buf text length:', data.buffer_text_length)
        print('buf size:', data.buffer_size)
        #data.selection_start = data.cursor_pos-1
        #data.selection_end = data.cursor_pos
        #data.cursor_pos = 0
        
        
    elif(data.event_flag == imgui.INPUT_TEXT_CALLBACK_CHAR_FILTER):
        print('FILTER')
        print('event_char:', data.event_char)
        
        if data.event_char == 'a':
            data.event_char = 'A'
            data.buffer_dirty = True
    else:
        
        if(data.has_selection()):
            print('selection_start:', data.selection_start)
            print('selection_end:', data.selection_end)
            begin = min(data.selection_start,data.selection_end)
            data.delete_chars(begin, abs(data.selection_end-data.selection_start))
            data.insert_chars(begin, "YOLO")
            data.selection_end = begin + len("YOLO")
            
        #data.delete_chars(0, len("Test"))
        #data.insert_chars(0, "Test")
        #data.select_all()
    
    return 0

def force_square_size_callback(data):
    
    #print('user_data:', data.user_data)
    #print('pos:', data.pos)
    #print('current_size:', data.current_size)
    
    data.desired_size = data.desired_size.x, data.desired_size.x
    
    return
    
def force_half_height_size_callback(data):
    data.desired_size = data.desired_size.x, data.desired_size.x/2

class special_info(object):
    
    def __init__(self):
        self.size = (0,0)
        self.counter = 0
    
    def setSize(self, size):
        self.size = size
    
    def setCounter(self, counter):
        self.counter = counter


def main():

    imgui.create_context()
    window = impl_glfw_init()
    impl = GlfwRenderer(window)
    
    # Utilities
    text_val = 'Change me!'
    spinf = special_info()
    foo_instance = foo()
    my_closure = generate_closure()

    while not glfw.window_should_close(window):
        glfw.poll_events()
        impl.process_inputs()

        imgui.new_frame()
        
        # === TEXT INPUT CALLBACKS ===
        
        imgui.begin('Text Callbacks')
        
        # No Callback
        changed, text_val = imgui.input_text('No callback', text_val, 512, 0)
        
        # Only one callback call
        changed, text_val = imgui.input_text('One callback', text_val, 512, 
                                                imgui.INPUT_TEXT_CALLBACK_CHAR_FILTER,
                                                text_edit_callback)
        
        # Callback is called multiple times depending on events
        changed, text_val = imgui.input_text('Multiple callback', text_val, 512, 
                                                imgui.INPUT_TEXT_CALLBACK_EDIT | 
                                                imgui.INPUT_TEXT_CALLBACK_CHAR_FILTER | 
                                                imgui.INPUT_TEXT_CALLBACK_HISTORY, 
                                                text_edit_callback, {'special':42})
        imgui.end()
        
        
        # === SIZE CALLBACKS ===
        
        # Multiple set don't leak memory, only last callback is used
        imgui.set_next_window_size_constraints((10,10), (1000,1000), force_square_size_callback, 'test')
        imgui.set_next_window_size_constraints((10,10), (1000,1000), force_half_height_size_callback)
        imgui.begin('Callback 1')
        imgui.end()
        
        # Next begin doesn't have callback anymore
        imgui.begin('Without callback after previous callback')
        imgui.end()
        
        # We can apply another callback for another begin()/end() pair
        imgui.set_next_window_size_constraints((10,10), (1000,1000), force_square_size_callback, 'test')
        imgui.begin('Callback 2')
        imgui.end()
            
        # Class callable
        imgui.set_next_window_size_constraints((200,10), (1000,1000), callable_class, spinf )
        imgui.begin('Callback: class')
        imgui.text("Window Size: %ix%i" % spinf.size)
        imgui.end()
        
        # Static method callable
        imgui.set_next_window_size_constraints((200,10), (1000,1000), foo.static_method, spinf )
        imgui.begin('Callback: static method')
        imgui.text("Window Size: %ix%i" % spinf.size)
        imgui.end()
        
        # Method callable - User Data can be sent via instance properties
        imgui.set_next_window_size_constraints((200,10), (1000,1000), foo_instance.method )
        imgui.begin('Callback: method')
        imgui.text("Window Size: %ix%i" % foo_instance.size)
        imgui.end()
        
        # Instance callable - User Data can be sent via instance properties
        imgui.set_next_window_size_constraints((200,10), (1000,1000), foo_instance )
        imgui.begin('Callback: callable instance')
        imgui.text("Window Size: %ix%i" % foo_instance.size)
        imgui.end()
        
        # Lambda callable
        imgui.set_next_window_size_constraints((10,10), (1000,1000), lambda data : data.user_data.setSize(data.desired_size), spinf )
        imgui.begin('Callback: lambda')
        imgui.text("Window Size: %ix%i" % spinf.size)
        imgui.end()
        
        # Generated lambda callable
        imgui.set_next_window_size_constraints((10,10), (1000,1000), generate_lambda(), spinf )
        imgui.begin('Callback: gen lambda')
        imgui.text("Window Size: %ix%i" % spinf.size)
        imgui.end()
        
        # Closure callable
        imgui.set_next_window_size_constraints((10,10), (1000,1000), my_closure, spinf )
        imgui.begin('Callback: closure')
        imgui.text("Window Size: %ix%i" % spinf.size)
        imgui.text("Counter: %i" % spinf.counter)
        imgui.end()
        
        # Decorated callable
        imgui.set_next_window_size_constraints((10,10), (1000,1000), my_func, spinf )
        imgui.begin('Callback: decorator')
        imgui.text("Window Size: %ix%i" % spinf.size)
        imgui.end()
        
        # === END OF TESTS ===
        
        gl.glClearColor(1., 1., 1., 1)
        gl.glClear(gl.GL_COLOR_BUFFER_BIT)

        imgui.render()
        impl.render(imgui.get_draw_data())
        glfw.swap_buffers(window)

    impl.shutdown()
    glfw.terminate()


def impl_glfw_init():
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


if __name__ == "__main__":
    main()
