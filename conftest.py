# -*- coding: utf-8 -*-
import os
import sys

import pytest
from inspect import currentframe, getframeinfo
from sphinx.application import Sphinx

import imgui

PROJECT_ROOT_DIR = os.path.dirname(os.path.abspath(__file__))
sphinx = None


def project_path(*paths):
    return os.path.join(PROJECT_ROOT_DIR, *paths)


class SphinxDoc(pytest.File):
    def __init__(self, path, parent):
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

        super(SphinxDoc, self).__init__(path, parent)

    def collect(self):
        # build only specified file
        sphinx.build(filenames=[self.fspath.relto(project_path())])
        return [
            DocItem(name, self, code)
            for (name, code) in sphinx.builder.snippets
        ]


class DocItem(pytest.Item):
    def __init__(self, name, parent, code):
        super(DocItem, self).__init__(name, parent)
        self.code = code

    def runtest(self):
        self.exec_snippet(self.code)

    def exec_snippet(self, source):

        # Strip out new_frame/end_frame from source
        lines = [
            line
            if all([
                "imgui.new_frame()" not in line,
                "imgui.render()" not in line,
                "imgui.end_frame()" not in line
            ]) else ""
            for line in
            source.split('\n')
        ]
        source = "\n".join(lines)

        code = compile(source, '<str>', 'exec')
        frameinfo = getframeinfo(currentframe())

        imgui.create_context()
        io = imgui.get_io()
        io.render_callback = lambda *args, **kwargs: None
        io.delta_time = 1.0 / 60.0
        io.display_size = 300, 300

        # setup default font
        io.fonts.get_tex_data_as_rgba32()
        io.fonts.add_font_default()
        io.fonts.texture_id = 0  # set any texture ID to avoid segfaults

        imgui.new_frame()

        try:
            exec(code, locals(), globals())
        except Exception as err:
            # note: quick and dirty way to annotate sources with error marker
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
        return SphinxDoc(path, parent)
