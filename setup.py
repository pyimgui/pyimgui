# -*- coding: utf-8 -*-
import os
import sys

from setuptools import setup, Extension, find_packages

try:
    from Cython.Build import cythonize
except ImportError:
    # A 'cythonize' stub is needed so that build, develop and install can
    # start before Cython is installed.
    cythonize = lambda extensions, **kwargs: extensions  # noqa
    USE_CYTHON = False
else:
    USE_CYTHON = True


_CYTHONIZE_WITH_COVERAGE = os.environ.get("_CYTHONIZE_WITH_COVERAGE", False)

if _CYTHONIZE_WITH_COVERAGE and not USE_CYTHON:
    raise RuntimeError(
        "Configured to build using Cython "
        "and coverage but Cython not available."
    )

try:
    from pypandoc import convert

    def read_md(f):
        return convert(f, 'rst')

except ImportError:
    convert = None
    # note: this warning is only for package registration step
    if 'register' in sys.argv:
        print("warning: pypandoc not found, could not convert Markdown to RST")

    def read_md(f):
        return open(f, 'r').read()  # noqa


def get_version(version_tuple):
    if not isinstance(version_tuple[-1], int):
        return '.'.join(map(str, version_tuple[:-1])) + version_tuple[-1]
    return '.'.join(map(str, version_tuple))


init = os.path.join(os.path.dirname(__file__), 'imgui', '__init__.py')
version_line = list(filter(lambda l: l.startswith('VERSION'), open(init)))[0]

VERSION = get_version(eval(version_line.split('=')[-1]))
README = os.path.join(os.path.dirname(__file__), 'README.md')


if sys.platform in ('cygwin', 'win32'):  # windows
    # note: `/FI` means forced include in VC++/VC
    # note: may be obsoleted in future if ImGui gets patched
    os_specific_flags = ['/FIpy_imconfig.h']
    # placeholder for future
    os_specific_macros = []
else:  # OS X and Linux
    # note: `-include` means forced include in GCC/clang
    # note: may be obsoleted in future if ImGui gets patched
    # placeholder for future
    os_specific_flags = ['-includeconfig-cpp/py_imconfig.h']
    os_specific_macros = []


if _CYTHONIZE_WITH_COVERAGE:
    compiler_directives = {
        'linetrace': True,
    }
    cythonize_opts = {
        'gdb_debug': True,
    }
    general_macros = [('CYTHON_TRACE_NOGIL', '1')]
else:
    compiler_directives = {}
    cythonize_opts = {}
    general_macros = []


extension_sources = ["imgui/core" + ('.pyx' if USE_CYTHON else '.cpp')]

if not USE_CYTHON:
    # note: Cython will pick these files automatically but when building
    #       a plain C++ sdist without Cython we need to explicitly mark
    #       these files for compilation and linking.
    extension_sources += [
        'imgui-cpp/imgui.cpp',
        'imgui-cpp/imgui_draw.cpp',
        'imgui-cpp/imgui_demo.cpp',
        'config-cpp/py_imconfig.cpp'
    ]

EXTENSIONS = [
    Extension(
        "imgui.core", extension_sources,
        extra_compile_args=os_specific_flags,
        define_macros=[
            # note: for raising custom exceptions directly in ImGui code
            ('PYIMGUI_CUSTOM_EXCEPTION', None)
        ] + os_specific_macros + general_macros,
        include_dirs=['imgui', 'config-cpp', 'imgui-cpp'],
    ),
]


setup(
    name='imgui',
    version=VERSION,
    packages=find_packages('.'),

    author=u'Michał Jaworski',
    author_email='swistakm@gmail.com',

    description="Cython-based Python bindings for dear imgui",
    long_description=read_md(README),
    url="https://github.com/swistakm/pyimgui",

    ext_modules=cythonize(
        EXTENSIONS,
        compiler_directives=compiler_directives, **cythonize_opts
    ),
    extras_require={
        'Cython':  ['Cython>=0.24'],
    },

    extras_require={
        'cocos2d': ['PyOpenGL', 'cocos2d'],
        'sdl2': ['PyOpenGL', 'PySDL'],
        'glfw': ['PyOpenGL', 'glfw'],
        'pygame': ['PyOpenGL', 'PySDL'],
        # todo: consider adding to install_requires
        'opengl': ['PyOpenGL'],
    },
    include_package_data=True,

    license='BSD',
    classifiers=[
        'Intended Audience :: Developers',
        'License :: OSI Approved :: BSD License',

        'Programming Language :: Cython',
        'Programming Language :: Python :: 2',

        'Operating System :: MacOS :: MacOS X',

        'Topic :: Games/Entertainment',
    ],
)
