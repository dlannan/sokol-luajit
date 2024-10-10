local ffi  = require( "ffi" )

local sokol_filename = _G.SOKOL_DLL or "sokol_imgui_dll"
local libs = ffi_sokol_imgui or {
   OSX     = { x64 = sokol_filename..".so" },
   Windows = { x64 = sokol_filename..".dll" },
   Linux   = { x64 = sokol_filename..".so", arm = sokol_filename..".so" },
   BSD     = { x64 = sokol_filename..".so" },
   POSIX   = { x64 = sokol_filename..".so" },
   Other   = { x64 = sokol_filename..".so" },
}

local lib  = ffi_sokol_imgui or libs[ ffi.os ][ ffi.arch ]
local sokol_imgui   = ffi.load( lib )

ffi.cdef[[

/********** sokol_gfx ****************************************************************/


/*
    Resource id typedefs:

    sg_buffer:      vertex- and index-buffers
    sg_image:       images used as textures and render targets
    sg_sampler      sampler object describing how a texture is sampled in a shader
    sg_shader:      vertex- and fragment-shaders and shader interface information
    sg_pipeline:    associated shader and vertex-layouts, and render states
    sg_attachments: a baked collection of render pass attachment images

    Instead of pointers, resource creation functions return a 32-bit
    number which uniquely identifies the resource object.

    The 32-bit resource id is split into a 16-bit pool index in the lower bits,
    and a 16-bit 'generation counter' in the upper bits. The index allows fast
    pool lookups, and combined with the generation-counter it allows to detect
    'dangling accesses' (trying to use an object which no longer exists, and
    its pool slot has been reused for a new object)

    The resource ids are wrapped into a strongly-typed struct so that
    trying to pass an incompatible resource id is a compile error.
*/
typedef struct sg_buffer        { uint32_t id; } sg_buffer;
typedef struct sg_image         { uint32_t id; } sg_image;
typedef struct sg_sampler       { uint32_t id; } sg_sampler;
typedef struct sg_shader        { uint32_t id; } sg_shader;
typedef struct sg_pipeline      { uint32_t id; } sg_pipeline;
typedef struct sg_attachments   { uint32_t id; } sg_attachments;

/*
    sg_range is a pointer-size-pair struct used to pass memory blobs into
    sokol-gfx. When initialized from a value type (array or struct), you can
    use the SG_RANGE() macro to build an sg_range struct. For functions which
    take either a sg_range pointer, or a (C++) sg_range reference, use the
    SG_RANGE_REF macro as a solution which compiles both in C and C++.
*/
typedef struct sg_range {
    const void* ptr;
    size_t size;
} sg_range;

//  various compile-time constants
enum {
    SG_INVALID_ID = 0,
    SG_NUM_SHADER_STAGES = 2,
    SG_NUM_INFLIGHT_FRAMES = 2,
    SG_MAX_COLOR_ATTACHMENTS = 4,
    SG_MAX_VERTEX_BUFFERS = 8,
    SG_MAX_SHADERSTAGE_IMAGES = 12,
    SG_MAX_SHADERSTAGE_SAMPLERS = 8,
    SG_MAX_SHADERSTAGE_IMAGESAMPLERPAIRS = 12,
    SG_MAX_SHADERSTAGE_STORAGEBUFFERS = 8,
    SG_MAX_SHADERSTAGE_UBS = 4,
    SG_MAX_UB_MEMBERS = 16,
    SG_MAX_VERTEX_ATTRIBUTES = 16,
    SG_MAX_MIPMAPS = 16,
    SG_MAX_TEXTUREARRAY_LAYERS = 128
};

/*
    sg_color

    An RGBA color value.
*/
typedef struct sg_color { float r, g, b, a; } sg_color;

/*
    sg_backend

    The active 3D-API backend, use the function sg_query_backend()
    to get the currently active backend.
*/
typedef enum sg_backend {
    SG_BACKEND_GLCORE,
    SG_BACKEND_GLES3,
    SG_BACKEND_D3D11,
    SG_BACKEND_METAL_IOS,
    SG_BACKEND_METAL_MACOS,
    SG_BACKEND_METAL_SIMULATOR,
    SG_BACKEND_WGPU,
    SG_BACKEND_DUMMY,
} sg_backend;

/*
    sg_pixel_format

    sokol_gfx.h basically uses the same pixel formats as WebGPU, since these
    are supported on most newer GPUs.

    A pixelformat name consist of three parts:

        - components (R, RG, RGB or RGBA)
        - bit width per component (8, 16 or 32)
        - component data type:
            - unsigned normalized (no postfix)
            - signed normalized (SN postfix)
            - unsigned integer (UI postfix)
            - signed integer (SI postfix)
            - float (F postfix)

    Not all pixel formats can be used for everything, call sg_query_pixelformat()
    to inspect the capabilities of a given pixelformat. The function returns
    an sg_pixelformat_info struct with the following members:

        - sample: the pixelformat can be sampled as texture at least with
                  nearest filtering
        - filter: the pixelformat can be samples as texture with linear
                  filtering
        - render: the pixelformat can be used for render targets
        - blend:  blending is supported when using the pixelformat for
                  render targets
        - msaa:   multisample-antialiasing is supported when using the
                  pixelformat for render targets
        - depth:  the pixelformat can be used for depth-stencil attachments
        - compressed: this is a block-compressed format
        - bytes_per_pixel: the numbers of bytes in a pixel (0 for compressed formats)

    The default pixel format for texture images is SG_PIXELFORMAT_RGBA8.

    The default pixel format for render target images is platform-dependent
    and taken from the sg_environment struct passed into sg_setup(). Typically
    the default formats are:

        - for the Metal, D3D11 and WebGPU backends: SG_PIXELFORMAT_BGRA8
        - for GL backends: SG_PIXELFORMAT_RGBA8
*/
typedef enum sg_pixel_format {
    _SG_PIXELFORMAT_DEFAULT,    // value 0 reserved for default-init
    SG_PIXELFORMAT_NONE,

    SG_PIXELFORMAT_R8,
    SG_PIXELFORMAT_R8SN,
    SG_PIXELFORMAT_R8UI,
    SG_PIXELFORMAT_R8SI,

    SG_PIXELFORMAT_R16,
    SG_PIXELFORMAT_R16SN,
    SG_PIXELFORMAT_R16UI,
    SG_PIXELFORMAT_R16SI,
    SG_PIXELFORMAT_R16F,
    SG_PIXELFORMAT_RG8,
    SG_PIXELFORMAT_RG8SN,
    SG_PIXELFORMAT_RG8UI,
    SG_PIXELFORMAT_RG8SI,

    SG_PIXELFORMAT_R32UI,
    SG_PIXELFORMAT_R32SI,
    SG_PIXELFORMAT_R32F,
    SG_PIXELFORMAT_RG16,
    SG_PIXELFORMAT_RG16SN,
    SG_PIXELFORMAT_RG16UI,
    SG_PIXELFORMAT_RG16SI,
    SG_PIXELFORMAT_RG16F,
    SG_PIXELFORMAT_RGBA8,
    SG_PIXELFORMAT_SRGB8A8,
    SG_PIXELFORMAT_RGBA8SN,
    SG_PIXELFORMAT_RGBA8UI,
    SG_PIXELFORMAT_RGBA8SI,
    SG_PIXELFORMAT_BGRA8,
    SG_PIXELFORMAT_RGB10A2,
    SG_PIXELFORMAT_RG11B10F,
    SG_PIXELFORMAT_RGB9E5,

    SG_PIXELFORMAT_RG32UI,
    SG_PIXELFORMAT_RG32SI,
    SG_PIXELFORMAT_RG32F,
    SG_PIXELFORMAT_RGBA16,
    SG_PIXELFORMAT_RGBA16SN,
    SG_PIXELFORMAT_RGBA16UI,
    SG_PIXELFORMAT_RGBA16SI,
    SG_PIXELFORMAT_RGBA16F,

    SG_PIXELFORMAT_RGBA32UI,
    SG_PIXELFORMAT_RGBA32SI,
    SG_PIXELFORMAT_RGBA32F,

    // NOTE: when adding/removing pixel formats before DEPTH, also update sokol_app.h/_SAPP_PIXELFORMAT_*
    SG_PIXELFORMAT_DEPTH,
    SG_PIXELFORMAT_DEPTH_STENCIL,

    // NOTE: don't put any new compressed format in front of here
    SG_PIXELFORMAT_BC1_RGBA,
    SG_PIXELFORMAT_BC2_RGBA,
    SG_PIXELFORMAT_BC3_RGBA,
    SG_PIXELFORMAT_BC3_SRGBA,
    SG_PIXELFORMAT_BC4_R,
    SG_PIXELFORMAT_BC4_RSN,
    SG_PIXELFORMAT_BC5_RG,
    SG_PIXELFORMAT_BC5_RGSN,
    SG_PIXELFORMAT_BC6H_RGBF,
    SG_PIXELFORMAT_BC6H_RGBUF,
    SG_PIXELFORMAT_BC7_RGBA,
    SG_PIXELFORMAT_BC7_SRGBA,
    SG_PIXELFORMAT_PVRTC_RGB_2BPP,      // FIXME: deprecated
    SG_PIXELFORMAT_PVRTC_RGB_4BPP,      // FIXME: deprecated
    SG_PIXELFORMAT_PVRTC_RGBA_2BPP,     // FIXME: deprecated
    SG_PIXELFORMAT_PVRTC_RGBA_4BPP,     // FIXME: deprecated
    SG_PIXELFORMAT_ETC2_RGB8,
    SG_PIXELFORMAT_ETC2_SRGB8,
    SG_PIXELFORMAT_ETC2_RGB8A1,
    SG_PIXELFORMAT_ETC2_RGBA8,
    SG_PIXELFORMAT_ETC2_SRGB8A8,
    SG_PIXELFORMAT_EAC_R11,
    SG_PIXELFORMAT_EAC_R11SN,
    SG_PIXELFORMAT_EAC_RG11,
    SG_PIXELFORMAT_EAC_RG11SN,

    SG_PIXELFORMAT_ASTC_4x4_RGBA,
    SG_PIXELFORMAT_ASTC_4x4_SRGBA,

    _SG_PIXELFORMAT_NUM,
    _SG_PIXELFORMAT_FORCE_U32 = 0x7FFFFFFF
} sg_pixel_format;

/*
    Runtime information about a pixel format, returned
    by sg_query_pixelformat().
*/
typedef struct sg_pixelformat_info {
    bool sample;            // pixel format can be sampled in shaders at least with nearest filtering
    bool filter;            // pixel format can be sampled with linear filtering
    bool render;            // pixel format can be used as render target
    bool blend;             // alpha-blending is supported
    bool msaa;              // pixel format can be used as MSAA render target
    bool depth;             // pixel format is a depth format
    bool compressed;        // true if this is a hardware-compressed format
    int bytes_per_pixel;    // NOTE: this is 0 for compressed formats, use sg_query_row_pitch() / sg_query_surface_pitch() as alternative
} sg_pixelformat_info;

/*
    Runtime information about available optional features,
    returned by sg_query_features()
*/
typedef struct sg_features {
    bool origin_top_left;               // framebuffer and texture origin is in top left corner
    bool image_clamp_to_border;         // border color and clamp-to-border UV-wrap mode is supported
    bool mrt_independent_blend_state;   // multiple-render-target rendering can use per-render-target blend state
    bool mrt_independent_write_mask;    // multiple-render-target rendering can use per-render-target color write masks
    bool storage_buffer;                // storage buffers are supported
} sg_features;

/*
    Runtime information about resource limits, returned by sg_query_limit()
*/
typedef struct sg_limits {
    int max_image_size_2d;          // max width/height of SG_IMAGETYPE_2D images
    int max_image_size_cube;        // max width/height of SG_IMAGETYPE_CUBE images
    int max_image_size_3d;          // max width/height/depth of SG_IMAGETYPE_3D images
    int max_image_size_array;       // max width/height of SG_IMAGETYPE_ARRAY images
    int max_image_array_layers;     // max number of layers in SG_IMAGETYPE_ARRAY images
    int max_vertex_attrs;           // max number of vertex attributes, clamped to SG_MAX_VERTEX_ATTRIBUTES
    int gl_max_vertex_uniform_components;    // <= GL_MAX_VERTEX_UNIFORM_COMPONENTS (only on GL backends)
    int gl_max_combined_texture_image_units; // <= GL_MAX_COMBINED_TEXTURE_IMAGE_UNITS (only on GL backends)
} sg_limits;

/*
    sg_resource_state

    The current state of a resource in its resource pool.
    Resources start in the INITIAL state, which means the
    pool slot is unoccupied and can be allocated. When a resource is
    created, first an id is allocated, and the resource pool slot
    is set to state ALLOC. After allocation, the resource is
    initialized, which may result in the VALID or FAILED state. The
    reason why allocation and initialization are separate is because
    some resource types (e.g. buffers and images) might be asynchronously
    initialized by the user application. If a resource which is not
    in the VALID state is attempted to be used for rendering, rendering
    operations will silently be dropped.

    The special INVALID state is returned in sg_query_xxx_state() if no
    resource object exists for the provided resource id.
*/
typedef enum sg_resource_state {
    SG_RESOURCESTATE_INITIAL,
    SG_RESOURCESTATE_ALLOC,
    SG_RESOURCESTATE_VALID,
    SG_RESOURCESTATE_FAILED,
    SG_RESOURCESTATE_INVALID,
    _SG_RESOURCESTATE_FORCE_U32 = 0x7FFFFFFF
} sg_resource_state;

/*
    sg_usage

    A resource usage hint describing the update strategy of
    buffers and images. This is used in the sg_buffer_desc.usage
    and sg_image_desc.usage members when creating buffers
    and images:

    SG_USAGE_IMMUTABLE:     the resource will never be updated with
                            new data, instead the content of the
                            resource must be provided on creation
    SG_USAGE_DYNAMIC:       the resource will be updated infrequently
                            with new data (this could range from "once
                            after creation", to "quite often but not
                            every frame")
    SG_USAGE_STREAM:        the resource will be updated each frame
                            with new content

    The rendering backends use this hint to prevent that the
    CPU needs to wait for the GPU when attempting to update
    a resource that might be currently accessed by the GPU.

    Resource content is updated with the functions sg_update_buffer() or
    sg_append_buffer() for buffer objects, and sg_update_image() for image
    objects. For the sg_update_*() functions, only one update is allowed per
    frame and resource object, while sg_append_buffer() can be called
    multiple times per frame on the same buffer. The application must update
    all data required for rendering (this means that the update data can be
    smaller than the resource size, if only a part of the overall resource
    size is used for rendering, you only need to make sure that the data that
    *is* used is valid).

    The default usage is SG_USAGE_IMMUTABLE.
*/
typedef enum sg_usage {
    _SG_USAGE_DEFAULT,      // value 0 reserved for default-init
    SG_USAGE_IMMUTABLE,
    SG_USAGE_DYNAMIC,
    SG_USAGE_STREAM,
    _SG_USAGE_NUM,
    _SG_USAGE_FORCE_U32 = 0x7FFFFFFF
} sg_usage;

/*
    sg_buffer_type

    Indicates whether a buffer will be bound as vertex-,
    index- or storage-buffer.

    Used in the sg_buffer_desc.type member when creating a buffer.

    The default value is SG_BUFFERTYPE_VERTEXBUFFER.
*/
typedef enum sg_buffer_type {
    _SG_BUFFERTYPE_DEFAULT,         // value 0 reserved for default-init
    SG_BUFFERTYPE_VERTEXBUFFER,
    SG_BUFFERTYPE_INDEXBUFFER,
    SG_BUFFERTYPE_STORAGEBUFFER,
    _SG_BUFFERTYPE_NUM,
    _SG_BUFFERTYPE_FORCE_U32 = 0x7FFFFFFF
} sg_buffer_type;

/*
    sg_index_type

    Indicates whether indexed rendering (fetching vertex-indices from an
    index buffer) is used, and if yes, the index data type (16- or 32-bits).
    This is used in the sg_pipeline_desc.index_type member when creating a
    pipeline object.

    The default index type is SG_INDEXTYPE_NONE.
*/
typedef enum sg_index_type {
    _SG_INDEXTYPE_DEFAULT,   // value 0 reserved for default-init
    SG_INDEXTYPE_NONE,
    SG_INDEXTYPE_UINT16,
    SG_INDEXTYPE_UINT32,
    _SG_INDEXTYPE_NUM,
    _SG_INDEXTYPE_FORCE_U32 = 0x7FFFFFFF
} sg_index_type;

/*
    sg_image_type

    Indicates the basic type of an image object (2D-texture, cubemap,
    3D-texture or 2D-array-texture). Used in the sg_image_desc.type member when
    creating an image, and in sg_shader_image_desc to describe a sampled texture
    in the shader (both must match and will be checked in the validation layer
    when calling sg_apply_bindings).

    The default image type when creating an image is SG_IMAGETYPE_2D.
*/
typedef enum sg_image_type {
    _SG_IMAGETYPE_DEFAULT,  // value 0 reserved for default-init
    SG_IMAGETYPE_2D,
    SG_IMAGETYPE_CUBE,
    SG_IMAGETYPE_3D,
    SG_IMAGETYPE_ARRAY,
    _SG_IMAGETYPE_NUM,
    _SG_IMAGETYPE_FORCE_U32 = 0x7FFFFFFF
} sg_image_type;

/*
    sg_image_sample_type

    The basic data type of a texture sample as expected by a shader.
    Must be provided in sg_shader_image_desc and used by the validation
    layer in sg_apply_bindings() to check if the provided image object
    is compatible with what the shader expects. Apart from the sokol-gfx
    validation layer, WebGPU is the only backend API which actually requires
    matching texture and sampler type to be provided upfront for validation
    (other 3D APIs treat texture/sampler type mismatches as undefined behaviour).

    NOTE that the following texture pixel formats require the use
    of SG_IMAGESAMPLETYPE_UNFILTERABLE_FLOAT, combined with a sampler
    of type SG_SAMPLERTYPE_NONFILTERING:

    - SG_PIXELFORMAT_R32F
    - SG_PIXELFORMAT_RG32F
    - SG_PIXELFORMAT_RGBA32F

    (when using sokol-shdc, also check out the meta tags `@image_sample_type`
    and `@sampler_type`)
*/
typedef enum sg_image_sample_type {
    _SG_IMAGESAMPLETYPE_DEFAULT,  // value 0 reserved for default-init
    SG_IMAGESAMPLETYPE_FLOAT,
    SG_IMAGESAMPLETYPE_DEPTH,
    SG_IMAGESAMPLETYPE_SINT,
    SG_IMAGESAMPLETYPE_UINT,
    SG_IMAGESAMPLETYPE_UNFILTERABLE_FLOAT,
    _SG_IMAGESAMPLETYPE_NUM,
    _SG_IMAGESAMPLETYPE_FORCE_U32 = 0x7FFFFFFF
} sg_image_sample_type;

/*
    sg_sampler_type

    The basic type of a texture sampler (sampling vs comparison) as
    defined in a shader. Must be provided in sg_shader_sampler_desc.

    sg_image_sample_type and sg_sampler_type for a texture/sampler
    pair must be compatible with each other, specifically only
    the following pairs are allowed:

    - SG_IMAGESAMPLETYPE_FLOAT => (SG_SAMPLERTYPE_FILTERING or SG_SAMPLERTYPE_NONFILTERING)
    - SG_IMAGESAMPLETYPE_UNFILTERABLE_FLOAT => SG_SAMPLERTYPE_NONFILTERING
    - SG_IMAGESAMPLETYPE_SINT => SG_SAMPLERTYPE_NONFILTERING
    - SG_IMAGESAMPLETYPE_UINT => SG_SAMPLERTYPE_NONFILTERING
    - SG_IMAGESAMPLETYPE_DEPTH => SG_SAMPLERTYPE_COMPARISON
*/
typedef enum sg_sampler_type {
    _SG_SAMPLERTYPE_DEFAULT,
    SG_SAMPLERTYPE_FILTERING,
    SG_SAMPLERTYPE_NONFILTERING,
    SG_SAMPLERTYPE_COMPARISON,
    _SG_SAMPLERTYPE_NUM,
    _SG_SAMPLERTYPE_FORCE_U32,
} sg_sampler_type;

/*
    sg_cube_face

    The cubemap faces. Use these as indices in the sg_image_desc.content
    array.
*/
typedef enum sg_cube_face {
    SG_CUBEFACE_POS_X,
    SG_CUBEFACE_NEG_X,
    SG_CUBEFACE_POS_Y,
    SG_CUBEFACE_NEG_Y,
    SG_CUBEFACE_POS_Z,
    SG_CUBEFACE_NEG_Z,
    SG_CUBEFACE_NUM,
    _SG_CUBEFACE_FORCE_U32 = 0x7FFFFFFF
} sg_cube_face;

/*
    sg_shader_stage

    There are 2 shader stages: vertex- and fragment-shader-stage.
    Each shader stage

    - SG_MAX_SHADERSTAGE_UBS slots for applying uniform data
    - SG_MAX_SHADERSTAGE_IMAGES slots for images used as textures
    - SG_MAX_SHADERSTAGE_SAMPLERS slots for texture samplers
    - SG_MAX_SHADERSTAGE_STORAGEBUFFERS slots for storage buffer bindings
*/
typedef enum sg_shader_stage {
    SG_SHADERSTAGE_VS,
    SG_SHADERSTAGE_FS,
    _SG_SHADERSTAGE_FORCE_U32 = 0x7FFFFFFF
} sg_shader_stage;

/*
    sg_primitive_type

    This is the common subset of 3D primitive types supported across all 3D
    APIs. This is used in the sg_pipeline_desc.primitive_type member when
    creating a pipeline object.

    The default primitive type is SG_PRIMITIVETYPE_TRIANGLES.
*/
typedef enum sg_primitive_type {
    _SG_PRIMITIVETYPE_DEFAULT,  // value 0 reserved for default-init
    SG_PRIMITIVETYPE_POINTS,
    SG_PRIMITIVETYPE_LINES,
    SG_PRIMITIVETYPE_LINE_STRIP,
    SG_PRIMITIVETYPE_TRIANGLES,
    SG_PRIMITIVETYPE_TRIANGLE_STRIP,
    _SG_PRIMITIVETYPE_NUM,
    _SG_PRIMITIVETYPE_FORCE_U32 = 0x7FFFFFFF
} sg_primitive_type;

/*
    sg_filter

    The filtering mode when sampling a texture image. This is
    used in the sg_sampler_desc.min_filter, sg_sampler_desc.mag_filter
    and sg_sampler_desc.mipmap_filter members when creating a sampler object.

    For the default is SG_FILTER_NEAREST.
*/
typedef enum sg_filter {
    _SG_FILTER_DEFAULT, // value 0 reserved for default-init
    SG_FILTER_NEAREST,
    SG_FILTER_LINEAR,
    _SG_FILTER_NUM,
    _SG_FILTER_FORCE_U32 = 0x7FFFFFFF
} sg_filter;

/*
    sg_wrap

    The texture coordinates wrapping mode when sampling a texture
    image. This is used in the sg_image_desc.wrap_u, .wrap_v
    and .wrap_w members when creating an image.

    The default wrap mode is SG_WRAP_REPEAT.

    NOTE: SG_WRAP_CLAMP_TO_BORDER is not supported on all backends
    and platforms. To check for support, call sg_query_features()
    and check the "clamp_to_border" boolean in the returned
    sg_features struct.

    Platforms which don't support SG_WRAP_CLAMP_TO_BORDER will silently fall back
    to SG_WRAP_CLAMP_TO_EDGE without a validation error.
*/
typedef enum sg_wrap {
    _SG_WRAP_DEFAULT,   // value 0 reserved for default-init
    SG_WRAP_REPEAT,
    SG_WRAP_CLAMP_TO_EDGE,
    SG_WRAP_CLAMP_TO_BORDER,
    SG_WRAP_MIRRORED_REPEAT,
    _SG_WRAP_NUM,
    _SG_WRAP_FORCE_U32 = 0x7FFFFFFF
} sg_wrap;

/*
    sg_border_color

    The border color to use when sampling a texture, and the UV wrap
    mode is SG_WRAP_CLAMP_TO_BORDER.

    The default border color is SG_BORDERCOLOR_OPAQUE_BLACK
*/
typedef enum sg_border_color {
    _SG_BORDERCOLOR_DEFAULT,    // value 0 reserved for default-init
    SG_BORDERCOLOR_TRANSPARENT_BLACK,
    SG_BORDERCOLOR_OPAQUE_BLACK,
    SG_BORDERCOLOR_OPAQUE_WHITE,
    _SG_BORDERCOLOR_NUM,
    _SG_BORDERCOLOR_FORCE_U32 = 0x7FFFFFFF
} sg_border_color;

/*
    sg_vertex_format

    The data type of a vertex component. This is used to describe
    the layout of vertex data when creating a pipeline object.
*/
typedef enum sg_vertex_format {
    SG_VERTEXFORMAT_INVALID,
    SG_VERTEXFORMAT_FLOAT,
    SG_VERTEXFORMAT_FLOAT2,
    SG_VERTEXFORMAT_FLOAT3,
    SG_VERTEXFORMAT_FLOAT4,
    SG_VERTEXFORMAT_BYTE4,
    SG_VERTEXFORMAT_BYTE4N,
    SG_VERTEXFORMAT_UBYTE4,
    SG_VERTEXFORMAT_UBYTE4N,
    SG_VERTEXFORMAT_SHORT2,
    SG_VERTEXFORMAT_SHORT2N,
    SG_VERTEXFORMAT_USHORT2N,
    SG_VERTEXFORMAT_SHORT4,
    SG_VERTEXFORMAT_SHORT4N,
    SG_VERTEXFORMAT_USHORT4N,
    SG_VERTEXFORMAT_UINT10_N2,
    SG_VERTEXFORMAT_HALF2,
    SG_VERTEXFORMAT_HALF4,
    _SG_VERTEXFORMAT_NUM,
    _SG_VERTEXFORMAT_FORCE_U32 = 0x7FFFFFFF
} sg_vertex_format;

/*
    sg_vertex_step

    Defines whether the input pointer of a vertex input stream is advanced
    'per vertex' or 'per instance'. The default step-func is
    SG_VERTEXSTEP_PER_VERTEX. SG_VERTEXSTEP_PER_INSTANCE is used with
    instanced-rendering.

    The vertex-step is part of the vertex-layout definition
    when creating pipeline objects.
*/
typedef enum sg_vertex_step {
    _SG_VERTEXSTEP_DEFAULT,     // value 0 reserved for default-init
    SG_VERTEXSTEP_PER_VERTEX,
    SG_VERTEXSTEP_PER_INSTANCE,
    _SG_VERTEXSTEP_NUM,
    _SG_VERTEXSTEP_FORCE_U32 = 0x7FFFFFFF
} sg_vertex_step;

/*
    sg_uniform_type

    The data type of a uniform block member. This is used to
    describe the internal layout of uniform blocks when creating
    a shader object.
*/
typedef enum sg_uniform_type {
    SG_UNIFORMTYPE_INVALID,
    SG_UNIFORMTYPE_FLOAT,
    SG_UNIFORMTYPE_FLOAT2,
    SG_UNIFORMTYPE_FLOAT3,
    SG_UNIFORMTYPE_FLOAT4,
    SG_UNIFORMTYPE_INT,
    SG_UNIFORMTYPE_INT2,
    SG_UNIFORMTYPE_INT3,
    SG_UNIFORMTYPE_INT4,
    SG_UNIFORMTYPE_MAT4,
    _SG_UNIFORMTYPE_NUM,
    _SG_UNIFORMTYPE_FORCE_U32 = 0x7FFFFFFF
} sg_uniform_type;

/*
    sg_uniform_layout

    A hint for the interior memory layout of uniform blocks. This is
    only really relevant for the GL backend where the internal layout
    of uniform blocks must be known to sokol-gfx. For all other backends the
    internal memory layout of uniform blocks doesn't matter, sokol-gfx
    will just pass uniform data as a single memory blob to the
    3D backend.

    SG_UNIFORMLAYOUT_NATIVE (default)
        Native layout means that a 'backend-native' memory layout
        is used. For the GL backend this means that uniforms
        are packed tightly in memory (e.g. there are no padding
        bytes).

    SG_UNIFORMLAYOUT_STD140
        The memory layout is a subset of std140. Arrays are only
        allowed for the FLOAT4, INT4 and MAT4. Alignment is as
        is as follows:

            FLOAT, INT:         4 byte alignment
            FLOAT2, INT2:       8 byte alignment
            FLOAT3, INT3:       16 byte alignment(!)
            FLOAT4, INT4:       16 byte alignment
            MAT4:               16 byte alignment
            FLOAT4[], INT4[]:   16 byte alignment

        The overall size of the uniform block must be a multiple
        of 16.

    For more information search for 'UNIFORM DATA LAYOUT' in the documentation block
    at the start of the header.
*/
typedef enum sg_uniform_layout {
    _SG_UNIFORMLAYOUT_DEFAULT,     // value 0 reserved for default-init
    SG_UNIFORMLAYOUT_NATIVE,       // default: layout depends on currently active backend
    SG_UNIFORMLAYOUT_STD140,       // std140: memory layout according to std140
    _SG_UNIFORMLAYOUT_NUM,
    _SG_UNIFORMLAYOUT_FORCE_U32 = 0x7FFFFFFF
} sg_uniform_layout;

/*
    sg_cull_mode

    The face-culling mode, this is used in the
    sg_pipeline_desc.cull_mode member when creating a
    pipeline object.

    The default cull mode is SG_CULLMODE_NONE
*/
typedef enum sg_cull_mode {
    _SG_CULLMODE_DEFAULT,   // value 0 reserved for default-init
    SG_CULLMODE_NONE,
    SG_CULLMODE_FRONT,
    SG_CULLMODE_BACK,
    _SG_CULLMODE_NUM,
    _SG_CULLMODE_FORCE_U32 = 0x7FFFFFFF
} sg_cull_mode;

/*
    sg_face_winding

    The vertex-winding rule that determines a front-facing primitive. This
    is used in the member sg_pipeline_desc.face_winding
    when creating a pipeline object.

    The default winding is SG_FACEWINDING_CW (clockwise)
*/
typedef enum sg_face_winding {
    _SG_FACEWINDING_DEFAULT,    // value 0 reserved for default-init
    SG_FACEWINDING_CCW,
    SG_FACEWINDING_CW,
    _SG_FACEWINDING_NUM,
    _SG_FACEWINDING_FORCE_U32 = 0x7FFFFFFF
} sg_face_winding;

/*
    sg_compare_func

    The compare-function for configuring depth- and stencil-ref tests
    in pipeline objects, and for texture samplers which perform a comparison
    instead of regular sampling operation.

    sg_pipeline_desc
        .depth
            .compare
        .stencil
            .front.compare
            .back.compar

    sg_sampler_desc
        .compare

    The default compare func for depth- and stencil-tests is
    SG_COMPAREFUNC_ALWAYS.

    The default compare func for sampler is SG_COMPAREFUNC_NEVER.
*/
typedef enum sg_compare_func {
    _SG_COMPAREFUNC_DEFAULT,    // value 0 reserved for default-init
    SG_COMPAREFUNC_NEVER,
    SG_COMPAREFUNC_LESS,
    SG_COMPAREFUNC_EQUAL,
    SG_COMPAREFUNC_LESS_EQUAL,
    SG_COMPAREFUNC_GREATER,
    SG_COMPAREFUNC_NOT_EQUAL,
    SG_COMPAREFUNC_GREATER_EQUAL,
    SG_COMPAREFUNC_ALWAYS,
    _SG_COMPAREFUNC_NUM,
    _SG_COMPAREFUNC_FORCE_U32 = 0x7FFFFFFF
} sg_compare_func;

/*
    sg_stencil_op

    The operation performed on a currently stored stencil-value when a
    comparison test passes or fails. This is used when creating a pipeline
    object in the members:

    sg_pipeline_desc
        .stencil
            .front
                .fail_op
                .depth_fail_op
                .pass_op
            .back
                .fail_op
                .depth_fail_op
                .pass_op

    The default value is SG_STENCILOP_KEEP.
*/
typedef enum sg_stencil_op {
    _SG_STENCILOP_DEFAULT,      // value 0 reserved for default-init
    SG_STENCILOP_KEEP,
    SG_STENCILOP_ZERO,
    SG_STENCILOP_REPLACE,
    SG_STENCILOP_INCR_CLAMP,
    SG_STENCILOP_DECR_CLAMP,
    SG_STENCILOP_INVERT,
    SG_STENCILOP_INCR_WRAP,
    SG_STENCILOP_DECR_WRAP,
    _SG_STENCILOP_NUM,
    _SG_STENCILOP_FORCE_U32 = 0x7FFFFFFF
} sg_stencil_op;

/*
    sg_blend_factor

    The source and destination factors in blending operations.
    This is used in the following members when creating a pipeline object:

    sg_pipeline_desc
        .colors[i]
            .blend
                .src_factor_rgb
                .dst_factor_rgb
                .src_factor_alpha
                .dst_factor_alpha

    The default value is SG_BLENDFACTOR_ONE for source
    factors, and SG_BLENDFACTOR_ZERO for destination factors.
*/
typedef enum sg_blend_factor {
    _SG_BLENDFACTOR_DEFAULT,    // value 0 reserved for default-init
    SG_BLENDFACTOR_ZERO,
    SG_BLENDFACTOR_ONE,
    SG_BLENDFACTOR_SRC_COLOR,
    SG_BLENDFACTOR_ONE_MINUS_SRC_COLOR,
    SG_BLENDFACTOR_SRC_ALPHA,
    SG_BLENDFACTOR_ONE_MINUS_SRC_ALPHA,
    SG_BLENDFACTOR_DST_COLOR,
    SG_BLENDFACTOR_ONE_MINUS_DST_COLOR,
    SG_BLENDFACTOR_DST_ALPHA,
    SG_BLENDFACTOR_ONE_MINUS_DST_ALPHA,
    SG_BLENDFACTOR_SRC_ALPHA_SATURATED,
    SG_BLENDFACTOR_BLEND_COLOR,
    SG_BLENDFACTOR_ONE_MINUS_BLEND_COLOR,
    SG_BLENDFACTOR_BLEND_ALPHA,
    SG_BLENDFACTOR_ONE_MINUS_BLEND_ALPHA,
    _SG_BLENDFACTOR_NUM,
    _SG_BLENDFACTOR_FORCE_U32 = 0x7FFFFFFF
} sg_blend_factor;

/*
    sg_blend_op

    Describes how the source and destination values are combined in the
    fragment blending operation. It is used in the following members when
    creating a pipeline object:

    sg_pipeline_desc
        .colors[i]
            .blend
                .op_rgb
                .op_alpha

    The default value is SG_BLENDOP_ADD.
*/
typedef enum sg_blend_op {
    _SG_BLENDOP_DEFAULT,    // value 0 reserved for default-init
    SG_BLENDOP_ADD,
    SG_BLENDOP_SUBTRACT,
    SG_BLENDOP_REVERSE_SUBTRACT,
    _SG_BLENDOP_NUM,
    _SG_BLENDOP_FORCE_U32 = 0x7FFFFFFF
} sg_blend_op;

/*
    sg_color_mask

    Selects the active color channels when writing a fragment color to the
    framebuffer. This is used in the members
    sg_pipeline_desc.colors[i].write_mask when creating a pipeline object.

    The default colormask is SG_COLORMASK_RGBA (write all colors channels)

    NOTE: since the color mask value 0 is reserved for the default value
    (SG_COLORMASK_RGBA), use SG_COLORMASK_NONE if all color channels
    should be disabled.
*/
typedef enum sg_color_mask {
    _SG_COLORMASK_DEFAULT = 0,    // value 0 reserved for default-init
    SG_COLORMASK_NONE   = 0x10,   // special value for 'all channels disabled
    SG_COLORMASK_R      = 0x1,
    SG_COLORMASK_G      = 0x2,
    SG_COLORMASK_RG     = 0x3,
    SG_COLORMASK_B      = 0x4,
    SG_COLORMASK_RB     = 0x5,
    SG_COLORMASK_GB     = 0x6,
    SG_COLORMASK_RGB    = 0x7,
    SG_COLORMASK_A      = 0x8,
    SG_COLORMASK_RA     = 0x9,
    SG_COLORMASK_GA     = 0xA,
    SG_COLORMASK_RGA    = 0xB,
    SG_COLORMASK_BA     = 0xC,
    SG_COLORMASK_RBA    = 0xD,
    SG_COLORMASK_GBA    = 0xE,
    SG_COLORMASK_RGBA   = 0xF,
    _SG_COLORMASK_FORCE_U32 = 0x7FFFFFFF
} sg_color_mask;

/*
    sg_load_action

    Defines the load action that should be performed at the start of a render pass:

    SG_LOADACTION_CLEAR:        clear the render target
    SG_LOADACTION_LOAD:         load the previous content of the render target
    SG_LOADACTION_DONTCARE:     leave the render target in an undefined state

    This is used in the sg_pass_action structure.

    The default load action for all pass attachments is SG_LOADACTION_CLEAR,
    with the values rgba = { 0.5f, 0.5f, 0.5f, 1.0f }, depth=1.0f and stencil=0.

    If you want to override the default behaviour, it is important to not
    only set the clear color, but the 'action' field as well (as long as this
    is _SG_LOADACTION_DEFAULT, the value fields will be ignored).
*/
typedef enum sg_load_action {
    _SG_LOADACTION_DEFAULT,
    SG_LOADACTION_CLEAR,
    SG_LOADACTION_LOAD,
    SG_LOADACTION_DONTCARE,
    _SG_LOADACTION_FORCE_U32 = 0x7FFFFFFF
} sg_load_action;

/*
    sg_store_action

    Defines the store action that be performed at the end of a render pass:

    SG_STOREACTION_STORE:       store the rendered content to the color attachment image
    SG_STOREACTION_DONTCARE:    allows the GPU to discard the rendered content
*/
typedef enum sg_store_action {
    _SG_STOREACTION_DEFAULT,
    SG_STOREACTION_STORE,
    SG_STOREACTION_DONTCARE,
    _SG_STOREACTION_FORCE_U32 = 0x7FFFFFFF
} sg_store_action;


/*
    sg_pass_action

    The sg_pass_action struct defines the actions to be performed
    at the start and end of a render pass.

    - at the start of the pass: whether the render targets should be cleared,
      loaded with their previous content, or start in an undefined state
    - for clear operations: the clear value (color, depth, or stencil values)
    - at the end of the pass: whether the rendering result should be
      stored back into the render target or discarded
*/
typedef struct sg_color_attachment_action {
    sg_load_action load_action;         // default: SG_LOADACTION_CLEAR
    sg_store_action store_action;       // default: SG_STOREACTION_STORE
    sg_color clear_value;               // default: { 0.5f, 0.5f, 0.5f, 1.0f }
} sg_color_attachment_action;

typedef struct sg_depth_attachment_action {
    sg_load_action load_action;         // default: SG_LOADACTION_CLEAR
    sg_store_action store_action;       // default: SG_STOREACTION_DONTCARE
    float clear_value;                  // default: 1.0
} sg_depth_attachment_action;

typedef struct sg_stencil_attachment_action {
    sg_load_action load_action;         // default: SG_LOADACTION_CLEAR
    sg_store_action store_action;       // default: SG_STOREACTION_DONTCARE
    uint8_t clear_value;                // default: 0
} sg_stencil_attachment_action;

typedef struct sg_pass_action {
    sg_color_attachment_action colors[SG_MAX_COLOR_ATTACHMENTS];
    sg_depth_attachment_action depth;
    sg_stencil_attachment_action stencil;
} sg_pass_action;

/*
    sg_swapchain

    Used in sg_begin_pass() to provide details about an external swapchain
    (pixel formats, sample count and backend-API specific render surface objects).

    The following information must be provided:

    - the width and height of the swapchain surfaces in number of pixels,
    - the pixel format of the render- and optional msaa-resolve-surface
    - the pixel format of the optional depth- or depth-stencil-surface
    - the MSAA sample count for the render and depth-stencil surface

    If the pixel formats and MSAA sample counts are left zero-initialized,
    their defaults are taken from the sg_environment struct provided in the
    sg_setup() call.

    The width and height *must* be > 0.

    Additionally the following backend API specific objects must be passed in
    as 'type erased' void pointers:

    GL: on all GL backends, a GL framebuffer object must be provided. This
    can be zero for the default framebuffer.

    D3D11:
        - an ID3D11RenderTargetView for the rendering surface, without
          MSAA rendering this surface will also be displayed
        - an optional ID3D11DepthStencilView for the depth- or depth/stencil
          buffer surface
        - when MSAA rendering is used, another ID3D11RenderTargetView
          which serves as MSAA resolve target and will be displayed

    WebGPU (same as D3D11, except different types)
        - a WGPUTextureView for the rendering surface, without
          MSAA rendering this surface will also be displayed
        - an optional WGPUTextureView for the depth- or depth/stencil
          buffer surface
        - when MSAA rendering is used, another WGPUTextureView
          which serves as MSAA resolve target and will be displayed

    Metal (NOTE that the rolves of provided surfaces is slightly different
    than on D3D11 or WebGPU in case of MSAA vs non-MSAA rendering):

        - A current CAMetalDrawable (NOT an MTLDrawable!) which will be presented.
          This will either be rendered to directly (if no MSAA is used), or serve
          as MSAA-resolve target.
        - an optional MTLTexture for the depth- or depth-stencil buffer
        - an optional multisampled MTLTexture which serves as intermediate
          rendering surface which will then be resolved into the
          CAMetalDrawable.

    NOTE that for Metal you must use an ObjC __bridge cast to
    properly tunnel the ObjC object handle through a C void*, e.g.:

        swapchain.metal.current_drawable = (__bridge const void*) [mtkView currentDrawable];

    On all other backends you shouldn't need to mess with the reference count.

    It's a good practice to write a helper function which returns an initialized
    sg_swapchain structs, which can then be plugged directly into
    sg_pass.swapchain. Look at the function sglue_swapchain() in the sokol_glue.h
    as an example.
*/
typedef struct sg_metal_swapchain {
    const void* current_drawable;       // CAMetalDrawable (NOT MTLDrawable!!!)
    const void* depth_stencil_texture;  // MTLTexture
    const void* msaa_color_texture;     // MTLTexture
} sg_metal_swapchain;

typedef struct sg_d3d11_swapchain {
    const void* render_view;            // ID3D11RenderTargetView
    const void* resolve_view;           // ID3D11RenderTargetView
    const void* depth_stencil_view;     // ID3D11DepthStencilView
} sg_d3d11_swapchain;

typedef struct sg_wgpu_swapchain {
    const void* render_view;            // WGPUTextureView
    const void* resolve_view;           // WGPUTextureView
    const void* depth_stencil_view;     // WGPUTextureView
} sg_wgpu_swapchain;

typedef struct sg_gl_swapchain {
    uint32_t framebuffer;               // GL framebuffer object
} sg_gl_swapchain;

typedef struct sg_swapchain {
    int width;
    int height;
    int sample_count;
    sg_pixel_format color_format;
    sg_pixel_format depth_format;
    sg_metal_swapchain metal;
    sg_d3d11_swapchain d3d11;
    sg_wgpu_swapchain wgpu;
    sg_gl_swapchain gl;
} sg_swapchain;

/*
    sg_pass

    The sg_pass structure is passed as argument into the sg_begin_pass()
    function.

    For an offscreen rendering pass, an sg_pass_action struct and sg_attachments
    object must be provided, and for swapchain passes, and sg_pass_action and
    an sg_swapchain struct. It is an error to provide both an sg_attachments
    handle and an initialized sg_swapchain struct in the same sg_begin_pass().

    An sg_begin_pass() call for an offscreen pass would look like this (where
    `attachments` is an sg_attachments handle):

        sg_begin_pass(&(sg_pass){
            .action = { ... },
            .attachments = attachments,
        });

    ...and a swapchain render pass would look like this (using the sokol_glue.h
    helper function sglue_swapchain() which gets the swapchain properties from
    sokol_app.h):

        sg_begin_pass(&(sg_pass){
            .action = { ... },
            .swapchain = sglue_swapchain(),
        });

    You can also omit the .action object to get default pass action behaviour
    (clear to color=grey, depth=1 and stencil=0).
*/
typedef struct sg_pass {
    uint32_t _start_canary;
    sg_pass_action action;
    sg_attachments attachments;
    sg_swapchain swapchain;
    const char* label;
    uint32_t _end_canary;
} sg_pass;

/*
    sg_bindings

    The sg_bindings structure defines the resource binding slots
    of the sokol_gfx render pipeline, used as argument to the
    sg_apply_bindings() function.

    A resource binding struct contains:

    - 1..N vertex buffers
    - 0..N vertex buffer offsets
    - 0..1 index buffers
    - 0..1 index buffer offsets
    - 0..N vertex shader stage images
    - 0..N vertex shader stage samplers
    - 0..N vertex shader storage buffers
    - 0..N fragment shader stage images
    - 0..N fragment shader stage samplers
    - 0..N fragment shader storage buffers

    For the max number of bindings, see the constant definitions:

    - SG_MAX_VERTEX_BUFFERS
    - SG_MAX_SHADERSTAGE_IMAGES
    - SG_MAX_SHADERSTAGE_SAMPLERS
    - SG_MAX_SHADERSTAGE_STORAGEBUFFERS

    The optional buffer offsets can be used to put different unrelated
    chunks of vertex- and/or index-data into the same buffer objects.
*/
typedef struct sg_stage_bindings {
    sg_image images[SG_MAX_SHADERSTAGE_IMAGES];
    sg_sampler samplers[SG_MAX_SHADERSTAGE_SAMPLERS];
    sg_buffer storage_buffers[SG_MAX_SHADERSTAGE_STORAGEBUFFERS];
} sg_stage_bindings;

typedef struct sg_bindings {
    uint32_t _start_canary;
    sg_buffer vertex_buffers[SG_MAX_VERTEX_BUFFERS];
    int vertex_buffer_offsets[SG_MAX_VERTEX_BUFFERS];
    sg_buffer index_buffer;
    int index_buffer_offset;
    sg_stage_bindings vs;
    sg_stage_bindings fs;
    uint32_t _end_canary;
} sg_bindings;

/*
    sg_buffer_desc

    Creation parameters for sg_buffer objects, used in the
    sg_make_buffer() call.

    The default configuration is:

    .size:      0       (*must* be >0 for buffers without data)
    .type:      SG_BUFFERTYPE_VERTEXBUFFER
    .usage:     SG_USAGE_IMMUTABLE
    .data.ptr   0       (*must* be valid for immutable buffers)
    .data.size  0       (*must* be > 0 for immutable buffers)
    .label      0       (optional string label)

    For immutable buffers which are initialized with initial data,
    keep the .size item zero-initialized, and set the size together with the
    pointer to the initial data in the .data item.

    For mutable buffers without initial data, keep the .data item
    zero-initialized, and set the buffer size in the .size item instead.

    You can also set both size values, but currently both size values must
    be identical (this may change in the future when the dynamic resource
    management may become more flexible).

    ADVANCED TOPIC: Injecting native 3D-API buffers:

    The following struct members allow to inject your own GL, Metal
    or D3D11 buffers into sokol_gfx:

    .gl_buffers[SG_NUM_INFLIGHT_FRAMES]
    .mtl_buffers[SG_NUM_INFLIGHT_FRAMES]
    .d3d11_buffer

    You must still provide all other struct items except the .data item, and
    these must match the creation parameters of the native buffers you
    provide. For SG_USAGE_IMMUTABLE, only provide a single native 3D-API
    buffer, otherwise you need to provide SG_NUM_INFLIGHT_FRAMES buffers
    (only for GL and Metal, not D3D11). Providing multiple buffers for GL and
    Metal is necessary because sokol_gfx will rotate through them when
    calling sg_update_buffer() to prevent lock-stalls.

    Note that it is expected that immutable injected buffer have already been
    initialized with content, and the .content member must be 0!

    Also you need to call sg_reset_state_cache() after calling native 3D-API
    functions, and before calling any sokol_gfx function.
*/
typedef struct sg_buffer_desc {
    uint32_t _start_canary;
    size_t size;
    sg_buffer_type type;
    sg_usage usage;
    sg_range data;
    const char* label;
    // optionally inject backend-specific resources
    uint32_t gl_buffers[SG_NUM_INFLIGHT_FRAMES];
    const void* mtl_buffers[SG_NUM_INFLIGHT_FRAMES];
    const void* d3d11_buffer;
    const void* wgpu_buffer;
    uint32_t _end_canary;
} sg_buffer_desc;

/*
    sg_image_data

    Defines the content of an image through a 2D array of sg_range structs.
    The first array dimension is the cubemap face, and the second array
    dimension the mipmap level.
*/
typedef struct sg_image_data {
    sg_range subimage[SG_CUBEFACE_NUM][SG_MAX_MIPMAPS];
} sg_image_data;

/*
    sg_image_desc

    Creation parameters for sg_image objects, used in the sg_make_image() call.

    The default configuration is:

    .type:              SG_IMAGETYPE_2D
    .render_target:     false
    .width              0 (must be set to >0)
    .height             0 (must be set to >0)
    .num_slices         1 (3D textures: depth; array textures: number of layers)
    .num_mipmaps:       1
    .usage:             SG_USAGE_IMMUTABLE
    .pixel_format:      SG_PIXELFORMAT_RGBA8 for textures, or sg_desc.environment.defaults.color_format for render targets
    .sample_count:      1 for textures, or sg_desc.environment.defaults.sample_count for render targets
    .data               an sg_image_data struct to define the initial content
    .label              0 (optional string label for trace hooks)

    Q: Why is the default sample_count for render targets identical with the
    "default sample count" from sg_desc.environment.defaults.sample_count?

    A: So that it matches the default sample count in pipeline objects. Even
    though it is a bit strange/confusing that offscreen render targets by default
    get the same sample count as 'default swapchains', but it's better that
    an offscreen render target created with default parameters matches
    a pipeline object created with default parameters.

    NOTE:

    Images with usage SG_USAGE_IMMUTABLE must be fully initialized by
    providing a valid .data member which points to initialization data.

    ADVANCED TOPIC: Injecting native 3D-API textures:

    The following struct members allow to inject your own GL, Metal or D3D11
    textures into sokol_gfx:

    .gl_textures[SG_NUM_INFLIGHT_FRAMES]
    .mtl_textures[SG_NUM_INFLIGHT_FRAMES]
    .d3d11_texture
    .d3d11_shader_resource_view
    .wgpu_texture
    .wgpu_texture_view

    For GL, you can also specify the texture target or leave it empty to use
    the default texture target for the image type (GL_TEXTURE_2D for
    SG_IMAGETYPE_2D etc)

    For D3D11 and WebGPU, either only provide a texture, or both a texture and
    shader-resource-view / texture-view object. If you want to use access the
    injected texture in a shader you *must* provide a shader-resource-view.

    The same rules apply as for injecting native buffers (see sg_buffer_desc
    documentation for more details).
*/
typedef struct sg_image_desc {
    uint32_t _start_canary;
    sg_image_type type;
    bool render_target;
    int width;
    int height;
    int num_slices;
    int num_mipmaps;
    sg_usage usage;
    sg_pixel_format pixel_format;
    int sample_count;
    sg_image_data data;
    const char* label;
    // optionally inject backend-specific resources
    uint32_t gl_textures[SG_NUM_INFLIGHT_FRAMES];
    uint32_t gl_texture_target;
    const void* mtl_textures[SG_NUM_INFLIGHT_FRAMES];
    const void* d3d11_texture;
    const void* d3d11_shader_resource_view;
    const void* wgpu_texture;
    const void* wgpu_texture_view;
    uint32_t _end_canary;
} sg_image_desc;

/*
    sg_sampler_desc

    Creation parameters for sg_sampler objects, used in the sg_make_sampler() call

    .min_filter:        SG_FILTER_NEAREST
    .mag_filter:        SG_FILTER_NEAREST
    .mipmap_filter      SG_FILTER_NEAREST
    .wrap_u:            SG_WRAP_REPEAT
    .wrap_v:            SG_WRAP_REPEAT
    .wrap_w:            SG_WRAP_REPEAT (only SG_IMAGETYPE_3D)
    .min_lod            0.0f
    .max_lod            FLT_MAX
    .border_color       SG_BORDERCOLOR_OPAQUE_BLACK
    .compare            SG_COMPAREFUNC_NEVER
    .max_anisotropy     1 (must be 1..16)

*/
typedef struct sg_sampler_desc {
    uint32_t _start_canary;
    sg_filter min_filter;
    sg_filter mag_filter;
    sg_filter mipmap_filter;
    sg_wrap wrap_u;
    sg_wrap wrap_v;
    sg_wrap wrap_w;
    float min_lod;
    float max_lod;
    sg_border_color border_color;
    sg_compare_func compare;
    uint32_t max_anisotropy;
    const char* label;
    // optionally inject backend-specific resources
    uint32_t gl_sampler;
    const void* mtl_sampler;
    const void* d3d11_sampler;
    const void* wgpu_sampler;
    uint32_t _end_canary;
} sg_sampler_desc;

/*
    sg_shader_desc

    The structure sg_shader_desc defines all creation parameters for shader
    programs, used as input to the sg_make_shader() function:

    - reflection information for vertex attributes (vertex shader inputs):
        - vertex attribute name (only optionally used by GLES3 and GL)
        - a semantic name and index (required for D3D11)
    - for each shader-stage (vertex and fragment):
        - the shader source or bytecode
        - an optional entry function name
        - an optional compile target (only for D3D11 when source is provided,
          defaults are "vs_4_0" and "ps_4_0")
        - reflection info for each uniform block used by the shader stage:
            - the size of the uniform block in bytes
            - a memory layout hint (native vs std140, only required for GL backends)
            - reflection info for each uniform block member (only required for GL backends):
                - member name
                - member type (SG_UNIFORMTYPE_xxx)
                - if the member is an array, the number of array items
        - reflection info for textures used in the shader stage:
            - the image type (SG_IMAGETYPE_xxx)
            - the image-sample type (SG_IMAGESAMPLETYPE_xxx, default is SG_IMAGESAMPLETYPE_FLOAT)
            - whether the shader expects a multisampled texture
        - reflection info for samplers used in the shader stage:
            - the sampler type (SG_SAMPLERTYPE_xxx)
        - reflection info for each image-sampler-pair used by the shader:
            - the texture slot of the involved texture
            - the sampler slot of the involved sampler
            - for GLSL only: the name of the combined image-sampler object
        - reflection info for each storage-buffer used by the shader:
            - whether the storage buffer is readonly (currently this
              must be true)

    For all GL backends, shader source-code must be provided. For D3D11 and Metal,
    either shader source-code or byte-code can be provided.

    For D3D11, if source code is provided, the d3dcompiler_47.dll will be loaded
    on demand. If this fails, shader creation will fail. When compiling HLSL
    source code, you can provide an optional target string via
    sg_shader_stage_desc.d3d11_target, the default target is "vs_4_0" for the
    vertex shader stage and "ps_4_0" for the pixel shader stage.
*/
typedef struct sg_shader_attr_desc {
    const char* name;           // GLSL vertex attribute name (optional)
    const char* sem_name;       // HLSL semantic name
    int sem_index;              // HLSL semantic index
} sg_shader_attr_desc;

typedef struct sg_shader_uniform_desc {
    const char* name;
    sg_uniform_type type;
    int array_count;
} sg_shader_uniform_desc;

typedef struct sg_shader_uniform_block_desc {
    size_t size;
    sg_uniform_layout layout;
    sg_shader_uniform_desc uniforms[SG_MAX_UB_MEMBERS];
} sg_shader_uniform_block_desc;

typedef struct sg_shader_storage_buffer_desc {
    bool used;
    bool readonly;
} sg_shader_storage_buffer_desc;

typedef struct sg_shader_image_desc {
    bool used;
    bool multisampled;
    sg_image_type image_type;
    sg_image_sample_type sample_type;
} sg_shader_image_desc;

typedef struct sg_shader_sampler_desc {
    bool used;
    sg_sampler_type sampler_type;
} sg_shader_sampler_desc;

typedef struct sg_shader_image_sampler_pair_desc {
    bool used;
    int image_slot;
    int sampler_slot;
    const char* glsl_name;
} sg_shader_image_sampler_pair_desc;

typedef struct sg_shader_stage_desc {
    const char* source;
    sg_range bytecode;
    const char* entry;
    const char* d3d11_target;
    sg_shader_uniform_block_desc uniform_blocks[SG_MAX_SHADERSTAGE_UBS];
    sg_shader_storage_buffer_desc storage_buffers[SG_MAX_SHADERSTAGE_STORAGEBUFFERS];
    sg_shader_image_desc images[SG_MAX_SHADERSTAGE_IMAGES];
    sg_shader_sampler_desc samplers[SG_MAX_SHADERSTAGE_SAMPLERS];
    sg_shader_image_sampler_pair_desc image_sampler_pairs[SG_MAX_SHADERSTAGE_IMAGESAMPLERPAIRS];
} sg_shader_stage_desc;

typedef struct sg_shader_desc {
    uint32_t _start_canary;
    sg_shader_attr_desc attrs[SG_MAX_VERTEX_ATTRIBUTES];
    sg_shader_stage_desc vs;
    sg_shader_stage_desc fs;
    const char* label;
    uint32_t _end_canary;
} sg_shader_desc;

/*
    sg_pipeline_desc

    The sg_pipeline_desc struct defines all creation parameters for an
    sg_pipeline object, used as argument to the sg_make_pipeline() function:

    - the vertex layout for all input vertex buffers
    - a shader object
    - the 3D primitive type (points, lines, triangles, ...)
    - the index type (none, 16- or 32-bit)
    - all the fixed-function-pipeline state (depth-, stencil-, blend-state, etc...)

    If the vertex data has no gaps between vertex components, you can omit
    the .layout.buffers[].stride and layout.attrs[].offset items (leave them
    default-initialized to 0), sokol-gfx will then compute the offsets and
    strides from the vertex component formats (.layout.attrs[].format).
    Please note that ALL vertex attribute offsets must be 0 in order for the
    automatic offset computation to kick in.

    The default configuration is as follows:

    .shader:            0 (must be initialized with a valid sg_shader id!)
    .layout:
        .buffers[]:         vertex buffer layouts
            .stride:        0 (if no stride is given it will be computed)
            .step_func      SG_VERTEXSTEP_PER_VERTEX
            .step_rate      1
        .attrs[]:           vertex attribute declarations
            .buffer_index   0 the vertex buffer bind slot
            .offset         0 (offsets can be omitted if the vertex layout has no gaps)
            .format         SG_VERTEXFORMAT_INVALID (must be initialized!)
    .depth:
        .pixel_format:      sg_desc.context.depth_format
        .compare:           SG_COMPAREFUNC_ALWAYS
        .write_enabled:     false
        .bias:              0.0f
        .bias_slope_scale:  0.0f
        .bias_clamp:        0.0f
    .stencil:
        .enabled:           false
        .front/back:
            .compare:       SG_COMPAREFUNC_ALWAYS
            .fail_op:       SG_STENCILOP_KEEP
            .depth_fail_op: SG_STENCILOP_KEEP
            .pass_op:       SG_STENCILOP_KEEP
        .read_mask:         0
        .write_mask:        0
        .ref:               0
    .color_count            1
    .colors[0..color_count]
        .pixel_format       sg_desc.context.color_format
        .write_mask:        SG_COLORMASK_RGBA
        .blend:
            .enabled:           false
            .src_factor_rgb:    SG_BLENDFACTOR_ONE
            .dst_factor_rgb:    SG_BLENDFACTOR_ZERO
            .op_rgb:            SG_BLENDOP_ADD
            .src_factor_alpha:  SG_BLENDFACTOR_ONE
            .dst_factor_alpha:  SG_BLENDFACTOR_ZERO
            .op_alpha:          SG_BLENDOP_ADD
    .primitive_type:            SG_PRIMITIVETYPE_TRIANGLES
    .index_type:                SG_INDEXTYPE_NONE
    .cull_mode:                 SG_CULLMODE_NONE
    .face_winding:              SG_FACEWINDING_CW
    .sample_count:              sg_desc.context.sample_count
    .blend_color:               (sg_color) { 0.0f, 0.0f, 0.0f, 0.0f }
    .alpha_to_coverage_enabled: false
    .label  0       (optional string label for trace hooks)
*/
typedef struct sg_vertex_buffer_layout_state {
    int stride;
    sg_vertex_step step_func;
    int step_rate;
} sg_vertex_buffer_layout_state;

typedef struct sg_vertex_attr_state {
    int buffer_index;
    int offset;
    sg_vertex_format format;
} sg_vertex_attr_state;

typedef struct sg_vertex_layout_state {
    sg_vertex_buffer_layout_state buffers[SG_MAX_VERTEX_BUFFERS];
    sg_vertex_attr_state attrs[SG_MAX_VERTEX_ATTRIBUTES];
} sg_vertex_layout_state;

typedef struct sg_stencil_face_state {
    sg_compare_func compare;
    sg_stencil_op fail_op;
    sg_stencil_op depth_fail_op;
    sg_stencil_op pass_op;
} sg_stencil_face_state;

typedef struct sg_stencil_state {
    bool enabled;
    sg_stencil_face_state front;
    sg_stencil_face_state back;
    uint8_t read_mask;
    uint8_t write_mask;
    uint8_t ref;
} sg_stencil_state;

typedef struct sg_depth_state {
    sg_pixel_format pixel_format;
    sg_compare_func compare;
    bool write_enabled;
    float bias;
    float bias_slope_scale;
    float bias_clamp;
} sg_depth_state;

typedef struct sg_blend_state {
    bool enabled;
    sg_blend_factor src_factor_rgb;
    sg_blend_factor dst_factor_rgb;
    sg_blend_op op_rgb;
    sg_blend_factor src_factor_alpha;
    sg_blend_factor dst_factor_alpha;
    sg_blend_op op_alpha;
} sg_blend_state;

typedef struct sg_color_target_state {
    sg_pixel_format pixel_format;
    sg_color_mask write_mask;
    sg_blend_state blend;
} sg_color_target_state;

typedef struct sg_pipeline_desc {
    uint32_t _start_canary;
    sg_shader shader;
    sg_vertex_layout_state layout;
    sg_depth_state depth;
    sg_stencil_state stencil;
    int color_count;
    sg_color_target_state colors[SG_MAX_COLOR_ATTACHMENTS];
    sg_primitive_type primitive_type;
    sg_index_type index_type;
    sg_cull_mode cull_mode;
    sg_face_winding face_winding;
    int sample_count;
    sg_color blend_color;
    bool alpha_to_coverage_enabled;
    const char* label;
    uint32_t _end_canary;
} sg_pipeline_desc;

/*
    sg_attachments_desc

    Creation parameters for an sg_attachments object, used as argument to the
    sg_make_attachments() function.

    An attachments object bundles 0..4 color attachments, 0..4 msaa-resolve
    attachments, and none or one depth-stencil attachmente for use
    in a render pass. At least one color attachment or one depth-stencil
    attachment must be provided (no color attachment and a depth-stencil
    attachment is useful for a depth-only render pass).

    Each attachment definition consists of an image object, and two additional indices
    describing which subimage the pass will render into: one mipmap index, and if the image
    is a cubemap, array-texture or 3D-texture, the face-index, array-layer or
    depth-slice.

    All attachments must have the same width and height.

    All color attachments and the depth-stencil attachment must have the
    same sample count.

    If a resolve attachment is set, an MSAA-resolve operation from the
    associated color attachment image into the resolve attachment image will take
    place in the sg_end_pass() function. In this case, the color attachment
    must have a (sample_count>1), and the resolve attachment a
    (sample_count==1). The resolve attachment also must have the same pixel
    format as the color attachment.

    NOTE that MSAA depth-stencil attachments cannot be msaa-resolved!
*/
typedef struct sg_attachment_desc {
    sg_image image;
    int mip_level;
    int slice;      // cube texture: face; array texture: layer; 3D texture: slice
} sg_attachment_desc;

typedef struct sg_attachments_desc {
    uint32_t _start_canary;
    sg_attachment_desc colors[SG_MAX_COLOR_ATTACHMENTS];
    sg_attachment_desc resolves[SG_MAX_COLOR_ATTACHMENTS];
    sg_attachment_desc depth_stencil;
    const char* label;
    uint32_t _end_canary;
} sg_attachments_desc;

/*
    sg_trace_hooks

    Installable callback functions to keep track of the sokol-gfx calls,
    this is useful for debugging, or keeping track of resource creation
    and destruction.

    Trace hooks are installed with sg_install_trace_hooks(), this returns
    another sg_trace_hooks struct with the previous set of
    trace hook function pointers. These should be invoked by the
    new trace hooks to form a proper call chain.
*/
typedef struct sg_trace_hooks {
    void* user_data;
    void (*reset_state_cache)(void* user_data);
    void (*make_buffer)(const sg_buffer_desc* desc, sg_buffer result, void* user_data);
    void (*make_image)(const sg_image_desc* desc, sg_image result, void* user_data);
    void (*make_sampler)(const sg_sampler_desc* desc, sg_sampler result, void* user_data);
    void (*make_shader)(const sg_shader_desc* desc, sg_shader result, void* user_data);
    void (*make_pipeline)(const sg_pipeline_desc* desc, sg_pipeline result, void* user_data);
    void (*make_attachments)(const sg_attachments_desc* desc, sg_attachments result, void* user_data);
    void (*destroy_buffer)(sg_buffer buf, void* user_data);
    void (*destroy_image)(sg_image img, void* user_data);
    void (*destroy_sampler)(sg_sampler smp, void* user_data);
    void (*destroy_shader)(sg_shader shd, void* user_data);
    void (*destroy_pipeline)(sg_pipeline pip, void* user_data);
    void (*destroy_attachments)(sg_attachments atts, void* user_data);
    void (*update_buffer)(sg_buffer buf, const sg_range* data, void* user_data);
    void (*update_image)(sg_image img, const sg_image_data* data, void* user_data);
    void (*append_buffer)(sg_buffer buf, const sg_range* data, int result, void* user_data);
    void (*begin_pass)(const sg_pass* pass, void* user_data);
    void (*apply_viewport)(int x, int y, int width, int height, bool origin_top_left, void* user_data);
    void (*apply_scissor_rect)(int x, int y, int width, int height, bool origin_top_left, void* user_data);
    void (*apply_pipeline)(sg_pipeline pip, void* user_data);
    void (*apply_bindings)(const sg_bindings* bindings, void* user_data);
    void (*apply_uniforms)(sg_shader_stage stage, int ub_index, const sg_range* data, void* user_data);
    void (*draw)(int base_element, int num_elements, int num_instances, void* user_data);
    void (*end_pass)(void* user_data);
    void (*commit)(void* user_data);
    void (*alloc_buffer)(sg_buffer result, void* user_data);
    void (*alloc_image)(sg_image result, void* user_data);
    void (*alloc_sampler)(sg_sampler result, void* user_data);
    void (*alloc_shader)(sg_shader result, void* user_data);
    void (*alloc_pipeline)(sg_pipeline result, void* user_data);
    void (*alloc_attachments)(sg_attachments result, void* user_data);
    void (*dealloc_buffer)(sg_buffer buf_id, void* user_data);
    void (*dealloc_image)(sg_image img_id, void* user_data);
    void (*dealloc_sampler)(sg_sampler smp_id, void* user_data);
    void (*dealloc_shader)(sg_shader shd_id, void* user_data);
    void (*dealloc_pipeline)(sg_pipeline pip_id, void* user_data);
    void (*dealloc_attachments)(sg_attachments atts_id, void* user_data);
    void (*init_buffer)(sg_buffer buf_id, const sg_buffer_desc* desc, void* user_data);
    void (*init_image)(sg_image img_id, const sg_image_desc* desc, void* user_data);
    void (*init_sampler)(sg_sampler smp_id, const sg_sampler_desc* desc, void* user_data);
    void (*init_shader)(sg_shader shd_id, const sg_shader_desc* desc, void* user_data);
    void (*init_pipeline)(sg_pipeline pip_id, const sg_pipeline_desc* desc, void* user_data);
    void (*init_attachments)(sg_attachments atts_id, const sg_attachments_desc* desc, void* user_data);
    void (*uninit_buffer)(sg_buffer buf_id, void* user_data);
    void (*uninit_image)(sg_image img_id, void* user_data);
    void (*uninit_sampler)(sg_sampler smp_id, void* user_data);
    void (*uninit_shader)(sg_shader shd_id, void* user_data);
    void (*uninit_pipeline)(sg_pipeline pip_id, void* user_data);
    void (*uninit_attachments)(sg_attachments atts_id, void* user_data);
    void (*fail_buffer)(sg_buffer buf_id, void* user_data);
    void (*fail_image)(sg_image img_id, void* user_data);
    void (*fail_sampler)(sg_sampler smp_id, void* user_data);
    void (*fail_shader)(sg_shader shd_id, void* user_data);
    void (*fail_pipeline)(sg_pipeline pip_id, void* user_data);
    void (*fail_attachments)(sg_attachments atts_id, void* user_data);
    void (*push_debug_group)(const char* name, void* user_data);
    void (*pop_debug_group)(void* user_data);
} sg_trace_hooks;

/*
    sg_buffer_info
    sg_image_info
    sg_sampler_info
    sg_shader_info
    sg_pipeline_info
    sg_attachments_info

    These structs contain various internal resource attributes which
    might be useful for debug-inspection. Please don't rely on the
    actual content of those structs too much, as they are quite closely
    tied to sokol_gfx.h internals and may change more frequently than
    the other public API elements.

    The *_info structs are used as the return values of the following functions:

    sg_query_buffer_info()
    sg_query_image_info()
    sg_query_sampler_info()
    sg_query_shader_info()
    sg_query_pipeline_info()
    sg_query_pass_info()
*/
typedef struct sg_slot_info {
    sg_resource_state state;    // the current state of this resource slot
    uint32_t res_id;            // type-neutral resource if (e.g. sg_buffer.id)
} sg_slot_info;

typedef struct sg_buffer_info {
    sg_slot_info slot;              // resource pool slot info
    uint32_t update_frame_index;    // frame index of last sg_update_buffer()
    uint32_t append_frame_index;    // frame index of last sg_append_buffer()
    int append_pos;                 // current position in buffer for sg_append_buffer()
    bool append_overflow;           // is buffer in overflow state (due to sg_append_buffer)
    int num_slots;                  // number of renaming-slots for dynamically updated buffers
    int active_slot;                // currently active write-slot for dynamically updated buffers
} sg_buffer_info;

typedef struct sg_image_info {
    sg_slot_info slot;              // resource pool slot info
    uint32_t upd_frame_index;       // frame index of last sg_update_image()
    int num_slots;                  // number of renaming-slots for dynamically updated images
    int active_slot;                // currently active write-slot for dynamically updated images
} sg_image_info;

typedef struct sg_sampler_info {
    sg_slot_info slot;              // resource pool slot info
} sg_sampler_info;

typedef struct sg_shader_info {
    sg_slot_info slot;              // resource pool slot info
} sg_shader_info;

typedef struct sg_pipeline_info {
    sg_slot_info slot;              // resource pool slot info
} sg_pipeline_info;

typedef struct sg_attachments_info {
    sg_slot_info slot;              // resource pool slot info
} sg_attachments_info;

/*
    sg_frame_stats

    Allows to track generic and backend-specific stats about a
    render frame. Obtained by calling sg_query_frame_stats(). The returned
    struct contains information about the *previous* frame.
*/
typedef struct sg_frame_stats_gl {
    uint32_t num_bind_buffer;
    uint32_t num_active_texture;
    uint32_t num_bind_texture;
    uint32_t num_bind_sampler;
    uint32_t num_use_program;
    uint32_t num_render_state;
    uint32_t num_vertex_attrib_pointer;
    uint32_t num_vertex_attrib_divisor;
    uint32_t num_enable_vertex_attrib_array;
    uint32_t num_disable_vertex_attrib_array;
    uint32_t num_uniform;
} sg_frame_stats_gl;

typedef struct sg_frame_stats_d3d11_pass {
    uint32_t num_om_set_render_targets;
    uint32_t num_clear_render_target_view;
    uint32_t num_clear_depth_stencil_view;
    uint32_t num_resolve_subresource;
} sg_frame_stats_d3d11_pass;

typedef struct sg_frame_stats_d3d11_pipeline {
    uint32_t num_rs_set_state;
    uint32_t num_om_set_depth_stencil_state;
    uint32_t num_om_set_blend_state;
    uint32_t num_ia_set_primitive_topology;
    uint32_t num_ia_set_input_layout;
    uint32_t num_vs_set_shader;
    uint32_t num_vs_set_constant_buffers;
    uint32_t num_ps_set_shader;
    uint32_t num_ps_set_constant_buffers;
} sg_frame_stats_d3d11_pipeline;

typedef struct sg_frame_stats_d3d11_bindings {
    uint32_t num_ia_set_vertex_buffers;
    uint32_t num_ia_set_index_buffer;
    uint32_t num_vs_set_shader_resources;
    uint32_t num_ps_set_shader_resources;
    uint32_t num_vs_set_samplers;
    uint32_t num_ps_set_samplers;
} sg_frame_stats_d3d11_bindings;

typedef struct sg_frame_stats_d3d11_uniforms {
    uint32_t num_update_subresource;
} sg_frame_stats_d3d11_uniforms;

typedef struct sg_frame_stats_d3d11_draw {
    uint32_t num_draw_indexed_instanced;
    uint32_t num_draw_indexed;
    uint32_t num_draw_instanced;
    uint32_t num_draw;
} sg_frame_stats_d3d11_draw;

typedef struct sg_frame_stats_d3d11 {
    sg_frame_stats_d3d11_pass pass;
    sg_frame_stats_d3d11_pipeline pipeline;
    sg_frame_stats_d3d11_bindings bindings;
    sg_frame_stats_d3d11_uniforms uniforms;
    sg_frame_stats_d3d11_draw draw;
    uint32_t num_map;
    uint32_t num_unmap;
} sg_frame_stats_d3d11;

typedef struct sg_frame_stats_metal_idpool {
    uint32_t num_added;
    uint32_t num_released;
    uint32_t num_garbage_collected;
} sg_frame_stats_metal_idpool;

typedef struct sg_frame_stats_metal_pipeline {
    uint32_t num_set_blend_color;
    uint32_t num_set_cull_mode;
    uint32_t num_set_front_facing_winding;
    uint32_t num_set_stencil_reference_value;
    uint32_t num_set_depth_bias;
    uint32_t num_set_render_pipeline_state;
    uint32_t num_set_depth_stencil_state;
} sg_frame_stats_metal_pipeline;

typedef struct sg_frame_stats_metal_bindings {
    uint32_t num_set_vertex_buffer;
    uint32_t num_set_vertex_texture;
    uint32_t num_set_vertex_sampler_state;
    uint32_t num_set_fragment_buffer;
    uint32_t num_set_fragment_texture;
    uint32_t num_set_fragment_sampler_state;
} sg_frame_stats_metal_bindings;

typedef struct sg_frame_stats_metal_uniforms {
    uint32_t num_set_vertex_buffer_offset;
    uint32_t num_set_fragment_buffer_offset;
} sg_frame_stats_metal_uniforms;

typedef struct sg_frame_stats_metal {
    sg_frame_stats_metal_idpool idpool;
    sg_frame_stats_metal_pipeline pipeline;
    sg_frame_stats_metal_bindings bindings;
    sg_frame_stats_metal_uniforms uniforms;
} sg_frame_stats_metal;

typedef struct sg_frame_stats_wgpu_uniforms {
    uint32_t num_set_bindgroup;
    uint32_t size_write_buffer;
} sg_frame_stats_wgpu_uniforms;

typedef struct sg_frame_stats_wgpu_bindings {
    uint32_t num_set_vertex_buffer;
    uint32_t num_skip_redundant_vertex_buffer;
    uint32_t num_set_index_buffer;
    uint32_t num_skip_redundant_index_buffer;
    uint32_t num_create_bindgroup;
    uint32_t num_discard_bindgroup;
    uint32_t num_set_bindgroup;
    uint32_t num_skip_redundant_bindgroup;
    uint32_t num_bindgroup_cache_hits;
    uint32_t num_bindgroup_cache_misses;
    uint32_t num_bindgroup_cache_collisions;
    uint32_t num_bindgroup_cache_invalidates;
    uint32_t num_bindgroup_cache_hash_vs_key_mismatch;
} sg_frame_stats_wgpu_bindings;

typedef struct sg_frame_stats_wgpu {
    sg_frame_stats_wgpu_uniforms uniforms;
    sg_frame_stats_wgpu_bindings bindings;
} sg_frame_stats_wgpu;

typedef struct sg_frame_stats {
    uint32_t frame_index;   // current frame counter, starts at 0

    uint32_t num_passes;
    uint32_t num_apply_viewport;
    uint32_t num_apply_scissor_rect;
    uint32_t num_apply_pipeline;
    uint32_t num_apply_bindings;
    uint32_t num_apply_uniforms;
    uint32_t num_draw;
    uint32_t num_update_buffer;
    uint32_t num_append_buffer;
    uint32_t num_update_image;

    uint32_t size_apply_uniforms;
    uint32_t size_update_buffer;
    uint32_t size_append_buffer;
    uint32_t size_update_image;

    sg_frame_stats_gl gl;
    sg_frame_stats_d3d11 d3d11;
    sg_frame_stats_metal metal;
    sg_frame_stats_wgpu wgpu;
} sg_frame_stats;

/*
    sg_desc

    The sg_desc struct contains configuration values for sokol_gfx,
    it is used as parameter to the sg_setup() call.

    The default configuration is:

    .buffer_pool_size       128
    .image_pool_size        128
    .sampler_pool_size      64
    .shader_pool_size       32
    .pipeline_pool_size     64
    .pass_pool_size         16
    .uniform_buffer_size    4 MB (4*1024*1024)
    .max_commit_listeners   1024
    .disable_validation     false
    .mtl_force_managed_storage_mode false
    .wgpu_disable_bindgroups_cache  false
    .wgpu_bindgroups_cache_size     1024

    .allocator.alloc_fn     0 (in this case, malloc() will be called)
    .allocator.free_fn      0 (in this case, free() will be called)
    .allocator.user_data    0

    .environment.defaults.color_format: default value depends on selected backend:
        all GL backends:    SG_PIXELFORMAT_RGBA8
        Metal and D3D11:    SG_PIXELFORMAT_BGRA8
        WebGPU:             *no default* (must be queried from WebGPU swapchain object)
    .environment.defaults.depth_format: SG_PIXELFORMAT_DEPTH_STENCIL
    .environment.defaults.sample_count: 1

    Metal specific:
        (NOTE: All Objective-C object references are transferred through
        a bridged (const void*) to sokol_gfx, which will use a unretained
        bridged cast (__bridged id<xxx>) to retrieve the Objective-C
        references back. Since the bridge cast is unretained, the caller
        must hold a strong reference to the Objective-C object for the
        duration of the sokol_gfx call!

        .mtl_force_managed_storage_mode
            when enabled, Metal buffers and texture resources are created in managed storage
            mode, otherwise sokol-gfx will decide whether to create buffers and
            textures in managed or shared storage mode (this is mainly a debugging option)
        .mtl_use_command_buffer_with_retained_references
            when true, the sokol-gfx Metal backend will use Metal command buffers which
            bump the reference count of resource objects as long as they are inflight,
            this is slower than the default command-buffer-with-unretained-references
            method, this may be a workaround when confronted with lifetime validation
            errors from the Metal validation layer until a proper fix has been implemented
        .environment.metal.device
            a pointer to the MTLDevice object

    D3D11 specific:
        .environment.d3d11.device
            a pointer to the ID3D11Device object, this must have been created
            before sg_setup() is called
        .environment.d3d11.device_context
            a pointer to the ID3D11DeviceContext object
        .d3d11_shader_debugging
            set this to true to compile shaders which are provided as HLSL source
            code with debug information and without optimization, this allows
            shader debugging in tools like RenderDoc, to output source code
            instead of byte code from sokol-shdc, omit the `--binary` cmdline
            option

    WebGPU specific:
        .wgpu_disable_bindgroups_cache
            When this is true, the WebGPU backend will create and immediately
            release a BindGroup object in the sg_apply_bindings() call, only
            use this for debugging purposes.
        .wgpu_bindgroups_cache_size
            The size of the bindgroups cache for re-using BindGroup objects
            between sg_apply_bindings() calls. The smaller the cache size,
            the more likely are cache slot collisions which will cause
            a BindGroups object to be destroyed and a new one created.
            Use the information returned by sg_query_stats() to check
            if this is a frequent occurrence, and increase the cache size as
            needed (the default is 1024).
            NOTE: wgpu_bindgroups_cache_size must be a power-of-2 number!
        .environment.wgpu.device
            a WGPUDevice handle

    When using sokol_gfx.h and sokol_app.h together, consider using the
    helper function sglue_environment() in the sokol_glue.h header to
    initialize the sg_desc.environment nested struct. sglue_environment() returns
    a completely initialized sg_environment struct with information
    provided by sokol_app.h.
*/
typedef struct sg_environment_defaults {
   sg_pixel_format color_format;
   sg_pixel_format depth_format;
   int sample_count;
} sg_environment_defaults;

typedef struct sg_metal_environment {
   const void* device;
} sg_metal_environment;

typedef struct sg_d3d11_environment {
   const void* device;
   const void* device_context;
} sg_d3d11_environment;

typedef struct sg_wgpu_environment {
   const void* device;
} sg_wgpu_environment;

typedef struct sg_environment {
   sg_environment_defaults defaults;
   sg_metal_environment metal;
   sg_d3d11_environment d3d11;
   sg_wgpu_environment wgpu;
} sg_environment;

/*
   sg_commit_listener

   Used with function sg_add_commit_listener() to add a callback
   which will be called in sg_commit(). This is useful for libraries
   building on top of sokol-gfx to be notified about when a frame
   ends (instead of having to guess, or add a manual 'new-frame'
   function.
*/
typedef struct sg_commit_listener {
   void (*func)(void* user_data);
   void* user_data;
} sg_commit_listener;

/*
   sg_allocator

   Used in sg_desc to provide custom memory-alloc and -free functions
   to sokol_gfx.h. If memory management should be overridden, both the
   alloc_fn and free_fn function must be provided (e.g. it's not valid to
   override one function but not the other).
*/
typedef struct sg_allocator {
   void* (*alloc_fn)(size_t size, void* user_data);
   void (*free_fn)(void* ptr, void* user_data);
   void* user_data;
} sg_allocator;

/*
   sg_logger

   Used in sg_desc to provide a logging function. Please be aware
   that without logging function, sokol-gfx will be completely
   silent, e.g. it will not report errors, warnings and
   validation layer messages. For maximum error verbosity,
   compile in debug mode (e.g. NDEBUG *not* defined) and provide a
   compatible logger function in the sg_setup() call
   (for instance the standard logging function from sokol_log.h).
*/
typedef struct sg_logger {
   void (*func)(
       const char* tag,                // always "sg"
       uint32_t log_level,             // 0=panic, 1=error, 2=warning, 3=info
       uint32_t log_item_id,           // SG_LOGITEM_*
       const char* message_or_null,    // a message string, may be nullptr in release mode
       uint32_t line_nr,               // line number in sokol_gfx.h
       const char* filename_or_null,   // source filename, may be nullptr in release mode
       void* user_data);
   void* user_data;
} sg_logger;

typedef struct sg_desc {
   uint32_t _start_canary;
   int buffer_pool_size;
   int image_pool_size;
   int sampler_pool_size;
   int shader_pool_size;
   int pipeline_pool_size;
   int attachments_pool_size;
   int uniform_buffer_size;
   int max_commit_listeners;
   bool disable_validation;    // disable validation layer even in debug mode, useful for tests
   bool d3d11_shader_debugging;    // if true, HLSL shaders are compiled with D3DCOMPILE_DEBUG | D3DCOMPILE_SKIP_OPTIMIZATION
   bool mtl_force_managed_storage_mode; // for debugging: use Metal managed storage mode for resources even with UMA
   bool mtl_use_command_buffer_with_retained_references;    // Metal: use a managed MTLCommandBuffer which ref-counts used resources
   bool wgpu_disable_bindgroups_cache;  // set to true to disable the WebGPU backend BindGroup cache
   int wgpu_bindgroups_cache_size;      // number of slots in the WebGPU bindgroup cache (must be 2^N)
   sg_allocator allocator;
   sg_logger logger; // optional log function override
   sg_environment environment;
   uint32_t _end_canary;
} sg_desc;

// setup and misc functions
void sg_setup(const sg_desc* desc);
void sg_shutdown(void);
bool sg_isvalid(void);
void sg_reset_state_cache(void);
sg_trace_hooks sg_install_trace_hooks(const sg_trace_hooks* trace_hooks);
void sg_push_debug_group(const char* name);
void sg_pop_debug_group(void);
bool sg_add_commit_listener(sg_commit_listener listener);
bool sg_remove_commit_listener(sg_commit_listener listener);

// resource creation, destruction and updating
sg_buffer sg_make_buffer(const sg_buffer_desc* desc);
sg_image sg_make_image(const sg_image_desc* desc);
sg_sampler sg_make_sampler(const sg_sampler_desc* desc);
sg_shader sg_make_shader(const sg_shader_desc* desc);
sg_pipeline sg_make_pipeline(const sg_pipeline_desc* desc);
sg_attachments sg_make_attachments(const sg_attachments_desc* desc);
void sg_destroy_buffer(sg_buffer buf);
void sg_destroy_image(sg_image img);
void sg_destroy_sampler(sg_sampler smp);
void sg_destroy_shader(sg_shader shd);
void sg_destroy_pipeline(sg_pipeline pip);
void sg_destroy_attachments(sg_attachments atts);
void sg_update_buffer(sg_buffer buf, const sg_range* data);
void sg_update_image(sg_image img, const sg_image_data* data);
int sg_append_buffer(sg_buffer buf, const sg_range* data);
bool sg_query_buffer_overflow(sg_buffer buf);
bool sg_query_buffer_will_overflow(sg_buffer buf, size_t size);

// rendering functions
void sg_begin_pass(const sg_pass* pass);
void sg_apply_viewport(int x, int y, int width, int height, bool origin_top_left);
void sg_apply_viewportf(float x, float y, float width, float height, bool origin_top_left);
void sg_apply_scissor_rect(int x, int y, int width, int height, bool origin_top_left);
void sg_apply_scissor_rectf(float x, float y, float width, float height, bool origin_top_left);
void sg_apply_pipeline(sg_pipeline pip);
void sg_apply_bindings(const sg_bindings* bindings);
void sg_apply_uniforms(sg_shader_stage stage, int ub_index, const sg_range* data);
void sg_draw(int base_element, int num_elements, int num_instances);
void sg_end_pass(void);
void sg_commit(void);

// getting information
sg_desc sg_query_desc(void);
sg_backend sg_query_backend(void);
sg_features sg_query_features(void);
sg_limits sg_query_limits(void);
sg_pixelformat_info sg_query_pixelformat(sg_pixel_format fmt);
int sg_query_row_pitch(sg_pixel_format fmt, int width, int row_align_bytes);
int sg_query_surface_pitch(sg_pixel_format fmt, int width, int height, int row_align_bytes);
// get current state of a resource (INITIAL, ALLOC, VALID, FAILED, INVALID)
sg_resource_state sg_query_buffer_state(sg_buffer buf);
sg_resource_state sg_query_image_state(sg_image img);
sg_resource_state sg_query_sampler_state(sg_sampler smp);
sg_resource_state sg_query_shader_state(sg_shader shd);
sg_resource_state sg_query_pipeline_state(sg_pipeline pip);
sg_resource_state sg_query_attachments_state(sg_attachments atts);
// get runtime information about a resource
sg_buffer_info sg_query_buffer_info(sg_buffer buf);
sg_image_info sg_query_image_info(sg_image img);
sg_sampler_info sg_query_sampler_info(sg_sampler smp);
sg_shader_info sg_query_shader_info(sg_shader shd);
sg_pipeline_info sg_query_pipeline_info(sg_pipeline pip);
sg_attachments_info sg_query_attachments_info(sg_attachments atts);
// get desc structs matching a specific resource (NOTE that not all creation attributes may be provided)
sg_buffer_desc sg_query_buffer_desc(sg_buffer buf);
sg_image_desc sg_query_image_desc(sg_image img);
sg_sampler_desc sg_query_sampler_desc(sg_sampler smp);
sg_shader_desc sg_query_shader_desc(sg_shader shd);
sg_pipeline_desc sg_query_pipeline_desc(sg_pipeline pip);
sg_attachments_desc sg_query_attachments_desc(sg_attachments atts);
// get resource creation desc struct with their default values replaced
sg_buffer_desc sg_query_buffer_defaults(const sg_buffer_desc* desc);
sg_image_desc sg_query_image_defaults(const sg_image_desc* desc);
sg_sampler_desc sg_query_sampler_defaults(const sg_sampler_desc* desc);
sg_shader_desc sg_query_shader_defaults(const sg_shader_desc* desc);
sg_pipeline_desc sg_query_pipeline_defaults(const sg_pipeline_desc* desc);
sg_attachments_desc sg_query_attachments_defaults(const sg_attachments_desc* desc);

// separate resource allocation and initialization (for async setup)
sg_buffer sg_alloc_buffer(void);
sg_image sg_alloc_image(void);
sg_sampler sg_alloc_sampler(void);
sg_shader sg_alloc_shader(void);
sg_pipeline sg_alloc_pipeline(void);
sg_attachments sg_alloc_attachments(void);
void sg_dealloc_buffer(sg_buffer buf);
void sg_dealloc_image(sg_image img);
void sg_dealloc_sampler(sg_sampler smp);
void sg_dealloc_shader(sg_shader shd);
void sg_dealloc_pipeline(sg_pipeline pip);
void sg_dealloc_attachments(sg_attachments attachments);
void sg_init_buffer(sg_buffer buf, const sg_buffer_desc* desc);
void sg_init_image(sg_image img, const sg_image_desc* desc);
void sg_init_sampler(sg_sampler smg, const sg_sampler_desc* desc);
void sg_init_shader(sg_shader shd, const sg_shader_desc* desc);
void sg_init_pipeline(sg_pipeline pip, const sg_pipeline_desc* desc);
void sg_init_attachments(sg_attachments attachments, const sg_attachments_desc* desc);
void sg_uninit_buffer(sg_buffer buf);
void sg_uninit_image(sg_image img);
void sg_uninit_sampler(sg_sampler smp);
void sg_uninit_shader(sg_shader shd);
void sg_uninit_pipeline(sg_pipeline pip);
void sg_uninit_attachments(sg_attachments atts);
void sg_fail_buffer(sg_buffer buf);
void sg_fail_image(sg_image img);
void sg_fail_sampler(sg_sampler smp);
void sg_fail_shader(sg_shader shd);
void sg_fail_pipeline(sg_pipeline pip);
void sg_fail_attachments(sg_attachments atts);

// frame stats
void sg_enable_frame_stats(void);
void sg_disable_frame_stats(void);
bool sg_frame_stats_enabled(void);
sg_frame_stats sg_query_frame_stats(void);


/********** cimgui ****************************************************************/

typedef unsigned int ImGuiID;
typedef signed char ImS8;
typedef unsigned char ImU8;
typedef signed short ImS16;
typedef unsigned short ImU16;
typedef signed int ImS32;
typedef unsigned int ImU32;
typedef signed long long ImS64;
typedef unsigned long long ImU64;
struct ImDrawChannel;
struct ImDrawCmd;
struct ImDrawData;
struct ImDrawList;
struct ImDrawListSharedData;
struct ImDrawListSplitter;
struct ImDrawVert;
struct ImFont;
struct ImFontAtlas;
struct ImFontBuilderIO;
struct ImFontConfig;
struct ImFontGlyph;
struct ImFontGlyphRangesBuilder;
struct ImColor;
struct ImGuiContext;
struct ImGuiIO;
struct ImGuiInputTextCallbackData;
struct ImGuiKeyData;
struct ImGuiListClipper;
struct ImGuiMultiSelectIO;
struct ImGuiOnceUponAFrame;
struct ImGuiPayload;
struct ImGuiPlatformIO;
struct ImGuiPlatformImeData;
struct ImGuiSelectionBasicStorage;
struct ImGuiSelectionExternalStorage;
struct ImGuiSelectionRequest;
struct ImGuiSizeCallbackData;
struct ImGuiStorage;
struct ImGuiStoragePair;
struct ImGuiStyle;
struct ImGuiTableSortSpecs;
struct ImGuiTableColumnSortSpecs;
struct ImGuiTextBuffer;
struct ImGuiTextFilter;
struct ImGuiViewport;
typedef int ImGuiCol;
typedef int ImGuiCond;
typedef int ImGuiDataType;
typedef int ImGuiMouseButton;
typedef int ImGuiMouseCursor;
typedef int ImGuiStyleVar;
typedef int ImGuiTableBgTarget;
typedef int ImDrawFlags;
typedef int ImDrawListFlags;
typedef int ImFontAtlasFlags;
typedef int ImGuiBackendFlags;
typedef int ImGuiButtonFlags;
typedef int ImGuiChildFlags;
typedef int ImGuiColorEditFlags;
typedef int ImGuiConfigFlags;
typedef int ImGuiComboFlags;
typedef int ImGuiDragDropFlags;
typedef int ImGuiFocusedFlags;
typedef int ImGuiHoveredFlags;
typedef int ImGuiInputFlags;
typedef int ImGuiInputTextFlags;
typedef int ImGuiItemFlags;
typedef int ImGuiKeyChord;
typedef int ImGuiPopupFlags;
typedef int ImGuiMultiSelectFlags;
typedef int ImGuiSelectableFlags;
typedef int ImGuiSliderFlags;
typedef int ImGuiTabBarFlags;
typedef int ImGuiTabItemFlags;
typedef int ImGuiTableFlags;
typedef int ImGuiTableColumnFlags;
typedef int ImGuiTableRowFlags;
typedef int ImGuiTreeNodeFlags;
typedef int ImGuiViewportFlags;
typedef int ImGuiWindowFlags;
typedef void* ImTextureID;
typedef unsigned short ImDrawIdx;
typedef unsigned int ImWchar32;
typedef unsigned short ImWchar16;
typedef ImWchar16 ImWchar;
typedef ImS64 ImGuiSelectionUserData;

typedef struct ImVector_ImWchar {int Size;int Capacity;ImWchar* Data;} ImVector_ImWchar;

typedef struct ImVec2 {
   float x;
   float y;
} ImVec2;

typedef struct ImVec4 {
   float x;
   float y;
   float z;
   float w;
} ImVec4;

typedef struct ImVec2ih {
   int16_t x;
   int16_t y;
} ImVec2ih;

typedef struct ImRect {
   ImVec2 Min;
   ImVec2 Max;
} ImRect;

typedef struct ImGuiKeyData
{
    bool Down;
    float DownDuration;
    float DownDurationPrev;
    float AnalogValue;
} ImGuiKeyData;

typedef enum {
   ImGuiSliderFlags_None = 0,
   ImGuiSliderFlags_AlwaysClamp = 1 << 4,
   ImGuiSliderFlags_Logarithmic = 1 << 5,
   ImGuiSliderFlags_NoRoundToFormat = 1 << 6,
   ImGuiSliderFlags_NoInput = 1 << 7,
   ImGuiSliderFlags_WrapAround = 1 << 8,
   ImGuiSliderFlags_InvalidMask_ = 0x7000000F,
}ImGuiSliderFlags_;

typedef enum {
   ImGuiInputTextFlags_None = 0,
   ImGuiInputTextFlags_CharsDecimal = 1 << 0,
   ImGuiInputTextFlags_CharsHexadecimal = 1 << 1,
   ImGuiInputTextFlags_CharsScientific = 1 << 2,
   ImGuiInputTextFlags_CharsUppercase = 1 << 3,
   ImGuiInputTextFlags_CharsNoBlank = 1 << 4,
   ImGuiInputTextFlags_AllowTabInput = 1 << 5,
   ImGuiInputTextFlags_EnterReturnsTrue = 1 << 6,
   ImGuiInputTextFlags_EscapeClearsAll = 1 << 7,
   ImGuiInputTextFlags_CtrlEnterForNewLine = 1 << 8,
   ImGuiInputTextFlags_ReadOnly = 1 << 9,
   ImGuiInputTextFlags_Password = 1 << 10,
   ImGuiInputTextFlags_AlwaysOverwrite = 1 << 11,
   ImGuiInputTextFlags_AutoSelectAll = 1 << 12,
   ImGuiInputTextFlags_ParseEmptyRefVal = 1 << 13,
   ImGuiInputTextFlags_DisplayEmptyRefVal = 1 << 14,
   ImGuiInputTextFlags_NoHorizontalScroll = 1 << 15,
   ImGuiInputTextFlags_NoUndoRedo = 1 << 16,
   ImGuiInputTextFlags_CallbackCompletion = 1 << 17,
   ImGuiInputTextFlags_CallbackHistory = 1 << 18,
   ImGuiInputTextFlags_CallbackAlways = 1 << 19,
   ImGuiInputTextFlags_CallbackCharFilter = 1 << 20,
   ImGuiInputTextFlags_CallbackResize = 1 << 21,
   ImGuiInputTextFlags_CallbackEdit = 1 << 22,
}ImGuiInputTextFlags_;

typedef enum {
   ImGuiComboFlags_None = 0,
   ImGuiComboFlags_PopupAlignLeft = 1 << 0,
   ImGuiComboFlags_HeightSmall = 1 << 1,
   ImGuiComboFlags_HeightRegular = 1 << 2,
   ImGuiComboFlags_HeightLarge = 1 << 3,
   ImGuiComboFlags_HeightLargest = 1 << 4,
   ImGuiComboFlags_NoArrowButton = 1 << 5,
   ImGuiComboFlags_NoPreview = 1 << 6,
   ImGuiComboFlags_WidthFitPreview = 1 << 7,
   ImGuiComboFlags_HeightMask_ = ImGuiComboFlags_HeightSmall | ImGuiComboFlags_HeightRegular | ImGuiComboFlags_HeightLarge | ImGuiComboFlags_HeightLargest,
}ImGuiComboFlags_;

typedef enum {
   ImGuiConfigFlags_None = 0,
   ImGuiConfigFlags_NavEnableKeyboard = 1 << 0,
   ImGuiConfigFlags_NavEnableGamepad = 1 << 1,
   ImGuiConfigFlags_NavEnableSetMousePos = 1 << 2,
   ImGuiConfigFlags_NavNoCaptureKeyboard = 1 << 3,
   ImGuiConfigFlags_NoMouse = 1 << 4,
   ImGuiConfigFlags_NoMouseCursorChange = 1 << 5,
   ImGuiConfigFlags_NoKeyboard = 1 << 6,
   ImGuiConfigFlags_IsSRGB = 1 << 20,
   ImGuiConfigFlags_IsTouchScreen = 1 << 21,
}ImGuiConfigFlags_;

typedef enum {
   ImGuiBackendFlags_None = 0,
   ImGuiBackendFlags_HasGamepad = 1 << 0,
   ImGuiBackendFlags_HasMouseCursors = 1 << 1,
   ImGuiBackendFlags_HasSetMousePos = 1 << 2,
   ImGuiBackendFlags_RendererHasVtxOffset = 1 << 3,
}ImGuiBackendFlags_;

typedef enum {
   ImGuiMouseSource_Mouse=0,
   ImGuiMouseSource_TouchScreen=1,
   ImGuiMouseSource_Pen=2,
   ImGuiMouseSource_COUNT=3,
}ImGuiMouseSource;

typedef enum {
   ImGuiCond_None = 0,
   ImGuiCond_Always = 1 << 0,
   ImGuiCond_Once = 1 << 1,
   ImGuiCond_FirstUseEver = 1 << 2,
   ImGuiCond_Appearing = 1 << 3,
}ImGuiCond_;

typedef enum {
   ImGuiDir_None=-1,
   ImGuiDir_Left=0,
   ImGuiDir_Right=1,
   ImGuiDir_Up=2,
   ImGuiDir_Down=3,
   ImGuiDir_COUNT=4,
   }ImGuiDir;
   typedef enum {
   ImGuiSortDirection_None=0,
   ImGuiSortDirection_Ascending=1,
   ImGuiSortDirection_Descending=2,
   }ImGuiSortDirection;
   typedef enum {
   ImGuiKey_None=0,
   ImGuiKey_Tab=512,
   ImGuiKey_LeftArrow=513,
   ImGuiKey_RightArrow=514,
   ImGuiKey_UpArrow=515,
   ImGuiKey_DownArrow=516,
   ImGuiKey_PageUp=517,
   ImGuiKey_PageDown=518,
   ImGuiKey_Home=519,
   ImGuiKey_End=520,
   ImGuiKey_Insert=521,
   ImGuiKey_Delete=522,
   ImGuiKey_Backspace=523,
   ImGuiKey_Space=524,
   ImGuiKey_Enter=525,
   ImGuiKey_Escape=526,
   ImGuiKey_LeftCtrl=527,
   ImGuiKey_LeftShift=528,
   ImGuiKey_LeftAlt=529,
   ImGuiKey_LeftSuper=530,
   ImGuiKey_RightCtrl=531,
   ImGuiKey_RightShift=532,
   ImGuiKey_RightAlt=533,
   ImGuiKey_RightSuper=534,
   ImGuiKey_Menu=535,
   ImGuiKey_0=536,
   ImGuiKey_1=537,
   ImGuiKey_2=538,
   ImGuiKey_3=539,
   ImGuiKey_4=540,
   ImGuiKey_5=541,
   ImGuiKey_6=542,
   ImGuiKey_7=543,
   ImGuiKey_8=544,
   ImGuiKey_9=545,
   ImGuiKey_A=546,
   ImGuiKey_B=547,
   ImGuiKey_C=548,
   ImGuiKey_D=549,
   ImGuiKey_E=550,
   ImGuiKey_F=551,
   ImGuiKey_G=552,
   ImGuiKey_H=553,
   ImGuiKey_I=554,
   ImGuiKey_J=555,
   ImGuiKey_K=556,
   ImGuiKey_L=557,
   ImGuiKey_M=558,
   ImGuiKey_N=559,
   ImGuiKey_O=560,
   ImGuiKey_P=561,
   ImGuiKey_Q=562,
   ImGuiKey_R=563,
   ImGuiKey_S=564,
   ImGuiKey_T=565,
   ImGuiKey_U=566,
   ImGuiKey_V=567,
   ImGuiKey_W=568,
   ImGuiKey_X=569,
   ImGuiKey_Y=570,
   ImGuiKey_Z=571,
   ImGuiKey_F1=572,
   ImGuiKey_F2=573,
   ImGuiKey_F3=574,
   ImGuiKey_F4=575,
   ImGuiKey_F5=576,
   ImGuiKey_F6=577,
   ImGuiKey_F7=578,
   ImGuiKey_F8=579,
   ImGuiKey_F9=580,
   ImGuiKey_F10=581,
   ImGuiKey_F11=582,
   ImGuiKey_F12=583,
   ImGuiKey_F13=584,
   ImGuiKey_F14=585,
   ImGuiKey_F15=586,
   ImGuiKey_F16=587,
   ImGuiKey_F17=588,
   ImGuiKey_F18=589,
   ImGuiKey_F19=590,
   ImGuiKey_F20=591,
   ImGuiKey_F21=592,
   ImGuiKey_F22=593,
   ImGuiKey_F23=594,
   ImGuiKey_F24=595,
   ImGuiKey_Apostrophe=596,
   ImGuiKey_Comma=597,
   ImGuiKey_Minus=598,
   ImGuiKey_Period=599,
   ImGuiKey_Slash=600,
   ImGuiKey_Semicolon=601,
   ImGuiKey_Equal=602,
   ImGuiKey_LeftBracket=603,
   ImGuiKey_Backslash=604,
   ImGuiKey_RightBracket=605,
   ImGuiKey_GraveAccent=606,
   ImGuiKey_CapsLock=607,
   ImGuiKey_ScrollLock=608,
   ImGuiKey_NumLock=609,
   ImGuiKey_PrintScreen=610,
   ImGuiKey_Pause=611,
   ImGuiKey_Keypad0=612,
   ImGuiKey_Keypad1=613,
   ImGuiKey_Keypad2=614,
   ImGuiKey_Keypad3=615,
   ImGuiKey_Keypad4=616,
   ImGuiKey_Keypad5=617,
   ImGuiKey_Keypad6=618,
   ImGuiKey_Keypad7=619,
   ImGuiKey_Keypad8=620,
   ImGuiKey_Keypad9=621,
   ImGuiKey_KeypadDecimal=622,
   ImGuiKey_KeypadDivide=623,
   ImGuiKey_KeypadMultiply=624,
   ImGuiKey_KeypadSubtract=625,
   ImGuiKey_KeypadAdd=626,
   ImGuiKey_KeypadEnter=627,
   ImGuiKey_KeypadEqual=628,
   ImGuiKey_AppBack=629,
   ImGuiKey_AppForward=630,
   ImGuiKey_GamepadStart=631,
   ImGuiKey_GamepadBack=632,
   ImGuiKey_GamepadFaceLeft=633,
   ImGuiKey_GamepadFaceRight=634,
   ImGuiKey_GamepadFaceUp=635,
   ImGuiKey_GamepadFaceDown=636,
   ImGuiKey_GamepadDpadLeft=637,
   ImGuiKey_GamepadDpadRight=638,
   ImGuiKey_GamepadDpadUp=639,
   ImGuiKey_GamepadDpadDown=640,
   ImGuiKey_GamepadL1=641,
   ImGuiKey_GamepadR1=642,
   ImGuiKey_GamepadL2=643,
   ImGuiKey_GamepadR2=644,
   ImGuiKey_GamepadL3=645,
   ImGuiKey_GamepadR3=646,
   ImGuiKey_GamepadLStickLeft=647,
   ImGuiKey_GamepadLStickRight=648,
   ImGuiKey_GamepadLStickUp=649,
   ImGuiKey_GamepadLStickDown=650,
   ImGuiKey_GamepadRStickLeft=651,
   ImGuiKey_GamepadRStickRight=652,
   ImGuiKey_GamepadRStickUp=653,
   ImGuiKey_GamepadRStickDown=654,
   ImGuiKey_MouseLeft=655,
   ImGuiKey_MouseRight=656,
   ImGuiKey_MouseMiddle=657,
   ImGuiKey_MouseX1=658,
   ImGuiKey_MouseX2=659,
   ImGuiKey_MouseWheelX=660,
   ImGuiKey_MouseWheelY=661,
   ImGuiKey_ReservedForModCtrl=662,
   ImGuiKey_ReservedForModShift=663,
   ImGuiKey_ReservedForModAlt=664,
   ImGuiKey_ReservedForModSuper=665,
   ImGuiKey_COUNT=666,
   ImGuiMod_None=0,
   ImGuiMod_Ctrl=1 << 12,
   ImGuiMod_Shift=1 << 13,
   ImGuiMod_Alt=1 << 14,
   ImGuiMod_Super=1 << 15,
   ImGuiMod_Mask_=0xF000,
   ImGuiKey_NamedKey_BEGIN=512,
   ImGuiKey_NamedKey_END=ImGuiKey_COUNT,
   ImGuiKey_NamedKey_COUNT=ImGuiKey_NamedKey_END - ImGuiKey_NamedKey_BEGIN,
   ImGuiKey_KeysData_SIZE=ImGuiKey_NamedKey_COUNT,
   ImGuiKey_KeysData_OFFSET=ImGuiKey_NamedKey_BEGIN,
}ImGuiKey;

typedef struct ImGuiInputTextCallbackData
{
   void* Ctx;
   ImGuiInputTextFlags EventFlag;
   ImGuiInputTextFlags Flags;
   void* UserData;
   ImWchar EventChar;
   ImGuiKey EventKey;
   char* Buf;
   int BufTextLen;
   int BufSize;
   bool BufDirty;
   int CursorPos;
   int SelectionStart;
   int SelectionEnd;
} ImGuiInputTextCallbackData;

typedef struct ImFontGlyph
{
    unsigned int Colored : 1;
    unsigned int Visible : 1;
    unsigned int Codepoint : 30;
    float AdvanceX;
    float X0, Y0, X1, Y1;
    float U0, V0, U1, V1;
} ImFontGlyph;
typedef struct ImVector_ImU32 {int Size;int Capacity;ImU32* Data;} ImVector_ImU32;

struct ImFontGlyphRangesBuilder
{
    ImVector_ImU32 UsedChars;
};

typedef enum {
    ImFontAtlasFlags_None = 0,
    ImFontAtlasFlags_NoPowerOfTwoHeight = 1 << 0,
    ImFontAtlasFlags_NoMouseCursors = 1 << 1,
    ImFontAtlasFlags_NoBakedLines = 1 << 2,
}ImFontAtlasFlags_;

typedef struct ImVector_float {int Size;int Capacity;float* Data;} ImVector_float;

typedef struct ImVector_ImFontGlyph {int Size;int Capacity;ImFontGlyph* Data;} ImVector_ImFontGlyph;

struct ImFontAtlas;

typedef struct ImFont
{
    ImVector_float IndexAdvanceX;
    float FallbackAdvanceX;
    float FontSize;
    ImVector_ImWchar IndexLookup;
    ImVector_ImFontGlyph Glyphs;
    const ImFontGlyph* FallbackGlyph;
    void* ContainerAtlas;
    const void* ConfigData;
    short ConfigDataCount;
    ImWchar FallbackChar;
    ImWchar EllipsisChar;
    short EllipsisCharCount;
    float EllipsisWidth;
    float EllipsisCharStep;
    bool DirtyLookupTables;
    float Scale;
    float Ascent, Descent;
    int MetricsTotalSurface;
    ImU8 Used4kPagesMap[(0xFFFF +1)/4096/8];
} ImFont;

typedef struct ImVector_ImFontPtr {int Size;int Capacity;ImFont** Data;} ImVector_ImFontPtr;

typedef struct ImFontAtlasCustomRect
{
    unsigned short Width, Height;
    unsigned short X, Y;
    unsigned int GlyphID;
    float GlyphAdvanceX;
    ImVec2 GlyphOffset;
    ImFont* Font;
}ImFontAtlasCustomRect;

typedef struct ImFontConfig
{
    void* FontData;
    int FontDataSize;
    bool FontDataOwnedByAtlas;
    int FontNo;
    float SizePixels;
    int OversampleH;
    int OversampleV;
    bool PixelSnapH;
    ImVec2 GlyphExtraSpacing;
    ImVec2 GlyphOffset;
    const ImWchar* GlyphRanges;
    float GlyphMinAdvanceX;
    float GlyphMaxAdvanceX;
    bool MergeMode;
    unsigned int FontBuilderFlags;
    float RasterizerMultiply;
    float RasterizerDensity;
    ImWchar EllipsisChar;
    char Name[40];
    ImFont* DstFont;
} ImFontConfig;

typedef struct ImVector_ImFontAtlasCustomRect {int Size;int Capacity;ImFontAtlasCustomRect* Data;} ImVector_ImFontAtlasCustomRect;

typedef struct ImVector_ImFontConfig {int Size;int Capacity;ImFontConfig* Data;} ImVector_ImFontConfig;

typedef struct ImFontAtlas
{
    ImFontAtlasFlags Flags;
    ImTextureID TexID;
    int TexDesiredWidth;
    int TexGlyphPadding;
    bool Locked;
    void* UserData;
    bool TexReady;
    bool TexPixelsUseColors;
    unsigned char* TexPixelsAlpha8;
    unsigned int* TexPixelsRGBA32;
    int TexWidth;
    int TexHeight;
    ImVec2 TexUvScale;
    ImVec2 TexUvWhitePixel;
    ImVector_ImFontPtr Fonts;
    ImVector_ImFontAtlasCustomRect CustomRects;
    ImVector_ImFontConfig ConfigData;
    ImVec4 TexUvLines[(63) + 1];
    const void* FontBuilderIO;
    unsigned int FontBuilderFlags;
    int PackIdMouseCursors;
    int PackIdLines;
} ImFontAtlas;


typedef struct ImGuiIO
{
    ImGuiConfigFlags ConfigFlags;
    ImGuiBackendFlags BackendFlags;
    ImVec2 DisplaySize;
    float DeltaTime;
    float IniSavingRate;
    const char* IniFilename;
    const char* LogFilename;
    void* UserData;
    ImFontAtlas*Fonts;
    float FontGlobalScale;
    bool FontAllowUserScaling;
    ImFont* FontDefault;
    ImVec2 DisplayFramebufferScale;
    bool MouseDrawCursor;
    bool ConfigMacOSXBehaviors;
    bool ConfigNavSwapGamepadButtons;
    bool ConfigInputTrickleEventQueue;
    bool ConfigInputTextCursorBlink;
    bool ConfigInputTextEnterKeepActive;
    bool ConfigDragClickToInputText;
    bool ConfigWindowsResizeFromEdges;
    bool ConfigWindowsMoveFromTitleBarOnly;
    float ConfigMemoryCompactTimer;
    float MouseDoubleClickTime;
    float MouseDoubleClickMaxDist;
    float MouseDragThreshold;
    float KeyRepeatDelay;
    float KeyRepeatRate;
    bool ConfigDebugIsDebuggerPresent;
    bool ConfigDebugBeginReturnValueOnce;
    bool ConfigDebugBeginReturnValueLoop;
    bool ConfigDebugIgnoreFocusLoss;
    bool ConfigDebugIniSettings;
    const char* BackendPlatformName;
    const char* BackendRendererName;
    void* BackendPlatformUserData;
    void* BackendRendererUserData;
    void* BackendLanguageUserData;
    bool WantCaptureMouse;
    bool WantCaptureKeyboard;
    bool WantTextInput;
    bool WantSetMousePos;
    bool WantSaveIniSettings;
    bool NavActive;
    bool NavVisible;
    float Framerate;
    int MetricsRenderVertices;
    int MetricsRenderIndices;
    int MetricsRenderWindows;
    int MetricsActiveWindows;
    ImVec2 MouseDelta;
    void* Ctx;
    ImVec2 MousePos;
    bool MouseDown[5];
    float MouseWheel;
    float MouseWheelH;
    ImGuiMouseSource MouseSource;
    bool KeyCtrl;
    bool KeyShift;
    bool KeyAlt;
    bool KeySuper;
    ImGuiKeyChord KeyMods;
    ImGuiKeyData KeysData[ImGuiKey_KeysData_SIZE];
    bool WantCaptureMouseUnlessPopupClose;
    ImVec2 MousePosPrev;
    ImVec2 MouseClickedPos[5];
    double MouseClickedTime[5];
    bool MouseClicked[5];
    bool MouseDoubleClicked[5];
    ImU16 MouseClickedCount[5];
    ImU16 MouseClickedLastCount[5];
    bool MouseReleased[5];
    bool MouseDownOwned[5];
    bool MouseDownOwnedUnlessPopupClose[5];
    bool MouseWheelRequestAxisSwap;
    bool MouseCtrlLeftAsRightClick;
    float MouseDownDuration[5];
    float MouseDownDurationPrev[5];
    float MouseDragMaxDistanceSqr[5];
    float PenPressure;
    bool AppFocusLost;
    bool AppAcceptingEvents;
    ImS8 BackendUsingLegacyKeyArrays;
    bool BackendUsingLegacyNavInputArray;
    ImWchar16 InputQueueSurrogate;
    ImVector_ImWchar InputQueueCharacters;
} ImGuiIO;

typedef int (*ImGuiInputTextCallback)(ImGuiInputTextCallbackData* data);

void igTextUnformatted(const char* text,const char* text_end);
void igText(const char* fmt,...);
void igTextV(const char* fmt,va_list args);
void igTextColored(const ImVec4 col,const char* fmt,...);
void igTextColoredV(const ImVec4 col,const char* fmt,va_list args);
void igTextDisabled(const char* fmt,...);
void igTextDisabledV(const char* fmt,va_list args);
void igTextWrapped(const char* fmt,...);
void igTextWrappedV(const char* fmt,va_list args);
void igLabelText(const char* label,const char* fmt,...);
void igLabelTextV(const char* label,const char* fmt,va_list args);
void igBulletText(const char* fmt,...);
void igBulletTextV(const char* fmt,va_list args);
void igSeparatorText(const char* label);
bool igButton(const char* label,const ImVec2 size);
bool igSmallButton(const char* label);
bool igInvisibleButton(const char* str_id,const ImVec2 size,ImGuiButtonFlags flags);
bool igArrowButton(const char* str_id,ImGuiDir dir);
bool igCheckbox(const char* label,bool* v);
bool igCheckboxFlags_IntPtr(const char* label,int* flags,int flags_value);
bool igCheckboxFlags_UintPtr(const char* label,unsigned int* flags,unsigned int flags_value);
bool igRadioButton_Bool(const char* label,bool active);
bool igRadioButton_IntPtr(const char* label,int* v,int v_button);
void igProgressBar(float fraction,const ImVec2 size_arg,const char* overlay);
void igBullet(void);
bool igTextLink(const char* label);
void igTextLinkOpenURL(const char* label,const char* url);
void igImage(ImTextureID user_texture_id,const ImVec2 image_size,const ImVec2 uv0,const ImVec2 uv1,const ImVec4 tint_col,const ImVec4 border_col);
bool igImageButton(const char* str_id,ImTextureID user_texture_id,const ImVec2 image_size,const ImVec2 uv0,const ImVec2 uv1,const ImVec4 bg_col,const ImVec4 tint_col);
bool igBeginCombo(const char* label,const char* preview_value,ImGuiComboFlags flags);
void igEndCombo(void);
bool igCombo_Str_arr(const char* label,int* current_item,const char* const items[],int items_count,int popup_max_height_in_items);
bool igCombo_Str(const char* label,int* current_item,const char* items_separated_by_zeros,int popup_max_height_in_items);
bool igCombo_FnStrPtr(const char* label,int* current_item,const char*(*getter)(void* user_data,int idx),void* user_data,int items_count,int popup_max_height_in_items);
bool igDragFloat(const char* label,float* v,float v_speed,float v_min,float v_max,const char* format,ImGuiSliderFlags flags);
bool igDragFloat2(const char* label,float v[2],float v_speed,float v_min,float v_max,const char* format,ImGuiSliderFlags flags);
bool igDragFloat3(const char* label,float v[3],float v_speed,float v_min,float v_max,const char* format,ImGuiSliderFlags flags);
bool igDragFloat4(const char* label,float v[4],float v_speed,float v_min,float v_max,const char* format,ImGuiSliderFlags flags);
bool igDragFloatRange2(const char* label,float* v_current_min,float* v_current_max,float v_speed,float v_min,float v_max,const char* format,const char* format_max,ImGuiSliderFlags flags);
bool igDragInt(const char* label,int* v,float v_speed,int v_min,int v_max,const char* format,ImGuiSliderFlags flags);
bool igDragInt2(const char* label,int v[2],float v_speed,int v_min,int v_max,const char* format,ImGuiSliderFlags flags);
bool igDragInt3(const char* label,int v[3],float v_speed,int v_min,int v_max,const char* format,ImGuiSliderFlags flags);
bool igDragInt4(const char* label,int v[4],float v_speed,int v_min,int v_max,const char* format,ImGuiSliderFlags flags);
bool igDragIntRange2(const char* label,int* v_current_min,int* v_current_max,float v_speed,int v_min,int v_max,const char* format,const char* format_max,ImGuiSliderFlags flags);
bool igDragScalar(const char* label,ImGuiDataType data_type,void* p_data,float v_speed,const void* p_min,const void* p_max,const char* format,ImGuiSliderFlags flags);
bool igDragScalarN(const char* label,ImGuiDataType data_type,void* p_data,int components,float v_speed,const void* p_min,const void* p_max,const char* format,ImGuiSliderFlags flags);
bool igSliderFloat(const char* label,float* v,float v_min,float v_max,const char* format,ImGuiSliderFlags flags);
bool igSliderFloat2(const char* label,float v[2],float v_min,float v_max,const char* format,ImGuiSliderFlags flags);
bool igSliderFloat3(const char* label,float v[3],float v_min,float v_max,const char* format,ImGuiSliderFlags flags);
bool igSliderFloat4(const char* label,float v[4],float v_min,float v_max,const char* format,ImGuiSliderFlags flags);
bool igSliderAngle(const char* label,float* v_rad,float v_degrees_min,float v_degrees_max,const char* format,ImGuiSliderFlags flags);
bool igSliderInt(const char* label,int* v,int v_min,int v_max,const char* format,ImGuiSliderFlags flags);
bool igSliderInt2(const char* label,int v[2],int v_min,int v_max,const char* format,ImGuiSliderFlags flags);
bool igSliderInt3(const char* label,int v[3],int v_min,int v_max,const char* format,ImGuiSliderFlags flags);
bool igSliderInt4(const char* label,int v[4],int v_min,int v_max,const char* format,ImGuiSliderFlags flags);

bool igInputText(const char* label,char* buf,size_t buf_size,ImGuiInputTextFlags flags,ImGuiInputTextCallback callback,void* user_data);
bool igInputTextMultiline(const char* label,char* buf,size_t buf_size,const ImVec2 size,ImGuiInputTextFlags flags,ImGuiInputTextCallback callback,void* user_data);
bool igInputTextWithHint(const char* label,const char* hint,char* buf,size_t buf_size,ImGuiInputTextFlags flags,ImGuiInputTextCallback callback,void* user_data);
bool igInputFloat(const char* label,float* v,float step,float step_fast,const char* format,ImGuiInputTextFlags flags);
bool igInputFloat2(const char* label,float v[2],const char* format,ImGuiInputTextFlags flags);
bool igInputFloat3(const char* label,float v[3],const char* format,ImGuiInputTextFlags flags);
bool igInputFloat4(const char* label,float v[4],const char* format,ImGuiInputTextFlags flags);
bool igInputInt(const char* label,int* v,int step,int step_fast,ImGuiInputTextFlags flags);
bool igInputInt2(const char* label,int v[2],ImGuiInputTextFlags flags);
bool igInputInt3(const char* label,int v[3],ImGuiInputTextFlags flags);
bool igInputInt4(const char* label,int v[4],ImGuiInputTextFlags flags);
bool igInputDouble(const char* label,double* v,double step,double step_fast,const char* format,ImGuiInputTextFlags flags);
bool igInputScalar(const char* label,ImGuiDataType data_type,void* p_data,const void* p_step,const void* p_step_fast,const char* format,ImGuiInputTextFlags flags);
bool igInputScalarN(const char* label,ImGuiDataType data_type,void* p_data,int components,const void* p_step,const void* p_step_fast,const char* format,ImGuiInputTextFlags flags);
bool igColorEdit3(const char* label,float col[3],ImGuiColorEditFlags flags);
bool igColorEdit4(const char* label,float col[4],ImGuiColorEditFlags flags);
bool igColorPicker3(const char* label,float col[3],ImGuiColorEditFlags flags);
bool igColorPicker4(const char* label,float col[4],ImGuiColorEditFlags flags,const float* ref_col);
bool igColorButton(const char* desc_id,const ImVec4 col,ImGuiColorEditFlags flags,const ImVec2 size);
void igSetColorEditOptions(ImGuiColorEditFlags flags);

void igSetNextWindowPos(const ImVec2 pos,ImGuiCond cond,const ImVec2 pivot);
void igSetNextWindowSize(const ImVec2 size,ImGuiCond cond);

bool igBegin(const char* name,bool* p_open,ImGuiWindowFlags flags);
void igEnd(void);

void igShowDemoWindow(bool* p_open);

ImGuiIO* igGetIO(void);

/********** sokol_imgui ****************************************************************/

/*
    simgui_image_t

    A combined image-sampler pair used to inject custom images and samplers into Dear ImGui.

    Create with simgui_make_image(), and convert to an ImTextureID handle via
    simgui_imtextureid().
*/
typedef struct simgui_image_t { uint32_t id; } simgui_image_t;

/*
    simgui_image_desc_t

    Descriptor struct for simgui_make_image(). You must provide
    at least an sg_image handle. Keeping the sg_sampler handle
    zero-initialized will select the builtin default sampler
    which uses linear filtering.
*/
typedef struct simgui_image_desc_t {
    sg_image image;
    sg_sampler sampler;
} simgui_image_desc_t;

/*
    simgui_allocator_t

    Used in simgui_desc_t to provide custom memory-alloc and -free functions
    to sokol_imgui.h. If memory management should be overridden, both the
    alloc_fn and free_fn function must be provided (e.g. it's not valid to
    override one function but not the other).
*/
typedef struct simgui_allocator_t {
    void* (*alloc_fn)(size_t size, void* user_data);
    void (*free_fn)(void* ptr, void* user_data);
    void* user_data;
} simgui_allocator_t;

/*
    simgui_logger

    Used in simgui_desc_t to provide a logging function. Please be aware
    that without logging function, sokol-imgui will be completely
    silent, e.g. it will not report errors, warnings and
    validation layer messages. For maximum error verbosity,
    compile in debug mode (e.g. NDEBUG *not* defined) and install
    a logger (for instance the standard logging function from sokol_log.h).
*/
typedef struct simgui_logger_t {
    void (*func)(
        const char* tag,                // always "simgui"
        uint32_t log_level,             // 0=panic, 1=error, 2=warning, 3=info
        uint32_t log_item_id,           // SIMGUI_LOGITEM_*
        const char* message_or_null,    // a message string, may be nullptr in release mode
        uint32_t line_nr,               // line number in sokol_imgui.h
        const char* filename_or_null,   // source filename, may be nullptr in release mode
        void* user_data);
    void* user_data;
} simgui_logger_t;

typedef struct simgui_desc_t {
    int max_vertices;               // default: 65536
    int image_pool_size;            // default: 256
    sg_pixel_format color_format;
    sg_pixel_format depth_format;
    int sample_count;
    const char* ini_filename;
    bool no_default_font;
    bool disable_paste_override;    // if true, don't send Ctrl-V on EVENTTYPE_CLIPBOARD_PASTED
    bool disable_set_mouse_cursor;  // if true, don't control the mouse cursor type via sapp_set_mouse_cursor()
    bool disable_windows_resize_from_edges; // if true, only resize edges from the bottom right corner
    bool write_alpha_channel;       // if true, alpha values get written into the framebuffer
    simgui_allocator_t allocator;   // optional memory allocation overrides (default: malloc/free)
    simgui_logger_t logger;         // optional log function override
} simgui_desc_t;

typedef struct simgui_frame_desc_t {
    int width;
    int height;
    double delta_time;
    float dpi_scale;
} simgui_frame_desc_t;

typedef struct simgui_font_tex_desc_t {
    sg_filter min_filter;
    sg_filter mag_filter;
} simgui_font_tex_desc_t;

void simgui_setup(const simgui_desc_t* desc);
void simgui_new_frame(const simgui_frame_desc_t* desc);
void simgui_render(void);
simgui_image_t simgui_make_image(const simgui_image_desc_t* desc);
void simgui_destroy_image(simgui_image_t img);
simgui_image_desc_t simgui_query_image_desc(simgui_image_t img);
void* simgui_imtextureid(simgui_image_t img);
simgui_image_t simgui_image_from_imtextureid(void* im_texture_id);
void simgui_add_focus_event(bool focus);
void simgui_add_mouse_pos_event(float x, float y);
void simgui_add_touch_pos_event(float x, float y);
void simgui_add_mouse_button_event(int mouse_button, bool down);
void simgui_add_mouse_wheel_event(float wheel_x, float wheel_y);
void simgui_add_key_event(int imgui_key, bool down);
void simgui_add_input_character(uint32_t c);
void simgui_add_input_characters_utf8(const char* c);
void simgui_add_touch_button_event(int mouse_button, bool down);

bool simgui_handle_event(const sapp_event* ev);
int simgui_map_keycode(sapp_keycode keycode);  // returns ImGuiKey_*

void simgui_shutdown(void);
void simgui_create_fonts_texture(const simgui_font_tex_desc_t* desc);
void simgui_destroy_fonts_texture(void);

]]

return sokol_imgui