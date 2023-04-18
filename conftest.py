# -*- coding: utf-8 -*-
import os
import sys
from traceback import print_exc

import pytest
from inspect import currentframe, getframeinfo

from _pytest.outcomes import Skipped
from sphinx.application import Sphinx

from pathlib import Path
import inspect

PROJECT_ROOT_DIR = os.path.dirname(os.path.abspath(__file__))
sphinx = None

if 'FROM_APPVEYOR' in os.environ:
    # We need to trick the import mechanism in order to load the
    # builded wheel instead of the local src directory
    init_file_path = os.path.join(PROJECT_ROOT_DIR, 'imgui','__init__.py')
    init_file_path_tmp = os.path.join(PROJECT_ROOT_DIR, 'imgui','__init__TMP.py')
    os.rename(init_file_path, init_file_path_tmp)
    import imgui
    os.rename(init_file_path_tmp, init_file_path)
else:
    import imgui


def project_path(*paths):
    return os.path.join(PROJECT_ROOT_DIR, *paths)


def _ns(locals_, globals_):
    ns = {}
    ns.update(locals_)
    ns.update(globals_)
    return ns

class SphinxDoc(pytest.File):
    @classmethod
    def from_parent(cls, parent, *, fspath):
        path = Path(fspath)

        # yuck!
        global sphinx
        if sphinx is None:
            os.environ['SPHINX_DISABLE_RENDER'] = '1'

            sphinx = Sphinx(
                srcdir=project_path('doc', 'source'),
                confdir=project_path('doc', 'source'),
                outdir=project_path('doc', 'build', 'vistest'),
                doctreedir=project_path('doc', 'build', 'doctree'),
                buildername='vistest',
            )

        # Check the signature of the from_parent method
        # Note(Sam): This hack won't be needed once we drop p3.7 support
        # it is required because Sphinx6 requires p3.8
        sig = inspect.signature(super().from_parent)
        if 'path' in sig.parameters:
            # Sphinx version >= 6, use path
            return super().from_parent(parent, path=path)
        else:
            # Sphinx version < 6, use fspath
            return super().from_parent(parent, fspath=fspath)

    def collect(self):
        # build only specified file
        sphinx.build(filenames=[self.fspath.relto(project_path())])

        return [
            DocItem.from_parent(self, name=name or "anonymous", code=code)
            for (name, code) in sphinx.builder.snippets
        ]

class DocItem(pytest.Item):
    @classmethod
    def from_parent(cls, parent, *, name, code):
        self = super().from_parent(parent, name=name)
        self.code = code
        return self

    def runtest(self):
        self.exec_snippet(self.code)

    def exec_snippet(self, source):

        # Strip out new_frame/end_frame from source
        if "# later" in source:
            raise Skipped(msg="multi-stage snippet, can't comprehend")

        lines = [
            line
            if all([
                "imgui.new_frame()" not in line,
                "imgui.render()" not in line,
                "imgui.end_frame()" not in line,
                "fonts.get_tex_data_as_rgba32()" not in line,
            ]) else ""
            for line in
            source.split('\n')
        ]
        source = "\n".join(lines)

        if (
            "import array" in source
            and sys.version_info < (3, 0)
        ):
            pytest.skip(
                "array.array does not work properly under py27 as memory view"
            )

        code = compile(source, '<str>', 'exec')
        frameinfo = getframeinfo(currentframe())

        imgui.create_context()
        io = imgui.get_io()
        io.delta_time = 1.0 / 60.0
        io.display_size = 300, 300

        # setup default font
        io.fonts.get_tex_data_as_rgba32()
        io.fonts.add_font_default()
        io.fonts.texture_id = 0  # set any texture ID to avoid segfaults

        imgui.new_frame()

        exec_ns = _ns(locals(), globals())

        try:
            exec(code, exec_ns, exec_ns)
        except Exception as err:
            # note: quick and dirty way to annotate sources with error marker
            print_exc()
            lines = source.split('\n')
            lines.insert(sys.exc_info()[2].tb_next.tb_lineno, "^^^")
            self.code = "\n".join(lines)
            imgui.end_frame()
            raise

        imgui.render()

    @staticmethod
    def indent(text, width=4):
        return "\n".join(
            ">" + " " * width + line
            for line in text.split('\n')
        )

    def repr_failure(self, excinfo):
        """ called when self.runtest() raises an exception. """
        return "Visual example fail: {}\n\n{}\n\n{}".format(
            excinfo,
            self.indent(self.code),
            excinfo.getrepr(funcargs=True, style='short')
        )

    def reportinfo(self):
        return self.fspath, 0, "testcase: %s" % self.name


class ExecException(Exception):
    pass

def pytest_collect_file(parent, path):
    if path.ext == '.rst' and 'source' in path.dirname:
        return SphinxDoc.from_parent(parent, fspath=path)
