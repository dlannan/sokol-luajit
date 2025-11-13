------------------------------------------------------------------------------------------------------------

local tinsert = table.insert

------------------------------------------------------------------------------------------------------------

local ffi 			= require("ffi")

local gameobject	= require("lua.engine.gameobject")

local geom 			= require("lua.gltfloader.geometry-utils")
local meshes 		= require("lua.geometry.meshes")
local imageutils 	= require("lua.gltfloader.image-utils")

local b64 			= require("lua.base64")
local utils			= require("lua.utils")
local cgltf      	= require("ffi.sokol.cgltf")
local hmm      		= require("hmm")

local binmgr 		= require("lua.geometry.bins")

local fmt 			= string.format

------------------------------------------------------------------------------------------------------------

local gltfloader = {
	gomeshname 		= "temp",
	goscriptname 	= "script",
	curr_factory 	= nil,
	temp_meshes 	= {},
}

------------------------------------------------------------------------------------------------------------

function gltfloader:processmaterials( model, gochildname, thisnode )

	-- Get indices from accessor 
	local thismesh = thisnode.mesh
	local prims = thismesh.primitives	

	if(prims == nil) then print("No Primitives?"); return end 

	-- Iterate primitives in this mesh
	for k,prim in pairs(prims) do

		-- If it has a material, load it, and set the material 
		if(prim.material) then 

			local mat = prim.material
			local pbrmetallicrough = mat.pbrMetallicRoughness 
			local primmesh = { mesh = prim.primmesh, name = prim.primname }

			if(mat.alphaMode) then 
				-- Set material tag to include mask (for predicate rendering!)
				if(mat.alphaMode == "MASK") then 
					-- local maskmat = go.get("/material#tempmask", "material")
					-- go.set(prim.primmesh, "material", maskmat)
				end
				if(mat.alphaMode == "BLEND") then 
					-- local maskmat = go.get("/material#tempmask", "material")
					-- go.set(prim.primmesh, "material", maskmat)
				end
			end
			
			if (pbrmetallicrough) then 

				if(pbrmetallicrough.baseColorFactor) then 
					local bcolor = pbrmetallicrough.baseColorFactor
					-- TODO: Material gen with base color setting
					-- model.set_constant(prim.primmesh, "tint", vmath.vector4(bcolor[1], bcolor[2], bcolor[3], bcolor[4]) )
				end 
				
				if(pbrmetallicrough.baseColorTexture) then 
					local bcolor = pbrmetallicrough.baseColorTexture
					gltfloader:loadimages( model, primmesh, bcolor, 0 )
				end 

				if(pbrmetallicrough.metallicRoughnessTexture) then 
					local bcolor = pbrmetallicrough.metallicRoughnessTexture
					gltfloader:loadimages( model, primmesh, bcolor, 1 )
				end
			end
			local pbremissive = mat.emissiveTexture
			if(pbremissive) then 
				local bcolor = pbremissive
				gltfloader:loadimages( model, primmesh, bcolor, 2 )
			end
			local pbrnormal = mat.normalTexture
			if(pbrnormal) then  
				local bcolor = pbrnormal
				gltfloader:loadimages( model, primmesh, bcolor, 3 )
			end

			if(mat.doubleSided == true) then 

			end
		end 
	end
end 

------------------------------------------------------------------------------------------------------------
-- Combine AABB's of model with primitives. 
local function calcAABB( aabb, aabbmin, aabbmax )
	aabb = aabb or { 
		min = hmm.HMM_Vec3(math.huge,math.huge,math.huge), 
		max = hmm.HMM_Vec3(-math.huge,-math.huge,-math.huge) 
	}
	aabb.min.x = math.min(aabb.min.x, aabbmin.x)
	aabb.min.y = math.min(aabb.min.y, aabbmin.y)
	aabb.min.z = math.min(aabb.min.z, aabbmin.z)

	aabb.max.x = math.max(aabb.max.x, aabbmax.x)
	aabb.max.y = math.max(aabb.max.y, aabbmax.y)
	aabb.max.z = math.max(aabb.max.z, aabbmax.z)
	return aabb
