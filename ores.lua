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


local function extract_ore_texture(tile)
    if type(tile) ~= 'string' then
        tile = tile.name;
    end;
    return string.match(tile, '^default_stone%.png%^(.*)');
end;


function deepslate.register_ore(name, ore_name, options, override)
    --[[
        Registers a deepslate version of the specified ore node.

        Returns true if the ore node was defined, or false if the
        original ore is not available.
    ]]

    local ore_def = minetest.registered_nodes[ore_name];
    if not ore_def then
        return false;
    end;

    options  = options  or {};
    override = override or {};

    -- Groups:
    local groups = table.copy(ore_def.groups or {});
    groups.deepslate = 1;
    groups.pickaxey  = groups.pickaxey or groups.level or 3;
    groups.level     = deepslate.settings.level + (groups.level or 0);
    for key, value in pairs(override.groups or {}) do
        groups[key] = value;
    end;

    -- Textures:
    local function _create_texture(stone, ore)
        assert(ore, ('[Deepslate] Could not extract overlay texture from %q.'):format(ore_name));
        if string.find(stone, '[()^]') or string.find(ore, '[()^]') then
            -- Complex textures — explicitly scale to a constant size:
            local size = 256;
            return string.format('((%s)^[resize:256x256)^((%s)^[resize:%dx%d)', stone, ore, size, size);
        else
            -- Simple textures — implicitly scale to the largest size:
            return string.format('%s^%s', stone, ore);
        end;
    end;
    local ore_texture  = options.ore_texture or extract_ore_texture(ore_def.tiles[1]);
    local top_texture  = _create_texture('mcl_deepslate_top.png', ore_texture);
    local side_texture = _create_texture('mcl_deepslate.png',     ore_texture);

    -- Drops:
    local drop = ore_def.drop;
    if drop == ore_name or (type(drop) == 'table' and drop.name == ore_name) then
        drop = name;
    end;

    -- Definition:
    local def =
    {
        description       = S('Deepslate @1', ore_def.description);
        tiles             = {top_texture, top_texture, side_texture};
        sounds            = ore_def.sounds or deepslate.sounds.node_sound_stone_defaults();
        groups            = groups;
        drop              = drop;
        light_source      = ore_def.light_source;
        is_ground_content = true;
        _mcl_hardness     = 4.5;
    };

    -- Overrides:
    for key, value in pairs(override) do
        def[key] = value;
    end;

    minetest.register_node(name, def);

    table.insert(deepslate.ores, name);
    deepslate.register_conversion(ore_name, name);

    -- Smelting:
    local result = minetest.get_craft_result{method = 'cooking', items = {ore_name}};
    if result.time > 0 then
        minetest.register_craft(
        {
            type   = 'cooking';
            output = result.item:to_string();
            recipe = name;
            time   = result.time;
        });
    end;

    return true;
end;


-- Minetest Game:
deepslate.register_ore('deepslate:deepslate_with_coal',         'default:stone_with_coal', {ore_texture = 'default_mineral_coal.png^[multiply:#BFBFBF'});
deepslate.register_ore('deepslate:deepslate_with_copper',       'default:stone_with_copper');
deepslate.register_ore('deepslate:deepslate_with_tin',          'default:stone_with_tin');
deepslate.register_ore('deepslate:deepslate_with_iron',         'default:stone_with_iron');
deepslate.register_ore('deepslate:deepslate_with_diamond',      'default:stone_with_diamond');
deepslate.register_ore('deepslate:deepslate_with_gold',         'default:stone_with_gold');
deepslate.register_ore('deepslate:deepslate_with_mese',         'default:stone_with_mese');

-- More Ores:
deepslate.register_ore('deepslate:deepslate_with_mithril',      'moreores:mineral_mithril');
deepslate.register_ore('deepslate:deepslate_with_silver',       'moreores:mineral_silver');

-- Technic:
deepslate.register_ore('deepslate:deepslate_with_chromium',     'technic:mineral_chromium');
deepslate.register_ore('deepslate:deepslate_with_lead',         'technic:mineral_lead');
deepslate.register_ore('deepslate:deepslate_with_sulfur',       'technic:mineral_sulfur');
deepslate.register_ore('deepslate:deepslate_with_uranium',      'technic:mineral_uranium');
deepslate.register_ore('deepslate:deepslate_with_zinc',         'technic:mineral_zinc');

-- Glooptest:
deepslate.register_ore('deepslate:deepslate_with_alatro',       'glooptest:mineral_alatro');
deepslate.register_ore('deepslate:deepslate_with_arol',         'glooptest:mineral_arol');
deepslate.register_ore('deepslate:deepslate_with_amethyst',     'glooptest:mineral_amethyst');
deepslate.register_ore('deepslate:deepslate_with_emerald',      'glooptest:mineral_emerald');
deepslate.register_ore('deepslate:deepslate_with_kalite',       'glooptest:mineral_kalite');
deepslate.register_ore('deepslate:deepslate_with_ruby',         'glooptest:mineral_ruby');
deepslate.register_ore('deepslate:deepslate_with_sapphire',     'glooptest:mineral_sapphire');
deepslate.register_ore('deepslate:deepslate_with_talinite',     'glooptest:mineral_talinite');
deepslate.register_ore('deepslate:deepslate_with_topaz',        'glooptest:mineral_topaz');

-- Repixture:
deepslate.register_ore('deepslate:deepslate_with_coal',         'rp_default:stone_with_coal');
deepslate.register_ore('deepslate:deepslate_with_graphite',     'rp_default:stone_with_graphite');
deepslate.register_ore('deepslate:deepslate_with_tin',          'rp_default:stone_with_tin');
deepslate.register_ore('deepslate:deepslate_with_copper',       'rp_default:stone_with_copper');
deepslate.register_ore('deepslate:deepslate_with_iron',         'rp_default:stone_with_iron');
deepslate.register_ore('deepslate:deepslate_with_sulfur',       'rp_default:stone_with_sulfur');
deepslate.register_ore('deepslate:deepslate_with_gold',         'rp_gold:stone_with_gold');
deepslate.register_ore('deepslate:deepslate_with_lumien',       'rp_lumien:stone_with_lumien');

-- Techage:
deepslate.register_ore('deepslate:deepslate_with_baborium',     'techage:stone_with_baborium');

-- Blox:
deepslate.register_ore('deepslate:deepslate_with_glow_ore',     'blox:glowore');

-- Quartz:
deepslate.register_ore('deepslate:deepslate_with_quartz',       'quartz:quartz_ore');

-- Lapis Lazuli:
deepslate.register_ore('deepslate:deepslate_with_lapis',        'lapis:stone_with_lapis');

-- Rainbow Ore:
deepslate.register_ore('deepslate:deepslate_with_rainbow_ore',  'rainbow_ore:rainbow_ore_block',
{
    ore_texture = 'raibow_ore.png'; -- The spelling mistake is from the Rainbow Ore mod.
});

-- Legendary Ore:
deepslate.register_ore('deepslate:deepslate_with_legendary_ore', 'legendary_ore:legendary_ore',
{
    ore_texture = 'legendary_ore_ore.png';
});

-- Titanium:
deepslate.register_ore('deepslate:deepslate_with_titanium',     'titanium:titanium_in_ground');

-- Ethereal:
deepslate.register_ore('deepslate:deepslate_with_etherium_ore', 'ethereal:stone_with_etherium_ore');
