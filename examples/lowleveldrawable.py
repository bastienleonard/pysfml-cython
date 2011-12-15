#! /usr/bin/env python2
# -*- coding: utf-8 -*-

import sf


class LowLevelDrawable(sf.Drawable):
    def render(self, target, renderer):
        renderer.begin(sf.Renderer.TRIANGLE_STRIP)
        renderer.add_vertex(200, 100, sf.Color.BLACK)
        renderer.add_vertex(200, 300, sf.Color.RED)
        renderer.add_vertex(500, 250, sf.Color.BLUE)
        renderer.add_vertex(200, 400, sf.Color.MAGENTA)
        renderer.end()


window = sf.RenderWindow(sf.VideoMode(640, 480), 'Low level rendering')
window.framerate_limit = 60
running = True
low_level_drawable = LowLevelDrawable()

while running:
    for event in window.iter_events():
        if event.type == sf.Event.CLOSED:
            running = False

    window.clear(sf.Color.WHITE)
    window.draw(low_level_drawable)
    window.display()
