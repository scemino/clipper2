import std/strutils

proc currentSourceDir(): string {.compileTime.} =
  result = currentSourcePath().replace("\\", "/")
  result = result[0 ..< result.rfind("/")]

{.passc: "-I" & currentSourceDir() & "/private/Clipper2Lib".}
{.compile: "private/Clipper2Lib/clipper.engine.cpp",
  compile: "private/Clipper2Lib/clipper.offset.cpp"
.}

{.push header: "<clipper.h>".}

type
  Point*[T] {.importcpp: "Clipper2Lib::Point".} = object
    x*: T
    y*: T
  Point64* {.importcpp: "Clipper2Lib::Point64".} = object
    ## The Point64 structure is used to represent a single vertex (or coordinate) in a series that together make a path or contour (see Path64). Closed paths are usually referred to as polygons, and open paths are referred to as lines or polylines.
    ## 
    ## All coordinates are represented internally using integers as this is the only way to ensure numerical robustness. While the library also accepts floating point coordinates (see PointD), these will be converted into integers internally (using user specified scaling).
    x*: int64
    y*: int64
  PointD* {.importcpp: "Clipper2Lib::PointD".} = object
    ## The PointD structure is used to represent a single floating point coordinate. A series of these coordinates forms a PathD structure.
    x*: cdouble
    y*: cdouble
  Path*[T] {.importcpp: "Clipper2Lib::Path".} = object
  Paths*[T] {.importcpp: "Clipper2Lib::Paths".} = object
  Path64* {.importcpp: "Clipper2Lib::Path64".} = object
    ## This structure contains a sequence of Point64 vertices defining a single contour (see also terminology). Paths may be open and represent a series of line segments defined by 2 or more vertices, or they may be closed and represent polygons. Whether or not a path is open depends on its context. Closed paths may be 'outer' contours, or they may be 'hole' contours, and this usually depends on their orientation (whether arranged roughly clockwise, or arranged counter-clockwise).
    ## Multiple Path64 structures can be grouped into a Paths64 structure.
  Paths64* {.importcpp: "Clipper2Lib::Paths64".} = object
    ## Paths64 represent one or more Path64 structures. While a single path can represent a simple polygon, multiple paths are usually required to define complex polygons that contain one or more holes. 
  PathD* {.importcpp: "Clipper2Lib::PathD".} = object
    ## This structure contains a sequence of PointD vertices defining a single contour (see also terminology). Paths may be open and represent a series of line segments defined by 2 or more vertices, or they may be closed and represent polygons. Whether or not a path is open depends on its context. Closed paths may be 'outer' contours, or they may be 'hole' contours, and this usually depends on their orientation (whether arranged roughly clockwise, or arranged counter-clockwise).
    ## 
    ## Multiple PathD structures can be grouped into a PathsD structure.
  PathsD* {.importcpp: "Clipper2Lib::PathsD".} = object
    ## PathsD represent one or more PathD structures. While a single path can represent a simple polygon, multiple paths are usually required to define complex polygons that contain one or more holes. 
  FillRule* {.importcpp: "Clipper2Lib::FillRule".} = enum
    ## Filling indicates those regions that are inside a closed path (ie 'filled' with a brush color or pattern in a graphical display) and those regions that are outside. The Clipper Library supports 4 filling rules: Even-Odd, Non-Zero, Positive and Negative.
    ## 
    ## The simplest filling rule is Even-Odd filling (sometimes called alternate filling). Given a group of closed paths start from a point outside the paths and progress along an imaginary line through the paths. When the first path is crossed the encountered region is filled. When the next path is crossed the encountered region is not filled. Likewise, each time a path is crossed, filling starts if it had stopped and stops if it had started.
    ## 
    ## With the exception of Even-Odd filling, all other filling rules rely on edge direction and winding numbers to determine filling. Edge direction is determined by the order in which vertices are declared when constructing a path. Edge direction is used to determine the winding number of each polygon subregion.
    frEvenOdd,  ## Odd numbered sub-regions are filled, while even numbered sub-regions are not.
    frNonZero,  ## All non-zero sub-regions are filled.
    frPositive, ## All sub-regions with winding counts > 0 are filled.
    frNegative  ## All sub-regions with winding counts < 0 are filled.
  ClipType* {.importcpp: "Clipper2Lib::ClipType".} = enum
    ##  There are four boolean operations - AND, OR, NOT & XOR.
    ##
    ## Given that subject and clip polygon brush 'filling' is defined both by their vertices and their respective filling rules, the four boolean operations can be applied to polygons to define new filling regions:
    ##
    ##    AND (intersection) - create regions where both subject and clip polygons are filled
    ##    OR (union) - create regions where either subject or clip polygons (or both) are filled
    ##    NOT (difference) - create regions where subject polygons are filled except where clip polygons are filled
    ##    XOR (exclusive or) - create regions where either subject or clip polygons are filled but not where both are filled
    ctNone,
    ctIntersection,
    ctUnion,
    ctDifference,
    ctXor
  PointInPolygonResult* {.importcpp: "Clipper2Lib::PointInPolygonResult".} = enum 
    ptIsOn,
    ptIsInside,
    ptIsOutside
  JoinType {.importcpp: "Clipper2Lib::JoinType".} = enum 
    ## The JoinType enumerator is only needed when offsetting (inflating/shrinking). It isn't needed for polygon clipping.
    ##
    ## When adding paths to a ClipperOffset object via the AddPaths method, the joinType parameter may be one of three types - Miter, Square or Round.
    jtSquare,
    jtRound,
    jtMiter
  EndType {.importcpp: "Clipper2Lib::EndType".} = enum
    ## The EndType enumerator is only needed when offsetting (inflating/shrinking). It isn't needed for polygon clipping.
    ## 
    ## EndType has 5 values:
    ## 
    ##     Polygon: the path is treated as a polygon
    ##     Join: ends are joined and the path treated as a polyline
    ##     Square: ends extend the offset amount while being squared off
    ##     Round: ends extend the offset amount while being rounded off
    ##     Butt: ends are squared off without any extension
    ## 
    ## Note: With EndType.Polygon and EndType.Join, path closure will occur regardless of whether or not the first and last vertices in the path match.
    etPolygon,
    etJoined,
    etButt,
    etSquare,
    etRound

