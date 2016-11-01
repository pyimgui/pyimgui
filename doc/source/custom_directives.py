# -*- coding: utf-8 -*-
from docutils import nodes


def wraps_role(name, rawtext, text, lineno, inliner, options={}, content=[]):
    """Mark something as wrapping given API element

    Returns 2 part tuple containing list of nodes to insert into the
    document and a list of system messages.  Both are allowed to be
    empty.

    :param name: The role name used in the document.
    :param rawtext: The entire markup snippet, with role.
    :param text: The text marked with the role.
    :param lineno: The line number where rawtext appears in the input.
    :param inliner: The inliner instance that called us.
    :param options: Directive options for customization.
    :param content: The directive content for customization.
    """
    return [
        nodes.strong(rawtext, "Wraps API: "),
        nodes.literal(rawtext, text)
    ], []

def setup(app):

    app.add_role('wraps', wraps_role)

    return {'version': '0.1'}
