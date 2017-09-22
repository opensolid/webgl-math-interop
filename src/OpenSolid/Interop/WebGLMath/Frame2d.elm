module OpenSolid.Interop.WebGLMath.Frame2d exposing (toFloat3x3)

{-| Conversion functions for `Frame2d`.

@docs toFloat3x3

-}

import Matrix3 exposing (Float3x3)
import OpenSolid.Direction2d as Direction2d
import OpenSolid.Frame2d as Frame2d exposing (Frame2d)
import OpenSolid.Point2d as Point2d


{-| Convert a `Frame2d` to a `Float3x3`. The resulting matrix can be thought of
in a couple of ways:

  - It is the transformation matrix that takes the global XY frame and
    transforms it to the given frame
  - It is the transformation matrix from local coordinates in the given frame
    to global coordinates

The first bullet implies that something like

    Frame2d.xy
        |> Frame2d.translateBy displacement
        |> Frame2d.rotateAround point angle
        |> Frame2d.mirrorAcross axis
        |> Frame2d.toFloat3x3

gives you a transformation matrix that is equivalent to applying the given
displacement, then the given rotation, then the given mirror. The second bullet
means that, for example,

    Point2d.placeIn frame

is equivalent to

    Point2d.transformBy (Frame2d.toFloat3x3 frame)

-}
toFloat3x3 : Frame2d -> Float3x3
toFloat3x3 frame =
    let
        ( m11, m21 ) =
            Direction2d.components (Frame2d.xDirection frame)

        ( m12, m22 ) =
            Direction2d.components (Frame2d.yDirection frame)

        ( m13, m23 ) =
            Point2d.coordinates (Frame2d.originPoint frame)
    in
    ( ( m11, m12, m13 )
    , ( m21, m22, m23 )
    , ( 0, 0, 1 )
    )
