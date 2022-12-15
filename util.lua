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


local S = deepslate.S;


local mt = {};
if minetest.get_modpath('default') then
    -- Sounds from Minetest Game:
    mt.__index = default;
elseif minetest.get_modpath('mcl_sounds') then
    -- Sounds from MineClone:
    mt.__index = mcl_sounds;
elseif minetest.get_modpath('rp_sounds') then
    -- Sounds from Repixture:
    mt.__index = rp_sounds;
else
    -- No sounds ☹ — create a placeholder sounds API.
    local function node_sound_x_defaults(sounds)
        return sounds or {};
    end;

    function mt.__index(key)
        return node_sound_x_defaults;
    end;
end;
deepslate.sounds = setmetatable({}, mt);


function deepslate.register_shapes(name, subname)
    --[[
        Registers stairs, slabs, walls, etc. of the specified node.
    ]]

    local def = minetest.registered_nodes[name];
    assert(def, ('Node ‘%s’ does not exist!'):format(name));

    local mod = def.mod_origin;
    if not subname then
        subname = string.match(name, '.+:(.+)$');
        assert(subname);
    end;

    local groups = table.copy(def.groups or {});
    groups.stone = 0; -- Prevent using partial nodes in crafting recipes.

    -- Stairs and slabs:
    if minetest.get_modpath('rp_partialblocks') then
        -- Repixture:
        local old_register_item = minetest.register_item; -- Patch `minetest.register_item()` to work around a bug in Repixture.
        function minetest.register_item(name, itemdef)
            old_register_item(':' .. name, itemdef);
        end;
        partialblocks.register_material(subname, S('@1 Slab', def.description), S('@1 Stair', def.description), name, groups);
        minetest.register_item = old_register_item;
    elseif minetest.get_modpath('stairs') then
        if minetest.global_exists('stairsplus') then
            -- Stairs+ (More Blocks):
            stairsplus:register_all(mod, subname, name, def);
        elseif stairs.register_all then
            -- Stairs Redo:
            stairs.register_all(subname, name, groups, def.tiles, def.description, def.sounds, true);
        elseif stairs.register_stair_and_slab then
            -- Minetest Game:
            stairs.register_stair_and_slab(subname, name, groups, def.tiles,
                S('@1 Stair', def.description), S('@1 Slab', def.description), def.sounds, true,
                S('Inner @1 Stair', def.description), S('Outer @1 Stair', def.description));
        end;
    end;

    -- Walls:
    local wall_name = ('%s:wall_%s'):format(mod, subname);
    if minetest.get_modpath('walls') then
        walls.register(wall_name, S('@1 Wall', def.description), def.tiles, name, def.sounds);
    elseif minetest.get_modpath('xconnected') then
        xconnected.register_wall(wall_name, def.tiles[1], name);
    end;

    -- Station platforms:
    if minetest.get_modpath('advtrains') then
        advtrains.register_platform(mod, name);
    end;

    -- Castle masonry:
    if minetest.get_modpath('castle_masonry') then
        local material = {name = subname, desc = def.description, tile = def.tiles[1], craft_material = name};
        castle_masonry.register_pillar(material);
        castle_masonry.register_arrowslit(material);
        castle_masonry.register_murderhole(material);
    end;
end;


function deepslate.first_available_item(...)
    --[[
        Returns the first item available for crafting.
    ]]

    for __, name in ipairs{...} do
        if name == '' or string.match(name, '^group:.*') or minetest.registered_items[name] then
            return name;
        end;
    end;
    return nil;
end;


function deepslate.register_rp_craft(items, output)
    --[[
        Registers a Repixture crafting recipe if Repixture's crafting system
        is available.
    ]]

    if minetest.get_modpath('rp_crafting') then
        crafting.register_craft{output = output, items = items};
    end;
end;
