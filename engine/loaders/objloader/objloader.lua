
local geom 			= require("lua.loaders.geometry-utils")
local meshes 		= require("lua.geometry.meshes")
local imageutils 	= require("lua.loaders.image-utils")

local hmm           = require("hmm")
local hutils        = require("hmm_utils")

local utils         = require("lua.utils")
local ffi           = require("ffi")

local tinsert       = table.insert 
local tremove       = table.remove

-- --------------------------------------------------------------------------------------

ffi.cdef[[
typedef struct {
    float x, y, z;
} Vertex;

typedef struct {
    float x, y, z;
} Normal;

typedef struct {
    float u, v;
} TexCoord;
]]

-- --------------------------------------------------------------------------------------

local loader = {

}

-- --------------------------------------------------------------------------------------

local fileparts = function( path )
    return string.match(path, "^(.-[\\/])([^\\/]-)%.([^\\/]+)$")
end

-- --------------------------------------------------------------------------------------

local function build_aabb(obj)

    assert(#obj.positions > 0, "OBJ contains no vertices")

    local first = obj.positions[1]

    local aabb = {
        min = {
            x = first.x,
            y = first.y,
            z = first.z,
        },
        max = {
            x = first.x,
            y = first.y,
            z = first.z,
        },
    }

    for i = 2, #obj.positions do
        local v = obj.positions[i]

        if v.x < aabb.min.x then aabb.min.x = v.x end
        if v.y < aabb.min.y then aabb.min.y = v.y end
        if v.z < aabb.min.z then aabb.min.z = v.z end

        if v.x > aabb.max.x then aabb.max.x = v.x end
        if v.y > aabb.max.y then aabb.max.y = v.y end
        if v.z > aabb.max.z then aabb.max.z = v.z end
    end

    return aabb
end

-- --------------------------------------------------------------------------------------

local function parse_vertex(token)
    local v, vt, vn

    v, vt, vn = token:match("^(%-?%d+)/(%-?%d+)/(%-?%d+)$")
    if v then
        return tonumber(v), tonumber(vt), tonumber(vn)
    end

    v, vt = token:match("^(%-?%d+)/(%-?%d+)$")
    if v then
        return tonumber(v), tonumber(vt), nil
    end

    v, vn = token:match("^(%-?%d+)//(%-?%d+)$")
    if v then
        return tonumber(v), nil, tonumber(vn)
    end

    return tonumber(token), nil, nil
end

-- --------------------------------------------------------------------------------------

local function build_mesh(obj)

    local mesh = {
        vertices = {},
        indices = {},
        parts = {},
    }

    local vertex_map = {}

    for _, object in ipairs(obj.objects) do
        for _, face in ipairs(object.faces) do

            -- We'll triangulate later.
            assert(#face == 3, "Only triangles currently supported")
            for _, token in ipairs(face) do

                local index = vertex_map[token]
                if not index then

                    local v, vt, vn = parse_vertex(token)
                    index = #mesh.vertices + 1
                    vertex_map[token] = index

                    mesh.vertices[index] = {
                        position = obj.positions[v],
                        texcoord = vt and obj.texcoords[vt] or nil,
                        normal = vn and obj.normals[vn] or nil,
                    }
                end

                mesh.indices[#mesh.indices + 1] = index
            end
        end
    end

    return mesh
end

-- --------------------------------------------------------------------------------------

local function calc_normals(obj)

    local normals = {}

    for i = 1, #obj.positions do
        normals[i] = {x=0, y=0, z=0}
    end

    for _, object in ipairs(obj.objects) do
        for _, face in ipairs(object.faces) do
            local i1, i2, i3 = tonumber(face[1]), tonumber(face[2]), tonumber(face[3])

            local v1 = obj.positions[i1]
            local v2 = obj.positions[i2]
            local v3 = obj.positions[i3]

            local e1x = v2.x - v1.x
            local e1y = v2.y - v1.y
            local e1z = v2.z - v1.z

            local e2x = v3.x - v1.x
            local e2y = v3.y - v1.y
            local e2z = v3.z - v1.z

            -- Cross product (not normalized)
            local nx = e1y * e2z - e1z * e2y
            local ny = e1z * e2x - e1x * e2z
            local nz = e1x * e2y - e1y * e2x

            normals[i1].x = normals[i1].x + nx
            normals[i1].y = normals[i1].y + ny
            normals[i1].z = normals[i1].z + nz

            normals[i2].x = normals[i2].x + nx
            normals[i2].y = normals[i2].y + ny
            normals[i2].z = normals[i2].z + nz

            normals[i3].x = normals[i3].x + nx
            normals[i3].y = normals[i3].y + ny
            normals[i3].z = normals[i3].z + nz
        end
    end

    for _, n in ipairs(normals) do
        local len = math.sqrt(n.x*n.x + n.y*n.y + n.z*n.z)

        if len > 0 then
            n.x = n.x / len
            n.y = n.y / len
            n.z = n.z / len
        end
    end
    return normals
end

-- --------------------------------------------------------------------------------------

local function triangulate(obj)
    local result = {
        mtllib    = obj.mtllib,
        positions = obj.positions,
        texcoords = obj.texcoords,
        normals   = obj.normals,
        objects   = {},
    }

    for _, object in ipairs(obj.objects) do

        local new_object = {
            name = object.name,
            faces = {},
        }

        for _, face in ipairs(object.faces) do

            if #face == 3 then

                table.insert(new_object.faces, face)

            elseif #face > 3 then

                -- Triangle fan:
                --
                -- 0,1,2
                -- 0,2,3
                -- 0,3,4
                --

                for i = 2, #face - 1 do
                    table.insert(new_object.faces, {
                        face[1],
                        face[i],
                        face[i + 1],
                    })
                end

            end
        end

        table.insert(result.objects, new_object)

    end

    return result
end

-- --------------------------------------------------------------------------------------

local function load_mtl(filename)

    local materials = {}
    local current = nil

    local fp = assert(io.open(filename, "r"))

    for line in fp:lines() do

        if line ~= "" and line:sub(1,1) ~= "#" then

            local cmd, args = line:match("^(%S+)%s*(.*)$")

            if cmd == "newmtl" then

                current = {
                    Ka = {0,0,0},
                    Kd = {0,0,0},
                    Ks = {0,0,0},

                    Ns = 0,
                    d = 1.0,
                }

                materials[args] = current

            elseif current then

                if cmd == "Ka" then

                    local r,g,b = args:match("(%S+)%s+(%S+)%s+(%S+)")
                    current.Ka = {tonumber(r), tonumber(g), tonumber(b)}

                elseif cmd == "Kd" then

                    local r,g,b = args:match("(%S+)%s+(%S+)%s+(%S+)")
                    current.Kd = {tonumber(r), tonumber(g), tonumber(b)}

                elseif cmd == "Ks" then

                    local r,g,b = args:match("(%S+)%s+(%S+)%s+(%S+)")
                    current.Ks = {tonumber(r), tonumber(g), tonumber(b)}

                elseif cmd == "Ns" then

                    current.Ns = tonumber(args)

                elseif cmd == "d" then

                    current.d = tonumber(args)

                elseif cmd == "map_Kd" then

                    current.map_Kd = args

                elseif cmd == "map_Bump" or cmd == "bump" then

                    current.map_Bump = args

                end

            end

        end

    end

    fp:close()

    return materials
end

-- --------------------------------------------------------------------------------------

local function load_obj(filename)
    local obj = {
        mtllibs = {},
        materials = {},
        textures = {},

        positions = {},
        texcoords = {},
        normals = {},

        objects = {},
    }

    local current = obj.objects[1]
    local fp = assert(io.open(filename, "r"))

    for line in fp:lines() do

        -- Ignore comments and blank lines.
        if line ~= "" and line:sub(1,1) ~= "#" then

            local cmd, args = line:match("^(%S+)%s*(.*)$")

            if cmd == "mtllib" then
                tinsert(obj.mtllibs, args)

            elseif cmd == "o" then

                current = {
                    name = args,
                    faces = {},
                }

                table.insert(obj.objects, current)

            elseif cmd == "v" then

                local x, y, z = args:match("(%S+)%s+(%S+)%s+(%S+)")

                table.insert(obj.positions, {
                    x = tonumber(x),
                    y = tonumber(y),
                    z = tonumber(z),
                })

            elseif cmd == "vt" then

                local u, v = args:match("(%S+)%s+(%S+)")

                table.insert(obj.texcoords, {
                    u = tonumber(u),
                    v = tonumber(v),
                })

            elseif cmd == "vn" then

                local x, y, z = args:match("(%S+)%s+(%S+)%s+(%S+)")

                table.insert(obj.normals, {
                    x = tonumber(x),
                    y = tonumber(y),
                    z = tonumber(z),
                })

            elseif cmd == "f" then

                local face = {}

                for vertex in args:gmatch("%S+") do
                    table.insert(face, vertex)
                end

                table.insert(current.faces, face)

            end
        end
    end

    fp:close()
    obj = triangulate(obj)

    -- Collate all the materials into a single map (name based)
    if(obj.mtllibs) then 
        for i, materialfilename in ipairs(obj.mtllibs) do
            local materials = load_mtl(materialfilename)
            for k,v in pairs(materials) do 
                obj.materials[k] = v 
                if(v.map_Kd) then obj.textures[v.map_Kd] = k end
                if(v.map_Bump) then obj.textures[v.map_Bump] = k end
                if(v.bump) then obj.textures[v.bump] = k end
            end
        end
    end

    if(#obj.normals == 0) then
        obj.normals = calc_normals(obj)
    end

    return obj
end

-- --------------------------------------------------------------------------------------

local function mesh_toffi(mesh)

    local out = {}

    out.vertex_count = #mesh.vertices
    out.index_count  = #mesh.indices
    out.vertices = ffi.new(
        "Vertex[?]",
        out.vertex_count
    )
    out.uvs = ffi.new(
        "TexCoord[?]",
        out.vertex_count
    )
    out.normals = ffi.new(
        "Normal[?]",
        out.vertex_count
    )
    out.indices = ffi.new(
        "uint32_t[?]",
        out.index_count
    )

    for i, v in ipairs(mesh.vertices) do

        local dstv = out.vertices[i-1]
        local dstn = out.normals[i-1]
        local dstuv = out.uvs[i-1]

        dstv.x = v.position.x
        dstv.y = v.position.y
        dstv.z = v.position.z

        if v.normal then
            dstn.x = v.normal.x
            dstn.y = v.normal.y
            dstn.z = v.normal.z
        else
            dstn.x = 0
            dstn.y = 0
            dstn.z = 0
        end

        if v.texcoord then
            dstuv.u = v.texcoord.u
            dstuv.v = v.texcoord.v
        else
            dstuv.u = 0
            dstuv.v = 0
        end
    end

    for i, index in ipairs(mesh.indices) do
        out.indices[i-1] = index - 1
    end

    out.transform = hmm.HMM_M4D(1.0) 

    return out
end

-- --------------------------------------------------------------------------------------

local function load_obj_asset( assetfilename, asset, disableaabb, bin_target )

    local basepath = assetfilename:match("(.*[\\/])")

    local obj = load_obj(assetfilename)
    local mesh = build_mesh(obj) 
    local cmesh = mesh_toffi(mesh)

	local model = {
		filename = assetfilename,
		basepath = basepath,
		data = mesh,
		all_geom = {},
        aabb = build_aabb(obj),
		stats = {
			vertices = cmesh.vertex_count,
			polys = 0,
			textures = utils.tcount(obj.textures),
			nodes = #obj.objects,
			primitives = #obj.objects,
		},
		counted = {},
		bin_target = bin_target,
	}    

    local primdata = {
        itype = sg.SG_INDEXTYPE_UINT32, 
        icount = cmesh.index_count,
        indices = cmesh.indices, 
        verts = cmesh.vertices,
        uvs = cmesh.uvs, 
        normals = cmesh.normals, 
    }

    model.stats.polys = model.stats.polys + primdata.icount / 3
    local mesh_buffers = geom:makeMesh( asset.name, primdata )
    if(mesh_buffers) then 
        local geom = geom:makeGeom(asset.name, cmesh, mesh_buffers, model.bin_target)
        tinsert(model.all_geom, geom)
        -- print("Added mesh buffer", prim.primmesh)
    end

    return model
end

-- --------------------------------------------------------------------------------------

loader.load_obj = function(filename, params)

    local dir, fname, extension = fileparts(filename)
    print(dir, fname, extension)
    local asset = {
        path = "",
        folder = dir,
        name = fname,
        asset = fname,
        format = extension
    }

	-- print(asset.path)
	-- print(asset.asset)
	-- print(asset.folder)
	-- print(asset.format)

	local assetfilename = filename
	local obj_data = load_obj_asset( assetfilename, asset, nil, params.bin_target )
    if(obj_data) then 
    	pprint("[Info] obj loaded: ", assetfilename)
    else
    	pprint("[Error] obj failed to load: ", assetfilename)
        return nil 
    end

    local ent = { 
		name = asset.name,
        id  = asset.go,
        model = nil,
        mesh = obj_data,
		pos = {0, 0, 0}, 
		rot = { 0, 0, 0}, 
		scale = {1, 1, 1},
		etype = asset.folder,
		filename = assetfilename,
		format = asset.format,
	} 

    if(params and params.on_load) then params.on_load(ent) end
    return ent
end

-- --------------------------------------------------------------------------------------

return loader

-- --------------------------------------------------------------------------------------