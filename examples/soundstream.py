#! /usr/bin/env python2
# -*- coding: utf-8 -*-

import sys

import sf


class CustomStream(sf.SoundStream):
    def __init__(self, path):
        sf.SoundStream.__init__(self)
        self.sound_buffer = sf.SoundBuffer.load_from_file(path)
        self._samples = self.sound_buffer.samples
        self.i = 0
        self.buffer_size = 2 ** 15
        self.initialize(self.sound_buffer.channel_count,
                        self.sound_buffer.sample_rate)

    def on_get_data(self, chunk):
        ret = True

        a = self.i
        b = self.i + self.buffer_size

        if b > self.sound_buffer.sample_count:
            b = self.sound_buffer.sample_count % self.buffer_size
            ret = False

        chunk.samples = self._samples[self.i:self.i+self.buffer_size]
        self.i += self.buffer_size

        return ret

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

    
