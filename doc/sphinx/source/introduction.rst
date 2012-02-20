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


Introduction
============


What is this project about?
---------------------------

This project allows you use to use `SFML 2 <http://sfml-dev.org/>`_
from Python.  As SFML's author puts it, "SFML is a free multimedia C++
API that provides you low and high level access to graphics, input,
audio, etc."  It's the kind of library you use for writing multimedia
applications such as games or video players.


What isn't this project about?
------------------------------

This binding currently doesn't aim to be used as an OpenGL wrapper,
unlike the original SFML library.  This is because there are already
such wrappers available in Python, such as Pygame, PyOpenGL or pyglet.


Doesn't SFML already have a Python binding?
-------------------------------------------

It does, but the binding needed to be rewritten, mainly because the
current binding is directly written in C++ and is a maintenance
nightmare.  This new binding is written in `Cython
<http://cython.org>`_, hence the name.

Also, I find that the current binding lacks some features, such as:

* It doesn't follow Python's naming conventions.
* It lacks some fancy features such as properties, exceptions and
  iterators (for example, my binding allows you to iterate on events
  with a simple ``for`` loop).

You should also note that the current PySFML release on SFML's website
is buggy (for example, ``Image.SetSmooth()`` doesn't work).
You'd need to compile the latest version yourself to avoid these bugs.


Why SFML 2?
-----------

SFML 1 is now part of the past; it contains some important bugs and
apparently won't be updated anymore.

SFML 2 is still a work in progress, but it's stable enough for many
projects and it only breaks a few parts of SFML 1's API.

SFML 2 brings in important changes, such as new features, performance
improvement and a more consistent API.  In my opinion, if you aren't
tied to SFML 1, you should stop using it and try SFML 2.


What does "Cython" mean? Can I use this module with Python 2/3?
---------------------------------------------------------------

I use it in the binding's name to help distinguish it with other
bindings. The fact the it's written with Cython means that it's easier
to maintain, and as fast as a C or C++ binding (although some parts
*might* need optimizations).

Don't worry, the module works with the traditional Python interpreter
(CPython), version 2 or 3. (For more information, see
:ref:`building_the_module`.) However, it doesn't work with other
interpreters like PyPy.
