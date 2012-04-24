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


Graphics
========

.. module:: sfml



.. _custom_drawables:

.. note:: Creating your own drawables

   A drawable is an object that can be draw directly to render target,
   e.g. you can write ``window.draw(a_drawable)``. The object can also
   be drawn using the low-level API.

   In the past, creating a drawable involved inheriting the ``Drawable``
   class and overriding its ``render()`` method. With the new graphics API,
   you only have to define a ``draw()`` method that takes two parameters::

       def draw(self, target, states):
           target.draw(self.logo)
           target.draw(self.princess)

   *target* and *states* are :class:`RenderTarget` and
   :class:`RenderStates` objects, respectively.  See
   ``examples/customdrawable.py`` for a working example.

   The :class:`Transformable` class now contains the operations that
   can be appied to a drawable. Most drawable (i.e. objects that can
   be drawn on a target) are transformable as well.

   C++ documentation:

   * http://www.sfml-dev.org/documentation/2.0/classsf_1_1Drawable.php
   * http://www.sfml-dev.org/documentation/2.0/classsf_1_1Transformable.php



Misc
----


.. _blend_modes:

Blend modes
^^^^^^^^^^^

.. attribute:: BLEND_ALPHA
.. attribute:: BLEND_ADD
.. attribute:: BLEND_MULTIPLY
.. attribute:: BLEND_NONE


.. _primitive_types:

Primitive types
^^^^^^^^^^^^^^^

.. attribute:: POINTS
.. attribute:: LINES
.. attribute:: LINES_STRIP
.. attribute:: TRIANGLES
.. attribute:: TRIANGLES_FAN
.. attribute:: QUADS


Classes
^^^^^^^

.. class:: Color(int r, int g, int b[, int a=255])

   Note: this class overrides some comparison and arithmetic operators in the
   same way that C++ class does.

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
   .. attribute:: g
   .. attribute:: b
   .. attribute:: a




