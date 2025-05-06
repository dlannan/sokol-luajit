local ffi  = require( "ffi" )

local libs = ffi_hmm_dll or {
   OSX     = { x64 = "hmm_dll_macos.so", arm64 = "hmm_dll_macos_arm64.so" },
   Windows = { x64 = "hmm_dll.dll" },
   Linux   = { x64 = "hmm_dll.so", arm = "hmm_dll.so" },
   BSD     = { x64 = "hmm_dll.so" },
   POSIX   = { x64 = "hmm_dll.so" },
   Other   = { x64 = "hmm_dll.so" },
}

local lib  = ffi_hmm_dll or libs[ ffi.os ][ ffi.arch ]
local hmm_lib   = ffi.load( lib )

ffi.cdef[[

/********** hmm_lib ****************************************************************/

typedef union hmm_vec2
{
    struct
    {
        float x, y;
    };

    struct
    {
        float X, Y;
    };

    struct
    {
        float U, V;
    };

    struct
    {
        float Left, Right;
    };
    
    struct
    {
        float Width, Height;
    };

    float Elements[2];
} hmm_vec2;

typedef union hmm_vec3
{
    struct
    {
        float x, y, z;
    };

    struct
    {
        float X, Y, Z;
    };

    struct
    {
        float U, V, W;
    };

    struct
    {
        float R, G, B;
    };

    struct
    {
        hmm_vec2 XY;
        float Ignored0_;
    };

    struct
    {
        float Ignored1_;
        hmm_vec2 YZ;
    };

    struct
    {
        hmm_vec2 UV;
        float Ignored2_;
    };

    struct
    {
        float Ignored3_;
        hmm_vec2 VW;
    };

    float Elements[3];
} hmm_vec3;

typedef union hmm_vec4
{
    struct
    {
        union
        {
            hmm_vec3 XYZ;
            struct
            {
                float X, Y, Z;
            };
            struct
            {
                float x, y, z;
            };        
        };

        float W;
    };
    struct
    {
        union
        {
            hmm_vec3 RGB;
            struct
            {
                float R, G, B;
            };
            struct
            {
                float x, y, z;
            };        
        };

        float A;
    };

    struct
    {
        hmm_vec2 XY;
        float Ignored0_;
        float Ignored1_;
    };

    struct
    {
        float Ignored2_;
        hmm_vec2 YZ;
        float Ignored3_;
    };

    struct
    {
        float Ignored4_;
        float Ignored5_;
        hmm_vec2 ZW;
    };

    float Elements[4];
} hmm_vec4;

typedef union hmm_mat4
{
    float Elements[4][4];

} hmm_mat4;

typedef union hmm_quaternion
{
    struct
    {
        union
        {
            hmm_vec3 XYZ;
            struct
            {
                float X, Y, Z;
            };
            struct
            {
                float x, y, z;
            };        
        };
        
        union
        {
            float W;
            float w;
        };
    };
    
    float Elements[4];
} hmm_quaternion;

typedef int32_t hmm_bool;

typedef hmm_vec2 hmm_v2;
typedef hmm_vec3 hmm_v3;
typedef hmm_vec4 hmm_v4;
typedef hmm_mat4 hmm_m4;    

float HMM_SinF(float Angle);
float HMM_TanF(float Angle);
float HMM_ATanF(float Theta);
float HMM_ATan2F(float Theta, float Theta2);
float HMM_CosF(float Angle);
float HMM_ACosF(float Theta);
float HMM_ExpF(float Float);
float HMM_LogF(float Float);

float HMM_ToRadians(float Degrees);
float HMM_SquareRootF(float Float);
float HMM_RSquareRootF(float Float);

float HMM_LengthSquaredVec2(hmm_vec2 A);
float HMM_LengthSquaredVec3(hmm_vec3 A);
float HMM_LengthSquaredVec4(hmm_vec4 A);

float HMM_LengthVec2(hmm_vec2 A);    
float HMM_LengthVec3(hmm_vec3 A);    
float HMM_LengthVec4(hmm_vec4 A);    

float HMM_Power(float Base, int Exponent);
float HMM_PowerF(float Base, float Exponent);
float HMM_Lerp(float A, float Time, float B);
float HMM_Clamp(float Min, float Value, float Max);

hmm_vec2 HMM_NormalizeVec2(hmm_vec2 A);
hmm_vec3 HMM_NormalizeVec3(hmm_vec3 A);
hmm_vec4 HMM_NormalizeVec4(hmm_vec4 A);

float HMM_DotVec2(hmm_vec2 VecOne, hmm_vec2 VecTwo);
float HMM_DotVec3(hmm_vec3 VecOne, hmm_vec3 VecTwo);
float HMM_DotVec4(hmm_vec4 VecOne, hmm_vec4 VecTwo);

hmm_vec3 HMM_Cross(hmm_vec3 VecOne, hmm_vec3 VecTwo);

hmm_vec2 HMM_Vec2(float X, float Y);
hmm_vec2 HMM_Vec2i(int X, int Y);
hmm_vec3 HMM_Vec3(float X, float Y, float Z);
hmm_vec3 HMM_Vec3i(int X, int Y, int Z);
hmm_vec4 HMM_Vec4(float X, float Y, float Z, float W);
hmm_vec4 HMM_Vec4i(int X, int Y, int Z, int W);
hmm_vec4 HMM_Vec4v(hmm_vec3 Vector, float W);

hmm_vec2 HMM_AddVec2(hmm_vec2 Left, hmm_vec2 Right);
hmm_vec3 HMM_AddVec3(hmm_vec3 Left, hmm_vec3 Right);
hmm_vec4 HMM_AddVec4(hmm_vec4 Left, hmm_vec4 Right);

hmm_vec2 HMM_SubtractVec2(hmm_vec2 Left, hmm_vec2 Right);
hmm_vec3 HMM_SubtractVec3(hmm_vec3 Left, hmm_vec3 Right);
hmm_vec4 HMM_SubtractVec4(hmm_vec4 Left, hmm_vec4 Right);

hmm_vec2 HMM_MultiplyVec2(hmm_vec2 Left, hmm_vec2 Right);
hmm_vec2 HMM_MultiplyVec2f(hmm_vec2 Left, float Right);
hmm_vec3 HMM_MultiplyVec3(hmm_vec3 Left, hmm_vec3 Right);
hmm_vec3 HMM_MultiplyVec3f(hmm_vec3 Left, float Right);
hmm_vec4 HMM_MultiplyVec4(hmm_vec4 Left, hmm_vec4 Right);
hmm_vec4 HMM_MultiplyVec4f(hmm_vec4 Left, float Right);

hmm_vec2 HMM_DivideVec2(hmm_vec2 Left, hmm_vec2 Right);
hmm_vec2 HMM_DivideVec2f(hmm_vec2 Left, float Right);
hmm_vec3 HMM_DivideVec3(hmm_vec3 Left, hmm_vec3 Right);
hmm_vec3 HMM_DivideVec3f(hmm_vec3 Left, float Right);
hmm_vec4 HMM_DivideVec4(hmm_vec4 Left, hmm_vec4 Right);
hmm_vec4 HMM_DivideVec4f(hmm_vec4 Left, float Right);

hmm_bool HMM_EqualsVec2(hmm_vec2 Left, hmm_vec2 Right);
hmm_bool HMM_EqualsVec3(hmm_vec3 Left, hmm_vec3 Right);
hmm_bool HMM_EqualsVec4(hmm_vec4 Left, hmm_vec4 Right);

hmm_mat4 HMM_Mat4(void);
hmm_mat4 HMM_Mat4d(float Diagonal);
hmm_mat4 HMM_AddMat4(hmm_mat4 Left, hmm_mat4 Right);
hmm_mat4 HMM_SubtractMat4(hmm_mat4 Left, hmm_mat4 Right);

hmm_mat4 HMM_MultiplyMat4(hmm_mat4 Left, hmm_mat4 Right);
hmm_mat4 HMM_MultiplyMat4f(hmm_mat4 Matrix, float Scalar);
hmm_vec4 HMM_MultiplyMat4ByVec4(hmm_mat4 Matrix, hmm_vec4 Vector);
hmm_mat4 HMM_DivideMat4f(hmm_mat4 Matrix, float Scalar);

hmm_mat4 HMM_Transpose(hmm_mat4 Matrix);

hmm_mat4 HMM_Orthographic(float Left, float Right, float Bottom, float Top, float Near, float Far);
hmm_mat4 HMM_Perspective(float FOV, float AspectRatio, float Near, float Far);

hmm_mat4 HMM_Translate(hmm_vec3 Translation);
hmm_mat4 HMM_Rotate(float Angle, hmm_vec3 Axis);
hmm_mat4 HMM_Scale(hmm_vec3 Scale);

hmm_mat4 HMM_LookAt(hmm_vec3 Eye, hmm_vec3 Center, hmm_vec3 Up);

hmm_quaternion HMM_Quaternion(float X, float Y, float Z, float W);
hmm_quaternion HMM_QuaternionV4(hmm_vec4 Vector);
hmm_quaternion HMM_AddQuaternion(hmm_quaternion Left, hmm_quaternion Right);
hmm_quaternion HMM_SubtractQuaternion(hmm_quaternion Left, hmm_quaternion Right);
hmm_quaternion HMM_MultiplyQuaternion(hmm_quaternion Left, hmm_quaternion Right);
hmm_quaternion HMM_MultiplyQuaternionF(hmm_quaternion Left, float Multiplicative);
hmm_quaternion HMM_DivideQuaternionF(hmm_quaternion Left, float Dividend);
hmm_quaternion HMM_InverseQuaternion(hmm_quaternion Left);
float HMM_DotQuaternion(hmm_quaternion Left, hmm_quaternion Right);
hmm_quaternion HMM_NormalizeQuaternion(hmm_quaternion Left);
hmm_quaternion HMM_NLerp(hmm_quaternion Left, float Time, hmm_quaternion Right);
hmm_quaternion HMM_Slerp(hmm_quaternion Left, float Time, hmm_quaternion Right);
hmm_mat4 HMM_QuaternionToMat4(hmm_quaternion Left);
hmm_quaternion HMM_QuaternionFromAxisAngle(hmm_vec3 Axis, float AngleOfRotation);

]]

return hmm_lib