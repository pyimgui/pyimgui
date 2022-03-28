import io
import sys
import inspect


class SkipWithStatement(Exception):
    pass


def raise_skip_with_statement(*args, **kwargs):
    raise SkipWithStatement()


def _settrace(func):
    # Pydev actually writes to stderr instead of using a warning...
    stderr, sys.stderr = sys.stderr, io.StringIO()
    sys.settrace(func)
    sys.stderr = stderr


class SkipWith(object):
    def __init__(self, context, should_skip):
        self._should_skip = should_skip
        self._context = context
        self._orig_trace = None
        self._skipped = False

    def __enter__(self):
        context_enter = self._context.__enter__()

        if self._should_skip:
            # Need to set trace to trigger the frame trace. Also need to reset trace after trace errors.
            self._orig_trace = sys.gettrace()
            if self._orig_trace is None:
                _settrace(lambda *args, **keys: None)

            # Set a stack trace that will raise an error to skip the context block.
            frame = inspect.currentframe().f_back
            frame.f_trace = raise_skip_with_statement
            self._skipped = True

        return context_enter

    def __exit__(self, exc_type, exc_val, exc_tb):
        # Reset the original trace method to resume debugging.
        if self._skipped:
            _settrace(self._orig_trace)
            self._orig_trace = None

        context_exit = self._context.__exit__(exc_type, exc_val, exc_tb)
        if exc_type == SkipWithStatement:
            # Truthy return from __exit__ suppresses the error.
            return True
        else:
            # Otherwise return the wrapped __exit__ result.
            return context_exit

    # For legacy support

    def __getitem__(self, item):
        return self._context.__getitem__(item)

    def __iter__(self):
        return self._context.__iter__()

    def __repr__(self):
        return self._context.__repr__()

    def __eq__(self, other):
        return self._context.__eq__(other)

    def __bool__(self):
        return self._context.__bool__()
