# Clipper2

Nim bindings for [Clipper2](https://github.com/AngusJohnson/Clipper2): A Polygon [Clipping](https://en.wikipedia.org/wiki/Clipping_(computer_graphics)) and [Offsetting](https://en.wikipedia.org/wiki/Parallel_curve) library from **Angus Johnson**.

## Documentation

[Extensive HTML documentation](http://www.angusj.com/clipper2/Docs/Overview.htm)

## Examples
```nim
var subject, clip: Paths64
subject.add MakePath("100, 50, 10, 79, 65, 2, 65, 98, 10, 21")
clip.add MakePath("98, 63, 4, 68, 77, 8, 52, 100, 19, 12")
let solution = Intersect(subject, clip, frNonZero)
```

![clipperB](https://user-images.githubusercontent.com/5280692/178123810-1719a1f5-25c3-4a9e-b419-e575ff056272.svg)