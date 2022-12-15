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


-- Deepslate:


if minetest.registered_nodes['mcl_deepslate:deepslate'] then
    minetest.register_alias('deepslate:deepslate', 'mcl_deepslate:deepslate')
else
    minetest.register_node('deepslate:deepslate',
    {
        description       = S('Deepslate');
        tiles             = {'mcl_deepslate_top.png', 'mcl_deepslate_top.png', 'mcl_deepslate.png'};
        sounds            = deepslate.sounds.node_sound_stone_defaults();
        paramtype2        = 'wallmounted';
        drop              = 'deepslate:deepslate_cobble';
        is_ground_content = true;
        groups =
        {
            cracky      = 3;
            pickaxey    = 1;
            level       = deepslate.settings.level;
            stone       = 1;
            deepslate   = 1;
        };
        _mcl_hardness = 3.0;
        _doc_items_longdesc = S('Deepslate is a type of stone that can be found deep underground. It can be used in place of stone for crafting tools.');
    });

    minetest.register_alias('mcl_deepslate:deepslate', 'deepslate:deepslate');

    minetest.register_craft(
    {
        type   = 'cooking';
        output = 'deepslate:deepslate';
        recipe = 'deepslate:deepslate_cobble';
        cooktime = 10.0;
    });
end;


-- Cobbled deepslate:


if minetest.registered_nodes['mcl_deepslate:deepslate_cobbled'] then
    minetest.register_alias('deepslate:deepslate_cobble', 'mcl_deepslate:deepslate_cobbled')
else
    minetest.register_node('deepslate:deepslate_cobble',
    {
        description       = S('Cobbled Deepslate');
        tiles             = {'mcl_cobbled_deepslate.png'};
        sounds            = deepslate.sounds.node_sound_stone_defaults();
        is_ground_content = true;
        groups =
        {
            cracky      = 3;
            pickaxey    = 1;
            level       = deepslate.settings.level;
            stone       = 2;
            cobble      = 1;
            deepslate   = 1;
        };
        _mcl_hardness = 3.5;
    });

    minetest.register_alias('mcl_deepslate:deepslate_cobbled', 'deepslate:deepslate_cobble');

    deepslate.register_shapes('deepslate:deepslate_cobble');
end;


-- Deepslate bricks:


if minetest.registered_nodes['mcl_deepslate:deepslate_bricks'] then
    minetest.register_alias('deepslate:deepslate_brick', 'mcl_deepslate:deepslate_bricks');
else
    minetest.register_node('deepslate:deepslate_brick',
    {
        description       = deepslate.settings.use_mcl_names and S('Deepslate Bricks') or S('Deepslate Brick');
        tiles             = {'mcl_deepslate_bricks.png'};
        sounds            = deepslate.sounds.node_sound_stone_defaults();
        is_ground_content = false;
        groups =
        {
            cracky      = 2;
            pickaxey    = 1;
            level       = deepslate.settings.level;
            stone       = 1;
            stonebrick  = 1;
            deepslate   = 1;
        };
        _mcl_hardness = 3.5;
    });

    minetest.register_alias('mcl_deepslate:deepslate_bricks', 'deepslate:deepslate_brick');

    deepslate.register_shapes('deepslate:deepslate_brick');

    if deepslate.settings.use_mcl_recipes then
        minetest.register_craft(
        {
            output = 'deepslate:deepslate_brick 4';
            recipe =
            {
                {'deepslate:deepslate_block', 'deepslate:deepslate_block'},
                {'deepslate:deepslate_block', 'deepslate:deepslate_block'},
            };
        });
    else
        minetest.register_craft(
        {
            output = 'deepslate:deepslate_brick 4';
            recipe =
            {
                {'deepslate:deepslate', 'deepslate:deepslate'},
                {'deepslate:deepslate', 'deepslate:deepslate'},
            };
        });
    end;
    deepslate.register_rp_craft({'deepslate:deepslate'}, 'deepslate:deepslate_brick');
end;


-- Cracked deepslate bricks:


