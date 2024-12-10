local sg        = _G.sg or require("ffi.sokol.sokol_gfx")

local hmm_utils = {}

hmm_utils.dump_mat4 = function( m )

    print("----- hmm_mat4")
    print("Row 0: "..m.Elements[0][0].." "..m.Elements[0][1].." "..m.Elements[0][2].." "..m.Elements[0][3].." ")
    print("Row 1: "..m.Elements[1][0].." "..m.Elements[1][1].." "..m.Elements[1][2].." "..m.Elements[1][3].." ")
    print("Row 2: "..m.Elements[2][0].." "..m.Elements[2][1].." "..m.Elements[2][2].." "..m.Elements[2][3].." ")
    print("Row 3: "..m.Elements[3][0].." "..m.Elements[3][1].." "..m.Elements[3][2].." "..m.Elements[3][3].." ")
end

hmm_utils.dump_vec3 = function( v )

    print("----- hmm_vec3")
    print("X: "..v.X.." Y: "..v.Y.." Z: "..v.Z)
end

hmm_utils.dump_vec4 = function( v )

    print("----- hmm_vec4")
    print("X: "..v.X.." Y: "..v.Y.." Z: "..v.Z.." W: "..v.W)
end

hmm_utils.show_stats = function()

    if(sg.sg_frame_stats_enabled() == false) then sg.sg_enable_frame_stats() end

    local stats = sg.sg_query_frame_stats()
    local redtext = "\27[31m"
    local whitetext = "\27[37m"
    if(stats.frame_index > 1) then io.write("\27[8A") end
    io.write(redtext.."frame_index: "..stats.frame_index.."\n")
    io.write(whitetext.."num_passes: "..stats.num_passes.."\n")
    io.write("num_apply_pipeline: "..stats.num_apply_pipeline.."\n")
    io.write("num_apply_bindings: "..stats.num_apply_bindings.."\n")
    io.write("num_apply_uniforms: "..stats.num_apply_uniforms.."\n")
    io.write("size_apply_uniforms: "..stats.size_apply_uniforms.."\n")
    io.write("num_bind_buffer: "..stats.gl.num_bind_buffer.."\n")
    io.write("num_bind_sampler: "..stats.gl.num_bind_sampler.."\n")
end

return hmm_utils