from functools import wraps
from warnings import warn


class ImguiDeprecationWarning(FutureWarning):
    pass


def deprecated(reason):
    def decorator(fn):
        @wraps(fn)
        def wrapper(*args, **kwargs):
            warn(reason, ImguiDeprecationWarning, stacklevel=2)
            return fn(*args, **kwargs)
        return wrapper
    return decorator
