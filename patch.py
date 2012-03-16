#! /usr/bin/env python2
# -*- coding: utf-8 -*-

"""This script modifies some Cython-generated files.

   Currently, it's only needed to call it when building for Python 3."""


import os.path
import re


def patch_sf_h():
    """Remove the DL_IMPORT macros in src/sfml.h."""

    filename = os.path.join('src', 'sfml.h')

    with open(filename, 'r') as f:
        source = f.read()

    source = re.sub(r'DL_IMPORT\(([\w\s:]+)\)', r'\1', source)

    with open(filename, 'w') as f:
        f.write(source)

def main():
    patch_sf_h()


if __name__ == '__main__':
    main()
