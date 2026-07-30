local sapp          = require("sokol_app")
local nk            = sg
local stb           = require("stb")

local hmm           = require("hmm")
local hutils        = require("hmm_utils")

local ffi           = require("ffi")

local utils         = require("lua.utils")

local tinsert       = table.insert
local tremove       = table.remove

-- --------------------------------------------------------------------------------------

local camera_manager   = {
    cameras         = {},
    cameras_active  = {},     -- Index array of the active cameras
    active          = 1,      -- Current index to camera in use
    transition      = nil,    -- transition information (next cam, time, callbacks)
}

-- --------------------------------------------------------------------------------------

local function make_cam(vfov, aspect, near, far)

    local cam = {
        proj        = hmm.HMM_Perspective_RH_NO(math.rad(vfov), aspect, near, far),
        view        = hmm.HMM_M4D(1.0),
        view_proj   = hmm.HMM_M4D(1.0),
        mvp         = hmm.HMM_M4D(1.0),

        position    = hmm.HMM_V3(0,0,0),
        rotation    = hmm.HMM_Q(0, 0, 0, 1),
        velocity    = hmm.HMM_V3(0,0,0),
        accel       = hmm.HMM_V3(0,0,0),

        viewport    = hmm.HMM_V4(0, 0, sapp.sapp_width(), sapp.sapp_height()),    -- View space dimensions of the view
        scissor     = hmm.HMM_V4(0, 0, sapp.sapp_width(), sapp.sapp_height()),    -- How to scissor/clip view

        aspect      = aspect,
        vfov        = vfov,
        near        = near, 
        far         = far,

        -- A list of passids associated with this camera
        passes      = {},
    }

    return cam
end

-- --------------------------------------------------------------------------------------

local function add( name, vfov, aspect, near, far )

    assert(name ~= nil)
    -- Setup a camera only with projection information initially
    local newcam = make_cam(vfov, aspect, near, far)
    newcam.name         = name       
    newcam.id           = #camera_manager.cameras_active + 1
    assert(camera_manager.cameras[name] == nil)
    camera_manager.cameras[name] = newcam
    camera_manager.cameras_active[newcam.id] = name
    camera_manager.active = newcam.id
    return newcam
end

-- --------------------------------------------------------------------------------------

local function add_default(name)

    name = name or "default"
    local w, h = sapp.sapp_width(), sapp.sapp_height()
    return add(name, 60.0, w/h, 0.01, 1000)
end

-- --------------------------------------------------------------------------------------

local function add_pass(name , passid) 
    local cam = camera_manager.cameras[name]
    if(cam) then 
        tinsert(cam.passes, passid)
    end
end

-- --------------------------------------------------------------------------------------

local function set_aspect(name , aspect) 
    local cam = camera_manager.cameras[name]
    if(cam and aspect ~= cam.aspect) then 
        cam.proj = hmm.HMM_Perspective_RH_NO(math.rad(cam.vfov), aspect, cam.near, cam.far)
        cam.aspect = aspect 
    end
end

-- --------------------------------------------------------------------------------------

local function set_nearfar(name , near, far) 
    local cam = camera_manager.cameras[name]
    near = near or cam.near 
    far = far or cam.far 
    if(cam and (near ~= cam.near or far ~= far)) then 
        local proj        = hmm.HMM_Perspective_RH_NO(math.rad(cam.vfov), cam.aspect, near, far)
        cam.proj = proj 
        cam.near = near 
        cam.far  = far
    end
end

-- --------------------------------------------------------------------------------------

local function get( name )
    return camera_manager.cameras[name]
end


-- --------------------------------------------------------------------------------------

local function get_passes(name) 
    local cam = camera_manager.cameras[name]
    if(cam) then 
        return cam.passes
    end
    return {}
end


-- --------------------------------------------------------------------------------------

local function get_id( name )
    local cam = camera_manager.cameras[name]
    if(cam) then 
        return cam.id
    end
    return nil
end

-- --------------------------------------------------------------------------------------

local function is_active(cameraid)
    return camera_manager.cameras_active[cameraid] ~= nil
end

-- --------------------------------------------------------------------------------------

local function get_active()

    return camera_manager.active or 1
end

-- --------------------------------------------------------------------------------------

local function get_view( name )
    local cam = camera_manager.cameras[name]
    if(cam) then 
        return cam.view 
    end
    return hmm.HMM_M4D(1.0)
end

-- --------------------------------------------------------------------------------------

local function get_projection( name )
    local cam = camera_manager.cameras[name]
    if(cam) then 
        return cam.proj
    end
    return hmm.HMM_M4D(1.0)
