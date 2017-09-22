module OpenSolid.Interop.WebGLMath.Vector2d exposing (transformBy)

{-| Transformation functions for `Vector2d`.

@docs transformBy

-}

import Matrix3 exposing (Float3x3)
import OpenSolid.Vector2d as Vector2d exposing (Vector2d)


{-| Transform a `Vector2d` by a `Float3x3`; note that

    vector
        |> Vector2d.transformBy matrix

is similar to but _not_ in general equivalent to

    vector
        |> Vector2d.components
        |> Matrix3.transform matrix
        |> Vector2d.fromComponents

since `Matrix3.transform` implicitly assumes that the given argument represents
a point, not a vector, and therefore applies translation to it. Transforming a
vector by a 3x3 matrix should in fact ignore any translation component of the
matrix, which this function does. For example:

    vector =
        Vector2d.fromComponents ( 2, 1 )

    -- 90 degree rotation, followed by a translation by (5, 5)
    matrix =
        ( ( 0, -1, 5 )
        , ( 1, 0, 5 )
        , ( 0, 0, 1 )
        )

    Vector2d.transformBy matrix vector
    --> Vector2d.fromComponents ( -1, 2 )

-}
transformBy : Float3x3 -> Vector2d -> Vector2d
transformBy matrix vector =
    let
        ( ( m11, m12, m13 ), ( m21, m22, m23 ), ( m31, m32, m33 ) ) =
            matrix

        ( x, y ) =
            Vector2d.components vector
    in
    Vector2d.fromComponents
        ( m11 * x + m12 * y
        , m21 * x + m22 * y
        )
