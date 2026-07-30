// SPDX-FileCopyrightText: 2025 Erin Catto
// SPDX-License-Identifier: MIT

/**
 * @defgroup math Math
 * @brief Vector math types and functions
 * @{
 */

/// https://en.wikipedia.org/wiki/Pi
#define B3_PI 3.14159265359f

/// Convenience macro to convert from degrees to radians.
#define B3_DEG_TO_RAD 0.01745329251f

/// Convenience macro to convert from radians to degrees.
#define B3_RAD_TO_DEG 57.2957795131f

/// Minimum scale used for scaling collision meshes, etc.
#define B3_MIN_SCALE 0.01f

/// A 2D vector.
typedef struct b3Vec2
{
	float x;
	float y;
} b3Vec2;

/// A 3D vector.
typedef struct b3Vec3
{
	float x;
	float y;
	float z;
} b3Vec3;

/// Cosine and sine pair.
/// This uses a custom implementation designed for cross-platform determinism.
typedef struct b3CosSin
{
	/// cosine and sine
	float cosine;
	float sine;
} b3CosSin;

/// A quaternion.
typedef struct b3Quat
{
	b3Vec3 v;
	float s;
} b3Quat;

/// A rigid transform.
typedef struct b3Transform
{
	b3Vec3 p;
	b3Quat q;
} b3Transform;

#if defined( BOX3D_DOUBLE_PRECISION )

/// A world position. Double precision in large world mode so coordinates stay accurate far
/// from the origin.
typedef struct b3Pos
{
	double x, y, z;
} b3Pos;

/// A world transform with double precision translation and float quaternion rotation. Rotation
/// is frame local and never needs the extra range, the same split as Jolt's DMat44.
typedef struct b3WorldTransform
{
	b3Pos p;
	b3Quat q;
} b3WorldTransform;

#else

/// In single precision mode these types are the same.
typedef b3Vec3 b3Pos;

/// In single precision mode these types are the same.
typedef b3Transform b3WorldTransform;

#endif

/// A 3x3 matrix.
typedef struct b3Matrix3
{
	b3Vec3 cx, cy, cz;
} b3Matrix3;

/// Axis aligned bounding box.
typedef struct b3AABB
{
	b3Vec3 lowerBound;
	b3Vec3 upperBound;
} b3AABB;

/// A plane.
/// separation = dot(normal, point) - offset
typedef struct b3Plane
{
	b3Vec3 normal;
	float offset;
} b3Plane;



/// Compute an approximate arctangent in the range [-pi, pi]
/// This is hand coded for cross-platform determinism. The atan2f
/// function in the standard library is not cross-platform deterministic.
///	Accurate to around 0.0023 degrees.
float b3Atan2( float y, float x );

/// Compute the cosine and sine of an angle in radians. Implemented
/// for cross-platform determinism.
b3CosSin b3ComputeCosSin( float radians );

/// Extract a quaternion from a rotation matrix.
b3Quat b3MakeQuatFromMatrix( const b3Matrix3* m );

/// Find a quaternion that rotates one vector to another.
b3Quat b3ComputeQuatBetweenUnitVectors( b3Vec3 v1, b3Vec3 v2 );


/// Get the inertia tensor of an offset point.
/// https://en.wikipedia.org/wiki/Parallel_axis_theorem
b3Matrix3 b3Steiner( float mass, b3Vec3 origin );

/// The closest points between to segments or infinite lines.
typedef struct b3SegmentDistanceResult
{
	b3Vec3 point1;
	float fraction1;
	b3Vec3 point2;
	float fraction2;
} b3SegmentDistanceResult;

/// Compute the closest point on the segment a-b to the target q.
b3Vec3 b3PointToSegmentDistance( b3Vec3 a, b3Vec3 b, b3Vec3 q );

/// Compute the closest points on two infinite lines.
b3SegmentDistanceResult b3LineDistance( b3Vec3 p1, b3Vec3 d1, b3Vec3 p2, b3Vec3 d2 );

/// Compute the closest points on two line segments.
b3SegmentDistanceResult b3SegmentDistance( b3Vec3 p1, b3Vec3 q1, b3Vec3 p2, b3Vec3 q2 );

/// Is this a valid number? Not NaN or infinity.
bool b3IsValidFloat( float a );

/// Is this a valid vector? Not NaN or infinity.
bool b3IsValidVec3( b3Vec3 a );

/// Is this a valid quaternion? Not NaN or infinity. Is normalized.
bool b3IsValidQuat( b3Quat q );

/// Is this a valid transform? Not NaN or infinity. Is normalized.
bool b3IsValidTransform( b3Transform a );

/// Is this a valid matrix? Not NaN or infinity.
bool b3IsValidMatrix3( b3Matrix3 a );

/// Is this a valid bounding box? Not Nan or infinity. Upper bound greater than or equal to lower bound.
bool b3IsValidAABB( b3AABB a );

/// Is this AABB reasonably close to the origin? See B3_HUGE.
bool b3IsBoundedAABB( b3AABB a );

/// Is this AABB valid and reasonable?
bool b3IsSaneAABB( b3AABB a );

/// Is this a valid plane? Normal is a unit vector. Not Nan or infinity.
bool b3IsValidPlane( b3Plane a );

/// Is this a valid world position? Not NaN or infinity.
bool b3IsValidPosition( b3Pos p );

/// Is this a valid world transform? Not NaN or infinity. Rotation is normalized.
bool b3IsValidWorldTransform( b3WorldTransform t );

/**@}*/ // math

