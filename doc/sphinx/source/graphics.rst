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


==========
 Graphics
==========

.. module:: sfml



.. _graphicsref_custom_drawables:

.. note:: Creating your own drawables

   A drawable is an object that can be drawn directly to render
   target, e.g. you can write ``window.draw(a_drawable)``.

   In the past, creating a drawable involved inheriting the ``Drawable``
   class and overriding its ``render()`` method. With the new graphics API,
   you only have to define a ``draw()`` method that takes two parameters::

       def draw(self, target, states):
           target.draw(self.logo)
           target.draw(self.princess)

   *target* and *states* are :class:`RenderTarget` and :class:`RenderStates`
   objects, respectively.  See ``examples/customdrawable.py`` for a working
   example, which also shows how you can use the low-level API.

   The :class:`Transformable` class now contains the operations that
   can be appied to a drawable. Most drawable (i.e. objects that can
   be drawn on a target) are transformable as well.

   C++ documentation:

   * http://www.sfml-dev.org/documentation/2.0/classsf_1_1Drawable.php
   * http://www.sfml-dev.org/documentation/2.0/classsf_1_1Transformable.php



Misc
====


.. _blend_modes:

Blend modes
-----------

.. attribute:: BLEND_ALPHA
.. attribute:: BLEND_ADD
.. attribute:: BLEND_MULTIPLY
.. attribute:: BLEND_NONE


.. _primitive_types:

Primitive types
---------------

.. attribute:: POINTS
.. attribute:: LINES
.. attribute:: LINES_STRIP
.. attribute:: TRIANGLES
.. attribute:: TRIANGLES_FAN
.. attribute:: QUADS


Classes
-------

.. class:: Color(int r, int g, int b[, int a=255])

   This class provides the following special methods:

   * Comparison operators: ``==`` and ``!=``.
   * Arithmetic operators: ``+`` and ``*``.

   The following colors are available as static attibutes, e.g. you can use
   ``sfml.Color.WHITE`` to obtain a reference to the white color.

   * BLACK
   * WHITE
   * RED
   * GREEN
   * BLUE
   * YELLOW
   * MAGENTA
   * CYAN

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


.. class:: Transformable

   Decomposed transform defined by a position, a rotation and a scale.

   This class is provided for convenience, on top of
   :class:`Transform`.

   :class:`Transform`, as a low-level class, offers a great level of
   flexibility but it's not always convenient to manage. One can
   easily combine any kind of operation, such as a translation
   followed by a rotation followed by a scaling, but once the result
   transform is built, there's no way to go backward and, say, change
   only the rotation without modifying the translation and
   scaling. The entire transform must be recomputed, which means that
   you need to retrieve the initial translation and scale factors as
   well, and combine them the same way you did before updating the
   rotation. This is a tedious operation, and it requires to store all
   the individual components of the final transform.

   That's exactly what Transformable was written for: it hides these
   variables and the composed transform behind an easy to use
   interface. You can set or get any of the individual components
   without worrying about the others. It also provides the composed
   transform (as a :class:`Transform` object), and keeps it
   up-to-date.

   In addition to the position, rotation and scale, Transformable
   provides an "origin" component, which represents the local origin
   of the three other components. Let's take an example with a 10x10
   pixels sprite. By default, the sprite is positionned/rotated/scaled
   relatively to its top-left corner, because it is the local point
   (0, 0). But if we change the origin to be (5, 5), the sprite will
   be positionned/rotated/scaled around its center instead. And if we
   set the origin to (10, 10), it will be transformed around its
   bottom-right corner.

   To keep the Transformable class simple, there's only one origin for
   all the components. You cannot position the sprite relatively to
   its top-left corner while rotating it around its center, for
   example. To do this kind of thing, use :class:`Transform` directly.

   Transformable can be used as a base class. It is often combined
   with :ref:`draw() method <graphicsref_custom_drawables>` --- that's
   what SFML's sprites, texts and shapes do::

      // TODO: port to Python
      class MyEntity : public sf::Transformable, public sf::Drawable
      {
          virtual void draw(sf::RenderTarget& target, sf::RenderStates states) const
          {
              states.transform *= getTransform();
              target.draw(..., states);
          }
      };

      MyEntity entity;
      entity.setPosition(10, 20);
      entity.setRotation(45);
      window.draw(entity);

   It can also be used as a member, if you don't want to use its API
   directly (because you don't need all its functions, or you have
   different naming conventions for example)::

      // TODO: port to Python
      class MyEntity
      {
      public :
          void SetPosition(const MyVector& v)
          {
              myTransform.setPosition(v.x(), v.y());
          }

          void Draw(sf::RenderTarget& target) const
          {
              target.draw(..., myTransform.getTransform());
          }

      private :
          sf::Transformable myTransform;
      };

   .. attribute:: origin

      The local origin of the object, as a tuple. When setting the
      attribute, you can also pass a :class:`Vector2f`. The origin of
      an object defines the center point for all transformations
      (position, scale, rotation). The coordinates of this point must
      be relative to the top-left corner of the object, and ignore all
      transformations (position, scale, rotation). The default origin
      of a transformable object is (0, 0).

   .. attribute:: position

      The position of the object, as a tuple. When setting the
      attribute, you can also pass a :class:`Vector2f`. This method
      completely overwrites the previous position. See :meth:`move` to
      apply an offset based on the previous position instead. The
      default position of a transformable object is (0, 0).

   .. attribute:: rotation

      The orientation of the object, as a float in the range [0,
      360]. This method completely overwrites the previous
      rotation. See :meth:`rotate` to add an angle based on the
      previous rotation instead. The default rotation of a
      transformable object is 0.

   .. attribute:: scale

      The scale factors of the object. This method completely
      overwrites the previous scale. See the :meth:`scale` to add a
      factor based on the previous scale instead. The default scale of
      a transformable object is (1, 1).

      The object returned by this property will behave like a tuple,
      but it might be important in some cases to know that its exact
      type isn't tuple, although its class does inherit tuple. In
      practice it should behave just like one, except if you write
      code that checks for exact type using the ``type()`` function.
      Instead, use ``isinstance()``::

        if isinstance(some_object, tuple):
            pass # We now know that some_object is a tuple

   .. attribute:: x

      Shortcut for ``self.position[0]``.

   .. attribute:: y

      Shortcut for ``self.position[1]``.

   .. method:: get_inverse_transform()

      Return the inverse of the combined :class:`Transform` of the
      object.

   .. method:: get_transform()

      Return the combined :class:`Transform` of the object.

   .. method:: move(float x, float y)

      Move the object by a given offset. This method adds to the
      current position of the object, unlike :meth:`position` which
      overwrites it. So it is equivalent to the following code::

         object.position = object.position + offset

   .. method:: rotate(float angle)

      Rotate the object. This method adds to the current rotation of
      the object, unlike :meth:`rotation` which overwrites it. So it
      is equivalent to the following code::

         object.rotation = object.rotation + angle

   .. method:: scale(float x, float y)

      Scale the object. This method multiplies the current scale of
      the object, unlike the :attr:`scale` attribute which overwrites
      it. So it is equivalent to the following code::

         scale = object.scale
         object.scale(scale[0] * factor_x, scale[1] * factor_y)


