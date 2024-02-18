local M = {}


M.lazy_load = function(...)
  return require("luasnip.loaders.from_lua").lazy_load {
    paths = vim.api.nvim_get_runtime_file("lua/sniplib/snippets/", true),
    ...
  }
end


return M
