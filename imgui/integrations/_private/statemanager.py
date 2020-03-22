from typing import ContextManager

from OpenGL.GL import *
from contextlib import contextmanager
from functools import partial

def makeShaderProgram(vertex_src,fragment_src):
    program = glCreateProgram()
    # note: no need to store shader parts handles after linking

    vertex_shader = glCreateShader(GL_VERTEX_SHADER)
    fragment_shader = glCreateShader(GL_FRAGMENT_SHADER)

    glShaderSource(vertex_shader, vertex_src)
    glShaderSource(fragment_shader, fragment_src)

    glCompileShader(vertex_shader)
    glCompileShader(fragment_shader)

    glAttachShader(program, vertex_shader)
    glAttachShader(program, fragment_shader)

    glLinkProgram(program)

    # note: after linking shaders can be removed
    glDeleteShader(vertex_shader)
    glDeleteShader(fragment_shader)

    return program

class StateProperty:
    def __init__(self, getter, setter):
        self.getter = getter
        self.setter = setter

    def __get__(self, instance: 'State', owner):
        return self.getter()

    def __set__(self, instance: 'State', *value):
        if self not in instance.modified:
            instance.modified[self] = self.getter()
        self.setter(*value)


def bindingproperty(setter, binding_index, *setter_args):
    getter = (lambda: glGetIntegerv(binding_index))
    setter = partial(setter, *setter_args)
    return StateProperty(getter, setter)


def unpackbindingproperty(binding_index, setter, *setter_index):
    return bindingproperty((lambda x: setter(*x)), binding_index, *setter_index)



def enableproperty(index):
    getter = lambda: glIsEnabled(index)

    def setter(switch):
        if switch:
            glEnable(index)
        else:
            glDisable(index)

    return StateProperty(getter, setter)

def combiningbindingproperty(setter, *binding_indices):
    getter = (lambda: [glGetIntegerv(idx) for idx in binding_indices])
    # setter = (lambda *x: setter(*x))
    return StateProperty(getter, setter)

def _blendequationsetter(a):
    if isinstance(a,list):
        glBlendEquationSeparate(*a)
    else:
        glBlendEquation(a)
class State():
    arraybuffer = bindingproperty(glBindBuffer, GL_ARRAY_BUFFER_BINDING, GL_ARRAY_BUFFER)
    elementarraybuffer = bindingproperty(glBindBuffer, GL_ELEMENT_ARRAY_BUFFER_BINDING, GL_ELEMENT_ARRAY_BUFFER)
    vertexarray = bindingproperty(glBindVertexArray, GL_VERTEX_ARRAY_BINDING)
    texture2d = bindingproperty(glBindTexture, GL_TEXTURE_BINDING_2D, GL_TEXTURE_2D)
    activetexture = bindingproperty(glActiveTexture, GL_ACTIVE_TEXTURE)
    program = bindingproperty(glUseProgram, GL_CURRENT_PROGRAM)
    blendequation = combiningbindingproperty(
        _blendequationsetter, GL_BLEND_EQUATION_RGB, GL_BLEND_EQUATION_ALPHA)
    blendfunc = combiningbindingproperty((lambda a:glBlendFunc(*a)), GL_BLEND_SRC, GL_BLEND_DST)

    viewport = unpackbindingproperty(GL_VIEWPORT, glViewport)
    scissor_box = unpackbindingproperty(GL_SCISSOR_BOX, glScissor)

    blend = enableproperty(GL_BLEND)
    cull_face = enableproperty(GL_CULL_FACE)
    depth_test = enableproperty(GL_DEPTH_TEST)
    scissor_test = enableproperty(GL_SCISSOR_TEST)
    def __init__(self):
        self.modified = {}
    def revert(self):
        for prop,value in self.modified.items():
            prop.setter(value)
        self.modified = {}
    def confirm(self):
        self.modified = {}

@contextmanager
def statecontext() -> ContextManager[State]:
    state = State()
    yield state
    state.revert()