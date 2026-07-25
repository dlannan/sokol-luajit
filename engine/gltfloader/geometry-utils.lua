------------------------------------------------------------------------------------------------------------
--    /// Some default models so can easily do simple things
--    /// Also this is a reference for math generated geometry 
--    /// 

-- luajit helpers :) 
local tinsert 		= table.insert 
local tremove 		= table.remove

local ffi 			= require("ffi")
local utils 		= require("lua.utils")
local meshes		= require("lua.geometry.meshes")

local sapp          = require("sokol_app")
local slib      	= require("sokol_libs")

local hmm           = require("hmm")
local hutils        = require("hmm_utils")

local bins 			= require("lua.geometry.bins")

------------------------------------------------------------------------------------------------------------

local geom = {

	ctr 		= 0,
	meshes 		= {},

	all_objs    = {},
}

------------------------------------------------------------------------------------------------------------

local function makeMvp(rx, ry)
    
    local w         = sapp.sapp_widthf()
    local h         = sapp.sapp_heightf()
    local t         = (sapp.sapp_frame_duration() * 60.0)

    local proj      = hmm.HMM_Perspective(60.0, w/h, 0.01, 10.0)
    local view      = hmm.HMM_LookAt(hmm.HMM_Vec3(0.0, 1.5, 6.0), hmm.HMM_Vec3(0.0, 0.0, 0.0), hmm.HMM_Vec3(0.0, 1.0, 0.0))
    local view_proj = hmm.HMM_MultiplyMat4(proj, view)

    local rxm       = hmm.HMM_Rotate(rx, hmm.HMM_Vec3(1.0, 0.0, 0.0))
    local rym       = hmm.HMM_Rotate(ry, hmm.HMM_Vec3(0.0, 1.0, 0.0))
    local model     = hmm.HMM_MultiplyMat4(rxm, rym)

    local mvp       = hmm.HMM_MultiplyMat4(view_proj, model)
    return mvp
end

------------------------------------------------------------------------------------------------------------
-- Bin related code
function geom:makeGeom(name, prim, mesh)

	-- TODO: Needs to come from gltf refs
	local material    = meshes.material(name, "lua/engine/base_texture.glsl", {})
	local prim_mat    = prim.material

	local newgeom = {}
	newgeom.id 			= #geom.all_objs + 1
	newgeom.model 		= meshes.model(name, prim, mesh, material)
	newgeom.transform 	= prim.transform

	newgeom.pip        = newgeom.model.pip 
	newgeom.bind       = newgeom.model.bind
	newgeom.rx = 0
	newgeom.ry = 0

	local bcolor = prim_mat.base_color or { 1, 1, 1, 1 }

	newgeom.vs_params = ffi.new("vs_params_t[1]")
	newgeom.vs_params[0].mvp    = makeMvp(0.0, 0.0)
	newgeom.vs_params[0].base_color_factor    = 	ffi.new("float [4]", {
		bcolor[1], bcolor[2], bcolor[3], bcolor[4]
	})

	newgeom.vs_sg_range = ffi.new("sg_range[1]")
	newgeom.vs_sg_range[0].ptr     = newgeom.vs_params
	newgeom.vs_sg_range[0].size    = ffi.sizeof(newgeom.vs_params[0])

	newgeom.fs_params = ffi.new("fs_params_t[1]")
	newgeom.fs_params[0].alpha_cutoff   = newgeom.model.alpha.cutoff or 0.0
	newgeom.fs_params[0].alpha_mode     = newgeom.model.alpha.mode or 0

	newgeom.fs_sg_range = ffi.new("sg_range[1]")
	newgeom.fs_sg_range[0].ptr     = newgeom.fs_params
	newgeom.fs_sg_range[0].size    = ffi.sizeof(newgeom.fs_params[0])

	newgeom.offset     = 0
	newgeom.count      = prim.index_count 
	newgeom.instances  = 1

	newgeom.bintype    = bins.BTYPE_OPAQUE

	tinsert(geom.all_objs, newgeom)

	newgeom.binid = bins.bin_add(newgeom)
	newgeom.pass = {
		action      =  sg.SG_LOADACTION_CLEAR,
		clear       = { 0.25, 0.5, 0.75, 1.0 },
		swapchain   = slib.sglue_swapchain(),
	}
	
	bins.pass_add(newgeom.pass, newgeom.binid, true)
	return newgeom.id
end