end

------------------------------------------------------------------------------------------------------------

local function transformAABB(aabb, tform)
    -- compute 8 corners of the local AABB
    local corners = {
        hmm.HMM_Vec3(aabb.min.x, aabb.min.y, aabb.min.z),
        hmm.HMM_Vec3(aabb.max.x, aabb.min.y, aabb.min.z),
        hmm.HMM_Vec3(aabb.min.x, aabb.max.y, aabb.min.z),
        hmm.HMM_Vec3(aabb.min.x, aabb.min.y, aabb.max.z),
        hmm.HMM_Vec3(aabb.min.x, aabb.max.y, aabb.max.z),
        hmm.HMM_Vec3(aabb.max.x, aabb.max.y, aabb.min.z),
        hmm.HMM_Vec3(aabb.max.x, aabb.min.y, aabb.max.z),
        hmm.HMM_Vec3(aabb.max.x, aabb.max.y, aabb.max.z),
    }

    local newAABB = { 
        min = hmm.HMM_Vec3(math.huge, math.huge, math.huge),
        max = hmm.HMM_Vec3(-math.huge, -math.huge, -math.huge)
    }

    for i=1,#corners do
        local worldCorner = hmm.HMM_MultiplyMat4ByVec4(tform, hmm.HMM_Vec4(corners[i].x, corners[i].y, corners[i].z, 1))
        newAABB.min.x = math.min(newAABB.min.x, worldCorner.x)
        newAABB.min.y = math.min(newAABB.min.y, worldCorner.y)
        newAABB.min.z = math.min(newAABB.min.z, worldCorner.z)
        newAABB.max.x = math.max(newAABB.max.x, worldCorner.x)
        newAABB.max.y = math.max(newAABB.max.y, worldCorner.y)
        newAABB.max.z = math.max(newAABB.max.z, worldCorner.z)
    end

    return newAABB
end

------------------------------------------------------------------------------------------------------------

local function jointables(t1, t2)

	for k,v in pairs(t2) do 
		tinsert(t1, v)
	end
end

------------------------------------------------------------------------------------------------------------

