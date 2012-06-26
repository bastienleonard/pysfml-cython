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


Drawing
=======

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

   That's exactly what :class:`Transformable` was written for: it
   hides these variables and the composed transform behind an easy to
   use interface. You can set or get any of the individual components
   without worrying about the others. It also provides the composed
   transform (as a :class:`Transform` object), and keeps it
   up-to-date.

   In addition to the position, rotation and scale,
   :class:`Transformable` provides an "origin" component, which
   represents the local origin of the three other components. Let's
   take an example with a 10x10 pixels sprite. By default, the sprite
   is positionned/rotated/scaled relatively to its top-left corner,
   because it is the local point (0, 0). But if we change the origin
   to be (5, 5), the sprite will be positionned/rotated/scaled around
   its center instead. And if we set the origin to (10, 10), it will
   be transformed around its bottom-right corner.

   To keep the :class:`Transformable` class simple, there's only one
   origin for all the components. You cannot position the sprite
   relatively to its top-left corner while rotating it around its
   center, for example. To do this kind of thing, use
   :class:`Transform` directly.

   :class:`Transformable` can be used as a base class. It is often
   combined with a :ref:`draw() method <graphicsref_custom_drawables>`
   --- that's what SFML's sprites, texts and shapes do::

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

   :class:`RenderTarget` defines the common behaviour of all the 2D
   render targets. It makes it possible to draw 2D entities like
   sprites, shapes, text without using any OpenGL command directly.

   A :class:`RenderTarget` is also able to use views (:class:`View`),
   which are some kind of 2D cameras. With views you can globally
   scroll, rotate or zoom everything that is drawn, without having to
   transform every single entity.

   On top of that, render targets are still able to render direct
   OpenGL stuff. It is even possible to mix together OpenGL calls and
   regular SFML drawing commands. When doing so, make sure that OpenGL
   states are not messed up by calling the
   :meth:`push_gl_states`/:meth:`pop_gl_states` methods.

   .. attribute:: default_view

      Read-only. The default view has the initial size of the render
      target, and never changes after the target has been created.

   .. attribute:: height

      Read-only. The height of the rendering region of the target.

   .. attribute:: size

      Read-only. The size of the rendering region of the target, as a
      tuple.

   .. attribute:: view

      The view is like a 2D camera, it controls which part of the 2D
      scene is visible, and how it is viewed in the render-target. The
      new view will affect everything that is drawn, until another
      view is set. The render target keeps its own copy of the view
      object, so it is not necessary to keep the original one alive
      after calling this function. To restore the original view of the
      target, you can pass the result of :attr:`default_view` to this
      function.

   .. attribute:: width

      Read-only. The width of the rendering region of the target.

   .. method:: clear([color])

      Clear the entire target with a single color. This function is
      usually called once every frame, to clear the previous contents
      of the target. The default is black.

   .. method:: convert_coords(int x, int y[, view=None])

      Convert a point from target coordinates to view
      coordinates. Initially, a unit of the 2D world matches a pixel
      of the render target. But if you define a custom view, this
      assertion is not true anymore, e.g. a point located at (10, 50)
      in your render target (for example a window) may map to the
      point (150, 75) in your 2D world --- for example if the view is
      translated by (140, 25). For render windows, this method is
      typically used to find which point (or object) is located below
      the mouse cursor.

      When the *view* argument isn't provided, the current view of the
      render target is used.

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

   .. method:: get_viewport(view)

      Return the viewport of a view applied to this render target, as
      an :class:`IntRect`. The viewport is defined in the view as a
      ratio, this method simply applies this ratio to the current
      dimensions of the render target to calculate the pixels
      rectangle that the viewport actually covers in the target.

   .. method:: pop_gl_states

      Restore the previously saved OpenGL render states and matrices.
      See :meth:`push_gl_states`.

   .. method:: push_gl_states

      Save the current OpenGL render states and matrices. This method
      can be used when you mix SFML drawing and direct OpenGL
      rendering. Combined with :meth:`pop_gl_states`, it ensures that:

      * SFML's internal states are not messed up by your OpenGL code.
      * Your OpenGL states are not modified by a call to a SFML
        method.

      More specifically, it must be used around code that calls
      ``draw()`` methods. Example::

         # OpenGL code here...
         window.push_gl_states()
         window.draw(...)
         window.draw(...)
         window.pop_gl_states()
         # OpenGL code here...

   Note that this method is quite expensive: it saves all the possible
   OpenGL states and matrices, even the ones you don't care
   about. Therefore it should be used wisely. It is provided for
   convenience, but the best results will be achieved if you handle
   OpenGL states yourself (because you know which states have really
   changed, and need to be saved and restored). Take a look at the
   :meth:`reset_gl_states` method if you do so.

   .. method:: reset_gl_states

      Reset the internal OpenGL states so that the target is ready for
      drawing. This function can be used when you mix SFML drawing and
      direct OpenGL rendering, if you choose not to use
      :meth:`push_gl_states`/:meth:`pop_gl_states`. It ensures that
      all OpenGL states needed by SFML are set, so that subsequent
      draw() calls will work as expected.

      Example::

         # OpenGL code here...
         glPushAttrib(...)
         window.reset_gl_states()
         window.draw(...)
         window.draw(...)
         glPopAttrib(...)
         # OpenGL code here...


