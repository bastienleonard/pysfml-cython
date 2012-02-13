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


Exceptions
==========


.. module:: sf


Currently, only one exception exists, but more specific exceptions will probably
be used in the future.


.. exception:: PySFMLException

   Raised when any important error is encountered. Typically, file loading
   methods such as :meth:`sf.Texture.load_from_file()` return the new object if
   everything went well, and raise this exception otherwise.

   A simple example of error handling::

      try:
          texture = sf.Texture.load_from_file('texture.png')
      except sf.PySFMLException as e:
          # Handle error: pring message, log it, ...

   In C++::

      sf::Texture texture;

      if (!texture.LoadFromFile("texture.png"))
      {
          // Handle error
      }

   Please understand that you don't *have* to handle exceptions every time you
   call a method that might throw one; you can handle them at a higher level or
   even not handle them at all, if the default behavior of stopping the program
   and printing a traceback is OK. This is an advantage compared to C++ SFML,
   where ignoring return statuses means that your program will try to keep
   running normally if an important error is raised.

   .. attribute:: message

      A string describing the error.  This is the same message that
      C++ SFML would write in the console.
