import os
import re

import click
import inflection

import jinja2

loader = jinja2.FileSystemLoader(searchpath="./")
env = jinja2.Environment(loader=loader)
base_dir = os.path.dirname(__file__)


def extract_comment(line):
    parts = line.split("//")
    if len(parts) > 1:
        return "//".join(map(str.strip, parts[1:]))
    else:
        return ""


def pxd_format(field, comment, max_len):
    if comment:
        return field + " " * (max_len - len(field) + 2) + "# " + comment
    else:
        return field


def pyx_format(field, comment, max_len, prefix=""):
    key = inflection.underscore(field.split("_", 1)[-1]).upper()

    return "{prefix}{key} = enums.{field}{comment}".format(
        prefix=prefix, key=key, field=field,
        comment="  # " + comment if comment else ""
    )


def py_format(field, comment, max_len, prefix=""):
    key = inflection.underscore(field.split("_", 1)[-1]).upper()

    return "{comment}{prefix}{key} = core.{prefix}{key}".format(
        prefix=prefix, key=key,
        comment="#: " + comment + "\n" if comment else ""
    )


class EnumParser:
    FIELD_RE_TEMPLATE = r"\s+({name}_?\w+)[,\s=]?"

    def __init__(self, header_file, formatter):
        self.formatter = formatter

        with open(header_file) as f:
            self.contents = f.readlines()

    def fields_of(self, name, **format_kwargs):
        fields = []
        started = False
        regexp = re.compile(self.FIELD_RE_TEMPLATE.format(name=name))

        for line in self.contents:
            if not started and line.startswith("enum {}".format(name)):
                started = True
                continue
            elif started and "}" in line:
                break
            elif started:
                match = regexp.match(line)
                if match:
                    comment = extract_comment(line)
                    field = match.groups()[0]
                    fields.append((field, comment))

        max_len = max(map(lambda x: len(x[0]), fields))
        out_lines = []

        for field, comment in fields:
            out_lines.append(self.formatter(field, comment, max_len, **format_kwargs))

        return "\n".join(out_lines)


@click.group()
def cli():
    pass


@cli.command()
def pxd():
    template = env.get_template(os.path.join(base_dir, "enums.pxd.jinja2"))
    parser = EnumParser(os.path.join(base_dir, "..", "imgui-cpp", "imgui.h"), pxd_format)
    click.echo(template.render(parser=parser))


@cli.command()
def py():
    template = env.get_template(os.path.join(base_dir, "flags.py.jinja2"))
    parser = EnumParser(os.path.join(base_dir, "..", "imgui-cpp", "imgui.h"), py_format)
    click.echo(template.render(parser=parser))


@cli.command()
def pyx():
    template = env.get_template(os.path.join(base_dir, "core.pyx.jinja2"))
    parser = EnumParser(os.path.join(base_dir, "..", "imgui-cpp", "imgui.h"), pyx_format)
    click.echo(template.render(parser=parser))


if __name__ == "__main__":
    cli()