.. class:: Transform([float a00, float a01, float a02,\
                     float a10, float a11, float a12,\
                     float a20, float a21, float a22])

   If called with no arguments, the value is set to the
   :attr:`IDENTITY` transform.

   A :class:`Transform` is a 3x3 transform matrix that specifies how
   to translate, rotate, scale, shear, project, etc. In mathematical
   terms, it defines how to transform a coordinate system into
   another.

   For example, if you apply a rotation transform to a sprite, the
   result will be a rotated sprite. And anything that is transformed
   by this rotation transform will be rotated the same way, according
   to its initial position.

   Transforms are typically used for drawing. But they can also be
   used for any computation that requires to transform points between
   the local and global coordinate systems of an entity (like
   collision detection).

   Example::

      # Define a translation transform
      translation = sfml.Transform()
      translation.translate(20, 50)

      # Define a rotation transform
      rotation = sf.Transform()
      rotation.rotate(45)

      # Combine them
      transform = translation * rotation

      # Use the result to transform stuff...
      point = transform.transform_point(10, 20)
      rect = transform.transform_rect(sfml.FloatRect(0, 0, 10, 100))

   This class provides the following special methods:

   * ``*`` and ``*=`` operators.
   * ``str()`` returns the content of the matrix in a human-readable format.

   .. attribute:: IDENTITY

      Class attribute containing the identity matrix.

   .. attribute:: matrix

      Read-only. a list of 16 floats containing the transform elements
      as a 4x4 matrix, which is directly compatible with OpenGL
      functions.

   .. method:: combine(transform)

      Combine the current transform with *transform*. The result is a
      transform that is equivalent to applying this followed by
      transform. Mathematically, it is equivalent to a matrix
      multiplication.

   .. method:: copy()

      Return a new transform object with the same content as self.

   .. method:: get_inverse()

      Return the inverse of the transform. If the inverse cannot be
      computed, an :attr:`IDENTITY` transform is returned.

   .. method:: rotate(float angle[, float center_x, float center_y])

      Combine the current transform with a rotation. This method
      returns self, so calls can be chained::

         transform = sfml.Transform()
         transform.rotate(90).translate(50, 20)

      The center of rotation can be provided with *center_x* and
      *center_y*, so that you can build rotations around arbitrary
      points more easily (and efficiently) than the usual
      ``translate(-center).rotate(angle).translate(center)``.

   .. method:: scale(float scale_x, float scale_y[, float, center_x,\
                     float center_y])

      Combine the current transform with a scaling. The center of
      scaling can be provided with *center_x* and *center_y*, so that
      you can build scaling around arbitrary points more easily (and
      efficiently) than the usual
      ``translate(-center).scale(factors).translate(center)``.

      This method returns self, so calls can be chained::

         transform = sfml.Transform()
         transform.scale(2, 1, 8, 3).rotate(45)


   .. method:: transform_point(float x, float y)

      Transform the point and return it as a tuple.

   .. method:: transform_rect(FloatRect rectangle)

      Transform a rectangle and return it as a
      :class:`FloatRect`. Since SFML doesn't provide support for
      oriented rectangles, the result of this function is always an
      axis-aligned rectangle. Which means that if the transform
      contains a rotation, the bounding rectangle of the transformed
      rectangle is returned.

   .. method:: translate(float x, float y)

      Combine the current transform with a translation. This method
      returns self, so calls can be chained::

         transform = sfml.Transform()
         transform.translate(100, 200).rotate(45)


