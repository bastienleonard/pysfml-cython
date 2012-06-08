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


.. _cpptut:

Learning pySFML from a C++ SFML background
==========================================


Naming convention
-----------------

This module follows the `style guide for Python code
<http://www.python.org/dev/peps/pep-0008/>`_ as much as possible. To
give you an idea, here is a list of attribute naming examples:

- Classes: ``RenderWindow``, ``Texture``.
- Methods and attributes: ``default_view``, ``load_from_file()``.
- Constants: ``CLOSED``, ``KEY_PRESSED``, ``BLEND_ALPHA``.

Namespaces normally follow the same nesting as in C++,
e.g. ``sf::Event::Closed`` becomes :attr:`sfml.Event.CLOSED`. Events
are an exception, see :ref:`cpptut_events`.


Object initialization with class methods
----------------------------------------

C++ SFML has a general pattern for creating objects when their
initialization may fail:

- Allocate an "empty" object.
- Call a method that will initialize the object, e.g. ``loadFromFile()``.
- If this method returned ``false``, handle the error.

In pySFML, you typically just have to call a class method,
e.g. :meth:`Texture.load_from_file`. If you want to handle possible
errors at this point, you write an ``except`` block (see
:ref:`cpptut_error_handling`). Otherwise, the exception will propagate
to the next handler.

In some cases, class methods are the only way to initialize an
object. In that case, the constructor will raise
``NotImplementedError`` if you call it. In other cases, the
constructors peform some kind of default initialization, while class
methods do more specific work.


Properties
----------

Generally speaking, ``set*()/get*()`` methods are replaced by
properties. For example,
``RenderWindow.getSize()/RenderWindow.setSize()`` becomes a
:attr:`RenderWindow.size` property which behaves like a normal
attribute. I tend to create properties when the user can safely ignore
that he's not dealing with an actual attribute, i.e. when the property
doesn't do anything non-obvious and is fast to execute.

In some cases, it's not that straightforward. Some properties only
have a getter or a setter, even though they should have both (for
example, :attr:`RenderWindow.key_repeat_enabled`). The reason is that
C++ SFML doesn't provide the missing set/get method. This has been
pointed out to SFML's author, who is going to fix it someday. I could
fix it myself, but it would require to add quite a lot of boilerplate
that I will need to remove when SFML gets the missing methods. The
reason why these methods are missing in the first place is that's
they're not very useful, so I consider that to be a decent trade-off.

Another problematic property is :attr:`Sprite.texture_rect`, which for
now returns a new copy every time you access it. Eventually, I will
either hack it to behave like an actual attribute, or rewrite it as
``get_texture_rect()/set_texture_rect()`` methods.

I tend to use a method instead of an attribute when I feel like a
``get*()`` method involves some kind of computation. For example,
:meth:`View.get_inverse_transform` is a method instead of a property
because I somehow feel like it involves something heavier than simply
looking up an attribute. Admittedly, this is subjective, and it's
difficult to be consistent with this kind of choice as well.


.. _cpptut_events:

Events
------

pySFML objects only feature the attributes that they actually
need. For example, ``event.key.code`` in C++ becomes ``event.code``.
Accessing an attribute that doesn't make sense for this event will
raise an exception, because the object event doesn't have it at all.
As you can see in the :ref:`event_types_reference`, there is some
overlap, so theoretically you could confuse a ``MOUSE_WHEEL_MOVED``
event for a ``MOUSE_MOVED`` event, access the ``x`` or ``y``
attribute, without raising any exception.

Instead of using :meth:`RenderWindow.poll_event`, events are usually
retrieved in ``for`` loop with :meth:`RenderWindow.iter_event`::

   for event in window.iter_events():
       if event.type == sfml.Event.CLOSED:
           ...


.. _cpptut_error_handling:

Error handling
--------------

Unlike C++ SFML, there are no boolean return values to indicate
success or failure. Anytime SFML returns ``False``, typically, when a
file can't be opened, pySFML raises :exc:`PySFMLException`. Please
read the description of this exception for more information.

I'd like to add more specific exceptions, but since SFML only returns
``True`` or ``False``, I can't tell if the source of the failure is a
non existant file, an invalid file content, an internal library
failure, or anything else. SFML's author wants to improve error
handling in a future release. At this point, more specific exceptions
will probably be possible to implement.


Creating your own drawables
---------------------------

Unlike in C++ SFML, you don't have to inherit a ``Drawable``
class. This is covered in :ref:`Creating your own
drawables<graphicsref_custom_drawables>`.


Time
----

Time values are created with :class:`Time`'s constructor using keyword
arguments, instead of calling a global function. For example,
``sf::milliseconds(200)`` becomes ``sfml.Time(milliseconds=200)``.


"Missing" features
------------------

:class:`Vector2f` has been ported, but tuples are used instead of
``Vector2i`` and ``Vector3f``. These classes are used so sparsely that
it doesn't seem worth porting them. Note that you can pass tuples
instead of :class:`Vector2f` objects.

The network and threading parts of SFML aren't ported in this module,
since similar features are already provided by the standard library.
For UDP and TCP connections, you should look into the ``socket``
module. ``threading`` is the general, high-level module for threading
stuff. For URL retrieval, ``urllib`` and ``urllib2`` are provided.

You may also want to check non standard libraries such as `Twisted
<http://twistedmatrix.com/>`_ or `requests
<http://docs.python-requests.org/en/latest/index.html>`_.

Most streaming features are also currently missing.
