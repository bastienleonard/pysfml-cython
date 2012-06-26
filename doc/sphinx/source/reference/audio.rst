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

.. currentmodule:: sfml


.. class:: Chunk

   A chunk of audio data to stream. See :class:`SoundStream`.

   .. attribute:: samples

      Should be a string in Python 2, and bytes in Python 3.


.. class:: Listener

   The audio listener is the point in the scene from where all the
   sounds are heard. The audio listener defines the global properties
   of the audio environment: where and how sounds and musics are
   heard.

   If :class:`View` is the eyes of the user, then :class:`Listener` is his
   ears (they are often linked together -- same position,
   orientation, etc.).

   Because the listener is unique in the scene, this class only
   contains static functions and doesn't have to be
   instanciated. Calling the constructor will raise
   ``NotImplementedError``.

   Usage example::

       # Move the listener to the position (1, 0, -5)
       sfml.Listener.set_position(1, 0, -5)

       # Make it face the right axis (1, 0, 0)
       sfml.Listener.set_direction(1, 0, 0)

       # Reduce the global volume
       sfml.Listener.set_global_volume(50)

   .. classmethod:: get_direction()

      Get the current direction of the listener in the scene, as a
      tuple of three floats.

   .. classmethod:: get_global_volume()

      Get the current value of the global volume, as a ``float``.

   .. classmethod:: get_position()

      Get the current position of the listener in the scene, as a
      tuple of three floats.

   .. classmethod:: set_global_volume(float volume)

      Change the global volume of all the sounds and musics.

      The volume is a number between 0 and 100; it is combined with
      the individual volume of each sound / music. The default value
      for the volume is 100 (maximum).

   .. classmethod:: set_direction(float x, float y, float z)

      Set the orientation of the listener in the scene.

      The orientation defines the 3D axes of the listener (left, up,
      front) in the scene. The orientation vector doesn't have to be
      normalized. The default listener's orientation is (0, 0, -1).

   .. classmethod:: set_position(float x, float y, float z)

      Set the position of the listener in the scene.

      The default listener's position is (0, 0, 0).


.. class:: Music

   This class inherits :class:`SoundStream`.  Will raise
   ``NotImplementedError`` if the constructor is called. Use class
   methods instead.

   Streamed music played from an audio file. Musics are sounds that
   are streamed rather than completely loaded in memory.

   This is especially useful for compressed musics that usually take
   hundreds of MB when they are uncompressed: by streaming it instead
   of loading it entirely, you avoid saturating the memory and have
   almost no loading delay.

   Apart from that, a Music object has almost the same features as the
   :class:`SoundBuffer`/:class:`Sound` pair: you can play/pause/stop
   it, request its parameters (channels, sample rate), change the way
   it is played (pitch, volume, 3D position, ...), etc.

   As a sound stream, a music is played in its own thread in order not
   to block the rest of the program. This means that you can leave the
   music alone after calling ``play()``, it will manage itself very
   well.

   Here is a list of all the supported formats: ogg, wav, flac, aiff,
   au, raw, paf, svx, nist, voc, ircam, w64, mat4, mat5 pvf, htk, sds,
   avr, sd2, caf, wve, mpc2k, and rf64.

   Usage example::

      # Create a new music object
      music = sfml.Music.open_from_file('music.ogg')

      # Change some parameters
      music.position = (0, 1, 10) # change its 3D position
      music.pitch = 2             # increase the pitch
      music.volume = 50           # reduce the volume
      music.loop = true           # make it loop

      # Play it
      music.play()


   .. attribute:: duration

      Read-only. The total duration of the music, as a :class:`Time`
      object.

   .. classmethod:: open_from_file(filename)

      Open a music from an audio file. This function doesn't start
      playing the music (call ``play()`` to do
      so). :exc:`PySFMLException` is raised if opening the file fails.

   .. classmethod:: open_from_memory(str data)

      Open a music from an audio file in memory. This function doesn't
      start playing the music (call ``play()`` to do so).
      :exc:`PySFMLException` is raised if opening the file fails.


