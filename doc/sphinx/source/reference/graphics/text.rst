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


Text
====


.. class:: Font

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


.. class:: Glyph

   A glyph is the visual representation of a character. :class:`Glyph`
   structure provides the information needed to handle the glyph:

   * its coordinates in the font's texture,
   * its bounding rectangle,
   * the offset to apply to get the starting position of the next
     glyph.

   .. attribute:: advance

      Offset to move horizontically to the next character.

   .. attribute:: bounds

      Bounding rectangle of the glyph as an :class:`IntRect`, in
      coordinates relative to the baseline.

   .. attribute:: texture_rect

      Texture coordinates of the glyph inside the font's texture, as
      an :class:`IntRect`.


.. class:: Text([string, font, character_size=0])

   This class inherits :class:`Transformable`.

   *string* can be a bytes/str/unicode object. SFML will internally
   store characters as 32-bit integers. A bytes object (str in Python
   2) will end up being interpreted by SFML as an "ANSI string"
   (cp1252 encoding). A unicode object (str in Python 3) will be
   interpreted as 32-bit code points.

   :class:`Text` is a drawable class that allows to easily display
   some text with custom style and color on a render target.

   It inherits all the functions from :class:`Transformable`:
   position, rotation, scale, origin. It also adds text-specific
   properties such as the font to use, the character size, the font
   style (bold, italic, underlined), the global color and the text to
   display of course. It also provides convenience functions to
   calculate the graphical size of the text, or to get the global
   position of a given character.

   :class:`Text` works in combination with the :class:`Font` class,
   which loads and provides the glyphs (visual characters) of a given
   font. The separation of :class:`Font` and :class:`Text` allows more
   flexibility and better performances: a :class:`Font` is a heavy
   resource, and any operation on it is slow (often too slow for
   real-time applications). On the other hand, a :class:`Text` is a
   lightweight object which can combine the glyphs data and metrics of
   a :class:`Font` to display any text on a render target.

   Usage example::

      # Declare and load a font
      font = sfml.Font.loadFromFile('arial.ttf')
 
      # Create a text
      text = sfml.Text('hello')
      text.font = font
      text.character_size = 30
      text.style = sfml.Text.BOLD
      text.color = sfml.Color.RED

      # Draw it
      window.draw(text)

   Note that you don't need to load a font to draw text, SFML comes
   with a built-in font that is implicitely used by default.

   .. attribute:: character_size

      The size of the characters, pixels. The default size is 30.

   .. attribute:: color

      The global color of the text. The default color is opaque white.

   .. attribute:: font

      The text's font. The default font is :attr:`Font.DEFAULT_FONT`.

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

      Return the position of the *index*-th character. This method
      computes the visual position of a character from its index in
      the string. The returned position is in global coordinates
      (translation, rotation, scale and origin are applied). If
      *index* is out of range, the position of the end of the string
      is returned.