.. class:: RenderTarget

   Base class for :class:`RenderWindow` and :class:`RenderTexture`. It
   is abstract; the constructor will raise ``NotImplementedError`` if
   you call it.

   .. attribute:: default_view
   .. attribute:: height
   .. attribute:: size
   .. attribute:: view
   .. attribute:: width

   .. method:: clear
   .. method:: convert_coords
   .. method:: draw(drawable, ...)

      *drawable* may be:

      * A built-in drawable, such as :class:`Sprite` or :class:`Text`,
        or a user-made drawable (see :ref:`Creating your own drawables
        <graphicsref_custom_drawables>`). You can pass a second
        argument of type :class:`Shader` or
        :class:`RenderStates`. Example::

            window.draw(sprite, shader)

      * A list or a tuple of :class:`Vertex` objects. You must pass a
        :ref:`primitive type <primitive_types>` as a second argument,
        and can pass a :class:`Shader` or :class:`RenderStates` as a
        third argument. Example::

            window.draw(vertices, sfml.QUADS, shader)

        See ``examples/vertices.py`` for a working example.

   .. method:: get_viewport
   .. method:: pop_gl_states
   .. method:: push_gl_states
   .. method:: reset_gl_states



.. class:: IntRect(int left=0, int top=0, int width=0, int height=0)

   You don't have to use this class; everywhere you can pass a
   :class:`IntRect`, you should be able to pass a tuple as
   well. However, it can be more practical to use it, as it provides
   useful methods and is mutable.

   This class provides the following special methods:

   * Comparison operators: ``==`` and ``!=``.

   .. attribute:: left
   .. attribute:: top
   .. attribute:: width
   .. attribute:: height

   .. method:: contains(int x, int y)

   .. method:: copy

      Return a new IntRect object with the same value as self.

   .. method:: intersects(IntRect rect[, IntRect intersection])



.. class:: FloatRect(float left=0, float top=0, float width=0, float height=0)

   You don't have to use this class; everywhere you can pass a
   :class:`FloatRect`, you should be able to pass a tuple as
   well. However, it can be more practical to use it, as it provides
   useful methods and is mutable.

   This class provides the following special methods:

   * Comparison operators: ``==`` and ``!=``.

   .. attribute:: left
   .. attribute:: top
   .. attribute:: width
   .. attribute:: height

   .. method:: contains(int x, int y)

   .. method:: copy

      Return a new FloatRect object with the same value as self.

   .. method:: intersects(FloatRect rect[, FloatRect intersection])



