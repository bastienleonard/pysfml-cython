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
        not_equal = [(sf.Color(0, 0, 0, 1), sf.Color(0, 1, 0, 0)),
                     (sf.Color(255, 255, 255, 255),
                      sf.Color(254, 255, 255, 255))]

        for c1, c2 in not_equal:
            self.assertNotEqual(c1, c2)

    def test_copy(self):
        c1 = self.random_color()
        c2 = c1.copy()
        self.assertEqual(c1, c2)


class TestIntRect(unittest.TestCase):
    def random_rect(self):
        return sf.IntRect(random.randint(0, 100),
                          random.randint(0, 100),
                          random.randint(0, 100),
                          random.randint(0, 100))

    def test_eq(self):
        def r():
            return random.randint(0, 100)

        equal = [(sf.IntRect(l, t, w, h), sf.IntRect(l, t, w, h))
                 for l, t, w, h in
                 [(r(), r(), r(), r()) for i in range(100)]]

        for r1, r2 in equal:
            self.assertEqual(r1, r2)

    def test_neq(self):
        not_equal = [(sf.IntRect(0, 0, 0, 0), sf.IntRect(0, 0, 0, 10)),
                     (sf.IntRect(0, 0, 0, 0), sf.IntRect(0, 0, 10, 0)),
                     (sf.IntRect(0, 0, 0, 0), sf.IntRect(0, 10, 0, 0)),
                     (sf.IntRect(0, 0, 0, 0), sf.IntRect(10, 0, 0, 0))]

        for r1, r2 in not_equal:
            self.assertNotEqual

    def test_copy(self):
        r1 = self.random_rect()
        r2 = r1.copy()
        self.assertEqual(r1, r2)


class TestFloatRect(unittest.TestCase):
    def random_rect(self):
        return sf.FloatRect(random.triangular(0.0, 100.0),
                            random.triangular(0.0, 100.0),
                            random.triangular(0.0, 100.0),
                            random.triangular(0.0, 100.0))

    def test_eq(self):
        def r():
            return random.triangular(0.0, 100.0)

        equal = [(sf.FloatRect(l, t, w, h), sf.FloatRect(l, t, w, h))
                 for l, t, w, h in
                 [(r(), r(), r(), r()) for i in range(100)]]

        for r1, r2 in equal:
            self.assertEqual(r1, r2)

    def test_neq(self):
        not_equal = [(sf.FloatRect(0, 0, 0, 0), sf.FloatRect(0, 0, 0, 10)),
                     (sf.FloatRect(0, 0, 0, 0), sf.FloatRect(0, 0, 10, 0)),
                     (sf.FloatRect(0, 0, 0, 0), sf.FloatRect(0, 10, 0, 0)),
                     (sf.FloatRect(0, 0, 0, 0), sf.FloatRect(10, 0, 0, 0))]

        for r1, r2 in not_equal:
            self.assertNotEqual

    def test_copy(self):
        r1 = self.random_rect()
        r2 = r1.copy()
        self.assertEqual(r1, r2)


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

    def test_copy(self):
        t1 = self.random_time()
        t2 = t1.copy()
        self.assertEqual(t1, t2)


class TestTransform(unittest.TestCase):
    def random_transform(self):
        return sf.Transform(*[random.triangular(0.0, 5.0) for i in range(9)])

    def test_init(self):
        self.assertEqual(sf.Transform().matrix, sf.Transform.IDENTITY.matrix)
        self.assertRaises(TypeError, sf.Transform, *range(10))

    def test_copy(self):
        for i in range(10):
            t1 = self.random_transform()
            t2 = t1.copy()
            self.assertEqual(t1.matrix, t2.matrix)

    def test_imul(self):
        t1 = self.random_transform()
        t2 = self.random_transform()
        t3 = t1.copy()
        t3 *= t2
        self.assertEqual((t1 * t2).matrix, t3.matrix)


if __name__ == '__main__':
    unittest.main()
