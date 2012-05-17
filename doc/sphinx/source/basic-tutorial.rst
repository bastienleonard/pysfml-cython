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


.. module:: sfml


pySFML basics
=============

.. warning::

   The module has recently been renamed from ``sf`` to ``sfml``, to be
   more clear and avoid clashes. However, it's easy to still use
   ``sf`` as the namespace in your code; just write ``import sfml as
   sf``. This is the approach that we follow in this tutorial and in
   the examples. The reference uses ``sfml`` though, since it's the
   "official" namespace.

Welcome to pySMFL's official tuturial! You are going to learn how to
display an image and move it based on user input. But first, here is
the full listing::

   import sfml as sf


   def main():
       window = sf.RenderWindow(sf.VideoMode(640, 480),
                                'Drawing an image with SFML')
       window.framerate_limit = 60
       running = True
       texture = sf.Texture.load_from_file('python-logo.png')
       sprite = sf.Sprite(texture)

       while running:
           for event in window.iter_events():
               if event.type == sf.Event.CLOSED:
                   running = False

           if sf.Keyboard.is_key_pressed(sf.Keyboard.RIGHT):
               sprite.move(5, 0)
           elif sf.Keyboard.is_key_pressed(sf.Keyboard.LEFT):
               sprite.move(-5, 0)

           window.clear(sf.Color.WHITE)
           window.draw(sprite)
           window.display()

       window.close()


   if __name__ == '__main__':
       main()

You can get the ``python-logo.png`` file `here
<https://github.com/bastienleonard/pysfml2-cython/raw/master/examples/python-logo.png>`_,
or use any other image file supported: bmp, dds, jpg, png, tga, or
psd.


.. note::

   If you're new to Python, you may find the last two lines
   confusing. The ``main()`` function that we defined isn't a standard
   function like in C or C++. So we call the function ourself if
   ``__name__ == __main__``, i.e. if our file has been launched by the
   user, rather than imported by some code. You can find more
   information here:
   http://stackoverflow.com/questions/419163/what-does-if-name-main-do


Creating a window
-----------------

Windows in pySFML are created with the :class:`RenderWindow`
class. This class provides some useful constructors to create directly
our window. The interesting one here is the following::

    window = sf.RenderWindow(sf.VideoMode(640, 480), 'SFML Window')

Here we create a new variable named ``window`` that will represent our
new window. Let's explain the parameters:

* The first parameter is a :class:`VideoMode`, which represents the
  chosen video mode for the window. Here, the size is 640x480 pixels,
  with a depth of 32 bits per pixel. Note that the specified size will
  be the internal area of the window, excluding the titlebar and the
  borders.
* The second parameter is the window title.

If you want to create your window later, or recreate it with different
parameters, you can use its :meth:`RenderWindow.create()` method::

    window.create(sf.VideoMode(640, 480), 'SFML Window');

The constructor and the :meth:`RenderWindow.create()` method also
accept two optional additionnal parameters: the first one to have more
control over the window's style, and the second one to set more
advanced graphics options; we'll come back to this one in another
tutorial, beginners usually don't need to care about it.  The style
parameter can be a combination of the ``sf.Style`` flags, which are
``NONE``, ``TITLEBAR``, ``RESIZE``, ``CLOSE`` and ``FULLSCREEN``. The
default style is ``Style.RESIZE | Style.CLOSE``. ::

    # This creates a fullscreen window
    window.create(sf.VideoMode(800, 600), 'SFML Window', sf.Style.FULLSCREEN);


Video modes
-----------

When you create a :class:`VideoMode`, you can choose the bits per
pixel with a third argument. If you don't, it is set to 32, which is
what we do in our examples, since it's probably the most common value.

In the previous examples, any video mode size works because we run in
windowed mode. But if we want to run in fullscreen mode, we have to
choose one of the allowed modes.  The
:meth:`VideoMode.get_fullscreen_modes()` class method returns a list
of all the valid fullscreen modes. They are sorted from best to worst,
so ``sf.VideoMode.get_fullscreen_modes()[0]`` will always be the
highest-quality mode available::

    window = sf.RenderWindow(sf.VideoMode.get_fullscreen_modes[0], 'SFML Window', sf.Style.FULLSCREEN)

If you are getting the video mode from the user, you should check its
validity before applying it.  This is done with
:meth:`VideoMode.is_valid()`::

    mode = get_mode_from_somewhere()

    if not mode.is_valid():
        # Error...

The current desktop mode can be obtained with the
:meth:`VideoMode.get_desktop_mode()` class method.


Main loop
---------

Let's write a skeleton of our game loop::

    # Setup code
    window = sf.RenderWindow(sf.VideoMode(640, 480), 'SFML window')
    # ...

    while True:
        # Handle events
        # ...

        window.clear(sf.Color.WHITE)
                
        # Draw our stuff
        # ...       

        window.display()