.. class:: Transform([float a00, float a01, float a02,\
                     float a10, float a11, float a12,\
                     float a20, float a21, float a22])

   If called with no arguments, the value is set to the identity
   transform.

   This class provides the following special methods:

   * ``*`` and ``*=`` operators.
   * ``str()`` returns the content of the matrix in a human-readable format.

   .. attribute:: IDENTITY

      Class attribute containing the identity matrix.

   .. attribute:: matrix

   .. method:: combine(transform)
   .. method:: copy()

      Return a new transform object with the same content as self.

   .. method:: get_inverse()
   .. method:: rotate(float angle[, float center_x, float center_y])
   .. method:: scale(float scale_x, float scale_y[, float, center_y,\
                     float center_y])
   .. method:: transform_point(float x, float y)
   .. method:: transform_rect(FloatRect rectangle)
   .. method:: translate(float x, float y)





Image display and effects
=========================



.. class:: Shape

   This abstract class inherits :class:`Transformable`. To create your
   own shapes, you should override :meth:`get_point` and
   :meth:`get_point_count`. A few built-in shapes are provided:
   :class:`RectangleShape`, :class:`CircleShape` and \
   :class:`ConvexShape`.

   .. attribute:: fill_color
   .. attribute:: global_bounds
   .. attribute:: local_bounds
   .. attribute:: texture
   .. attribute:: texture_rect
   .. attribute:: outline_color
   .. attribute:: outline_thickness

   .. method:: get_point(int index)

      This method should be overriden to return a tuple or a
      :class:`Vector2f` containing the coordinates at the position
      ``index``.

   .. method:: get_point_count()

      This method should be overriden to return the number of points,
      as an integer.

   .. method:: set_texture(texture[, reset_rect=False])
   .. method:: update()

      This method is not available in built-in SFML shapes (it would
      require extra work for each class, and doesn't seem useful for
      any use case).



.. class:: RectangleShape([size])

   This class inherits :class:`Shape`. *size* can be either a tuple or
   a :class:`Vector2f`.

   .. attribute:: size



.. class:: CircleShape([float radius[, int point_count]])

   This class inherits :class:`Shape`.

   .. attribute:: point_count
   .. attribute:: radius


.. class:: ConvexShape([int point_count])

   This class inherits :class:`Shape`.

   .. method:: get_point(int index)
   .. method:: get_point_count
   .. method:: set_point(int index, point)

      *point* may be either a tuple or a :class:`Vector2f`.

   .. method:: set_point_count(int count)


.. class:: Image(int width, int height[, color])

   .. attribute:: height
   .. attribute:: size
   .. attribute:: width

   .. classmethod:: load_from_file(filename)
   .. classmethod:: load_from_memory(str mem)
   .. classmethod:: load_from_pixels(int width, int height, str pixels)

   .. method:: __getitem__()

      Get a pixel from the image. Equivalent to :meth:`get_pixel()`. Example::

         print image[0,0]  # Create tuple implicitly
         print image[(0,0)]  # Create tuple explicitly

   .. method:: __setitem__()

      Set a pixel of the image. Equivalent to :meth:`set_pixel()`. Example::

         image[0,0] = sfml.Color(10, 20, 30)  # Create tuple implicitly
         image[(0,0)] = sfml.Color(10, 20, 30)  # Create tuple explicitly

   .. method:: copy(Image source, int dest_x, int dest_y\
                    [, source_rect, apply_alpha])
   .. method:: create_mask_from_color(color, int alpha)
   .. method:: get_pixel(int x, int y)
   .. method:: get_pixels()
   .. method:: save_to_file(filename)
   .. method:: set_pixel(int x, int y, color)
   .. method:: update_pixels(str pixels[, rect])



