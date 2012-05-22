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


Events
======


.. module:: sfml


.. _event_types_reference:

Event types reference
^^^^^^^^^^^^^^^^^^^^^

============================================================================= ===================================================== ==========
Type                                                                          Attributes                                            Remarks
============================================================================= ===================================================== ==========
:attr:`Event.CLOSED`                                                                                                                In fullscreen, Alt + F4 won't send the ``CLOSED`` event (on GNU/Linux, at least).
:attr:`Event.RESIZED`                                                         ``width``, ``height``
:attr:`Event.LOST_FOCUS`
:attr:`Event.GAINED_FOCUS`
:attr:`Event.TEXT_ENTERED`                                                    ``unicode``                                           The attribute lets you retrieve the character entered by the user, as a Unicode string.
:attr:`Event.KEY_PRESSED`, :attr:`Event.KEY_RELEASED`                         ``code``, ``alt``, ``control``, ``shift``, ``system`` ``code`` is the code of the key that was pressed/released, the other attributes are booleans and tell you if the alt/control/shit/system modifier was pressed.
:attr:`Event.MOUSE_WHEEL_MOVED`                                               ``delta``, ``x``, ``y``                               The attribute contains the mouse wheel move (positive if forward, negative if backward).
:attr:`Event.MOUSE_BUTTON_PRESSED`, :attr:`Event.MOUSE_BUTTON_RELEASED`       ``button``, ``x``, ``y``                              See the :class:`Mouse` class for the button codes.
:attr:`Event.MOUSE_MOVED`                                                     ``x``, ``y``
:attr:`Event.MOUSE_ENTERED`
:attr:`Event.MOUSE_LEFT`
:attr:`Event.JOYSTICK_BUTTON_PRESSED`, :attr:`Event.JOYSTICK_BUTTON_RELEASED` ``joystick_id``, ``button``                           ``button`` is a number between 0 and :attr:`Joystick.BUTTON_COUNT`- 1.
:attr:`Event.JOYSTICK_MOVED`                                                  ``joystick_id``, ``axis``, ``position``               See the :class:`Joystick` class for the axis codes.
:attr:`Event.JOYSTICK_CONNECTED`, :attr:`Event.JOYSTICK_DISCONNECTED`         ``joystick_id``
============================================================================= ===================================================== ==========



.. class:: Event

   This class behaves differently from the C++ ``sf::Event`` class.
   Every Event object will always only feature the attributes that
   actually make sense regarding the event type.  This means that
   there is no need for the C++ union; you just access whatever
   attribute you want.

   For example, this is the kind of code you'd write in C++::

      if (event.Type == sf::Event::KeyPressed &&
          event.Key.Code == sf::Keyboard::Escape)
      {
          // ...
      }

   In Python, it becomes::

      if event.type == sfml.Event.KEY_PRESSED and event.code == sfml.Keyboard.ESCAPE:
          # ...

   .. attribute:: NAMES

      A class attribute that maps event codes to a short description::

         >>> sfml.Event.NAMES[sfml.Event.CLOSED]
         'Closed'
         >>> sfml.Event.NAMES[sfml.Event.KEY_PRESSED]
         'Key pressed'

      If you want to print this information about a specific object,
      you can simply use ``print``; ``Event.__str__()`` will look up
      the description for you.

   Event types:

   .. attribute:: CLOSED

      The window requested to be closed.

   .. attribute:: RESIZED

      The window was resized.

   .. attribute:: LOST_FOCUS

      The window lost focus.

   .. attribute:: GAINED_FOCUS

      The window gained focus.

   .. attribute:: TEXT_ENTERED

      A character was entered.

   .. attribute:: KEY_PRESSED

      A key was pressed.

   .. attribute:: KEY_RELEASED

      A key was released.

   .. attribute:: MOUSE_WHEEL_MOVED

      The mouse wheel was scrolled.

   .. attribute:: MOUSE_BUTTON_PRESSED

      A mouse button was pressed.

   .. attribute:: MOUSE_BUTTON_RELEASED

      A mouse button was released.

   .. attribute:: MOUSE_MOVED

      The mouse cursors moved.

   .. attribute:: MOUSE_ENTERED

      The mouse cursor entered the area of the window.

   .. attribute:: MOUSE_LEFT

      The mouse cursor entered the area of the window.

   .. attribute:: JOYSTICK_BUTTON_PRESSED

      A joystick button was pressed.

   .. attribute:: JOYSTICK_BUTTON_RELEASED

      A joystick button was released.

   .. attribute:: JOYSTICK_MOVED

      The joystick moved along an axis.

   .. attribute:: JOYSTICK_CONNECTED

      A joystick was connected.

   .. attribute:: JOYSTICK_DISCONNECTED

      A joystick was disconnected.



