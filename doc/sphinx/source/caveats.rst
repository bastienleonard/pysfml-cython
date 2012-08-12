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


.. _caveats:

Caveats
=======

Currently, the binding doesn't work correctly when built straight from
the Git repo. See :ref:`building_with_cython` for more information.

Windows programs sometimes crash just before exiting. Starting from
pySFML 0.2.1, the default font has been removed, which should solve a
lot of deallocation problems. Christoph Gohlke's installers also seem
to generally be more reliable, so as far as I know, newer installers
shouldn't have this bug.

A current limitation is that :class:`Texture` objects won't work as
expected unless they are created after your :class:`RenderWindow`. It
isn't a big problem in practice, but it's something to keep in mind
until the issue is fixed. This seems to be related to a bug in SFML:
https://github.com/LaurentGomila/SFML/issues/160 It may also be
dependent on the platform, but even if it works correctly on your
system, you shouldn't rely on it for now.
