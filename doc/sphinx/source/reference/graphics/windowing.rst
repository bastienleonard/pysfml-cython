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


Windowing
=========


.. class:: RenderWindow([VideoMode mode, title\
                        [, style[, ContextSettings settings]]])

   This class inherits :class:`RenderTarget`.

   This class represents an OS window that can be painted using the other
   graphics-related classes, such as :class:`Sprite` and
   :class:`Text`.

   The constructor creates the window with the size and pixel depth
   defined in *mode*. If specified, *style* must be a value from the
   :class:`Style` class. *settings* is an optional
   :class:`ContextSettings` specifying advanced OpenGL context
   settings such as antialiasing, depth-buffer bits, etc. You
   shouldn't need to use it for a regular usage.

   .. attribute:: active

      Write-only. If true, the window is activated as the current
      target for OpenGL rendering. A window is active only on the
      current thread, if you want to make it active on another thread
      you have to deactivate it on the previous thread first if it was
      active. Only one window can be active on a thread at a time,
      thus the window previously active (if any) automatically gets
      deactivated. If an error occurs, :exc:`PySFMLException` is
      raised.

   .. attribute:: framerate_limit

      Write-only. If set, the window will use a small delay after each
      call to :meth:`display()` to ensure that the current frame
      lasted long enough to match the framerate limit. SFML will try
      to match the given limit as much as it can, but since the
      precision depends on the underlying OS, the results may be a
      little unprecise as well (for example, you can get 65 FPS when
      requesting 60).

   .. attribute:: height

      The height of the rendering region of the window. The height
      doesn't include the titlebar and borders of the window. Unlike
      :attr:`RenderTarget.height`, this property can be modified.

   .. attribute:: joystick_threshold

      Write-only. The joystick threshold is the value below which no
      :attr:`Event.JOYSTICK_MOVED` event will be generated. Default
      value: 0.1.

   .. attribute:: key_repeat_enabled

      Write-only. If key repeat is enabled, you will receive repeated
      :attr:`Event.KEY_PRESSED` events while keeping a key pressed. If
      it is disabled, you will only get a single event when the key is
      pressed. Default value: ``True``.

   .. attribute:: mouse_cursor_visible

      Write-only. Whether or not the mouse cursor is shown. Default
      value: ``True``.

   .. attribute:: open

      Read-only. Whether or not the window exists. Note that a hidden
      window (``visible = False``) is open (so this attribute would be
      ``True``).

   .. attribute:: position

      The position of the window on screen. This attribute only works
      for top-level windows (i.e. it will be ignored for windows
      created from the :attr:`system_handle` of a child
      window/control).

   .. attribute:: settings

      Read-only. The settings of the OpenGL context of the
      window. Note that these settings may be different from what was
      passed when creating the window, if one or more settings were
      not supported. In this case, SFML chooses the closest match.

   .. attribute:: size

      The size of the rendering region of the window. The size doesn't
      include the titlebar and borders of the window. Unlike
      :attr:`RenderTarget.size`, this property can be modified.

   .. attribute:: system_handle

      Return the system handle as a long (or int on Python 3). Windows
      and Mac users will probably need to convert this to another type
      suitable for their system's API. You shouldn't need to use this,
      unless you have very specific stuff to implement that pySFML
      doesn't support, or implement a temporary workaround until a bug
      is fixed. If you need to use it, please contact me and show me
      your use case to see if I can make the API more user-friendly.

   .. attribute:: title

      Write-only. The title of the window.

   .. attribute:: vertical_sync_enabled

      Write-only. Whether or not the vertical synchronization is
      enabled. Activating vertical synchronization will limit the
      number of frames displayed to the refresh rate of the
      monitor. This can avoid some visual artifacts, and limit the
      framerate to a good value (but not constant across different
      computers). Default value: ``False``.

   .. attribute:: visible

      Write-only. Whether or not the window is shown. Default value:
      ``True``.

   .. attribute:: width

      The width of the rendering region of the window. The width
      doesn't include the titlebar and borders of the window. Unlike
      :attr:`RenderTarget.width`, this property can be modified.

   .. classmethod:: from_window_handle(long window_handle\
                                       [, ContextSettings settings])

      Construct the window from an existing control. Use this class
      method if you want to create an SFML rendering area into an
      already existing control. The fourth parameter is an optional
      structure specifying advanced OpenGL context settings such as
      antialiasing, depth-buffer bits, etc. You shouldn't care about
      these parameters for regular usage.

      Equivalent to this C++ constructor::

         RenderWindow(WindowHandle, ContextSettings=ContextSettings())

   .. method:: close()

      Close the window and destroy all the attached resources. After
      calling this function, the instance remains valid and you can
      call :meth:`create` to recreate the window. All other methods
      such as :meth:`poll_event` or :meth:`display` will still work
      (i.e. you don't have to test :attr:`open` every time), and will
      have no effect on closed windows.

   .. method:: create(VideoMode mode, title\
                      [, int style[, ContextSettings settings]])

      Create (or recreate) the window. If the window was already
      created, it closes it first. If *style* contains
      :attr:`Style.FULLSCREEN`, then *mode* must be a valid video
      mode.

   .. method:: display()

      Display on screen what has been rendered to the window so
      far. This function is typically called after all the OpenGL
      rendering has been done for the current frame, in order to show
      it on screen.

   .. method:: iter_events()

      Return an iterator which yields the current pending events. Example::
        
         for event in window.iter_events():
             if event.type == sfml.Event.CLOSED:
                 pass # ...

      The traditional :meth:`poll_event()` method can be used to
      achieve the same effect, but using this iterator makes your life
      easier and is the recommended way to handle events.

   .. method:: poll_event()

      Pop the event on top of events stack, if any, and return
      it. This method is not blocking: if there's no pending event
      then it will return ``None`` and leave the event
      unmodified. Note that more than one event may be present in the
      events stack, thus you should always call this function in a
      loop to make sure that you process every pending event.

      ::

        event = sfml.Event()

        while window.poll_event(event):
           pass # process event...

      .. warning::

         In most cases, you should use :meth:`iter_events` instead, as
         it takes care of creating the event objects for you.

   .. method:: set_icon(int width, int height, str pixels)

      Change the window's icon. *pixels* must be a string in Python 2,
      or a bytes object in Python 3. It should contain width x height
      pixels in 32-bits RGBA format. The OS default icon is used by
      default.

   .. method:: wait_event()

      Wait for an event and return it. This method is blocking: if
      there's no pending event, it will wait until an event is
      received. After this function returns (and no error occured),
      the event object is always valid and filled properly. This
      method is typically used when you have a thread that is
      dedicated to events handling: you want to make this thread sleep
      as long as no new event is received. If an error occurs,
      :exc:`PySFMLException` is raised.

      ::

        event = sfml.Event()

        if window.wait_event(event):
           pass # process event...


.. class:: Style

   This window contains the available window styles, as class
   attributes. See :class:`RenderWindow`.

   Calling the constructor will raise ``NotImplementedError``.

   .. attribute:: CLOSE

      Titlebar + close button.

   .. attribute:: DEFAULT

      Default window style.

   .. attribute:: FULLSCREEN

      Fullscreen mode (this flag and all others are mutually exclusive).

   .. attribute:: NONE

      No border/title bar (this flag and all others are mutually
      exclusive).

   .. attribute:: RESIZE

      Titlebar + resizable border + maximize button.

   .. attribute:: TITLEBAR

      Title bar + fixed border.


.. class:: ContextSettings(int depth=24, int stencil=8, int antialiasing=0,\
                           int major=2, int minor=0)

   Class defining the settings of the OpenGL context attached to a
   window. :class:`ContextSettings` allows to define several advanced
   settings of the OpenGL context attached to a window.

   All these settings have no impact on the regular SFML rendering
   (graphics module), except the anti-aliasing level, so you may need
   to use this structure only if you're using SFML as a windowing
   system for custom OpenGL rendering.

   Please note that these values are only a hint. No failure will be
   reported if one or more of these values are not supported by the
   system; instead, SFML will try to find the closest valid match. You
   can then retrieve the settings that the window actually used to
   create its context, with :attr:`RenderWindow.settings`.

   .. attribute:: antialiasing_level

      Number of multisampling levels for antialiasing.

   .. attribute:: depth_bits

      Bits of the depth buffer.

   .. attribute:: major_version

      Major number of the context version to create. Only versions
      greater or equal to 3.0 are relevant; versions less than 3.0 are
      all handled the same way (i.e. you can use any version < 3.0 if
      you don't want an OpenGL 3 context).

   .. attribute:: minor_version

      Minor number of the context version to create. Only versions
      greater or equal to 3.0 are relevant; versions less than 3.0 are
      all handled the same way (i.e. you can use any version < 3.0 if
      you don't want an OpenGL 3 context).

   .. attribute:: stencil_bits

      Bits of the stencil buffer.


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

   This class overrides the following special methods:

   * Comparison operators (``==``, ``!=``, ``<``, ``>``, ``<=`` and
     ``>=``).
   * ``str(mode)`` returns a description of the mode in a
     ``widthxheightxbpp`` format.
   * ``repr(mode)`` returns a string in a ``VideoMode(width, height,
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

   The constructor creates a default view of (0, 0, 1000, 1000).

   2D camera that defines what region is shown on screen. This is a
   very powerful concept: you can scroll, rotate or zoom the entire
   scene without altering the way that your drawable objects are
   drawn.

   A view is composed of a source rectangle, which defines what part
   of the 2D scene is shown, and a target viewport, which defines
   where the contents of the source rectangle will be displayed on the
   render target (window or texture).

   The viewport allows to map the scene to a custom part of the render
   target, and can be used for split-screen or for displaying a
   minimap, for example. If the source rectangle has not the same size
   as the viewport, its contents will be stretched to fit in.

   To apply a view, you have to assign it to the render target. Then,
   every objects drawn in this render target will be affected by the
   view until you use another view.

   Usage example::

      window = sfml.RenderWindow(sfml.VideoMode(640, 480), 'Title')
 
      # Initialize the view with a rectangle located at (100, 100) and
      # a size of 400x200
      view = sfml.View.from_rect(sfml.FloatRect(100, 100, 400, 200))

      # Rotate it by 45 degrees
      view.rotate(45)

      # Set its target viewport to be half of the window
      view.view_port = sfml.FloatRect(0.0, 0.0, 0.5, 1.0)

      # Apply it
      window.view = view

      # Render stuff
      window.draw(some_sprite)

      # Set the default view back
      window.view = window.default_view

      # Render stuff not affected by the view
      window.draw(some_text)

   .. attribute:: center

      The center of the view, as a tuple. The value can also be set
      from a :class:`Vector2f` object.

   .. attribute:: height

      Shortcut for ``self.size[1]``.

   .. attribute:: rotation

      The orientation of the view, as a float. Default value: 0.0 degree.

   .. attribute:: size

      The size of the view, as a tuple. The value can also be set from
      a :class:`Vector2f` object.

   .. attribute:: viewport

      The target viewport. The viewport is the rectangle into which
      the contents of the view are displayed, expressed as a factor
      (between 0 and 1) of the size of the :class:`RenderTarget` to
      which the view is applied. For example, a view which takes the
      left side of the target would be defined with ``View.viewport =
      sfml.FloatRect(0, 0, 0.5, 1)``. By default, a view has a
      viewport which covers the entire target.

   .. attribute:: width

      Shortcut for ``self.size[0]``.

   .. classmethod:: from_center_and_size(center, size)

      Return a new view created from a center and a size.  *center*
      and *size* can be either tuples or :class:`Vector2f`.

   .. classmethod:: from_rect(rect)

      Return a new view created from a rectangle. *rect* can be a
      tuple or a :class:`FloatRect`.

   .. method:: move(float x, float y)

      Move the view relatively to its current position.

   .. method:: reset(rect)

      Reset the view to the given rectangle. *rect* can be a tuple or
      a :class:`FloatRect`. Note that this function resets the
      rotation angle to 0.

   .. method:: rotate(float angle)

      Rotate the view relatively to its current orientation.

   .. method:: zoom(float factor)

      Resize the view rectangle relatively to its current
      size. Resizing the view simulates a zoom, as the zone displayed
      on screen grows or shrinks. *factor* is a multiplier:

      * 1 keeps the size unchanged.
      * > 1 makes the view bigger (objects appear smaller).
      * < 1 makes the view smaller (objects appear bigger).