if minetest.registered_nodes['mcl_deepslate:deepslate_bricks_cracked'] then
    minetest.register_alias('deepslate:deepslate_brick_cracked', 'mcl_deepslate:deepslate_bricks_cracked');
else
    minetest.register_node('deepslate:deepslate_brick_cracked',
    {
        description       = deepslate.settings.use_mcl_names and S('Cracked Deepslate Bricks') or S('Cracked Deepslate Brick');
        tiles             = {'mcl_cracked_deepslate_bricks.png'};
        sounds            = deepslate.sounds.node_sound_stone_defaults();
        is_ground_content = false;
        groups =
        {
            cracky      = 3;
            pickaxey    = 1;
            level       = deepslate.settings.level;
            stone       = 1;
            stonebrick  = 1;
            deepslate   = 1;
            cracked     = 1;
        };
        _mcl_hardness = 3.5;
    });

    minetest.register_alias('mcl_deepslate:deepslate_bricks_cracked', 'deepslate:deepslate_brick_cracked');

    minetest.register_craft(
    {
        type   = 'cooking';
        output = 'deepslate:deepslate_brick_cracked';
        recipe = 'deepslate:deepslate_brick';
        cooktime = 10.0;
    });
end;


-- Chiselled deepslate:


if minetest.registered_nodes['mcl_deepslate:deepslate_chiseled'] then
    minetest.register_alias('deepslate:deepslate_chiselled', 'mcl_deepslate:deepslate_chiseled');
else
    minetest.register_node('deepslate:deepslate_chiselled',
    {
        description       = S('Chiselled Deepslate');
        tiles             = {'mcl_chiseled_deepslate.png'};
        sounds            = deepslate.sounds.node_sound_stone_defaults();
        is_ground_content = false;
        groups =
        {
            cracky      = 2;
            pickaxey    = 1;
            level       = deepslate.settings.level;
            stone       = 1;
            deepslate   = 1;
        };
        _mcl_hardness = 3.5;
    });

    minetest.register_alias('mcl_deepslate:deepslate_chiseled', 'deepslate:deepslate_chiselled');

    if deepslate.settings.use_mcl_recipes then
        minetest.register_craft(
        {
            output = 'deepslate:deepslate_chiselled';
            recipe =
            {
                {'group:deepslate,slab'},
                {'group:deepslate,slab'},
            };
        });
    else
        minetest.register_craft(
        {
            output = 'deepslate:deepslate_chiselled 2';
            recipe =
            {
                {'group:deepslate,slab', '',                     'group:deepslate,slab'};
                {'',                     'group:deepslate,slab', ''};
                {'',                     'group:deepslate,slab', ''};
            };
        });
    end;
    deepslate.register_rp_craft({'deepslate:deepslate'}, 'deepslate:deepslate_chiselled');
end;


-- Deepslate block (polished deepslate):


if minetest.registered_nodes['mcl_deepslate:deepslate_polished'] then
    minetest.register_alias('deepslate:deepslate_block', 'mcl_deepslate:deepslate_polished');
else
    minetest.register_node('deepslate:deepslate_block',
    {
        description       = deepslate.settings.use_mcl_names and S('Polished Deepslate') or S('Deepslate Block');
        tiles             = {'mcl_polished_deepslate.png'};
        sounds            = deepslate.sounds.node_sound_stone_defaults();
        is_ground_content = false;
        groups =
        {
            cracky      = 2;
            pickaxey    = 1;
            level       = deepslate.settings.level;
            stone       = 1;
            deepslate   = 1;
        };
        _mcl_hardness = 3.5;
    });

    minetest.register_alias('mcl_deepslate:deepslate_polished', 'deepslate:deepslate_block');

    deepslate.register_shapes('deepslate:deepslate_block');

    if deepslate.settings.use_mcl_recipes then
        minetest.register_craft(
        {
            output = 'deepslate:deepslate_block 4';
            recipe =
            {
                {'deepslate:deepslate_cobble', 'deepslate:deepslate_cobble'},
                {'deepslate:deepslate_cobble', 'deepslate:deepslate_cobble'},
            };
        });
    else
        minetest.register_craft(
        {
            output = 'deepslate:deepslate_block 9';
            recipe =
            {
                {'deepslate:deepslate', 'deepslate:deepslate', 'deepslate:deepslate'},
                {'deepslate:deepslate', 'deepslate:deepslate', 'deepslate:deepslate'},
                {'deepslate:deepslate', 'deepslate:deepslate', 'deepslate:deepslate'},
            };
        });
    end;
    deepslate.register_rp_craft({'deepslate:deepslate'}, 'deepslate:deepslate_block');
