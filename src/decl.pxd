# -*- python -*-
# -*- coding: utf-8 -*-

# Copyright 2010, 2011, 2012 Bastien Léonard. All rights reserved.

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


from libcpp.vector cimport vector
from libcpp.string cimport string


# Forward declarations, to avoid some circular import errors when
# these declarations are imported elsewhere (e.g. from declmouse.pxd)
cdef extern from "SFML/Graphics.hpp" namespace "sf":
    cppclass RenderWindow
    cppclass Vector2i


cimport declkey
cimport decljoy
cimport declmouse
cimport declprimitive
cimport declshader



cdef extern from "Python.h":
    void PyEval_InitThreads()

cdef extern from "hacks.hpp":
    void replace_error_handler()
    Drawable* transformable_to_drawable(Transformable*)

    cdef cppclass CppDrawable:
        CppDrawable()
        CppDrawable(void*)
        # This is a PyObject*, but for some reason Cython doesn't
        # accept ``object''
        void *drawable

    cdef cppclass CppShape:
        CppShape()
        CppShape(void*)
        void *shape
        unsigned int getPointCount()
        Vector2f getPoint(unsigned int)
        void update()

    cdef cppclass CppSoundStream:
        CppSoundStream()
        CppSoundStream(void*)
        void initialize(unsigned int, unsigned int)
        void play()
        void *sound_stream


cdef extern from "SFML/Graphics.hpp" namespace "sf::Event":
    cdef struct SizeEvent:
        unsigned int width
        unsigned int height

    cdef struct KeyEvent:
        int code
        bint alt
        bint control
        bint shift
        bint system

    cdef struct MouseMoveEvent:
        int x
        int y

    cdef struct MouseButtonEvent:
        int button
        int x
        int y

    cdef struct TextEvent:
        int unicode

    cdef struct MouseWheelEvent:
        int delta
        int x
        int y

    cdef struct JoystickMoveEvent:
        unsigned int joystickId
        int axis
        float position

    cdef struct JoystickButtonEvent:
        unsigned int joystickId
        unsigned int button

    cdef struct JoystickConnectEvent:
        unsigned int joystickId



cdef extern from "SFML/System.hpp" namespace "sf":
    ctypedef short Int16
    ctypedef unsigned char Uint8
    ctypedef int Int32
    ctypedef unsigned int Uint32
    ctypedef long int Int64
    ctypedef unsigned long int Uint64



