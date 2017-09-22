module Tests exposing (..)

import Fuzz
import Matrix3
import Matrix4
import OpenSolid.Axis3d as Axis3d
import OpenSolid.Direction3d as Direction3d
import OpenSolid.Geometry.Expect as Expect
import OpenSolid.Geometry.Fuzz as Fuzz
import OpenSolid.Interop.WebGLMath.Frame2d as Frame2d
import OpenSolid.Interop.WebGLMath.Frame3d as Frame3d
import OpenSolid.Interop.WebGLMath.Point2d as Point2d
import OpenSolid.Interop.WebGLMath.Point3d as Point3d
import OpenSolid.Interop.WebGLMath.Vector2d as Vector2d
import OpenSolid.Interop.WebGLMath.Vector3d as Vector3d
import OpenSolid.Point2d as Point2d
import OpenSolid.Point3d as Point3d
import OpenSolid.Vector2d as Vector2d
import OpenSolid.Vector3d as Vector3d
import Test exposing (Test)
import Vector2
import Vector3


point2dPlaceInIsTransform : Test
point2dPlaceInIsTransform =
    Test.fuzz2 Fuzz.point2d
        Fuzz.frame2d
        "Point2d.placeIn is equivalent to transform with Frame2d.toFloat3x3"
        (\point frame ->
            point
                |> Point2d.coordinates
                |> Matrix3.transform (Frame2d.toFloat3x3 frame)
                |> Point2d.fromCoordinates
                |> Expect.point2d (Point2d.placeIn frame point)
        )


point3dPlaceInIsTransform : Test
point3dPlaceInIsTransform =
    Test.fuzz2 Fuzz.point3d
        Fuzz.frame3d
        "Point3d.placeIn is equivalent to transform with Frame3d.toFloat4x4"
        (\point frame ->
            point
                |> Point3d.coordinates
                |> Matrix4.transform (Frame3d.toFloat4x4 frame)
                |> Point3d.fromCoordinates
                |> Expect.point3d (Point3d.placeIn frame point)
        )


vector2dPlaceInIsTransform : Test
vector2dPlaceInIsTransform =
    let
        transformVec mat vec =
            Vector2.sub
                (Matrix3.transform mat vec)
                (Matrix3.transform mat ( 0, 0 ))
    in
    Test.fuzz2 Fuzz.vector2d
        Fuzz.frame2d
        "Vector2d.placeIn is equivalent to transform with Frame2d.toFloat3x3"
        (\vector frame ->
            vector
                |> Vector2d.components
                |> transformVec (Frame2d.toFloat3x3 frame)
                |> Vector2d.fromComponents
                |> Expect.vector2d (Vector2d.placeIn frame vector)
        )


vector3dPlaceInIsTransform : Test
vector3dPlaceInIsTransform =
    let
        transformVec mat vec =
            Vector3.sub
                (Matrix4.transform mat vec)
                (Matrix4.transform mat ( 0, 0, 0 ))
    in
    Test.fuzz2 Fuzz.vector3d
        Fuzz.frame3d
        "Vector3d.placeIn is equivalent to transform with Frame3d.toFloat4x4"
        (\vector frame ->
            vector
                |> Vector3d.components
                |> transformVec (Frame3d.toFloat4x4 frame)
                |> Vector3d.fromComponents
                |> Expect.vector3d (Vector3d.placeIn frame vector)
        )


point2dPlaceInIsTransformBy : Test
point2dPlaceInIsTransformBy =
    Test.fuzz2 Fuzz.point2d
        Fuzz.frame2d
        "Point2d.placeIn is equivalent to transformBy Frame2d.toFloat3x3"
        (\point frame ->
            point
                |> Point2d.transformBy (Frame2d.toFloat3x3 frame)
                |> Expect.point2d (Point2d.placeIn frame point)
        )


point3dPlaceInIsTransformBy : Test
point3dPlaceInIsTransformBy =
    Test.fuzz2 Fuzz.point3d
        Fuzz.frame3d
        "Point3d.placeIn is equivalent to transformBy Frame3d.toFloat4x4"
        (\point frame ->
            point
                |> Point3d.transformBy (Frame3d.toFloat4x4 frame)
                |> Expect.point3d (Point3d.placeIn frame point)
        )


vector2dPlaceInIsTransformBy : Test
vector2dPlaceInIsTransformBy =
    Test.fuzz2 Fuzz.vector2d
        Fuzz.frame2d
        "Vector2d.placeIn is equivalent to transformBy Frame2d.toFloat3x3"
        (\vector frame ->
            vector
                |> Vector2d.transformBy (Frame2d.toFloat3x3 frame)
                |> Expect.vector2d (Vector2d.placeIn frame vector)
        )


vector3dPlaceInIsTransformBy : Test
vector3dPlaceInIsTransformBy =
    Test.fuzz2 Fuzz.vector3d
        Fuzz.frame3d
        "Vector3d.placeIn is equivalent to transformBy Frame3d.toFloat4x4"
        (\vector frame ->
            vector
                |> Vector3d.transformBy (Frame3d.toFloat4x4 frame)
                |> Expect.vector3d (Vector3d.placeIn frame vector)
        )


point3dRelativeToIsTransformByInverse : Test
point3dRelativeToIsTransformByInverse =
    Test.fuzz2 Fuzz.point3d
        Fuzz.frame3d
        "Point3d.relativeTo is equivalent to transformBy inverse of Frame3d.toFloat4x4"
        (\point frame ->
            point
                |> Point3d.transformBy
                    (Matrix4.inverseRigidBodyTransform (Frame3d.toFloat4x4 frame))
                |> Expect.point3d (Point3d.relativeTo frame point)
        )


vector3dRelativeToIsTransformByInverse : Test
vector3dRelativeToIsTransformByInverse =
    Test.fuzz2 Fuzz.vector3d
        Fuzz.frame3d
        "Vector3d.relativeTo is equivalent to transformBy inverse of Frame3d.toFloat4x4"
        (\vector frame ->
            vector
                |> Vector3d.transformBy
                    (Matrix4.inverseRigidBodyTransform (Frame3d.toFloat4x4 frame))
                |> Expect.vector3d (Vector3d.relativeTo frame vector)
        )


point3dRotationMatchesMatrix : Test
point3dRotationMatchesMatrix =
    Test.fuzz3 Fuzz.point3d
        Fuzz.direction3d
        (Fuzz.floatRange -pi pi)
        "Point3d rotation matches matrix version"
        (\point direction angle ->
            let
                axis =
                    Axis3d.with
                        { originPoint = Point3d.origin
                        , direction = direction
                        }

                rotationMatrix =
                    Matrix4.makeRotate angle (Direction3d.components direction)
            in
            Point3d.rotateAround axis angle point
                |> Expect.point3d
                    (Point3d.transformBy rotationMatrix point)
        )


point3dTranslationMatchesMatrix : Test
point3dTranslationMatchesMatrix =
    Test.fuzz2 Fuzz.point3d
        Fuzz.vector3d
        "Point3d translation matches matrix version"
        (\point vector ->
            let
                translationMatrix =
                    Matrix4.makeTranslate (Vector3d.components vector)
            in
            Point3d.translateBy vector point
                |> Expect.point3d
                    (Point3d.transformBy translationMatrix point)
        )
