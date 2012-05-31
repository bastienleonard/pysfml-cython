# -*- coding: utf-8 -*-

# Copyright 2010, 2011 Bastien Léonard. All rights reserved.

# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:

#    1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.

#    2. Redistributions in binary form must reproduce the above
#    copyright notice, this list of conditions and the following
#    disclaimer in the documentation and/or other materials provided
#    with the distribution.

# THIS SOFTWARE IS PROVIDED BY BASTIEN LÉONARD ``AS IS'' AND ANY
# EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
# PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL BASTIEN LÉONARD OR
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF
# USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT
# OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
# SUCH DAMAGE.


# When creating a Windows installer, drop the SFML and dependent DLLs
# in the current folder and they will be included in the installer.


# Set to False if you don't have Cython installed. The script will
# then build the extension module from the sf.cpp file, like a regular
# extension.
USE_CYTHON = True


import glob
import os.path
import sys
from distutils.core import setup
from distutils.extension import Extension
from distutils.command.build_ext import build_ext

if USE_CYTHON:
    import Cython.Distutils


def src(path):
    return os.path.join('src', path)


print >> sys.stderr, ("\nIf the build fails, run patch.py and try again\n"
                      "----------------------------------------------\n")

libs = ['sfml-graphics', 'sfml-window', 'sfml-audio', 'sfml-system']

if USE_CYTHON:
    ext_modules = [Extension('sfml', [src('sfml.pyx'), src('hacks.cpp')],
                             language='c++',
                             libraries=libs)]
else:
    ext_modules = [Extension('sfml', [src('sfml.cpp'), src('hacks.cpp')],
                             libraries=libs)]

with open('README.md', 'r') as f:
    long_description = f.read()

kwargs = dict(name='pySFML',
              ext_modules=ext_modules,
              version='0.1.2',
              description='A Python binding for SFML 2',
              long_description=long_description,
              author=u'Bastien Léonard',
              author_email='bastien.leonard@gmail.com',
              url='https://github.com/bastienleonard/pysfml2-cython',
              license='BSD',
              scripts=glob.glob(os.path.join('examples', '*.py')),
              data_files=[
                  ('', glob.glob('*.dll')),
                  (os.path.join('lib', 'site-packages', 'pysfml2-cython'),
                   ['LICENSE.txt', 'SFML-LICENSE.txt'])],
              classifiers=[
                  'Development Status :: 4 - Beta',
                  'Intended Audience :: Developers',
                  'License :: OSI Approved :: BSD License',
                  'Operating System :: OS Independent',
                  'Programming Language :: Cython',
                  'Topic :: Games/Entertainment',
                  'Topic :: Multimedia',
                  'Topic :: Software Development :: Libraries :: Python Modules'
                  ])


if USE_CYTHON:
    kwargs.update(cmdclass={'build_ext': Cython.Distutils.build_ext})
else:
    class CustomBuildExt(build_ext):
        """This class is used to build the Windows binary releases."""

        def build_extensions(self):
            cc = self.compiler.compiler_type

            if cc == 'mingw32':
                for e in self.extensions:
                    # e.extra_compile_args = []
                    e.extra_link_args = ['-static-libgcc', '-static-libstdc++']

            build_ext.build_extensions(self)

    kwargs.update(cmdclass={'build_ext': CustomBuildExt})

setup(**kwargs)