cdef extern from "SFML/Graphics.hpp" namespace "sf":
    # Forward declarations
    cdef cppclass RenderWindow

    cdef cppclass BlendMode:
        pass

    cdef int BlendAlpha
    cdef int BlendAdd
    cdef int BlendMultiply
    cdef int BlendNone

    cdef cppclass PrimitiveType:
        pass

    cdef int Points
    cdef int Lines
    cdef int LinesStrip
    cdef int Triangles
    cdef int TrianglesStrip
    cdef int TrianglesFan
    cdef int Quads

    cdef cppclass Vector2f:
        Vector2f()
        Vector2f(float, float)
        float x
        float y

    cdef cppclass Vector2i:
        Vector2i()
        Vector2i(int, int)
        int x
        int y

    cdef cppclass Vector2u:
       Vector2u()
       Vector2u(unsigned int, unsigned int)
       unsigned int x
       unsigned int y

    cdef cppclass Vector3f:
        Vector3f()
        Vector3f(float, float, float)
        float x
        float y
        float z

    cdef cppclass IntRect:
        IntRect()
        IntRect(int, int, int, int)
        bint contains(int, int)
        bint intersects(IntRect&)
        bint intersects(IntRect&, IntRect&)
        int left
        int top
        int width
        int height

    cdef cppclass FloatRect:
        FloatRect()
        FloatRect(float, float, float, float)
        bint contains(int, int)
        bint intersects(FloatRect&)
        bint intersects(FloatRect&, FloatRect&)
        float left
        float top
        float width
        float height

    cdef cppclass Transform:
        Transform()
        Transform(float, float, float,
                  float, float, float,
                  float, float, float)
        Transform(Transform&)
        Transform combine(Transform&)
        Transform getInverse()
        float* getMatrix()
        Transform& rotate(float)
        Transform& rotate(float, float, float)
        Transform& rotate(float, Vector2f&)
        Transform& scale(float, float)
        Transform& scale(float, float, float, float)
        Transform& scale(Vector2f&)
        Transform& scale(Vector2f&, Vector2f&)
        Vector2f transformPoint(float, float)
        Vector2f transformPoint(Vector2f&)
        FloatRect transformRect(FloatRect&)
        Transform& translate(float, float)
        Transform& translate(Vector2f&)

        Transform operator*(Transform&)
        Vector2f operator*(Vector2f&)
        # Transform operator*=(Transform&, Transform&)

    cdef cppclass Time:
        Time()
        Time(Time)
        float asSeconds()
        Uint32 asMilliseconds()
        Int64 asMicroseconds()
        bint operator==(Time&)
        bint operator!=(Time&)
        bint operator<(Time&)
        bint operator>(Time&)
        bint operator<=(Time&)
        bint operator>=(Time&)
        Time operator+(Time&, Time&)
        Time operator-(Time&, Time&)
        Time operator*(float)
        Time operator*(Int64)
        Time operator/(float)
        Time operator/(Int64)

    cdef cppclass Clock:
        Clock()
        Time getElapsedTime()
        Time restart()

    cdef cppclass Color:
        Color()
        Color(unsigned int r, unsigned int g, unsigned b)
        Color(unsigned int r, unsigned int g, unsigned b, unsigned int a)
        Color(Color&)
        unsigned int r
        unsigned int g
        unsigned int b
        unsigned int a

    cdef cppclass Event:
        Event()
        int type
        SizeEvent size
        KeyEvent key
        MouseMoveEvent mouseMove
        MouseButtonEvent mouseButton
        TextEvent text
        MouseWheelEvent mouseWheel
        JoystickMoveEvent joystickMove
        JoystickButtonEvent joystickButton
        JoystickConnectEvent joystickConnect

    cdef cppclass VideoMode:
        VideoMode()
        VideoMode(unsigned int width, unsigned int height)
        VideoMode(unsigned int width, unsigned int height,
                  unsigned int bits_per_pixel)
        bint isValid()
        unsigned int width
        unsigned int height
        unsigned int bitsPerPixel


    cdef cppclass Image:
        Image()
        Image(Image&)
        void copy(Image&, unsigned int, unsigned int)
        void copy(Image&, unsigned int, unsigned int, IntRect&)
        void copy(Image&, unsigned int, unsigned int, IntRect&, bint)
        bint create(unsigned int, unsigned int)
        bint create(unsigned int, unsigned int, Color&)
        bint create(unsigned int, unsigned int, Uint8*)
        void createMaskFromColor(Color&)
        void createMaskFromColor(Color&, unsigned char)
        Color& getPixel(unsigned int, unsigned int)
        unsigned char* getPixelsPtr()
        Vector2u getSize()
        bint loadFromFile(char*)
        bint loadFromMemory(void*, size_t)
        bint saveToFile(string&)
        bint saveToFile(char*)
        void setPixel(unsigned int, unsigned int, Color&)

    cdef cppclass Texture:
        Texture()
        Texture(Texture&)
        void bind()
        Image copyToImage()
        bint create(unsigned int, unsigned int)
        Vector2u getSize()
        bint isRepeated()
        bint isSmooth()
        bint loadFromFile(char*)
        bint loadFromFile(char*, IntRect&)
        bint loadFromImage(Image&)
        bint loadFromImage(Image&, IntRect&)
        bint loadFromMemory(void*, size_t)
        bint loadFromMemory(void*, size_t, IntRect&)
        # bint loadFromStream(InputStream&)
        # bint loadFromStream(InputStream&, IntRect&)
        void setRepeated(bint)
        void setSmooth(bint)
        void update(Uint8*)
        void update(Uint8*, unsigned int, unsigned int, unsigned int,
                    unsigned int)
        void update(Image&)
        void update(Image&, unsigned int, unsigned int)
        void update(RenderWindow&)
        void update(RenderWindow&, unsigned int, unsigned int)

    cdef cppclass String:
        String()
        String(Uint32*)
        Uint32* getData()
        size_t getSize()
        string toAnsiString()

    cdef cppclass Glyph:
        Glyph()
        int advance
        IntRect bounds
        IntRect textureRect

    cdef cppclass Font:
        Font()
        Font(Font&)
        Glyph& getGlyph(Uint32, unsigned int, bint)
        Texture& getTexture(unsigned int)
        int getKerning(Uint32, Uint32, unsigned int)
        int getLineSpacing(unsigned int)
        bint loadFromFile(char*)
        bint loadFromMemory(void*, size_t)

    cdef cppclass Drawable:
        pass

    cdef cppclass Transformable:
        Transformable()
        Vector2f& getOrigin()
        Vector2f& getPosition()
        float getRotation()
        Vector2f& getScale()
        Transform& getTransform()
        Transform& getInverseTransform()
        void move(float, float)
        void move(Vector2f&)
        void rotate(float)
        void scale(float, float)
        void scale(Vector2f&)
        void setOrigin(float, float)
        void setOrigin(Vector2f&)
        void setPosition(float, float)
        void setPosition(Vector2f&)
        void setRotation(float)
        void setScale(float, float)
        void setScale(Vector2f&)        

    cdef cppclass Text:
        Text()
        Text(char*)
        Text(char*, Font&)
        Text(char*, Font&, unsigned int)
        Text(String&)
        Text(String&, Font&)
        Text(String&, Font&, unsigned int)
        Vector2f findCharacterPos(size_t)
        unsigned int getCharacterSize()
        Color& getColor()
        Font& getFont()
        FloatRect getGlobalBounds()
        FloatRect getLocalBounds()
        String& getString()
        unsigned long getStyle()
        void setCharacterSize(unsigned int)
        void setColor(Color&)
        void setFont(Font&)
        void setString(char*)
        void setString(String&)
        void setStyle(unsigned long)

    cdef cppclass Sprite:
        Sprite()
        Sprite(Texture&)
        Sprite(Texture&, IntRect&)
        Sprite(Sprite&)
        Color& getColor()
        FloatRect getGlobalBounds()
        FloatRect getLocalBounds()
        Texture* getTexture()
        IntRect& getTextureRect()
        void setColor(Color&)
        void setTexture(Texture&)
        void setTexture(Texture&, bint)
        void setTextureRect(IntRect&)

    cdef cppclass View:
        View()
        View(FloatRect&)
        View(Vector2f&, Vector2f&)
        Vector2f& getCenter()
        Transform& getInverseTransform()
        Transform& getTransform()
        float getRotation()
        FloatRect& getViewport()
        Vector2f& getSize()
        void move(float, float)
        void move(Vector2f&)
        void reset(FloatRect&)
        void rotate(float)
        void setCenter(float, float)
        void setCenter(Vector2f&)
        void setFromRect(FloatRect&)
        void setRotation(float)
        void setSize(float, float)
        void setSize(Vector2f&)
        void setViewport(FloatRect&)
        void zoom(float)

    cdef cppclass Shader:
        Shader()
        Shader(Shader)
        void bind()
        bint loadFromFile(char*, declshader.Type)
        bint loadFromFile(char*, char*)
        bint loadFromMemory(char*, declshader.Type)
        bint loadFromMemory(char*, char*)
        # bint loadFromStream(InputStream&, declshader.Type)
        # bint loadFromStream(InputStream&, InputStream&)
        void setCurrentTexture(char*)
        void setParameter(char*, float)
        void setParameter(char*, float, float)
        void setParameter(char*, float, float, float)
        void setParameter(char*, float, float, float, float)
        void setParameter(char*, Vector2f&)
        void setParameter(char*, Vector3f&)
        void setParameter(char*, Color&)
        void setParameter(char*, Transform&)
        void setParameter(char*, Texture&)
        void setParameter(char*, declshader.CurrentTexture)
        void unbind()

    cdef cppclass ContextSettings:
        ContextSettings()
        ContextSettings(unsigned int)
        ContextSettings(unsigned int, unsigned int)
        ContextSettings(unsigned int, unsigned int, unsigned int)
        ContextSettings(unsigned int, unsigned int, unsigned int, unsigned int)
        ContextSettings(unsigned int, unsigned int, unsigned int, unsigned int,
                        unsigned int)
        unsigned int antialiasingLevel
        unsigned int depthBits
        unsigned int majorVersion
        unsigned int minorVersion
        unsigned int stencilBits

    cdef cppclass WindowHandle:
        pass

    cdef cppclass RenderStates:
        RenderStates()
        RenderStates(RenderStates&)
        BlendMode blendMode
        Shader* shader
        Texture* texture
        Transform transform

    cdef cppclass Vertex:
        Vertex()
        Vertex(Vector2f&)
        Vertex(Vector2f&, Color&)
        Vertex(Vector2f&, Vector2f&)
        Vertex(Vector2f&, Color&, Vector2f&)
        Vector2f position
        Color color
        Vector2f texCoords

    cdef cppclass VertexArray:
        VertexArray()
        VertexArray(PrimitiveType, unsigned int)
        Vertex& operator[](unsigned int)
        void append(Vertex&)
        void clear()
        FloatRect getBounds()
        PrimitiveType getPrimitiveType()
        unsigned int getVertexCount()
        void resize(unsigned int)
        void setPrimitiveType(PrimitiveType)

    cdef cppclass RenderTarget:
        void clear()
        void clear(Color&)
        void draw(Drawable&)
        void draw(Drawable&, Shader*)
        void draw(Drawable&, RenderStates&)
        void draw(Vertex*, unsigned int, PrimitiveType)
        void draw(Vertex*, unsigned int, PrimitiveType, RenderStates&)
        void draw(Vertex*, unsigned int, PrimitiveType, Shader*)
        Vector2u getSize()
        void setView(View&)
        View& getView()
        View& getDefaultView()
        IntRect getViewport(View&)
        Vector2f convertCoords(Vector2i&)
        Vector2f convertCoords(Vector2i&, View&)
        void popGLStates()
        void pushGLStates()
        void resetGLStates()

    cdef cppclass RenderWindow:
        RenderWindow()
        RenderWindow(VideoMode, char*)
        RenderWindow(VideoMode, char*, unsigned long)
        RenderWindow(VideoMode, char*, unsigned long, ContextSettings&)
        RenderWindow(WindowHandle window_handle)
        RenderWindow(WindowHandle window_handle, ContextSettings&)
        void close()
        void create(VideoMode, char*)
        void create(VideoMode, char*, unsigned long)
        void create(VideoMode, char*, unsigned long, ContextSettings&)
        void display() nogil
        void enableVerticalSync(bint)
        Vector2i getPosition()
        ContextSettings& getSettings()
        unsigned long getSystemHandle()
        bint isOpen()
        bint pollEvent(Event&)
        void setActive()
        void setActive(bint)
        void setIcon(unsigned int, unsigned int, Uint8*)
        void setJoystickThreshold(float)
        void setFramerateLimit(unsigned int)
        void setKeyRepeatEnabled(bint)
        void setMouseCursorVisible(bint)
        void setPosition(Vector2i&)
        void setSize(Vector2u)
        void setTitle(char*)
        void setVerticalSyncEnabled(bint)
        void setVisible(bint)
        bint waitEvent(Event&)

    cdef cppclass RenderTexture:
        RenderTexture()
        bint create(unsigned int, unsigned int)
        bint create(unsigned int, unsigned int, bint depth)
        void setSmooth(bint)
        bint isSmooth()
        bint setActive()
        bint setActive(bint)
        void display()
        Texture& getTexture()
        bint isAvailable()
    
    cdef cppclass Shape:
        Shape()
        Color& getFillColor()
        FloatRect getLocalBounds()
        FloatRect getGlobalBounds()
        Transform& getInverseTransform()
        Vector2f& getOrigin()
        Color& getOutlineColor()
        float getOutlineThickness()
        Vector2f getPoint(unsigned int)
        unsigned int getPointCount()
        Vector2f& getPosition()
        float getRotation()
        Vector2f& getScale()
        Texture* getTexture()
        IntRect& getTextureRect()
        Transform& getTransform()
        void move(float, float)
        void move(Vector2f&)
        void rotate(float)
        void setFillColor(Color&)
        void scale(float, float)
        void scale(Vector2f&)
        void setOrigin(float, float)
        void setOrigin(Vector2f&)
        void setOutlineColor(Color&)
        void setOutlineThickness(float)
        void setPosition(float, float)
        void setPosition(Vector2f&)
        void setRotation(float)
        void setScale(float, float)
        void setScale(Vector2f&)
        void setTexture(Texture*)
        void setTexture(Texture*, bint)
        void setTextureRect(IntRect&)

    cdef cppclass RectangleShape:
        RectangleShape()
        RectangleShape(Vector2f&)
        Vector2f& getSize()
        void setSize(Vector2f&)

    cdef cppclass CircleShape:
        CircleShape()
        CircleShape(float)
        CircleShape(float, unsigned int)
        unsigned int getPointCount()
        float getRadius()
        void setPointCount(unsigned int)
        void setRadius(float)

    cdef cppclass ConvexShape:
        ConvexShape()
        ConvexShape(unsigned int)
        Vector2f getPoint(unsigned int)
        unsigned int getPointCount()
        void setPoint(unsigned int, Vector2f&)
        void setPointCount(unsigned int)


# Hacks for static methods and attributes. Some similar hacks are
# created in seperate files, mainly for enums, e.g. declevents.pxd
cdef extern from "SFML/Graphics.hpp":
    cdef Time Time_Zero "sf::Time::Zero"
    cdef int Shader_Fragment "sf::Shader::Fragment"
    cdef int Shader_Vertex "sf::Shader::Vertex"
    cdef Time Time_seconds "sf::seconds" (float)
    cdef Time Time_milliseconds "sf::milliseconds" (Int32)
    cdef Time Time_microseconds "sf::microseconds" (Int64)
    RenderStates RenderStates_Default "sf::RenderStates::Default"
    cdef VideoMode& VideoMode_getDesktopMode "sf::VideoMode::getDesktopMode" ()
    cdef vector[VideoMode]& getFullscreenModes "sf::VideoMode::getFullscreenModes" ()
    cdef Transform Transform_Identity "sf::Transform::Identity"
    cdef unsigned int Texture_getMaximumSize "sf::Texture::getMaximumSize"()
    cdef Font& Font_getDefaultFont "sf::Font::getDefaultFont" ()
    cdef bint Shader_isAvailable "sf::Shader::isAvailable" ()