.. class:: Texture([int width[, int height]])

   The constructor serves the same purpose as ``Texture.create()`` in
   C++ SFML. It raises :exc:`PySFMLException` if texture creation fails.

   :class:`Image` living on the graphics card that can be used for
   drawing.

   A texture lives in the graphics card memory, therefore it is very
   fast to draw a texture to a render target, or copy a render target
   to a texture (the graphics card can access both directly).

   Being stored in the graphics card memory has some drawbacks. A
   texture cannot be manipulated as freely as a :class:`Image`, you
   need to prepare the pixels first and then upload them to the
   texture in a single operation (see :meth:`update`).

   Texture makes it easy to convert from/to :class:`Image`, but keep
   in mind that these calls require transfers between the graphics
   card and the central memory, therefore they are slow operations.

   A texture can be loaded from an image, but also directly from a
   file/memory/stream. The necessary shortcuts are defined so that you
   don't need an image first for the most common cases. However, if
   you want to perform some modifications on the pixels before
   creating the final texture, you can load your file to a
   :class:`Image`, do whatever you need with the pixels, and then call
   :meth:`load_from_image`.

   Since they live in the graphics card memory, the pixels of a
   texture cannot be accessed without a slow copy first. And they
   cannot be accessed individually. Therefore, if you need to read the
   texture's pixels (like for pixel-perfect collisions), it is
   recommended to store the collision information separately, for
   example in an array of booleans.

   Like :class:`Image`, Texture can handle a unique internal
   representation of pixels, which is RGBA 32 bits. This means that a
   pixel must be composed of 8 bits red, green, blue and alpha
   channels --- just like a :class:`Color`.

   Usage example::

      # This example shows the most common use of Texture:
      # drawing a sprite

      # Load a texture from a file
      texture = sfml.load_from_file('texture.png')

      # Assign it to a sprite
      sprite = sfml.Sprite(texture)

      # Draw the textured sprite
      window.draw(sprite)

   ::

      # This example shows another common use of Texture:
      # streaming real-time data, like video frames

      # Create an empty texture
      texture = sfml.Texture(640, 480)

      # Create a sprite that will display the texture
      sprite = sfml.Sprite(texture)

      while True:
          # ...

          # Update the texture
          # Get a fresh chunk of pixels (the next frame of a movie, for example)
          # This should be a string object in Python 2, and a bytes object in Python 3
          pixels = get_pixels()
          texture.update(pixels)

          # draw it
          window.draw(sprite)

          # ...

   .. attribute:: MAXIMUM_SIZE

      Read-only. The maximum texture size allowed, as a class
      attribute. This maximum size is defined by the graphics
      driver. You can expect a value of 512 pixels for low-end
      graphics card, and up to 8192 pixels or more for newer hardware.

   .. attribute:: height   

      Read-only. The height of the texture.

   .. attribute:: repeated

      Whether the texture is repeated or not. Repeating is involved
      when using texture coordinates outside the texture rectangle [0,
      0, width, height]. In this case, if repeat mode is enabled, the
      whole texture will be repeated as many times as needed to reach
      the coordinate (for example, if the X texture coordinate is 3 *
      width, the texture will be repeated 3 times). If repeat mode is
      disabled, the "extra space" will instead be filled with border
      pixels. Repeating is disabled by default.

      .. warning::

         On very old graphics cards, white pixels may appear when the
         texture is repeated. With such cards, repeat mode can be used
         reliably only if the texture has power-of-two dimensions
         (such as 256x128).

   .. attribute:: size

      Read-only. The size of the texture.

   .. attribute:: smooth

      Whether the smooth filter is enabled or not. When the filter is
      activated, the texture appears smoother so that pixels are less
      noticeable. However if you want the texture to look exactly the
      same as its source file, you should leave it disabled. The
      smooth filter is disabled by default.

   .. attribute:: width

      Read-only. The width of the texture.

   .. classmethod:: load_from_file(filename[, area])

      Load the texture from a file on disk. This function is a
      shortcut for the following code::

         image = sfml.Image.load_from_file(filename)
         sfml.Texture.load_from_image(image, area)

      *area*, if specified, may be either a tuple or an
      :class:`IntRect`. Then only a sub-rectangle of the whole image
      will be loaded. If the area rectangle crosses the bounds of the
      image, it is adjusted to fit the image size.

      The maximum size for a texture depends on the graphics driver
      and can be retrieved with the getMaximumSize function.

      :exc:`PySFMLException` is raised if the loading fails.

   .. classmethod:: load_from_image(image[, area])

      Load the texture from an image.

      *area*, if specified, may be either a tuple or an
      :class:`IntRect`. Then only a sub-rectangle of the whole image
      will be loaded. If the area rectangle crosses the bounds of the
      image, it is adjusted to fit the image size.

      The maximum size for a texture depends on the graphics driver
      and is accessible with the :attr:`MAXIMUM_SIZE` class attribute.

      :exc:`PySFMLException` is raised if the loading fails.

   .. classmethod:: load_from_memory(bytes data[, area])

      Load the texture from a file in memory. This function is a
      shortcut for the following code::

         image = sfml.Image.load_from_memory(data)
         texture = sfml.Texture.load_from_image(image, area)

      *area*, if specified, may be either a tuple or an
      :class:`IntRect`. Then only a sub-rectangle of the whole image
      will be loaded. If the area rectangle crosses the bounds of the
      image, it is adjusted to fit the image size.

      The maximum size for a texture depends on the graphics driver
      and is accessible with the :attr:`MAXIMUM_SIZE` class attribute.

      :exc:`PySFMLException` is raised if the loading fails.

   .. method:: copy_to_image()

      Copy the texture pixels to an image and return it. This method
      performs a slow operation that downloads the texture's pixels
      from the graphics card and copies them to a new image,
      potentially applying transformations to pixels if necessary
      (texture may be padded or flipped).

   .. method:: update(source, ...)

      This method can be called in three ways, to be consistent with
      the C++ method overloading:

      ::

         update(bytes pixels[, width, height, x, y])

      Update a part of the texture from an array of pixels. The size
      of *pixels* must match the width and height arguments, and it
      must contain 32-bits RGBA pixels. No additional check is
      performed on the size of the pixel array or the bounds of the
      area to update, passing invalid arguments will lead to an
      undefined behaviour.

      ::

         update(image[, x, y])

      Update the texture from an image. Although the source image can
      be smaller than the texture, it's more convenient to use the *x*
      and *y* parameters for updating a sub-area of the texture.

      ::

         update(window[, x, y])

      Update the texture from the contents of a window. Although the
      source window can be smaller than the texture, it's more
      convenient to use the *x* and *y* parameters for updating a
      sub-area of the texture. No additional check is performed on the
      size of the window, passing a window bigger than the texture
      will lead to an undefined behaviour.

