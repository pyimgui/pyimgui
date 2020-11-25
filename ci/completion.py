# -*- coding: utf-8 -*-
import subprocess
import sys
import re
import fileinput

import click

try:
    from urllib import quote
except ImportError:
    from urllib.parse import quote

BASE_URL = 'https://img.shields.io/badge/completion-%s-blue.svg'
BADGE_TEMPLATE = "[![completion](%s)](https://github.com/swistakm/pyimgui)"
ALL_RE = re.compile(r'(?!(^\s*$)|(^\s*#)).*[✗✓]')
DONE_RE = re.compile(r'(?!(^\s*$)|(^\s*#)).*✓')
BADGE_RE = re.compile(r'\[!\[completion\]\(.*\)\](\(.*\))?\s*$')


@click.group()
@click.option(
    '-o', '--badge-output', type=click.Path(exists=True), default=None
)
@click.pass_context
def cli(ctx, badge_output):
    ctx.obj['badge_output'] = badge_output


@cli.command(name='with-nm')
@click.argument('srclib', type=click.Path(exists=True))
@click.argument('dstlib', type=click.Path(exists=True))
@click.pass_context
def with_nm(ctx, srclib, dstlib):
    src_symbols = lib_symbols(srclib, undefined=False)
    dst_symbols = lib_symbols(dstlib, undefined=True)

    done_count = len(dst_symbols.intersection(src_symbols))
    all_count = len(src_symbols)

    output(done_count, all_count, ctx.obj['badge_output'])


@cli.command(name='with-pxd')
@click.argument('pxd_file', type=click.File('r'))
@click.pass_context
def with_pxd(ctx, pxd_file):
    lines = pxd_file.readlines()

    all_count = len(list(filter(ALL_RE.match, lines)))
    done_count = len(list(filter(DONE_RE.match, lines)))

    output(done_count, all_count, ctx.obj['badge_output'])


@cli.command()
@click.argument('srclib', type=click.Path(exists=True))
@click.argument('dstlib', type=click.Path(exists=True))
def missing(srclib, dstlib):
    src_symbols = lib_symbols(srclib, undefined=False)
    dst_symbols = lib_symbols(dstlib, undefined=True)

    for symbol in sorted(src_symbols.difference(dst_symbols)):
        click.echo(symbol)


def lib_symbols(lib_path, undefined=False):
    # get symbols
    nm = subprocess.Popen(
        ['nm', '-guj' if undefined else '-gUj', lib_path],
        stdout=subprocess.PIPE
    )
    # demangle
    cppfilt = subprocess.Popen(
        ['c++filt'], stdin=nm.stdout, stdout=subprocess.PIPE
    )
    out = cppfilt.communicate()[0]

    return set(out.decode().split('\n'))


def output(done_count, all_count, badge_output=None):
    if all_count == 0:
        result = "-"
    else:
        result = "%d%% (%s of %s)" % (
            float(done_count)/all_count * 100,
            done_count, all_count
        )

    badge_url = BASE_URL % quote(result)
    badge_md = BADGE_TEMPLATE % badge_url

    if badge_output:
        output_file = fileinput.input(files=(badge_output,), inplace=True)
        try:
            for line in output_file:
                if BADGE_RE.match(line):
                    sys.stdout.write(badge_md + "\n")
                else:
                    sys.stdout.write(line)

        finally:
            fileinput.close()

    click.echo("Estimated: %s" % result)
    click.echo("Badge:     %s" % badge_md)


if __name__ == "__main__":
    cli(obj={})
