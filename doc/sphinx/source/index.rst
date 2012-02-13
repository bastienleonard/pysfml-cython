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


.. pySFML 2 - Cython documentation master file, created by
   sphinx-quickstart on Fri Feb 18 08:41:37 2011.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

Welcome to pySFML 2 - Cython's documentation!
=============================================

A new Python binding for SFML 2, made with `Cython
<http://cython.org>`_.  Many features of SFML are currently available,
but this is still a work in progress.  Feel free to report any issue
you encounter.

You can find the source code and the issue tracker here:
https://github.com/bastienleonard/pysfml2-cython

Currently the reference just lists the available classes, their
members, and information specific to this binding.  For the
documentation itself, please see the `SFML 2 documentation
<http://sfml-dev.org/documentation/2.0/annotated>`_.  The mapping
between SFML and this binding should be fairly easy to grasp.

.. note::

   A current limitation is that :class:`sf.Texture` objects won't work
   as expected unless they are created after your
   :class:`sf.RenderWindow`.  It isn't a big problem in practice, but
   it's something to keep in mind until the issue is
   fixed. **Update:** this seems to be related to a bug in SFML:
   https://github.com/LaurentGomila/SFML/issues/160

.. warning::

   The current Github binding has been updated to SFML's new graphics
   API recently, but the documentation hasn't been updated yet.

Contents:

.. toctree::
   :maxdepth: 2

   introduction
   building
   tutorial
   reference
   licenses


Indices and tables
==================

* :ref:`genindex`
* :ref:`modindex`
* :ref:`search`