.. class:: Sprite([texture])

   This class inherits :class:`Transformable`.

   Drawable representation of a texture, with its own transformations,
   color, etc.

   It inherits all the attributes from :class:`Transformable`:
   position, rotation, scale, origin. It also adds sprite-specific
   properties such as the texture to use, the part of it to display,
   and some convenience functions to change the overall color of the
   sprite, or to get its bounding rectangle.

   Sprite works in combination with the :class:`Texture` class, which
   loads and provides the pixel data of a given texture.

   The separation of Sprite and :class:`Texture` allows more
   flexibility and better performances: indeed a :class:`Texture` is a
   heavy resource, and any operation on it is slow (often too slow for
   real-time applications). On the other side, a sf::Sprite is a
   lightweight object which can use the pixel data of a
   :class:`Texture` and draw it with its own
   transformation/color/blending attributes.

   Usage example::

      # Load a texture
      texture = sfml.Texture.load_from_file('texture.png')
 
      # Create a sprite
      sprite = sfml.Sprite(texture)
      sprite.texture_rect = sfml.IntRect(10, 10, 50, 30)
      sprite.color = sfml.Color(255, 255, 255, 200)
      sprite.position = (100, 25)

      # Draw it
      window.draw(sprite)

   .. attribute:: color

      The global color of the sprite. This color is modulated
      (multiplied) with the sprite's texture. It can be used to
      colorize the sprite, or change its global opacity. By default,
      the sprite's color is opaque white.

   .. attribute:: global_bounds

      Read-only. The global bounding rectangle of the entity, as a
      :class:`FloatRect`.

      The returned rectangle is in global coordinates, which means
      that it takes into account the transformations (translation,
      rotation, scale, ...) that are applied to the entity. In other
      words, this function returns the bounds of the sprite in the
      global 2D world's coordinate system.

   .. attribute:: local_bounds

      Read-only. The local bounding rectangle of the entity, as a
      :class:`FloatRect`.

      The returned rectangle is in local coordinates, which means that
      it ignores the transformations (translation, rotation, scale,
      ...) that are applied to the entity. In other words, this
      function returns the bounds of the entity in the entity's
      coordinate system.

   .. attribute:: texture

      The source :class:`Texture` of the sprite, or ``None`` if no
      texture has been set. Also see :meth:`set_texture`, which lets
      you provide another argument.

   .. method:: copy

      Return a new Sprite object with the same value. The new sprite's
      texture is the same as the current one (no new texture is created).

   .. method:: get_texture_rect

      Return the sub-rectangle of the texture displayed by the sprite,
      as an :class:`IntRect`. The texture rect is useful when you only
      want to display a part of the texture. By default, the texture
      rect covers the entire texture.

      .. warning::

         This method returns a copy of the rectangle, so code like
         this won't work as expected::

             sprite.get_texture_rect().top = 10
             # Or this:
             rect = sprite.get_texture_rect()
             rect.top = 10

         Instead, you need to call :meth:`set_texture_rect` with the
         desired rect::

             rect = sprite.get_texture_rect()
             rect.top = 10
             sprite.set_texture_rect(rect)

   .. method:: set_texture(texture[, reset_rect=False])

      Set the source :class:`Texture` of the sprite. If *reset_rect*
      is ``True``, the texture rect of the sprite is automatically
      adjusted to the size of the new texture. If it is ``False``, the
      texture rect is left unchanged.

   .. method:: set_texture_rect(rect)

      Set the sub-rectangle of the texture displayed by the sprite, as
      an :class:`IntRect`. The texture rect is useful when you only
      want to display a part of the texture. By default, the texture
      rect covers the entire texture. *rect* may an :class:`IntRect`
      or a tuple.


