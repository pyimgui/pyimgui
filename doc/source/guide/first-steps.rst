.. _guide-first-steps:

First steps with imgui
======================

In this tutorial you will learn how to use **imgui** library and how to
create your first immediate mode GUI in Python.


What is immediate mode GUI
--------------------------

**pyimgui** is a Python wrapper around ImGui C++ library that allows you
to easily define custom user interfaces no matter what game engine or graphic
library you want to use. It is a immediate mode GUI library (opposed to
retained mode). In short, retained mode means that there is no general GUI
definition for your application but only direct calls that create new windows
and widgets or query their state whenever they are needed and on every frame
that is rendered.

Actual pipeline of drawing commands is constructed as you go and executed only
when you need it. Defining whole GUI on every frame may seem counterintuitive
and inefficient. Anyway, such approach is very flexible and allows you to
iterate your UI designs very fast.

If you want to learn more about the general philosophy behind this technique
watch following video where Casey Muratori thoroughly explains the idea of
immediate mode user interfaces:

.. raw:: html

   <iframe width="560" height="315" src="https://www.youtube.com/embed/Z1qyvQsjK5Y" frameborder="0" allowfullscreen></iframe>



Using pyimgui
-------------

The **imgui** Python library consists of two main components

* The :mod:`imgui.core` submodule. It provides functions that allow you to
  define new windows and widgets, query their state, and control the GUI
  context within your application. For the sake of simplicity all public
  functions from :any:`imgui.core` submodule are also available in the root
  ``imgui`` namespace.
* The :mod:`imgui.integrations` subpackage. It provides utilities that allow
  you to easily integrate ImGui with popular Python frameworks and engines.



Basic GUI drawing loop
``````````````````````

Despite being an *immediate mode* GUI library ImGui doesn't draw immediately
anything every time you call any function from :mod:`imgui.core` module.
Calls to the window and widget functions just create new entries in the list
of drawing commands to be executed during next frame rendering. You alone
decide when to start new frame context and when to execute all drawing
commands.


.. visual-example::
  :title: Basic UI loop
  :auto_layout:
  :introduction: Following is the basic rendering loop as its simplest:
  :inter: Above loop should result in following interface:

  import imgui

  # initilize imgui context (see documentation)
  imgui.create_context()
  imgui.get_io().display_size = 100, 100
  imgui.get_io().fonts.get_tex_data_as_rgba32()

  # start new frame context
  imgui.new_frame()

  # open new window context
  imgui.begin("Your first window!", True)

  # draw text label inside of current window
  imgui.text("Hello world!")

  # close current window context
  imgui.end()

  # pass all drawing comands to the rendering pipeline
  # and close frame context
  imgui.render()
  imgui.end_frame()


Of course this is not enough to create fully working GUI application with
**pyimgui**. The bare :mod:`imgui.core` module is not able to render anything
on its own. The :func:`imgui.render()` function just passes abstract ImGui
drawing commands to your rendering backend. In order to make it work you will
first have to initialize the rendering backend of your choice.


Using built-in rendering backend integrations
`````````````````````````````````````````````

The :mod:`imgui.integrations` sub-package provides multiple modules that
aim to ease integration with various Python rendering engines, frameworks,
and libraries:

* :mod:`imgui.integrations.cocos2d` integrates **pyimgui** with Cocos2d_
  game engine.
* :mod:`imgui.integrations.glfw` integrates **pyimgui** with GLFW_ OpenGL
  windowing library through
  `glfw Python package <https://pypi.python.org/pypi/glfw>`_
  .
* :mod:`imgui.integrations.pygame` integrates **pyimgui** with pygame_ game
  engine.
* :mod:`imgui.integrations.sdl2` integrates **pyimgui** with SDL2_ library
  through PySDL2_ Python package
* :mod:`imgui.integrations.pyglet` integrates **pyimgui** with pyglet_
  library, both stable (1.5.x) and development versions (2.x), switching
  between *fixed* and *programmable* as appropriate.
* :mod:`imgui.integrations.opengl` provides bare integration with OpenGL both
  in *fixed pipeline* and *programmable pipeline* mode. It does not provide any
  windowing facilities (so cannot be used as a standalone renderer) but serves
  as a good starting point for new custom integrations with other OpenGL-based
  frameworks and engines. It is based on PyOpenGL_ library.


Note that **pyimgui** does not include any of integrated backend requirement
during installation as default. Still it is possible to install all additional
requirements using *setuptools extras* feature. Just specify your integration
submodule name for backend of your choicse as an *extra tag* during **imgui**
installation with ``pip install`` command e.g.::

    $ pip install imgui[sdl2]
    $ pip install imgui[pygame]

If you want you can install **pyimgui** with multiple backends at once::

    $ pip install imgui[glfw,cocos2d,pygame,sdl2,pyglet]

You can even request to install all requirements for every supported backend
and every optional feature using single ``full`` extras option::

    $ pip install imgui[full]

For actual examples of using these backends see the `doc/examples`_ directory
of the `project page on GitHub <https://github.com/swistakm/pyimgui>`_.

.. _Cocos2d: http://python.cocos2d.org
.. _GLFW: http://www.glfw.org
.. _pygame: http://www.pygame.org
.. _PyOpenGL: http://pyopengl.sourceforge.net
.. _SDL2: https://www.libsdl.org
.. _PySDL2: https://pysdl2.readthedocs.io
.. _pyglet: https://pyglet.readthedocs.io
.. _doc/examples: https://github.com/swistakm/pyimgui/tree/master/doc/examples

