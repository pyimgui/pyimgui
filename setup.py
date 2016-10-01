# -*- coding: utf-8 -*-
# from __future__ import unicode_literals

from setuptools import setup, Extension
from Cython.Build import cythonize
import os


try:
    from pypandoc import convert

    def read_md(f):
        return convert(f, 'rst')

except ImportError:
    convert = None
    print(
        "warning: pypandoc module not found, could not convert Markdown to RST"
    )

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


setup(
    name='imgui',
    version=VERSION,
    packages=['imgui'],

    author=u'Michał Jaworski',
    author_email='swistakm@gmail.com',

    description="Cython-based Python bindings for dear imgui",
    long_description=read_md(README),
    url="https://github.com/swistakm/pyimgui",

    ext_modules=cythonize([
        Extension("imgui.core", ["extensions/core.pyx"]),
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