function gltfloader:processdata( model, gochildname, thisnode, parent )

	--print(model)
	local thismesh = thisnode.mesh
	local prims = thismesh.primitives	

	if(prims == nil) then print("No Primitives?"); return end 

	local buffer_data = nil
	
	-- collate all primitives (we ignore material separate prims)
	for pid, prim in ipairs(prims) do

		local verts = nil
		local uvs = nil
		local normals = nil
		
		local acc_idx = prim.indices
		local indices = nil
		
		local itype = sg.SG_INDEXTYPE_UINT16

		if(acc_idx) then 
			local bv = acc_idx.buffer_view
			local index_buffer_data = cgltf.cgltf_buffer_view_data(bv)

			local ctype = tonumber(acc_idx.component_type)
			-- Indices specific - this is default dataset for gltf (I think)
			if(ctype == cgltf.cgltf_component_type_r_32u) then 
				indices = ffi.new("uint32_t[?]", acc_idx.count)
				ffi.copy(indices, index_buffer_data, acc_idx.count * 4)
				-- geomextension.setdataintstotable( 0, , index_buffer_data, indices)
				itype = sg.SG_INDEXTYPE_UINT32
				print("[Warning] 32 bit index buffer")
			elseif(ctype == cgltf.cgltf_component_type_r_32f) then 
				print("TODO: Support float buffers")
			elseif(ctype == cgltf.cgltf_component_type_r_16u or ctype == cgltf.cgltf_component_type_r_16) then 
				indices = ffi.new("uint16_t[?]", acc_idx.count)
				ffi.copy(indices, index_buffer_data, acc_idx.count * 2)
				-- geomextension.setdatashortstotable( 0, acc_idx.count * 2, index_buffer_data, indices)
			elseif(ctype == cgltf.cgltf_component_type_r_8u or ctype == cgltf.cgltf_component_type_r_8) then 
				indices = ffi.new("uint16_t[?]", acc_idx.count)
				local ptr = index_buffer_data
				local acount = tonumber(acc_idx.count)
				for i=0, acount-1 do 
					indices[i] = ptr[i]
				end
				itype = sg.SG_INDEXTYPE_UINT16
				-- geomextension.setdatabytestotable( 0, acc_idx.count, index_buffer_data, indices)
				print("[Warning] 8 bit index buffer")
			else 
				print("[Error] Unhandled componentType: "..ctype)
			end
		else 
			print("[Error] No indices.")
			-- No indices generate a tristrip from position count
			local posidx = prim.attributes["POSITION"]
			-- Leave indices nil. The pipeline builder will use triangles by default

			-- geomextension.buildindicestotable( 0, posidx.count, 1, indices)
		end

		-- Get position accessor
		local aabb = nil
		local pos_attrib = prim.attributes["POSITION"]
		if(pos_attrib) then 
			local bv = pos_attrib.data.buffer_view
			buffer_data = cgltf.cgltf_buffer_view_data(bv)

			local length = tonumber(bv[0].size)
			local float_count = length / ffi.sizeof("float")
			if(model.counted[pos_attrib] == nil) then
				model.stats.vertices = model.stats.vertices + float_count / 3
				model.counted[pos_attrib] = true
			end

			-- Get positions (or verts) 
			verts = ffi.new("float[?]", float_count)
			ffi.copy(verts, buffer_data, length)

			-- geomextension.setdataindexfloatstotable( buffer_data, verts, indices, 3)
			local pos_acc = pos_attrib.data
			local pmin = hmm.HMM_Vec3(pos_acc.min[0], pos_acc.min[1], pos_acc.min[2])
			local pmax = hmm.HMM_Vec3(pos_acc.max[0], pos_acc.max[1], pos_acc.max[2]) 
			aabb = calcAABB( aabb, pmin, pmax )
		end

		-- Get uvs accessor
		local tex_attrib = prim.attributes["TEXCOORD_0"]
		if(tex_attrib) then 
			local bv = tex_attrib.data.buffer_view
			buffer_data = cgltf.cgltf_buffer_view_data(bv)

			local length = tonumber(bv[0].size)

			uvs = ffi.new("float[?]", length / ffi.sizeof("float"))
			ffi.copy(uvs, buffer_data, length)
			-- geomextension.setdataindexfloatstotable( buffer_data, uvs, indices, 2)
		end 

		-- Get normals accessor
		local norm_attrib = prim.attributes["NORMAL"]
		if(norm_attrib) then 
			local bv = norm_attrib.data.buffer_view
			buffer_data = cgltf.cgltf_buffer_view_data(bv)

			local length = tonumber(bv[0].size)

			normals = ffi.new("float[?]", length/ ffi.sizeof("float"))
			ffi.copy(normals, buffer_data, length)			
			-- geomextension.setdataindexfloatstotable( buffer_data, normals, indices, 3)
		end 

		if(acc_idx) then 
			-- Reset indicies, because our buffers are all aligned!

			-- NOTE: Not sure if this is needed. Will need to check
			-- geomextension.buildindicestotable( 0, acc_idx.count, 1, indices)
		end
		
		-- 	local indices	= { 0, 1, 2, 0, 2, 3 }
		-- 	local verts		= { -sx + offx, 0.0, sy + offy, sx + offx, 0.0, sy + offy, sx + offx, 0.0, -sy + offy, -sx + offx, 0.0, -sy + offy }
		-- 	local uvs		= { 0.0, 0.0, uvMult, 0.0, uvMult, uvMult, 0.0, uvMult }
		-- 	local normals	= { 0.0, 1.0, 0.0, 0.0, 1.0, 0.0, 0.0, 1.0, 0.0, 0.0, 1.0, 0.0 }

		-- Make a submesh for each primitive. This is kinda bad, but.. well.
		-- print(gochildname)
		local primname = fmt( "%s_prim_%s", ffi.string(gochildname), tostring(pid) )
		prim.primname = ffi.string(gochildname)
		local primgo = gameobject.create( nil, primname )
		local primmesh = ffi.string(gameobject.goname(primgo)).."_temp"
		prim.primmesh = primmesh
		prim.transform = thisnode.transform
		prim.index_count = tonumber(acc_idx.count)

		if(indices) then 

			local primdata = {
				itype = itype, 
				icount = prim.index_count,
				indices = indices, 
				verts = verts, 
				uvs = uvs, 
				normals = normals, 
			}

			model.stats.polys = model.stats.polys + primdata.icount / 3
			prim.mesh_buffers = geom:makeMesh( primmesh, primdata )
			if(prim.mesh_buffers) then 

				prim.geom = geom:makeGeom(primmesh, prim, prim.mesh_buffers)
				tinsert(model.all_geom, prim.geom)
			
				print("Added mesh buffer", prim.primmesh)
			end
		else 
			-- Should habndle vert buffers naively
			print("Non index buffers?", prim.primmesh)
		end

		prim.aabb = aabb
		local tfaabb = transformAABB(prim.aabb, thisnode.transform)
		model.aabb = calcAABB(model.aabb, tfaabb.min, tfaabb.max)

		-- go.set_rotation(vmath.quat(), primgo)
		-- go.set_position(vmath.vector3(0,0,0), primgo)
		-- go.set_parent( primmesh, gochildname )
	end
