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


.. _building_the_module:

Building the module
===================

Binary releases
---------------

If you're on Windows, you can download the current binary release at
https://github.com/bastienleonard/pysfml2-cython/downloads, and ignore
most of this section. The installer contains the module itself, and
the required DLLs (SFML and dependencies). The DLLs are dropped in
Python's folder, e.g. ``C:\Python27``. If you haven't already, make
sure that this folder has been added to the ``PATH`` environment
variable.

Christoph Gohlke also provides installers, with support for Python 2.6
as well as native 64 bits installers on his website:
http://www.lfd.uci.edu/~gohlke/pythonlibs/#pysfml2

You should be able to use pySFML 2 without installing anything
else. Feedback is welcome.

On other platforms, there may still be easier ways to build the
module. Someone has written AUR scripts for Arch Linux users:

* https://aur.archlinux.org/packages.php?ID=50841

* https://aur.archlinux.org/packages.php?ID=50842


Getting SFML 2
--------------

The first thing you should do is get `SFML 2
<https://github.com/LaurentGomila/SFML>`_ and make sure it
works. Please refer to the official tutorial:
http://sfml-dev.org/tutorials/2.0/compile-with-cmake.php

Some platforms may make it easier to install it, for example Arch
Linux users can get it from AUR.

If you are on Windows, you will probably want to copy SFML's headers
and libraries directories to the corresponding directories of your
compiler/IDE, and SFML's DLLs to Windows' DLL directory.


Building on Windows
-------------------

If you don't have a C++ compiler installed, I suggest using `MinGW
<http://www.mingw.org>`_.

If you are using a recent version of MinGW, you may encounter this
error when building the module::

    error: unrecognized command line option '-mno-cygwin'

The `problem <http://bugs.python.org/issue12641>`_ is that the
``-mno-cygwin`` has been dropped in recent MinGW releases.  A quick
way to fix this is to remove the option from the distutils
source. Find the ``distutils/cygwinccompiler.py`` in your Python
installation (it should be something like
``C:\Python27\Lib\distutils\cygwinccompiler.py``). Find the
``MinGW32CCompiler`` class and remove the ``-mno-cygwin`` options::

    # class CygwinCCompiler
    self.set_executables(compiler='gcc -mno-cygwin -O -Wall',
                         compiler_so='gcc -mno-cygwin -mdll -O -Wall',
                         compiler_cxx='g++ -mno-cygwin -O -Wall',
                         linker_exe='gcc -mno-cygwin',
                         linker_so='%s -mno-cygwin %s %s'
                                    % (self.linker_dll, shared_option,
                                       entry_point))


If you are using Visual C++, please use the 2008 version. Python was
built with this version, and it's apparently difficult to use 2010
because it links to another C or C++ runtime.


Common build options
--------------------

You can build the module with the ``setup.py`` script (or
``setup3k.py`` for Python 3).  This section discusses some common
options that you may need or find useful.

``--inplace`` means that the module will be dropped in the current
directory. I find this more practical, so it makes it easier to test
the module once built.

``--compiler=mingw32`` obviously means that `MinGW`_
will be invoked instead of the default compiler. This is needed when you want
to use GCC on Windows. This command will show you the list of compiler you
specify: ``python setup.py build_ext --help-compiler``.

In the end, the command will look something like this::

    python setup.py build_ext --inplace --compiler=mingw32


.. _building_without_cython:

Building without Cython
-----------------------

If you download a source release at the `download page
<https://github.com/bastienleonard/pysfml2-cython/downloads>`_, you
don't need to install Cython, since the release already contains the
files that Cython would generate.

Make sure that ``USE_CYTHON`` is set to ``False`` in setup.py (or
setup3k.py, if you're building for Python 3).  You can then build the
module by typing this command::

    python setup.py build_ext


Building with Cython installed
------------------------------

.. warning::

   Currently, modules built straight from the repo probably won't work
   (this may depend on your Cython version). Consider using a source
   release, or read this forum post if you still want to build from
   Git:
   http://en.sfml-dev.org/forums/index.php?topic=5311.msg52943#msg52943

.. warning::

   Several Ubuntu users reported that they can't build the module
   because the Cython package is currently outdated. One solution is
   to `install Cython manually
   <http://docs.cython.org/src/quickstart/install.html>`_, for example
   with ``easy_install cython``.

If you downloaded the source straight from the Git repo or if you have
modified the source, you'll need to install Cython to build a module
including the changes.  Also, make sure that ``USE_CYTHON`` is set to
``True`` in setup.py.

When you've done so, you can build the module by typing this command::

    python setup.py build_ext

If you get an error related with ``DL_IMPORT``, refer to the end of
the :ref:`python3` section.


.. _python3:

Building a Python 3 module
--------------------------

It's possible to build a Python 3 module, but you may encounter a few
minor problems.

First of all, on my machine, the Cython class used in ``setup3k.py`` to
automate Cython invocation is only installed for Python 2. It's
probably possible to install it for Python 3, but it's not complicated
to invoke Cython manually::

    cython --cplus sfml.pyx

The next step is to invoke the ``setup3k.py`` script to build the
module. Since we called Cython already, make sure that ``USE_CYTHON``
is set to ``False`` in ``setup3k.py``, then invoke this command::

    python3 setup3k.py build_ext

(Note that you may have to type ``python`` instead of ``python3``;
typically, GNU/Linux systems provide this as a way to call a specific
version of the interpreter, but I'm not sure that's the case for all
of them as well as Windows.)

(Also note that on GNU/Linux, the generated file won't be called
``sfml.so`` but something like ``sfml.cpython-32mu.so``. Apparently,
on Windows it's still ``sfml.pyd``.)

The second problem used to be that you had to use bytes instead of
Unicode e.g. when passing a filename or window title to SFML. This is
now gone, except possibly in methods that I forgot to fix; make sure
to report the issue if you encounter such a case. When you pass a
Unicode object to these methods, they now encode it in UTF-8 before
passing them to SFML. You can change the encoding by setting the
:attr:`default_encoding` variable at any time.

Finally, compilation may fail because the ``src/sfml.h`` file
generated by Cython uses the deprecated ``DL_IMPORT()`` macro. At the
root of the project, there is a ``patch.py`` script that will remove
the offending macros for you. The trick is that ``src/sfml.h`` will
not exist at first; the setup script will create it, then try to
compile it and fail. That's when you need to use ``patch.py``, and
build the module again.
