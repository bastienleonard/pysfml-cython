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


.. function:: Time seconds(float seconds)

.. function:: Time milliseconds(int milliseconds)

.. function:: Time microseconds(int microseconds)


.. class:: Time(seconds=-1.0, milliseconds=-1, microseconds=-1)

   .. attribute:: ZERO

      Predefind "zero" time value (class attribute).

   Using one keyword argument is equivalent to calling the
   corresponding function. For example,
   ``sf.seconds(10) == sf.Time(seconds=10)``.

   This class provides the following special methods:

   * Comparison operators: ``==``, ``!=``, ``<``, ``>``, ``<=``, ``>=``.
   * Arithmetic operators: ``+``, ``-``, ``*``, ``/``, unary ``-``.
   * ``str()`` returns a representation of the number of seconds.

   .. method:: float as_seconds()
   .. method:: int as_milliseconds()
   .. method:: int as_microseconds()


.. class:: Clock

   .. attribute:: Time elapsed_time

   .. method:: Time restart()



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
