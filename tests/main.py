#! /usr/bin/env python2
# -*- coding: utf-8 -*-

import random
import unittest

import sfml as sf


class TestColor(unittest.TestCase):
    def random_color(self):
        return sf.Color(random.randint(0, 255),
                        random.randint(0, 255),
                        random.randint(0, 255),
                        random.randint(0, 255))

    def test_eq(self):
        equal = [(sf.Color(i, i, i, i), sf.Color(i, i, i, i))
                 for i in range(256)]

        for c1, c2 in equal:
            self.assertEqual(c1, c2)

    def test_neq(self):
        non_equal = [(sf.Color(0, 0, 0, 1), sf.Color(0, 1, 0, 0)),
                     (sf.Color(255, 255, 255, 255),
                      sf.Color(254, 255, 255, 255))]

        for c1, c2 in non_equal:
            self.assertNotEqual(c1, c2)


class TestTime(unittest.TestCase):
    def random_time(self):
        return sf.Time(microseconds=random.randint(0, 1000000))

    def test_eq(self):
        equal = [(sf.Time(microseconds=x), sf.Time(microseconds=x))
                  for x in
                  [random.randint(0, 1000000) for n in range(10)]]

        for t1, t2 in equal:
            self.assertEqual(t1, t2)

    def test_add(self):
        t1 = self.random_time()
        t2 = self.random_time()
        self.assertEqual(
            t1 + t2,
            sf.Time(microseconds=t1.as_microseconds() + t2.as_microseconds()))

    def test_sub(self):
        t1 = self.random_time()
        t2 = self.random_time()
        self.assertEqual(
            t1 - t2,
            sf.Time(microseconds=t1.as_microseconds() - t2.as_microseconds()))

    def test_mul(self):
        t = self.random_time()
        i = random.randint(1, 1000)
        self.assertEqual(t * i,
                         sf.Time(microseconds=t.as_microseconds() * i))
        f = random.triangular(0.0, 100.0)
        self.assertEqual(t * f,
                         sf.Time(seconds=t.as_seconds() * f))

    def test_div(self):
        t = self.random_time()
        i = random.randint(1,  1000)
        self.assertEqual(t / i,
                         sf.Time(microseconds=t.as_microseconds() / i))
        f = random.triangular(0.0, 100.0)
        self.assertEqual(t / f,
                         sf.Time(seconds=t.as_seconds() / f))



if __name__ == '__main__':
    unittest.main()
