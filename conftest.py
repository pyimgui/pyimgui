# -*- coding: utf-8 -*-
import os

import pytest
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

    @staticmethod
    def exec_snippet(source):
        code = compile(source, '<str>', 'exec')

        io = imgui.get_io()
        io.render_callback = lambda *args, **kwargs: None
        io.delta_time = 1.0 / 60.0
        io.display_size = 300, 300

        # setup default font
        io.fonts.get_tex_data_as_rgba32()
        io.fonts.add_font_default()
        io.fonts.texture_id = 0  # set any texture ID to avoid segfaults

        imgui.new_frame()
        exec(code, locals(), globals())
        imgui.render()

    def repr_failure(self, excinfo):
        """ called when self.runtest() raises an exception. """
        return "\n".join([
            "Documentation test execution for code:",
            self.code,
            "---",
            str(excinfo)
        ])

    def reportinfo(self):
        return self.fspath, 0, "usecase: %s" % self.name


def pytest_collect_file(parent, path):

    if path.ext == '.rst' and 'source' in path.dirname:
        return SphinxDoc(path, parent)
