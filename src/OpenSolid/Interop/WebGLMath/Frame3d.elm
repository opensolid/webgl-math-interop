module OpenSolid.Interop.WebGLMath.Frame3d exposing (toFloat4x4)

{-| Conversion functions for `Frame3d`.

@docs toFloat4x4

-}

import Matrix4 exposing (Float4x4)
import OpenSolid.Direction3d as Direction3d
import OpenSolid.Frame3d as Frame3d exposing (Frame3d)
import OpenSolid.Point3d as Point3d


{-| Convert a `Frame3d` to a `Float4x4`. The resulting matrix can be thought of
in a couple of ways:

  - It is the transformation matrix that takes the global XYZ frame and
    transforms it to the given frame
  - It is the transformation matrix from local coordinates in the given frame
    to global coordinates

The first bullet implies that something like

    Frame3d.xyz
        |> Frame3d.translateBy displacement
        |> Frame3d.rotateAround axis angle
        |> Frame3d.mirrorAcross plane
        |> Frame3d.toFloat4x4

gives you a transformation matrix that is equivalent to applying the given
displacement, then the given rotation, then the given mirror. The second bullet
means that, for example,

    Point3d.placeIn frame

is equivalent to

    Point3d.transformBy (Frame3d.toFloat4x4 frame)

and

    Point3d.relativeTo frame

is equivalent to

    Point3d.transformBy <|
        Matrix4.inverseRigidBodyTransform
            (Frame3d.toFloat4x4 frame)

-}
toFloat4x4 : Frame3d -> Float4x4
toFloat4x4 frame =
    let
        ( m11, m21, m31 ) =
            Direction3d.components (Frame3d.xDirection frame)

        ( m12, m22, m32 ) =
            Direction3d.components (Frame3d.yDirection frame)

        ( m13, m23, m33 ) =
            Direction3d.components (Frame3d.zDirection frame)

        ( m14, m24, m34 ) =
            Point3d.coordinates (Frame3d.originPoint frame)
    in
    ( ( m11, m12, m13, m14 )
    , ( m21, m22, m23, m24 )
    , ( m31, m32, m33, m34 )
    , ( 0, 0, 0, 1 )
    )
