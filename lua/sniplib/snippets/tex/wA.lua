--[[
w --> snippet will not expand at word boundaries, wordTrig=true (by default);
A --> auto expand, snippetType="autosnippet".
]]
--[[ SNIPPETS
-- inline math $...$ (mk)  -- display math \[...\] (dm)
]]
--[[ Imports ]]
local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local i = ls.insert_node
local d = ls.dynamic_node
local fmta = require("luasnip.extras.fmt").fmta

local make_condition = require("luasnip.extras.conditions").make_condition
local conditions = require("sniplib.snippets.tex.utils.conditions")
local in_text = make_condition(conditions.in_text)
require("luasnip").extend_decorator.register(s, {arg_indx=1})
local snippet = require('luasnip').extend_decorator.apply(s,
  { snippetType = "autosnippet" }
)

local wA = {
  snippet(
    {
      trig = "mk",
      dscr = "inline math $$",
      docstring = "$$"
    },
	  fmta(
      [[
      $<>$<>
      ]],
	    { d(1,
          function(_, snip)
            local res, env = {}, snip.env
            for _, val in ipairs(env.LS_SELECT_RAW) do table.insert(res, val) end
            return  sn(nil, { i(1, res) })
          end, {}),
        i(0)
      }),
    { condition = in_text }
	),
  snippet(
    {
      trig = "dm",
      dscr = "display math \\[\\]",
      docstring = [[ \[ \] ]]
    },
	  fmta([[
      \[
        <>
      \]
      ]],
	    { d(1,
          function(_, snip)
            local res, env = {}, snip.env
            for _, val in ipairs(env.LS_SELECT_RAW) do table.insert(res, val) end
            return  sn(nil, { i(1, res) })
          end, {}),
      }),
    { condition = in_text }
	),
}

return wA