------------------------------------------------------------------------------------------------------------
-- AABB param is a table with siz values (min.max) like: { 0, 0, 0, 1, 1, 1 }
function geom:makeMesh( goname, primdata )

	local itype 	= primdata.itype
	local icount 	= primdata.icount
	local indices 	= primdata.indices
	local verts 	= primdata.verts
	local uvs 		= primdata.uvs
	local normals 	= primdata.normals
	local aabb 		= primdata.aabb

	if(verts == nil) then
		print("[Error geom:makeMesh] No valid vertices?")
		return nil
	end 
	if(type(goname) == "cdata") then goname = ffi.string(goname) end

	local buffers 		= {}
	buffers.itype 		= itype
	buffers.icount 		= icount
	buffers.vertices 	= verts

	if(indices) then 
		buffers.indices = indices
	end 
	if(uvs) then 
		buffers.uvs = uvs
	end 
	if(normals) then 
		buffers.normals = normals
	end 
	
	local buffs =  meshes.create_buffer(goname, buffers)
	if(buffs == nil) then return nil end -- Dont process missing buffers!

	-- Fill out some manual defaults in the buffs
    -- buffs.index_type = itype
    buffs.cullmode = sg.SG_CULLMODE_BACK
    buffs.depth.write_enabled = true
    buffs.depth.compare = sg.SG_COMPAREFUNC_LESS_EQUAL

	local mesh = meshes.make_mesh(goname, {buffs})

	geom.meshes[goname] = mesh
	geom.ctr = geom.ctr + 1

	mesh.count = icount

	return mesh
end

------------------------------------------------------------------------------------------------------------

function geom:New(goname, sz)

	local props = {}
	props[goname] = { }
end

------------------------------------------------------------------------------------------------------------

function geom:GetMesh(goname)

	return self.meshes[goname]
end

------------------------------------------------------------------------------------------------------------

function geom:GenerateCube(goname, sz, d )

	geom:New(goname, 1.0)
	tinsert(self.meshes, goname)

	local verts = {}
	local indices = {} 
	local normals = {}
	local uvs = {}			-- TODO - generate UVS

	local vcount = 1
	local ucount = 1
	local ncount = 1
	local icount = 1
	local index = 1

	-- Start with a cube. Then for number x/y sizes iterate each side of the cube
	-- For each side of the cube cal vert trace back to center of cube, then recalc vert based on radius.
	-- Collect verts in order, making triangles along the way	

	local targets = {  
		[1] = function( a, b ) return { a, -sz, b, -1, 0.25, 0.333, 0, -1, 0 }; end,
		[2] = function( a, b ) return { a, b, -sz, 1, 0.0, 0.333, 0, 0, -1 }; end,
		[3] = function( a, b ) return { a, b, sz, -1, 0.25, 0.333, 0, 0, 1 }; end,
		[4] = function( a, b ) return { -sz, b, a, -1, 0.25, 0.333, -1, 0, 0 }; end,
		[5] = function( a, b ) return { sz, b, a, 1, 0.0, 0.333, 1, 0, 0 }; end,
		[6] = function( a, b ) return { a, sz, b, 1, 0.0, 0.333, 0, 1, 0 }; end
	}

	local startuvs = {
		[1] = { 0.25, 0.666 },		-- Ground
		[2] = { 0.25, 0.333 },		-- Front
		[3] = { 0.75, 0.333 },		-- Back
		[4] = { 0.0, 0.333 },		-- Left
		[5] = { 0.5, 0.333 },		-- Right
		[6] = { 0.25, 0.0 }			-- Sky
	}

	function make_vert( icount, f, uv1, uv2, uv1fac, uv2fac, sz)

		tinsert(indices, icount)
		tinsert(verts, f[1])
		tinsert(verts, f[2])
		tinsert(verts, f[3])
		tinsert(normals, f[7])
		tinsert(normals, f[8])
		tinsert(normals, f[9])
		tinsert(uvs, uv1 + f[5] + f[4] * uv1fac)
		tinsert(uvs, uv2 + f[6] - uv2fac)

		index 	= #indices + 1
		vcount 	= #verts + 1
		ucount 	= #uvs + 1
		ncount 	= #normals + 1
	end	
		
	local stepsize = sz * 2 / d
	for key, func in ipairs(targets) do

		local uv1 = startuvs[key][1]
		local vstep = 1.0 / d

		local amult = 1.0 / ( 2.005 * sz * 4.0 )
		local bmult = 1.0 / ( 2.005 * sz * 3.0 )

		for a = -sz, sz-stepsize, stepsize do

			local uv2 = startuvs[key][2]
			for b = -sz, sz-stepsize, stepsize do

				local switch = false
				if(key == 3 or key == 4 or key == 1) then switch = true end

				if(switch == false) then 
					local v = func(a, b)
					make_vert(icount, v, uv1, uv2, (a + sz) * amult, (b + sz) * bmult)
					local x = func(a+stepsize, b)
					make_vert(icount-1, x, uv1, uv2, (a + sz + stepsize) * amult, (b + sz) * bmult)

				else 
					local x = func(a+stepsize, b)
					make_vert(icount, x, uv1, uv2, (a + sz + stepsize) * amult, (b + sz) * bmult)
					local v = func(a, b)
					make_vert(icount-1, v, uv1, uv2, (a + sz) * amult, (b + sz) * bmult)
				end				

				local w = func(a, b+stepsize)
				make_vert(icount+1, w, uv1, uv2, (a + sz) * amult, (b + sz + stepsize) * bmult)
								
				if(switch == false) then 
					local x = func(a+stepsize, b)
					make_vert(icount+3, x, uv1, uv2, (a + sz + stepsize) * amult,  (b + sz) * bmult)
					local y = func(a+stepsize,b+stepsize)
					make_vert(icount+2, y, uv1, uv2, (a + sz + stepsize) * amult,  (b + sz + stepsize) * bmult)
				else 
					local y = func(a+stepsize,b+stepsize)
					make_vert(icount+3, y, uv1, uv2, (a + sz + stepsize) * amult,  (b + sz + stepsize) * bmult)
					local x = func(a+stepsize, b)
					make_vert(icount+2, x, uv1, uv2, (a + sz + stepsize) * amult,  (b + sz) * bmult)
				end 
									
				local w = func(a, b+stepsize)
				make_vert(icount+4, w, uv1, uv2, (a + sz) * amult,  (b + sz + stepsize) * bmult)

 				icount = icount + 6
 			end
		end
	end

	return geom:makeMesh( goname, indices, verts, uvs, normals )
