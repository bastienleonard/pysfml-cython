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


.. class:: InputStream

   This abstract class allows users to define their own file-like
   input sources from which SFML can load resources.

   SFML resource classes like :class:`Texture` and
   :class:`SoundBuffer` provide loadFromFile and loadFromMemory class
   methods which read data from conventional sources. However, if you
   have data coming from a different source (over a network, embedded,
   encrypted, compressed, etc) you can derive your own class from
   :class:`InputStream` and load SFML resources with their
   loadFromStream function.

   .. warning::

      Exceptions that occur in the implemented methods won't be
      propagated, but printed on ``sys.stderr`` (the console, by
      default). This is because of concerns regarding multithreading
      and exception propagation. Please keep your methods as simple as
      possible, and if they don't work, make sure you read the
      console.

   Usage example::

       class ExampleStream(sfml.InputStream):
           def __init__(self, filename):
               sfml.InputStream.__init__(self)
               self.filename = filename
               self.file = open(filename, 'rb')
               self.file.seek(0, 2)
               self.size = self.file.tell()
               self.file.seek(0)

           def get_size(self):
               print('{0}: get_size()'.format(self.filename))
               return self.size

           def read(self, size):
               print('{0}: read({1})'.format(self.filename, size))

               return self.file.read(size)

           def seek(self, position):
               print('{0}: seek({1})'.format(self.filename, position))
               self.file.seek(position)

               return self.tell()

           def tell(self):
               print('{0}: tell()'.format(self.filename))

               return self.file.tell()

           def close(self):
               self.file.close()

       # Now you can load textures...
       texture_stream = ExampleStream(some_path)
       texture = sfml.Texture.load_from_stream(texture_stream)

       # Music...
       music_stream = ExampleStream('music.ogg')
       music = sfml.Music.open_from_stream(music_stream)
       music.play()

       # Etc.

   .. method:: get_size

      Return the number of bytes available in the stream, or -1 on
      error.

   .. method:: read(int size)

      *size* is the desired number of bytes to read. The method should
       return a string in Python 2, or a bytes object in Python 3. If
       needed, its length can be smaller than *size*.

   .. method:: seek(int position)

      Change the current position to *position*, from the beginning of
      the streal. This method has to return the actual position sought
      to, or -1 on error.

   .. method:: tell

      Return the current reading position on the stream, or -1 on
      error.


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
