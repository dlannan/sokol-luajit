-- TODO: Clean this up - this is a port of the defold geomextension addon in C++

local tinsert       = table.insert

ffi.cdef[[
    typedef struct Vec3 {
        float x, y, z;
    } Vec3;
    
    typedef struct Matrix4      float[16];

    typedef struct Ray {
        Vec3 position;
        Vec3 direction;
    } Ray;
    
    typedef struct AABB {
        Vec3        min;
        Vec3        max;
        uint64_t    tag;
        Matrix4    mat;
    } AABB;
    
    typedef struct OBB {
        Vec3        center;
        Vec3        axis[3];
        Vec3        extents;
        uint64_t    tag;
        Matrix4     mat;
    } OBB;
]]

local g_bounds = {}

-- // --- Scale a vector to unit length (1).
-- // -- @tparam vec3 a vector to normalize
-- // -- @treturn vec3 out
local function normalize(a)

	if( a.x == 0.0f && a.y == 0.0f && a.z == 0.0f)
		return a;

    local vlen = math.sqrt(a.x * a.x + a.y * a.y + a.z * a.z)
    local invlen = 1.0 / vlen
	return ffi.new("Vec3", ( a.x * invlen, a.y * invlen, a.z * invlen) )
end

local function dot(a, b) 
    return (a.x * b.x + a.y * b.y + a.z * b.z)
end

-- // -- http://gamedev.stackexchange.com/a/18459
-- // -- ray.position  is a vec3
-- // -- ray.direction is a vec3
-- // -- aabb.min      is a vec3
-- // -- aabb.max      is a vec3
-- // -- distance is a pointer to a number 
local function intersect( ray, aabb, distance)

    local dir     = normalize(ray.direction)
	local dirfrac = ffi.new("Vec3", {
		1.0f / dir.x,
		1.0f / dir.y,
		1.0f / dir.z
	})

	local t1 = (aabb.min.x - ray.position.x) * dirfrac.x
	local t2 = (aabb.max.x - ray.position.x) * dirfrac.x
	local t3 = (aabb.min.y - ray.position.y) * dirfrac.y
	local t4 = (aabb.max.y - ray.position.y) * dirfrac.y
	local t5 = (aabb.min.z - ray.position.z) * dirfrac.z
	local t6 = (aabb.max.z - ray.position.z) * dirfrac.z

	local tmin = math.max(math.max(math.min(t1, t2), math.min(t3, t4)), math.min(t5, t6))
	local tmax = math.min(math.min(math.max(t1, t2), math.max(t3, t4)), math.max(t5, t6))

	-- // -- ray is intersecting AABB, but whole AABB is behind us
	if (tmax < 0.0) then return false end

	-- // -- ray does not intersect AABB
	if (tmin > tmax) then return false end

	-- // -- Return collision po int and distance from ray origin
    local dx = ray.position.x + ray.direction.x * tmin
    local dy = ray.position.y + ray.direction.y * tmin
    local dz = ray.position.z + ray.direction.z * tmin
	distance = sqrt( dx * dx + dy * dy + dz * dz)
    return true
end