end

------------------------------------------------------------------------------------------------------------

function geom:GeneratePlane( goname, sx, sy, uvMult, offx, offy )

	offx     = offx or 0
	offy     = offy or 0
	uvMult   = uvMult or 1.0
	local plane 	= geom:New(goname)
	geom:New(goname, 1.0)
	tinsert(self.meshes, goname)
	
	local indices	= { 0, 1, 2, 0, 2, 3 }
	local verts		= { -sx + offx, 0.0, sy + offy, sx + offx, 0.0, sy + offy, sx + offx, 0.0, -sy + offy, -sx + offx, 0.0, -sy + offy }
	local uvs		= { 0.0, 0.0, uvMult, 0.0, uvMult, uvMult, 0.0, uvMult }
	local normals	= { 0.0, 1.0, 0.0, 0.0, 1.0, 0.0, 0.0, 1.0, 0.0, 0.0, 1.0, 0.0 }

	return geom:makeMesh( goname, indices, verts, uvs, normals )
end


------------------------------------------------------------------------------------------------------------
-- 
function geom:GenerateSphere( goname, sz, d, inverted )

	if inverted == nil then inverted = 1.0 end
	geom:New(goname, 1.0)
	tinsert(self.meshes, goname)

	local verts 	= {}
	local indices 	= {} 
	local uvs 		= {}
	local normals 	= {}

	local vcount    = 1
	local ncount    = 1
	local ucount    = 1
	local icount    = 1
	local index     = 1

	-- Start with a cube. Then for number x/y sizes iterate each side of the cube
	-- For each side of the cube cal vert trace back to center of cube, then recalc vert based on radius.
	-- Collect verts in order, making triangles along the way
	function spherevec( vec )		
		local nvec = vmath.normalize( vmath.vector3( vec[1], vec[2], vec[3] ) )
		return { nvec.x * sz, nvec.y * sz, nvec.z * sz, vec[4], vec[5], vec[6] }
	end

	local targets = {  
		[1] = function( a, b ) return spherevec( { a, -sz, b, -1, 0.25, 0.333 } ); end,
		[2] = function( a, b ) return spherevec( { a, b, -sz, 1, 0.0, 0.333 } ); end,
		[3] = function( a, b ) return spherevec( { a, b, sz, -1, 0.25, 0.333 } ); end,
		[4] = function( a, b ) return spherevec( { -sz, b, a, -1, 0.25, 0.333 } ); end,
		[5] = function( a, b ) return spherevec( { sz, b, a, 1, 0.0, 0.333 } ); end,
		[6] = function( a, b ) return spherevec( { a, sz, b, 1, 0.0, 0.333 } ); end
	}

	local startuvs = {
		[1] = { 0.25, 0.666 },		-- Ground
		[2] = { 0.25, 0.333 },		-- Front
		[3] = { 0.75, 0.333 },		-- Back
		[4] = { 0.0, 0.333 },		-- Left
		[5] = { 0.5, 0.333 },		-- Right
		[6] = { 0.25, 0.0 }			-- Sky
	}

	local stepsize = sz * 2 / d
	for key, func in ipairs(targets) do

		local uv1 = startuvs[key][1]
		local vstep = 1.0 / d

		local amult = 1.0 / ( 2.005 * sz * 4.0 )
		local bmult = 1.0 / ( 2.005 * sz * 3.0 )

		for a = -sz, sz-stepsize, stepsize do

			local uv2 = startuvs[key][2]
			for b = -sz, sz-stepsize, stepsize do
				local toggle = 1

				local v = func(a, b)
				indices[index]  = icount+v[4] * inverted ; index = index + 1
				verts[vcount]   = v[1]; vcount = vcount + 1
				verts[vcount]   = v[2]; vcount = vcount + 1
				verts[vcount]   = v[3]; vcount = vcount + 1
				normals[ncount]   = v[1]; ncount = ncount + 1
				normals[ncount]   = v[2]; ncount = ncount + 1
				normals[ncount]   = v[3]; ncount = ncount + 1
				uvs[ucount]     = uv1 + v[5] + v[4] * (a + sz) * amult; ucount = ucount + 1
				uvs[ucount]     = uv2 + v[6] - (b + sz) * bmult; ucount = ucount + 1

				local x = func(a+stepsize, b)
				indices[index]  = icount ; index = index + 1
				verts[vcount]   = x[1]; vcount = vcount + 1
				verts[vcount]   = x[2]; vcount = vcount + 1
				verts[vcount]   = x[3]; vcount = vcount + 1
				normals[ncount]   = x[1]; ncount = ncount + 1
				normals[ncount]   = x[2]; ncount = ncount + 1
				normals[ncount]   = x[3]; ncount = ncount + 1
				uvs[ucount]     = uv1 + x[5] + x[4] * (a + sz + stepsize) * amult; ucount = ucount + 1
				uvs[ucount]     = uv2 + x[6] - (b + sz) * bmult; ucount = ucount + 1

				local w = func(a, b+stepsize)
				indices[index]  = icount-v[4] * inverted ; index = index + 1
				verts[vcount]   = w[1]; vcount = vcount + 1
				verts[vcount]   = w[2]; vcount = vcount + 1
				verts[vcount]   = w[3]; vcount = vcount + 1
				normals[ncount]   = w[1]; ncount = ncount + 1
				normals[ncount]   = w[2]; ncount = ncount + 1
				normals[ncount]   = w[3]; ncount = ncount + 1
				uvs[ucount]     = uv1 + w[5] + w[4] * (a + sz) * amult; ucount = ucount + 1
				uvs[ucount]     = uv2 + w[6] - (b + sz + stepsize) * bmult; ucount = ucount + 1

				local y = func(a+stepsize,b+stepsize)
				verts[vcount]   = y[1]; vcount = vcount + 1
				verts[vcount]   = y[2]; vcount = vcount + 1
				verts[vcount]   = y[3]; vcount = vcount + 1
				normals[ncount]   = y[1]; ncount = ncount + 1
				normals[ncount]   = y[2]; ncount = ncount + 1
				normals[ncount]   = y[3]; ncount = ncount + 1
				uvs[ucount]     = uv1 + y[5] + y[4] * (a + sz + stepsize) * amult; ucount = ucount + 1
				uvs[ucount]     = uv2 + y[6] - (b + sz + stepsize) * bmult; ucount = ucount + 1

				indices[index]  = icount+2-(1-v[4] * inverted) ; index = index + 1
				indices[index]  = icount+1-v[4] * inverted ; index = index + 1

				-- Build the extra tri from previous verts and one new one.
				indices[index]  = icount+1 ; index = index + 1
				icount = icount + 4
			end
		end
	end