.. class:: Sound([SoundBuffer buffer])

   Sound is the class to use to play sounds. It provides:

   - Control (play, pause, stop)
   - Ability to modify output parameters in real-time (pitch, volume, ...)
   - 3D spatial features (position, attenuation, ...).

   Sound is perfect for playing short sounds that can fit in memory
   and require no latency, like foot steps or gun shots. For longer
   sounds, like background musics or long speeches, see
   :class:`Music`, which is based on streaming.

   In order to work, a sound must be given a buffer of audio data to
   play. Audio data (samples) is stored in a :class:`SoundBuffer`, and
   attached to a sound with the :attr:`buffer` attribute, or as a
   constructor argument. Note that multiple sounds can use the same
   sound buffer at the same time.

   Usage example::

      buf = sfml.SoundBuffer.load_from_file('sound.wav')
      sound = sfml.Sound()
      sound.buffer = buf
      sound.play()

   .. attribute:: attenuation

      The attenuation factor of the sound.

   .. attribute:: buffer

      The audio buffer attached to the sound.

   .. attribute:: loop

      Whether or not the sound is in loop mode.

   .. attribute:: min_distance

      The minimum distance of the sound.

   .. attribute:: pitch

      The pitch of the sound.

   .. attribute::  playing_offset

      The current playing position of the sound, as a :class:`Time`
      object.

   .. attribute:: position

      The 3D position of the sound in the audio scene, as a three
      elements tuple.

   .. attribute:: relative_to_listener

      Whether the sound's position is relative to the listener or
      absolute.

   .. attribute:: status

      Read-only. Can be one of:

      * ``sfml.Sound.STOPPED``
      * ``sfml.Sound.PAUSED``
      * ``sfml.Sound.PLAYING``

   .. attribute:: volume

      A value between 0 (muted) and 100 (full volume and default value).

   .. method:: pause()

      Pause the sound. This method has no effect if the sound isn't
      playing.

   .. method:: play()

      Start or resume playing the sound. This method restarts the
      sound from its beginning if it's already playing. It uses its
      own thread so that it doesn't block the rest of the program
      while the sound is played.

   .. method:: stop()

      Stop playing the sound and reset the playing position. This
      method has no effect is the sound is already stopped.


