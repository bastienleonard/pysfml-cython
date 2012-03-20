#! /usr/bin/env python2
# -*- coding: utf-8 -*-

import sfml as sf


class Drawable(object):
    def __init__(self):
        self.princess = sf.Sprite(sf.Texture.load_from_file('princess.png'))
        self.logo = sf.Sprite(sf.Texture.load_from_file('python-logo.png'))

    def draw(self, target, states):
        target.draw(self.logo)
        target.draw(self.princess)


class LowLevelDrawable(object):
    def draw(self, target, states):
        vertices = [sf.Vertex((200, 150), sf.Color.BLACK),
                    sf.Vertex((400, 150), sf.Color.RED),
                    sf.Vertex((400, 350), sf.Color.BLUE),
                    sf.Vertex((200, 350), sf.Color.MAGENTA)]
        target.draw(vertices, sf.TRIANGLES_FAN)


window = sf.RenderWindow(sf.VideoMode(640, 480), 'User defined drawable')
window.framerate_limit = 60
running = True
drawable = Drawable()
low_level_drawable = LowLevelDrawable()

while running:
    for event in window.iter_events():
        if event.type == sf.Event.CLOSED:
            running = False

    window.clear(sf.Color.WHITE)
    window.draw(drawable)
    window.draw(low_level_drawable)
    window.display()
