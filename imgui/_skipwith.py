import io
import sys
import inspect

_orig_trace = None


class SkipWithStatement(Exception):
    pass


def raise_skip_with_statement(*args, **kwargs):
    raise SkipWithStatement()


def _settrace(func):
    # Pydev actually writes to stderr instead of using a warning...
    stderr, sys.stderr = sys.stderr, io.StringIO()
    sys.settrace(func)
    sys.stderr = stderr


def skip_with_init():
    global _orig_trace
    # Need to set trace to trigger the frame trace. Also need to reset trace after trace errors.
    _orig_trace = sys.gettrace()
    if _orig_trace is None:
        _settrace(lambda *args, **keys: None)

    # Set a stack trace that will raise an error to skip the context block.
    frame = inspect.currentframe().f_back
    frame.f_trace = raise_skip_with_statement


def skip_with_cleanup():
    global _orig_trace
    # Reset the original trace method to resume debugging.
    _settrace(_orig_trace)
    _orig_trace = None
