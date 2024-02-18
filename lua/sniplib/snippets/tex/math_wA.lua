--[[
w --> the snippet is only expanded if the word ([%w_]+) before
the cursor matches the trigger entirely, wordTrig=true;
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
local in_align = make_condition(conditions.in_align)
local snippet = require('luasnip').extend_decorator.apply(s,
  { snippetType = "autosnippet", },
  { condition = in_math, }
)
local utils = require("sniplib.snippets.tex.utils")


local math_wA = {
	snippet(
		{ trig = "//", dscr = "fraction (wA)", docstring = "" },
		fmta([[\frac{<>}{<>}<>]],
      { d(1,
          function(_, snip)
            local res = utils.select_raw(_, snip)
            return  sn(nil,
              {
                c(1,
                  {
                    sn(nil, { r(1, '1', i(1, res)) }),
                    sn(nil,
                      fmta([[(<>)<>]],
                        {
                          r(1, '1'), i(2)
                        }
                      )
                    ),
                    sn(nil,
                      fmta([[\left(<>\right)<>]],
                        {
                          r(1, '1'), i(2)
                        }
                      )
                    ),
                  }
                )
              }
            )
          end, {}),
        c(2,
            {
              sn(nil, { r(1, '2', i(1)) }),
              sn(nil,
                fmta([[(<>)<>]],
                  {
                    r(1, '2'), i(2)
                  }
                )
              ),
              sn(nil,
                fmta([[\left(<>\right)<>]],
                  {
                    r(1, '2'), i(2)
                  }
                )
              )
            }
        ), i(0)
      }
    )
  ),
	snippet(
		{ trig = "vec", dscr = [[\vec (wA)]], priority = 998, docstring = [[\vec{}]] },
		fmta([[\<>{<>}<>]],
      {
        f(function(_, snip) return snip.trigger end, {}),
        d(1, function(_, snip)
          local cap = utils.select_raw(_, snip)
          return sn(nil, {i(1, cap)})
        end, {}),
        i(0)
      }
    )
  ),
	snippet(
		{ trig = "hat", dscr = [[\hat (wA)]], docstring = [[\hat{}]] },
		fmta([[\<>{<>}<>]],
      {
        f(function(_, snip) return snip.trigger end, {}),
        d(1, function(_, snip)
          local cap = utils.select_raw(_, snip)
          return sn(nil, {i(1, cap)})
        end, {}),
        i(0)
      }
    )
  ),
	snippet(
		{ trig = "bar", dscr = [[\overline (wA)]], docstring = [[\overline{}]] },
		fmta([[\overline{<>}<>]],
      {
        d(1, function(_, snip)
          local cap = utils.select_raw(_, snip)
          return sn(nil, {i(1, cap)})
        end, {}),
        i(0)
      }
    )
  ),
	snippet(
		{ trig = "underbrace", dscr = [[\underbrace (wA)]], docstring = [[\underbrace{}]] },
		fmta([[\underbrace{<>}<>]],
      {
        d(1, function(_, snip)
          local cap = utils.select_raw(_, snip)
          return sn(nil, {i(1, cap)})
        end, {}),
        i(0)
      }
    )
  ),
	snippet(
		{ trig = "overbrace", dscr = [[\overbrace (wA)]], docstring = [[\overbrace{}]] },
		fmta([[\overbrace{<>}<>]],
      {
        d(1, function(_, snip)
          local cap = utils.select_raw(_, snip)
          return sn(nil, {i(1, cap)})
        end, {}),
        i(0)
      }
    )
  ),
	snippet(
		{ trig = "dot", dscr = [[\dot (wA)]], docstring = [[\dot{}]] },
		fmta([[\<>{<>}<>]],
      {
        c(1, { t "dot", t "ddot", t "dddot" }),
        d(2, function(_, snip)
          local cap = utils.select_raw(_, snip)
          return sn(nil, {i(1, cap)})
        end, {}),
        i(0)
      }
    )
  ),
	snippet(
		{ trig = "sum", dscr = [[\sum (wA)]] },
		fmta(
			[[
    \sum<> <>
    ]],
      {
        c(1,
          {
            t(""),
            fmta([[_{<>}^{<>}]], {i(1, "i=0"), i(2, "\\infty")}),
          }
        ), i(0)
      }
		)
	),
	snippet(
		{ trig = "lim", dscr = [[\lim (wA)]] },
    {
      c(1,
        {
		      fmta( [[ \lim_{<>} <> ]], { i(1), i(2) }),
		      fmta( [[ \limits_{<>} ]], { i(1) }),
		      fmta( [[ \limits_{<>}^{<>} ]], { i(1), i(2) }),
        }
      ),
    }
	),
  s(
    {
      trig = '==',
      name = '&= align',
      dscr = 'alignment for = in align environment (wA)',
      snippetType = "autosnippet"
    },
    fmta([[&<> <>]],
      { c(1, {t "=" , t "\\leq" , i(1)}), i(2) }
    ),
    { condition = in_align }
  ),
	snippet(
		{ trig = "dint", dscr = [[\int (wA)]] },
		{
		  c(1,
		    {
		      fmta( [[\int <> \, d <>]], { i(1), i(2) }),
		      fmta( [[\int\limits_{<>}^{<>} <> \, d <>]], {
		        i(1), i(2), i(3), i(4)
		      }),
		      fmta( [[\int\limits_{S} <> \, d S]], { i(1) }),
		      fmta( [[\int\limits_{V} <> \, d V]], { i(1) }),
		    }
		  )
		}
	),
	snippet(
		{ trig = "part", dscr = "partial derivative (wA)" },
		{
		  c(1,
		    {
		      fmta( [[\frac{\partial <>}{\partial <>} <>]],
			      { i(1), i(2), i(3) }
		      ),
		      fmta( [[\frac{\partial^2 <>}{\partial <>^2} <>]],
			      { i(1), i(2), i(3) }
		      ),
		      fmta( [[\frac{\partial <>}{\partial t} <>]],
			      { i(1), i(2) }
		      ),
		    }
		  ),
		}
	),
	snippet(
		{ trig = "ddt", dscr = "time derivative (wA)" },
		{
		  c(1,
		    {
		      fmta( [[ \frac{d <>}{d <>} <>]],
			      { i(1), i(2, "t"), i(0) }
		      ),
		      fmta( [[ \frac{d^2 <>}{d <>} <>]],
			      { i(1), i(2, "t^2"), i(0) }
		      ),
		    }
		  ),
		}
	),
}

return math_wA
