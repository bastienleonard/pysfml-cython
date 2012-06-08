# -*- python -*-
# -*- coding: utf-8 -*-

# Copyright 2011, 2012 Bastien Léonard. All rights reserved.

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


# This the main source file, and yes it's huge. I'd like to split it
# into several files, but using includes seems ugly and dangerous, and
# Cython's module/namespace mechanisms didn't work when I tried to put
# exceptions-related stuff in another file.


"""Python wrapper for the C++ library SFML 2 (Simple and Fast
Multimedia Library)."""


from libc.stdlib cimport malloc, free
from libc.stdio cimport printf, puts
from libcpp.vector cimport vector
from cython.operator cimport preincrement as preinc, dereference as deref
cimport cpython

import threading

cimport decl
cimport declaudio
cimport declevent
cimport decljoy
cimport declkey
cimport declmouse
cimport declshader
cimport declstyle
cimport declprimitive


# Forward declarations
cdef class RenderTarget
cdef class RenderWindow



decl.PyEval_InitThreads()

# Currently, this encoding is used when the user passes a Unicode
# object to method that will call a SFML method which only supports
# std::string argument (that's the case most of the time, AFAIK the
# only exception is Text which interacts with sf::String for ``true''
# Unicode support). The user-supplised Unicode object will be encoded
# with this encoding and the resulting bytes will be passed to
# SFML. This is mostly for Python 3 users, so they don't have to use
# byte strings all the time.
default_encoding = 'utf-8'


# If you add a class that inherits drawables to the module, you *must*
# add it to this list. It used in RenderTarget.draw(), to know
# whether a drawable is ``built-in'' or user-defined.
# Important: RenderTarget.draw() assumes that these drawables' C++
# object inherit sf::Transformable, which causes a problem with
# sf::VertexArray, since it only inherits sf::Drawable. This is
# another reason why I removed that class.
cdef sfml_drawables = (Shape, Sprite, Text)


cdef error_messages = {}
cdef error_messages_lock = threading.Lock()


# TODO: apparently functions should be static in Python modules, see
# http://docs.python.org/extending/extending.html#providing-a-c-api-for-an-extension-module.
# The problem is that this function needs to be called in hacks.cpp,
# and Cython doesn't (AFAIK) make any difference between ``available
# across translations units'' and ``available at runtime in the shared
# object/DLL''.
cdef public void set_error_message(char* message):
    ident = threading.current_thread().ident

    with error_messages_lock:
        error_messages[ident] = message


decl.replace_error_handler()


# Return the last error message for the current thread, or None.  Will
# return None after you consumed the latest message, until a new
# message is added. The goal is to avoid showing the same message
# twice.
cdef object get_last_error_message():
    ident = threading.current_thread().ident

    with error_messages_lock:
        if ident in error_messages:
            message = error_messages[ident]
            del error_messages[ident]
            return message

    return None



class PySFMLException(Exception):
    def __init__(self, message=None):
        if message is None:
            message = get_last_error_message()

        if message is None:
            Exception.__init__(self)
        else:
            Exception.__init__(self, message)



BLEND_ALPHA = decl.BlendAlpha
BLEND_ADD = decl.BlendAdd
BLEND_MULTIPLY = decl.BlendMultiply
BLEND_NONE = decl.BlendNone

POINTS = decl.Points
LINES = decl.Lines
LINES_STRIP = decl.LinesStrip
TRIANGLES = decl.Triangles
TRIANGLES_STRIP = decl.TrianglesStrip
TRIANGLES_FAN = decl.TrianglesFan
QUADS = decl.Quads




cdef class Mouse:
    LEFT = declmouse.Left
    RIGHT = declmouse.Right
    MIDDLE = declmouse.Middle
    X_BUTTON1 = declmouse.XButton1
    X_BUTTON2 = declmouse.XButton2
    BUTTON_COUNT = declmouse.ButtonCount

    @classmethod
    def is_button_pressed(cls, int button):
        return declmouse.isButtonPressed(<declmouse.Button>button)

    @classmethod
    def get_position(cls, RenderWindow window=None):
        cdef decl.Vector2i pos

        if window is None:
            pos = declmouse.getPosition()
        else:
            pos = declmouse.getPosition((<decl.RenderWindow*>window.p_this)[0])

        return (pos.x, pos.y)

    @classmethod
    def set_position(cls, tuple position, RenderWindow window=None):
        cdef decl.Vector2i cpp_pos

        cpp_pos.x, cpp_pos.y = position

        if window is None:
            declmouse.setPosition(cpp_pos)
        else:
            declmouse.setPosition(cpp_pos,
                                  (<decl.RenderWindow*>window.p_this)[0])



cdef class Joystick:
    COUNT = decljoy.Count
    BUTTON_COUNT = decljoy.ButtonCount
    AXIS_COUNT = decljoy.AxisCount
    X = decljoy.X
    Y = decljoy.Y
    Z = decljoy.Z
    R = decljoy.R
    U = decljoy.U
    V = decljoy.V
    POV_X = decljoy.PovX
    POV_Y = decljoy.PovY

    @classmethod
    def is_connected(cls, unsigned int joystick):
        return decljoy.isConnected(joystick)

    @classmethod
    def get_button_count(cls, unsigned int joystick):
        return decljoy.getButtonCount(joystick)

    @classmethod
    def has_axis(cls, unsigned int joystick, int axis):
        return decljoy.hasAxis(joystick, <decljoy.Axis>axis)

    @classmethod
    def is_button_pressed(cls, unsigned int joystick, unsigned int button):
        return decljoy.isButtonPressed(joystick, button)

    @classmethod
    def get_axis_position(cls, unsigned int joystick, int axis):
        return decljoy.getAxisPosition(joystick, <decljoy.Axis> axis)

    @classmethod
    def update(cls):
        decljoy.update()


cdef class Keyboard:
    A = declkey.A
    B = declkey.B
    C = declkey.C
    D = declkey.D
    E = declkey.E
    F = declkey.F
    G = declkey.G
    H = declkey.H
    I = declkey.I
    J = declkey.J
    K = declkey.K
    L = declkey.L
    M = declkey.M
    N = declkey.N
    O = declkey.O
    P = declkey.P
    Q = declkey.Q
    R = declkey.R
    S = declkey.S
    T = declkey.T
    U = declkey.U
    V = declkey.V
    W = declkey.W
    X = declkey.X
    Y = declkey.Y
    Z = declkey.Z
    NUM0 = declkey.Num0
    NUM1 = declkey.Num1
    NUM2 = declkey.Num2
    NUM3 = declkey.Num3
    NUM4 = declkey.Num4
    NUM5 = declkey.Num5
    NUM6 = declkey.Num6
    NUM7 = declkey.Num7
    NUM8 = declkey.Num8
    NUM9 = declkey.Num9
    ESCAPE = declkey.Escape
    L_CONTROL = declkey.LControl
    L_SHIFT = declkey.LShift
    L_ALT = declkey.LAlt
    L_SYSTEM = declkey.LSystem
    R_CONTROL = declkey.RControl
    R_SHIFT = declkey.RShift
    R_ALT = declkey.RAlt
    R_SYSTEM = declkey.RSystem
    MENU = declkey.Menu
    L_BRACKET = declkey.LBracket
    R_BRACKET = declkey.RBracket
    SEMI_COLON = declkey.SemiColon
    COMMA = declkey.Comma
    PERIOD = declkey.Period
    QUOTE = declkey.Quote
    SLASH = declkey.Slash
    BACK_SLASH = declkey.BackSlash
    TILDE = declkey.Tilde
    EQUAL = declkey.Equal
    DASH = declkey.Dash
    SPACE = declkey.Space
    RETURN = declkey.Return
    BACK = declkey.Back
    TAB = declkey.Tab
    PAGE_UP = declkey.PageUp
    PAGE_DOWN = declkey.PageDown
    END = declkey.End
    HOME = declkey.Home
    INSERT = declkey.Insert
    DELETE = declkey.Delete
    ADD = declkey.Add
    SUBTRACT = declkey.Subtract
    MULTIPLY = declkey.Multiply
    DIVIDE = declkey.Divide
    LEFT = declkey.Left
    RIGHT = declkey.Right
    UP = declkey.Up
    DOWN = declkey.Down
    NUMPAD0 = declkey.Numpad0
    NUMPAD1 = declkey.Numpad1
    NUMPAD2 = declkey.Numpad2
    NUMPAD3 = declkey.Numpad3
    NUMPAD4 = declkey.Numpad4
    NUMPAD5 = declkey.Numpad5
    NUMPAD6 = declkey.Numpad6
    NUMPAD7 = declkey.Numpad7
    NUMPAD8 = declkey.Numpad8
    NUMPAD9 = declkey.Numpad9
    F1 = declkey.F1
    F2 = declkey.F2
    F3 = declkey.F3
    F4 = declkey.F4
    F5 = declkey.F5
    F6 = declkey.F6
    F7 = declkey.F7
    F8 = declkey.F8
    F9 = declkey.F9
    F10 = declkey.F10
    F11 = declkey.F11
    F12 = declkey.F12
    F13 = declkey.F13
    F14 = declkey.F14
    F15 = declkey.F15
    PAUSE = declkey.Pause
    KEY_COUNT = declkey.KeyCount

    @classmethod
    def is_key_pressed(cls, int key):
        return declkey.isKeyPressed(<declkey.Key>key)



cdef class Style:
    NONE = declstyle.None
    TITLEBAR = declstyle.Titlebar
    RESIZE = declstyle.Resize
    CLOSE = declstyle.Close
    FULLSCREEN = declstyle.Fullscreen
    DEFAULT = declstyle.Default



cdef class IntRect:
    cdef decl.IntRect *p_this

    def __init__(self, int left=0, int top=0, int width=0, int height=0):
        self.p_this = new decl.IntRect(left, top, width, height)

    def __dealloc__(self):
        del self.p_this

    def __repr__(self):
        return ('IntRect(left={0.left!r}, top={0.top!r}, '
                'width={0.width!r}, height={0.height!r})'.format(self))

    def __richcmp__(IntRect x, IntRect y, int op):
        # ==
        if op == 2:
            return (x.left == y.left and
                    x.top == y.top and
                    x.width == y.width and
                    x.height == y.height)
        # !=
        elif op == 3:
            return not x == y

        return NotImplemented

    property left:
        def __get__(self):
            return self.p_this.left

        def __set__(self, int value):
            self.p_this.left = value

    property top:
        def __get__(self):
            return self.p_this.top

        def __set__(self, int value):
            self.p_this.top = value

    property width:
        def __get__(self):
            return self.p_this.width

        def __set__(self, int value):
            self.p_this.width = value

    property height:
        def __get__(self):
            return self.p_this.height

        def __set__(self, int value):
            self.p_this.height = value

    def contains(self, int x, int y):
        return self.p_this.contains(x, y)

    def copy(self):
        return IntRect(self.left, self.top, self.width, self.height)

    def intersects(self, IntRect rect, IntRect intersection=None):
        if intersection is None:
            return self.p_this.intersects(rect.p_this[0])
        else:
            return self.p_this.intersects(rect.p_this[0],
                                          intersection.p_this[0])


cdef IntRect wrap_int_rect_instance(decl.IntRect *p_cpp_instance):
    cdef IntRect ret = IntRect.__new__(IntRect)
    ret.p_this = p_cpp_instance

    return ret


cdef decl.IntRect convert_to_int_rect(value) except *:
    if isinstance(value, IntRect):
        return (<IntRect>value).p_this[0]

    if isinstance(value, tuple):
        return decl.IntRect(value[0], value[1], value[2], value[3])
    
    raise TypeError("Expected IntRect or tuple, found {0}".format(type(value)))