end

------------------------------------------------------------------------------------------------------------

function gltfloader:makeNodeMeshes( model, parent, node )

	local thisnode = node
	
	-- Each node can have a mesh reference. If so, get the mesh data and make one, set its parent to the
	--  parent node mesh

	local parentname = gameobject.goname(parent)
	local gomeshname  = parentname.."/node_"..string.format("%s", node.name)
	gomeshname = gomeshname:gsub("%s+", "")
		
	local gochild = gameobject.create( nil, gomeshname )
	if(gochild == nil) then 
		print("[Error] Factory could not create mesh.")
		return 
	end 

	local gochildname = gameobject.goname(gochild)
	thisnode.goname = gochildname
	
	--print("Name:", gomeshname)	
	if(thisnode.mesh) then 
		
		-- Temp.. 
		gltfloader:processdata( model, gochildname, thisnode, parent )
		gltfloader:processmaterials( model, gochildname, thisnode )	
	end 

	-- Try children
	local rot = thisnode["rotation"]
	if(rot) then gameobject.set_rotation(gochild, hmm.HMM_Quaternion(rot[1], rot[2], rot[3], rot[4])) end
	local trans = thisnode["translation"]
	if(trans) then gameobject.set_position(gochild, hmm.HMM_Vec3(trans[1], trans[2], trans[3])) end

	local scale = thisnode["scale"]
	if(scale) then gameobject.set_scale(gochild, hmm.HMM_Vec3(math.abs(scale[1]), math.abs(scale[2]), math.abs(scale[3])) ) end
	
	-- Parent this mesh to the incoming node 
	gameobject.set_parent(gochild, parent)
	
	if(thisnode.children ~= nil) then 
		local ccount = tonumber(thisnode.children_count)
		for i = 0, ccount - 1 do 
			local child = thisnode.children[i]
			self:makeNodeMeshes( model, gochild, child)
		end 
	end
end	

------------------------------------------------------------------------------------------------------------
-- Load images: This is horribly slow at the moment. Will improve.

