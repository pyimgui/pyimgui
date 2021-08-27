.. _guide-slider-flags:

Using slider flags
======================

Slider functions accept various flags to manage their behaviour.

List of all available slider flags (click to see documentation):

.. _slider-flag-options:

* :py:data:`imgui.SLIDER_FLAGS_NONE`
* :py:data:`imgui.SLIDER_FLAGS_ALWAYS_CLAMP` Clamp value to min/max bounds when input manually with CTRL+Click. By default CTRL+Click allows going out of bounds.
* :py:data:`imgui.SLIDER_FLAGS_LOGARITHMIC` Make the widget logarithmic (linear otherwise). Consider using ImGuiSliderFlags_NoRoundToFormat with this if using a format-string with small amount of digits.
* :py:data:`imgui.SLIDER_FLAGS_NO_ROUND_TO_FORMAT` Disable rounding underlying value to match precision of the display format string (e.g. %.3f values are rounded to those 3 digits)
* :py:data:`imgui.SLIDER_FLAGS_NO_INPUT` Disable CTRL+Click or Enter key allowing to input text directly into the widget