.. class:: SoundBuffer

   The constructor will raise ``NotImplementedError``. Use one of the class
   methods instead.

   Storage for audio samples defining a sound.

   A sound buffer holds the data of a sound, which is an array of
   audio samples.

   A sample is a 16 bits signed integer that defines the amplitude of
   the sound at a given time. The sound is then restituted by playing
   these samples at a high rate (for example, 44100 samples per second
   is the standard rate used for playing CDs). In short, audio samples
   are like texture pixels, and a SoundBuffer is similar to a
   :class:`Texture`.

   A sound buffer can be loaded from a file (see
   :meth:`load_from_file` for the complete list of supported formats),
   from memory or directly from a list of samples. It can also be
   saved back to a file.

   Here is the list of all the supported formats: ogg, wav, flac,
   aiff, au, raw, paf, svx, nist, voc, ircam, w64, mat4, mat5 pvf,
   htk, sds, avr, sd2, caf, wve, mpc2k, and rf64. (Note that mp3 isn't
   supported.)

   Sound buffers alone are not very useful: they hold the audio data
   but cannot be played. To do so, you need to use the :class:`Sound`
   class, which provides functions to play/pause/stop the sound as
   well as changing the way it is outputted (volume, pitch, 3D
   position, ...). This separation allows more flexibility and better
   performances: a SoundBuffer is a heavy resource, and any operation
   on it is slow (often too slow for real-time applications). On the
   other hand, a :class:`Sound` is a lightweight object, which can use
   the audio data of a sound buffer and change the way it is played
   without actually modifying that data. Note that it is also possible
   to bind several :class:`Sound` instances to the same SoundBuffer.

   Usage example::

      # Create a new sound buffer
      buf = sfml.SoundBuffer.load_from_file('sound.wav')
 
      # Create a sound source and bind it to the buffer
      sound1 = sfml.Sound()
      sound1.buffer = buf
 
      # Play the sound
      sound1.play()
 
      # Create another sound source bound to the same buffer, this time
      # passing it to the constructor instead of using the buffer property
      sound2 = sfml.Sound(buf)

      # Play it with a higher pitch -- the first sound remains unchanged
      sound2.pitch = 2
      sound2.play()

   .. attribute:: channel_count

      Read-only. The number of channels used by the sound (1 for mono, 2 for
      stereo, etc.).

   .. attribute:: duration

      The total duration of the sound, as a :class:`Time` object.

   .. attribute:: sample_rate

      The sample rate of the sound. This is the number of samples
      played per second. The higher, the better the quality (for
      example, 44100 samples/s is CD quality).

   .. attribute:: samples

      The samples stored in the buffer, as a byte string (``str`` in
      Python 2, ``bytes`` in Python 3). Use ``len()`` to get the
      number of samples.

   .. classmethod:: load_from_file(filename)

      Load the sound buffer from a file. :exc:`PySFMLException` is
      raised if loading fails.

   .. classmethod:: load_from_memory(bytes data)

      Load the sound buffer from a file in
      memory. :exc:`PySFMLException` is raised if loading
      fails. *data* should be ``str`` object in Python 2, and a
      ``bytes`` object in Python 3.

   .. classmethod:: load_from_samples(list samples, int channel_count,\
                                      int sample_rate)

      Load the sound buffer from a list of audio samples. *samples*
      should be a ``bytes`` object in Python 3, and a string in
      Python 2. Each sample must be stored on two bytes (``Int16`` in
      C++ SFML). :exc:`PySFMLException` is raised if loading fails.

   .. method:: save_to_file(filename)

      Save the sound buffer to an audio file. :exc:`PySFMLException`
      is raised if saving fails.


.. class:: SoundStream

   Abstract class for streamed audio sources.

   Unlike audio buffers such as :class:`SoundBuffer`, audio streams
   are never completely loaded in memory. Instead, the audio data is
   acquired continuously while the stream is playing. This behaviour
   allows to play a sound with no loading delay, and keeps the memory
   consumption very low.

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

   .. attribute:: attenuation

      The attenuation factor of the sound.

   .. attribute:: channel_count

      Read-only. The number of channels used by the sound (1 for mono, 2 for
      stereo, etc.).

   .. attribute:: loop

      Whether or not the stream is in loop mode.

   .. attribute:: min_distance

      The minimum distance of the sound.

   .. attribute:: pitch

      The pitch of the sound.

   .. attribute:: playing_offset

      The current position of the stream, as a :class:`Time` object.

   .. attribute:: position

      The 3D position of the sound the audio scene, as a three
      elements tuple.

   .. attribute:: relative_to_listener

      Whether the sound's position is relative to the listener or
      absolute.

   .. attribute:: sample_rate

      Read-only. The sample rate of the stream. This is the number of
      audio samples played per second. The higher, the better the
      quality.

   .. attribute:: status

      Read-only. Can be one of:

      * ``sfml.SoundStream.STOPPED``
      * ``sfml.SoundStream.PAUSED``
      * ``sfml.SoundStream.PLAYING``

   .. attribute:: volume

      A value between 0 (muted) and 100 (full volume and default value).

   .. method:: initialize(int channel_count, int sample_rate)

      This method must be called by user-defined streams. It's not
      available from built-in sound streams such as :class:`Music`.

   .. method:: pause()

      Pause the stream. This method has no effect if the stream isn't
      playing.

   .. method:: play()

      Start or resume playing the stream. This method restarts the
      stream from its beginning if it's already playing. It uses its
      own thread so that it doesn't block the rest of the program
      while the stream is played.

   .. method:: stop()

      Stop playing the stream and reset the playing position. This
      method has no effect is the stream is already stopped.
