usage guide
===========

.. toctree::
   :hidden:

.. toctree::
   :maxdepth: 5

   conditions
   window-flags
   treenode-flags
   selectable-flag
   inputtext-flags

.. visual-example::
    :title: Guide - hello world!
    :height: 80
    :auto_layout:

    imgui.begin("My first window!")
    imgui.text("hello world!")
    imgui.text_colored("Python rocks!", 0.2, 1., 0.)
    imgui.end()

