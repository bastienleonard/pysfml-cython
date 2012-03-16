#! /usr/bin/env python2
# -*- coding: utf-8 -*-

# Please note that this example may not work on all GPUs (eg. intel chipsets)
# because of a bug in the drivers. See the corresponding SFML issue:
# https://github.com/LaurentGomila/SFML/issues/101

import sfml as sf


def main():
    window = sf.RenderWindow(sf.VideoMode(640, 480),
                             'SFML RenderTexture example')
    window.framerate_limit = 60
    running = True
    
    rect0 = sf.RectangleShape((5, 5))
    rect0.position = (90, 50)
    rect0.fill_color = sf.Color.GREEN
    rect0.outline_color = sf.Color.BLUE
    rect0.outline_thickness = 2.0

    rect1 = sf.RectangleShape((20, 30))
    rect1.position = (50, 50)
    rect1.fill_color = sf.Color.CYAN

    rt = sf.RenderTexture(110, 110)
    rt.clear(sf.Color(0, 0, 0, 0))
    rt.draw(rect0)
    rt.draw(rect1)
    rt.display()
    s = sf.Sprite(rt.texture)
    s.origin = (55, 55)
    s.position = (320, 240)

    while running:
        for event in window.iter_events():
            if event.type == sf.Event.CLOSED:
                running = False

        window.clear(sf.Color.WHITE)
        s.rotate(5)
        window.draw(s)
        window.display()
    window.close()


if __name__ == '__main__':
    main()
