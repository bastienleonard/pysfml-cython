#! /usr/bin/env python2
# -*- coding: utf-8 -*-

import sfml as sf


def main():
    window = sf.RenderWindow(sf.VideoMode(640, 480), 'SFML vertices example')
    window.framerate_limit = 60
    running = True
    vertices = [sf.Vertex((200, 150), sf.Color.RED),
                sf.Vertex((200, 350), sf.Color.BLUE),
                sf.Vertex((400, 350), sf.Color.GREEN),
                sf.Vertex((400, 150), sf.Color.YELLOW)]


    while running:
        for event in window.iter_events():
            if event.type == sf.Event.CLOSED:
                running = False

        window.clear(sf.Color.WHITE)
        window.draw(vertices, sf.TRIANGLES)
        window.display()

    window.close()


if __name__ == '__main__':
    main()