.. class:: RenderStates(blend_mode=-1, shader=None, texture=None,\
                        transform=None)

   The constructor first creates a default RenderStates object, then
   sets its attributes with respect to the provided
   arguments. Constructing a default set of render states is
   equivalent to using :attr:`RenderStates.DEFAULT`. The default set
   defines

   * the :attr:`BLEND_ALPHA` blend mode,
   * the :attr:`Transform.IDENTITY` transform,
   * no texture (``None``),
   * no shader (``None``).

   Contains the states used for drawing to a
   :class:`RenderTarget`. There are four global states that can be
   applied to the drawn objects:

   * The blend mode: how pixels of the object are blended with the
     background.
   * The transform: how the object is positioned/rotated/scaled.
   * The texture: which image is mapped to the object.
   * The shader: which custom effect is applied to the object.

   High-level objects such as sprites or text force some of these
   states when they are drawn. For example, a sprite will set its own
   texture, so that you don't have to care about it when drawing the
   sprite.

   The transform is a special case: sprites, texts and shapes (and
   it's a good idea to do it with your own drawable classes too)
   combine their transform with the one that is passed in the
   RenderStates structure. So that you can use a "global" transform on
   top of each object's transform.

   Most objects, especially high-level drawables, can be drawn
   directly without defining render states explicitely --- the default
   set of states is ok in most cases::

      window.draw(sprite)

   If you just want to specify a shader, you can pass it directly to
   the :meth:`RenderTarget.draw` method::

      window.draw(sprite, shader)

   Note that unlike in C++ SFML, this only works for shaders and not
   for other render states. This is because adding other possibilities
   means writing a lot of boilerplate code in the binding, and shader
   seemed to be most used state when writing this method.

   When you're inside the draw method of a drawable object, you can
   either pass the render states unmodified, or change some of
   them. For example, a transformable object will combine the current
   transform with its own transform. A sprite will set its
   texture. Etc.

   .. attribute:: DEFAULT

      A RenderStates object with the default values, as a class
      attribute.

   .. attribute:: blend_mode

      See :ref:`blend_modes` for a list of the valid values.

   .. attribute:: shader

      A :class:`Shader` object.

   .. attribute:: texture

      A :class:`Texture` object.

   .. attribute:: transform

      A :class:`Transform` object.


.. class:: Shape

   This abstract class inherits :class:`Transformable`.

   :class:`Shape` is a drawable class that allows to define and
   display a custom convex shape on a render target.

   Every shape has the following attributes:

   * a texture,
   * a texture rectangle,
   * a fill color,
   * an outline color,
   * an outline thickness.

   Each feature is optional, and can be disabled easily:

   * the texture can be ``None``,
   * the fill/outline colors can be :attr:`Color.TRANSPARENT`,
   * the outline thickness can be zero.

   You can write your own derived shape class, there are only two
   methods to override:

   * :meth:`get_point_count` must return the number of points of the
     shape,
   * :meth:`get_point` must return the points of the shape.

   A few concrete shapes are provided: :class:`RectangleShape`,
   :class:`CircleShape` and \ :class:`ConvexShape`.

   .. attribute:: fill_color

      The fill color of the shape. This color is modulated
      (multiplied) with the shape's texture if any. It can be used to
      colorize the shape, or change its global opacity. You can use
      :attr:`Color.TRANSPARENT` to make the inside of the shape
      transparent, and have the outline alone. By default, the shape's
      fill color is opaque white.

   .. attribute:: global_bounds

      Read-only. The global bounding rectangle of the entity, as a
      :class:`FloatRect`. The returned rectangle is in global
      coordinates, which means that it takes in account the
      transformations (translation, rotation, scale, ...) that are
      applied to the entity. In other words, this function returns the
      bounds of the sprite in the global 2D world's coordinate system.

   .. attribute:: local_bounds

      Read-only. The local bounding rectangle of the entity, as a
      :class:`FloatRect`. The returned rectangle is in local
      coordinates, which means that it ignores the transformations
      (translation, rotation, scale, ...) that are applied to the
      entity. In other words, this function returns the bounds of the
      entity in the entity's coordinate system.

   .. attribute:: texture

      The source texture of the shape. Can be ``None`` to disable
      texturing. Also see :meth:`set_texture`, which allows you to
      update :attr:`texture_rect` automatically.

   .. attribute:: texture_rect

      The sub-rectangle of the texture that the shape will
      display. The texture rect is useful when you only want to
      display a part of the texture. By default, the texture rect
      covers the entire texture.

   .. attribute:: outline_color

      The outline color of the shape. You can use
      :attr:`Color.TRANSPARENT` to disable the outline. By default,
      the shape's outline color is opaque white.

   .. attribute:: outline_thickness

      The thickness of the shape's outline, as a float. This number
      cannot be negative. Using zero disables the outline. By default,
      the outline thickness is 0.0.

   .. method:: get_point(int index)

      This method should be overriden to return a tuple or a
      :class:`Vector2f` containing the coordinates at the position
      *index*.

   .. method:: get_point_count()

      This method should be overriden to return the number of points,
      as an integer.

   .. method:: set_texture(texture[, reset_rect=False])

      Set the source texture of the shape. *texture* can be ``None``
      to disable texturing. If *reset_rect* is true, the
      :attr:`texture_rect` property of the shape is automatically
      adjusted to the size of the new texture. If it is false, the
      texture rect is left unchanged.

      Calling this method does the same thing as modifiying the
      :attr:`texture` attribute, except when the *reset_rect*
      parameter is used.

   .. method:: update()

      Recompute the internal geometry of the shape. This method must
      be called by the derived class everytime the shape's points
      change (i.e. the result of either :meth:`get_point_count` or
      :meth:`get_point` is different). This includes when the shape
      object is created.

      If you call this method from a built-in shape, it will raise
      ``NotImplementedError``.


.. class:: RectangleShape([size])

   This class inherits :class:`Shape`. *size* can be either a tuple or
   a :class:`Vector2f`.

   Usage example::

      rectangle = sfml.RectangleShape((100, 50))
      rectangle.outline_color = sfml.Color.RED
      rectangle.outline_thickness = 5
      rectangle.position = (10, 20)
      # ...
      window.draw(rectangle)

   .. attribute:: size

      The size of the rectangle, as a tuple. The value can also be set
      from a :class:`Vector2f`.


.. class:: CircleShape([float radius[, int point_count]])

   This class inherits :class:`Shape`.

   Usage example::

      circle = sfml.CircleShape(150)
      circle.outline_color = sfml.Color.Red
      circle.outline_thickness = 5
      circle.position = (10, 20)
      # ...
      window.draw(circle)

   Since the graphics card can't draw perfect circles, we have to fake
   them with multiple triangles connected to each other. The
   :attr:`point_count` property defines how many of these triangles to
   use, and therefore defines the quality of the circle.

   The number of points can also be used for another purpose; with
   small numbers you can create any regular polygon shape: equilateral
   triangle, square, pentagon, hexagon, ...

   .. attribute:: point_count

      The number of points in the circle.

   .. attribute:: radius

      The radius of the circle, as a float.


.. class:: ConvexShape([int point_count])

   This class inherits :class:`Shape`.

   Specialized shape representing a convex polygon.

   It is important to keep in mind that a convex shape must always
   be... convex, otherwise it may not be drawn correctly. Moreover,
   the points must be defined in order; using a random order would
   result in an incorrect shape.

   Usage example::

      polygon = sfml.ConvexShape(3)
      polygon.set_point(0, (0, 0))
      polygon.set_point(1, (0, 10))
      polygon.set_point(2, (25, 5))
      polygon.outline_color = sfml.Color.RED
      polygon.outline_thickness = 5
      polygon.position = (10, 20)
      # ...
      window.draw(polygon)

   .. method:: get_point(int index)

      Return the position of a point. The result is undefined if
      *index* is out of the valid range.

   .. method:: get_point_count

      Return the number of points of the polygon.

   .. method:: set_point(int index, point)

      Set the position of a point. Don't forget that the polygon must
      remain convex, and the points need to stay ordered!
      :meth:`set_point_count` must be called first in order to set the
      total number of points. The result is undefined if index is out
      of the valid range.

      *point* may be either a tuple or a :class:`Vector2f`.

   .. method:: set_point_count(int count)

      Set the number of points of the polygon. *count* must be greater
      than 2 to define a valid shape.


.. class:: Image(int width, int height[, color])

   :class:`Image` is an abstraction to manipulate images as
   bidimensional arrays of pixels. It allows you to load, manipulate
   and save images.

   The constructor create images of the specified size, filled with a
   color. For loading images, you should use one of the class
   methods. :meth:`load_from_file` is the most common one.

   :class:`Image` can handle a unique internal representation of
   pixels, which is RGBA 32 bits. This means that a pixel must be
   composed of 8 bits red, green, blue and alpha channels --- just
   like a :class:`Color`. All the functions that return an array of
   pixels follow this rule, and all parameters that you pass to
   :class:`Image` methods (such as :meth:`load_from_pixels`) must use
   this representation as well.

   An image can be copied, but you should note that it's a heavy
   resource.

   Usage example::

      # Load an image file from a file
      background = sfml.Image.load_from_file('background.jpg')

      # Create a 20x20 image filled with black color
      image = sfml.Image(20, 20, sfml.Color.BLACK)

      # Copy image1 on image2 at position (10, 10)
      image.copy(background, 10, 10)

      # Make the top-left pixel transparent
      color = image[0,0]
      color.a = 0
      image[0,0] = color

      # Save the image to a file
      image.save_to_file('result.png')

   This class provides the following special methods:

   * ``image[tuple]`` returns a pixel from the image, as a
     :class:`Color` object. Equivalent to
     :meth:`get_pixel()`. Example::

         print image[0,0]  # Create tuple implicitly
         print image[(0,0)]  # Create tuple explicitly
   * ``image[tuple] = color`` sets a pixel of the image to a
     :class:`Color` object value. Equivalent to
     :meth:`set_pixel()`. Example::

         image[0,0] = sfml.Color(10, 20, 30)  # Create tuple implicitly
         image[(0,0)] = sfml.Color(10, 20, 30)  # Create tuple explicitly

   .. attribute:: height

      Read-only. The height of the image.

   .. attribute:: size

      Read-only. The size of the image, as a tuple.

   .. attribute:: width

      Read-only. The width of the image.

   .. classmethod:: load_from_file(filename)

      Load the image from *filename* on disk and return a new
      :class:`Image` object. The supported image formats are bmp, png,
      tga, jpg, gif, psd, hdr and pic. Some format options are not
      supported, like progressive jpeg.

      :exc:`PySFMLException` is raised if loading fails.

   .. classmethod:: load_from_memory(bytes mem)

      Load the image from a file in memory. The supported image
      formats are bmp, png, tga, jpg, gif, psd, hdr and pic. Some
      format options are not supported, like progressive jpeg.

      :exc:`PySFMLException` is raised if loading fails.

   .. classmethod:: load_from_pixels(int width, int height, bytes pixels)

      Return a new image, created from a str/bytes object of
      pixels. *pixels* is assumed to contain 32-bits RGBA pixels, and
      have the given *width* and *height*. If not, the behavior is
      undefined. If *pixels* is ``None``, an empty image is created.

   .. method:: copy(Image source, int dest_x, int dest_y\
                    [, source_rect, apply_alpha])

      Copy pixels from another image onto this one. This method does a
      slow pixel copy and should not be used intensively. It can be
      used to prepare a complex static image from several others, but
      if you need this kind of feature in real-time you'd better use
      :class:`RenderTexture`.

      Without *source_rect*, the whole image is copied. *source_rect*
      can be either an :class:`IntRect` or a tuple.

      If *apply_alpha* is provided, the transparency of *source*'s
      pixels is applied. If it isn't, the pixels are copied unchanged
      with their alpha value.

   .. method:: create_mask_from_color(color, int alpha)

      Create a transparency mask from a specified color-key. This
      method sets the alpha value of every pixel matching the given
      color to *alpha* (0 by default), so that they become
      transparent.

   .. method:: flip_horizontally

      Flip the image horizontally (left <-> right).

   .. method:: flip_vertically

      Flip the image vertically (top <-> bottom).

   .. method:: get_pixel(int x, int y)

      Return the color of the pixel at *(x, y)*.

      ``IndexError`` is raised if the pixel is out of range.

   .. method:: get_pixels()

      Return a str (in Python 2) or a bytes (Python 3) object to the
      pixels. The returned value points to an array of RGBA pixels
      made of 8 bits integers components. The size of the object is
      :attr:`width` * :attr:`height` * 4. If the image is empty,
      ``None`` is returned.

   .. method:: save_to_file(filename)

      Save the image to a file on disk. The format of the image is
      automatically deduced from the extension. The supported image
      formats are bmp, png, tga and jpg. The destination file is
      overwritten if it already exists. This method fails if the image
      is empty.

      :exc:`PySFMLException` is raised if saving fails.

   .. method:: set_pixel(int x, int y, color)

      Set the color of the pixel at *(x, y)* to *color*. This method
      doesn't check the validity of the pixel coordinates, using
      out-of-range values will result in an undefined behaviour.

      ``IndexError`` is raised if the pixel is out of range.


.. class:: Texture([int width[, int height]])

   The constructor serves the same purpose as ``Texture.create()`` in
   C++ SFML. It raises :exc:`PySFMLException` if texture creation fails.

   :class:`Image` living on the graphics card that can be used for
   drawing. A texture lives in the graphics card memory, therefore it
   is very fast to draw a texture to a render target, or copy a render
   target to a texture (the graphics card can access both directly).

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

   .. attribute:: NORMALIZED

      Constant for the type of texture coordinates where the range is
      [0 .. 1], as a class attribute.

   .. attribute:: PIXELS

      Constant for the type of texture coordinates where the range is
      [0 .. size], as a class attribute.

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

      :exc:`PySFMLException` is raised if loading fails.

   .. classmethod:: load_from_image(image[, area])

      Load the texture from an image.

      *area*, if specified, may be either a tuple or an
      :class:`IntRect`. Then only a sub-rectangle of the whole image
      will be loaded. If the area rectangle crosses the bounds of the
      image, it is adjusted to fit the image size.

      The maximum size for a texture depends on the graphics driver
      and is accessible with the :attr:`MAXIMUM_SIZE` class attribute.

      :exc:`PySFMLException` is raised if loading fails.

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

   .. method:: bind([int coordinate_type])

      Activate the texture for rendering. This method is mainly used
      internally by the SFML rendering system. However it can be
      useful when using :class:`Texture` with OpenGL code (this method
      is equivalent to ``glBindTexture()``).

      *coordinate_type* controls how texture coordinates will be
      interpreted. If :attr:`NORMALIZED` (the default), they must be
      in range [0 .. 1], which is the default way of handling texture
      coordinates with OpenGL. If :attr:`PIXELS`, they must be given
      in pixels (range [0 .. size]). This mode is used internally by
      the graphics classes of SFML, it makes the definition of texture
      coordinates more intuitive for the high-level API, users don't
      need to compute normalized values.

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
      rect covers the entire texture. *rect* may be an
      :class:`IntRect` or a tuple.


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

      True if the system supports shaders. You shoul always test this
      class attribute before using the shader features. If it is
      false, then any attempt to use :class:`Shader` will fail.

   .. attribute:: CURRENT_TEXTURE

      Special type/value that can be passed to :meth:`set_parameter`,
      and that represents the texture of the object being drawn.

   .. attribute:: FRAGMENT

      Fragment (pixel) shader type, as an int class attribute.

   .. attribute:: VERTEX

      Vertex shader type, as an int class attribute.

   .. classmethod:: load_both_types_from_file(str vertex_shader_filename,\
                                              str fragment_shader_filename)

      Load both the vertex and the fragment shaders. If one of them
      fails to load, the shader is left empty (the valid shader is
      unloaded). The sources must be text files containing valid
      shaders in GLSL language. GLSL is a C-like language dedicated to
      OpenGL shaders; you'll probably need to read a good
      documentation for it before writing your own shaders.

      If an error occurs, :exc:`PySFMLException` is raised.

   .. classmethod:: load_both_types_from_memory(str vertex_shader,\
                                                str fragment_shader)

      Load both the vertex and the fragment shaders. If one of them
      fails to load, the shader is left empty (the valid shader is
      unloaded). The sources must be valid shaders in GLSL
      language. GLSL is a C-like language dedicated to OpenGL shaders;
      you'll probably need to read a good documentation for it before
      writing your own shaders.

      If an error occurs, :exc:`PySFMLException` is raised.

   .. classmethod:: load_from_file(filename, int type)

      Load a single shader, either vertex or fragment, identified by
      the *type* parameter, which must be :attr:`Shader.FRAGMENT` or
      :attr:`Shader.VERTEX`. The source must be a text file containing
      a valid shader in GLSL language. GLSL is a C-like language
      dedicated to OpenGL shaders; you'll probably need to read a good
      documentation for it before writing your own shaders.

      If an error occurs, :exc:`PySFMLException` is raised.

   .. classmethod:: load_from_memory(str shader, int type)

      Load a single shader, either vertex or fragment, identified by
      the *type* argument, which must be :attr:`Shader.FRAGMENT` or
      :attr:`Shader.VERTEX`. The source code must be a valid shader in
      GLSL language. GLSL is a C-like language dedicated to OpenGL
      shaders; you'll probably need to read a good documentation for
      it before writing your own shaders.

   .. method:: bind()

      Bind the shader for rendering (activate it). This method is
      normally for internal use only, unless you want to use the
      shader with a custom OpenGL rendering instead of a SFML
      drawable::

         window.active = True
         shader.bind()
         # ... render OpenGL geometry ...
         shader.unbind()

   .. method:: set_parameter(str name, ...)

      Set a shader parameter.

      The first parameter, *name*, is the name of the variable to
      change in the shader. After *name*, you can pass an argument or
      several floats, depending on your need:

      * 1 float,
      * 2 floats,
      * 3 floats,
      * 4 floats,
      * a color,
      * a transform,
      * a texture.

      If you want to pass the texture of the object being drawn, which
      cannot be known in advance, you can pass the special value
      :attr:`CURRENT_TEXTURE`::

         shader.set_parameter('the_texture', sfml.Shader.CURRENT_TEXTURE)

   .. method:: unbind()

      Unbind the shader (deactivate it). This method is normally for
      internal use only, unless you want to use the shader with a
      custom OpenGL rendering instead of a SFML drawable.


.. class:: RenderTexture(int width, int height[, bool depth=False])

   This class inherits :class:`RenderTarget`.

   Target for off-screen 2D rendering into an
   texture. :class:`RenderTexture` is the little brother of
   :class:`RenderWindow`.

   It implements the same 2D drawing and OpenGL-related functions (see
   their base class :class:`RenderTarget` for more details), the
   difference is that the result is stored in an off-screen texture
   rather than being show in a window.

   Rendering to a texture can be useful in a variety of situations:

   * Precomputing a complex static texture (like a level's background
     from multiple tiles).
   * Applying post-effects to the whole scene with shaders.
   * Creating a sprite from a 3D object rendered with OpenGL.
   * Etc.

   Usage example::

      # Create a new render-window
      window = sfml.RenderWindow(sf.VideoMode(800, 600), 'pySFML window')

      # Create a new render texture
      render_texture = sfml.RenderTexture(500, 500)

      # The main loop
      while window.open:
         # Event processing
         # ...

         # Clear the whole texture with red color
         render_texture.clear(sfml.Color.RED)

         # Draw stuff to the texture
         render_texture.draw(sprite)  # sprite is a Sprite
         render_texture.draw(shape)   # shape is a Shape
         render_texture.draw(text)    # text is a Text

         # We're done drawing to the texture
         render_texture.display()

         # Now we start rendering to the window, clear it first
         window.clear()

         # Draw the texture
         sprite = sfml.Sprite(render_texture.texture)
         window.draw(sprite);

         # End the current frame and display its contents on screen
         window.display()

   .. attribute:: active

      Write-only. If true, the render texture's context becomes
      current for future OpenGL rendering operations (so you shouldn't
      care about it if you're not doing direct OpenGL stuff). Only one
      context can be current in a thread, so if you want to draw
      OpenGL geometry to another render target (like a
      :class:`RenderWindow`), don't forget to activate it again. If an
      error occurs, :exc:`PySFMLException` is raised.

   .. attribute:: texture

      Read-only.The target texture, as a :class:`Texture`. After
      drawing to the render-texture and calling :meth:`display`, you
      can retrieve the updated texture using this function, and draw
      it using a sprite (for example).

      .. warning::

         Textures obtained with this property should never be
         modified. The object itself is a normal :class:`Texture`
         object, but the underlying C++ object is specified as
         ``const`` and a C++ compiler wouldn't let you attempt to
         modify it.

   .. attribute:: smooth

      Whether the smooth filtering is enabled or not. Default value:
      ``False``.

   .. method:: display()

      Update the contents of the target texture. This method updates
      the target texture with what has been drawn so far. Like for
      windows, calling this function is mandatory at the end of
      rendering. Not calling it may leave the texture in an undefined
      state.


.. class:: Vertex([position[, color[, tex_coords]]])

   A vertex is an improved point. It has a position and other extra
   attributes that will be used for drawing: a color and a pair of
   texture coordinates.

   The vertex is the building block of drawing. Everything which is
   visible on screen is made of vertices. They are grouped as 2D
   primitives (triangles, quads, ... see :ref:`blend_modes`), and
   these primitives are grouped to create even more complex 2D
   entities such as sprites, texts, etc.

   If you use the graphical entities of SFML (:class:`Sprite`,
   :class:`Text`, :class:`Shape`) you won't have to deal with vertices
   directly. But if you want to define your own 2D entities, such as
   tiled maps or particle systems, using vertices will allow you to
   get maximum performances.

   This class provides the following special methods:

   * ``repr(vertex)`` returns a description in format
     ``Vertex(position, color, tex_coords``.

   Example::

      # define a 100x100 square, red, with a 10x10 texture mapped on it
      vertices = [sfml.Vertex((0, 0), sfml.Color.RED, (0, 0)),
                  sfml.Vertex((0, 100), sfml.Color.RED, (0, 10)),
                  sfml.Vertex((100, 100), sfml.Color.RED, (10, 10)),
                  sfml.Vertex((100, 0), sfml.Color.RED, (10, 0))]

      # draw it
      window.draw(vertices, sfml.QUADS)

   Note: although texture coordinates are supposed to be an integer
   amount of pixels, their type is float because of some buggy
   graphics drivers that are not able to process integer coordinates
   correctly.

   .. attribute:: color

      :class:`Color` of the vertex.

   .. attribute:: position

      2D position of the vertex. The value is always retrieved as a
      tuple. It can be set as a tuple or a :class:`Vector2f`.

   .. attribute:: tex_coords

      Coordinates of the texture's pixel map to the vertex. The value
      is always retrieved as a tuple. It can be set as a tuple or a
      :class:`Vector2f`.

   .. method:: copy

      Return a new vertex with the same value as self.
