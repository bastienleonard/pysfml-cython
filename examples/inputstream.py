#! /usr/bin/env python2
# -*- coding: utf-8 -*-

import sys

import sfml as sf


class Stream(sf.InputStream):
    def __init__(self, filename):
        sf.InputStream.__init__(self)
        self.filename = filename
        self.file = open(filename, 'rb')
        self.file.seek(0, 2)
        self.size = self.file.tell()
        self.file.seek(0)

    def get_size(self):
        print('{0}: get_size()'.format(self.filename))
        return self.size

    def read(self, size):
        print('{0}: read({1})'.format(self.filename, size))

        return self.file.read(size)

    def seek(self, position):
        print('{0}: seek({1})'.format(self.filename, position))
        self.file.seek(position)

        return self.tell()

    def tell(self):
        print('{0}: tell()'.format(self.filename))

        return self.file.tell()

    def close(self):
        self.file.close()



def main(args):
    window = sf.RenderWindow(sf.VideoMode(640, 480), 'InputStream example')
    window.framerate_limit = 60
    running = True
    error_message = None
    texture_stream = Stream('python-logo.png')
    texture = sf.Texture.load_from_stream(texture_stream)
    sprite = sf.Sprite(texture)
    music = None
    music_stream = None

    if len(args) > 1:
        music_stream = Stream(args[1])
        music = sf.Music.open_from_stream(music_stream)
        music.play()
    else:
        error_message = sf.Text(
            "Error: please provide an audio file as a command-line argument\n"
            "Example: ./soundstream.py music.ogg")
        error_message.color = sf.Color.BLACK
        error_message.character_size = 18


    while running:
        for event in window.iter_events():
            if event.type == sf.Event.CLOSED:
                running = False

        window.clear(sf.Color.WHITE)
        window.draw(sprite)

        if error_message is not None:
            window.draw(error_message)

        window.display()

    texture_stream.close()

    if music is not None:
        music.stop()

    if music_stream is not None:
        music_stream.close()

    window.close()


if __name__ == '__main__':
    main(sys.argv)
