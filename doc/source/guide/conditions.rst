Using conditions
================

Many imgui functions accept ``conditions`` argument. It allows you to specify
when values/procedures specified by given API function should be applied.

Available values for conditions are:

.. _condition-options:

* :py:data:`imgui.ALWAYS`
* :py:data:`imgui.ONCE`
* :py:data:`imgui.FIRST_USE_EVER`
* :py:data:`imgui.APPEARING`

