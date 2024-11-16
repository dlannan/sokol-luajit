local ffi  = require( "ffi" )

local sokol_filename = _G.SOKOL_DLL or "sokol_dll"
local libs = ffi_sokol_libs or {
   OSX     = { x64 = "lib"..sokol_filename.."_macos.so" },
   Windows = { x64 = sokol_filename..".dll" },
   Linux   = { x64 = sokol_filename..".so", arm = sokol_filename..".so" },
   BSD     = { x64 = sokol_filename..".so" },
   POSIX   = { x64 = sokol_filename..".so" },
   Other   = { x64 = sokol_filename..".so" },
}

local lib  = ffi_sokol_libs or libs[ ffi.os ][ ffi.arch ]
local sokol_libs   = ffi.load( lib )

ffi.cdef[[

/********** sokol_args ****************************************************************/

/*
    sargs_allocator

    Used in sargs_desc to provide custom memory-alloc and -free functions
    to sokol_args.h. If memory management should be overridden, both the
    alloc_fn and free_fn function must be provided (e.g. it's not valid to
    override one function but not the other).
*/
typedef struct sargs_allocator {
   void* (*alloc_fn)(size_t size, void* user_data);
   void (*free_fn)(void* ptr, void* user_data);
   void* user_data;
} sargs_allocator;

typedef struct sargs_desc {
   int argc;
   char** argv;
   int max_args;
   int buf_size;
   sargs_allocator allocator;
} sargs_desc;

/* setup sokol-args */
void sargs_setup(const sargs_desc* desc);
/* shutdown sokol-args */
void sargs_shutdown(void);
/* true between sargs_setup() and sargs_shutdown() */
bool sargs_isvalid(void);
/* test if an argument exists by key name */
bool sargs_exists(const char* key);
/* get value by key name, return empty string if key doesn't exist or an existing key has no value */
const char* sargs_value(const char* key);
/* get value by key name, return provided default if key doesn't exist or has no value */
const char* sargs_value_def(const char* key, const char* def);
/* return true if val arg matches the value associated with key */
bool sargs_equals(const char* key, const char* val);
/* return true if key's value is "true", "yes", "on" or an existing key has no value */
bool sargs_boolean(const char* key);
/* get index of arg by key name, return -1 if not exists */
int sargs_find(const char* key);
/* get number of parsed arguments */
int sargs_num_args(void);
/* get key name of argument at index, or empty string */
const char* sargs_key_at(int index);
/* get value string of argument at index, or empty string */
const char* sargs_value_at(int index);

/********** sokol_audio ****************************************************************/

/*
    saudio_logger

    Used in saudio_desc to provide a custom logging and error reporting
    callback to sokol-audio.
*/
typedef struct saudio_logger {
   void (*func)(
       const char* tag,                // always "saudio"
       uint32_t log_level,             // 0=panic, 1=error, 2=warning, 3=info
       uint32_t log_item_id,           // SAUDIO_LOGITEM_*
       const char* message_or_null,    // a message string, may be nullptr in release mode
       uint32_t line_nr,               // line number in sokol_audio.h
       const char* filename_or_null,   // source filename, may be nullptr in release mode
       void* user_data);
   void* user_data;
} saudio_logger;

/*
   saudio_allocator

   Used in saudio_desc to provide custom memory-alloc and -free functions
   to sokol_audio.h. If memory management should be overridden, both the
   alloc_fn and free_fn function must be provided (e.g. it's not valid to
   override one function but not the other).
*/
typedef struct saudio_allocator {
   void* (*alloc_fn)(size_t size, void* user_data);
   void (*free_fn)(void* ptr, void* user_data);
   void* user_data;
} saudio_allocator;

typedef struct saudio_desc {
   int sample_rate;        // requested sample rate
   int num_channels;       // number of channels, default: 1 (mono)
   int buffer_frames;      // number of frames in streaming buffer
   int packet_frames;      // number of frames in a packet
   int num_packets;        // number of packets in packet queue
   void (*stream_cb)(float* buffer, int num_frames, int num_channels);  // optional streaming callback (no user data)
   void (*stream_userdata_cb)(float* buffer, int num_frames, int num_channels, void* user_data); //... and with user data
   void* user_data;        // optional user data argument for stream_userdata_cb
   saudio_allocator allocator;     // optional allocation override functions
   saudio_logger logger;           // optional logging function (default: NO LOGGING!)
} saudio_desc;

/* setup sokol-audio */
void saudio_setup(const saudio_desc* desc);
/* shutdown sokol-audio */
void saudio_shutdown(void);
/* true after setup if audio backend was successfully initialized */
bool saudio_isvalid(void);
/* return the saudio_desc.user_data pointer */
void* saudio_userdata(void);
/* return a copy of the original saudio_desc struct */
saudio_desc saudio_query_desc(void);
/* actual sample rate */
int saudio_sample_rate(void);
/* return actual backend buffer size in number of frames */
int saudio_buffer_frames(void);
/* actual number of channels */
int saudio_channels(void);
/* return true if audio context is currently suspended (only in WebAudio backend, all other backends return false) */
bool saudio_suspended(void);
/* get current number of frames to fill packet queue */
int saudio_expect(void);
/* push sample frames from main thread, returns number of frames actually pushed */
int saudio_push(const float* frames, int num_frames);

/********** sokol_fetch ****************************************************************/


/*
    sfetch_logger_t

    Used in sfetch_desc_t to provide a custom logging and error reporting
    callback to sokol-fetch.
*/
typedef struct sfetch_logger_t {
   void (*func)(
       const char* tag,                // always "sfetch"
       uint32_t log_level,             // 0=panic, 1=error, 2=warning, 3=info
       uint32_t log_item_id,           // SFETCH_LOGITEM_*
       const char* message_or_null,    // a message string, may be nullptr in release mode
       uint32_t line_nr,               // line number in sokol_fetch.h
       const char* filename_or_null,   // source filename, may be nullptr in release mode
       void* user_data);
   void* user_data;
} sfetch_logger_t;

/*
   sfetch_range_t

   A pointer-size pair struct to pass memory ranges into and out of sokol-fetch.
   When initialized from a value type (array or struct) you can use the
   SFETCH_RANGE() helper macro to build an sfetch_range_t struct.
*/
typedef struct sfetch_range_t {
   const void* ptr;
   size_t size;
} sfetch_range_t;

/*
   sfetch_allocator_t

   Used in sfetch_desc_t to provide custom memory-alloc and -free functions
   to sokol_fetch.h. If memory management should be overridden, both the
   alloc and free function must be provided (e.g. it's not valid to
   override one function but not the other).
*/
typedef struct sfetch_allocator_t {
   void* (*alloc_fn)(size_t size, void* user_data);
   void (*free_fn)(void* ptr, void* user_data);
   void* user_data;
} sfetch_allocator_t;

/* configuration values for sfetch_setup() */
typedef struct sfetch_desc_t {
   uint32_t max_requests;          // max number of active requests across all channels (default: 128)
   uint32_t num_channels;          // number of channels to fetch requests in parallel (default: 1)
   uint32_t num_lanes;             // max number of requests active on the same channel (default: 1)
   sfetch_allocator_t allocator;   // optional memory allocation overrides (default: malloc/free)
   sfetch_logger_t logger;         // optional log function overrides (default: NO LOGGING!)
} sfetch_desc_t;

/* a request handle to identify an active fetch request, returned by sfetch_send() */
typedef struct sfetch_handle_t { uint32_t id; } sfetch_handle_t;

/* error codes */
typedef enum sfetch_error_t {
   SFETCH_ERROR_NO_ERROR,
   SFETCH_ERROR_FILE_NOT_FOUND,
   SFETCH_ERROR_NO_BUFFER,
   SFETCH_ERROR_BUFFER_TOO_SMALL,
   SFETCH_ERROR_UNEXPECTED_EOF,
   SFETCH_ERROR_INVALID_HTTP_STATUS,
   SFETCH_ERROR_CANCELLED
} sfetch_error_t;

/* the response struct passed to the response callback */
typedef struct sfetch_response_t {
   sfetch_handle_t handle;         // request handle this response belongs to
   bool dispatched;                // true when request is in DISPATCHED state (lane has been assigned)
   bool fetched;                   // true when request is in FETCHED state (fetched data is available)
   bool paused;                    // request is currently in paused state
   bool finished;                  // this is the last response for this request
   bool failed;                    // request has failed (always set together with 'finished')
   bool cancelled;                 // request was cancelled (always set together with 'finished')
   sfetch_error_t error_code;      // more detailed error code when failed is true
   uint32_t channel;               // the channel which processes this request
   uint32_t lane;                  // the lane this request occupies on its channel
   const char* path;               // the original filesystem path of the request
   void* user_data;                // pointer to read/write user-data area
   uint32_t data_offset;           // current offset of fetched data chunk in the overall file data
   sfetch_range_t data;            // the fetched data as ptr/size pair (data.ptr == buffer.ptr, data.size <= buffer.size)
   sfetch_range_t buffer;          // the user-provided buffer which holds the fetched data
} sfetch_response_t;

/* request parameters passed to sfetch_send() */
typedef struct sfetch_request_t {
   uint32_t channel;                                // index of channel this request is assigned to (default: 0)
   const char* path;                                // filesystem path or HTTP URL (required)
   void (*callback) (const sfetch_response_t*);     // response callback function pointer (required)
   uint32_t chunk_size;                             // number of bytes to load per stream-block (optional)
   sfetch_range_t buffer;                           // a memory buffer where the data will be loaded into (optional)
   sfetch_range_t user_data;                        // ptr/size of a POD user data block which will be memcpy'd (optional)
} sfetch_request_t;


/* setup sokol-fetch (can be called on multiple threads) */
void sfetch_setup(const sfetch_desc_t* desc);
/* discard a sokol-fetch context */
void sfetch_shutdown(void);
/* return true if sokol-fetch has been setup */
bool sfetch_valid(void);
/* get the desc struct that was passed to sfetch_setup() */
sfetch_desc_t sfetch_desc(void);
/* return the max userdata size in number of bytes (SFETCH_MAX_USERDATA_UINT64 * sizeof(uint64_t)) */
int sfetch_max_userdata_bytes(void);
/* return the value of the SFETCH_MAX_PATH implementation config value */
int sfetch_max_path(void);

/* send a fetch-request, get handle to request back */
sfetch_handle_t sfetch_send(const sfetch_request_t* request);
/* return true if a handle is valid *and* the request is alive */
bool sfetch_handle_valid(sfetch_handle_t h);
/* do per-frame work, moves requests into and out of IO threads, and invokes response-callbacks */
void sfetch_dowork(void);

/* bind a data buffer to a request (request must not currently have a buffer bound, must be called from response callback */
void sfetch_bind_buffer(sfetch_handle_t h, sfetch_range_t buffer);
/* clear the 'buffer binding' of a request, returns previous buffer pointer (can be 0), must be called from response callback */
void* sfetch_unbind_buffer(sfetch_handle_t h);
/* cancel a request that's in flight (will call response callback with .cancelled + .finished) */
void sfetch_cancel(sfetch_handle_t h);
/* pause a request (will call response callback each frame with .paused) */
void sfetch_pause(sfetch_handle_t h);
/* continue a paused request */
void sfetch_continue(sfetch_handle_t h);

/********** sokol_glue ****************************************************************/

sg_environment sglue_environment(void);
sg_swapchain sglue_swapchain(void);

/********** sokol_log ****************************************************************/

void slog_func(const char* tag, uint32_t log_level, uint32_t log_item, const char* message, uint32_t line_nr, const char* filename, void* user_data);

/********** sokol_time ****************************************************************/

void stm_setup(void);
uint64_t stm_now(void);
uint64_t stm_diff(uint64_t new_ticks, uint64_t old_ticks);
uint64_t stm_since(uint64_t start_ticks);
uint64_t stm_laptime(uint64_t* last_time);
uint64_t stm_round_to_common_refresh_rate(uint64_t frame_ticks);
double stm_sec(uint64_t ticks);
double stm_ms(uint64_t ticks);
double stm_us(uint64_t ticks);
double stm_ns(uint64_t ticks);

]]

return sokol_libs