function gltfloader:loadimages( model, primmesh, bcolor, tid )
	
	if(bcolor and bcolor.texture and bcolor.texture.source) then 
		tid = tid or 0
		-- Load in any images 
		if(bcolor.texture.source.uri) then 
			-- print("TID: "..tid.."   "..model.basepath..bcolor.texture.source.uri)
			imageutils.loadimage(primmesh.mesh, model.basepath..bcolor.texture.source.uri, tid )
		elseif(bcolor.texture.source.bufferView) then
			-- print("TID: "..tid.."   "..bcolor.texture.source.name.."  "..bcolor.texture.source.mimeType)
			local stringbuffer = bcolor.texture.source.bufferView:get()
			imageutils.loadimagebuffer(primmesh.mesh, stringbuffer, tid )

			-- imageutils.defoldbufferimage(primmesh.mesh, bytes, pnginfo, tid )		
		end
	end
end

------------------------------------------------------------------------------------------------------------
-- // parse the GLTF buffer definitions and start loading buffer blobs
function gltf_parse_buffers(model)
	
	local options = ffi.new("cgltf_options[1]", {})
	local result = cgltf.cgltf_load_buffers( options, model.data[0], model.filename)
	if(result ~= cgltf.cgltf_result_success) then 
		print("[Error] gltf_parse_buffers: cannot load buffers")
		return nil
	end

	-- Buffer views and buffers are now loaded ok. Ready for parsing.
end	

-- --------------------------------------------------------------------------------------------------------
-- This creates a world transform for each node. Not sure I like this (was copied from sokol cgltf example)
local function build_transform_for_gltf_node(node)
    local parent_tform = hmm.HMM_Mat4d(1.0) -- ✅ start with identity
    if node[0].parent ~= nil then
        parent_tform = build_transform_for_gltf_node(node[0].parent)
    end

    if node[0].has_matrix == 1 then
        local tform = ffi.new("hmm_mat4[1]")
        ffi.copy(tform, node.matrix, 16 * ffi.sizeof("float"))
        return hmm.HMM_MultiplyMat4(parent_tform, tform[0])
    else
        local translate = hmm.HMM_Mat4d(1.0)
		if(node[0].has_translation == 1) then 
			translate = hmm.HMM_Translate(hmm.HMM_Vec3(node[0].translation[0], node[0].translation[1], node[0].translation[2])) 
		end
        local rotate = hmm.HMM_Mat4d(1.0)
		if(node[0].has_rotation == 1) then 
			rotate = hmm.HMM_QuaternionToMat4(hmm.HMM_Quaternion( node[0].rotation[0], node[0].rotation[1], node[0].rotation[2], node[0].rotation[3]))
		end
        local scale = hmm.HMM_Mat4d(1.0)
		if(node[0].has_scale == 1) then 
			scale = hmm.HMM_Scale(hmm.HMM_Vec3(node[0].scale[0], node[0].scale[1], node[0].scale[2]))
		end
        local local_tform = hmm.HMM_MultiplyMat4(translate, hmm.HMM_MultiplyMat4(rotate, scale))

        return hmm.HMM_MultiplyMat4(parent_tform, local_tform)
    end
end

-- ----------hmm.----------------------------------------------------------------------------------------------

local function get_addr(ptr, off, ctype)
    off = off or 0
    ctype = ctype or "uintptr_t"  -- type of element, defaults to pointer size
    local addr = ffi.cast("uintptr_t", ptr) + off * ffi.sizeof(ctype)
    return tonumber(addr)
end

