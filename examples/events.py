#! /usr/bin/env python2
# -*- coding: utf-8 -*-

import sfml as sf


class EventQueue(object):
    def __init__(self, max_events, font):
        self.max_events = max_events
        self.font = font
        self.events = []

    def add(self, event):
        self.events.append(event)

        if len(self.events) > self.max_events:
            self.events.pop(0)

    # We could make it a custom drawable, but I personally don't like it
    def draw(self, window):
        y = 0
        text = sf.Text('Last events, with event attributes:', self.font, 14)
        text.color = sf.Color.BLACK
        window.draw(text)

        for event in reversed(self.events):
            y += text.global_bounds.height
            text.string = str(event)
            text.color = sf.Color.BLACK
            text.y = y
            window.draw(text)


def main():
    window = sf.RenderWindow(sf.VideoMode(800, 600), 'SFML Events example')
    window.framerate_limit = 60
    running = True
    font = sf.Font.load_from_file('LinBiolinum_Re.ttf')
    events = EventQueue(50, font)

    while running:
        for event in window.iter_events():
            # Stop running if the application is closed
            # or if the user presses Escape
            if (event.type == sf.Event.CLOSED or
               (event.type == sf.Event.KEY_PRESSED and
                event.code == sf.Keyboard.ESCAPE)):
                running = False

            events.add(event)

        window.clear(sf.Color.WHITE)
        events.draw(window)
        window.display()

    window.close()


if __name__ == '__main__':
    main()