cdef class FloatRect:
    cdef decl.FloatRect *p_this

    def __init__(self, float left=0, float top=0, float width=0,
                  float height=0):
        self.p_this = new decl.FloatRect(left, top, width, height)

    def __dealloc__(self):
        del self.p_this

    def __repr__(self):
        return ('FloatRect(left={0.left!r}, top={0.top!r}, '
                'width={0.width!r}, height={0.height!r})'.format(self))

    def __richcmp__(FloatRect x, FloatRect y, int op):
        # ==
        if op == 2:
            return (x.left == y.left and
                    x.top == y.top and
                    x.width == y.width and
                    x.height == y.height)
        # !=
        elif op == 3:
            return not x == y

        return NotImplemented

    property left:
        def __get__(self):
            return self.p_this.left

        def __set__(self, float value):
            self.p_this.left = value

    property top:
        def __get__(self):
            return self.p_this.top

        def __set__(self, float value):
            self.p_this.top = value

    property width:
        def __get__(self):
            return self.p_this.width

        def __set__(self, float value):
            self.p_this.width = value

    property height:
        def __get__(self):
            return self.p_this.height

        def __set__(self, float value):
            self.p_this.height = value

    def contains(self, int x, int y):
        return self.p_this.contains(x, y)

    def copy(self):
        return FloatRect(self.left, self.top, self.width, self.height)

    def intersects(self, FloatRect rect, FloatRect intersection=None):
        if intersection is None:
            return self.p_this.intersects(rect.p_this[0])
        else:
            return self.p_this.intersects(rect.p_this[0],
                                          intersection.p_this[0])


cdef FloatRect wrap_float_rect_instance(decl.FloatRect *p_cpp_instance):
    cdef FloatRect ret = FloatRect.__new__(FloatRect)
    ret.p_this = p_cpp_instance

    return ret




cdef class Vector2f:
    cdef decl.Vector2f *p_this

    def __cinit__(self, float x=0.0, float y=0.0):
        self.p_this = new decl.Vector2f(x, y)

    def __dealloc__(self):
        del self.p_this

    def __repr__(self):
        return 'Vector2f({0}, {1})'.format(self.x, self.y)

    def __richcmp__(Vector2f a, Vector2f b, int op):
        # ==
        if op == 2:
            return a.x == b.x and a.y == b.y
        # !=
        elif op == 3:
            return a.x != b.x or a.y != b.y

        return NotImplemented

    def __add__(a, b):
        if isinstance(a, Vector2f) and isinstance(b, Vector2f):
            return Vector2f(a.x + b.x, a.y + b.y)

        return NotImplemented

    def __iadd__(self, b):
        if isinstance(b, Vector2f):
            self.p_this.x += b.x
            self.p_this.y += b.y
            return self

        return NotImplemented

    def __sub__(a, b):
        if isinstance(a, Vector2f) and isinstance(b, Vector2f):
            return Vector2f(a.x - b.x, a.y - b.y)

    def __isub__(self, b):
        if isinstance(b, Vector2f):
            self.p_this.x -= b.x
            self.p_this.y -= b.y
            return self

        return NotImplemented

    def __mul__(a, b):
        if isinstance(a, Vector2f) and isinstance(b, (int, float)):
            return Vector2f(a.x * b, a.y * b)
        elif isinstance(a, (int, float)) and isinstance(b, Vector2f):
            return Vector2f(b.x * a, b.y * a)

        return NotImplemented

    def __imul__(self, b):
        if isinstance(b, (int, float)):
            self.p_this.x *= b
            self.p_this.y *= b
            return self

        return NotImplemented

    def __div__(a, b):
        if isinstance(a, Vector2f) and isinstance(b, (int, float)):
            return Vector2f(a.x / <float>b, a.y / <float>b)

        return NotImplemented

    # / method for Python 3
    def __truediv__(a, b):
        if isinstance(a, Vector2f) and isinstance(b, (int, float)):
            return Vector2f(a.x / <float>b, a.y / <float>b)

        return NotImplemented

    def __idiv__(self, b):
        if isinstance(b, (int, float)):
            self.p_this.x /= <float>b
            self.p_this.y /= <float>b
            return self

        return NotImplemented

    # /= method for Python 3
    def __itruediv__(self, b):
        if isinstance(b, (int, float)):
            self.p_this.x /= <float>b
            self.p_this.y /= <float>b
            return self

        return NotImplemented

    def copy(self):
        return Vector2f(self.p_this.x, self.p_this.y)

    property x:
        def __get__(self):
            return self.p_this.x

        def __set__(self, float value):
            self.p_this.x = value

    property y:
        def __get__(self):
            return self.p_this.y

        def __set__(self, float value):
            self.p_this.y = value


cdef public decl.Vector2f convert_to_vector2f(value) except *:
    if isinstance(value, Vector2f):
        return (<Vector2f>value).p_this[0]

    if isinstance(value, tuple):
        return decl.Vector2f(value[0], value[1])
    
    raise TypeError("Expected Vector2f or tuple, found {0}".format(type(value)))




cdef class Transform:
    cdef decl.Transform *p_this

    IDENTITY = wrap_transform_instance(
        new decl.Transform(decl.Transform_Identity))

    def __init__(self, *args):
        if len(args) == 0:
            self.p_this = new decl.Transform()
        elif len(args) == 9:
            a = args
            self.p_this = new decl.Transform(a[0], a[1], a[2],
                                             a[3], a[4], a[5],
                                             a[6], a[7], a[8])
        else:
            raise TypeError(
                "Transform takes 0 or 9 arguments, received {0}"
                .format(len(args)))

    def __dealloc__(self):
        del self.p_this

    def __str__(self):
        cdef float *p

        p = <float*>self.p_this.getMatrix()

        return ('[{0} {4} {8} {12}]\n'
                '[{1} {5} {9} {13}]\n'
                '[{2} {6} {10} {14}]\n'
                '[{3} {7} {11} {15}]'
                .format(p[0], p[1], p[2], p[3],
                        p[4], p[5], p[6], p[7],
                        p[8], p[9], p[10], p[11],
                        p[12], p[13], p[14], p[15]))

    def __mul__(a, b):
        cdef decl.Transform *p_t
        cdef decl.Vector2f *p_v

        if isinstance(a, Vector2f) and isinstance(b, Transform):
            a, b = b, a

        if isinstance(a, Transform):
            if isinstance(b, Transform):
                p_t = new decl.Transform()

                p_t[0] = ((<Transform>a).p_this[0] *
                          (<Transform>b).p_this[0])

                return wrap_transform_instance(p_t)
            elif isinstance(b, Vector2f):
                p_v = new decl.Vector2f()

                p_v[0] = ((<Transform>a).p_this[0] *
                        (<Vector2f>b).p_this[0])

                return Vector2f(p_v.x, p_v.y)

        return NotImplemented

    def __imul__(self, b):
        if isinstance(b, Transform):
            self.p_this[0] *= (<Transform>b).p_this[0]
            return self

        return NotImplemented

    property matrix:
        def __get__(self):
            cdef float *p = <float*>self.p_this.getMatrix()
            cdef ret = []

            for i in range(16):
                ret.append(p[0])
                p += 1

            return ret

    def combine(self, Transform transform):
        cdef decl.Transform *p = new decl.Transform()

        p[0] = self.p_this.combine(transform.p_this[0])

        return wrap_transform_instance(p)

    def copy(self):
        cdef decl.Transform *p = new decl.Transform(self.p_this[0])

        return wrap_transform_instance(p)

    def get_inverse(self):
        cdef decl.Transform *p = new decl.Transform()

        p[0] = self.p_this.getInverse()

        return wrap_transform_instance(p)

    def rotate(self, object angle, object center_x=None, object center_y=None):
        if center_x is None and center_y is None:
            self.p_this.rotate(<float?>angle)
        elif center_x is not None and center_y is not None:
            self.p_this.rotate(<float?>angle, <float?>center_x,
                               <float?>center_y)
        else:
            raise PySFMLException(
                "You must provide either 1 float or 3 floats are arguments")

        return self

    def scale(self, float scale_x, float scale_y,
              object center_x=None, object center_y=None):
        if center_x is None and center_y is None:
            self.p_this.scale(scale_x, scale_y)
        elif center_x is not None and center_y is not None:
            self.p_this.scale(scale_x, scale_y, <float?>center_x,
                              <float?>center_y)
        else:
            raise PySFMLException(
                "You must provide either 2 floats or 4 floats as arguments")

        return self

    def transform_point(self, float x, float y):
        cdef decl.Vector2f v = self.p_this.transformPoint(x, y)

        return (v.x, v.y)

    def transform_rect(self, FloatRect rectangle):
        cdef decl.FloatRect *p = new decl.FloatRect()

        p[0] = self.p_this.transformRect(rectangle.p_this[0])

        return wrap_float_rect_instance(p)

    def translate(self, float x, float y):
        self.p_this.translate(x, y)

        return self


cdef Transform wrap_transform_instance(decl.Transform *p_cpp_instance):
    cdef Transform ret = Transform.__new__(Transform)

    ret.p_this = p_cpp_instance

    return ret





cdef class Time:
    cdef decl.Time *p_this
    ZERO = wrap_time_instance(new decl.Time(decl.Time_Zero))

    def __init__(self, float seconds=-1.0, int milliseconds=-1,
                 int microseconds=-1):
        self.p_this = new decl.Time()

        if seconds != -1.0:
            self.p_this[0] = decl.Time_seconds(seconds)
        elif milliseconds != -1:
            self.p_this[0] = decl.Time_milliseconds(milliseconds)
        elif microseconds != -1:
            self.p_this[0] = decl.Time_microseconds(microseconds)

    def __dealloc__(self):
        del self.p_this

    def __str__(self):
        return 'Time ({0} seconds)'.format(self.as_seconds())

    def __repr__(self):
        return 'Time(microseconds={0})'.format(self.as_microseconds())

    def __richcmp__(Time x, Time y, int op):
        # ==
        if op == 2:
            return x.p_this[0] == y.p_this[0]

        # !=
        elif op == 3:
            return x.p_this[0] != y.p_this[0]

        # <
        elif op == 0:
            return x.p_this[0] < y.p_this[0]
        # >
        elif op == 4:
            return x.p_this[0] > y.p_this[0]

        # <=
        elif op == 1:
            return x.p_this[0] <= y.p_this[0]
        # >=
        elif op == 5:
            return x.p_this[0] >= y.p_this[0]

        return NotImplemented

    def __add__(a, b):
        if isinstance(a, Time) and isinstance(b, Time):
            return Time(microseconds=a.as_microseconds() + b.as_microseconds())

        return NotImplemented

    def __sub__(a, b):
        if isinstance(a, Time) and isinstance(b, Time):
            return Time(microseconds=a.as_microseconds() - b.as_microseconds())

        return NotImplemented

    def __mul__(a, b):
        if isinstance(a, (int, float)) and isinstance(b, Time):
            a, b = b, a

        if isinstance(a, Time):
            if isinstance(b, int):
                return Time(microseconds=a.as_microseconds() * b)
            if isinstance(b, float):
                return Time(seconds=a.as_seconds() * b)

        return NotImplemented

    def __div__(a, b):
        if isinstance(a, (int, float)) and isinstance(b, Time):
            a, b = b, a

        if isinstance(a, Time):
            if isinstance(b, int):
                return Time(microseconds=a.as_microseconds() / b)
            if isinstance(b, float):
                return Time(seconds=a.as_seconds() / b)

        return NotImplemented

    # / method for Python 3
    def __truediv__(a, b):
        if isinstance(a, (int, float)) and isinstance(b, Time):
            a, b = b, a

        if isinstance(a, Time):
            if isinstance(b, int):
                return Time(microseconds=a.as_microseconds() / b)
            if isinstance(b, float):
                return Time(seconds=a.as_seconds() / b)

        return NotImplemented

    def __neg__(self):
        return Time(microseconds=-self.p_this.asMicroseconds())

    def as_seconds(self):
        return self.p_this.asSeconds()

    def as_milliseconds(self):
        return <int>self.p_this.asMilliseconds()

    def as_microseconds(self):
        return self.p_this.asMicroseconds()

    def copy(self):
        return Time(microseconds=self.as_microseconds())


cdef public object wrap_time_instance(decl.Time *p_cpp_instance):
    cdef Time ret = Time.__new__(Time)

    ret.p_this = p_cpp_instance

    return ret