-- --------------------------------------------------------------------------------------------------------
-- Load images using our utils.
function gltf_parse_images(model)

	local image_map = {}
	model.images = {}
	local image_count = tonumber(model.data[0].images_count)
	for i=0, image_count -1 do 
		local img = model.data[0].images[i]
		local addr = get_addr(model.data[0].images, i, "cgltf_image")
		image_map[addr] = #model.images + 1
		local image = nil
		local imagename = ffi.string(img.name)
		if(img.uri ~= nil) then 
			local filepath = model.basepath..ffi.string(img.uri)
			image = imageutils.loadimage(imagename, filepath, i )
		else 
			local bv = img.buffer_view		
			local bufptr = nil
			if(bv[0].data ~= nil) then 
				bufptr = ffi.cast("uint8_t *", bv[0].data)
			else
				bufptr = cgltf.cgltf_buffer_view_data(bv)
			end
			image = imageutils.loadimagebuffer(imagename, bufptr, bv[0].size, i )
		end
		tinsert(model.images, image)
		collectgarbage("collect")
	end

	-- Loade images into texture slots! 
	model.textures = {}
	model.textures_map = {}
	for i = 0, tonumber(model.data[0].textures_count)-1 do
    	local tex = model.data[0].textures[i]
		local img_id = image_map[get_addr(tex.image)]
		local tex_img = model.images[img_id]
		local texaddr = get_addr(model.data[0].textures, i, "cgltf_texture")
		model.textures_map[texaddr] = tex_img
    	tinsert(model.textures, tex_img)
		model.stats.textures = model.stats.textures + 1
	end	
end

-- --------------------------------------------------------------------------------------------------------

function gltf_parse_materials(model)

	model.materials = {}
	model.materials_map = {}
	local gltf = model.data[0]
	local num_materials =  tonumber(gltf.materials_count)
    for i = 0, num_materials - 1 do
        local gltf_mat = gltf.materials[i]
        local scene_mat = {}
        scene_mat.is_metallic = gltf_mat.has_pbr_metallic_roughness
        if (scene_mat.is_metallic == 1) then
            local src = gltf_mat.pbr_metallic_roughness
			scene_mat.name = ffi.string(gltf_mat.name)
			scene_mat.alpha_mode = gltf_mat.alpha_mode
			scene_mat.alpha_cutoff = gltf_mat.alpha_cutoff

            scene_mat.base_color = {
				src.base_color_factor[0], src.base_color_factor[1], src.base_color_factor[2], src.base_color_factor[3],
			}
			scene_mat.metallic_factor = src.metallic_factor
			scene_mat.roughness_factor = src.roughness_factor
			scene_mat.emissive_factor = {
				gltf_mat.emissive_factor[0], gltf_mat.emissive_factor[1], gltf_mat.emissive_factor[2],
			}

			local base_color_tex = model.textures_map[get_addr(src.base_color_texture.texture)]
			local metallic_roughness_tex = model.textures_map[get_addr(src.metallic_roughness_texture.texture)]
			local normal_tex = model.textures_map[get_addr(gltf_mat.normal_texture.texture)]
			local occulusion_tex = model.textures_map[get_addr(gltf_mat.occlusion_texture.texture)]
			local emissive_tex = model.textures_map[get_addr(gltf_mat.emissive_texture.texture)]

            scene_mat.images = {
                base_color 			= base_color_tex,
                metallic_roughness 	= metallic_roughness_tex,
                normal 				= normal_tex,
                occlusion 			= occulusion_tex,
                emissive 			= emissive_tex,
            }
        end 
		model.materials_map[ get_addr(gltf.materials, i, "cgltf_material") ] = scene_mat
		tinsert(model.materials, scene_mat)
	end
end

-- --------------------------------------------------------------------------------------------------------