local function  intersectOBB( ray, obb, distance)

    local O 		= ray.position -- // Line origin    
    local D 		= ray.direction -- // Line direction    
    
    local C  		= obb.center --  // Box center    
    local bbmin 	= obb.axis[0]
    local bbmax 	= obb.axis[1]
    local e  		= obb.extents -- // Box extents    

	-- // Intersection method from Real-Time Rendering and Essential Mathematics for Games
	
	local tMin = 0.0
	local tMax = 100000.0

	local delta = ffi.new("Vec3", {C.x - O.x, C.y - O.y, C.z - O.z})

	-- // Test intersection with the 2 planes perpendicular to the OBB's X axis
	
    local xaxis = ffi.new("Vec3", {obb.mat[0][0], obb.mat[0][1], obb.mat[0][2]})
    local e = dot(xaxis, delta)
    local f = dot(ray.direction, xaxis)

    if ( math.abs(f) > 0.001 ) then -- // Standard case

        local t1 = (e+bbmin.x)/f -- // Intersection with the "left" plane
        local t2 = (e+bbmax.x)/f -- // Intersection with the "right" plane
        -- // t1 and t2 now contain distances betwen ray origin and ray-plane intersections

        -- // We want t1 to represent the nearest intersection, 
        -- // so if it's not the case, invert t1 and t2
        if (t1>t2) then
            local w=t1;t1=t2;t2=w; -- // swap t1 and t2
        end

        -- // tMax is the nearest "far" intersection (amongst the X,Y and Z planes pairs)
        if ( t2 < tMax )
            tMax = t2;
        -- // tMin is the farthest "near" intersection (amongst the X,Y and Z planes pairs)
        if ( t1 > tMin )
            tMin = t1;

        -- // And here's the trick :
        -- // If "far" is closer than "near", then there is NO intersection.
        -- // See the images in the tutorials for the visual explanation.
        if (tMax < tMin ) then 
            return false
        end

    else -- // Rare case : the ray is almost parallel to the planes, so they don't have any "intersection"
        if(-e+bbmin.x > 0.0 or -e+bbmax.x < 0.0 ) then
            return false
        end
    end

	-- // Test intersection with the 2 planes perpendicular to the OBB's Y axis
	-- // Exactly the same thing than above.
    local yaxis = ffi.new("Vec3", {obb.mat[1][0], obb.mat[1][1], obb.mat[1][2]})
    local e = dot(yaxis, delta)
    local f = dot(ray.direction, yaxis)

    if ( math.abs(f) > 0.001 ) then

        local t1 = (e+bbmin.y)/f
        local t2 = (e+bbmax.y)/f

        if (t1>t2) then local w=t1;t1=t2;t2=w; end

        if ( t2 < tMax ) then 
            tMax = t2
        end
        if ( t1 > tMin ) then 
            tMin = t1
        end
        if (tMin > tMax) then 
            return false
        end

    else
        if(-e+bbmin.y > 0.0 or -e+bbmax.y < 0.0) then 
            return false
        end
    end
	
	-- // Test intersection with the 2 planes perpendicular to the OBB's Z axis
	-- // Exactly the same thing than above.
	
    local zaxis = ffi.new("Vec3", {obb.mat[2][0], obb.mat[2][1], obb.mat[2][2]})
    local e = dot(zaxis, delta)
    local f = dot(ray.direction, zaxis)

    if ( math.abs(f) > 0.001 ) then

        local t1 = (e+bbmin.z)/f
        local t2 = (e+bbmax.z)/f

        if (t1>t2) then local w=t1;t1=t2;t2=w; end

        if ( t2 < tMax ) then 
            tMax = t2
        end
        if ( t1 > tMin ) then
            tMin = t1
        end
        if (tMin > tMax) then 
            return false
        end

    else
        if(-e+bbmin.z > 0.0 || -e+bbmax.z < 0.0) then 
            return false
        end 
    end

	distance = tMin
	return true
end

local function AddBoundingBox(vmin, vmax, tag)

    local obb = {}
    local center = ffi.new("Vec3", 
        {
            (vmax.x - vmin.x) * 0.5 + vmin.x,
            (vmax.y - vmin.y) * 0.5 + vmin.y,
            (vmax.z - vmin.z) * 0.5 + vmin.z,
        })
    local extents = ffi.new("Vec3", {
        (vmax.x - vmin.x) * 0.5,
        (vmax.y - vmin.y) * 0.5,
        (vmax.z - vmin.z) * 0.5
    })

    obb.axis.x     = ffi.new("Vec3", {vmin.x,vmin.y,vmin.z})
    obb.axis.y     = ffi.new("Vec3", {vmax.x,vmax.y,vmax.z})

    obb.center = ffi.new("Vec3", {center.x, center.y, centerz})
    obb.extents = ffi.new("Vec3", {extents.x, extents.y, extents.z})
    obb.tag = tag
    tinsert(g_bounds, obb)
    return #g_bounds-1
end

-- // Recal OOBB - rotations and translations may change min and max values.
local function MultWorld( obb )

    local out = ffi.new("OBB")
    -- // for(i=0; i<3; ++i) {
    -- //     dmVMath::Vector4 res = obb.mat * dmVMath::Vector4(obb.axis[i].x, obb.axis[i].y, obb.axis[i].z);
    -- //     out.axis[i] = Vec3(res[0], res[1], res[2]);
    -- // }
    out.mat = obb.mat
    out.axis.x = obb.axis.x
    out.axis.y = obb.axis.y
    -- // dmVMath::Vector4 res = obb.mat * dmVMath::Vector4(obb.center.x, obb.center.y, obb.center.z, 1.0);
    out.center = ffi.new("Vec3", {obb.mat[3][0], obb.mat[3][1], obb.mat[3][2]})
    out.extents = obb.extents
    out.tag = obb.tag
    return out
