--[[
i --> the snippet is expanded even if the word ([%w_]+) before
the cursor does not match the trigger entirely, wordTrig=false;
A --> auto expand, snippetType="autosnippet".
]]
--[[ Snippets
-- matrix  -- 
]]

--[[ Imports ]]
local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local extras = require("luasnip.extras")
local rep = extras.rep
local fmta = require("luasnip.extras.fmt").fmta

local make_condition = require("luasnip.extras.conditions").make_condition
local conditions = require("sniplib.snippets.tex.utils.conditions")
local in_math = make_condition(conditions.in_math)
local snippet = require("luasnip").extend_decorator.apply(s,
  {}, { show_condition = in_math }
)

local math_w = {
  snippet(
    {
      trig = "vec2",
      name = [[pmatrix]],
      dscr = [[\begin{pmatrix}...\end{pmatrix} () vector (w)]]
    },
    fmta([[
      \begin{pmatrix} <> \\ <> \end{pmatrix}
      ]],
      { i(1, 'x'), i(2, 'y') }
    ),
    { show_condition = in_math }
  ),
  snippet(
    {
      trig = "vec3",
      name = [[pmatrix]],
      dscr = [[\begin{pmatrix}...\end{pmatrix} () vector (w)]]
    },
    fmta([[
      \begin{pmatrix} <> \\ <> \\ <> \end{pmatrix}
      ]],
      { i(1, 'x'), i(2, 'y'), i(0, 'z') }
    ),
    { show_condition = in_math }
  ),
  snippet(
    {
      trig = "zin2",
      name = [[bmatrix]],
      dscr = [[\begin{bmatrix}...\end{bmatrix} [] vector (w)]]
    },
    fmta([[
      \begin{bmatrix} <> \\ <> \end{bmatrix}
      ]],
      { i(1, 'x'), i(2, 'y') }
    ),
    { show_condition = in_math }
  ),
  snippet(
    {
      trig = "zin3",
      name = [[bmatrix]],
      dscr = [[\begin{bmatrix}...\end{bmatrix} [] vector (w)]]
    },
    fmta([[
      \begin{bmatrix} <> \\ <> \\ <> \end{bmatrix}
      ]],
      { i(1, 'x'), i(2, 'y'), i(3, 'z') }
    ),
    { show_condition = in_math }
  ),
}

return math_w
