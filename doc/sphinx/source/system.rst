System
======


.. function:: seconds(float seconds)

.. function:: milliseconds(int milliseconds)

.. function:: microseconds(int microseconds)


.. class:: Time(seconds=-1.0, milliseconds=-1, microseconds=-1)

   Using one keyword argument is equivalent to calling the
   corresponding function. For example,
   ``sf.seconds(10) == sf.Time(seconds=10)``.

   This class provides the following special methods:

   * Comparison operators: ``==``, ``!=``, ``<``, ``>``, ``<=``, ``>=``.
   * Arithmetic operators: ``+``, ``-``, ``*``, ``/``, unary ``-``.
   * ``str()`` returns a representation of the number of seconds.

   .. method:: as_seconds()
   .. method:: as_milliseconds()
   .. method:: as_microseconds()


.. class:: Clock

   .. attribute:: elapsed_time

   .. method:: restart()



.. class:: Vector2f(float x=0.0; float y=0.0)

   You don't have to use this class; everywhere you can pass a
   :class:`Vector2f`, you should be able to pass a tuple as well. However, it
   can be more practical to use it, as it overrides arithmetic and comparison
   operators, is mutable and requires that you use ``x`` and ``y`` members
   instead of indexing.

   .. attribute:: x
   .. attribute:: y

   .. classmethod:: from_tuple(t)

   .. method:: copy()

      Return a new :class:`Vector2f` with ``x`` and ``y`` set to the
      value of ``self``.
