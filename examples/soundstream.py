#! /usr/bin/env python2
# -*- coding: utf-8 -*-

import sys
import time

try:
    from cStringIO import StringIO
except ImportError:
    from StringIO import StringIO

import sfml as sf


class CustomStream(sf.SoundStream):
    def __init__(self, path):
        sf.SoundStream.__init__(self)
        sound_buffer = sf.SoundBuffer.load_from_file(path)
        self.string_buffer = StringIO(sound_buffer.samples)

        # The program crashes if this line is removed. Apparently,
        # cStringIO doesn't keep a Python reference to the string.
        self.s = sound_buffer.samples
        self.initialize(sound_buffer.channel_count,
                        sound_buffer.sample_rate)
        self.buffer_size = 2 ** 12
        self.next_data = self.string_buffer.read(self.buffer_size)

    def on_get_data(self, chunk):
        if not self.next_data:
            return False

        chunk.samples = self.next_data
        self.next_data = self.string_buffer.read(self.buffer_size)

        return True

    def on_seek(self, time_offset):
        print(time_offset)



def main(argv):
    window = sf.RenderWindow(sf.VideoMode(640, 480),
                             'SFML sound streaming example')
    window.framerate_limit = 60
    running = True

    stream = None
    error_message = None

    if len(argv) > 1:
        stream = CustomStream(argv[1])
        stream.play()
    else:
        error_message = sf.Text(
            "Error: please give an audio file as a command-line argument\n"
            "e.g. ./soundstream.py sound.wav")
        error_message.color = sf.Color.BLACK
        error_message.character_size = 17

    while running:
        for event in window.iter_events():
            if event.type == sf.Event.CLOSED:
                running = False

        window.clear(sf.Color.WHITE)

        if error_message is not None:
            window.draw(error_message)

        window.display()


if __name__ == '__main__':
    main(sys.argv)
