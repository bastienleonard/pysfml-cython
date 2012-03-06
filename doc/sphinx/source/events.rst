.. Copyright 2011 Bastien Léonard. All rights reserved.

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


.. module:: sf


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

      if event.type == sf.Event.KEY_PRESSED and event.code == sf.Keyboard.ESCAPE:
          # ...

   .. attribute:: NAMES

      A class attribute that maps event codes to a short description::

         >>> sf.Event.NAMES[sf.Event.CLOSED]
         'Closed'
         >>> sf.Event.NAMES[sf.Event.KEY_PRESSED]
         'Key pressed'

      If you want to print this information about a specific object,
      you can simply use ``print``; ``Event.__str__()`` will look up
      the description for you.

   Event types:

   .. attribute:: CLOSED
   .. attribute:: RESIZED
   .. attribute:: LOST_FOCUS
   .. attribute:: GAINED_FOCUS
   .. attribute:: TEXT_ENTERED
   .. attribute:: KEY_PRESSED
   .. attribute:: KEY_RELEASED
   .. attribute:: MOUSE_WHEEL_MOVED
   .. attribute:: MOUSE_BUTTON_PRESSED
   .. attribute:: MOUSE_BUTTON_RELEASED
   .. attribute:: MOUSE_MOVED
   .. attribute:: MOUSE_ENTERED
   .. attribute:: MOUSE_LEFT
   .. attribute:: JOYSTICK_BUTTON_PRESSED
   .. attribute:: JOYSTICK_BUTTON_RELEASED
   .. attribute:: JOYSTICK_MOVED
   .. attribute:: JOYSTICK_CONNECTED
   .. attribute:: JOYSTICK_DISCONNECTED



.. class:: Joystick


   .. attribute:: COUNT
   .. attribute:: BUTTON_COUNT
   .. attribute:: AXIS_COUNT
   .. attribute:: X
   .. attribute:: Y
   .. attribute:: Z
   .. attribute:: R
   .. attribute:: U
   .. attribute:: V
   .. attribute:: POV_X
   .. attribute:: POV_Y

   .. classmethod:: is_connected(int joystick)
   .. classmethod:: get_button_count(int joystick)
   .. classmethod:: has_axis(int joystick, int axis)
   .. classmethod:: is_button_pressed(int joystick, int button)
   .. classmethod:: get_axis_position(int joystick, int axis)

.. class:: Keyboard


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
   .. attribute:: NUM1
   .. attribute:: NUM2
   .. attribute:: NUM3
   .. attribute:: NUM4
   .. attribute:: NUM5
   .. attribute:: NUM6
   .. attribute:: NUM7
   .. attribute:: NUM8
   .. attribute:: NUM9
   .. attribute:: ESCAPE
   .. attribute:: L_CONTROL
   .. attribute:: L_SHIFT
   .. attribute:: L_ALT
   .. attribute:: L_SYSTEM
   .. attribute:: R_CONTROL
   .. attribute:: R_SHIFT
   .. attribute:: R_ALT
   .. attribute:: R_SYSTEM
   .. attribute:: MENU
   .. attribute:: L_BRACKET
   .. attribute:: R_BRACKET
   .. attribute:: SEMI_COLON
   .. attribute:: COMMA
   .. attribute:: PERIOD
   .. attribute:: QUOTE
   .. attribute:: SLASH
   .. attribute:: BACK_SLASH
   .. attribute:: TILDE
   .. attribute:: EQUAL
   .. attribute:: DASH
   .. attribute:: SPACE
   .. attribute:: RETURN
   .. attribute:: BACK
   .. attribute:: TAB
   .. attribute:: PAGE_UP
   .. attribute:: PAGE_DOWN
   .. attribute:: END
   .. attribute:: HOME
   .. attribute:: INSERT
   .. attribute:: DELETE
   .. attribute:: ADD
   .. attribute:: SUBTRACT
   .. attribute:: MULTIPLY
   .. attribute:: DIVIDE
   .. attribute:: LEFT
   .. attribute:: RIGHT
   .. attribute:: UP
   .. attribute:: DOWN
   .. attribute:: NUMPAD0
   .. attribute:: NUMPAD1
   .. attribute:: NUMPAD2
   .. attribute:: NUMPAD3
   .. attribute:: NUMPAD4
   .. attribute:: NUMPAD5
   .. attribute:: NUMPAD6
   .. attribute:: NUMPAD7
   .. attribute:: NUMPAD8
   .. attribute:: NUMPAD9
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

   .. classmethod:: is_key_pressed(int key)

.. class:: Mouse


   .. attribute:: LEFT
   .. attribute:: RIGHT
   .. attribute:: MIDDLE
   .. attribute:: X_BUTTON1
   .. attribute:: X_BUTTON2
   .. attribute:: BUTTON_COUNT

   .. classmethod:: is_button_pressed(int button)
   .. classmethod:: get_position([window])
   .. classmethod:: set_position(tuple position[, window])
