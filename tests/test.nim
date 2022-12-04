import unittest
import clipper2

test "intersect":
  var subject, clip: Paths64
  subject.add(MakePath("100, 50, 10, 79, 65, 2, 65, 98, 10, 21"))
  clip.add(MakePath("98, 63, 4, 68, 77, 8, 52, 100, 19, 12"))
  let solution = Intersect(subject, clip, frNonZero)

  let expected = MakePath("65, 39, 68, 40, 67, 43, 85, 55, 65, 61, 65, 65, 62, 65, 56, 85, 44, 68, 40, 69, 39, 66, 18, 67, 31, 50, 29, 48, 32, 45, 24, 26, 44, 32, 46, 29, 49, 31, 65, 18")
  check solution.len == 1
  check solution[0] == expected
