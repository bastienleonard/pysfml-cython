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


#include "hacks.hpp"

#include <iostream>
#include <cassert>



// This file contains code that couldn't be written in Cython.



// C functions defined in sf.pyx
// Can't declare them in hacks.hpp because the const-qualifier will clash with
// the actual signature (Cython doesn't support const pointers)
extern "C"
{
    void set_error_message(const char* message);
}


// This should be big enough to contain any message error
static const int ERROR_MESSAGE_BUFFER_SIZE = 512;



sf::Drawable* transformable_to_drawable(sf::Transformable *t)
{
    return dynamic_cast<sf::Drawable*>(t);
}

// A custom streambuf that will put error messages in a Python dict
class MyBuff : public std::streambuf
{
public:
    MyBuff()
    {
        buffer = new char[ERROR_MESSAGE_BUFFER_SIZE];
        setp(buffer, buffer + ERROR_MESSAGE_BUFFER_SIZE);
    }

    ~MyBuff()
    {
        delete[] pbase();
    }

private:
    char* buffer;

    // This code is from SFML's bufstream. In our case overflow()
    // should never get called, unless I missed something. But I don't
    // undestand why it would get called when there's no overflow
    // either (i.e., when pptr() != epptr()), so let's be on the safe
    // side.
    virtual int overflow(int character)
    {
        if (character != EOF && pptr() != epptr())
        {
            // Valid character
            return sputc(static_cast<char>(character));
        }
        else if (character != EOF)
        {
            // Not enough space in the buffer: synchronize output and try again
            sync();
            return overflow(character);
        }
        else
        {
            // Invalid character: synchronize output
            return sync();
        }
    }

    virtual int sync()
    {
        if (pbase() != pptr())
        {
            // Replace '\n' at the end of the message with '\0'
            *(pptr() - 1) = '\0';

            // Call the function in sf.pyx that handles new messages
            set_error_message(pbase());

            setp(pbase(), epptr());
        }

        return 0;
    }
};


void replace_error_handler()
{
    static MyBuff my_buff;
    sf::Err().rdbuf(&my_buff);
}



CppDrawable::CppDrawable()
{
}

CppDrawable::CppDrawable(void* drawable):
    sf::Drawable(),
    drawable(drawable)
{
}

void CppDrawable::Draw(sf::RenderTarget& target, sf::RenderStates states) const
{
    // The string parameters to PyObject_CallMethod() are char*, so in
    // theory they can be modified, and string litterals are const char*
    char method_name[] = "render";
    char format[] = "(O, O)";
    PyObject* py_target = (PyObject*)(wrap_render_target_instance(&target));
    PyObject* py_states = (PyObject*)(wrap_render_states_instance(&states));
    
    // The caller needs to use PyErr_Occurred() to know if this
    // function failed
    PyObject* ret = PyObject_CallMethod(
        static_cast<PyObject*>(drawable), method_name, format,
        py_target, py_states);

    if (ret != NULL)
    {
        Py_DECREF(ret);
    }
}



void ShapeWithUpdate::Update()
{
    sf::Shape::Update();
}


CppShape::CppShape()
{
}

CppShape::CppShape(void* shape) : shape(shape)
{
}

unsigned int CppShape::GetPointCount() const
{
    char method_name[] = "get_point_count";
    char format[] = "";
    PyObject* ret = PyObject_CallMethod(
        static_cast<PyObject*>(shape), method_name, format);
    long count = 0;

    if (ret != NULL)
    {
#ifndef IS_PY3K
        if (!PyInt_Check(ret))
#else
        if (!PyLong_Check(ret))
#endif
        {
            PyErr_SetString(PyExc_TypeError,
                            "get_point_count() must return an integer");
        }

#ifndef IS_PY3K
        count = PyInt_AsLong(ret);
#else
        count = PyLong_AsLong(ret);
#endif
        Py_DECREF(ret);
    }

    return count;
}

sf::Vector2f CppShape::GetPoint(unsigned int index) const
{
    char method_name[] = "get_point";
    char format[] ="I";
    PyObject *ret = PyObject_CallMethod(
        static_cast<PyObject*>(shape), method_name, format, index);
    sf::Vector2f point;

    if (ret != NULL)
    {
        point = convert_to_vector2f(ret);
        Py_DECREF(ret);
    }

    return point;
}
