.. _guide-combo-flags:

Using combo flags
======================

Combo functions accept various flags to manage their behaviour.

List of all available combo flags (click to see documentation):

.. _combo-flag-options:

* :py:data:`COMBO_NONE` = core.COMBO_NONE
* :py:data:`COMBO_POPUP_ALIGN_LEFT` Align the popup toward the left by default
* :py:data:`COMBO_HEIGHT_SMALL` Max ~4 items visible. Tip: If you want your combo popup to be a specific size you can use SetNextWindowSizeConstraints() prior to calling BeginCombo()
* :py:data:`COMBO_HEIGHT_REGULAR` Max ~8 items visible (default)
* :py:data:`COMBO_HEIGHT_LARGE` Max ~20 items visible
* :py:data:`COMBO_HEIGHT_LARGEST` As many fitting items as possible
* :py:data:`COMBO_NO_ARROW_BUTTON` Display on the preview box without the square arrow button
* :py:data:`COMBO_NO_PREVIEW` Display only a square arrow button
* :py:data:`COMBO_HEIGHT_MASK` Shortcut: "imgui.COMBO_HEIGHT_SMALL | imgui.COMBO_HEIGHT_REGULAR | imgui.COMBO_HEIGHT_LARGE | imgui.COMBO_HEIGHT_LARGEST".
