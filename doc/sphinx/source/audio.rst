.. Copyright 2011, 2012 Bastien Léonard. All rights reserved.

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


Audio
=====

.. currentmodule:: sf


.. class:: SoundBuffer

   The constructor will raise ``NotImplementedError``. Use one of the class
   methods instead.

   .. attribute:: channels_count
   .. attribute:: Time duration
   .. attribute:: sample_rate
   .. attribute:: samples
   .. attribute:: samples_count

   .. classmethod:: load_from_file(filename)
   .. classmethod:: load_from_memory(str data)
   .. classmethod:: load_from_samples(list samples, int channels_count,\
                                      int sample_rate)

   .. method:: save_to_file(filename)



.. class:: Sound([SoundBuffer buffer])

   .. attribute:: attenuation
   .. attribute:: buffer
   .. attribute:: loop
   .. attribute:: min_distance
   .. attribute:: pitch
   .. attribute:: Time playing_offset
   .. attribute:: position
   .. attribute:: relative_to_listener
   .. attribute:: status

      Read-only. Can be one of:

      * sf.Sound.STOPPED
      * sf.Sound.PAUSED
      * sf.Sound.PLAYING

   .. attribute:: volume

   .. method:: pause()
   .. method:: play()
   .. method:: stop()




.. class:: Chunk

   .. attribute:: sample_count

      Normally you should use ``len(self.samples)``, but accessing
      this attribute might be faster, since it just reads the
      appropriate C++ attribute.

   .. attribute:: samples

      Should be a string in Python 2, and bytes in Python 3.


.. class:: SoundStream

   Abstract class.

   To create your own sound stream, you must inherit this class and at
   least define a ``on_get_data()`` method that receives a
   :class:`Chunk` parameter. ``on_seek(Time)`` may be implemented as
   well. Any exception raised in these two methods will be printed to
   ``sys.stdout`` and swallowed. This is because it doesn't seem
   possible to catch an exception raised in another thread, or at
   least it doesn't seem reliable. So try to keep them as short as
   possible, and if they don't work, check the console. See
   ``examples/soundstream.py`` for an example.

   My streaming tests show that this class is still too slow. I
   optimized it as much as I could, and I'm not sure how to improve it
   now. Also, ``on_seek()`` seems to hang the program when seeking is
   used.

   .. attribute:: PAUSED
   .. attribute:: PLAYING
   .. attribute:: STOPPED

   .. attribute:: attenuation
   .. attribute:: channel_count
   .. attribute:: loop
   .. attribute:: min_distance
   .. attribute:: pitch
   .. attribute:: playing_offset
   .. attribute:: position
   .. attribute:: relative_to_listener
   .. attribute:: sample_rate
   .. attribute:: status
   .. attribute:: volume

   .. method:: initialize(int channel_count, int sample_rate)

      This method must be called by user-defined streams. It's not
      available from built-in sound streams such as :class:`Music`.

   .. method:: pause()
   .. method:: play()
   .. method:: stop()


.. class:: Music

   This class inherits :class:`SoundStream`.
   Will raise ``NotImplementedError`` if the constructor is called. Use class
   methods instead.

   .. attribute:: Time duration

   .. classmethod:: open_from_file(filename)
   .. classmethod:: open_from_memory(str data)