.. class:: Transformable

   Abstract class.

   .. attribute:: origin
   .. attribute:: position
   .. attribute:: rotation
   .. attribute:: scale

      The object returned by this property will behave like a tuple,
      but it might be important in some cases to know that its exact
      type isn't tuple, although its class does inherit tuple. In
      practice it should behave just like one, except if you write
      code that checks for exact type using the ``type()`` function.
      Instead, use ``isinstance()``::

        if isinstance(some_object, tuple):
            # We now know that some_object is a tuple

   .. attribute:: x
   .. attribute:: y

   .. method:: get_inverse_transform()
   .. method:: get_transform()
   .. method:: move(float x, float y)
   .. method:: rotate(float angle)



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
        <custom_drawables>`). You can pass a second argument of type
        :class:`Shader` or :class:`RenderStates`. Example::

            window.draw(sprite, shader)

      * A list of :class:`Vertex` objects. You must pass a
        :ref:`primitive type <primitive_types>` as a second argument,
        and can pass a :class:`Shader` or :class:`RenderStates` as a
        third argument. Example::

            window.draw(vertices, sf::QUADS, shader)

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

   .. attribute:: left
   .. attribute:: top
   .. attribute:: width
   .. attribute:: height

   .. method:: contains(int x, int y)
   .. method:: intersects(IntRect rect[, IntRect intersection])



.. class:: FloatRect(float left=0, float top=0, float width=0, float height=0)

   You don't have to use this class; everywhere you can pass a
   :class:`FloatRect`, you should be able to pass a tuple as
   well. However, it can be more practical to use it, as it provides
   useful methods and is mutable.

   .. attribute:: left
   .. attribute:: top
   .. attribute:: width
   .. attribute:: height

   .. method:: contains(int x, int y)
   .. method:: intersects(FloatRect rect[, FloatRect intersection])



.. class:: Transform(float a00, float a01, float a02,\
                     float a10, float a11, float a12,\
                     float a20, float a21, float a22)

   This class provides the following special methods:

   * ``*`` operator.
   * ``str()`` returns the content of the matrix in a human-readable format.

   .. attribute:: IDENTITY

      Class attribute containing the identity matrix.

   .. attribute:: matrix

   .. method:: combine(transform)
   .. method:: get_inverse()
   .. method:: rotate(float angle[, float center_x, float center_y])
   .. method:: scale(float scale_x, float scale_y[, float, center_y,\
                     float center_y])
   .. method:: transform_point(float x, float y)
   .. method:: transform_rect(FloatRect rectangle)
   .. method:: translate(float x, float y)





Image display and effects
-------------------------



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

   .. attribute:: point_count


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

   This class has been introduced in SFML 2. It basically replaces the
   :class:`Image` class, except when you need to access or set pixels,
   which is only possible with Images.

   .. attribute:: MAXIMUM_SIZE
   .. attribute:: height   
   .. attribute:: repeated
   .. attribute:: size
   .. attribute:: smooth
   .. attribute:: width

   .. classmethod:: load_from_file(filename[, area])

      *area* can be either a tuple or an :class:`IntRect`.

   .. classmethod:: load_from_image(image[, area])

      *area* can be either a tuple or an :class:`IntRect`.

   .. classmethod:: load_from_memory(bytes data[, area])

      *area* can be either a tuple or an :class:`IntRect`.

   .. method:: bind()
   .. method:: copy_to_image()
   .. method:: update(object source, int p1=-1, int p2=-1, int p3=-1, int p4=-1)

      This method can be called in three ways, to be consistent with
      the C++ method overloading::

          update(bytes pixels[, width, height, x, y])
          update(image[, x, y])
          update(window[, x, y])



.. class:: Sprite([texture])

   This class inherits :class:`Transformable`.

   .. attribute:: color
   .. attribute:: global_bounds
   .. attribute:: local_bounds
   .. attribute:: texture
   .. attribute:: texture_rect

      .. warning::

         This property returns a copy of the rectangle, so code like
         this won't work::

             sprite.texture_rect.top = 10

         Instead, you need to explicitely set the property to the
         desired value:

             rect = sprite.texture_rect
             # ...
             sprite.texture_rect = rect

   .. method:: set_texture(texture[, adjust_to_new_size=False])



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

       shader.set_parameter('offset', 2.f);
       shader.set_parameter('color', 0.5f, 0.8f, 0.3f);
       shader.set_parameter('matrix', transform); # transform is a sfml.Transform
       shader.set_parameter('overlay', texture); # texture is a sfml.Texture
       shader.set_parameter('texture', sfml.Shader.CURRENT_TEXTURE);

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
---------


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
   .. attribute:: cursor_position
   .. attribute:: default_view
   .. attribute:: framerate_limit
   .. attribute:: height
   .. attribute:: joystick_threshold
   .. attribute:: key_repeat_enabled
   .. attribute:: mouse_cursor_visible
   .. attribute:: open
   .. attribute:: position
   .. attribute:: settings
   .. attribute:: size

   .. attribute:: system_handle

      Return the system handle as a long (or int on Python 3). Windows
      and Mac users will probably need to cast this as another type
      suitable for their system's API. Please contact me and show me
      your use case so that I can make the API more user-friendly.

   .. attribute:: title
   .. attribute:: vertical_sync_enabled
   .. attribute:: view
   .. attribute:: width

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
                 # ...

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

   Note: this class overrides the comparison operators.

   .. attribute:: width
   .. attribute:: height
   .. attribute:: bits_per_pixel

   .. classmethod:: get_desktop_mode()
   .. classmethod:: get_fullscreen_modes()

   .. method:: is_valid()



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
----


.. class:: Font()

   The constructor will raise ``NotImplementedError`` if called.  Use
   class methods like :meth:`load_from_file()` or :meth:`load_from_memory()`
   instead.

   The following types of fonts are supported: TrueType, Type 1, CFF,
   OpenType, SFNT, X11 PCF, Windows FNT, BDF, PFR and Type 42.

   Once it's loaded, you can retrieve three types of information about the font:

   * Global metrics, such as the line spacing
   * Per-glyph metrics, such as bounding box or kerning
   * Pixel representation of glyphs

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
       font = sfml.Font.load_from_file('arial.ttf'))
 
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