proc IsPositive*(path: PathD): bool {.importcpp: "Clipper2Lib::IsPositive(@)".}
  ## This function assesses the winding orientation of closed paths.
  ##
  ## Positive winding paths will be oriented in an anti-clockwise direction in Cartesian coordinates (where coordinate values increase when heading rightward and upward). Nevertheless it's common for graphics libraries to use inverted Y-axes (where Y values decrease heading upward). In these libraries, paths with Positive winding will be oriented clockwise.
  ##
  ## Note: Self-intersecting polygons have indeterminate orientation since some path segments will commonly wind in opposite directions to other segments. 
proc IsPositive*(path: Path64): bool {.importcpp: "Clipper2Lib::IsPositive(@)".}
  ## This function assesses the winding orientation of closed paths.
  ##
  ## Positive winding paths will be oriented in an anti-clockwise direction in Cartesian coordinates (where coordinate values increase when heading rightward and upward). Nevertheless it's common for graphics libraries to use inverted Y-axes (where Y values decrease heading upward). In these libraries, paths with Positive winding will be oriented clockwise.
  ##
  ## Note: Self-intersecting polygons have indeterminate orientation since some path segments will commonly wind in opposite directions to other segments. 
proc PointInPolygon*(pt: Point[int64], polygon: Path64): PointInPolygonResult {.importcpp: "Clipper2Lib::PointInPolygon(@)".}
  ## The function result indicates whether the point is inside, or outside, or on one of the specified polygon's edges.
proc PointInPolygon*(pt: Point[cdouble], polygon: PathD): PointInPolygonResult {.importcpp: "Clipper2Lib::PointInPolygon(@)".}
  ## The function result indicates whether the point is inside, or outside, or on one of the specified polygon's edges.
proc Area*(paths: Paths): cdouble {.importcpp: "Clipper2Lib::Area(@)".}
  ## This function returns the area of the supplied polygon. It's assumed that the path is closed and does not self-intersect. Depending on the path's winding orientation, this value may be positive or negative. If the winding is clockwise, then the area will be positive and conversely, if winding is counter-clockwise, then the area will be negative.

proc MakePath*(s: cstring, skip_chars: cstring = ""): Path64 {.importcpp: "Clipper2Lib::MakePath(@)".}
proc MakePathD*(s: cstring): PathD {.importcpp: "Clipper2Lib::MakePathD(@)".}

