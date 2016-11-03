# -*- coding: utf-8 -*-
import sys
import re

try:
    from urllib2 import urlopen, Request
    from urllib import quote
    from urllib2 import HTTPError
except ImportError:
    from urllib.parse import quote
    from urllib.request import urlopen, Request
    from urllib.error import HTTPError


BASE_URL = 'https://img.shields.io/badge/completion-%s-blue.svg'
ALL_RE = re.compile(r'(?!(^\s*$)|(^\s*#))')
DONE_RE = re.compile(r'(?!(^\s*$)|(^\s*#)).*✓')


if __name__ == "__main__":
    if len(sys.argv) == 2:
        pxd_file_name, out_file_name = sys.argv[1], None
    elif len(sys.argv) == 3:
        pxd_file_name, out_file_name = sys.argv[1:]
    else:
        pxd_file_name, out_file_name = None, None
        exit("Usage: python %s PXD_FILE [OUT_FILE]" % __file__)

    with open(pxd_file_name) as pyx_file:
        lines = pyx_file.readlines()

    all_count = len(list(filter(ALL_RE.match, lines)))
    done_count = len(list(filter(DONE_RE.match, lines)))
    result = "%d %% (%s of %s)" % (
        float(done_count)/all_count * 100,
        done_count, all_count
    )

    if out_file_name:
        with open(out_file_name, 'w') as out_file:
            request = Request(
                BASE_URL % quote(result),
                # note: Shields.io does not allow Python-urllib/* user agent
                headers={"User-Agent": "Spoofed"}
            )
            response = urlopen(request)
            out_file.write(response.read())

    print(result)