end

local function RaycastToBox( x1, y1, z1, x2, y2, z2)

    local ray = ffi.new("Ray", { {x1, y1, z1}, {x2, y2, z2} })

    -- // Go through boxes checking hits. Closest hit wins!
    local distance = ffi.new("float[1]", { {math.huge} })
    local closest = math.huge
    local hitbox = -1
    local hitpoint = ffi.new("Vec3")
    for i,bound in ipairs(g_bounds) do
        local testbox = MultWorld(bound)
        if( intersectOBB(ray, testbox, distance ) ) then
            if(distance[0] < closest) then
                closest = distance[0]
                hitbox = i
            end
        end
    end
    
    if(closest == math.huge) then
        return nil, nil, nil
    else 
        local hitpoint = ffi.new("Vec3", {
            ray.position.x + ray.direction.x * closest,
            ray.position.y + ray.direction.y * closest,
            ray.position.z + ray.direction.z * closest
        })
        return closest, g_bounds[hitbox].tag, hitpoint
    end
end

local function UpdateOBB( index, world )
    -- // Need to do some index checking here.
    g_bounds[index].mat = world
end

local SEED = 0
local hash = {208,34,231,213,32,248,233,56,161,78,24,140,71,48,140,254,245,255,247,247,40,
    185,248,251,245,28,124,204,204,76,36,1,107,28,234,163,202,224,245,128,167,204,
    9,92,217,54,239,174,173,102,193,189,190,121,100,108,167,44,43,77,180,204,8,81,
    70,223,11,38,24,254,210,210,177,32,81,195,243,125,8,169,112,32,97,53,195,13,
    203,9,47,104,125,117,114,124,165,203,181,235,193,206,70,180,174,0,167,181,41,
    164,30,116,127,198,245,146,87,224,149,206,57,4,192,210,65,210,129,240,178,105,
    228,108,245,148,140,40,35,195,38,58,65,207,215,253,65,85,208,76,62,3,237,55,89,
    232,50,217,64,244,157,199,121,252,90,17,212,203,149,152,140,187,234,177,73,174,
    193,100,192,143,97,53,145,135,19,103,13,90,135,151,199,91,239,247,33,39,145,
    101,120,99,3,186,86,99,41,237,203,111,79,220,135,158,42,30,154,120,67,87,167,
    135,176,183,191,253,115,184,21,233,58,129,233,142,39,128,211,118,137,139,255,
    114,20,218,113,154,27,127,246,250,1,8,198,250,209,92,222,173,21,88,102,219
}

local function noise2(x, y)
    local tmp = hash[(y + SEED) % 256 + 1]
    return hash[(tmp + x) % 256 + 1]
end

local function lin_inter(x, y, s)
    return x + s * (y-x);
end

local smooth_inter( x, y, s)
    return lin_inter(x, y, s * s * (3-2*s))
end

local noise2d( x, y)

    local x_int = x
    local y_int = y
    local x_frac = x - x_int
    local y_frac = y - y_int
    local s = noise2(x_int, y_int)
    local t = noise2(x_int+1, y_int)
    local u = noise2(x_int, y_int+1)
    local v = noise2(x_int+1, y_int+1)
    local low = smooth_inter(s, t, x_frac)
    local high = smooth_inter(u, v, x_frac)
    return smooth_inter(low, high, y_frac)
end

local perlin2d(x, y, freq, depth)
    local xa = x*freq;
    local ya = y*freq;
    local amp = 1.0;
    local fin = 0;
    local div = 0.0;

    local i;
    for i=0, depth-1 do
        div = div + 256 * amp;
        fin = fin + noise2d(xa, ya) * amp
        amp = amp / 2
        xa = xa * 2
        ya = ya * 2
    end

    return fin/div
end

return {
    normalize       = normalize,
    dot             = dot,
    intersect       = intersect,
    intersectOBB    = intersectOBB,

    AddBoundingBox  = AddBoundingBox,
    MultWorld       = MultWorld,
    RaycastToBox    = RaycastToBox,
    UpdateOBB       = UpdateOBB,

    noise2          = noise2,
    lin_inter       = lin_inter,
    smooth_inter    = smooth_inter,
}