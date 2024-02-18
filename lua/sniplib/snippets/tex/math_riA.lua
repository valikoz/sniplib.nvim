--[[
WARN: snippets are activated in spite of the match_pattern?

Move into math_riA_v1

r --> regex;
i --> snippet will expand at word boundaries, wordTrig=false;
A --> auto expand, snippetType="autosnippet".
]]

--[[ Imports ]]
local ls = require("luasnip")
local sn = ls.snippet_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local extras = require("luasnip.extras")
local l = extras.lambda
local fmta = require("luasnip.extras.fmt").fmta
local postfix = require("luasnip.extras.postfix").postfix

local make_condition = require("luasnip.extras.conditions").make_condition
local conditions = require("sniplib.snippets.tex.utils.conditions")
local in_math = make_condition(conditions.in_math)
local context_extend = require("sniplib.snippets.tex.utils").context_extend
require("luasnip").extend_decorator.register(postfix,
  { arg_indx = 1, extend = context_extend },
  { arg_indx = 3 }
)
local autopostfix = require("luasnip").extend_decorator.apply(postfix,
  { snippetType = "autosnippet" },
  { condition = in_math, }
)

local math_riA = {
  -- Conflict with matrix snippet:
	-- snippet(
	-- 	{
 --      trig = "(%a+)(%d)", dscr = "auto subscript"
 --    },
	-- 	fmta(
	-- 		[[<>_<>]],
	-- 		{
  --       f(function(_, snip) return snip.captures[1] end, {}),
 --        f(function(_, snip) return snip.captures[2] end, {})
 --      }
	-- 	)
	-- ),
	-- snippet(
	-- 	{
	-- 		trig = "(%a+)_(%d%d)", dscr = "auto subscript for 2+ digits",
	-- 	},
	-- 	fmta(
	-- 		[[<>_{<>}]],
	-- 		{
 --        f(function(_, snip) return snip.captures[1] end, {}),
 --        f(function(_, snip) return snip.captures[2] end, {})
 --      }
	-- 	)
	-- ),

  -- More about lua patterns http://www.lua.org/manual/5.1/manual.html#5.4.1
  autopostfix(
    {
      trig = "vec",
      dscr = "\\vector (riA: postfix)",
      match_pattern = "\\?%a+$",
      priority = 999
    },
    {
      l("\\vec{" .. l.POSTFIX_MATCH .. "}")
    }
  ),
  autopostfix(
    {
      trig = "hat",
      dscr = "\\hat (riA: postfix)",
      match_pattern="\\?%a+$",
      -- docstring = ""
    },
    {
      l("\\hat{" .. l.POSTFIX_MATCH .. "}")
    }
  ),
  autopostfix(
    {
      trig = "bar",
      dscr = "\\overline (riA: postfix)",
      match_pattern = "\\?%a+$",
    },
    {
      l("\\overline{" .. l.POSTFIX_MATCH .. "}")
    }
  ),
  autopostfix(
    {
      trig = "dot",
      dscr = "\\dot (riA: postfix)",
      match_pattern = "\\?%a+$",
    },
    {
      c(1,
        {
          sn(nil, { l("\\dot{" .. l.POSTFIX_MATCH .. "}"), i(1) }),
          sn(nil, { l("\\ddot{" .. l.POSTFIX_MATCH .. "}"), i(1) }),
          sn(nil, { l("\\dddot{" .. l.POSTFIX_MATCH .. "}"), i(1) })
        }
      )
    }
  ),
  autopostfix(
    {
      trig="/",
      dscr = "\\frac (riA: postfix)",
      priority = 999, -- important: prio of `fraction (wA)` is 1000
      match_pattern = "[^%s]$",
    },
    fmta(
      [[\frac{<>}{<>}<>]],
      {
        d(1,
          function (_, parent)
            return sn(nil,
            {
              c(1,
                {
                  i(1, parent.env.POSTFIX_MATCH),
                  sn(nil, fmta([[(<>)<>]], { i(1, parent.env.POSTFIX_MATCH), i(2) })),
                  sn(nil, fmta([[\left(<>\right)<>]], { i(1, parent.env.POSTFIX_MATCH), i(2) }))
                }
              )
            })
          end
        ),
        c(2,
          {
            r(1, '2', i(1)),
            sn(nil, fmta([[(<>)<>]], { r(1, '2'), i(2) })),
            sn(nil, fmta([[\left(<>\right)<>]], { r(1, '2'), i(2) }))
          }
        ),
        i(0)
      }
    )
  ),
  -- auto backslash \
  autopostfix({
      trig = [[.bs]],
      dscr = "auto backslash (riA: postfix)",
      match_pattern = "%a+",
    }, {
      f(function(_, parent)
          return "\\" .. parent.snippet.env.POSTFIX_MATCH
      end, {})
    }
  ),
  autopostfix(
    {
      trig = "mcal",
      dscr = [[\mathcal (riA: postfix)]],
      match_pattern = "\\?%a+$",
      priority = 1000
    },
    {
      l("\\mathcal{" .. l.POSTFIX_MATCH .. "}")
    }
  ),

}

-- return math_riA
