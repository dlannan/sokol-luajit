local ffi  = require( "ffi" )

local libs = ffi_sokol_shape or {
   OSX     = { x64 = "libsokol_shape_dll_macos.so" },
   Windows = { x64 = "sokol_shape_dll.dll" },
   Linux   = { x64 = "sokol_shape_dll.so", arm = "sokol_shape_dll.so" },
   BSD     = { x64 = "sokol_shape_dll.so" },
   POSIX   = { x64 = "sokol_shape_dll.so" },
   Other   = { x64 = "sokol_shape_dll.so" },
}

local lib  = ffi_sokol_shape or libs[ ffi.os ][ ffi.arch ]
local sokol_shape   = ffi.load( lib )

ffi.cdef[[

/********** sokol_shape ****************************************************************/

/*
    sshape_range is a pointer-size-pair struct used to pass memory
    blobs into sokol-shape. When initialized from a value type
    (array or struct), use the SSHAPE_RANGE() macro to build
    an sshape_range struct.
*/
typedef struct sshape_range {
   const void* ptr;
   size_t size;
} sshape_range;

/* a 4x4 matrix wrapper struct */
typedef struct sshape_mat4_t { float m[4][4]; } sshape_mat4_t;

/* vertex layout of the generated geometry */
typedef struct sshape_vertex_t {
   float x, y, z;
   uint32_t normal;        // packed normal as BYTE4N
   uint16_t u, v;          // packed uv coords as USHORT2N
   uint32_t color;         // packed color as UBYTE4N (r,g,b,a);
} sshape_vertex_t;

/* a range of draw-elements (sg_draw(int base_element, int num_element, ...)) */
typedef struct sshape_element_range_t {
   int base_element;
   int num_elements;
} sshape_element_range_t;

/* number of elements and byte size of build actions */
typedef struct sshape_sizes_item_t {
   uint32_t num;       // number of elements
   uint32_t size;      // the same as size in bytes
} sshape_sizes_item_t;

typedef struct sshape_sizes_t {
   sshape_sizes_item_t vertices;
   sshape_sizes_item_t indices;
} sshape_sizes_t;

/* in/out struct to keep track of mesh-build state */
typedef struct sshape_buffer_item_t {
   sshape_range buffer;    // pointer/size pair of output buffer
   size_t data_size;       // size in bytes of valid data in buffer
   size_t shape_offset;    // data offset of the most recent shape
} sshape_buffer_item_t;

typedef struct sshape_buffer_t {
   bool valid;
   sshape_buffer_item_t vertices;
   sshape_buffer_item_t indices;
} sshape_buffer_t;

/* creation parameters for the different shape types */
typedef struct sshape_plane_t {
   float width, depth;             // default: 1.0
   uint16_t tiles;                 // default: 1
   uint32_t color;                 // default: white
   bool random_colors;             // default: false
   bool merge;                     // if true merge with previous shape (default: false)
   sshape_mat4_t transform;        // default: identity matrix
} sshape_plane_t;

typedef struct sshape_box_t {
   float width, height, depth;     // default: 1.0
   uint16_t tiles;                 // default: 1
   uint32_t color;                 // default: white
   bool random_colors;             // default: false
   bool merge;                     // if true merge with previous shape (default: false)
   sshape_mat4_t transform;        // default: identity matrix
} sshape_box_t;

typedef struct sshape_sphere_t {
   float radius;                   // default: 0.5
   uint16_t slices;                // default: 5
   uint16_t stacks;                // default: 4
   uint32_t color;                 // default: white
   bool random_colors;             // default: false
   bool merge;                     // if true merge with previous shape (default: false)
   sshape_mat4_t transform;        // default: identity matrix
} sshape_sphere_t;

typedef struct sshape_cylinder_t {
   float radius;                   // default: 0.5
   float height;                   // default: 1.0
   uint16_t slices;                // default: 5
   uint16_t stacks;                // default: 1
   uint32_t color;                 // default: white
   bool random_colors;             // default: false
   bool merge;                     // if true merge with previous shape (default: false)
   sshape_mat4_t transform;        // default: identity matrix
} sshape_cylinder_t;

typedef struct sshape_torus_t {
   float radius;                   // default: 0.5f
   float ring_radius;              // default: 0.2f
   uint16_t sides;                 // default: 5
   uint16_t rings;                 // default: 5
   uint32_t color;                 // default: white
   bool random_colors;             // default: false
   bool merge;                     // if true merge with previous shape (default: false)
   sshape_mat4_t transform;        // default: identity matrix
} sshape_torus_t;

/* shape builder functions */
sshape_buffer_t sshape_build_plane(const sshape_buffer_t* buf, const sshape_plane_t* params);
sshape_buffer_t sshape_build_box(const sshape_buffer_t* buf, const sshape_box_t* params);
sshape_buffer_t sshape_build_sphere(const sshape_buffer_t* buf, const sshape_sphere_t* params);
sshape_buffer_t sshape_build_cylinder(const sshape_buffer_t* buf, const sshape_cylinder_t* params);
sshape_buffer_t sshape_build_torus(const sshape_buffer_t* buf, const sshape_torus_t* params);

/* query required vertex- and index-buffer sizes in bytes */
sshape_sizes_t sshape_plane_sizes(uint32_t tiles);
sshape_sizes_t sshape_box_sizes(uint32_t tiles);
sshape_sizes_t sshape_sphere_sizes(uint32_t slices, uint32_t stacks);
sshape_sizes_t sshape_cylinder_sizes(uint32_t slices, uint32_t stacks);
sshape_sizes_t sshape_torus_sizes(uint32_t sides, uint32_t rings);

/* extract sokol-gfx desc structs and primitive ranges from build state */
sshape_element_range_t sshape_element_range(const sshape_buffer_t* buf);
sg_buffer_desc sshape_vertex_buffer_desc(const sshape_buffer_t* buf);
sg_buffer_desc sshape_index_buffer_desc(const sshape_buffer_t* buf);
sg_vertex_buffer_layout_state sshape_vertex_buffer_layout_state(void);
sg_vertex_attr_state sshape_position_vertex_attr_state(void);
sg_vertex_attr_state sshape_normal_vertex_attr_state(void);
sg_vertex_attr_state sshape_texcoord_vertex_attr_state(void);
sg_vertex_attr_state sshape_color_vertex_attr_state(void);

/* helper functions to build packed color value from floats or bytes */
uint32_t sshape_color_4f(float r, float g, float b, float a);
uint32_t sshape_color_3f(float r, float g, float b);
uint32_t sshape_color_4b(uint8_t r, uint8_t g, uint8_t b, uint8_t a);
uint32_t sshape_color_3b(uint8_t r, uint8_t g, uint8_t b);

/* adapter function for filling matrix struct from generic float[16] array */
sshape_mat4_t sshape_mat4(const float m[16]);
sshape_mat4_t sshape_mat4_transpose(const float m[16]);

]]

return sokol_shape