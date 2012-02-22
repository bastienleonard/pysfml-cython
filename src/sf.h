#ifndef __PYX_HAVE__sf
#define __PYX_HAVE__sf


#ifndef __PYX_HAVE_API__sf

#ifndef __PYX_EXTERN_C
  #ifdef __cplusplus
    #define __PYX_EXTERN_C extern "C"
  #else
    #define __PYX_EXTERN_C extern
  #endif
#endif

__PYX_EXTERN_C DL_IMPORT(void) set_error_message(char *);
__PYX_EXTERN_C DL_IMPORT(sf::Vector2f) convert_to_vector2f(PyObject *);
__PYX_EXTERN_C DL_IMPORT(struct __pyx_obj_2sf_RenderStates) *wrap_render_states_instance(sf::RenderStates *);
__PYX_EXTERN_C DL_IMPORT(struct __pyx_obj_2sf_RenderTarget) *wrap_render_target_instance(sf::RenderTarget *);

#endif /* !__PYX_HAVE_API__sf */

#if PY_MAJOR_VERSION < 3
PyMODINIT_FUNC initsf(void);
#else
PyMODINIT_FUNC PyInit_sf(void);
#endif

#endif /* !__PYX_HAVE__sf */