.. class:: Shader

   The constructor will raise ``NotImplementedError`` if called.  Use
   class methods like :meth:`load_from_file()` or :meth:`load_from_memory()`
   instead.

   Shaders are programs written using a specific language, executed
   directly by the graphics card and allowing to apply real-time
   operations to the rendered entities.

   There are two kinds of shaders:

   * Vertex shaders, that process vertices.
   * Fragment (pixel) shaders, that process pixels.

   A shader can be composed of either a vertex shader alone, a
   fragment shader alone, or both combined (see the variants of the
   load classmethods).

   Shaders are written in GLSL, which is a C-like language dedicated
   to OpenGL shaders. You'll probably need to learn its basics before
   writing your own shaders for SFML.

   Like any Python program, a shader has its own variables that you can
   set from your Python. :class:`Shader` handles four different types
   of variables:

   * floats
   * vectors (2, 3 or 4 components)
   * textures
   * transforms (matrices)

   The value of the variables can be changed at any time with
   :meth:`set_parameter`::

       shader.set_parameter('offset', 2.0)
       shader.set_parameter('color', 0.5, 0.8, 0.3)
       shader.set_parameter('matrix', transform); # transform is a sfml.Transform
       shader.set_parameter('overlay', texture) # texture is a sfml.Texture
       shader.set_parameter('texture', sfml.Shader.CURRENT_TEXTURE)

   The special :attr:`Shader.CURRENT_TEXTURE` argument maps the given
   texture variable to the current texture of the object being drawn
   (which cannot be known in advance).

   To apply a shader to a drawable, you must pass it as an additional
   parameter to :meth:`RenderTarget.draw`::

       window.draw(sprite, shader)

   Which is in fact just a shortcut for this::

       states = sfml.RenderStates()
       states.shader = shader
       window.draw(sprite, states)

   Shaders can be used on any drawable, but some combinations are not
   interesting. For example, using a vertex shader on a
   :class:`Sprite` is limited because there are only 4 vertices, the
   sprite would have to be subdivided in order to apply wave
   effects. Another bad example is a fragment shader with
   :class:`Text`: the texture of the text is not the actual text that
   you see on screen, it is a big texture containing all the
   characters of the font in an arbitrary order; thus, texture lookups
   on pixels other than the current one may not give you the expected
   result.

   Shaders can also be used to apply global post-effects to the
   current contents of the target (like the old ``PostFx`` class in
   SFML 1). This can be done in two different ways:

   * Draw everything to a :class:`RenderTexture`, then draw it to the main
     target using the shader.
   * Draw everything directly to the main target, then use
     :meth:`Texture.update` to copy its contents to a texture
     and draw it to the main target using the shader.

   The first technique is more optimized because it doesn't involve
   retrieving the target's pixels to system memory, but the second one
   doesn't impact the rendering process and can be easily inserted
   anywhere without impacting all the code.

   Like :class:`Texture` that can be used as a raw OpenGL texture,
   :class:`Shader` can also be used directly as a raw shader for
   custom OpenGL geometry::

      window.active = True
      shader.bind()
      # render OpenGL geometry ...
      shader.unbind()


   .. attribute:: IS_AVAILABLE
   .. attribute:: CURRENT_TEXTURE
   .. attribute:: FRAGMENT
   .. attribute:: VERTEX

   .. classmethod:: load_both_types_from_file(str vertex_shader_filename,\
                                              str fragment_shader_filename)
   .. classmethod:: load_both_types_from_memory(str vertex_shader,\
                                                str fragment_shader)
   .. classmethod:: load_from_file(filename, int type)

      *type* must be :attr:`Shader.FRAGMENT` or :attr:`Shader.VERTEX`.

   .. classmethod:: load_from_memory(str shader, int type)

      *type* must be :attr:`Shader.FRAGMENT` or :attr:`Shader.VERTEX`.

   .. method:: bind()

   .. method:: set_parameter(str name, float x[, float y, float z, float w])

      After *name*, you can pass as many parameters as four, depending
      on your need.

   .. method:: unbind()




.. class:: RenderTexture(int width, int height[, bool depth=False])

   .. attribute:: active
   .. attribute:: default_view
   .. attribute:: height
   .. attribute:: texture
   .. attribute:: smooth
   .. attribute:: view
   .. attribute:: width
    
   .. method:: clear([color])
   .. method:: convert_coords(int x, int y[, view])
   .. method:: create(int width, int height[, bool depth=False])
   .. method:: display()
   .. method:: draw(drawable[, shader])
   .. method:: get_viewport(view)
   .. method:: restore_gl_states()
   .. method:: save_gl_states()



.. class:: Vertex([position[, color[, tex_coords]]])

   .. attribute:: color
   .. attribute:: position
   .. attribute:: tex_coords


Windowing
=========