end;


--  Deepslate tiles:


if minetest.registered_nodes['mcl_deepslate:deepslate_tiles'] then
    minetest.register_alias('deepslate:deepslate_tiles', 'mcl_deepslate:deepslate_tiles');
else
    minetest.register_node('deepslate:deepslate_tiles',
    {
        description       = S('Deepslate Tiles');
        tiles             = {'mcl_deepslate_tiles.png'};
        sounds            = deepslate.sounds.node_sound_stone_defaults();
        is_ground_content = false;
        groups =
        {
            cracky      = 2;
            pickaxey    = 1;
            level       = deepslate.settings.level;
            stone       = 1;
            deepslate   = 1;
        };
        _mcl_hardness = 3.5;
    });

    minetest.register_alias('mcl_deepslate:deepslate_tiles', 'deepslate:deepslate_tiles');

    deepslate.register_shapes('deepslate:deepslate_tiles');

    minetest.register_craft(
    {
        output = 'deepslate:deepslate_tiles 4';
        recipe =
        {
            {'deepslate:deepslate_brick', 'deepslate:deepslate_brick'},
            {'deepslate:deepslate_brick', 'deepslate:deepslate_brick'},
        };
    });
    deepslate.register_rp_craft({'deepslate:deepslate'}, 'deepslate:deepslate_tiles');
end;


-- Cracked deepslate tiles:


if minetest.registered_nodes['mcl_deepslate:deepslate_tiles_cracked'] then
    minetest.register_alias('deepslate:deepslate_tiles_cracked', 'mcl_deepslate:deepslate_tiles_cracked');
else
    minetest.register_node('deepslate:deepslate_tiles_cracked',
    {
        description       = S('Cracked Deepslate Tiles');
        tiles             = {'mcl_cracked_deepslate_tiles.png'};
        sounds            = deepslate.sounds.node_sound_stone_defaults();
        is_ground_content = false;
        groups =
        {
            cracky      = 3;
            pickaxey    = 1;
            level       = deepslate.settings.level;
            stone       = 1;
            deepslate   = 1;
            cracked     = 1;
        };
        _mcl_hardness = 3.5;
    });

    minetest.register_alias('mcl_deepslate:deepslate_tiles_cracked', 'deepslate:deepslate_tiles_cracked');

    minetest.register_craft(
    {
        type   = 'cooking';
        output = 'deepslate:deepslate_tiles_cracked';
        recipe = 'deepslate:deepslate_tiles';
        cooktime = 10.0;
    });
end;


-- Deepslate pillar:


minetest.register_node('deepslate:deepslate_pillar',
{
    description       = S('Deepslate Pillar');
    tiles             = {'deepslate_deepslate_pillar_top.png', 'deepslate_deepslate_pillar_top.png', 'deepslate_deepslate_pillar.png'};
    paramtype2        = 'wallmounted';
    sounds            = deepslate.sounds.node_sound_stone_defaults();
    is_ground_content = false;
    groups =
    {
        cracky      = 2;
        pickaxey    = 1;
        level       = deepslate.settings.level;
        stone       = 1;
        deepslate   = 1;
    };
    _mcl_hardness = 3.5;
});

minetest.register_craft(
{
    output = 'deepslate:deepslate_pillar 2';
    recipe =
    {
        {'deepslate:deepslate'},
        {'deepslate:deepslate'},
    };
});
deepslate.register_rp_craft({'deepslate:deepslate'}, 'deepslate:deepslate_pillar');
