import sys

_orig_trace = None


class SkipWithStatement(Exception):
    pass


def raise_skip_with_statement(*args, **kwargs):
    raise SkipWithStatement()


def empty_trace(*args, **kwargs):
    return


def skip_with_init():
    global _orig_trace
    # Need to set trace to trigger the frame trace. Also need to reset trace after trace errors.
    _orig_trace = sys.gettrace()
    if _orig_trace is None:
        sys.settrace(empty_trace)

    # Set a stack trace that will raise an error to skip the context block.
    sys._getframe(1).f_trace = raise_skip_with_statement


def skip_with_cleanup():
    # Reset the original trace method to resume debugging.
    sys.settrace(_orig_trace)
