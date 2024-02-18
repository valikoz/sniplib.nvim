--[[
i --> the snippet is expanded even if the word ([%w_]+) before
the cursor does not match the trigger entirely, wordTrig=false;
A --> auto expand, snippetType="snippet".
]]

--[[ Imports ]]
local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local fmta = require("luasnip.extras.fmt").fmta

local make_condition = require("luasnip.extras.conditions").make_condition
local conditions = require("sniplib.snippets.tex.utils.conditions")
local in_math = make_condition(conditions.in_math)
local snippet = require("luasnip").extend_decorator.apply(s,
  {
    wordTrig = false,
    snippetType = "autosnippet",
  },
  { condition = in_math, }
)


local math_iA = {
  snippet({trig="sr", dscr="^2 (iA)"}, { t "^2" }),
	snippet({trig="cb", dscr="^3 (iA)"}, { t "^3"  }),
  -- "complement"
	snippet({trig="compl", dscr="^{c} (iA)"}, { t "^{c}"  }),
	snippet({trig="inv", dscr="^{-1} (iA)"}, { t "^{-1}"  }),
	snippet({
      trig = "td",
      dscr = "^{...} (iA)",
      docstring = "^{}"
    },
    fmta(
    [[^{<>}<>]],
	    { d(1,
          function(_, snip)
            local res, env = {}, snip.env
            for _, val in ipairs(env.LS_SELECT_RAW) do table.insert(res, val) end
            return sn(nil,
              { -- sn(...) first would cause infinite loop of expansion.
                c(1,
                  {
                    sn(nil, { r(1, '1', i(1, res)) }),
                    sn(nil,
                      fmta([[<>(<>)]],
                        {
                          i(1), r(2, '1')
                        }
                      )
                    ),
                    sn(nil,
                      fmta([[<>\left(<>\right)]],
                        {
                          i(1), r(2, '1')
                        }
                      )
                    )
                  }
                )
              }
            )
          end, {}),
        i(0)
      }
    )
  ),
	snippet({
      trig = "sq",
      dscr = [[\sqrt[]{...} (iA)]],
      docstring = [[\sqrt{}]]
    },
    fmta(
      [[\sqrt{<>}<>]],
	    {
        -- c(1, { t "", sn(nil, fmta("[<>]", { i(1, "3") })) }),
        d(1,
          function(_, snip)
            local res, env = {}, snip.env
            for _, val in ipairs(env.LS_SELECT_RAW) do table.insert(res, val) end
            return sn(nil,
              { -- sn(...) first would cause infinite loop of expansion.
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
                    )
                  }
                )
              }
            )
          end, {}),
        i(0)
      }
    )
  ),
  snippet({
      trig = ",,",
      dscr = "subscript _{} (iA)"
    },
    {
      c(1,
        {
          sn(nil, fmta([[_{<>}<>]], { r(1, '1.0.1', i(1)), i(0) })),
          sn(nil, fmta([[_<>]], { r(1, '1.0.1') }))
        }
      )
    }
  ),
  snippet(
    {
      trig = "fi",
      dscr = [[\varphi (iA)]]
    },
    { t([[\varphi]]) }
  ),
  snippet(
    {
      trig = "afa",
      dscr = [[\alpha (iA)]]
    },
    { t([[\alpha]]) }
  ),
  snippet(
    {
      trig = "<=",
      dscr = [[less or equal <= (iA)]]
    },
    { t([[\leq]]) }
  ),
  snippet(
    {
      trig = ">=",
      dscr = [[greater or equal >= (iA)]]
    },
    { t([[\geq]]) }
  ),
  snippet(
    {
      trig = "===",
      dscr = [[equivalent (iA)]]
    },
    { t([[\equiv]]) }
  ),
  snippet(
    {
      trig = "EE",
      dscr = [[\exists (iA)]]
    },
    { t([[\exists]]) }
  ),
  snippet(
    {
      trig = "AA",
      dscr = [[\forall (iA)]]
    },
    { t([[\forall]]) }
  ),
  snippet(
    {
      trig = "mcal",
      dscr = [[\mathcal (iA)]],
      priority = 999
    },
    fmta([[\mathcal{<>}<>]],
    { i(1), i(0) }
    )
  ),
  snippet(
    {
      trig = "mbb",
      dscr = [[\mathbb (iA)]]
    },
    fmta([[\mathbb{<>}<>]],
    { i(1), i(0) }
    )
  ),
  snippet(
    {
      trig = "inn",
      dscr = [[\in (iA)]]
    },
    { t([[\in]]) }
  ),
  snippet(
    {
      trig = "~~",
      dscr = [[\sim (iA)]]
    },
    { t([[\sim]]) }
  ),
  snippet(
    {
      trig = "~=",
      dscr = [[\simeq (iA)]]
    },
    { t([[\simeq]]) }
  ),
  snippet(
    {
      trig = "inf",
      dscr = [[\infty (iA)]]
    },
    { t([[\infty]]) }
  ),
  snippet(
    {
      trig = "tt",
      dscr = [[\text (iA)]]
    },
    fmta([[\text{<>}<>]],
      { i(1), i(0) }
    )
  ),
}

return math_iA
