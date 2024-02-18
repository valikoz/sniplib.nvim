--[[
w --> snippet will not expand at word boundaries, wordTrig=true (by default);
r --> regular trigger, regTrig=false;
A --> auto expand, snippetType="autosnippet".
]]

--[[ Imports ]]
local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local fmta = require("luasnip.extras.fmt").fmta

local make_condition = require("luasnip.extras.conditions").make_condition
local conditions = require("sniplib.snippets.tex.utils.conditions")
local in_math = make_condition(conditions.in_math)
local snippet = require('luasnip').extend_decorator.apply(s,
  {
    regTrig = true,
    snippetType = "autosnippet",
  },
  { condition = in_math, }
)
local utils = require('sniplib.snippets.tex.utils')
local symbols = require('sniplib.snippets.tex.utils.symbols')

local math_wrA = {
	snippet(
		{
			trig = "(%b())/",
			-- trig = [[left%p(.+)\right%p/]],
			-- trig = [[left%((.+)\right%)/]],
			-- trigEngine = "pattern",
			-- trig = [[(.*)/]],
			-- trigEngine = "vim",
      dscr = [[\frac{...} (parentheses) (wrA)]],
      priority = 1000
		},
		fmta(
      [[\frac{<>}{<>}<>]],
			{
        f(function(_, snip) return snip.captures[1] end, {}),
        c(1,
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
	snippet(
		{
      trig = "lr(%a)",
      name = "left right",
      dscr = [[\left.. \right.. delimiters]],
      docTrig = "lrp"
    },
		fmta(
			[[
      \left<> <> \right<><>
      ]],
			{
				f(function(_, snip)
					local cap = snip.captures[1]
					if symbols.delimiters[cap] == nil then
						cap = "p"
					end -- set default to parentheses
					return symbols.delimiters[cap][1]
				end),
				d(1, utils.get_visual),
				f(function(_, snip)
					local cap = snip.captures[1]
					if symbols.delimiters[cap] == nil then
						cap = "p"
					end
					return symbols.delimiters[cap][2]
				end),
				i(0),
			}
		)
	),
	snippet(
		{
      trig = "ri(%a)",
      name = "right",
      dscr = [[\right.. delimiter]],
      docTrig = "rip"
    },
		fmta(
			[[
      \right<><>
      ]],
			{
				f(function(_, snip)
					local cap = snip.captures[1]
					if symbols.delimiters[cap] == nil then
						cap = "p"
					end
					return symbols.delimiters[cap][2]
				end),
				i(0),
			}
		)
	),
	snippet(
		{
      trig = "le(%a)",
      name = "left",
      dscr = [[\left.. delimiter]],
      docTrig = "lep"
    },
		fmta(
			[[
      \left<> <>
      ]],
			{
				f(function(_, snip)
					local cap = snip.captures[1]
					if symbols.delimiters[cap] == nil then
						cap = "p"
					end -- set default to parentheses
					return symbols.delimiters[cap][1]
				end),
				i(0),
			}
		)
	),
  snippet(
    {
      trig = "([bBpvV])mat(%d+)(%d+)",
      dscr = [[\begin{_matrix}...\end{_matrix} (wrA)]],
      docTrig = "bmat22r",
      docstring = "",
    },
	  fmta([[
      \begin{<>}
      <>
      \end{<>}]],
	    {
        f(function(_, snip)
          return snip.captures[1] .. "matrix"
        end),
      	d(1, utils.mat),
      	f(function(_, snip)
          	return snip.captures[1] .. "matrix"
      	end)
      }
    )
	),
	snippet(
		{
      trig = "([clvda])%.",
      dscr = [[\_dots (wrA)]]
    },
		fmta([[\<>dots]], {
      f(function(_, snip) return snip.captures[1] end, {})
    })
	),
	snippet(
		{
      trig = "(%d)int",
      dscr = "multi integrals (wrA)",
      docTrig = "1int",
      docstring = [[ \int_{} d ]]
    },
		fmta(
			[[<> <> <> <>]],
			{
        sn(1,
				  fmta(
					  [[ \<><>nt<> ]],
					  {
						  c(1, { t "" , t "o" }),
						  f(function(_, parent, _)
							  local inum = tonumber(parent.parent.captures[1])
							  local res = string.rep("i", inum or 0)
							  return res
						  end),
						  c(2,
                {
                  fmta("_{<>}", {i(1)} ),
                  fmta([[\limits_{<>}^{<>}]], { i(1), i(2) } )
                }
              )
					  }
				  )
        ),
				i(2),
				d(3, utils.integrals),
				i(0),
			}
		)
	),
  snippet(
    {
      trig = "(%d?)cases",
      name = "cases",
      dscr = "\\begin{cases}...\\end{cases}",
      docTrig = "cases"
    },
    fmta([[
      \begin{cases}
      <>
      \end{cases}
      ]],
	  { d(1, utils.case) })
	),
}

return math_wrA
