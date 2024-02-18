--[[
Working version

r --> regex;
i --> snippet will expand at word boundaries, wordTrig=false;
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
local extras = require("luasnip.extras")
local l = extras.lambda
local fmta = require("luasnip.extras.fmt").fmta

local make_condition = require("luasnip.extras.conditions").make_condition
local conditions = require("sniplib.snippets.tex.utils.conditions")
local in_math = make_condition(conditions.in_math)
local autosnip = require("luasnip").extend_decorator.apply(s,
  {
    snippetType = "autosnippet",
    wordTrig = false,
    regTrig = true
  },
  { condition = in_math, }
)

local M = {
  autosnip(
    {
      trig = "(\\?%a+)vec",
      dscr = "\\vector (riA)",
      priority = 999
    },
    fmta(
      [[\vec{<>}<>]],
      {
        f(function(_, snip) return snip.captures[1] end, {}),
        i(0),
      }
    )
  ),
  autosnip(
    {
      trig = "(\\?%a+)hat",
      dscr = "\\hat (riA)",
    },
    fmta(
      [[\hat{<>}<>]],
      {
        f(function(_, snip) return snip.captures[1] end, {}),
        i(0),
      }
    )
  ),
  autosnip(
    {
      trig = "(\\?%a+)bar",
      dscr = "\\overline (riA)",
    },
    fmta(
      [[\overline{<>}<>]],
      {
        f(function(_, snip) return snip.captures[1] end, {}),
        i(0),
      }
    )
  ),
  autosnip(
    {
      trig = "(\\?%a+)tild",
      dscr = "\\widetilde (riA)",
    },
    fmta(
      [[\widetilde{<>}<>]],
      {
        f(function(_, snip) return snip.captures[1] end, {}),
        i(0),
      }
    )
  ),
  autosnip(
    {
      trig = "(\\?%a+)dot",
      dscr = "\\dot (riA)",
    },
    {
      c(1,
        {
          sn(nil, { l("\\dot{" .. l.CAPTURE1 .. "}"), i(1) }),
          sn(nil, { l("\\ddot{" .. l.CAPTURE1 .. "}"), i(1) }),
          sn(nil, { l("\\dddot{" .. l.CAPTURE1 .. "}"), i(1) })
        }
      )
    }
  ),
  autosnip(
    {
      trig="([\\%w_%^]+)/",
      dscr = "\\frac (riA)",
      priority = 997,
    },
    fmta(
      [[\frac{<>}{<>}<>]],
      {
        d(1,
          function (_, snip)
            return sn(nil,
            {
              t(snip.captures[1])
              -- c(1,
              --   {
              --     t(snip.captures[1]),
              --     sn(nil, fmta([[(<>)<>]], { i(1, snip.captures[1]), i(2) })),
              --     sn(nil, fmta([[\left(<>\right)<>]],
              --         { i(1, snip.captures[1]), i(2) }
              --       )
              --     )
              --   }
              -- )
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
  autosnip({
      trig = [[(%a+).bs]],
      dscr = "auto backslash (riA)",
    },
    {
      t[[\]],
      f(function(_, snip) return snip.captures[1] end, {}),
    }
  ),
  autosnip(
    {
      trig = "(\\?%a+)mcal",
      dscr = [[\mathcal (riA)]],
      priority = 1000
    },
    fmta(
      [[\mathcal{<>}<>]],
      {
        f(function(_, snip) return snip.captures[1] end, {}),
        i(0),
      }
    )
  ),

}

return M
