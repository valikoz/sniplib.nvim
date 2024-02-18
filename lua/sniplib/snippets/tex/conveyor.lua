--[[ Imports ]]
local ls = require("luasnip")
local make_condition = require("luasnip.extras.conditions").make_condition
local conditions = require("sniplib.snippets.tex.utils.conditions")
local in_math = make_condition(conditions.in_math)
local no_backslash = conditions.no_backslash
local utils = require('sniplib.snippets.tex.utils')
local toautobs = require('sniplib.snippets.tex.utils.symbols').toautobs
local fortips = require('sniplib.snippets.tex.utils.symbols').fortips

local M = {}

M.autosnippets = {}
M.snippets = {}

-- Make auto backslash snippets
local regtrig = nil
for _, v in pairs(toautobs) do
  for _, snip_args in ipairs(v) do
    if not snip_args.context.trig then
		  error("context doesn't include a `trig` key which is mandatory", 2)
      goto skip_to_next
    elseif string.match(snip_args.context.trig, "%[.*%]") then
      regtrig = true
    else
      regtrig = false
    end
    table.insert(M.autosnippets,
      utils.bs_snip(
        {
          trig = snip_args.context.trig,
          dscr = snip_args.context.dscr or "auto backslash",
          priority = snip_args.context.priority or 1000,
          wordTrig = false,
          regTrig = regtrig,
        }, { condition = in_math * no_backslash }
      )
    )
    ::skip_to_next::
  end
end

-- Make normal bs snippets for cmp
for _, v in pairs(fortips) do
  for _, snip_args in ipairs(v) do
    table.insert(M.snippets,
      utils.bs_snip(
        snip_args.context,
        {show_condition = in_math * no_backslash}
      )
    )
  end
end

ls.add_snippets("tex", M.autosnippets, {
  type = "autosnippets",
})

ls.add_snippets("tex", M.snippets)