cdef class Clock:
    cdef decl.Clock *p_this

    def __cinit__(self):
        self.p_this = new decl.Clock()

    def __dealloc__(self):
        del self.p_this

    property elapsed_time:
        def __get__(self):
            cdef decl.Time *p = new decl.Time()

            p[0] = self.p_this.getElapsedTime()

            return wrap_time_instance(p)

    def restart(self):
        return wrap_time_instance(new decl.Time(self.p_this.restart()))



cdef class Color:
    BLACK = Color(0, 0, 0)
    WHITE = Color(255, 255, 255)
    RED = Color(255, 0, 0)
    GREEN = Color(0, 255, 0)
    BLUE = Color(0, 0, 255)
    YELLOW = Color(255, 255, 0)
    MAGENTA = Color(255, 0, 255)
    CYAN = Color(0, 255, 255)

    cdef decl.Color *p_this

    def __init__(self, int r, int g, int b, int a=255):
        self.p_this = new decl.Color(r, g, b, a)

    def __dealloc__(self):
        del self.p_this

    def __repr__(self):
        return 'Color({0.r}, {0.g}, {0.b}, {0.a})'.format(self)

    def __richcmp__(Color x, Color y, int op):
        # ==
        if op == 2:
            return (x.r == y.r and
                    x.g == y.g and
                    x.b == y.b and
                    x.a == y.a)
        # !=
        elif op == 3:
            return not x == y

        return NotImplemented

    def __add__(x, y):
        if isinstance(x, Color) and isinstance(y, Color):
            return Color(min(x.r + y.r, 255),
                         min(x.g + y.g, 255),
                         min(x.b + y.b, 255),
                         min(x.a + y.a, 255))

        return NotImplemented

    def __mul__(x, y):
        if isinstance(x, Color) and isinstance(y, Color):
            return Color(x.r * y.r / 255,
                         x.g * y.g / 255,
                         x.b * y.b / 255,
                         x.a * y.a / 255)

        return NotImplemented

    property r:
        def __get__(self):
            return self.p_this.r

        def __set__(self, unsigned int value):
            self.p_this.r = value

    property g:
        def __get__(self):
            return self.p_this.g

        def __set__(self, unsigned int value):
            self.p_this.g = value

    property b:
        def __get__(self):
            return self.p_this.b

        def __set__(self, unsigned int value):
            self.p_this.b = value

    property a:
        def __get__(self):
            return self.p_this.a

        def __set__(self, unsigned int value):
            self.p_this.a = value

    def copy(self):
        return Color(self.r, self.g, self.b, self.a)


cdef Color wrap_color_instance(decl.Color *p_cpp_instance):
    cdef Color ret = Color.__new__(Color)
    ret.p_this = p_cpp_instance

    return ret




cdef class Listener:
    def __init__(self):
        raise NotImplementedError("This class only contains static methods")

    @classmethod
    def get_direction(cls):
        cdef decl.Vector3f d = declaudio.Listener_getDirection()

        return (d.x, d.y, d.z)

    @classmethod
    def get_global_volume(cls):
        return declaudio.Listener_getGlobalVolume()

    @classmethod
    def get_position(cls):
        cdef decl.Vector3f pos = declaudio.Listener_getPosition()

        return (pos.x, pos.y, pos.z)

    @classmethod
    def set_global_volume(cls, float volume):
        declaudio.Listener_setGlobalVolume(volume)

    @classmethod
    def set_direction(cls, float x, float y, float z):
        declaudio.Listener_setDirection(x, y, z)

    @classmethod
    def set_position(cls, float x, float y, float z):
        declaudio.Listener_setPosition(x, y, z)



cdef class SoundBuffer:
    cdef declaudio.SoundBuffer *p_this
    cdef bint delete_this

    def __init__(self):
        # self.delete_this = True
        raise NotImplementedError("Use static methods like load_from_file "
                                  "to create SoundBuffer instances")

    def __dealloc__(self):
        if self.delete_this:
            del self.p_this

    property channel_count:
        def __get__(self):
            return <int>self.p_this.getChannelCount()

    property duration:
        def __get__(self):
            cdef decl.Time *p = new decl.Time()

            p[0] = self.p_this.getDuration()

            return wrap_time_instance(p)

    property sample_rate:
        def __get__(self):
            return <int>self.p_this.getSampleRate()

    property samples:
        def __get__(self):
            cdef char *c_string = <char*>self.p_this.getSamples()
            cdef bytes ret = c_string[:self.p_this.getSampleCount()]

            return ret

    @classmethod
    def load_from_file(cls, filename):
        cdef declaudio.SoundBuffer *p = new declaudio.SoundBuffer()
        cdef char *c_filename

        if isinstance(filename, str):
            py_filename = filename.encode(default_encoding)
            c_filename = py_filename
        else:
            c_filename = <bytes?>filename

        if p.loadFromFile(c_filename):
            return wrap_sound_buffer_instance(p, True)

        raise PySFMLException()

    @classmethod
    def load_from_memory(cls, bytes data):
        cdef declaudio.SoundBuffer *p = new declaudio.SoundBuffer()

        if p.loadFromMemory(<char*>data, len(data)):
            return wrap_sound_buffer_instance(p, True)

        raise PySFMLException()

    @classmethod
    def load_from_samples(cls, bytes samples, unsigned int channel_count,
                          unsigned int sample_rate):
        cdef declaudio.SoundBuffer *p = new declaudio.SoundBuffer()

        if p.loadFromSamples(<decl.Int16*>(<char*>samples), len(samples),
                             channel_count, sample_rate):
            return wrap_sound_buffer_instance(p, True)
        else:
            raise PySFMLException()

    def save_to_file(self, filename):
        cdef char *c_filename

        if isinstance(filename, str):
            py_filename = filename.encode(default_encoding)
            c_filename = py_filename
        else:
            c_filename = <bytes?>filename

        if not self.p_this.saveToFile(c_filename):
            raise PySFMLException()


cdef SoundBuffer wrap_sound_buffer_instance(
    declaudio.SoundBuffer *p_cpp_instance, bint delete_this):
    cdef SoundBuffer ret = SoundBuffer.__new__(SoundBuffer)

    ret.p_this = p_cpp_instance
    ret.delete_this = delete_this

    return ret




cdef class Sound:
    cdef SoundBuffer buffer
    cdef declaudio.Sound *p_this

    STOPPED = declaudio.Stopped
    PAUSED = declaudio.Paused
    PLAYING = declaudio.Playing

    def __cinit__(self, SoundBuffer buffer=None):
        if buffer is None:
            self.p_this = new declaudio.Sound()
            self.buffer = None
        else:
            self.buffer = buffer
            self.p_this = new declaudio.Sound(buffer.p_this[0])

    def __dealloc__(self):
        del self.p_this

    property attenuation:
        def __get__(self):
            return self.p_this.getAttenuation()

        def __set__(self, float value):
            self.p_this.setAttenuation(value)

    property buffer:
        def __get__(self):
            return self.buffer

        def __set__(self, SoundBuffer value):
            self.buffer = value
            self.p_this.setBuffer(value.p_this[0])

    property loop:
        def __get__(self):
            return self.p_this.getLoop()

        def __set__(self, bint value):
            self.p_this.setLoop(value)

    property min_distance:
        def __get__(self):
            return self.p_this.getMinDistance()

        def __set__(self, float value):
            self.p_this.setMinDistance(value)

    property pitch:
        def __get__(self):
            return self.p_this.getPitch()

        def __set__(self, float value):
            self.p_this.setPitch(value)

    property playing_offset:
        def __get__(self):
            cdef decl.Time *p = new decl.Time()

            p[0] = self.p_this.getPlayingOffset()

            return wrap_time_instance(p)

        def __set__(self, Time value):
            self.p_this.setPlayingOffset(value.p_this[0])

    property position:
        def __get__(self):
            cdef decl.Vector3f pos = self.p_this.getPosition()

            return (pos.x, pos.y, pos.z)

        def __set__(self, tuple value):
            x, y, z = value
            self.p_this.setPosition(x, y, z)

    property relative_to_listener:
        def __get__(self):
            return self.p_this.isRelativeToListener()

        def __set__(self, bint value):
            self.p_this.setRelativeToListener(value)

    property status:
        def __get__(self):
            return <int>self.p_this.getStatus()

    property volume:
        def __get__(self):
            return self.p_this.getVolume()

        def __set__(self, float value):
            self.p_this.setVolume(value)

    def pause(self):
        self.p_this.pause()

    def play(self):
        self.p_this.play()

    def stop(self):
        self.p_this.stop()




cdef class Chunk:
    cdef declaudio.Chunk *p_this
    cdef bint delete_this
    cdef object py_string

    def __init__(self):
        self.p_this = new declaudio.Chunk()
        self.delete_this = True
        self.py_string = None

    def __dealloc__(self):
        if self.delete_this:
            del self.p_this

    property samples:
        def __get__(self):
            return self.py_string

        def __set__(self, bytes value):
            cdef char *c_string = value

            self.py_string = value
            self.p_this.samples = <decl.Int16*>c_string
            self.p_this.sampleCount = len(value)
                

cdef public object wrap_chunk_instance(declaudio.Chunk *p, bint delete_this):
    cdef Chunk ret = Chunk.__new__(Chunk)

    ret.p_this = p
    ret.p_this.samples = NULL
    ret.delete_this = delete_this

    return ret



cdef class SoundStream:
    cdef declaudio.SoundStream *p_this

    PAUSED = declaudio.Paused
    PLAYING = declaudio.Playing
    STOPPED = declaudio.Stopped

    def __init__(self):
        if self.__class__ == SoundStream:
            raise NotImplementedError("SoundStream is abstract")

        self.p_this = <declaudio.SoundStream*>new decl.CppSoundStream(
            <void*>self)

    def __dealloc__(self):
        del self.p_this

    property attenuation:
        def __get__(self):
            return self.p_this.getAttenuation()

        def __set__(self, float value):
            self.p_this.setAttenuation(value)

    property channel_count:
        def __get__(self):
            return self.p_this.getChannelCount()

    property loop:
        def __get__(self):
            return self.p_this.getLoop()

        def __set__(self, bint value):
            self.p_this.setLoop(value)

    property min_distance:
        def __get__(self):
            return self.p_this.getMinDistance()

        def __set__(self, float value):
            self.p_this.setMinDistance(value)

    property pitch:
        def __get__(self):
            return self.p_this.getPitch()

        def __set__(self, float value):
            self.p_this.setPitch(value)

    property playing_offset:
        def __get__(self):
            cdef decl.Time *p = new decl.Time()

            p[0] = self.p_this.getPlayingOffset()

            return wrap_time_instance(p)

        def __set__(self, Time value):
            self.p_this.setPlayingOffset(value.p_this[0])

    property position:
        def __get__(self):
            cdef decl.Vector3f pos = self.p_this.getPosition()

            return (pos.x, pos.y, pos.z)

        def __set__(self, tuple value):
            x, y, z = value
            self.p_this.setPosition(x, y, z)

    property relative_to_listener:
        def __get__(self):
            return self.p_this.isRelativeToListener()

        def __set__(self, bint value):
            self.p_this.setRelativeToListener(value)

    property sample_rate:
        def __get__(self):
            return self.p_this.getSampleRate()

    property status:
        def __get__(self):
            return <int>self.p_this.getStatus()

    property volume:
        def __get__(self):
            return self.p_this.getVolume()

        def __set__(self, float value):
            self.p_this.setVolume(value)

    def initialize(self, int channel_count, int sample_rate):
        (<decl.CppSoundStream*>self.p_this).initialize(channel_count,
                                                       sample_rate)

    def pause(self):
        self.p_this.pause()

    def play(self):
        self.p_this.play()

    def stop(self):
        self.p_this.stop()



