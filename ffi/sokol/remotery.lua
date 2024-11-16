local ffi  = require( "ffi" )

local libs = ffi_remotery_dll or {
   OSX     = { x64 = "remotery_dll_macos.so" },
   Windows = { x64 = "remotery_dll.dll" },
   Linux   = { x64 = "remotery_dll.so", arm = "remotery_dll.so" },
   BSD     = { x64 = "remotery_dll.so" },
   POSIX   = { x64 = "remotery_dll.so" },
   Other   = { x64 = "remotery_dll.so" },
}

local lib  = ffi_remotery_dll or libs[ ffi.os ][ ffi.arch ]
local remotery_lib   = ffi.load( lib )

ffi.cdef[[

/********** remotery_lib ****************************************************************/

/*--------------------------------------------------------------------------------------------------------------------------------
   Types
--------------------------------------------------------------------------------------------------------------------------------*/


// Boolean
typedef unsigned int rmtBool;
enum {
    RMT_FALSE = 0,
    RMT_TRUE = 1
};

// Unsigned integer types
typedef unsigned char rmtU8;
typedef unsigned short rmtU16;
typedef unsigned int rmtU32;
typedef unsigned long long rmtU64;

// Signed integer types
typedef char rmtS8;
typedef short rmtS16;
typedef int rmtS32;
typedef long long rmtS64;

// Float types
typedef float rmtF32;
typedef double rmtF64;

// Const, null-terminated string pointer
typedef const char* rmtPStr;

// Opaque pointer for a sample graph tree
typedef struct Msg_SampleTree rmtSampleTree;

// Opaque pointer to a node in the sample graph tree
typedef struct Sample rmtSample;

// Handle to the main remotery instance
typedef struct Remotery Remotery;

// Forward declaration
struct rmtProperty;


typedef enum rmtSampleType
{
    RMT_SampleType_CPU,
    RMT_SampleType_CUDA,
    RMT_SampleType_D3D11,
    RMT_SampleType_D3D12,
    RMT_SampleType_OpenGL,
    RMT_SampleType_Metal,
    RMT_SampleType_Vulkan,
    RMT_SampleType_Count,
} rmtSampleType;

// All possible error codes
// clang-format off
typedef enum rmtError
{
    RMT_ERROR_NONE,
    RMT_ERROR_RECURSIVE_SAMPLE,                 // Not an error but an internal message to calling code
    RMT_ERROR_UNKNOWN,                          // An error with a message yet to be defined, only for internal error handling
    RMT_ERROR_INVALID_INPUT,                    // An invalid input to a function call was provided
    RMT_ERROR_RESOURCE_CREATE_FAIL,             // Creation of an internal resource failed
    RMT_ERROR_RESOURCE_ACCESS_FAIL,             // Access of an internal resource failed
    RMT_ERROR_TIMEOUT,                          // Internal system timeout

    // System errors
    RMT_ERROR_MALLOC_FAIL,                      // Malloc call within remotery failed
    RMT_ERROR_TLS_ALLOC_FAIL,                   // Attempt to allocate thread local storage failed
    RMT_ERROR_VIRTUAL_MEMORY_BUFFER_FAIL,       // Failed to create a virtual memory mirror buffer
    RMT_ERROR_CREATE_THREAD_FAIL,               // Failed to create a thread for the server
    RMT_ERROR_OPEN_THREAD_HANDLE_FAIL,          // Failed to open a thread handle, given a thread id

    // Network TCP/IP socket errors
    RMT_ERROR_SOCKET_INVALID_POLL,              // Poll attempt on an invalid socket
    RMT_ERROR_SOCKET_SELECT_FAIL,               // Server failed to call select on socket
    RMT_ERROR_SOCKET_POLL_ERRORS,               // Poll notified that the socket has errors
    RMT_ERROR_SOCKET_SEND_FAIL,                 // Unrecoverable error occured while client/server tried to send data
    RMT_ERROR_SOCKET_RECV_NO_DATA,              // No data available when attempting a receive
    RMT_ERROR_SOCKET_RECV_TIMEOUT,              // Timed out trying to receive data
    RMT_ERROR_SOCKET_RECV_FAILED,               // Unrecoverable error occured while client/server tried to receive data

    // WebSocket errors
    RMT_ERROR_WEBSOCKET_HANDSHAKE_NOT_GET,      // WebSocket server handshake failed, not HTTP GET
    RMT_ERROR_WEBSOCKET_HANDSHAKE_NO_VERSION,   // WebSocket server handshake failed, can't locate WebSocket version
    RMT_ERROR_WEBSOCKET_HANDSHAKE_BAD_VERSION,  // WebSocket server handshake failed, unsupported WebSocket version
    RMT_ERROR_WEBSOCKET_HANDSHAKE_NO_HOST,      // WebSocket server handshake failed, can't locate host
    RMT_ERROR_WEBSOCKET_HANDSHAKE_BAD_HOST,     // WebSocket server handshake failed, host is not allowed to connect
    RMT_ERROR_WEBSOCKET_HANDSHAKE_NO_KEY,       // WebSocket server handshake failed, can't locate WebSocket key
    RMT_ERROR_WEBSOCKET_HANDSHAKE_BAD_KEY,      // WebSocket server handshake failed, WebSocket key is ill-formed
    RMT_ERROR_WEBSOCKET_HANDSHAKE_STRING_FAIL,  // WebSocket server handshake failed, internal error, bad string code
    RMT_ERROR_WEBSOCKET_DISCONNECTED,           // WebSocket server received a disconnect request and closed the socket
    RMT_ERROR_WEBSOCKET_BAD_FRAME_HEADER,       // Couldn't parse WebSocket frame header
    RMT_ERROR_WEBSOCKET_BAD_FRAME_HEADER_SIZE,  // Partially received wide frame header size
    RMT_ERROR_WEBSOCKET_BAD_FRAME_HEADER_MASK,  // Partially received frame header data mask
    RMT_ERROR_WEBSOCKET_RECEIVE_TIMEOUT,        // Timeout receiving frame header

    RMT_ERROR_REMOTERY_NOT_CREATED,             // Remotery object has not been created
    RMT_ERROR_SEND_ON_INCOMPLETE_PROFILE,       // An attempt was made to send an incomplete profile tree to the client

    // CUDA error messages
    RMT_ERROR_CUDA_DEINITIALIZED,               // This indicates that the CUDA driver is in the process of shutting down
    RMT_ERROR_CUDA_NOT_INITIALIZED,             // This indicates that the CUDA driver has not been initialized with cuInit() or that initialization has failed
    RMT_ERROR_CUDA_INVALID_CONTEXT,             // This most frequently indicates that there is no context bound to the current thread
    RMT_ERROR_CUDA_INVALID_VALUE,               // This indicates that one or more of the parameters passed to the API call is not within an acceptable range of values
    RMT_ERROR_CUDA_INVALID_HANDLE,              // This indicates that a resource handle passed to the API call was not valid
    RMT_ERROR_CUDA_OUT_OF_MEMORY,               // The API call failed because it was unable to allocate enough memory to perform the requested operation
    RMT_ERROR_ERROR_NOT_READY,                  // This indicates that a resource handle passed to the API call was not valid

    // Direct3D 11 error messages
    RMT_ERROR_D3D11_FAILED_TO_CREATE_QUERY,     // Failed to create query for sample

    // OpenGL error messages
    RMT_ERROR_OPENGL_ERROR,                     // Generic OpenGL error, no need to expose detail since app will need an OpenGL error callback registered

    RMT_ERROR_CUDA_UNKNOWN,
} rmtError;

/*--------------------------------------------------------------------------------------------------------------------------------
   Runtime Settings
--------------------------------------------------------------------------------------------------------------------------------*/


// Callback function pointer types
typedef void* (*rmtMallocPtr)(void* mm_context, rmtU32 size);
typedef void* (*rmtReallocPtr)(void* mm_context, void* ptr, rmtU32 size);
typedef void (*rmtFreePtr)(void* mm_context, void* ptr);
typedef void (*rmtInputHandlerPtr)(const char* text, void* context);
typedef void (*rmtSampleTreeHandlerPtr)(void* cbk_context, rmtSampleTree* sample_tree);
typedef void (*rmtPropertyHandlerPtr)(void* cbk_context, struct rmtProperty* root);

// Struture to fill in to modify Remotery default settings
typedef struct rmtSettings
{
    // Which port to listen for incoming connections on
    rmtU16 port;

    // When this server exits it can leave the port open in TIME_WAIT state for a while. This forces
    // subsequent server bind attempts to fail when restarting. If you find restarts fail repeatedly
    // with bind attempts, set this to true to forcibly reuse the open port.
    rmtBool reuse_open_port;

    // Only allow connections on localhost?
    // For dev builds you may want to access your game from other devices but if
    // you distribute a game to your players with Remotery active, probably best
    // to limit connections to localhost.
    rmtBool limit_connections_to_localhost;

    // Whether to enable runtime thread sampling that discovers which processors a thread is running
    // on. This will suspend and resume threads from outside repeatdly and inject code into each
    // thread that automatically instruments the processor.
    // Default: Enabled
    rmtBool enableThreadSampler;

    // How long to sleep between server updates, hopefully trying to give
    // a little CPU back to other threads.
    rmtU32 msSleepBetweenServerUpdates;

    // Size of the internal message queues Remotery uses
    // Will be rounded to page granularity of 64k
    rmtU32 messageQueueSizeInBytes;

    // If the user continuously pushes to the message queue, the server network
    // code won't get a chance to update unless there's an upper-limit on how
    // many messages can be consumed per loop.
    rmtU32 maxNbMessagesPerUpdate;

    // Callback pointers for memory allocation
    rmtMallocPtr malloc;
    rmtReallocPtr realloc;
    rmtFreePtr free;
    void* mm_context;

    // Callback pointer for receiving input from the Remotery console
    rmtInputHandlerPtr input_handler;

    // Callback pointer for traversing the sample tree graph
    rmtSampleTreeHandlerPtr sampletree_handler;
    void* sampletree_context;

    // Callback pointer for traversing the prpperty graph
    rmtPropertyHandlerPtr snapshot_callback;
    void* snapshot_context;

    // Context pointer that gets sent to Remotery console callback function
    void* input_handler_context;

    rmtPStr logPath;
} rmtSettings;
    
/*--------------------------------------------------------------------------------------------------------------------------------
   GPU Sampling
--------------------------------------------------------------------------------------------------------------------------------*/

typedef struct rmtD3D12Bind
{
    // The main device shared by all threads
    void* device;

    // The queue command lists are executed on for profiling
    void* queue;

} rmtD3D12Bind;

typedef struct rmtVulkanFunctions
{
    // Function pointers to Vulkan functions
    // Untyped so that the Vulkan headers are not required in this file

    // Instance functions
    void* vkGetPhysicalDeviceProperties;

    // Device functions
    void* vkQueueSubmit;
    void* vkQueueWaitIdle;
    void* vkCreateQueryPool;
    void* vkDestroyQueryPool;
    void* vkResetQueryPool; // vkResetQueryPool (Vulkan 1.2+ with hostQueryReset) or vkResetQueryPoolEXT (VK_EXT_host_query_reset)
    void* vkGetQueryPoolResults;
    void* vkCmdWriteTimestamp;
    void* vkCreateSemaphore;
    void* vkDestroySemaphore;
    void* vkSignalSemaphore; // vkSignalSemaphore (Vulkan 1.2+ with timelineSemaphore) or vkSignalSemaphoreKHR (VK_KHR_timeline_semaphore)
    void* vkGetSemaphoreCounterValue; // vkGetSemaphoreCounterValue (Vulkan 1.2+ with timelineSemaphore) or vkGetSemaphoreCounterValueKHR (VK_KHR_timeline_semaphore)
    void* vkGetCalibratedTimestampsEXT; // vkGetCalibratedTimestampsKHR (VK_KHR_calibrated_timestamps) or vkGetCalibratedTimestampsEXT (VK_EXT_calibrated_timestamps)

} rmtVulkanFunctions;

typedef struct rmtVulkanBind
{
    // The physical Vulkan device, of type VkPhysicalDevice
    void* physical_device;

    // The logical Vulkan device, of type VkDevice
    void* device;

    // The queue command buffers are executed on for profiling, of type VkQueue
    void* queue;

} rmtVulkanBind;

/*--------------------------------------------------------------------------------------------------------------------------------
   Runtime Properties
--------------------------------------------------------------------------------------------------------------------------------*/


/* --- Public API --------------------------------------------------------------------------------------------------------------*/


// Flags that control property behaviour
typedef enum
{
    RMT_PropertyFlags_NoFlags = 0,

    // Reset property back to its default value on each new frame
    RMT_PropertyFlags_FrameReset = 1,
} rmtPropertyFlags;

// All possible property types that can be recorded and sent to the viewer
typedef enum
{
    RMT_PropertyType_rmtGroup,
    RMT_PropertyType_rmtBool,
    RMT_PropertyType_rmtS32,
    RMT_PropertyType_rmtU32,
    RMT_PropertyType_rmtF32,
    RMT_PropertyType_rmtS64,
    RMT_PropertyType_rmtU64,
    RMT_PropertyType_rmtF64,
} rmtPropertyType;

// A property value as a union of all its possible types
typedef union rmtPropertyValue
{
    rmtBool Bool;
    rmtS32 S32;
    rmtU32 U32;
    rmtF32 F32;
    rmtS64 S64;
    rmtU64 U64;
    rmtF64 F64;
} rmtPropertyValue;

// Definition of a property that should be stored globally
// Note:
//  Use the callback api and the rmt_PropertyGetxxx accessors to traverse this structure
typedef struct rmtProperty
{
    // Gets set to RMT_TRUE after a property has been modified, when it gets initialised for the first time
    rmtBool initialised;

    // Runtime description
    rmtPropertyType type;
    rmtPropertyFlags flags;

    // Current value
    rmtPropertyValue value;

    // Last frame value to see if previous value needs to be updated
    rmtPropertyValue lastFrameValue;
    
    // Previous value only if it's different from the current value, and when it changed
    rmtPropertyValue prevValue;
    rmtU32 prevValueFrame;

    // Text description
    const char* name;
    const char* description;

    // Default value for Reset calls
    rmtPropertyValue defaultValue;

    // Parent link specifically placed after default value so that variadic macro can initialise it
    struct rmtProperty* parent;

    // Links within the property tree
    struct rmtProperty* firstChild;
    struct rmtProperty* lastChild;
    struct rmtProperty* nextSibling;

    // Hash for efficient sending of properties to the viewer
    rmtU32 nameHash;

    // Unique, persistent ID among all properties
    rmtU32 uniqueID;
} rmtProperty;


void _rmt_PropertySetValue(rmtProperty* property);
void _rmt_PropertyAddValue(rmtProperty* property, rmtPropertyValue add_value);
rmtError _rmt_PropertySnapshotAll();
void _rmt_PropertyFrameResetAll();
rmtU32 _rmt_HashString32(const char* s, int len, rmtU32 seed);

/*--------------------------------------------------------------------------------------------------------------------------------
   Sample Tree API for walking `rmtSampleTree` Objects in the Sample Tree Handler.
--------------------------------------------------------------------------------------------------------------------------------*/


typedef enum rmtSampleFlags
{
    // Default behaviour
    RMTSF_None = 0,

    // Search parent for same-named samples and merge timing instead of adding a new sample
    RMTSF_Aggregate = 1,

    // Merge sample with parent if it's the same sample
    RMTSF_Recursive = 2,

    // Set this flag on any of your root samples so that Remotery will assert if it ends up *not* being the root sample.
    // This will quickly allow you to detect Begin/End mismatches causing a sample tree imbalance.
    RMTSF_Root = 4,

    // Mainly for platforms other than Windows that don't support the thread sampler and can't detect stalling samples.
    // Where you have a non-root sample that stays open indefinitely and never sends its contents to log/viewer.
    // Send this sample to log/viewer when it closes.
    // You can not have more than one sample open with this flag on the same thread at a time.
    // This flag will be removed in a future version when all platforms support stalling samples.
    RMTSF_SendOnClose = 8,
} rmtSampleFlags;

// Struct to hold iterator info
typedef struct rmtSampleIterator
{
// public
    rmtSample* sample;
// private
    rmtSample* initial;
} rmtSampleIterator;

// Struct to hold iterator info
typedef struct rmtPropertyIterator
{
// public
    rmtProperty* property;
// private
    rmtProperty* initial;
} rmtPropertyIterator;

// Gets the last error message issued on the calling thread
rmtPStr rmt_GetLastErrorMessage();

/*--------------------------------------------------------------------------------------------------------------------------------
   Private Interface - don't directly call these
--------------------------------------------------------------------------------------------------------------------------------*/

/* ---- While this is true - we will call them, the way they are used in the defines. 
   ----   Theres no simple way around this unless I build another API for them, which isnt really needed.
   ---    The aim will be to have lua util methods that mimik the same use as the defines. */

void * CreateGlobalInstance();
void DestroyGlobalInstance(void *rmt);
void SetGlobalInstance(void *rmt);
void * GetGlobalInstance();


rmtSettings* _rmt_Settings( void );
enum rmtError _rmt_CreateGlobalInstance(Remotery** remotery);
void _rmt_DestroyGlobalInstance(Remotery* remotery);
void _rmt_SetGlobalInstance(Remotery* remotery);
Remotery* _rmt_GetGlobalInstance(void);
void _rmt_SetCurrentThreadName(rmtPStr thread_name);
void _rmt_LogText(rmtPStr text);
void _rmt_BeginCPUSample(rmtPStr name, rmtU32 flags, rmtU32* hash_cache);
void _rmt_EndCPUSample(void);
rmtError _rmt_MarkFrame(void);

void _rmt_BindOpenGL();
void _rmt_UnbindOpenGL(void);
void _rmt_BeginOpenGLSample(rmtPStr name, rmtU32* hash_cache);
void _rmt_EndOpenGLSample(void);

// Sample iterator
void                _rmt_IterateChildren(rmtSampleIterator* iter, rmtSample* sample);
rmtBool             _rmt_IterateNext(rmtSampleIterator* iter);

// SampleTree accessors
const char*         _rmt_SampleTreeGetThreadName(rmtSampleTree* sample_tree);
rmtSample*          _rmt_SampleTreeGetRootSample(rmtSampleTree* sample_tree);

// Sample accessors
const char*         _rmt_SampleGetName(rmtSample* sample);
rmtU32              _rmt_SampleGetNameHash(rmtSample* sample);
rmtU32              _rmt_SampleGetCallCount(rmtSample* sample);
rmtU64              _rmt_SampleGetStart(rmtSample* sample);
rmtU64              _rmt_SampleGetTime(rmtSample* sample);
rmtU64              _rmt_SampleGetSelfTime(rmtSample* sample);
void                _rmt_SampleGetColour(rmtSample* sample, rmtU8* r, rmtU8* g, rmtU8* b);
rmtSampleType       _rmt_SampleGetType(rmtSample* sample);

// Property iterator
void                _rmt_PropertyIterateChildren(rmtPropertyIterator* iter, rmtProperty* property);
rmtBool             _rmt_PropertyIterateNext(rmtPropertyIterator* iter);

// Property accessors
rmtPropertyType     _rmt_PropertyGetType(rmtProperty* property);
rmtU32              _rmt_PropertyGetNameHash(rmtProperty* property);
const char*         _rmt_PropertyGetName(rmtProperty* property);
const char*         _rmt_PropertyGetDescription(rmtProperty* property);
rmtPropertyValue    _rmt_PropertyGetValue(rmtProperty* property);
]]

return remotery_lib