#! /usr/bin/env python2
# -*- coding: utf-8 -*-

from random import randint

import sfml as sf


def random_color():
    return sf.Color(randint(0, 255), randint(0, 255), randint(0, 255))

def random_position(window):
    return (randint(0, window.view.width), randint(0, window.view.height))


class CustomShape(sf.Shape):
    def __init__(self):
        sf.Shape.__init__(self)
        self.fill_color = sf.Color.RED
        self.points = [(400, 200), (450, 150), (500, 200), (550, 200),
                       (500, 250), (420, 300)]
        self.update()

    def get_point_count(self):
        return len(self.points)

    def get_point(self, index):
        return self.points[index]


def main():
    window = sf.RenderWindow(sf.VideoMode(800, 600), 'Shape example')
    window.framerate_limit = 60
    running = True
    clock = sf.Clock()

    custom_shapes = [CustomShape()]
    rectangles = []
    circles = []

    for i in range(30):
        circle = sf.CircleShape(randint(5, 20))
        circle.fill_color = random_color()
        circle.position = random_position(window)
        circles.append(circle)

    for i in range(100):
        rectangle = sf.RectangleShape((randint(10, 30), randint(10, 30)))
        rectangle.position = random_position(window)
        rectangle.fill_color = random_color()
        rectangle.outline_color = random_color()
        rectangle.outline_thickness = randint(1, 2)
        rectangles.append(rectangle)

    while running:
        for event in window.iter_events():
            if event.type == sf.Event.CLOSED:
                running = False

        frame_time = clock.restart().as_milliseconds()

        for r in rectangles:
            r.rotate(frame_time * 0.3)

        window.clear(sf.Color.WHITE)

        for shape in custom_shapes + rectangles + circles:
            window.draw(shape)

        window.display()

    window.close()


if __name__ == '__main__':
    main()
