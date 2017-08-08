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
=============

The **imgui** Python library consists of two main components

* The :any:`imgui.core` submodule. It provides functions that allow you to
  define new windows and widgets, query their state, and control the GUI
  context within your application.
* The :any:`imgui.integrations` subpackage. It provides utilities that allow
  you to easily integrate ImGui with popular Python frameworks and engines.


