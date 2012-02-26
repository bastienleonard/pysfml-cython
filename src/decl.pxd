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
        unsigned int GetPointCount()
        Vector2f GetPoint(unsigned int)
        void Update()

    cdef cppclass CppSoundStream:
        CppSoundStream()
        CppSoundStream(void*)
        void Initialize(unsigned int, unsigned int)
        void Play()
        void *sound_stream


cdef extern from "SFML/Graphics.hpp" namespace "sf::Event":
    cdef struct SizeEvent:
        unsigned int Width
        unsigned int Height

    cdef struct KeyEvent:
        int Code
        bint Alt
        bint Control
        bint Shift
        bint System

    cdef struct MouseMoveEvent:
        int X
        int Y

    cdef struct MouseButtonEvent:
        int Button
        int X
        int Y

    cdef struct TextEvent:
        int Unicode

    cdef struct MouseWheelEvent:
        int Delta
        int X
        int Y

    cdef struct JoystickMoveEvent:
        unsigned int JoystickId
        int Axis
        float Position

    cdef struct JoystickButtonEvent:
        unsigned int JoystickId
        unsigned int Button

    cdef struct JoystickConnectEvent:
        unsigned int JoystickId



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

    cdef cppclass Vector3f:
        Vector3f()
        Vector3f(float, float, float)
        float x
        float y
        float z

    cdef cppclass IntRect:
        IntRect()
        IntRect(int, int, int, int)
        bint Contains(int, int)
        bint Intersects(IntRect&)
        bint Intersects(IntRect&, IntRect&)
        int Left
        int Top
        int Width
        int Height

    cdef cppclass FloatRect:
        FloatRect()
        FloatRect(float, float, float, float)
        bint Contains(int, int)
        bint Intersects(FloatRect&)
        bint Intersects(FloatRect&, FloatRect&)
        float Left
        float Top
        float Width
        float Height

    cdef cppclass Transform:
        Transform()
        Transform(float, float, float,
                  float, float, float,
                  float, float, float)
        Transform(Transform&)
        Transform Combine(Transform&)
        Transform GetInverse()
        float* GetMatrix()
        Transform& Rotate(float)
        Transform& Rotate(float, float, float)
        Transform& Rotate(float, Vector2f&)
        Transform& Scale(float, float)
        Transform& Scale(float, float, float, float)
        Transform& Scale(Vector2f&)
        Transform& Scale(Vector2f&, Vector2f&)
        Vector2f TransformPoint(float, float)
        Vector2f TransformPoint(Vector2f&)
        FloatRect TransformRect(FloatRect&)
        Transform& Translate(float, float)
        Transform& Translate(Vector2f&)

        Transform operator*(Transform&)
        Vector2f operator*(Vector2f&)
        # Transform operator*=(Transform&, Transform&)

    cdef cppclass Time:
        Time()
        Time(Time)
        float AsSeconds()
        Uint32 AsMilliseconds()
        Int64 AsMicroseconds()
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
        Time GetElapsedTime()
        Time Restart()

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
        int Type
        SizeEvent Size
        KeyEvent Key
        MouseMoveEvent MouseMove
        MouseButtonEvent MouseButton
        TextEvent Text
        MouseWheelEvent MouseWheel
        JoystickMoveEvent JoystickMove
        JoystickButtonEvent JoystickButton
        JoystickConnectEvent JoystickConnect

    cdef cppclass VideoMode:
        VideoMode()
        VideoMode(unsigned int width, unsigned int height)
        VideoMode(unsigned int width, unsigned int height,
                  unsigned int bits_per_pixel)
        bint IsValid()
        unsigned int Width
        unsigned int Height
        unsigned int BitsPerPixel


    cdef cppclass Image:
        Image()
        Image(Image&)
        void Copy(Image&, unsigned int, unsigned int)
        void Copy(Image&, unsigned int, unsigned int, IntRect&)
        void Copy(Image&, unsigned int, unsigned int, IntRect&, bint)
        bint Create(unsigned int, unsigned int)
        bint Create(unsigned int, unsigned int, Color&)
        bint Create(unsigned int, unsigned int, Uint8*)
        void CreateMaskFromColor(Color&)
        void CreateMaskFromColor(Color&, unsigned char)
        unsigned int GetHeight()
        Color& GetPixel(unsigned int, unsigned int)
        unsigned char* GetPixelsPtr()
        unsigned int GetWidth() 
        bint LoadFromFile(char*)
        bint LoadFromMemory(void*, size_t)
        bint SaveToFile(string&)
        bint SaveToFile(char*)
        void SetPixel(unsigned int, unsigned int, Color&)

    cdef cppclass Texture:
        Texture()
        Texture(Texture&)
        void Bind()
        Image CopyToImage()
        bint Create(unsigned int, unsigned int)
        unsigned int GetHeight()
        unsigned int GetWidth()
        bint IsRepeated()
        bint IsSmooth()
        bint LoadFromFile(char*)
        bint LoadFromFile(char*, IntRect&)
        bint LoadFromImage(Image&)
        bint LoadFromImage(Image&, IntRect&)
        bint LoadFromMemory(void*, size_t)
        bint LoadFromMemory(void*, size_t, IntRect&)
        # bint LoadFromStream(InputStream&)
        # bint LoadFromStream(InputStream&, IntRect&)
        void SetRepeated(bint)
        void SetSmooth(bint)
        void Update(Uint8*)
        void Update(Uint8*, unsigned int, unsigned int, unsigned int,
                    unsigned int)
        void Update(Image&)
        void Update(Image&, unsigned int, unsigned int)
        void Update(RenderWindow&)
        void Update(RenderWindow&, unsigned int, unsigned int)

    cdef cppclass String:
        String()
        String(Uint32*)
        Uint32* GetData()
        size_t GetSize()
        string ToAnsiString()

    cdef cppclass Glyph:
        Glyph()
        int Advance
        IntRect Bounds
        IntRect TextureRect

    cdef cppclass Font:
        Font()
        Font(Font&)
        Glyph& GetGlyph(Uint32, unsigned int, bint)
        Texture& GetTexture(unsigned int)
        int GetKerning(Uint32, Uint32, unsigned int)
        int GetLineSpacing(unsigned int)
        bint LoadFromFile(char*)
        bint LoadFromMemory(void*, size_t)

    cdef cppclass Drawable:
        pass

    cdef cppclass Transformable:
        Transformable()
        Vector2f& GetOrigin()
        Vector2f& GetPosition()
        float GetRotation()
        Vector2f& GetScale()
        Transform& GetTransform()
        Transform& GetInverseTransform()
        void Move(float, float)
        void Move(Vector2f&)
        void Rotate(float)
        void Scale(float, float)
        void Scale(Vector2f&)
        void SetOrigin(float, float)
        void SetOrigin(Vector2f&)
        void SetPosition(float, float)
        void SetPosition(Vector2f&)
        void SetRotation(float)
        void SetScale(float, float)
        void SetScale(Vector2f&)        

    cdef cppclass Text:
        Text()
        Text(char*)
        Text(char*, Font&)
        Text(char*, Font&, unsigned int)
        Text(String&)
        Text(String&, Font&)
        Text(String&, Font&, unsigned int)
        Vector2f FindCharacterPos(size_t)
        unsigned int GetCharacterSize()
        Color& GetColor()
        Font& GetFont()
        FloatRect GetGlobalBounds()
        FloatRect GetLocalBounds()
        String& GetString()
        unsigned long GetStyle()
        void SetCharacterSize(unsigned int)
        void SetColor(Color&)
        void SetFont(Font&)
        void SetString(char*)
        void SetString(String&)
        void SetStyle(unsigned long)

    cdef cppclass Sprite:
        Sprite()
        Sprite(Texture&)
        Sprite(Texture&, IntRect&)
        Color& GetColor()
        FloatRect GetGlobalBounds()
        FloatRect GetLocalBounds()
        Texture* GetTexture()
        IntRect& GetTextureRect()
        void SetColor(Color&)
        void SetTexture(Texture&)
        void SetTexture(Texture&, bint)
        void SetTextureRect(IntRect&)

    cdef cppclass View:
        View()
        View(FloatRect&)
        View(Vector2f&, Vector2f&)
        Vector2f& GetCenter()
        Transform& GetInverseTransform()
        Transform& GetTransform()
        float GetRotation()
        FloatRect& GetViewport()
        Vector2f& GetSize()
        void Move(float, float)
        void Move(Vector2f&)
        void Reset(FloatRect&)
        void Rotate(float)
        void SetCenter(float, float)
        void SetCenter(Vector2f&)
        void SetFromRect(FloatRect&)
        void SetRotation(float)
        void SetSize(float, float)
        void SetSize(Vector2f&)
        void SetViewport(FloatRect&)
        void Zoom(float)

    cdef cppclass Shader:
        Shader()
        Shader(Shader)
        void Bind()
        bint LoadFromFile(char*, declshader.Type)
        bint LoadFromFile(char*, char*)
        bint LoadFromMemory(char*, declshader.Type)
        bint LoadFromMemory(char*, char*)
        # bint LoadFromStream(InputStream&, declshader.Type)
        # bint LoadFromStream(InputStream&, InputStream&)
        void SetCurrentTexture(char*)
        void SetParameter(char*, float)
        void SetParameter(char*, float, float)
        void SetParameter(char*, float, float, float)
        void SetParameter(char*, float, float, float, float)
        void SetParameter(char*, Vector2f&)
        void SetParameter(char*, Vector3f&)
        void SetParameter(char*, Color&)
        void SetParameter(char*, Transform&)
        void SetParameter(char*, Texture&)
        void SetParameter(char*, declshader.CurrentTexture)
        void Unbind()

    cdef cppclass ContextSettings:
        ContextSettings()
        ContextSettings(unsigned int)
        ContextSettings(unsigned int, unsigned int)
        ContextSettings(unsigned int, unsigned int, unsigned int)
        ContextSettings(unsigned int, unsigned int, unsigned int, unsigned int)
        ContextSettings(unsigned int, unsigned int, unsigned int, unsigned int,
                        unsigned int)
        unsigned int AntialiasingLevel
        unsigned int DepthBits
        unsigned int MajorVersion
        unsigned int MinorVersion
        unsigned int StencilBits

    cdef cppclass WindowHandle:
        pass

    cdef cppclass RenderStates:
        RenderStates()
        RenderStates(RenderStates&)
        BlendMode BlendMode
        Shader* Shader
        Texture* Texture
        Transform Transform

    cdef cppclass Vertex:
        Vertex()
        Vertex(Vector2f&)
        Vertex(Vector2f&, Color&)
        Vertex(Vector2f&, Vector2f&)
        Vertex(Vector2f&, Color&, Vector2f&)
        Vector2f Position
        Color Color
        Vector2f TexCoords

    cdef cppclass VertexArray:
        VertexArray()
        VertexArray(PrimitiveType, unsigned int)
        Vertex& operator[](unsigned int)
        void Append(Vertex&)
        void Clear()
        FloatRect GetBounds()
        PrimitiveType GetPrimitiveType()
        unsigned int GetVertexCount()
        void Resize(unsigned int)
        void SetPrimitiveType(PrimitiveType)

    cdef cppclass RenderTarget:
        void Clear()
        void Clear(Color&)
        void Draw(Drawable&)
        void Draw(Drawable&, Shader*)
        void Draw(Drawable&, RenderStates&)
        void Draw(Vertex*, unsigned int, PrimitiveType)
        void Draw(Vertex*, unsigned int, PrimitiveType, RenderStates&)
        void Draw(Vertex*, unsigned int, PrimitiveType, Shader*)
        unsigned int GetHeight()
        unsigned int GetWidth()
        void SetView(View&)
        View& GetView()
        View& GetDefaultView()
        IntRect GetViewport(View&)
        Vector2f ConvertCoords(unsigned int, unsigned int)
        Vector2f ConvertCoords(unsigned int, unsigned int, View&)
        void PopGLStates()
        void PushGLStates()
        void ResetGLStates()

    cdef cppclass RenderWindow:
        RenderWindow()
        RenderWindow(VideoMode, char*)
        RenderWindow(VideoMode, char*, unsigned long)
        RenderWindow(VideoMode, char*, unsigned long, ContextSettings&)
        RenderWindow(WindowHandle window_handle)
        RenderWindow(WindowHandle window_handle, ContextSettings&)
        void Close()
        void Create(VideoMode, char*)
        void Create(VideoMode, char*, unsigned long)
        void Create(VideoMode, char*, unsigned long, ContextSettings&)
        void Display()
        void EnableKeyRepeat(bint)
        void EnableVerticalSync(bint)
        ContextSettings& GetSettings()
        unsigned long GetSystemHandle()
        bint IsOpen()
        bint PollEvent(Event&)
        void SetActive()
        void SetActive(bint)
        void SetIcon(unsigned int, unsigned int, Uint8*)
        void SetJoystickThreshold(float)
        void SetFramerateLimit(unsigned int)
        void SetPosition(int, int)
        void SetSize(unsigned int, unsigned int)
        void SetTitle(char*)
        void Show(bint)
        void ShowMouseCursor(bint)
        void UseVerticalSync(bint)
        bint WaitEvent(Event&)

    cdef cppclass RenderTexture:
        RenderTexture()
        bint Create(unsigned int, unsigned int)
        bint Create(unsigned int, unsigned int, bint depth)
        void SetSmooth(bint)
        bint IsSmooth()
        bint SetActive()
        bint SetActive(bint)
        void Display()
        Texture& GetTexture()
        bint IsAvailable()
    
    cdef cppclass Shape:
        Shape()
        Color& GetFillColor()
        FloatRect GetLocalBounds()
        FloatRect GetGlobalBounds()
        Transform& GetInverseTransform()
        Vector2f& GetOrigin()
        Color& GetOutlineColor()
        float GetOutlineThickness()
        Vector2f GetPoint(unsigned int)
        unsigned int GetPointCount()
        Vector2f& GetPosition()
        float GetRotation()
        Vector2f& GetScale()
        Texture* GetTexture()
        IntRect& GetTextureRect()
        Transform& GetTransform()
        void Move(float, float)
        void Move(Vector2f&)
        void Rotate(float)
        void SetFillColor(Color&)
        void Scale(float, float)
        void Scale(Vector2f&)
        void SetOrigin(float, float)
        void SetOrigin(Vector2f&)
        void SetOutlineColor(Color&)
        void SetOutlineThickness(float)
        void SetPosition(float, float)
        void SetPosition(Vector2f&)
        void SetRotation(float)
        void SetScale(float, float)
        void SetScale(Vector2f&)
        void SetTexture(Texture*)
        void SetTexture(Texture*, bint)
        void SetTextureRect(IntRect&)

    cdef cppclass RectangleShape:
        RectangleShape()
        RectangleShape(Vector2f&)
        Vector2f& GetSize()
        void SetSize(Vector2f&)

    cdef cppclass CircleShape:
        CircleShape()
        CircleShape(float)
        CircleShape(float, unsigned int)
        unsigned int GetPointCount()
        float GetRadius()
        void SetPointCount(unsigned int)
        void SetRadius(float)

    cdef cppclass ConvexShape:
        ConvexShape()
        ConvexShape(unsigned int)
        unsigned int GetPointCount()
        void SetPointCount(unsigned int)


# Hacks for static methods and attributes. Some similar hacks are
# created in seperate files, mainly for enums, e.g. declevents.pxd
cdef extern from "SFML/Graphics.hpp":
    cdef Time Time_Zero "sf::Time::Zero"
    cdef int Shader_Fragment "sf::Shader::Fragment"
    cdef int Shader_Vertex "sf::Shader::Vertex"
    cdef Time Time_Seconds "sf::Seconds" (float)
    cdef Time Time_Milliseconds "sf::Milliseconds" (Int32)
    cdef Time Time_Microseconds "sf::Microseconds" (Int64)
    RenderStates RenderStates_Default "sf::RenderStates::Default"
    cdef VideoMode& VideoMode_GetDesktopMode "sf::VideoMode::GetDesktopMode" ()
    cdef vector[VideoMode]& GetFullscreenModes "sf::VideoMode::GetFullscreenModes" ()
    cdef Transform Transform_Identity "sf::Transform::Identity"
    cdef unsigned int Texture_GetMaximumSize "sf::Texture::GetMaximumSize"()
    cdef Font& Font_GetDefaultFont "sf::Font::GetDefaultFont" ()
    cdef bint Shader_IsAvailable "sf::Shader::IsAvailable" ()