cdef class Music(SoundStream):
    def __init__(self):
        raise NotImplementedError(
            "Use class methods like open_from_file() or open_from_memory() "
            "to create Music objects")

    property duration:
        def __get__(self):
            cdef decl.Time *p = new decl.Time()

            p[0] = (<declaudio.Music*>self.p_this).getDuration()

            return wrap_time_instance(p)

    @classmethod
    def open_from_file(cls, filename):
        cdef declaudio.Music *p = new declaudio.Music()
        cdef char *c_filename

        if isinstance(filename, str):
            py_filename = filename.encode(default_encoding)
            c_filename = py_filename
        else:
            c_filename = <bytes?>filename

        if p.openFromFile(c_filename):
            return wrap_music_instance(p)

        raise PySFMLException()

    @classmethod
    def open_from_memory(cls, bytes data):
        cdef declaudio.Music *p = new declaudio.Music()

        if p.openFromMemory(<char*>data, len(data)):
            return wrap_music_instance(p)

        raise PySFMLException()

    def initialize(self, int channel_count, int sample_rate):
        raise NotImplementedError(
            "You can only call initialize() if you create a class derived "
            "from SoundStream")


cdef Music wrap_music_instance(declaudio.Music *p_cpp_instance):
    cdef Music ret = Music.__new__(Music)

    ret.p_this = <declaudio.SoundStream*>p_cpp_instance

    return ret



class Event:
    CLOSED = declevent.Closed
    RESIZED = declevent.Resized
    LOST_FOCUS = declevent.LostFocus
    GAINED_FOCUS = declevent.GainedFocus
    TEXT_ENTERED = declevent.TextEntered
    KEY_PRESSED = declevent.KeyPressed
    KEY_RELEASED = declevent.KeyReleased
    MOUSE_WHEEL_MOVED = declevent.MouseWheelMoved
    MOUSE_BUTTON_PRESSED = declevent.MouseButtonPressed
    MOUSE_BUTTON_RELEASED = declevent.MouseButtonReleased
    MOUSE_MOVED = declevent.MouseMoved
    MOUSE_ENTERED = declevent.MouseEntered
    MOUSE_LEFT = declevent.MouseLeft
    JOYSTICK_BUTTON_PRESSED = declevent.JoystickButtonPressed
    JOYSTICK_BUTTON_RELEASED = declevent.JoystickButtonReleased
    JOYSTICK_MOVED = declevent.JoystickMoved
    JOYSTICK_CONNECTED = declevent.JoystickConnected
    JOYSTICK_DISCONNECTED = declevent.JoystickDisconnected
    COUNT = declevent.Count

    NAMES = {
        CLOSED: 'Closed',
        RESIZED: 'Resized',
        LOST_FOCUS: 'Lost focus',
        GAINED_FOCUS: 'Gained focus',
        TEXT_ENTERED: 'Text entered',
        KEY_PRESSED: 'Key pressed',
        KEY_RELEASED: 'Key released',
        MOUSE_WHEEL_MOVED: 'Mouse wheel moved',
        MOUSE_BUTTON_PRESSED: 'Mouse button pressed',
        MOUSE_BUTTON_RELEASED: 'Mouse button released',
        MOUSE_MOVED: 'Mouse moved',
        MOUSE_ENTERED: 'Mouse entered',
        MOUSE_LEFT: 'Mouse left',
        JOYSTICK_BUTTON_PRESSED: 'Joystick button pressed',
        JOYSTICK_BUTTON_RELEASED: 'Joystick button released',
        JOYSTICK_MOVED: 'Joystick moved',
        JOYSTICK_CONNECTED: 'Joystick connected',
        JOYSTICK_DISCONNECTED: 'Joystick disconnected'
        }

    def __str__(self):
        name = self.NAMES[self.type]
        format = ''

        if self.type == self.RESIZED:
            format = ' (width={0.width}, height={0.height})'
        elif self.type == self.TEXT_ENTERED:
            format = ' (unicode={0.unicode!r})'
        elif self.type in (self.KEY_PRESSED, self.KEY_RELEASED):
            format = (' (code={0.code}, alt={0.alt}, control={0.control}, '
                      'shift={0.shift}, system={0.system})')
        elif self.type == self.MOUSE_WHEEL_MOVED:
            format = ' (delta={0.delta}, x={0.x}, y={0.y})'
        elif self.type in (self.MOUSE_BUTTON_PRESSED,
                           self.MOUSE_BUTTON_RELEASED):
            format = ' (button={0.button}, x={0.x}, y={0.y})'
        elif self.type == self.MOUSE_MOVED:
            format = ' (x={0.x}, y={0.y})'
        elif self.type in (self.JOYSTICK_BUTTON_PRESSED,
                           self.JOYSTICK_BUTTON_RELEASED):
            format = ' (joystick_id={0.joystick_id}, button={0.button})'
        elif self.type == self.JOYSTICK_MOVED:
            format = (' (joystick_id={0.joystick_id}, axis={0.axis}, '
                      'position={0.position})')
        elif self.type in (self.JOYSTICK_CONNECTED, self.JOYSTICK_DISCONNECTED):
            format = (' (joystick_id={0.joystick_id)')

        return name + format.format(self)


# Create an Python Event object that matches the C++ object
# by dynamically setting the corresponding attributes.
cdef wrap_event_instance(decl.Event *p_cpp_instance):
    cdef ret = Event()
    cdef decl.Uint32 code

    # Set the type
    if p_cpp_instance.type == declevent.Closed:
        ret.type = Event.CLOSED
    elif p_cpp_instance.type == declevent.KeyPressed:
        ret.type = Event.KEY_PRESSED
    elif p_cpp_instance.type == declevent.KeyReleased:
        ret.type = Event.KEY_RELEASED
    elif p_cpp_instance.type == declevent.Resized:
        ret.type = Event.RESIZED
    elif p_cpp_instance.type == declevent.TextEntered:
        ret.type = Event.TEXT_ENTERED
    elif p_cpp_instance.type == declevent.MouseButtonPressed:
        ret.type = Event.MOUSE_BUTTON_PRESSED
    elif p_cpp_instance.type == declevent.MouseButtonReleased:
        ret.type = Event.MOUSE_BUTTON_RELEASED
    elif p_cpp_instance.type == declevent.MouseMoved:
        ret.type = Event.MOUSE_MOVED
    elif p_cpp_instance.type == declevent.LostFocus:
        ret.type = Event.LOST_FOCUS
    elif p_cpp_instance.type == declevent.GainedFocus:
        ret.type = Event.GAINED_FOCUS
    elif p_cpp_instance.type == declevent.MouseWheelMoved:
        ret.type = Event.MOUSE_WHEEL_MOVED
    elif p_cpp_instance.type == declevent.MouseMoved:
        ret.type = Event.MOUSE_MOVED
    elif p_cpp_instance.type == declevent.MouseEntered:
        ret.type = Event.MOUSE_ENTERED
    elif p_cpp_instance.type == declevent.MouseLeft:
        ret.type = Event.MOUSE_LEFT
    elif p_cpp_instance.type == declevent.JoystickButtonPressed:
        ret.type = Event.JOYSTICK_BUTTON_PRESSED
    elif p_cpp_instance.type == declevent.JoystickButtonReleased:
        ret.type = Event.JOYSTICK_BUTTON_RELEASED
    elif p_cpp_instance.type == declevent.JoystickMoved:
        ret.type = Event.JOYSTICK_MOVED
    elif p_cpp_instance.type == declevent.JoystickConnected:
        ret.type = Event.JOYSTICK_CONNECTED
    elif p_cpp_instance.type == declevent.JoystickDisconnected:
        ret.type = Event.JOYSTICK_DISCONNECTED

    # Set other attributes if needed
    if p_cpp_instance.type == declevent.Resized:
        ret.width = p_cpp_instance.size.width
        ret.height = p_cpp_instance.size.height
    elif p_cpp_instance.type == declevent.TextEntered:
        code = p_cpp_instance.text.unicode
        ret.unicode = ((<char*>&code)[:4]).decode('utf-32-le')
    elif (p_cpp_instance.type == declevent.KeyPressed or
          p_cpp_instance.type == declevent.KeyReleased):
        ret.code = p_cpp_instance.key.code
        ret.alt = p_cpp_instance.key.alt
        ret.control = p_cpp_instance.key.control
        ret.shift = p_cpp_instance.key.shift
        ret.system = p_cpp_instance.key.system
    elif (p_cpp_instance.type == declevent.MouseButtonPressed or
          p_cpp_instance.type == declevent.MouseButtonReleased):
        ret.button = p_cpp_instance.mouseButton.button
        ret.x = p_cpp_instance.mouseButton.x
        ret.y = p_cpp_instance.mouseButton.y
    elif p_cpp_instance.type == declevent.MouseMoved:
        ret.x = p_cpp_instance.mouseMove.x
        ret.y = p_cpp_instance.mouseMove.y
    elif p_cpp_instance.type == declevent.MouseWheelMoved:
        ret.delta = p_cpp_instance.mouseWheel.delta
        ret.x = p_cpp_instance.mouseWheel.x
        ret.y = p_cpp_instance.mouseWheel.y
    elif (p_cpp_instance.type == declevent.JoystickButtonPressed or
          p_cpp_instance.type == declevent.JoystickButtonReleased):
        ret.joystick_id = p_cpp_instance.joystickButton.joystickId
        ret.button = p_cpp_instance.joystickButton.button
    elif p_cpp_instance.type == declevent.JoystickMoved:
        ret.joystick_id = p_cpp_instance.joystickMove.joystickId
        ret.axis = p_cpp_instance.joystickMove.axis
        ret.position = p_cpp_instance.joystickMove.position
    elif p_cpp_instance.type == declevent.JoystickConnected:
        ret.joystick_id = p_cpp_instance.joystickConnect.joystickId
    elif p_cpp_instance.type == declevent.JoystickDisconnected:
        ret.joystick_id = p_cpp_instance.joystickConnect.joystickId

    return ret



cdef class Glyph:
    cdef decl.Glyph *p_this

    def __init__(self):
        self.p_this = new decl.Glyph()

    def __dealloc__(self):
        del self.p_this

    property advance:
        def __get__(self):
            return self.p_this.advance

    property bounds:
        def __get__(self):
            cdef decl.IntRect *p = new decl.IntRect()

            p[0] = self.p_this.bounds

            return wrap_int_rect_instance(p)

    property texture_rect:
        def __get__(self):
            cdef decl.IntRect *p = new decl.IntRect()

            p[0] = self.p_this.textureRect

            return wrap_int_rect_instance(p)


cdef Glyph wrap_glyph_instance(decl.Glyph *p_cpp_instance):
    cdef Glyph ret = Glyph.__new__(Glyph)

    ret.p_this = p_cpp_instance

    return ret





cdef class Font:
    cdef decl.Font *p_this
    cdef bint delete_this

    DEFAULT_FONT = wrap_font_instance(
        <decl.Font*>&decl.Font_getDefaultFont(), False)

    def __init__(self):
        self.delete_this = False
        raise NotImplementedError(
            "Use class methods like load_from_file() to load your fonts")

    def __dealloc__(self):
        if self.delete_this:
            del self.p_this

    @classmethod
    def load_from_file(cls, filename):
        cdef decl.Font *p = new decl.Font()
        cdef char *c_filename

        if isinstance(filename, str):
            py_filename = filename.encode(default_encoding)
            c_filename = py_filename
        else:
            c_filename = <bytes?>filename

        if p.loadFromFile(c_filename):
            return wrap_font_instance(p, True)

        raise PySFMLException()

    @classmethod
    def load_from_memory(cls, bytes data):
        cdef decl.Font *p = new decl.Font()

        if p.loadFromMemory(<char*>data, len(data)):
            return wrap_font_instance(p, True)

        raise PySFMLException()

    def get_glyph(self, unsigned int code_point, unsigned int character_size,
                  bint bold):
        cdef decl.Glyph *p = new decl.Glyph()

        p[0] = self.p_this.getGlyph(code_point, character_size, bold)

        return wrap_glyph_instance(p)

    def get_texture(self, unsigned int character_size):
        cdef decl.Texture *p = <decl.Texture*>&self.p_this.getTexture(
            character_size)

        return wrap_texture_instance(p, False)

    def get_kerning(self, unsigned int first, unsigned int second,
                    unsigned int character_size):
        return self.p_this.getKerning(first, second, character_size)

    def get_line_spacing(self, unsigned int character_size):
        return self.p_this.getLineSpacing(character_size)