-- 	sphere.ibuffers[1] = byt3dIBuffer:New()
-- 
-- 	sphere.ibuffers[1].vertBuffer 		= ffi.new("float["..(vcount-1).."]", verts)
-- 	sphere.ibuffers[1].indexBuffer 		= ffi.new("unsigned short["..(index-1).."]", indices)
-- 	sphere.ibuffers[1].texCoordBuffer 	= ffi.new("float["..(ucount-1).."]", uvs)
-- 
-- 	local name = string.format("Dynamic Mesh Sphere(%02d)", gSphereCount)
-- 	gSphereCount = gSphereCount + 1;    
-- 	self.node:AddBlock(sphere, name, "byt3dMesh")
-- 
	return geom:makeMesh( goname, indices, verts, uvs, normals )
end

-- ------------------------------------------------------------------------------------------------------------
-- 
-- function geom:GeneratePyramid(sz)
-- 
-- 	local newmodel 	= geom:New()
-- 	local pyramid 	= byt3dMesh:New()
-- 
-- 	local verts = 
-- 	{   
-- 		-sz, 0.0, -sz,  -sz, 0.0, sz,  sz, 0.0, sz,   sz, 0.0, -sz,
-- 		0.0, sz, 0.0
-- 	}
-- 
-- 	local indices = 
-- 	{
-- 		0, 2, 1, 2, 3, 0,      -- // Base
-- 		0, 4, 3,  0, 1, 4,  1, 2, 4, 2, 3, 4,  -- // Front Left Back Right
-- 	}
-- 
-- 	pyramid.ibuffers[1] = byt3dIBuffer:New()
-- 
-- 	pyramid.ibuffers[1].vertBuffer 		= verts
-- 	pyramid.ibuffers[1].indexBuffer 	= indices
-- 
-- 	newmodel.node:AddBlock(pyramid, nil, "byt3dMesh")
-- 	newmodel.boundMax = { sz, sz, sz, 0.0 }
-- 	newmodel.boundMin = { -sz, 0.0, -sz, 0.0 }
-- 	newmodel.boundCtr[1] = (newmodel.boundMax[1] - newmodel.boundMin[1]) * 0.5 + newmodel.boundMin[1]
-- 	newmodel.boundCtr[2] = (newmodel.boundMax[2] - newmodel.boundMin[2]) * 0.5 + newmodel.boundMin[2]
-- 	newmodel.boundCtr[3] = (newmodel.boundMax[3] - newmodel.boundMin[3]) * 0.5 + newmodel.boundMin[3]
-- 
-- 	return newmodel
-- end
-- 

