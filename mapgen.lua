--[[
    Deepslate — adds deepslate and related building materials to Minetest
    Copyright © 2022, Silver Sandstone <@SilverSandstone@craftodon.social>

    Permission is hereby granted, free of charge, to any person obtaining a
    copy of this software and associated documentation files (the "Software"),
    to deal in the Software without restriction, including without limitation
    the rights to use, copy, modify, merge, publish, distribute, sublicense,
    and/or sell copies of the Software, and to permit persons to whom the
    Software is furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in
    all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
    FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
    DEALINGS IN THE SOFTWARE.
]]


local trans_top   = deepslate.settings.transition_top;
local fill_top    = deepslate.settings.fill_top;
local fill_bottom = deepslate.settings.fill_bottom;

local has_mcl_deepslate = minetest.get_modpath('mcl_deepslate') and minetest.settings:get_bool('mcl_generate_deepslate', true);

trans_top = math.max(trans_top, fill_top);
local trans_noiseparams =
{
    offset  = 0.375;
    scale   = 0.5;
    spread  = vector.new(5, 5, 5);
    seed    = 0x64656570;
    octaves = 1;
    persist = 0.0;
};


deepslate.PRESERVE_PARAM2 = '~';


function deepslate._get_cid_mapping()
    --[[
        Gets or creates the content ID mapping for deepslate conversion.

        Returns `{old_cid: new_cid}, {old_cid: new_param2}`.
    ]]

    local cid_mapping = {};
    local param2_mapping = {};

    for old_name, new_name in pairs(deepslate.conversion_mapping) do
        if minetest.registered_nodes[old_name] and minetest.registered_nodes[new_name] then
            local old_cid = minetest.get_content_id(old_name);
            local new_cid = minetest.get_content_id(new_name);
            local param2 = deepslate.conversion_mapping_param2[old_name] or 0;
            cid_mapping[old_cid] = new_cid;
            if param2 ~= deepslate.PRESERVE_PARAM2 then
                param2_mapping[old_cid] = param2;
            end;
        end;
    end;

    -- Cache the value for future invocations:
    function deepslate._get_cid_mapping()
        return cid_mapping, param2_mapping;
    end;

    return cid_mapping, param2_mapping;
end;


function deepslate.deepslatify_area(minp, maxp, lvm)
    --[[
        Converts an area to deepslate.

        `minp` and `maxp` specify the area to convert.

        `lvm` should be a VoxelManip object containing (but not necessarily
        equal to) the specified area, or nil to create an LVM automatically.
    ]]

    local cid_mapping, param2_mapping = deepslate._get_cid_mapping();

    if not lvm then
        lvm = VoxelManip(minp, maxp);
    end;
    local lvm_minp, lvm_maxp = lvm:get_emerged_area();

    local _should_convert_index;
    if minp.y > trans_top or maxp.y < fill_bottom then
        -- Above the transition area or below the fill area — cancel conversion:
        return;
    elseif maxp.y >= fill_bottom and minp.y <= fill_top then
        -- In the fill area — always convert:
        function _should_convert_index(index)
            return true;
        end;
    else
        -- In the transition area — convert according to Perlin noise with a gradient threshold:
        local lvm_area = VoxelArea:new{MinEdge = lvm_minp, MaxEdge = lvm_maxp};
        local gen_area = VoxelArea:new{MinEdge = minp,     MaxEdge = maxp};
        local perlin = minetest.get_perlin(trans_noiseparams);
        function _should_convert_index(index)
            local pos = lvm_area:position(index);
            if not gen_area:containsp(pos) then
                return false; -- Outside of the generating area — don't convert.
            elseif pos.y < fill_bottom or pos.y > trans_top then
                return false; -- Below the fill area or above the transition area — don't convert.
            elseif pos.y < fill_top then
                return true; -- In the fill area — convert.
            else
                -- In transition area — convert according to Perlin noise:
                local fill_progress = (pos.y - trans_top) / (fill_top - trans_top);
                return perlin:get_3d(pos) < fill_progress;
            end;
        end;
    end;

    local nodes = lvm:get_data();
    local param2s = lvm:get_param2_data();
    for index, value in pairs(nodes) do
        if _should_convert_index(index) then
            nodes[index] = cid_mapping[value] or value;
            param2s[index] = param2_mapping[value] or param2s[index];
        end;
    end;
    lvm:set_data(nodes);
    lvm:set_param2_data(param2s);
    lvm:write_to_map(false);

    if deepslate.settings.log_mapgen then
        local volume = (maxp.x + 1 - minp.x) * (maxp.y + 1 - minp.y) * (maxp.z + 1 - minp.z);
        minetest.debug(('[Deepslate] Converted area from %s to %s — %d nodes.'):format(vector.to_string(minp), vector.to_string(maxp), volume));
    end;
end;

if deepslate.settings.generate and not has_mcl_deepslate then
    local function on_generated(minp, maxp, blockseed)
        if maxp.y >= fill_bottom and minp.y <= trans_top then
            local lvm = minetest.get_mapgen_object('voxelmanip');
            deepslate.deepslatify_area(minp, maxp, lvm);
        end;
    end;

    minetest.register_on_generated(on_generated);
end;


function deepslate.register_conversion(from, to, param2)
    --[[
        Registers a node to be converted during deepslate generation.

        `from` is the name of the node to replace.

        `to` is the name of the node to replace it with.

        `param2` is the param2 value for the new node, or
        deepslate.PRESERVE_PARAM2 to keep the old node's param2.

        Returns true if the conversion was registered.
    ]]

    if not minetest.registered_nodes[from] then
        return false;
    elseif not minetest.registered_nodes[to] then
        minetest.log('warning', ('[Deepslate] Failed to register conversion from %q: %q doesn\'t exist.'):format(from, to));
        return false;
    end;

    deepslate.conversion_mapping[from] = to;
    deepslate.conversion_mapping_param2[from] = param2 or 0;
    return true;
end;


deepslate.register_conversion('default:stone',       'deepslate:deepslate', 1);
deepslate.register_conversion('default:cobble',      'deepslate:deepslate_brick');
deepslate.register_conversion('default:mossycobble', 'deepslate:deepslate_brick_cracked');
deepslate.register_conversion('default:stonebrick',  'deepslate:deepslate_brick');
deepslate.register_conversion('stairs:stair_cobble', 'stairs:stair_deepslate_brick', deepslate.PRESERVE_PARAM2);