cdef Font wrap_font_instance(decl.Font *p_cpp_instance, bint delete_this):
    cdef Font ret = Font.__new__(Font)

    ret.p_this = p_cpp_instance
    ret.delete_this = delete_this

    return ret





cdef class Image:
    cdef decl.Image *p_this
    cdef bint delete_this

    def __init__(self, int width, int height, Color color=None):
        self.p_this = new decl.Image()
        self.delete_this = True

        if color is None:
            self.p_this.create(width, height)
        else:
            self.p_this.create(width, height, color.p_this[0])

    def __dealloc__(self):
        if self.delete_this:
            del self.p_this

    def __getitem__(self, coords):
        cdef decl.Vector2f v = convert_to_vector2f(coords)

        return self.get_pixel(v.x, v.y)

    def __setitem__(self, coords, Color color):
        cdef decl.Vector2f v = convert_to_vector2f(coords)

        self.set_pixel(v.x, v.y, color)

    property height:
        def __get__(self):
            return self.size[1]

    property size:
        def __get__(self):
            cdef decl.Vector2u size = self.p_this.getSize()

            return (size.x, size.y)

    property width:
        def __get__(self):
            return self.size[0]

    @classmethod
    def load_from_file(cls, char *filename):
        cdef decl.Image *p_cpp_instance = new decl.Image()

        if p_cpp_instance.loadFromFile(filename):
            return wrap_image_instance(p_cpp_instance, True)

        raise PySFMLException()

    @classmethod
    def load_from_memory(cls, bytes mem):
        cdef decl.Image *p_cpp_instance = new decl.Image()

        if p_cpp_instance.loadFromMemory(<char*>mem, len(mem)):
            return wrap_image_instance(p_cpp_instance, True)

        raise PySFMLException()

    @classmethod
    def load_from_pixels(cls, int width, int height, bytes pixels):
        cdef decl.Image *p_cpp_instance = new decl.Image()

        p_cpp_instance.create(width, height, <unsigned char*>pixels)

        return wrap_image_instance(p_cpp_instance, True)

    def copy(self, Image source, int dest_x, int dest_y,
             source_rect=None, bint apply_alpha=None):
        cdef decl.IntRect cpp_source_rect

        if source_rect is None:
            self.p_this.copy(source.p_this[0], dest_x, dest_y)
        else:
            if isinstance(source_rect, tuple):
                cpp_source_rect = decl.IntRect(source_rect[0],
                                               source_rect[1],
                                               source_rect[2],
                                               source_rect[3])
            elif isinstance(source_rect, IntRect):
                cpp_source_rect = (<IntRect>source_rect).p_this[0]
            else:
                raise TypeError('source_rect must be tuple or IntRect')

            if apply_alpha is None:
                self.p_this.copy(source.p_this[0], dest_x, dest_y,
                                 cpp_source_rect)
            else:
                self.p_this.copy(source.p_this[0], dest_x, dest_y,
                                 cpp_source_rect, apply_alpha)

    def create_mask_from_color(self, Color color, int alpha=0):
        self.p_this.createMaskFromColor(color.p_this[0], alpha)

    def get_pixel(self, int x, int y):
        cdef decl.Color *p_color = new decl.Color()
        cdef decl.Color temp = self.p_this.getPixel(x, y)

        p_color[0] = temp

        return wrap_color_instance(p_color)

    def get_pixels(self):
        cdef char* p = <char*>self.p_this.getPixelsPtr()
        cdef int length = self.width * self.height * 4
        cdef bytes ret = p[:length]

        return ret

    def save_to_file(self, filename):
        cdef char *c_filename

        if isinstance(filename, str):
            py_filename = filename.encode(default_encoding)
            c_filename = py_filename
        else:
            c_filename = <bytes?>filename

        self.p_this.saveToFile(c_filename)

    def set_pixel(self, int x, int y, Color color):
        self.p_this.setPixel(x, y, color.p_this[0])


cdef Image wrap_image_instance(decl.Image *p_cpp_instance, bint delete_this):
    cdef Image ret = Image.__new__(Image)
    ret.p_this = p_cpp_instance
    ret.delete_this = delete_this

    return ret





cdef class Texture:
    cdef decl.Texture *p_this
    cdef bint delete_this

    MAXIMUM_SIZE = decl.Texture_getMaximumSize()

    def __init__(self, unsigned int width=0, unsigned int height=0):
        self.p_this = new decl.Texture()
        self.delete_this = True

        if width > 0 and height > 0:
            if self.p_this.create(width, height) != True:
                raise PySFMLException()

    def __dealloc__(self):
        if self.delete_this:
            del self.p_this

    property height:
        def __get__(self):
            return self.size[1]

    property repeated:
        def __get__(self):
            return self.p_this.isRepeated()

        def __set__(self, bint value):
            self.p_this.setRepeated(value)

    property size:
        def __get__(self):
            cdef decl.Vector2u size = self.p_this.getSize()

            return (size.x, size.y)

    property smooth:
        def __get__(self):
            return self.p_this.isSmooth()

        def __set__(self, bint value):
            self.p_this.setSmooth(value)

    property width:
        def __get__(self):
            return self.size[0]

    @classmethod
    def load_from_file(cls, filename, object area=None):
        cdef decl.IntRect cpp_rect
        cdef decl.Texture *p_cpp_instance = new decl.Texture()
        cdef char *c_filename

        if isinstance(filename, str):
            py_filename = filename.encode(default_encoding)
            c_filename = py_filename
        else:
            c_filename = <bytes?>filename

        if area is None:
            if p_cpp_instance.loadFromFile(c_filename):
                return wrap_texture_instance(p_cpp_instance, True)
        else:
            cpp_rect = convert_to_int_rect(area)

            if p_cpp_instance.loadFromFile(c_filename, cpp_rect):
                return wrap_texture_instance(p_cpp_instance, True)

        raise PySFMLException()

    @classmethod
    def load_from_image(cls, Image image, object area=None):
        cdef decl.IntRect cpp_rect
        cdef decl.Texture *p_cpp_instance = new decl.Texture()

        if area is None:
            if p_cpp_instance.loadFromImage(image.p_this[0]):
                return wrap_texture_instance(p_cpp_instance, True)
        else:
            cpp_rect = convert_to_int_rect(area)

            if p_cpp_instance.loadFromImage(image.p_this[0], cpp_rect):
                return wrap_texture_instance(p_cpp_instance, True)

        raise PySFMLException()

    @classmethod
    def load_from_memory(cls, bytes data, area=None):
        cdef decl.IntRect cpp_rect
        cdef decl.Texture *p_cpp_instance = new decl.Texture()

        if area is None:
            if p_cpp_instance.loadFromMemory(<char*>data, len(data)):
                return wrap_texture_instance(p_cpp_instance, True)
        else:
            cpp_rect = convert_to_int_rect(area)

            if p_cpp_instance.loadFromMemory(<char*>data, len(data), cpp_rect):
                return wrap_texture_instance(p_cpp_instance, True)

        raise PySFMLException()

    def copy_to_image(self):
        return wrap_image_instance(new decl.Image(self.p_this.copyToImage()),
                                   True)

    def update(self, object source, int p1=-1, int p2=-1, int p3=-1, int p4=-1):
        if isinstance(source, bytes):
            if p1 == -1:
                self.p_this.update(<decl.Uint8*>(<char*>source))
            else:
                self.p_this.update(<decl.Uint8*>(<char*>source),
                                   p1, p2, p3, p4)
        elif isinstance(source, Image):
            if p1 == -1:
                self.p_this.update((<Image>source).p_this[0])
            else:
                self.p_this.update((<Image>source).p_this[0], p1, p2)
        elif isinstance(source, RenderWindow):
            if p1 == -1:
                self.p_this.update(
                    (<decl.RenderWindow*>(<RenderWindow>source).p_this)[0])
            else:
                self.p_this.update(
                    (<decl.RenderWindow*>(<RenderWindow>source).p_this)[0],
                    p1, p2)
        else:
            raise TypeError(
                "The source argument should be of type str / bytes(py3k), "
                "Image or RenderWindow (found {0})".format(type(source)))


cdef Texture wrap_texture_instance(decl.Texture *p_cpp_instance,
                                   bint delete_this):
    cdef Texture ret = Texture.__new__(Texture)
    ret.p_this = p_cpp_instance
    ret.delete_this = delete_this

    return ret





cdef class Transformable:
    cdef decl.Transformable *p_this

    # This constructor sets p_this to a new Transformable object.
    # Because of this, it should NEVER be called by other built in
    # Transformables (Sprite, Text, ...).
    def __init__(self, *args, **kwargs):
        self.p_this = new decl.Transformable()
    
    def __dealloc__(self):
        del self.p_this

    property origin:
        def __get__(self):
            cdef decl.Vector2f origin = self.p_this.getOrigin()

            return (origin.x, origin.y)

        def __set__(self, value):
            cdef decl.Vector2f v = convert_to_vector2f(value)

            self.p_this.setOrigin(v.x, v.y)

    property position:
        def __get__(self):
            cdef decl.Vector2f pos = self.p_this.getPosition()

            return (pos.x, pos.y)

        def __set__(self, value):
            cdef decl.Vector2f v = convert_to_vector2f(value)

            self.p_this.setPosition(v.x, v.y)

    property rotation:
        def __get__(self):
            return self.p_this.getRotation()

        def __set__(self, float value):
            self.p_this.setRotation(value)

    property scale:
        def __get__(self):
            cdef decl.Vector2f scale = self.p_this.getScale()

            return ScaleWrapper(self, scale.x, scale.y)

        def __set__(self, value):
            cdef decl.Vector2f v = convert_to_vector2f(value)

            self.p_this.setScale(v.x, v.y)

    property x:
        def __get__(self):
            return self.position[0]

        def __set__(self, float value):
            self.position = (value, self.y)

    property y:
        def __get__(self):
            return self.position[1]

        def __set__(self, float value):
            self.position = (self.x, value)

    def get_inverse_transform(self):
        cdef decl.Transform *p = new decl.Transform()

        p[0] = self.p_this.getInverseTransform()

        return wrap_transform_instance(p)


    def get_transform(self):
        cdef decl.Transform *p = new decl.Transform()

        p[0] = self.p_this.getTransform()

        return wrap_transform_instance(p)

    def move(self, float x, float y):
        self.p_this.move(x, y)

    def rotate(self, float angle):
        self.p_this.rotate(angle)

    def _scale(self, float x, float y):
        self.p_this.scale(x, y)



# This class allows the user to use the Transformable.scale attribute
# both for GetScale()/SetScale() property and the Scale() method.
# When the user calls the getter for Transformable.scale, the object
# returned is an instance of this class. It will behave like a tuple,
# except that the call overrides __call__() so that the C++ Scale()
# method is called when the user types some_transformable.scale().
class ScaleWrapper(tuple):
    def __new__(cls, Transformable transformable, float x, float y):
        return tuple.__new__(cls, (x, y))

    def __init__(self, Transformable transformable, float x, float y):
        self.transformable = transformable

    def __call__(self, float x, float y):
        self.transformable._scale(x, y)