.. class:: Joystick

   This class gives access to the real-time state of the joysticks.

   It only contains static functions, so it's not meant to be
   instanciated. Instead, each joystick is identified by an index that
   is passed to the functions of this class.

   This class allows users to query the state of joysticks at any time
   and directly, without having to deal with a window and its
   events. Compared to the :attr:`Event.JOYSTICK_MOVED`,
   :attr:`Event.JOYSTICK_BUTTON_PRESSED` and
   :attr:`Event.JOYSTICK_BUTTON_RELEASED` events, this class can
   retrieve the state of axes and buttons of joysticks at any time
   (you don't need to store and update a boolean on your side in order
   to know if a button is pressed or released), and you always get the
   real state of joysticks, even if they are moved, pressed or
   released when your window is out of focus and no event is
   triggered.

   SFML supports:

   * 8 joysticks (:attr:`COUNT`)
   * 32 buttons per joystick (:attr:`BUTTON_COUNT`)
   * 8 axes per joystick (:attr:`AXIS_COUNT`)

   Unlike the keyboard or mouse, the state of joysticks is sometimes
   not directly available (depending on the OS), so the :meth:`update`
   method must be called in order to update the current state of
   joysticks. When you have a window with event handling, this is done
   automatically, you don't need to call anything. But if you have no
   window, or if you want to check joysticks state before creating
   one, you must call :meth:`update` explicitely.

   Usage example::

      # Is joystick #0 connected?
      connected = sfml.Joystick.is_connected(0)

      # How many buttons does joystick #0 support?
      buttons = sfml.Joystick.get_button_count(0)

      # Does joystick #0 define a X axis?
      has_x = sfml.Joystick.has_axis(0, sfml.Joystick.X)

      # Is button #2 pressed on joystick #0?
      pressed = sfml.Joystick.is_button_pressed(0, 2)

      # What's the current position of the Y axis on joystick #0?
      position = sfml.Joystick.get_axis_position(0, sfml.Joystick.Y)

   .. attribute:: COUNT

      The maximum number of supported joysticks.      

   .. attribute:: BUTTON_COUNT

      The maximum number of supported buttons.

   .. attribute:: AXIS_COUNT

      The maximum number of supported axes.

   .. _refevents_axescodes:

   Axes codes:

   .. attribute:: X

      The *x* axis.

   .. attribute:: Y

      The *y* axis.

   .. attribute:: Z

      The *z* axis.

   .. attribute:: R

      The *r* axis.

   .. attribute:: U

      The *u* axis.

   .. attribute:: V

      The *v* axis.


   .. attribute:: POV_X

      The *x* axis of the point-of-view hat.

   .. attribute:: POV_Y

      The *y* axis of the point-of-view hat.

   .. classmethod:: is_connected(int joystick)

      Return ``True`` is *joystick* is connected, otherwise ``False``
      is returned.

   .. classmethod:: get_button_count(int joystick)

      Return the number of buttons supported by *joystick*. If the
      joystick is not connected, return 0.

   .. classmethod:: has_axis(int joystick, int axis)

      Return whether *joystick* supports the given *axis*. If the
      joystick isn't connected, ``False`` is returned. *axis* should
      be an :ref:`axis code <refevents_axescodes>`.

   .. classmethod:: is_button_pressed(int joystick, int button)

      Return whether *button* is pressed on *joystick*. If the
      joystick isn't connected, ``False`` is returned.

   .. classmethod:: get_axis_position(int joystick, int axis)

      Return the current position along *axis* as a float. If the
      joystick is not connected, 0.0 is returned. *axis* should be an
      :ref:`axis code <refevents_axescodes>`.

   .. classmethod:: update()

      Update the state of all the joysticks. You don't need to call
      this method yourself in most cases. If you haven't created any
      window, however, you will need to call it to update the joystick
      state.