function gltf_parse_meshes(model)

	model.scene = {}
	model.scene.meshes = {}
	model.meshes_map = {}
	local gltf = model.data[0]

    model.scene.num_meshes = tonumber(gltf.meshes_count)
    for mesh_index = 0, model.scene.num_meshes-1 do
        local gltf_mesh = gltf.meshes[mesh_index]

		local mesh = { primitives = {} }
        mesh.first_primitive = 1
        mesh.num_primitives = tonumber(gltf_mesh.primitives_count)
        for prim_index = 0,  mesh.num_primitives-1 do
            local gltf_prim = gltf_mesh.primitives[prim_index]
			local mat_handle = get_addr(gltf_prim.material)
            local prim = {
				prim = gltf_prim,
				material = model.materials_map[mat_handle],
				indices = gltf_prim.indices,
				type = gltf_prim.type,
				attributes = {},
			}
			local attrib_count = tonumber(gltf_prim.attributes_count)
			for i=0, attrib_count-1 do
				local attrib = gltf_prim.attributes[i]
				prim.attributes[ffi.string(attrib.name)] = attrib
			end

			tinsert( mesh.primitives, prim )
        end 
		model.stats.primitives = model.stats.primitives + mesh.num_primitives
		model.meshes_map[get_addr(gltf.meshes, mesh_index, "cgltf_mesh")] = mesh
		tinsert( model.scene.meshes, mesh )
    end
end

-- --------------------------------------------------------------------------------------------------------

local function gltf_parse_nodes(model, node)
	
	local gltf = model.data[0]
	local nodes_count  = tonumber(node.children_count)
	for node_index = 0, nodes_count-1 do
        local gltf_node = node.children[node_index]
		gltf_node.parent = node
		gltf_parse_nodes(model, gltf_node)
    end

	if (node.mesh ~= nil) then 
		local newnode = {}
		newnode.name = ffi.string(node.name or "")
		newnode.mesh = model.meshes_map[get_addr(node.mesh)]
		newnode.transform = build_transform_for_gltf_node(node)
		tinsert(model.scene.nodes, newnode)
	end
	model.stats.nodes = model.stats.nodes + 1 
end

-- --------------------------------------------------------------------------------------------------------
-- A new loader method using a new loader from here: https://github.com/leonardus/lua-gltf
function gltfloader:load( model, scene, pobj, meshname )

	-- Note: Meshname is important for idenifying a mesh you want to be able to modify
	if(pobj == nil) then 
		pobj = gameobject.create( nil, meshname )
		return pobj
	end 

	model.goname = gltfloader.gomeshname
	model.goscript = gltfloader.goscriptname

	-- Iterate model scene and build meshes
	--   By default the model is collapsed to a series of meshes, and transforms and names are lost.
	--   An option will be added if the hierarchy needs to be retained.
	for n, node in ipairs(scene.nodes) do
		self:makeNodeMeshes( model, pobj, node)
	end

	-- This will free cgltf's own memory (we dont need it now)
	-- model.data = nil

	return pobj
end

-- --------------------------------------------------------------------------------------------------------
-- This is a special version of load that allows the loading of a single mesh into a gameobject manager