cdef class Text(Transformable):
    cdef bint is_unicode
    cdef Font font
    cdef Color color

    REGULAR = declstyle.Regular
    BOLD = declstyle.Bold
    ITALIC = declstyle.Italic
    UNDERLINED = declstyle.Underlined

    def __init__(self, string=None, Font font=None, int character_size=0):
        cdef decl.String cpp_string
        cdef char* c_string = NULL

        self.is_unicode = False

        if string is None:
            self.p_this = <decl.Transformable*>new decl.Text()
        elif isinstance(string, bytes):
            if font is None:
                self.p_this = <decl.Transformable*>new decl.Text(<char*>string)
                self.font = wrap_font_instance(
                    <decl.Font*>&(<decl.Text*>self.p_this).getFont(), False)
            elif character_size == 0:
                self.p_this = <decl.Transformable*>new decl.Text(
                    <char*>string, font.p_this[0])
                self.font = font
            else:
                self.p_this = <decl.Transformable*>new decl.Text(
                    <char*>string, font.p_this[0], character_size)
                self.font = font
        elif isinstance(string, unicode):
            self.is_unicode = True
            string += '\x00'
            py_byte_string = string.encode('utf-32-le')
            c_string = py_byte_string
            cpp_string = decl.String(<decl.Uint32*>c_string)

            if font is None:
                self.p_this = <decl.Transformable*>new decl.Text(cpp_string)
                self.font = wrap_font_instance(
                    <decl.Font*>&(<decl.Text*>self.p_this).getFont(), False)
            elif character_size == 0:
                self.p_this = <decl.Transformable*>new decl.Text(
                    cpp_string, font.p_this[0])
                self.font = font
            else:
                self.p_this = <decl.Transformable*>new decl.Text(
                    cpp_string, font.p_this[0], character_size)
                self.font = font
        else:
            raise TypeError("Expected bytes/str or unicode for string, got {0}"
                            .format(type(string)))

        self.color = wrap_color_instance(
            new decl.Color((<decl.Text*>self.p_this).getColor()))

    property character_size:
        def __get__(self):
            return (<decl.Text*>self.p_this).getCharacterSize()

        def __set__(self, int value):
            (<decl.Text*>self.p_this).setCharacterSize(value)

    property color:
        def __get__(self):
            return self.color

        def __set__(self, Color value):
            self.color = value
            (<decl.Text*>self.p_this).setColor(value.p_this[0])

    property font:
        def __get__(self):
            return self.font

        def __set__(self, Font value):
            (<decl.Text*>self.p_this).setFont(value.p_this[0])
            self.font = value

    property global_bounds:
        def __get__(self):
            cdef decl.FloatRect *p = new decl.FloatRect()

            p[0] = (<decl.Text*>self.p_this).getGlobalBounds()

            return wrap_float_rect_instance(p)

    property local_bounds:
        def __get__(self):
            cdef decl.FloatRect *p = new decl.FloatRect()

            p[0] = (<decl.Text*>self.p_this).getLocalBounds()

            return wrap_float_rect_instance(p)

    property string:
        def __get__(self):
            cdef decl.string res
            cdef char *p = NULL
            cdef bytes data

            if not self.is_unicode:
                res = ((<decl.Text*>self.p_this).getString()
                       .toAnsiString())
                ret = res.c_str()
            else:
                p = <char*>(<decl.Text*>self.p_this).getString().getData()
                data = p[:(<decl.Text*>self.p_this).getString().getSize() * 4]
                ret = data.decode('utf-32-le')

            return ret

        def __set__(self, value):
            cdef char* c_string = NULL

            if isinstance(value, bytes):
                (<decl.Text*>self.p_this).setString(<char*>value)
                self.is_unicode = False
            elif isinstance(value, unicode):
                value += '\x00'
                py_byte_string = value.encode('utf-32-le')
                c_string = py_byte_string
                (<decl.Text*>self.p_this).setString(
                    decl.String(<decl.Uint32*>c_string))
                self.is_unicode = True
            else:
                raise TypeError(
                    "Expected bytes/str or unicode for string, got {0}"
                    .format(type(value)))

    property style:
        def __get__(self):
            return (<decl.Text*>self.p_this).getStyle()

        def __set__(self, int value):
            (<decl.Text*>self.p_this).setStyle(value)

    def find_character_pos(self, int index):
        cdef decl.Vector2f res = (<decl.Text*>self.p_this).findCharacterPos(
            index)

        return (res.x, res.y)





cdef class Sprite(Transformable):
    cdef Texture texture

    def __init__(self, Texture texture=None, IntRect rectangle=None):
        if texture is None:
            self.texture = None
            self.p_this = <decl.Transformable*>new decl.Sprite()
        elif rectangle is None:
            self.texture = texture
            self.p_this = <decl.Transformable*>new decl.Sprite(
                texture.p_this[0])
        else:
            self.texture = texture
            self.p_this = <decl.Transformable*>new decl.Sprite(
                texture.p_this[0], rectangle.p_this[0])

    property color:
        def __get__(self):
            return wrap_color_instance(new decl.Color(
                (<decl.Sprite*>self.p_this).getColor()))

        def __set__(self, Color value):
            (<decl.Sprite*>self.p_this).setColor(value.p_this[0])

    property global_bounds:
        def __get__(self):
            cdef decl.FloatRect r = ((<decl.Sprite*>self.p_this)
                                     .getGlobalBounds())

            return FloatRect(r.left, r.top, r.width, r.height)

    property local_bounds:
        def __get__(self):
            cdef decl.FloatRect r = ((<decl.Sprite*>self.p_this)
                                     .getLocalBounds())

            return FloatRect(r.left, r.top, r.width, r.height)

    property texture:
        def __get__(self):
            return self.texture

        def __set__(self, Texture value):
            self.texture = value
            (<decl.Sprite*>self.p_this).setTexture(value.p_this[0])
           
    def copy(self):
        cdef decl.Sprite *p = new decl.Sprite((<decl.Sprite*>self.p_this)[0])
        cdef Sprite sprite = wrap_sprite_instance(p, self.texture)

        return sprite

    def get_texture_rect(self): 
        cdef decl.IntRect r = (<decl.Sprite*>self.p_this).getTextureRect()

        return IntRect(r.left, r.top, r.width, r.height)

    def set_texture(self, Texture texture, bint reset_rect=False):
        self.texture = texture
        (<decl.Sprite*>self.p_this).setTexture(texture.p_this[0],
                                               reset_rect)

    def set_texture_rect(self, IntRect rect):
        cdef decl.IntRect r = convert_to_int_rect(rect)

        (<decl.Sprite*>self.p_this).setTextureRect(r)


cdef Sprite wrap_sprite_instance(decl.Sprite *p, Texture texture):
    cdef Sprite ret = Sprite.__new__(Sprite)
    ret.p_this = <decl.Transformable*>p
    ret.texture = texture
    return ret



# Classes like Rectangle that inherit from Shape shouldn't have a
# __cinit__() constructor, otherwise they will call Shape's
# constructor automatically, which will create a Shape object for no reason.
cdef class Shape(Transformable):
    cdef Texture texture

    def __init__(self, *args, **kwargs):
        if self.__class__ == Shape:
            raise NotImplementedError("Shape is abstract")

        self.texture = None
        self.p_this = <decl.Transformable*>new decl.CppShape()
        (<decl.CppShape*>self.p_this).shape = <void*>self

    property fill_color:
        def __get__(self):
            return wrap_color_instance(new decl.Color(
                (<decl.Shape*>self.p_this).getFillColor()))

        def __set__(self, Color value):
            (<decl.Shape*>self.p_this).setFillColor(value.p_this[0])

    property global_bounds:
        def __get__(self):
            cdef decl.FloatRect r = (<decl.Shape*>self.p_this).getGlobalBounds()

            return FloatRect(r.left, r.top, r.width, r.height)

    property local_bounds:
        def __get__(self):
            cdef decl.FloatRect r = (<decl.Shape*>self.p_this).getLocalBounds()

            return FloatRect(r.left, r.top, r.width, r.height)

    property texture:
        def __get__(self):
            return self.texture

        def __set__(self, Texture value):
            self.texture = value
            (<decl.Shape*>self.p_this).setTexture(value.p_this)

    property texture_rect:
        def __get__(self):
            cdef decl.IntRect r = (<decl.Shape*>self.p_this).getTextureRect()

            return IntRect(r.left, r.top, r.width, r.height)

        def __set__(self, object value):
            (<decl.Shape*>self.p_this).setTextureRect(
                convert_to_int_rect(value))

    property outline_color:
        def __get__(self):
            return wrap_color_instance(new decl.Color(
                (<decl.Shape*>self.p_this).getOutlineColor()))

        def __set__(self, Color value):
            (<decl.Shape*>self.p_this).setOutlineColor(value.p_this[0])

    property outline_thickness:
        def __get__(self):
            return (<decl.Shape*>self.p_this).getOutlineThickness()

        def __set__(self, float value):
            (<decl.Shape*>self.p_this).setOutlineThickness(value)

    def get_point(self, int index):
        raise NotImplementedError("get_point() is abstract")

    def get_point_count(self):
        raise NotImplementedError("get_point_count() is abstract")

    def set_texture(self, Texture texture, bint reset_rect=False):
        self.texture = texture
        (<decl.Shape*>self.p_this).setTexture(texture.p_this, reset_rect)

    # Built-in shapes must override this method and raise NotImplementedError,
    # since their p_this isn't a CppShape* but a sf::Shape*.
    def update(self):
        (<decl.CppShape*>self.p_this).update()



cdef class RectangleShape(Shape):
    def __init__(self, size=None):
        cdef decl.Vector2f s

        if size is None:
            self.p_this = <decl.Transformable*>new decl.RectangleShape()
        else:
            s = convert_to_vector2f(size)
            self.p_this = <decl.Transformable*>new decl.RectangleShape(s)

    property size:
        def __get__(self):
            cdef decl.Vector2f s = (<decl.RectangleShape*>self.p_this).getSize()

            convert_to_vector2f(1)

            return (s.x, s.y)

        def __set__(self, object size):
            cdef decl.Vector2f s = convert_to_vector2f(size)

            (<decl.RectangleShape*>self.p_this).setSize(s)

    def update(self):
        raise NotImplementedError(
            "This method isn't availble in built-in shapes")


cdef class CircleShape(Shape):
    def __init__(self, radius=None, point_count=None):
        self.p_this = <decl.Transformable*>new decl.CircleShape()

        if radius is not None:
            (<decl.CircleShape*>self.p_this).setRadius(<float?>radius)

        if point_count is not None:
            (<decl.CircleShape*>self.p_this).setPointCount(<int?>point_count)

    property point_count:
        def __get__(self):
            return (<decl.CircleShape*>self.p_this).getPointCount()

        def __set__(self, int value):
            (<decl.CircleShape*>self.p_this).setPointCount(value)

    property radius:
        def __get__(self):
            return (<decl.CircleShape*>self.p_this).getRadius()

        def __set__(self, float value):
            (<decl.CircleShape*>self.p_this).setRadius(value)

    def update(self):
        raise NotImplementedError(
            "This method isn't availble in built-in shapes")



cdef class ConvexShape(Shape):
    def __init__(self, point_count=None):
        self.p_this = <decl.Transformable*>new decl.ConvexShape()

        if point_count is not None:
            (<decl.ConvexShape*>self.p_this).setPointCount(<int?>point_count)

    def get_point(self, int index):
        cdef decl.Vector2f point = ((<decl.ConvexShape*>self.p_this)
                                    .getPoint(index))

        return (point.x, point.y)

    def get_point_count(self):
        return (<decl.ConvexShape*>self.p_this).getPointCount()

    def set_point(self, int index, object point):
        cdef decl.Vector2f cpp_point = convert_to_vector2f(point)

        (<decl.ConvexShape*>self.p_this).setPoint(index, cpp_point)

    def set_point_count(self, int count):
        (<decl.ConvexShape*>self.p_this).setPointCount(count)

    def update(self):
        raise NotImplementedError(
            "This method isn't availble in built-in shapes")



cdef class Vertex:
    cdef decl.Vertex *p_this
    cdef Color color

    def __init__(self, object position=None, Color color=None,
                 object tex_coords=None):
        self.p_this = new decl.Vertex()

        if position is not None:
            self.p_this.position = convert_to_vector2f(position)

        if color is not None:
            self.p_this.color = color.p_this[0]
            self.color = color

        if tex_coords is not None:
            self.p_this.texCoords = convert_to_vector2f(tex_coords)

    def __dealloc__(self):
        del self.p_this

    property color:
        def __get__(self):
            return self.color

        def __set__(self, Color value):
            self.color = value
            self.p_this.color = value.p_this[0]

    property position:
        def __get__(self):
            cdef decl.Vector2f v = self.p_this.position

            return (v.x, v.y)

        def __set__(self, object value):
            self.p_this.position = convert_to_vector2f(value)

    property tex_coords:
        def __get__(self):
            cdef decl.Vector2f v = self.p_this.texCoords

            return (v.x, v.y)

        def __set__(self, object value):
            self.p_this.texCoords = convert_to_vector2f(value)