.. class:: RenderWindow([VideoMode mode, title\
                        [, style[, ContextSettings settings]]])

   *style* can be one of:

   ========================= ===========
   Name                      Description
   ========================= ===========
   ``sfml.Style.NONE``
   ``sfml.Style.TITLEBAR``
   ``sfml.Style.RESIZE``
   ``sfml.Style.CLOSE``
   ``sfml.Style.FULLSCREEN``
   ========================= ===========

   .. attribute:: active
   .. attribute:: framerate_limit
   .. attribute:: height

      Unlike :attr:`RenderTarget.height`, this property can be
      modified.

   .. attribute:: joystick_threshold
   .. attribute:: key_repeat_enabled
   .. attribute:: mouse_cursor_visible
   .. attribute:: open
   .. attribute:: position
   .. attribute:: settings
   .. attribute:: size

      Unlike :attr:`RenderTarget.size`, this property can be modified.

   .. attribute:: system_handle

      Return the system handle as a long (or int on Python 3). Windows
      and Mac users will probably need to cast this as another type
      suitable for their system's API. Please contact me and show me
      your use case so that I can make the API more user-friendly.

   .. attribute:: title
   .. attribute:: vertical_sync_enabled
   .. attribute:: view
   .. attribute:: width

      Unlike :attr:`RenderTarget.width`, this property can be
      modified.

   .. classmethod:: from_window_handle(long window_handle\
                                       [, ContextSettings settings])

      Equivalent to this C++ constructor::

         RenderWindow(WindowHandle, ContextSettings=ContextSettings())

   .. method:: clear([color])
   .. method:: close()
   .. method:: convert_coords(x, y[, view])
   .. method:: create(VideoMode mode, title\
                      [, int style[, ContextSettings settings]])
   .. method:: display()
   .. method:: draw()
   .. method:: get_input()
   .. method:: get_viewport(view)
   .. method:: iter_events()

      Return an iterator which yields the current pending events. Example::
        
         for event in window.iter_events():
             if event.type == sfml.Event.CLOSED:
                 pass # ...

   .. method:: poll_event()
   .. method:: restore_gl_states()
   .. method:: save_gl_states()
   .. method:: set_icon(int width, int height, str pixels)
   .. method:: show(show)
   .. method:: wait_event()




.. class:: RenderStates(shader=None, texture=None, transform=None)

   .. attribute:: blend_mode

      See :ref:`blend_modes`.

   .. attribute:: shader
   .. attribute:: texture
   .. attribute:: transform



.. class:: ContextSettings(int depth=24, int stencil=8, int antialiasing=0,\
                           int major=2, int minor=0)

   .. attribute:: antialiasing_level
   .. attribute:: depth_bits
   .. attribute:: major_version
   .. attribute:: minor_version
   .. attribute:: stencil_bits



.. class:: VideoMode([width, height, bits_per_pixel=32])

   A video mode is defined by a width and a height (in pixels) and a
   depth (in bits per pixel). Video modes are used to setup windows
   (:class:`RenderWindow`) at creation time.

   The main usage of video modes is for fullscreen mode: you have to
   use one of the valid video modes allowed by the OS (which are
   defined by what the monitor and the graphics card support),
   otherwise your window creation will just fail.

   VideoMode provides a static method for retrieving the list of all
   the video modes supported by the system:
   :class:`get_fullscreen_modes`.

   A custom video mode can also be checked directly for fullscreen
   compatibility with its :meth:`is_valid` method.

   Additionnally, VideoMode provides a static method to get the mode
   currently used by the desktop: :meth:`get_desktop_mode`. This
   allows to build windows with the same size or pixel depth as the
   current resolution.

   Usage example::

      # Display the list of all the video modes available for fullscreen
      modes = sfml.VideoMode.get_fullscreen_modes()

      for mode in modes:
          print(mode)

      # Create a window with the same pixel depth as the desktop
      desktop_mode = sfml.VideoMode.get_desktop_mode()
      window.create(sfml.VideoMode(1024, 768, desktop_mode.bits_per_pixel),
                    'SFML window')

   This class overrides the following special method:

   * Comparison operators (``==``, ``!=``, ``<``, ``>``, ``<=`` and
     ``>=``).
   * ``__str__()`` returns a description of the mode in a
     ``widthxheightxbpp`` format.
   * ``__repr__()`` returns a string in a ``VideoMode(width, height,
     bpp)`` format.

   .. attribute:: width

      Video mode width, in pixels.

   .. attribute:: height

      Video mode height, in pixels.

   .. attribute:: bits_per_pixel

      Video mode depth, in bits per pixel.

   .. classmethod:: get_desktop_mode()

      Return the current desktop mode.

   .. classmethod:: get_fullscreen_modes()

      Return a list of all the video modes supported in fullscreen
      mode. It is sorted from best to worst, so that the first element
      will always give the best mode (higher width, height and
      bits-per-pixel).

   .. method:: is_valid()

      Return a boolean telling whether the mode is valid or not. This
      is only relevant in fullscreen mode; in other cases all modes
      are valid.


.. class:: View



   .. attribute:: center
   .. attribute:: height
   .. attribute:: rotation
   .. attribute:: size
   .. attribute:: viewport
   .. attribute:: width

   .. classmethod:: from_center_and_size(center, size)

      *center* and *size* can be either tuples or :class:`Vector2f`.

   .. classmethod:: from_rect(rect)

   .. method:: get_inverse_transform()
   .. method:: get_transform()
   .. method:: move()
   .. method:: reset()
   .. method:: rotate()
   .. method:: zoom()