function gltfloader:load_gltf( assetfilename, asset, disableaabb )

	-- Check for gltf - only support this at the moment. 
	local valid = string.match(assetfilename, ".+%."..asset.format)
	assert(valid)

	local basepath = assetfilename:match("(.*[\\/])")
	
	-- Parse using geomext 

	local options = ffi.new("cgltf_options[1]", {})
	local data = ffi.new("cgltf_data *[1]", {nil})
	local result = cgltf.cgltf_parse_file(options, assetfilename, data)
	if (result == cgltf.cgltf_result_success) then
	
		-- Handle autodestruction when data is made nil
		ffi.gc(data, function(d)
			if d[0] ~= nil then cgltf.cgltf_free(d[0]); d[0] = nil end
		end)
		print("[Info] gltf loaded: ", assetfilename)
	else 
		print("[Error] Unable to load gltf: ", assetfilename)
	end

	local model = {
		filename = assetfilename,
		basepath = basepath,
		data = data,
		all_geom = {},
		stats = {
			vertices = 0,
			polys = 0,
			textures = 0,
			nodes = 0,
			primitives = 0,
		},
		counted = {},
	}

	gltf_parse_buffers(model)
	gltf_parse_images(model)
	gltf_parse_materials(model)
	gltf_parse_meshes(model)

	model.scene.nodes = {}
	local gltf = model.data[0]
	model.scene.nodes_count  = tonumber(gltf[0].scene.nodes_count)
	for i=0, model.scene.nodes_count-1 do
		local node = gltf[0].scene.nodes[i]
		gltf_parse_nodes(model, node)
	end

	-- if(model.animations) then 
	-- 	ozzanim.loadgltf( "--file="..assetfilename )
	-- end

	model.aabb = { 
		min = hmm.HMM_Vec3(math.huge,math.huge,math.huge), 
		max = hmm.HMM_Vec3(-math.huge,-math.huge,-math.huge) 
	}

	if(asset.format == "gltf" or asset.format == "glb") then 
		asset.go = gameobject.create( nil, asset.name )

		self:load( model, model.scene, asset.go, asset.name)

		-- local mesh, scene = gltf:load(assetfilename, asset.go, asset.name)
		-- go.set_position(vmath.vector3(0, -999999, 0), asset.go)
	end
	
	-- -- TODO - THIS IS HORRIBLE - NEEDS TO GO TO BINS AND HANDLED IN PRE-TRAVERSAL!
	-- local states 	  = {}
	-- -- TODO: Dodgy override for a material atm. Will change.

	-- local prims       = {}

	-- -- Collect meshes together for rendering
	-- gltfloader:run_nodes( model , function( model, thisnode )
	-- 	if(thisnode.mesh) then 
	-- 		local mesh = thisnode.mesh
	-- 		if(mesh.primitives) then 
	-- 			for i, prim in ipairs(mesh.primitives) do 
	-- 				if(prims[prim.primmesh] == nil and prim.mesh_buffers) then 
    --         			prims[prim.primmesh] = { 
	-- 						index_count = prim.mesh_buffers.count,
	-- 						node = mesh, prim = prim, 
	-- 						mesh = prim.mesh_buffers,
	-- 						aabb = prim.aabb,
	-- 						material = prim.material,
	-- 						transform = thisnode.transform,
	-- 					}
	-- 				end
	-- 			end 
	-- 		end
	-- 	end
	-- end)

	-- for k, prim in pairs(prims) do 
	-- 	-- local geom_mesh = geom:GetMesh(prim.prim.primmesh)
	-- 	local state_tbl = meshes.state(k, prim, prim.mesh, material)
	-- 	local state = { 
	-- 		pip = state_tbl.pip, 
	-- 		bind = state_tbl.bind, 
	-- 		alpha = state_tbl.alpha, 
	-- 		count = prim.index_count,
	-- 		transform = prim.transform,
	-- 		base_color = prim.material.base_color or { 1, 1, 1, 1 },
	-- 	}
	-- 	tinsert(states, state)
	-- 	local tfaabb = transformAABB(prim.aabb, prim.transform)
	-- 	model.aabb = calcAABB(model.aabb, tfaabb.min, tfaabb.max)
	-- end

	if(model.aabb == nil) then 
		print("[Error] Model has no aabb: "..assetfilename)
	end

	-- model.states_tbl = states

	-- This releases cgltf data
	model.data = nil

	return model
end

------------------------------------------------------------------------------------------------------------

function gltfloader:run_node( model, thisnode, node_func)

	if(thisnode.children ~= nil) then 
		local ccount = tonumber(thisnode.children_count)
		for i=0, ccount -1 do 
			local child = thisnode.children[i]
			self:run_node( model,  child, node_func)
		end 
	end

	if(node_func and thisnode) then 
		node_func(  model, thisnode )
	end
end

------------------------------------------------------------------------------------------------------------

function gltfloader:run_nodes( model, node_func )

	for n, node in ipairs(model.scene.nodes) do

		self:run_node( model, node, node_func)
	end 
end

------------------------------------------------------------------------------------------------------------

return gltfloader

------------------------------------------------------------------------------------------------------------