cdef Vertex wrap_vertex_instance(decl.Vertex *p):
    cdef Vertex ret = Vertex.__new__(Vertex)

    ret.p_this = p

    return ret




cdef class VideoMode:
    cdef decl.VideoMode *p_this
    cdef bint delete_this

    def __init__(self, width=None, height=None, bits_per_pixel=32):
        if width is None or height is None:
            self.p_this = new decl.VideoMode()
        else:
            self.p_this = new decl.VideoMode(width, height, bits_per_pixel)

        self.delete_this = True

    def __dealloc__(self):
        if self.delete_this:
            del self.p_this

    def __str__(self):
        return '{0.width}x{0.height}x{0.bits_per_pixel}'.format(self)

    def __repr__(self):
        return ('VideoMode({0.width}, {0.height}, {0.bits_per_pixel})'
                .format(self))

    def __richcmp__(VideoMode x, VideoMode y, int op):
        # ==
        if op == 2:
            return (x.width == y.width and
                    x.height == y.height and
                    x.bits_per_pixel == y.bits_per_pixel)
        # !=
        elif op == 3:
            return not x == y

        # <
        elif op == 0:
            if x.bits_per_pixel == y.bits_per_pixel:
                if x.width == y.width:
                    return x.height < y.height
                else:
                    return x.width < y.width
            else:
                return x.bits_per_pixel < y.bits_per_pixel
        # >
        elif op == 4:
            return y < x

        # <=
        elif op == 1:
            return not y < x
        # >=
        elif op == 5:
            return not x < y

        return NotImplemented

    property width:
        def __get__(self):
            return self.p_this.width

        def __set__(self, unsigned int value):
            self.p_this.width = value

    property height:
        def __get__(self):
            return self.p_this.height

        def __set__(self, unsigned value):
            self.p_this.height = value

    property bits_per_pixel:
        def __get__(self):
            return self.p_this.bitsPerPixel

        def __set__(self, unsigned int value):
            self.p_this.bitsPerPixel = value

    @classmethod
    def get_desktop_mode(cls):
        cdef decl.VideoMode *p = new decl.VideoMode()
        p[0] = decl.VideoMode_getDesktopMode()

        return wrap_video_mode_instance(p, True)

    @classmethod
    def get_fullscreen_modes(cls):
        cdef list ret = []
        cdef vector[decl.VideoMode] v = decl.getFullscreenModes()
        cdef vector[decl.VideoMode].iterator it = v.begin()
        cdef decl.VideoMode current
        cdef decl.VideoMode *p_temp

        while it != v.end():
            current = deref(it)
            p_temp = new decl.VideoMode(current.width, current.height,
                                        current.bitsPerPixel)
            ret.append(wrap_video_mode_instance(p_temp, True))
            preinc(it)

        return ret

    def is_valid(self):
        return self.p_this.isValid()


cdef VideoMode wrap_video_mode_instance(decl.VideoMode *p_cpp_instance,
                                        bint delete_this):
    cdef VideoMode ret = VideoMode.__new__(VideoMode)
    ret.p_this = p_cpp_instance
    ret.delete_this = delete_this

    return ret





cdef class View:
    cdef decl.View *p_this
    # A RenderTarget (e.g., a RenderWindow or a RenderImage) can be
    # bound to the view. Every time the view is changed, the target
    # will be automatically updated. The target object must have a
    # view property.  This is used so that code like
    # window.view.move(10, 10) works as expected, since window.view
    # returns a copy of the view.
    cdef object render_target

    def __init__(self):
        self.p_this = new decl.View()
        self.render_target = None

    def __dealloc__(self):
        del self.p_this

    property center:
        def __get__(self):
            cdef decl.Vector2f center = self.p_this.getCenter()

            return (center.x, center.y)

        def __set__(self, value):
            cdef decl.Vector2f v = convert_to_vector2f(value)

            self.p_this.setCenter(v.x, v.y)
            self._update_target()

    property height:
        def __get__(self):
            return self.size[1]

        def __set__(self, float value):
            self.size = (self.width, value)
            self._update_target()

    property rotation:
        def __get__(self):
            return self.p_this.getRotation()

        def __set__(self, float value):
            self.p_this.setRotation(value)
            self._update_target()

    property size:
        def __get__(self):
            cdef decl.Vector2f size = self.p_this.getSize()

            return (size.x, size.y)

        def __set__(self, value):
            cdef decl.Vector2f v = convert_to_vector2f(value)

            self.p_this.setSize(v.x, v.y)
            self._update_target()

    property viewport:
        def __get__(self):
            cdef decl.FloatRect *p = new decl.FloatRect()

            p[0] = self.p_this.getViewport()

            return wrap_float_rect_instance(p)

        def __set__(self, FloatRect value):
            self.p_this.setViewport(value.p_this[0])
            self._update_target()

    property width:
        def __get__(self):
            return self.size[0]

        def __set__(self, float value):
            self.size = (value, self.height)
            self._update_target()

    @classmethod
    def from_center_and_size(cls, center, size):
        cdef decl.Vector2f cpp_center = convert_to_vector2f(center)
        cdef decl.Vector2f cpp_size = convert_to_vector2f(size)
        cdef decl.View *p

        p = new decl.View(cpp_center, cpp_size)

        return wrap_view_instance(p, None)
        
    @classmethod
    def from_rect(cls, FloatRect rect):
        cdef decl.View *p = new decl.View(rect.p_this[0])

        return wrap_view_instance(p, None)

    def get_inverse_transform(self):
        cdef decl.Transform *p = new decl.Transform()

        p[0] = self.p_this.getInverseTransform()

        return wrap_transform_instance(p)

    def get_transform(self):
        cdef decl.Transform *p = new decl.Transform()

        p[0] = self.p_this.getTransform()

        return wrap_transform_instance(p)

    def move(self, float x, float y):
        self.p_this.move(x, y)
        self._update_target()

    def reset(self, FloatRect rect):
        self.p_this.reset(rect.p_this[0])
        self._update_target()

    def rotate(self, float angle):
        self.p_this.rotate(angle)
        self._update_target()

    def zoom(self, float factor):
        self.p_this.zoom(factor)
        self._update_target()

    def _update_target(self):
        if self.render_target is not None:
            self.render_target.view = self


cdef View wrap_view_instance(decl.View *p_cpp_view, object window):
    cdef View ret = View.__new__(View)

    ret.p_this = p_cpp_view
    ret.render_target = window

    return ret





cdef class Shader:
    cdef decl.Shader *p_this
    cdef bint delete_this

    IS_AVAILABLE = decl.Shader_isAvailable()
    CURRENT_TEXTURE = object()
    FRAGMENT = decl.Shader_Fragment
    VERTEX = decl.Shader_Vertex

    def __init__(self):
        raise NotImplementedError(
            "Use class methods like Shader.load_from_file() "
            "to create Shader objects")

    def __dealloc__(self):
        if self.delete_this:
            del self.p_this

    @classmethod
    def load_both_types_from_file(cls, char *vertex_shader_filename,
                                  char *fragment_shader_filename):
        cdef decl.Shader *p = new decl.Shader()

        if p.loadFromFile(vertex_shader_filename,
                          fragment_shader_filename):
            return wrap_shader_instance(p, True)

        raise PySFMLException()

    @classmethod
    def load_both_types_from_memory(cls, bytes vertex_shader,
                                    bytes fragment_shader):
        cdef decl.Shader *p = new decl.Shader()

        if p.loadFromMemory(<char*>vertex_shader, <char*>fragment_shader):
            return wrap_shader_instance(p, True)

        raise PySFMLException()

    @classmethod
    def load_from_file(cls, char *filename, int type):
        cdef decl.Shader *p = new decl.Shader()

        if p.loadFromFile(filename, <declshader.Type>type):
            return wrap_shader_instance(p, True)

        raise PySFMLException()

    @classmethod
    def load_from_memory(cls, bytes shader, int type):
        cdef decl.Shader *p = new decl.Shader()

        if p.loadFromMemory(<char*>shader, <declshader.Type>type):
            return wrap_shader_instance(p, True)

        raise PySFMLException()

    def bind(self):
        self.p_this.bind()

    def set_parameter(self, char *name, x, y=None, z=None, w=None):
        if y is None:
            if x is self.CURRENT_TEXTURE:
                self.p_this.setParameter(name, declshader.CurrentTexture)
            elif isinstance(x, float):
                self.p_this.setParameter(name, <float>x)
            elif isinstance(x, Color):
                self.p_this.setParameter(name, (<Color>x).p_this[0])
            elif isinstance(x, Transform):
                self.p_this.setParameter(name, (<Transform>x).p_this[0])
            elif isinstance(x, Texture):
                self.p_this.setParameter(name, (<Texture>x).p_this[0])
            else:
                raise TypeError(
                    "Second argument has type {0}. "
                    "It should be one of: float, Color, Transform, Texture, "
                    "sf.Shader.CURRENT_TEXTURE"
                    .format(type(x)))
        elif z is None:
            self.p_this.setParameter(name, x, y)
        elif w is None:
            self.p_this.setParameter(name, x, y, z)
        else:
            self.p_this.setParameter(name, x, y, z, w)

    def unbind(self):
        self.p_this.unbind()


cdef Shader wrap_shader_instance(decl.Shader *p_cpp_instance, bint delete_this):
    cdef Shader ret = Shader.__new__(Shader)

    ret.p_this = p_cpp_instance
    ret.delete_this = delete_this

    return ret





cdef class ContextSettings:
    cdef decl.ContextSettings *p_this

    def __init__(self, unsigned int depth=24, unsigned int stencil=8,
                 unsigned int antialiasing=0, unsigned int major=2,
                 unsigned int minor=0):
        self.p_this = new decl.ContextSettings(depth, stencil, antialiasing,
                                               major, minor)

    def __dealloc__(self):
        del self.p_this

    property antialiasing_level:
        def __get__(self):
            return self.p_this.antialiasingLevel

        def __set__(self, unsigned int value):
            self.p_this.antialiasingLevel = value

    property depth_bits:
        def __get__(self):
            return self.p_this.depthBits

        def __set__(self, unsigned int value):
            self.p_this.depthBits = value

    property major_version:
        def __get__(self):
            return self.p_this.majorVersion

        def __set__(self, unsigned int value):
            self.p_this.majorVersion = value

    property minor_version:
        def __get__(self):
            return self.p_this.minorVersion

        def __set__(self, unsigned int value):
            self.p_this.minorVersion = value

    property stencil_bits:
        def __get__(self):
            return self.p_this.stencilBits

        def __set__(self, unsigned int value):
            self.p_this.stencilBits = value


cdef ContextSettings wrap_context_settings_instance(
    decl.ContextSettings *p_cpp_instance):
    cdef ContextSettings ret = ContextSettings.__new__(ContextSettings)

    ret.p_this = p_cpp_instance

    return ret




cdef class RenderStates:
    cdef decl.RenderStates *p_this
    # m prefixes are used to distinguish these attributes from the
    # Python properties
    cdef Transform m_transform
    cdef Texture m_texture
    cdef Shader m_shader

    DEFAULT = wrap_render_states_instance(
        new decl.RenderStates(decl.RenderStates_Default))

    def __init__(self, Shader shader=None, Texture texture=None,
                  Transform transform=None):
        self.p_this = new decl.RenderStates()
        self.shader = shader
        self.texture = texture

        if transform is None:
            self.transform = Transform()
        else:
            self.transform = transform

    def __dealloc__(self):
        del self.p_this

    property blend_mode:
        def __get__(self):
            return <int>self.p_this.blendMode

        def __set__(self, int value):
            self.p_this.blendMode = <decl.BlendMode>value

    property shader:
        def __get__(self):
            return self.m_shader

        def __set__(self, Shader value):
            self.m_shader = value
            self.p_this.shader = value.p_this

    property texture:
        def __get__(self):
            return self.m_texture

        def __set__(self, Texture value):
            self.m_texture = value
            self.p_this.texture = value.p_this

    property transform:
        def __get__(self):
            return self.m_transform

        def __set__(self, Transform value):
            self.m_transform = value
            self.p_this.transform = value.p_this[0]


