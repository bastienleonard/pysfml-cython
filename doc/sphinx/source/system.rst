.. Copyright 2011, 2012 Bastien Léonard. All rights reserved.

.. Redistribution and use in source (reStructuredText) and 'compiled'
   forms (HTML, PDF, PostScript, RTF and so forth) with or without
   modification, are permitted provided that the following conditions are
   met:

.. 1. Redistributions of source code (reStructuredText) must retain
   the above copyright notice, this list of conditions and the
   following disclaimer as the first lines of this file unmodified.

.. 2. Redistributions in compiled form (converted to HTML, PDF,
   PostScript, RTF and other formats) must reproduce the above
   copyright notice, this list of conditions and the following
   disclaimer in the documentation and/or other materials provided
   with the distribution.

.. THIS DOCUMENTATION IS PROVIDED BY BASTIEN LÉONARD ``AS IS'' AND ANY
   EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
   IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
   PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL BASTIEN LÉONARD BE LIABLE
   FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
   CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
   SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
   BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
   WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
   OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS DOCUMENTATION,
   EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


System
======

.. module:: sfml


.. attribute:: default_encoding

   Currently, this encoding is used when the user passes a Unicode
   object to method that will call a SFML method which only supports
   ``std::string`` argument. The user-supplised Unicode object will be
   encoded with this encoding and the resulting bytes will be passed
   to SFML. This is mostly for Python 3 users, so they don't have to
   use byte strings all the time. Here is the list of valid encodings:
   http://docs.python.org/py3k/library/codecs.html#standard-encodings


.. class:: Time(seconds=-1.0, milliseconds=-1, microseconds=-1)

   Instead of forcing the user to use a specific time units, SFML uses
   this class to encapsulate time values. The user can get an actual
   time value by using the following methods: :meth:`as_seconds`,
   :meth:`as_milliseconds` and :meth:`as_microseconds`. You can also
   create your own time objects by calling the constructor with one
   keyword argument.

   Using one keyword argument is equivalent to calling the
   corresponding function. For example, ``sfml.seconds(10) ==
   sfml.Time(seconds=10)``.

   This class provides the following special methods:

   * Comparison operators: ``==``, ``!=``, ``<``, ``>``, ``<=``, ``>=``.
   * Arithmetic operators: ``+``, ``-``, ``*``, ``/``, unary ``-``.
   * ``str()`` returns a representation of the number of seconds.

   .. attribute:: ZERO

      Predefind "zero" time value (class attribute).

   .. method:: as_seconds()

      Return a ``float`` containing the number of seconds for this time object.

   .. method:: as_milliseconds()

      Return an ``int`` containing the number of milliseconds for this time
      object.

   .. method:: as_microseconds()

      Return an ``int`` containing the number of microseconds for this time
      object.

   .. method:: copy()

      Return a new Time object with the same value as self.

.. class:: Clock

   Utility class that measures the elapsed time.

   Its provides the most precise time that the underlying OS can
   achieve (generally microseconds or nanoseconds). It also ensures
   monotonicity, which means that the returned time can never go
   backward, even if the system time is changed.

   Usage example::

      clock = sfml.Clock()
      ...
      time1 = clock.elapsed_time
      ...
      time2 = clock.restart()

   The :class:`Time` object returned by the clock can then be
   converted to a number of seconds, milliseconds or even
   microseconds.

   .. attribute:: elapsed_time

      A :class:`Time` object containing the time elapsed since the
      last call to :meth:`restart`, or the construction of the
      instance if :meth:`restart` has not been called yet.

   .. method:: restart()

      Restart the clock, and return a :class:`Time` object containing
      the elapsed time since the clock started.



.. class:: Vector2f(float x=0.0; float y=0.0)

   You don't have to use this class; everywhere you can pass a
   :class:`Vector2f`, you should be able to pass a tuple as
   well. However, it can be more practical to use it, as it overrides
   arithmetic and comparison operators, is mutable and requires that
   you use the :attr:`x` and :attr:`y` members instead of indexing.

   This class provides the following special methods:

   * Comparison operators: ``==`` and ``!=``.

   .. attribute:: x

      *x* coordinate for this vector.

   .. attribute:: y

      *y* coordinate for this vector.

   .. method:: copy()

      Return a new :class:`Vector2f` with ``x`` and ``y`` set to the
      value of ``self``.
