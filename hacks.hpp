#ifndef H_HACKS
#define H_HACKS

#include "Python.h"
#include <SFML/Graphics.hpp>


void replace_error_handler();

// This function simply does a dynamic cast, as it's not available in
// Cython, apparently
sf::Drawable* transformable_to_drawable(sf::Transformable *t);

extern "C"
{
    struct __pyx_obj_2sf_RenderTarget* wrap_render_target_instance(
        sf::RenderTarget*);
    struct __pyx_obj_2sf_RenderStates* wrap_render_states_instance(
        sf::RenderStates*);
}

// See this class like Shape, Sprite and Text. They have already defined
// their Render method and if we want to make Drawable derivable with 
// python, this virtual method has to be defined too which can not be
// done with cython. Therefore this class is needed to call the suitable
// python method; render(self, target, renderer)
class CppDrawable : public sf::Drawable
{
public :
    CppDrawable();
    CppDrawable(void* drawable);
    void* drawable; // this is a PyObject pointer

private :
    virtual void Draw(sf::RenderTarget& target, sf::RenderStates states) const;
};

#endif
