.. Copyright 2012 Bastien Léonard. All rights reserved.

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


Changelog
=========

.. currentmodule:: sfml


0.2 (07/20/2012):

- ``Keyboard.BACK`` has been renamed to :attr:`Keyboard.BACK_SPACE`, to fit with
  the C++ SFML change.
- Added support for file streaming: see :class:`SoundStream`,
  :meth:`SoundBuffer.load_from_stream()`, :meth:`Music.open_from_stream()`,
  :meth:`Font.load_from_stream()`, :meth:`Image.load_from_stream()`,
  :meth:`Texture.load_from_stream()`,
  :meth:`Shader.load_both_types_from_stream()` and
  :meth:`Shader.load_from_stream()`.
- :attr:`RectangleShape.size` doesn't raise exceptions for no reason anymore.
- Removed ``RenderTexture.create()``, the constructor should be used instead.
- :attr:`RenderTexture.active` now raises an exception when setting it causes an
  error.
- Added :meth:`copy()` and ``__repr__()`` methods in :class:`Vertex`.
- Removed ``View.get_transform()`` and ``View.get_inverse_transform()``; SFML's
  documentation says they are meant for internal use only.
- :meth:`View.from_rect()` and :meth:`View.reset()` now accept tuples.
- Setting :attr:`Shape.texture` to ``None`` now does the right thing at the C++
  level (it sets the underlying texture pointer to ``NULL``).
- The API reference should now be complete, and it has been reorganized to avoid
  huge pages. A FAQ page has been started.

0.1.3 (06/19/2012):

- Replaced ``Sprite.text_rect`` with two
  :meth:`Sprite.get_texture_rect` and :meth:`Sprite.set_texture_rect`.
- :class:`RenderStates`' constructor now takes a :ref:`blend
  mode<blend_modes>` as its first parameter.
- Added missing methods in :class:`ConvexShape` (``get_point()``,
  ``get_point_count()``, ``set_point()``, ``set_point_count()``). The
  ``point_count`` attribute has been removed.
- Added :attr:`RenderWindow.height`, :attr:`RenderWindow.width`,
  :meth:`Texture.bind`, :attr:`Texture.NORMALIZED`,
  :attr:`Texture.PIXELS`, :attr:`Color.TRANSPARENT`,
  :meth:`Image.flip_horizontally`, :meth:`Image.flip_vertically` and
  :attr:`RenderWindow.active`.
- :class:`Glyph`'s attributes are now modifiable.
- :meth:`RenderWindow.wait_event` now raises :exc:`PySFMLException`
  when the underlying C++ method fails. (In the past, the error would
  be ignored.)
- :meth:`Image.get_pixels` now returns None when the image is empty.
- :meth:`Image.get_pixel` and :meth:`Image.set_pixel` now raise
  ``IndexError`` if the pixel coordinates are out of range.
- :meth:`Image.save_to_file` now raises :exc:`PySFMLException` when an
  error occurs.
- The constructors of :class:`Keyboard`, :class:`Mouse` and
  :class:`Style` now raise ``NotImplementedError``.
- Fixed a bug where SFML would fail to raise an exception. This
  typically happened when a tuple, a :class:`FloatRect` or an
  :class:`IntRect` was expected, but another type was passed.
- Added the tests in the source release.
- Completed the documentation of many graphics classes.

0.1.2:

- Added copy() methods in :class:`Transform`, :class:`IntRect`,
  :class:`FloatRect`, :class:`Time` and :class:`Sprite`.
- :meth:`RenderTarget.draw` now also accepts a tuple of vertices. Also
  fixed error handling when the objects contained in the list/tuple
  have the wrong type.
- Added ``==`` and ``!=`` operators in :class:`IntRect` and
  :class:`FloatRect`.
- :class:`Transform`'s constructor now creates an identity transform
  when called with no arguments.
- Transform now supports the ``*=`` operator. (It already worked in
  the past, because Python will automatically use the ``*`` operator
  if ``*=`` isn't provided, but it's slower.)
- :meth:`SoundBuffer.save_to_file` now raises an exception in case of
  failure. (In the past, it didn't report errors in any way.)
- Removed ``Chunk.sample_count`` and
  ``SoundBuffer.sample_count``. Instead, use ``len(Chunk.samples)``and
  ``len(SoundBuffer.samples)``, respectively.
- :meth:`SoundBuffer.load_from_samples` now uses strings/bytes (for
  Python 2/3, respectively) instead of list.
- Fixed bugs in :class:`Font`, :class:`Image` and :class:`Shader`
  classmethods that load from strings/bytes objects.
- Added :meth:`Joystick.update`.
- :class:`Transformable` isn't abstract anymore, and can be inherited
  safely.
- Completed the events and audio documentation, added documentation
  for some graphics classes.
- Expanded the tutorial for C++ developers.

0.1.1:

- The ``seconds()``, ``milliseconds()`` and ``microseconds()``
  functions are removed. Use the :class:`Time` constructor with
  keyword arguments instead, e.g. ``milliseconds(200)`` becomes
  ``Time(milliseconds=200)``.
- Made Sprite more straightforward to inherit, ``__cinit__()`` won't
  raise errors because it automatically gets passed the constructor
  arguments anymore.
- Fixed a bug in Time where some arithemtic operators would always
  raise an exception.
- Fixed a bug in RenderStates where internal attributes and properties
  got mismatched because they had the same name.
- Added a ``__repr__()`` method in :class:`Time` (mostly to have more
  readable unit test errors, ``__str__()`` already existed in the
  past).
- Documentation: added a "caveats" page, and a new tutorial for people
  who are coming from a C++ SFML background.
- Added some unit tests.

0.1:

- The module is now called sfml. To keep using the sf prefix, import the module
  with ``import sfml as sf``.
- Python 3 users don't need to use bytes instead of strings
  anymore. When a C++ method expects a byte string and the user passes
  a Unicode object, it is encoded to a byte string with
  :attr:`sfml.default_encoding` (UTF-8 by default, you can change it
  as needed).
- Added the :class:`Listener` class.
- Added audio streaming (still lacking performance-wise).
- Added :meth:`Texture.copy_to_image`.
- Improved examples.
- Fixed various bugs and memory leaks.
