--[[
b --> snippet will only be expanded at the beginning of a line;
w --> snippet will not expand at word boundaries, wordTrig=true (by default);
A --> auto expand, snippetType="autosnippet".
]]

--[[ Imports ]]
local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local extras = require("luasnip.extras")
local rep = extras.rep
local fmta = require("luasnip.extras.fmt").fmta

local line_begin = require("luasnip.extras.conditions.expand").line_begin
local make_condition = require("luasnip.extras.conditions").make_condition
local conditions = require("sniplib.snippets.tex.utils.conditions")
local in_bullets = make_condition(conditions.in_bullets)
local autosnip = require("luasnip").extend_decorator.apply(s,
  { snippetType = "autosnippet" },
  { condition = line_begin }
)


local bwA = {
	autosnip(
    {
      trig = "beg",
      dscr = [[\begin{}...\end{} environment (bwA)]]
    },
		fmta(
		[[
    \begin{<>}
      <>
    \end{<>}]],
			{ c(1, {
          i(nil),
          t("center")
        }),
        i(0), rep(1) }
		)
	),
  autosnip(
    {
      trig = "ali",
      dscr = [[\begin{align}...\end{align} environment (bwA)]]
    },
	  fmta([[
      \begin{align<>}<>
        <>
      \end{align<>}
      ]],
      { c(1, {t("*"), t("")}),
        c(2, {
          i(nil),
          sn(nil,
            fmta(
              [[
              \label{<>:<>}
              ]],
              { t("eq"), i(1) }
            )
          ),
        }),
        i(0),
        rep(1)
      }
    )
	),
	autosnip(
    {
      trig = "eqn",
      dscr = [[\begin{equation}...\end{equation} (bwA)]]
    },
	  fmta([[
      \begin{equation<>}<>
        <>
      \end{equation<>}
      ]],
	    {
        c(1, { t("*"), t("") }),
        c(2,
        {
          i(nil),
          sn(nil, fmta([[ \label{<>:<>} ]], { t("eq"), i(1) })),
        }),
        i(0), rep(1)
      }
    )
	),
	autosnip(
    {
      trig = "enum",
      dscr = [[\begin{enumerate}...\end{enumerate} (bwA)]]
    },
		fmta(
			[[
      \begin{enumerate}<>
      \item <>
      \end{enumerate}
      ]],
			{
				c(1,
					{
						t(""),
						sn(nil,
							fmta(
								[[
                [label=<>]
                ]],
								{ c(1, { t("(\\alph*)"), t("(\\roman*)"), i(1) }) }
							)
						),
					}
				),
				c(2,
          { i(0),
            sn(
					    nil,
					    fmta(
						    [[
                [<>]<>
                ]],
						    { i(1), i(0) }
					    )
				    )
          }
        )
			}
		)
	),

	autosnip(
    {
		  trig = "item",
      dscr = [[\begin{itemize}...\end{itemize} (bwA)]]
    },
		fmta(
			[[
      \begin{itemize}
        \item <>
      \end{itemize}
      ]],
			{ c(1,
          { i(0),
            sn(
				      nil,
				      fmta(
					      [[
                [<>] <>
                ]],
					      { i(1), i(0) }
				      )
			      )
          }
        )
      }
		)
	),
  -- generate new bullet points
	autosnip({ trig="-", dscr=[[\item (bwA)]], },
    { t("\\item ") },
	  { condition = line_begin * in_bullets }
  ),
	autosnip({ trig="*", dscr=[[\item[] (bwA)]], },
	  fmta([[ \item[<>] <> ]],
	    { i(1), i(0) }
    ),
	  { condition = line_begin * in_bullets }
	),
}

return bwA
