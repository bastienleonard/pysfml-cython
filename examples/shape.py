#! /usr/bin/env python2
# -*- coding: utf-8 -*-

import sf


class CustomShape(sf.Shape):
    def __init__(self):
        sf.Shape.__init__(self)
        self.fill_color = sf.Color.RED
        self.update()

    def get_point_count(self):
        return 3

    def get_point(self, index):
        if index == 0:
            return (500, 50)
        elif index == 1:
            return (600, 100)
        elif index == 2:
            return (450, 300)

        assert False, "Code should never reach this"


def main():
    window = sf.RenderWindow(sf.VideoMode(640, 480), 'Shape example')
    window.framerate_limit = 60
    running = True
    circle = sf.CircleShape(100.0)
    circle.fill_color = sf.Color.YELLOW
    circle.position = (100, 50)
    
    rectangle = sf.RectangleShape((100, 50))
    rectangle.position = (200, 350)
    rectangle.fill_color = sf.Color.GREEN
    rectangle.outline_color = sf.Color.BLUE
    rectangle.outline_thickness = 2.0

    shapes = [circle, rectangle, CustomShape()]

    while running:
        for event in window.iter_events():
            if event.type == sf.Event.CLOSED:
                running = False

        rectangle.rotate(2)

        window.clear(sf.Color.WHITE)

        for s in shapes:
            window.draw(s)

        window.display()

    window.close()


if __name__ == '__main__':
    main()
