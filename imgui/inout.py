import abc
from functools import wraps


class InOutABC(object):
    """Metaclass that defines generic interface for inout arguments.

    Every object that contains 'set' and 'get' methods is considered an
    in-out capable type. Objects of that type allow to pass arguments to
    functions as C++-style references.
    """

    __metaclass__ = abc.ABCMeta

    @abc.abstractmethod
    def set(self, value):
        pass

    @abc.abstractmethod
    def get(self):
        pass

    @classmethod
    def __subclasshook__(cls, C):
        if cls is InOutABC:
            if (
                any("set" in B.__dict__ for B in C.__mro__) and
                any("get" in B.__dict__ for B in C.__mro__)
            ):
                return True

        return NotImplemented


def allow_inout(arg_pos, kwarg_name, result_pos=1):
    """Mark given function/method argument as in-out argument."""
    def wrapper(func):
        @wraps(func)
        def wrapped(*args, **kwargs):
            try:
                kwarg = args[arg_pos]
                args = args[:arg_pos] + args[arg_pos+1:]

            except IndexError:
                kwarg = kwargs.get(kwarg_name, None)

            inout_mode = isinstance(kwarg, InOutABC)

            if inout_mode:
                kwargs[kwarg_name]=kwarg.get()

            result_tuple = func(*args, **kwargs)

            if inout_mode:
                kwarg.set(result_tuple[result_pos])

            return result_tuple

        return wrapped

    return wrapper


class InteractionTuple(tuple):
    """Used to wrap return values of interactive widgets."""

    def __bool__(self):
        raise ValueError(
            "{} instances cannot be evaluated to bool."
            "".format(self.__class__.__name__)
        )

    @property
    def clicked(self):
        return bool(self[0])


class VisibilityTuple(tuple):
    """Used to wrap return values of widgets that have togglable visibility."""

    def __bool__(self):
        raise ValueError(
            "{} instances cannot be evaluated to bool."
            "".format(self.__class__.__name__)
        )

    @property
    def visible(self):
        return bool(self[0])

    @property
    def expanded(self):
        return bool(self[0])