.. class:: Keyboard

   This class provides an interface to the state of the keyboard. It
   only contains static methods (a single keyboard is assumed), so
   it's not meant to be instanciated.

   This class allows users to query the keyboard state at any time and
   directly, without having to deal with a window and its
   events. Compared to the :attr:`Event.KEY_PRESSED` and
   :attr:`Event.KEY_RELEASED` events, Keyboard can retrieve the state
   of a key at any time (you don't need to store and update a boolean
   on your side in order to know if a key is pressed or released), and
   you always get the real state of the keyboard, even if keys are
   pressed or released when your window is out of focus and no event
   is triggered.

   Usage example::

      if sfml.Keyboard.is_key_pressed(sfml.Keyboard.LEFT):
          pass # move left...
      elif sfml.Keyboard.is_key_pressed(sfml.Keyboard.RIGHT):
          pass # move right...
      elif sfml.Keyboard.is_key_pressed(sfml.Keyboard.ESCAPE):
          pass # quit...

   .. _refevents_keycodes:

   Key codes:

   .. attribute:: A
   .. attribute:: B
   .. attribute:: C
   .. attribute:: D
   .. attribute:: E
   .. attribute:: F
   .. attribute:: G
   .. attribute:: H
   .. attribute:: I
   .. attribute:: J
   .. attribute:: K
   .. attribute:: L
   .. attribute:: M
   .. attribute:: N
   .. attribute:: O
   .. attribute:: P
   .. attribute:: Q
   .. attribute:: R
   .. attribute:: S
   .. attribute:: T
   .. attribute:: U
   .. attribute:: V
   .. attribute:: W
   .. attribute:: X
   .. attribute:: Y
   .. attribute:: Z
   .. attribute:: NUM0

      The 0 key.

   .. attribute:: NUM1

      The 1 key.

   .. attribute:: NUM2

      The 2 key.

   .. attribute:: NUM3

      The 3 key.

   .. attribute:: NUM4

      The 4 key.

   .. attribute:: NUM5

      The 5 key.

   .. attribute:: NUM6

      The 6 key.

   .. attribute:: NUM7

      The 7 key.

   .. attribute:: NUM8

      The 8 key.

   .. attribute:: NUM9

      The 9 key.

   .. attribute:: ESCAPE
   .. attribute:: L_CONTROL

      The left control key.

   .. attribute:: L_SHIFT

      The left shift key.

   .. attribute:: L_ALT

      The left alt key.

   .. attribute:: L_SYSTEM

      The left OS-specific key, e.g. window, apple or home key.

   .. attribute:: R_CONTROL

      The right control key.

   .. attribute:: R_SHIFT

      The right shift key.

   .. attribute:: R_ALT

      The right alt key.

   .. attribute:: R_SYSTEM

      The right OS-specific key, e.g. window, apple or home key.

   .. attribute:: MENU

      The menu key.

   .. attribute:: L_BRACKET

      The ``[`` key.

   .. attribute:: R_BRACKET

      The ``]`` key.

   .. attribute:: SEMI_COLON

      The ``;`` key.

   .. attribute:: COMMA

      The ``,`` key.

   .. attribute:: PERIOD

      The ``.`` key.

   .. attribute:: QUOTE

      The ``'`` key.

   .. attribute:: SLASH

      The ``/`` key.

   .. attribute:: BACK_SLASH

      The ``\`` key.

   .. attribute:: TILDE

      The ``~`` key.

   .. attribute:: EQUAL

      The ``=`` key.

   .. attribute:: DASH

      The ``-`` key.

   .. attribute:: SPACE
   .. attribute:: RETURN
   .. attribute:: BACK

      The backspace key.

   .. attribute:: TAB

      The tabulation key.

   .. attribute:: PAGE_UP
   .. attribute:: PAGE_DOWN
   .. attribute:: END
   .. attribute:: HOME
   .. attribute:: INSERT
   .. attribute:: DELETE
   .. attribute:: ADD

      The ``+`` key.

   .. attribute:: SUBTRACT

      The ``-`` key.

   .. attribute:: MULTIPLY

      The ``*`` key.

   .. attribute:: DIVIDE

      The ``/`` key.

   .. attribute:: LEFT

      The left arrow.

   .. attribute:: RIGHT

      The right arrow.

   .. attribute:: UP

      The up arrow.

   .. attribute:: DOWN

      The down arrow.

   .. attribute:: NUMPAD0

      The numpad 0 key.

   .. attribute:: NUMPAD1

      The numpad 1 key.

   .. attribute:: NUMPAD2

      The numpad 2 key.

   .. attribute:: NUMPAD3

      The numpad 3 key.

   .. attribute:: NUMPAD4

      The numpad 4 key.

   .. attribute:: NUMPAD5

      The numpad 5 key.

   .. attribute:: NUMPAD6

      The numpad 6 key.

   .. attribute:: NUMPAD7

      The numpad 7 key.

   .. attribute:: NUMPAD8

      The numpad 8 key.

   .. attribute:: NUMPAD9

      The numpad 9 key.

   .. attribute:: F1
   .. attribute:: F2
   .. attribute:: F3
   .. attribute:: F4
   .. attribute:: F5
   .. attribute:: F6
   .. attribute:: F7
   .. attribute:: F8
   .. attribute:: F9
   .. attribute:: F10
   .. attribute:: F11
   .. attribute:: F12
   .. attribute:: F13
   .. attribute:: F14
   .. attribute:: F15
   .. attribute:: PAUSE
   .. attribute:: KEY_COUNT

      The total number of keyboard keys.

   .. classmethod:: is_key_pressed(int key)

      Return ``True`` if *key* is pressed, otherwise ``False`` is
      returned. *key* should a value from the :ref:`key codes
      <refevents_keycodes>`.