end

-- --------------------------------------------------------------------------------------

local function get_view_proj( name )
    local cam = camera_manager.cameras[name]
    if(cam) then 
        return cam.view_proj
    end
    return hmm.HMM_M4D(1.0)
end

-- --------------------------------------------------------------------------------------

local function get_aspect_ratio( name )
    local cam = camera_manager.cameras[name]
    if(cam) then 
        return cam.aspect
    end
    return 1.0
end

-- --------------------------------------------------------------------------------------

local function delete( name )
    if(camera_manager.cameras[name]) then
        camera_manager.cameras[name] = nil 
        collectgarbage()
    end 
end

-- --------------------------------------------------------------------------------------

local function update_viewport( name, viewport )
    local cam = camera_manager.cameras[name]
    if(cam) then cam.viewport = viewport end 
end

-- --------------------------------------------------------------------------------------

local function update_scissor( name, scissor )
    local cam = camera_manager.cameras[name]
    if(cam) then cam.scissor = scissor end 
end

-- --------------------------------------------------------------------------------------

local function apply_viewport( name, viewport )
    local cam = camera_manager.cameras[name]
    if(cam) then 
        sg.sg_apply_viewport(cam.viewport.x, cam.viewport.y, cam.viewport.w, cam.viewport.h, true)
    end 
end

-- --------------------------------------------------------------------------------------

local function apply_scissor( name )
    local cam = camera_manager.cameras[name]
    if(cam) then 
        sg.sg_apply_scissor_rect(cam.scissor.x, cam.scissor.y, cam.scissor.w, cam.scissor.h, true)
    end
end

-- --------------------------------------------------------------------------------------

local function lookat( name, eye, target, up )
    local cam = camera_manager.cameras[name]
    if(cam) then         
        cam.position    = eye 
        cam.target      = target 
        cam.up          = up 
        cam.view        = hmm.HMM_LookAt_RH(eye, target, up)
        cam.view_proj   = hmm.HMM_MulM4(cam.proj, cam.view)
    end 
end

-- --------------------------------------------------------------------------------------

local function get_mvp(name, model_mat)
    local cam = camera_manager.cameras[name]
    if(cam) then         
        cam.view    = hmm.HMM_LookAt_RH(cam.position, cam.target, cam.up)
        cam.mvp     = hmm.HMM_MulM4(cam.view_proj, model_mat)
        return cam.mvp
    end 
    return nil 
end

-- --------------------------------------------------------------------------------------

local function apply( name )
    local cam = camera_manager.cameras[name]
    if(cam) then       
        local vp = cam.viewport  
        local sc = cam.scissor
        sg.sg_apply_viewport(vp.x, vp.y, vp.z, vp.W, true)
        sg.sg_apply_scissor_rect(sc.x, sc.y, sc.z, sc.W, true)
    end
end

-- --------------------------------------------------------------------------------------
-- Render pass example.
-- sg.sg_apply_pipeline(pip)
-- sg.sg_apply_bindings(bind)

-- geom.vs_params[0].mvp    = mvp
-- sg.sg_apply_uniforms(sg.SG_SHADERSTAGE_VS,  geom.vs_sg_range)
-- sg.sg_apply_uniforms(sg.SG_SHADERSTAGE_FS,  geom.fs_sg_range)

-- sg.sg_apply_viewport(model_rect.x, model_rect.y, model_rect.w, model_rect.h, true)
-- sg.sg_apply_scissor_rect(model_rect.x, model_rect.y, model_rect.w, model_rect.h, true)

-- sg.sg_draw(0, geom.count, 1)

-- --------------------------------------------------------------------------------------

return {
    add_default         = add_default,
    add_pass            = add_pass,
    add                 = add,

    is_active           = is_active,

    get                 = get,
    get_id              = get_id,
    get_active          = get_active,
    get_mvp             = get_mvp,

    get_passes          = get_passes,
    get_view            = get_view,
    get_projection      = get_projection,
    get_view_proj       = get_view_proj,
    get_aspect_ratio    = get_aspect_ratio,

    set_aspect          = set_aspect,
    set_nearfar         = set_nearfar,

    update_viewport     = update_viewport,
    update_scissor      = update_scissor,
    apply_viewport      = apply_viewport,
    apply_scissor       = apply_scissor,
    apply               = apply,
    delete              = delete,
    lookat              = lookat,

    cameras_active      = camera_manager.cameras_active,
}

-- --------------------------------------------------------------------------------------