module OpenSolid.Interop.WebGLMath.Point2d exposing (transformBy)

{-| Transformation functions for `Point2d`.

@docs transformBy

-}

import Matrix3 exposing (Float3x3)
import OpenSolid.Point2d as Point2d exposing (Point2d)


{-| Transform a `Point2d` by a `Float3x3`;

    point
        |> Point2d.transformBy matrix

is equivalent to

    point
        |> Point2d.coordinates
        |> Matrix3.transform matrix
        |> Point2d.fromCoordinates

For example:

    point =
        Point2d.fromCoordinates ( 2, 1 )

    -- Translation by (5, 5)
    matrix =
        ( ( 1, 0, 5 )
        , ( 0, 1, 5 )
        , ( 0, 0, 1 )
        )

    Point2d.transformBy matrix point
    --> Point2d.fromCoordinates ( 7, 6 )

-}
transformBy : Float3x3 -> Point2d -> Point2d
transformBy matrix point =
    point
        |> Point2d.coordinates
        |> Matrix3.transform matrix
        |> Point2d.fromCoordinates
