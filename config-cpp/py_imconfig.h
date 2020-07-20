/*
 * Additional config for imgui compilation.
 *
 * We don't want to touch sources from git submodule in order to configure
 * imgui so we force include using `-inlcude` flag during compilation.
 *
 * TODO: submit PR to imgui that allows configuring congiguration header
 # TODO: file using some other preprocessor directive
 */

#pragma once

extern "C" {
#include <Python.h>
}

// few macros to make IM_ASSERT cleaner
#define STRINGIFY(x) #x
#define TOSTRING(x) STRINGIFY(x)
#define TOWRAP(x) "(" STRINGIFY(x) ")"
#define AT __FILE__ ":" TOSTRING(__LINE__)

#if defined(_MSC_VER) &&_MSC_VER <= 1500
// lousy workaround for missing stdint.h in Visual C++ for Python
typedef unsigned __int64     uint64_t;
typedef signed __int64       int64_t;
#endif

// Redefine IM_ASSERT to raise Python specific exceptions
// note: enabling asserts as Python exceptions guards us from
//       possible segmentation faults when using functions that
//       does not return error values. Especially when pushing/poping
//       style stack variables.
#define IM_ASSERT(EX) (void)((EX) || (__py_assert ("ImGui assertion error (" #EX ") at " AT),0))


void __py_assert(const char* msg);

// tune vertex index size to enable longer draw lists (see #138 issue)
#define ImDrawIdx unsigned int
