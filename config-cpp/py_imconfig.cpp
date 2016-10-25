#include "py_imconfig.h"
#include "core.h"

// note: error type can be controlled during compilation
#ifndef PYIMGUI_CUSTOM_EXCEPTION
#define PYIMGUI_EXC_TYPE PyExc_RuntimeError
#else
#define PYIMGUI_EXC_TYPE ImGuiError
#endif


// ImGui does not throw exceptions whenever error occurs. The only way to add
// error handling is to provide custom IM_ASSERT definition. Here we can
// set Python interpreter exception and also throw C++ exception to interrupt
// any function call in order to avoid any memory corruption.
void __py_assert(const char* msg) {
    // At first, set the Python exception state so we don't need to provide
    // custom exception translation function everywhere in Cython code
    PyErr_SetString(PYIMGUI_EXC_TYPE, msg);

    // Throw anything so on the Cython side we can can catch it with
    // something like:
    //
    //     cdef extern from "imgui.h" namespace "ImGui":
    //         void PopStyleVar(int) except +
    throw msg;
}