proc BooleanOp*(cliptype: ClipType, fillrule: FillRule, subjects, clips: Paths64): PathsD {.importcpp: "Clipper2Lib::BooleanOp(@)".}
  ## This function is a generic alternative to the Intersect, Difference, Union and XOR functions. 
proc BooleanOp*(cliptype: ClipType, fillrule: FillRule, subjects, clips: PathsD, decimal_prec: cint = 2): PathsD {.importcpp: "Clipper2Lib::BooleanOp(@)".}
  ## This function is a generic alternative to the Intersect, Difference, Union and XOR functions. 
proc Intersect*(subjects, clips: Paths64, fillrule: FillRule): Paths64 {.importcpp: "Clipper2Lib::Intersect(@)".}
  ## This function intersects subject paths with clip paths. For more complex clipping operations, you'll likely need to use Clipper64 (or ClipperD) directly.
proc Intersect*(subjects, clips: PathsD, fillrule: FillRule, decimal_prec: cint = 2): PathsD {.importcpp: "Clipper2Lib::Intersect(@)".}
  ## This function intersects subject paths with clip paths. For more complex clipping operations, you'll likely need to use Clipper64 (or ClipperD) directly.
proc Union*(subjects, clips: Paths64, fillrule: FillRule): Paths64 {.importcpp: "Clipper2Lib::Union(@)".}
  ## This function 'unions' together subject paths, with or without clip paths. For more complex clipping operations, you'll likely need to use Clipper64 (or ClipperD) directly.
proc Union*(subjects, clips: PathsD, fillrule: FillRule, decimal_prec: cint = 2): PathsD {.importcpp: "Clipper2Lib::Union(@)".}
  ## This function 'unions' together subject paths, with or without clip paths. For more complex clipping operations, you'll likely need to use Clipper64 (or ClipperD) directly.
proc Difference*(subjects, clips: Paths64, fillrule: FillRule): Paths64 {.importcpp: "Clipper2Lib::Difference(@)".}
  ## This function 'differences' subject paths from clip paths. For more complex clipping operations, you'll likely need to use Clipper64 (or ClipperD) directly.
proc Difference*(subjects, clips: PathsD, fillrule: FillRule, decimal_prec: cint = 2): PathsD {.importcpp: "Clipper2Lib::Difference(@)".}
  ## This function 'differences' subject paths from clip paths. For more complex clipping operations, you'll likely need to use Clipper64 (or ClipperD) directly.
proc Xor*(subjects, clips: Paths64, fillrule: FillRule): Paths64 {.importcpp: "Clipper2Lib::Xor(@)".}
  ## This function 'XORs' subject paths and clip paths. For more complex clipping operations, you'll likely need to use Clipper64 (or ClipperD) directly.
proc Xor*(subjects, clips: PathsD, fillrule: FillRule, decimal_prec: cint = 2): PathsD {.importcpp: "Clipper2Lib::Xor(@)".}
  ## This function 'XORs' subject paths and clip paths. For more complex clipping operations, you'll likely need to use Clipper64 (or ClipperD) directly.

proc InflatePaths*(paths: PathsD, delta: cdouble, jt: JoinType, et: EndType, miter_limit: cdouble = 2.0, precision: cdouble = 2.0): PathsD {.importcpp: "Clipper2Lib::InflatePaths(@)".}
  ## These functions encapsulate ClipperOffset, the class that performs both polygon and open path offsetting.
  ## 
  ## Note: When using this function to inflate polygons (as opposed to open paths), it's important that you select EndType.Polygon. If you select one of the open path end types (including EndType.Join), you'll inflate the polygon's outline instead. (Example here.)
  ## 
  ## Caution: Offsetting self-intersecting polygons may produce unexpected results.
proc InflatePaths*(paths: Paths64, delta: cdouble, jt: JoinType, et: EndType, miter_limit: cdouble = 2.0): Paths64 {.importcpp: "Clipper2Lib::InflatePaths(@)".}
  ## These functions encapsulate ClipperOffset, the class that performs both polygon and open path offsetting.
  ## 
  ## Note: When using this function to inflate polygons (as opposed to open paths), it's important that you select EndType.Polygon. If you select one of the open path end types (including EndType.Join), you'll inflate the polygon's outline instead. (Example here.)
  ## 
  ## Caution: Offsetting self-intersecting polygons may produce unexpected results.