.. class:: Mouse

   This class gives access to the real-time state of the mouse. It
   only contains static functions (a single mouse is assumed), so it's
   not meant to be instanciated.

   This class allows users to query the mouse state at any time and
   directly, without having to deal with a window and its
   events. Compared to the :attr:`Event.MOUSE_MOVED`,
   :attr:`Event.MOUSE_BUTTON_PRESSED` and
   :attr:`Event.MOUSE_BUTTON_RELEASED` events, this class can retrieve
   the state of the cursor and the buttons at any time (you don't need
   to store and update a boolean on your side in order to know if a
   button is pressed or released), and you always get the real state
   of the mouse, even if it is moved, pressed or released when your
   window is out of focus and no event is triggered.

   The :meth:`set_position` and :meth:`get_position` methods can be
   used to change or retrieve the current position of the mouse
   pointer. There are two versions: one that operates in global
   coordinates (relative to the desktop) and one that operates in
   window coordinates (relative to a specific window).

   Usage example::

      if sfml.Mouse.is_button_pressed(sfml.Mouse.LEFT):
          pass # left click...

      # Get global mouse position
      position = sfml.Mouse.get_position()

      # Set mouse position relative to a window
      sfml.Mouse.set_position((100, 200), window)

   .. _eventsref_mousebuttons:

   Mouse buttons codes:

   .. attribute:: LEFT

      The left mouse button.

   .. attribute:: RIGHT

      The right mouse button.

   .. attribute:: MIDDLE

      The middle (wheel) mouse button.

   .. attribute:: X_BUTTON1

      The first extra mouse button.

   .. attribute:: X_BUTTON2

      The second extra mouse button.

   .. attribute:: BUTTON_COUNT

      The total number of mouse buttons.

   .. classmethod:: is_button_pressed(int button)

      Return ``True`` if *button* is pressed, otherwise returns
      ``False``. *button* should be a :ref:`mouse button
      code<eventsref_mousebuttons>`.

   .. classmethod:: get_position([window])

      Return a tuple with the current position of the cursor. With no
      arguments, the global position on the desktop is returned. If a
      *window* argument is provided, the position relative to the
      window is returned.

   .. classmethod:: set_position(tuple position[, window])

      Set the current position of the cursor. With only one argument,
      *position* is considered a as global desktop position. If a
      *window* argument is provided, the position is considered as
      relative to the window.
