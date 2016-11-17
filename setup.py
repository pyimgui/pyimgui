# -*- coding: utf-8 -*-
import os
import sys

from setuptools import setup, Extension, find_packages
from Cython.Build import cythonize


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


setup(
    name='imgui',
    version=VERSION,
    packages=find_packages('.'),

    author=u'Michał Jaworski',
    author_email='swistakm@gmail.com',

    description="Cython-based Python bindings for dear imgui",
    long_description=read_md(README),
    url="https://github.com/swistakm/pyimgui",

    ext_modules=cythonize([
        Extension(
            "imgui.core", ["imgui/core.pyx"],
            extra_compile_args=os_specific_flags,
            define_macros=[
                # note: for raising custom exceptions directly in ImGui code
                ('PYIMGUI_CUSTOM_EXCEPTION', None)
            ] + os_specific_macros,
            include_dirs=['imgui', 'config-cpp'],
        ),
    ], gdb_debug=True),
    setup_requires=['cython'],

    include_package_data=True,

    license='BSD',
    classifiers=[
        'Intended Audience :: Developers',
        'License :: OSI Approved :: BSD License',

        'Programming Language :: Cython',
        'Programming Language :: Python :: 2',
        'Programming Language :: Python :: 2 :: Only',

        'Operating System :: MacOS :: MacOS X',

        'Topic :: Games/Entertainment',
    ],
)
