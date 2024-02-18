local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
-- local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
-- local c = ls.choice_node
-- local d = ls.dynamic_node
local r = ls.restore_node
-- local events = require("luasnip.util.events")
-- local ai = require("luasnip.nodes.absolute_indexer")
-- local extras = require("luasnip.extras")
-- local l = extras.lambda
-- local rep = extras.rep
-- local p = extras.partial
-- local m = extras.match
-- local n = extras.nonempty
-- local dl = extras.dynamic_lambda
-- local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
-- local conds = require("luasnip.extras.expand_conditions")
-- local postfix = require("luasnip.extras.postfix").postfix
-- local types = require("luasnip.util.types")
-- local parse = require("luasnip.util.parser").parse_snippet
-- local ms = ls.multi_snippet
-- local k = require("luasnip.nodes.key_indexer").new_key

local M = {}

M.mat = function(_, snip)
	local rows = tonumber(snip.captures[2])
	local cols = tonumber(snip.captures[3])
	local nodes = {}
	local ins_indx = 1
	for j = 1, rows do
		table.insert(nodes, r(ins_indx, tostring(j) .. "x1", i(1)))
		ins_indx = ins_indx + 1
		for k = 2, cols do
			table.insert(nodes, t(" & "))
			table.insert(nodes, r(ins_indx, tostring(j) .. "x" .. tostring(k), i(1)))
			ins_indx = ins_indx + 1
		end
		table.insert(nodes, t({ "\t\\\\", "" }))
	end
	-- fix last node.
	-- nodes[#nodes] = t("\\\\")
	nodes[#nodes] = nil
	return sn(nil, nodes)
end

M.case = function(_, snip)
	local rows = tonumber(snip.captures[1]) or 2 -- default option 2 for cases
	local nodes = {}
	local ins_indx = 1
	for j = 1, rows do
		table.insert(nodes, r(ins_indx, tostring(j) .. "x1", i(1)))
		ins_indx = ins_indx + 1
		table.insert(nodes, t({ "\t\\\\", "" }))
	end
	-- fix last node.
	-- nodes[#nodes] = t("\\\\")
	nodes[#nodes] = nil
	return sn(nil, nodes)
end

---@return function (snippet node) 
--as many `d` as multiplicity of integral
M.integrals = function(_, snip)
	local vars = tonumber(snip.captures[1])
	local nodes = {}
	for j = 1, vars do
		table.insert(nodes, t(" d "))
		table.insert(nodes, r(j, "var" .. tostring(j), i(1)))
	end
	return sn(nil, nodes)
end

-- visual util to add insert node
---@return function (snippet node)
M.get_visual = function(_, parent)
	if #parent.snippet.env.SELECT_RAW > 0 then
		return sn(nil, i(1, parent.snippet.env.SELECT_RAW))
	else -- If SELECT_RAW is empty, return a blank insert node
		return sn(nil, i(1))
	end
end

---@return table `res`: selected text
M.select_raw = function(_, snip)
  local res, env = {}, snip.env
  for _, val in ipairs(env.LS_SELECT_RAW) do table.insert(res, val) end
  return res
end


---Backslash snippet
---@param context table
---@param opts table
M.bs_snip = function(context, opts)
  return s(
    context,
    fmta([[\<>]],
      {
        f(function(_, snippet)
          return snippet.trigger
        end, {})
      }
    ),
    opts or {}
  )
end

M.context_extend = function(arg, extend)
	local argtype = type(arg)
	if argtype == "string" then
		arg = { trig = arg }
	elseif argtype == "table" then
		return vim.tbl_extend("keep", arg, extend or {})
	end
	-- fall back to unchanged arg.
	-- log this, probably.
	return arg
end

return M