proc len*(v: Path64): csize_t {.importcpp: "size".}
proc len*(v: Paths64): csize_t {.importcpp: "size".}
proc len*(v: PathD): csize_t {.importcpp: "size".}
proc len*(v: PathsD): csize_t {.importcpp: "size".}
proc unsafeIndex(self: var Paths64, i: csize_t): var Path64 {.importcpp: "#[#]".}
proc unsafeIndex(self: Paths64, i: csize_t): lent Path64 {.importcpp: "#[#]".}
proc unsafeIndex(self: var Path64, i: csize_t): var Point[int64] {.importcpp: "#[#]".}
proc unsafeIndex(self: Path64, i: csize_t): lent Point[int64] {.importcpp: "#[#]".}
proc unsafeIndex(self: var PathsD, i: csize_t): var PathD {.importcpp: "#[#]".}
proc unsafeIndex(self: PathsD, i: csize_t): lent PathD {.importcpp: "#[#]".}
proc unsafeIndex(self: var PathD, i: csize_t): var Point[cdouble] {.importcpp: "#[#]".}
proc unsafeIndex(self: PathD, i: csize_t): lent Point[cdouble] {.importcpp: "#[#]".}
proc add*(pathes: var Paths64, path: Path64) {.importcpp: "push_back".}
proc add*(path: var Path64, point: Point64) {.importcpp: "push_back".}
proc add*(pathes: var PathsD, path: PathD) {.importcpp: "push_back".}
proc add*(path: var PathD, point: PointD) {.importcpp: "push_back".}
{.pop.} # {.push header: "<clipper.h>".}

# Element access
proc `[]`*(self: Paths64, idx: Natural): lent Path64 {.inline.} =
  let i = csize_t(idx)
  self.unsafeIndex(i)

proc `[]`*(self: var Paths64, idx: Natural): var Path64 {.inline.} =
  let i = csize_t(idx)
  (addr self.unsafeIndex(i))[]

proc `[]=`*[T](self: var Paths64, idx: Natural, val: Path64) {.inline.} =
  let i = csize_t(idx)
  self.unsafeIndex(i) = val

proc `[]`*(self: Path64, idx: Natural): lent Point[int64] {.inline.} =
  let i = csize_t(idx)
  self.unsafeIndex(i)

proc `[]`*(self: var Path64, idx: Natural): var Point[int64] {.inline.} =
  let i = csize_t(idx)
  (addr self.unsafeIndex(i))[]

proc `[]=`*[T](self: var Path64, idx: Natural, val: Point[int64]) {.inline.} =
  let i = csize_t(idx)
  self.unsafeIndex(i) = val

proc `[]`*(self: PathsD, idx: Natural): lent PathD {.inline.} =
  let i = csize_t(idx)
  self.unsafeIndex(i)

proc `[]`*(self: var PathsD, idx: Natural): var PathD {.inline.} =
  let i = csize_t(idx)
  (addr self.unsafeIndex(i))[]

proc `[]=`*[T](self: var PathsD, idx: Natural, val: PathD) {.inline.} =
  let i = csize_t(idx)
  self.unsafeIndex(i) = val

proc `[]`*(self: PathD, idx: Natural): lent Point[cdouble] {.inline.} =
  let i = csize_t(idx)
  self.unsafeIndex(i)

proc `[]`*(self: var PathD, idx: Natural): var Point[cdouble] {.inline.} =
  let i = csize_t(idx)
  (addr self.unsafeIndex(i))[]

proc `[]=`*[T](self: var PathD, idx: Natural, val: Point[cdouble]) {.inline.} =
  let i = csize_t(idx)
  self.unsafeIndex(i) = val

iterator items*(v: Paths64): Path64 =
  for idx in 0.csize_t ..< v.len():
    yield v[idx]

iterator items*(v: Path64): Point[int64] =
  for idx in 0.csize_t ..< v.len():
    yield v[idx]

iterator items*(v: PathsD): PathD =
  for idx in 0.csize_t ..< v.len():
    yield v[idx]

iterator items*(v: PathD): Point[cdouble] =
  for idx in 0.csize_t ..< v.len():
    yield v[idx]

when isMainModule:
  var subject, clip: Paths64
  subject.add MakePath("100, 50, 10, 79, 65, 2, 65, 98, 10, 21")
  clip.add MakePath("98, 63, 4, 68, 77, 8, 52, 100, 19, 12")
  let solution = Intersect(subject, clip, frNonZero)

  for path in solution:
    for pt in path:
      echo pt
