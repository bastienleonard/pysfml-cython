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


.. module:: sfml


Misc
====


.. _blend_modes:

Blend modes
-----------

.. attribute:: BLEND_ADD

   Pixel = Source + Dest.

.. attribute:: BLEND_ALPHA

   Pixel = Source * Source.a + Dest * (1 - Source.a).

.. attribute:: BLEND_MULTIPLY

   Pixel = Source * Dest.

.. attribute:: BLEND_NONE

   Pixel = Source.


.. _primitive_types:

Primitive types
---------------

.. attribute:: POINTS

   List of individual points.

.. attribute:: LINES

   List of individual lines. 

.. attribute:: LINES_STRIP

   List of connected lines, a point uses the previous point to form a line.

.. attribute:: TRIANGLES

   List of individual triangles.

.. attribute:: TRIANGLES_FAN

   List of connected triangles, a point uses the common center and the
   previous point to form a triangle.

.. attribute:: TRIANGLES_STIP

   List of connected triangles, a point uses the two previous points
   to form a triangle.

.. attribute:: QUADS

   List of individual quads.


Basic classes
-------------

.. class:: Color(int r, int g, int b[, int a=255])

   Represents a color of 4 components:

   * red,
   * green,
   * blue,
   * alpha (opacity).

   Each component is a public member, an unsigned integer in the range
   [0, 255]. Thus, colors can be constructed and manipulated very
   easily::

      color = sfml.Color(255, 0, 0)  # red; you can also use Color.RED
      color.r = 0  # make it black
      color.b = 128  # make it dark blue

   The fourth component of colors, named "alpha", represents the
   opacity of the color. A color with an alpha value of 255 will be
   fully opaque, while an alpha value of 0 will make a color fully
   transparent, whatever the value of the other components is.

   This class provides the following special methods:

   * Comparison operators: ``==`` and ``!=``.
   * Arithmetic operators: ``+`` and ``*``.

   The following colors are available as static attibutes, e.g. you
   can use :attr:`Color.WHITE` to obtain a reference to the white color:

   .. attribute:: BLACK
   .. attribute:: BLUE
   .. attribute:: CYAN
   .. attribute:: GREEN
   .. attribute:: MAGENTA
   .. attribute:: RED
   .. attribute:: TRANSPARENT

      Transparent black color, i.e. this is equal to ``Color(0, 0, 0, 0)``.

   .. attribute:: WHITE
   .. attribute:: YELLOW

   .. attribute:: r

      Red component.

   .. attribute:: g

      Green component.

   .. attribute:: b

      Blue component.

   .. attribute:: a

      Alpha (opacity) component.

   .. method:: copy

      Return a new Color with the same value as self.


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


.. class:: IntRect(int left=0, int top=0, int width=0, int height=0)

   A rectangle is defined by its top-left corner and its size.

   To keep things simple, :class:`IntRect` doesn't define functions to
   emulate the properties that are not directly members (such as
   right, bottom, center, etc.), instead it only provides intersection
   functions.

   :class:`IntRect` uses the usual rules for its boundaries:

   * The left and top edges are included in the rectangle's area.
   * The right (left + width) and bottom (top + height) edges are
     excluded from the rectangle's area.

   This means that ``sfml.IntRect(0, 0, 1, 1)`` and ``sfml.IntRect(1,
   1, 1, 1)`` don't intersect.

   Usage example::

      # Define a rectangle, located at (0, 0) with a size of 20x5
      r1 = sfml.IntRect(0, 0, 20, 5)

      # Define another rectangle, located at (4, 2) with a size of 18x10
      r2 = sfml.IntRect(4, 2, 18, 10)

      # Test intersections with the point (3, 1)
      b1 = r1.contains(3, 1) # True
      b2 = r2.contains(3, 1) # False

      # Test the intersection between r1 and r2
      result = sfml.IntRect()
      b3 = r1.intersects(r2, result) # True
      # result == (4, 2, 16, 3)

   .. note::

      You don't have to use this class; everywhere you can pass a
      :class:`IntRect`, you should be able to pass a tuple as
      well. However, it can be more practical to use it, as it
      provides useful methods and is mutable.

   This class provides the following special methods:

   * Comparison operators: ``==`` and ``!=``.

   .. attribute:: left

      Left coordinate of the rectangle.

   .. attribute:: top

      Top coordinate of the rectangle.

   .. attribute:: width

      Width of the rectangle.

   .. attribute:: height

      Height of the rectangle.

   .. method:: contains(int x, int y)

      Return whether or not the rectangle contains the point *(x, y)*.

   .. method:: copy

      Return a new IntRect object with the same value as self.

   .. method:: intersects(IntRect rect[, IntRect intersection])

      Return whether or not the two rectangles intersect. If
      *intersection* is provided, it will be set to the intersection
      area.


.. class:: FloatRect(float left=0, float top=0, float width=0, float height=0)

   A rectangle is defined by its top-left corner and its size.

   To keep things simple, :class:`FloatRect` doesn't define functions
   to emulate the properties that are not directly members (such as
   right, bottom, center, etc.), instead it only provides intersection
   functions.

   :class:`FloatRect` uses the usual rules for its boundaries:

   * The left and top edges are included in the rectangle's area.
   * The right (left + width) and bottom (top + height) edges are
     excluded from the rectangle's area.

   This means that ``sfml.FloatRect(0, 0, 1, 1)`` and ``sfml.FloatRect(1,
   1, 1, 1)`` don't intersect.

   See :class:`IntRect` for an example.

   .. note::

      You don't have to use this class; everywhere you can pass a
      :class:`FloatRect`, you should be able to pass a tuple as
      well. However, it can be more practical to use it, as it
      provides useful methods and is mutable.

   This class provides the following special methods:

   * Comparison operators: ``==`` and ``!=``.

   .. attribute:: left

      The left coordinate of the rectangle.

   .. attribute:: top

      The top coordinate of the rectangle.

   .. attribute:: width

      The width of the rectangle.

   .. attribute:: height

      The height of the rectangle.

   .. method:: contains(int x, int y)

      Return whether or not the rectangle contains the point *(x, y)*.

   .. method:: copy

      Return a new FloatRect object with the same value as self.

   .. method:: intersects(FloatRect rect[, FloatRect intersection])

      Return whether or not the two rectangles intersect. If
      *intersection* is provided, it will be set to the intersection
      area.
