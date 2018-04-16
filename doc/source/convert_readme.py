#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
This scripts handles conversion of Markdown README into rst for inclusion
in Sphinx documentation.
"""

import os
from pypandoc import convert

DOC_DIR = os.path.dirname(os.path.abspath(__file__))

MD_README_PATH = os.path.join(
    os.path.dirname(os.path.dirname(DOC_DIR)),
    'README.md'
)
RST_README_PATH = os.path.join(DOC_DIR, 'readme.rst')


def convert_md():
    with open(RST_README_PATH, 'wb') as readme:
        converted = convert(MD_README_PATH, 'rst')
        readme.write(converted.encode('utf-8'))


if __name__ == '__main__':
    convert_md()
