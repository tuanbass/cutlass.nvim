local cutlass = require("cutlass")
local get_mappings = function(mode)
  local mappings = {}
  for _, mapping in ipairs(vim.api.nvim_get_keymap(mode)) do
    mappings[mapping.lhs] = mapping
  end

  return mappings
end

describe("Options should be set correctly", function()
  it("should take default values", function()
    cutlass.setup()
    assert(cutlass.options.cut_key == nil)
  end)
end)

describe("Overrides delete and change mappings", function()
  it("should map change and delete keys", function()
    cutlass.setup()
    local mappings = get_mappings("n")

    assert(mappings["c"])
    assert(mappings["d"].rhs == '"_d')
    assert(mappings["D"].silent)
    assert(mappings["x"].noremap)
  end)

  it("should map change and delete keys in x mode", function()
    cutlass.setup()
    local mappings = get_mappings("x")

    assert(mappings["c"])
    assert(mappings["d"].rhs == '"_d')
    assert(mappings["D"].silent)
    assert(mappings["x"].noremap)
  end)

  it("should not override already mapped keys", function()
    vim.api.nvim_set_keymap("n", "d", "gv", { noremap = true, silent = true })

    cutlass.setup()
    local mappings = get_mappings("n")

    assert(mappings["d"].rhs == "gv")
  end)
end)

describe("Overrides select mode", function()
  it("should overrides select mode", function()
    cutlass.setup()
    local mappings = get_mappings("s")

    assert(mappings["a"])
    assert(mappings["a"].rhs, '<c-o>"_ca')
    assert(mappings["Z"])
    assert(mappings["Z"].rhs, '<c-o>"_cZ')

    assert(mappings["\\"])
    assert(mappings["\\"].rhs, '<c-o>"_c\\')
    assert(mappings["|"])
    assert(mappings["|"].rhs, '<c-o>"_c|')
  end)
end)

describe("Create cut mappings", function()
  it("should map cut keys if setup", function()
    cutlass.setup({
      cut_key = "m",
    })
    local mappings = get_mappings("n")

    assert(mappings["m"])
    assert(mappings["m"].rhs, "d")
    assert(mappings["mm"])
    assert(mappings["mm"].rhs, "dd")
  end)
end)
