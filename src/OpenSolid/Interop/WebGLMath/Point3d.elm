module OpenSolid.Interop.WebGLMath.Point3d exposing (transformBy)

{-| Transformation functions for `Point3d`.

@docs transformBy

-}

import Matrix4 exposing (Float4x4)
import OpenSolid.Point3d as Point3d exposing (Point3d)


{-| Transform a `Point3d` by a `Float4x4`;

    point
        |> Point3d.transformBy matrix

is equivalent to

    point
        |> Point3d.coordinates
        |> Matrix4.transform matrix
        |> Point3d.fromCoordinates

For example:

    point =
        Point3d.fromCoordinates ( 2, 1, 3 )

    matrix =
        Matrix4.makeTranslate ( 3, 4, 5 )

    Point3d.transformBy matrix point
    --> Point3d.fromCoordinates ( 5, 5, 8 )

-}
transformBy : Float4x4 -> Point3d -> Point3d
transformBy matrix point =
    point
        |> Point3d.coordinates
        |> Matrix4.transform matrix
        |> Point3d.fromCoordinates