cdef public object wrap_render_states_instance(decl.RenderStates *p):
    cdef RenderStates ret = RenderStates.__new__(RenderStates)

    ret.p_this = p

    if p.shader == NULL:
        ret.shader = None
    else:
        ret.shader = wrap_shader_instance(<decl.Shader*>p.shader, False)

    if p.texture == NULL:
        ret.texture = None
    else:
        ret.texture = wrap_texture_instance(<decl.Texture*>p.texture, False)

    ret.transform = wrap_transform_instance(new decl.Transform(p.transform))

    return ret



cdef class RenderTarget:
    cdef decl.RenderTarget *p_this

    def __cinit__(self, *args, **kwargs):
        pass

    def __init__(self, *args, **kwargs):
        if self.__class__ == RenderTarget:
            raise NotImplementedError('RenderTarget is abstact')

    property default_view:
        def __get__(self):
            cdef decl.View *p = new decl.View()

            p[0] = self.p_this.getDefaultView()

            return wrap_view_instance(p, None)

    property height:
        def __get__(self):
            return self.size[1]

    property size:
        def __get__(self):
            cdef decl.Vector2u size = self.p_this.getSize()

            return (size.x, size.y)

    property view:
        def __get__(self):
            cdef decl.View *p = new decl.View()

            p[0] = self.p_this.getView()

            return wrap_view_instance(p, self)

        def __set__(self, View value):
            self.p_this.setView(value.p_this[0])

    property width:
        def __get__(self):
            return self.size[0]

    def clear(self, Color color=None):
        if color is None:
            self.p_this.clear()
        else:
            self.p_this.clear(color.p_this[0])

    def convert_coords(self, unsigned int x, unsigned int y, View view=None):
        cdef decl.Vector2f res

        if view is None:
            res = self.p_this.convertCoords(decl.Vector2i(x, y))
        else:
            res = self.p_this.convertCoords(decl.Vector2i(x, y), view.p_this[0])

        return (res.x, res.y)

    def draw(self, object drawable, object x=None, object y=None):
        cdef decl.Vertex *vertex
        cdef unsigned int vertex_count
        cdef int the_type

        if isinstance(drawable, sfml_drawables):
            if x is None:
                self.p_this.draw(decl.transformable_to_drawable(
                    (<Transformable>drawable).p_this)[0])
            elif isinstance(x, Shader):
                self.p_this.draw(decl.transformable_to_drawable(
                                 (<Transformable>drawable).p_this)[0],
                                 (<Shader>x).p_this)
            elif isinstance(x, RenderStates):
                self.p_this.draw(decl.transformable_to_drawable(
                                 (<Transformable>drawable).p_this)[0],
                                 (<RenderStates>x).p_this[0])
            else:
                raise TypeError(
                    "The optional second argument has type {0}. "
                    "Only Shader and RenderStates are supported."
                    .format(type(x)))
        elif isinstance(drawable, (list, tuple)):
            vertex_count = len(drawable)
            vertex = <decl.Vertex*>malloc(vertex_count * sizeof(decl.Vertex))

            if vertex == NULL:
                cpython.exc.PyErr_NoMemory()

            the_type = <int?>x

            for i in range(vertex_count):
                if not isinstance(drawable[i], Vertex):
                    free(vertex)
                    raise TypeError(
                        "The list should contain vertex objects, {0} found"
                        .format(type(drawable[i])))

                vertex[i] = (<Vertex>(drawable[i])).p_this[0]

            if y is None:
                self.p_this.draw(vertex, vertex_count,
                                 <decl.PrimitiveType>the_type)
            elif isinstance(y, Shader):
                self.p_this.draw(vertex, vertex_count,
                                 <decl.PrimitiveType>the_type,
                                 (<Shader>y).p_this)
            elif isinstance(y, RenderStates):
                self.p_this.draw(vertex, vertex_count,
                                 <decl.PrimitiveType>the_type,
                                 (<RenderStates>y).p_this[0])
            else:
                free(vertex)
                raise TypeError(
                    "The optional third argument has type {0}. "
                    "Only Shader and RenderStates are supported."
                    .format(type(x)))

            free(vertex)
        else:
            call_render(self, drawable, x)

    def get_viewport(self, View view):
        cdef decl.IntRect *p = new decl.IntRect()

        p[0] = self.p_this.getViewport(view.p_this[0])

        return wrap_int_rect_instance(p)

    def pop_gl_states(self):
        self.p_this.popGLStates()

    def push_gl_states(self):
        self.p_this.pushGLStates()

    def reset_gl_states(self):
        self.p_this.resetGLStates()


# Wraps the code that will call the render() method of a drawable.
# This is called in RenderTarget.draw(). The goal is to force Cython to
# check if an error occured (with except *), because the C++ Draw()
# method can't return any status code.
cdef void call_render(RenderTarget target, object drawable, object x) except *:
    cdef decl.CppDrawable cpp_drawable

    cpp_drawable.drawable = <void*>drawable;

    if isinstance(x, Shader):
        target.p_this.draw((<decl.Drawable*>&cpp_drawable)[0],
                           (<Shader>x).p_this)
    elif isinstance(x, RenderStates):
        target.p_this.draw((<decl.Drawable*>&cpp_drawable)[0],
                           (<RenderStates>x).p_this[0])
    else:
        target.p_this.draw((<decl.Drawable*>&cpp_drawable)[0])


cdef public object wrap_render_target_instance(decl.RenderTarget
                                               *p_cpp_instance):
    cdef RenderTarget ret = RenderTarget.__new__(RenderTarget)
    ret.p_this = p_cpp_instance

    return ret


    
    
cdef class RenderWindow(RenderTarget):
    def __init__(self, VideoMode mode=None, title=None, int style=Style.DEFAULT,
                  ContextSettings settings=None):
        cdef char *c_title

        if mode is None:
            self.p_this = <decl.RenderTarget*>new decl.RenderWindow()
        else:
            if isinstance(title, str):
                py_title = title.encode(default_encoding)
                c_title = py_title
            else:
                c_title = <bytes?>title

            if settings is None:
                self.p_this = <decl.RenderTarget*>new decl.RenderWindow(
                    mode.p_this[0], c_title, style)
            else:
                self.p_this = <decl.RenderTarget*>new decl.RenderWindow(
                    mode.p_this[0], c_title, style, settings.p_this[0])

    def __dealloc__(self):
        del self.p_this

    def __iter__(self):
        return self

    def __next__(self):
        cdef decl.Event p

        if (<decl.RenderWindow*>self.p_this).pollEvent(p):
            return wrap_event_instance(&p)

        raise StopIteration

    property active:
        def __set__(self, bint value):
            (<decl.RenderWindow*>self.p_this).setActive(value)

    property framerate_limit:
        def __set__(self, int value):
            (<decl.RenderWindow*>self.p_this).setFramerateLimit(value)

    property height:
        def __get__(self):
            return self.size[1]

        def __set__(self, int value):
            self.size[1] = value

    property joystick_threshold:
        def __set__(self, bint value):
            (<decl.RenderWindow*>self.p_this).setJoystickThreshold(value)

    property key_repeat_enabled:
        def __set__(self, bint value):
            (<decl.RenderWindow*>self.p_this).setKeyRepeatEnabled(value)

    property mouse_cursor_visible:
        def __set__(self, bint value):
            (<decl.RenderWindow*>self.p_this).setMouseCursorVisible(value)

    property open:
        def __get__(self):
            return (<decl.RenderWindow*>self.p_this).isOpen()

    property position:
        def __get__(self):
            cdef decl.Vector2i pos = ((<decl.RenderWindow*>self.p_this)
                                      .getPosition())

            return (pos.x, pos.y)

        def __set__(self, tuple value):
            cdef decl.Vector2i pos
            x, y = value
            pos.x = x
            pos.y = y
            (<decl.RenderWindow*>self.p_this).setPosition(pos)

    property settings:
        def __get__(self):
            cdef decl.ContextSettings *p = new decl.ContextSettings()

            p[0] = (<decl.RenderWindow*>self.p_this).getSettings()

            return wrap_context_settings_instance(p)

    property size:
        def __get__(self):
            cdef decl.Vector2u size = self.p_this.getSize()

            return (size.x, size.y)

        def __set__(self, tuple value):
            x, y = value
            (<decl.RenderWindow*>self.p_this).setSize(decl.Vector2u(x, y))

    property system_handle:
        def __get__(self):
            return (<unsigned long>(<decl.RenderWindow*>self.p_this)
                    .getSystemHandle())

    property title:
        def __set__(self, value):
            cdef char *c_title

            if isinstance(value, str):
                py_title = value.encode(default_encoding)
                c_title = py_title
            else:
                c_title = <bytes?>value

            (<decl.RenderWindow*>self.p_this).setTitle(c_title)

    property vertical_sync_enabled:
        def __set__(self, bint value):
            (<decl.RenderWindow*>self.p_this).setVerticalSyncEnabled(value)

    property visible:
        def __set__(self, bint value):
            (<decl.RenderWindow*>self.p_this).setVisible(value)

    property width:
        def __get__(self):
            return self.size[0]

        def __set__(self, int value):
            self.size[0] = value

    @classmethod
    def from_window_handle(cls, unsigned long window_handle,
                           ContextSettings settings=None):
        cdef decl.RenderWindow *p = NULL

        if settings is None:
            p = new decl.RenderWindow(<decl.WindowHandle>window_handle)
        else:
            p = new decl.RenderWindow(<decl.WindowHandle>window_handle,
                                      settings.p_this[0])

        return wrap_render_window_instance(p)

    def close(self):
        (<decl.RenderWindow*>self.p_this).close()

    def create(self, VideoMode mode, title, int style=Style.DEFAULT,
               ContextSettings settings=None):
        cdef char *c_title

        if isinstance(title, str):
            py_title = title.encode(default_encoding)
            c_title = py_title
        else:
            c_title = <bytes?>title

        if settings is None:
            (<decl.RenderWindow*>self.p_this).create(mode.p_this[0], c_title,
                                                     style)
        else:
            (<decl.RenderWindow*>self.p_this).create(mode.p_this[0], c_title,
                                                     style, settings.p_this[0])

    def display(self):
        cdef decl.RenderWindow *w = <decl.RenderWindow*>self.p_this

        with nogil:
            w.display()

    def iter_events(self):
        return self

    def poll_event(self):
        cdef decl.Event *p = new decl.Event()

        if (<decl.RenderWindow*>self.p_this).pollEvent(p[0]):
            return wrap_event_instance(p)

    def set_icon(self, unsigned int width, unsigned int height, char* pixels):
        (<decl.RenderWindow*>self.p_this).setIcon(width, height,
                                                  <decl.Uint8*>pixels)

    def wait_event(self):
        cdef decl.Event *p = new decl.Event()

        if (<decl.RenderWindow*>self.p_this).waitEvent(p[0]):
            return wrap_event_instance(p)


cdef RenderWindow wrap_render_window_instance(
    decl.RenderWindow *p_cpp_instance):
    cdef RenderWindow ret = RenderWindow.__new__(RenderWindow)

    ret.p_this = <decl.RenderTarget*>p_cpp_instance

    return ret


cdef class RenderTexture(RenderTarget):
    def __cinit__(self):
        self.p_this = <decl.RenderTarget*>new decl.RenderTexture()
    
    def __init__(self, unsigned int width, unsigned int height,
                 bint depth=False):
        self.create(width, height, depth)
    
    def __dealloc__(self):
        del self.p_this
    
    property active:
        def __set__(self, bint active):
            (<decl.RenderTexture*>self.p_this).setActive(active)

    property texture:
        def __get__(self):
            return wrap_texture_instance(
                <decl.Texture*>&(<decl.RenderTexture*>self.p_this).getTexture(),
                False)

    property smooth:
        def __get__(self):
            return (<decl.RenderTexture*>self.p_this).isSmooth()
        
        def __set__(self, bint smooth):
            (<decl.RenderTexture*>self.p_this).setSmooth(smooth)

    def create(self, unsigned int width, unsigned int height, bint depth=False):
        (<decl.RenderTexture*>self.p_this).create(width, height, depth)

    def display(self):
        (<decl.RenderTexture*>self.p_this).display()