-- ------------------------------------------------------------------------------------------------------------
-- 
-- function geom:GenerateBlock( sx, sy, sz, uvMult )
-- 
-- 	if uvMult   == nil then uvMult = 1.0 end
-- 	local plane 	= byt3dMesh:New()
-- 
-- 	local indices	= ffi.new("unsigned short[36]", 0, 1, 2,  2, 3, 0,  6, 5, 7,  7, 5, 4,
-- 	4, 0, 7,  0, 3, 7,  5, 6, 1,  1, 6, 2,
-- 	0, 4, 5,  0, 5, 1,  2, 7, 3,  2, 6, 7 )
-- 	local verts		= ffi.new( "float[24]", -sx, sy, -sz,   sx, sy, -sz,    sx, -sy, -sz,   -sx, -sy, -sz,
-- 	-sx, sy, sz,    sx, sy, sz,     sx, -sy, sz,    -sx, -sy, sz )
-- 	local uvs		= ffi.new( "float[16]", 0.0, 0.0, uvMult, 0.0, uvMult, uvMult, 0.0, uvMult,
-- 	uvMult, uvMult, 0.0, 0.0, 0.0, uvMult, uvMult, 0.0)
-- 
-- 	plane.ibuffers[1] = byt3dIBuffer:New()
-- 	plane.ibuffers[1].vertBuffer 		= verts
-- 	plane.ibuffers[1].indexBuffer 		= indices
-- 	plane.ibuffers[1].texCoordBuffer 	= uvs
-- 
-- 	local name = string.format("Dynamic Mesh Block(%02d)", gPlaneCount)
-- 	io.write("New Plane: ", name, "\n")
-- 	gPlaneCount = gPlaneCount + 1;
-- 
-- 	self.node:AddBlock(plane, name, "byt3dMesh")
-- 	self.boundMax = { sx, sy, sz, 0.0 }
-- 	self.boundMin = { -sx, -sy, -sz, 0.0 }
-- 	self.boundCtr[1] = (self.boundMax[1] - self.boundMin[1]) * 0.5 + self.boundMin[1]
-- 	self.boundCtr[2] = (self.boundMax[2] - self.boundMin[2]) * 0.5 + self.boundMin[2]
-- 	self.boundCtr[3] = (self.boundMax[3] - self.boundMin[3]) * 0.5 + self.boundMin[3]
-- end
-- 
-- ------------------------------------------------------------------------------------------------------------
-- 

return geom