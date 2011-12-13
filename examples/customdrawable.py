#! /usr/bin/env python2
# -*- coding: utf-8 -*-

import sf


class Drawable(sf.Drawable):
    def __init__(self):
        self.princess = sf.Sprite(sf.Texture.load_from_file(
            'examples/princess.png'))
        self.logo = sf.Sprite(sf.Texture.load_from_file(
            'examples/python-logo.png'))

    def render(self, target, renderer):
        target.draw(self.logo)
        target.draw(self.princess)


window = sf.RenderWindow(sf.VideoMode(640, 480), 'Test')
window.framerate_limit = 60
running = True
drawable = Drawable()

while running:
    for event in window.iter_events():
        if event.type == sf.Event.CLOSED:
            running = False

    window.clear(sf.Color.WHITE)
    window.draw(drawable)
    window.display()