:py:meth:`RenderWindow.clear()` fills the window with the specified
color. (If you don't pass any color, black will be used.) You can
create "custom" color objects with the :py:class:`Color` constructor.
For example, if you wanted to a pink background you could write
``window.clear(sf.Color(255, 192, 203))``.  The call to
:py:meth:`RenderWindow.display()` simply updates the content of the
window.

This code doesn't look right currently, because we have a loop that
doesn't really do anything: it just draws the same background over and
over.  Don't worry, it will make more sense once we will actually draw
stuff.

If you run this program and look at your process manager, you'll see
that it is using 100% of one of your processor's time.  This isn't
surprising, given the busy loop we wrote.  A simple fix is to set the
:py:attr:`RenderWindow.framerate_limit` attribute::

    window.framerate_limit = 60

This line tells SFML to ensure that the window isn't updated more than
60 times per second. It should to go in the setup code.


Event handling basics
---------------------

The most common way to handle events in pySFML is to use
:meth:`RenderWindow.iter_events()`. You can still use
:meth:`RenderWindow.poll_event()` like in C++ SFML, but it will just
make the code look a bit clumsy.

If you're used to C++ SFML, you will need to change your habit: pySFML
events only have the attributes that make sense for this particular
event; there's no equivalent to the C++ union.

You need to test the ``type`` attribute to know kind of event you're
looking at. Here are the event types:

* ``sf.Event.CLOSED``
* ``sf.Event.RESIZED``
* ``sf.Event.LOST_FOCUS``
* ``sf.Event.GAINED_FOCUS``
* ``sf.Event.TEXT_ENTERED``
* ``sf.Event.KEY_PRESSED``
* ``sf.Event.KEY_RELEASED``
* ``sf.Event.MOUSE_WHEEL_MOVED``
* ``sf.Event.MOUSE_BUTTON_PRESSED``
* ``sf.Event.MOUSE_BUTTON_RELEASED``
* ``sf.Event.MOUSE_MOVED``
* ``sf.Event.MOUSE_ENTERED``
* ``sf.Event.MOUSE_LEFT``
* ``sf.Event.JOYSTICK_BUTTON_PRESSED``
* ``sf.Event.JOYSTICK_BUTTON_RELEASED``
* ``sf.Event.JOYSTICK_MOVED``
* ``sf.Event.JOYSTICK_CONNECTED``
* ``sf.Event.JOYSTICK_DISCONNECTED``

In our case, we just use the "closed" event to stop the program::

    for event in window.iter_events():
        if event.type == sf.Event.CLOSED:
            running = False

Most event objects contain special attributes containing useful
values, but ``CLOSED`` doesn't, it just tells you that the user want
to close your application. ``KEY_PRESSED`` is another common event
type. Events of this type contain several attributes, but the most
important one is ``code``. It's an integer that maps to one of the
constants in the :class:`Keyboard` class.

For example, if we wanted to close the window when the user presses
the Escape key, our event loop could look like this::

   while running:
       for event in window.iter_events():
           if event.type == sf.Event.CLOSED:
               running = False
           elif event.type == sf.Event.KEY_PRESSED:
               if event.code == sf.Keyboard.ESCAPE:
                   running = False

See :ref:`event_types_reference` for the list of all events and the
attributes they contain.

.. note::

   In fullscreen mode, you can't rely on the window manager's controls
   to send the ``CLOSED`` event, so it's a good idea to set a shortcut
   like we just did to make sure the user is able to close the
   application.


Drawing the image
-----------------

You will need to use at least two classes for displaying the image:
:class:`Texture` and :class:`Sprite`. It's important to understand the
difference between these two:

* Textures contain the actual image that you want to display. They are
  heavy objects, and you shouldn't have the same image/texture loaded
  more than once in memory. Textures objects can't be displayed
  directly; for example there's no way to set the (x, y) position of a
  texture. You need to use sprites for this purpose.
* Sprites are lightweight objects associated with a texture, either
  with the constructor or the :attr:`Sprite.texture` attribute. They
  have many visual properties that you can change, such as the (x, y)
  position, the zoom or the rotation.

In practice, you might have several creatures displayed on screen, all
from the same image. The image would be loaded only once into memory,
and several sprite objects would be created. They would all have the
same texture property, but their position would be set to the
creature's position on screen. They could also have a different
rotation or other effects, based on the creature's state.

There are two main steps to displaying our image. First, we need to
load the image in the setup code and create the sprite::

    texture = sf.Texture.load_from_file('python-logo.png')
    sprite = sf.Sprite(texture)

Now, we can display the sprite in the game loop::

    window.clear(sf.Color.WHITE)
    window.draw(sprite)
    window.display()


Real-time input handling
------------------------

What if we want to do something as long as the user is pressing a
certain key? For example, we want to move our logo as long as the user
is pressing the right arrow key, or the left key. In that case, it's
not enough to know that the user just pressed the key. We want to know
whether he is still holding it or not.

To achieve that, you would need to set a boolean to ``True`` as soon
as the user is pressing the key. When you get the "release" event for
that key, you set it back to ``False``. And you read the value of that
boolean to know whether the right key is pressed or not.

As it turns out, SFML has this kind of feature built in. You can call
:meth:`Keyboard.is_key_pressed` with the code the key as an argument;
it will return ``True`` if this key is currently pressed. The key
codes are class attributes in :class:`Keyboard`: for example,
:attr:`Keyboard.LEFT` and :attr:`Keyboard.RIGHT` map to the left and
right arrow keys. Your event loop would then look something like this::

   while running:
       for event in window.iter_events():
           if event.type == sf.Event.CLOSED:
               running = False

       if sf.Keyboard.is_key_pressed(sf.Keyboard.RIGHT):
           sprite.move(5, 0)
       elif sf.Keyboard.is_key_pressed(sf.Keyboard.LEFT):
           sprite.move(-5, 0)

The :class:`Mouse` class provides a similar class method,
:meth:`Mouse.is_button_pressed`, for when you need to know whether a
mouse button is pressed.


Images and textures
-------------------

Another class may be useful for displaying images: :class:`Image`. The
difference between a texture and an image is that a texture gets
loaded into video memory and can be efficiently displayed. If you want
to display an image, you need to create a texture and call
:meth:`Texture.load_from_image`, and then display the texture. On the
other hand, you can access and modify the pixels of an image as
needed.

The bottom line is: use textures by default, and use images only if
it's needed.
