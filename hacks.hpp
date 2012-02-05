// Copyright 2011, 2012 Bastien Léonard. All rights reserved.

// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions
// are met:

//    1. Redistributions of source code must retain the above copyright
//    notice, this list of conditions and the following disclaimer.

//    2. Redistributions in binary form must reproduce the above
//    copyright notice, this list of conditions and the following
//    disclaimer in the documentation and/or other materials provided
//    with the distribution.

// THIS SOFTWARE IS PROVIDED BY BASTIEN LÉONARD ``AS IS'' AND ANY
// EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
// PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL BASTIEN LÉONARD OR
// CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
// SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
// LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF
// USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
// ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
// OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT
// OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
// SUCH DAMAGE.


#ifndef H_HACKS
#define H_HACKS

#include "Python.h"
#include <SFML/Graphics.hpp>

#if PY_MAJOR_VERSION >= 3
#define IS_PY3K
#endif


void replace_error_handler();

// This function simply does a dynamic cast, as it's not available in
// Cython, apparently
sf::Drawable* transformable_to_drawable(sf::Transformable *t);

// TODO: move these declarations to the .cpp file, and see if it fixes
// the MSVC build problem
extern "C"
{
    DL_IMPORT(struct __pyx_obj_2sf_RenderTarget)* wrap_render_target_instance(
        sf::RenderTarget*);
    DL_IMPORT(struct __pyx_obj_2sf_RenderStates)* wrap_render_states_instance(
        sf::RenderStates*);
    sf::Vector2f convert_to_vector2f(PyObject*);
}



// This is the same class as sf::Shape, but with a public Update()
// method. This allows to expose it a public method in Python.
class ShapeWithUpdate : public sf::Shape
{
public:
    void Update();
};


// Important: these Cpp* classes ``callback'' methods can't return a
// value to the Python caller to report errors. So the caller must
// check the current exception directly with PyErr_Occurred(). In
// Cython, the only way to do that is to add ``except *'' at the end
// of a function signature.

// See this class like Shape, Sprite and Text. They have already defined
// their Render method and if we want to make Drawable derivable with 
// python, this virtual method has to be defined too which can not be
// done with cython. Therefore this class is needed to call the suitable
// python method; render(self, target, renderer)
class CppDrawable : public sf::Drawable
{
public:
    CppDrawable();
    CppDrawable(void* drawable);
    virtual void Draw(sf::RenderTarget& target, sf::RenderStates states) const;

    void* drawable; // this is a PyObject pointer
};


class CppShape : public ShapeWithUpdate
{
public:
    CppShape();
    CppShape(void*);
    virtual unsigned int GetPointCount() const;
    virtual sf::Vector2f GetPoint(unsigned int index) const;
    void* shape;
};

#endif