Text
====


.. class:: Font()

   The constructor will raise ``NotImplementedError`` if called.  Use
   class methods like :meth:`load_from_file()` or :meth:`load_from_memory()`
   instead.

   The following types of fonts are supported: TrueType, Type 1, CFF,
   OpenType, SFNT, X11 PCF, Windows FNT, BDF, PFR and Type 42.

   Once it's loaded, you can retrieve three types of information about the font:

   * Global metrics, such as the line spacing.
   * Per-glyph metrics, such as bounding box or kerning.
   * Pixel representation of glyphs.

   Fonts alone are not very useful: they hold the font data but cannot
   make anything useful of it. To do so you need to use the
   :class:`Text` class, which is able to properly output text with
   several options such as character size, style, color, position,
   rotation, etc. This separation allows more flexibility and better
   performances: a font is a heavy resource, and any operation on it
   is slow (often too slow for real-time applications). On the other
   hand, a :class:`Text` is a lightweight object which can combine the
   glyphs data and metrics of a font to display any text on a render
   target. Note that it is also possible to bind several text
   instances to the same font.

   Usage example::

       # Load a font from a file, catch PySFMLException
       # if you want to handle the error
       font = sfml.Font.load_from_file('arial.ttf')
 
       # Create a text which uses our font
       text1 = sfml.Text()
       text1.font = font
       text1.character_size = 30
       text1.style = sfml.Text.REGULAR
 
       # Create another text using the same font, but with different parameters
       text2 = sfml.Text()
       text2.font = font
       text2.character_size = 50
       text1.style = sfml.Text.ITALIC

   Apart from loading font files, and passing them to instances of
   :class:`Text`, you should normally not have to deal directly with
   this class. However, it may be useful to access the font metrics or
   rasterized glyphs for advanced usage.

   .. attribute:: DEFAULT_FONT

      The default font (Arial), as a class attribute::

         print sfml.Font.DEFAULT_FONT

      This font is provided for convenience, it is used by text
      instances by default. It is provided so that users don't have to
      provide and load a font file in order to display text on
      screen.

   .. classmethod:: load_from_file(filename)

      Load the font from *filename*, and return a new font object.

      Note that this class method knows nothing about the standard
      fonts installed on the user's system, so you can't load them
      directly.

      :exc:`PySFMLException` is raised if an error occurs.

   .. classmethod:: load_from_memory(bytes data)

      Load the font from the string/bytes object (for Python 2/3,
      respectively) and return a new font object.

      .. warning::

         SFML cannot preload all the font data in this function, so
         you should keep a reference to the *data* object as long as
         the font is used.

   .. method:: get_glyph(int code_point, int character_size, bool bold)

      Return a glyph corresponding to *code_point* and *character_size*.

   .. method:: get_texture(int character_size)

      Retrieve the texture containing the loaded glyphs of a certain size.

      The contents of the returned texture changes as more glyphs are
      requested, thus it is not very relevant. It is mainly used
      internally by :class:`Text`.

   .. method:: get_kerning(int first, int second, int character_size)

      Return the kerning offset of two glyphs.

      The kerning is an extra offset (negative) to apply between two
      glyphs when rendering them, to make the pair look more
      "natural". For example, the pair "AV" have a special kerning to
      make them closer than other characters. Most of the glyphs pairs
      have a kerning offset of zero, though.

   .. method:: get_line_spacing(int character_size)

      Get the line spacing.

      Line spacing is the vertical offset to apply between two
      consecutive lines of text.



.. class:: Text([string, font, character_size=0])

   This class inherits :class:`Transformable`.

   *string* can be either a regular string or Unicode. SFML will
   internally store characters as 32-bit integers. A ``str`` object
   will end up being interpreted by SFML as an "ANSI string" (cp1252
   encoding). A ``unicode`` object will be interpreted as 32-bit code
   points, as you would expect.

   .. attribute:: character_size
   .. attribute:: color
   .. attribute:: font
   .. attribute:: global_bounds
   .. attribute:: local_bounds
   .. attribute:: string

      This attribute can be set as either a ``str`` or ``unicode``
      object. The value retrieved will be either ``str`` or
      ``unicode`` as well, depending on what type has been set
      before. See :class:`Text` for more information.

   .. attribute:: style

      Can be one or more of the following:

      * ``sfml.Text.REGULAR``
      * ``sfml.Text.BOLD``
      * ``sfml.Text.ITALIC``
      * ``sfml.Text.UNDERLINED``

      Example::

         text.style = sfml.Text.BOLD | sfml.Text.ITALIC

   .. method:: find_character_pos(int index)



.. class:: Glyph

   .. attribute:: advance
   .. attribute:: bounds
   .. attribute:: texture_rect
