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


local function get_b(key, default)
    return minetest.settings:get_bool(key, default);
end;

local function get_i(key, default)
    return math.floor(tonumber(minetest.settings:get(key) or default));
end;


deepslate.settings =
{
    level           = get_i('deepslate.level',           0);
    generate        = get_b('deepslate.generate',        true);
    transition_top  = get_i('deepslate.transition_top',  -768);
    fill_top        = get_i('deepslate.fill_top',        -1024);
    fill_bottom     = get_i('deepslate.fill_bottom',     -32768);
    use_mcl_names   = get_b('deepslate.use_mcl_names',   false);
    use_mcl_recipes = get_b('deepslate.use_mcl_recipes', false);
    -- Advanced:
    log_mapgen      = get_b('deepslate.log_mapgen',      false);
};
