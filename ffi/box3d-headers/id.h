// SPDX-FileCopyrightText: 2026 Erin Catto
// SPDX-License-Identifier: MIT

// Note: this file should be stand-alone

/**
 * @defgroup id Ids
 * These ids serve as handles to internal Box3D objects.
 * These should be considered opaque data and passed by value.
 * Include this header if you need the id types and not the whole Box3D API.
 * All ids are considered null if initialized to zero.
 *
 * For example in C++:
 *
 * @code{.cxx}
 * b3WorldId worldId = {};
 * @endcode
 *
 * Or in C:
 *
 * @code{.c}
 * b3WorldId worldId = {0};
 * @endcode
 *
 * These are both considered null.
 *
 * @warning Do not use the internals of these ids. They are subject to change. Ids should be treated as opaque objects.
 * @warning You should use ids to access objects in Box3D. Do not access files within the src folder. Such usage is unsupported.
 * @{
 */

/// World id references a world instance. This should be treated as an opaque handle.
typedef struct b3WorldId
{
	uint16_t index1;
	uint16_t generation;
} b3WorldId;

/// Body id references a body instance. This should be treated as an opaque handle.
typedef struct b3BodyId
{
	int32_t index1;
	uint16_t world0;
	uint16_t generation;
} b3BodyId;

/// Shape id references a shape instance. This should be treated as an opaque handle.
typedef struct b3ShapeId
{
	int32_t index1;
	uint16_t world0;
	uint16_t generation;
} b3ShapeId;

/// Joint id references a joint instance. This should be treated as an opaque handle.
typedef struct b3JointId
{
	int32_t index1;
	uint16_t world0;
	uint16_t generation;
} b3JointId;

/// Contact id references a contact instance. This should be treated as an opaque handle.
typedef struct b3ContactId
{
	int32_t index1;
	uint16_t world0;
	int16_t padding;
	uint32_t generation;
} b3ContactId;

// clang-format off
#ifdef __cplusplus
	/// A null id. Works for any id type.
	#define B3_NULL_ID {}
	#define B3_ID_INLINE inline
#else
	/// A null id. Works for any id type.
	#define B3_NULL_ID { 0 }

	/// This macro bridges C and C++ inline functions. C++ has the one definition rule that C lacks.
	#define B3_ID_INLINE static inline
#endif
// clang-format on

/// Use these to make your identifiers null.
/// You may also use zero initialization to get null.
//static const b3WorldId b3_nullWorldId = B3_NULL_ID;
//static const b3BodyId b3_nullBodyId = B3_NULL_ID;
//static const b3ShapeId b3_nullShapeId = B3_NULL_ID;
//static const b3JointId b3_nullJointId = B3_NULL_ID;
//static const b3ContactId b3_nullContactId = B3_NULL_ID;

/// Macro to determine if any id is null.
#define B3_IS_NULL( id ) ( id.index1 == 0 )

/// Macro to determine if any id is non-null.
#define B3_IS_NON_NULL( id ) ( id.index1 != 0 )

/// Compare two ids for equality. Doesn't work for b3WorldId. Don't mix types.
#define B3_ID_EQUALS( id1, id2 ) ( id1.index1 == id2.index1 && id1.world0 == id2.world0 && id1.generation == id2.generation )


/**@}*/
