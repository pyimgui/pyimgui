# -*- coding: utf-8 -*-
from inspect import cleandoc
import sys
import re
import fileinput

try:
    from urllib import quote
except ImportError:
    from urllib.parse import quote

BASE_URL = 'https://img.shields.io/badge/completion-%s-blue.svg'
BADGE_TEMPLATE = "[![completion](%s)](https://github.com/swistakm/pyimgui)"
ALL_RE = re.compile(r'(?!(^\s*$)|(^\s*#))')
DONE_RE = re.compile(r'(?!(^\s*$)|(^\s*#)).*✓')
BADGE_RE = re.compile(r'\[!\[completion\]\(.*\)\](\(.*\))?\s*$')


if __name__ == "__main__":
    if len(sys.argv) == 2:
        pxd_file_name, out_file_name = sys.argv[1], None
    elif len(sys.argv) == 3:
        pxd_file_name, out_file_name = sys.argv[1:]
    else:
        pxd_file_name, out_file_name = None, None
        exit(cleandoc(
            """Usage: python %s PXD_FILE [README]

            Estimate completion status and print result.

            Note: if README argument is provided it will
            try to update it with completion badge looking
            for existing markdown badge markup.
             """ % __file__
        ))

    with open(pxd_file_name) as pyx_file:
        lines = pyx_file.readlines()

    all_count = len(list(filter(ALL_RE.match, lines)))
    done_count = len(list(filter(DONE_RE.match, lines)))
    result = "%d%% (%s of %s)" % (
        float(done_count)/all_count * 100,
        done_count, all_count
    )

    badge_url = BASE_URL % quote(result)
    badge_md = BADGE_TEMPLATE % badge_url

    if out_file_name:
        output = fileinput.input(files=(out_file_name,), inplace=True)
        try:
            for line in output:
                if BADGE_RE.match(line):
                    sys.stdout.write(badge_md + "\n")
                else:
                    sys.stdout.write(line)

        finally:
            fileinput.close()

    print("Estimated: %s" % result)
    print("Badge:     %s" % badge_md)
