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


cimport decl


cdef extern from "SFML/Audio.hpp" namespace "sf::SoundSource":
    cdef cppclass Status

    int Stopped
    int Paused
    int Playing


cdef extern from "SFML/Audio.hpp" namespace "sf":
    cdef cppclass SoundBuffer:
        SoundBuffer()
        unsigned int getChannelCount()
        decl.Time getDuration()
        decl.Int16* getSamples()
        unsigned int getSampleRate()
        size_t getSampleCount()
        bint loadFromFile(char*)
        bint loadFromMemory(void*, size_t)
        bint loadFromSamples(decl.Int16*, size_t, unsigned int, unsigned int)
        bint saveToFile(char*)

    cdef cppclass Sound:
        Sound()
        Sound(SoundBuffer&)
        float getAttenuation()
        SoundBuffer* getBuffer()
        bint getLoop()
        float getMinDistance()
        float getPitch()
        decl.Time getPlayingOffset()
        decl.Vector3f getPosition()
        float getVolume()
        Status getStatus()
        bint isRelativeToListener()
        void pause()
        void play()
        void setAttenuation(float)
        void setBuffer(SoundBuffer&)
        void setLoop(bint)
        void setMinDistance(float)
        void setPitch(float)
        void setPlayingOffset(decl.Time)
        void setPosition(float, float, float)
        void setPosition(decl.Vector3f&)
        void setRelativeToListener(bint)
        void setVolume(float)
        void stop()

    cdef cppclass Music:
        Music()
        float getAttenuation()
        unsigned int getChannelCount()
        unsigned int getSampleRate()
        decl.Time getDuration()
        bint getLoop()
        float getMinDistance()
        float getPitch()
        decl.Time getPlayingOffset()
        decl.Vector3f getPosition()
        Status getStatus()
        float getVolume()
        bint isRelativeToListener()
        bint openFromFile(char*)
        bint openFromMemory(void*, size_t)
        void pause()
        void play()
        void setAttenuation(float)
        void setLoop(bint)
        void setMinDistance(float)
        void setPitch(float)
        void setPlayingOffset(decl.Time)
        void setPosition(float, float, float)
        void setPosition(decl.Vector3f&)
        void setRelativeToListener(bint)
        void setVolume(float)
        void stop()

    cdef cppclass Chunk "sf::SoundStream::Chunk":
        decl.Int16* samples
        size_t sampleCount

    cdef cppclass SoundStream:
        float getAttenuation()
        unsigned int getChannelCount()
        bint getLoop()
        float getMinDistance()
        float getPitch()
        decl.Time getPlayingOffset()
        decl.Vector3f getPosition()
        unsigned int getSampleRate()
        Status getStatus()
        float getVolume()
        bint isRelativeToListener()
        void pause()
        void play()
        void setAttenuation(float)
        void setLoop(bint)
        void setMinDistance(float)
        void setPitch(float)
        void setPlayingOffset(decl.Time)
        void setPosition(float, float, float)
        void setRelativeToListener(bint)
        void setVolume(float)
        void stop()


cdef extern from "SFML/Audio.hpp":
    cdef decl.Vector3f Listener_getDirection "sf::Listener::getDirection" ()
    cdef float Listener_getGlobalVolume "sf::Listener::getGlobalVolume" ()
    cdef decl.Vector3f Listener_getPosition "sf::Listener::getPosition" ()
    cdef void Listener_setGlobalVolume "sf::Listener::setGlobalVolume" (float)
    cdef void Listener_setDirection "sf::Listener::setDirection" (float, float, float)
    cdef void Listener_setDirection "sf::Listener::setDirection" (decl.Vector3f&)
    cdef void Listener_setPosition "sf::Listener::setPosition" (float, float, float)
    cdef void Listener_setPosition "sf::Listener::setPosition" (decl.Vector3f&)
