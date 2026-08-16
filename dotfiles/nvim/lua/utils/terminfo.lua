local M = {}

M.supported_terms = {
  "ghostty",
  "WezTerm"
}

M.is_kitty_compatible = function()
  local term = os.getenv("TERM") or ""
  local prog = os.getenv("TERM_PROGRAM") or ""

  -- Check for kitty support
  if term:find("kitty") then
    return true
  end

  -- Check for compatible terms
  for _, t in ipairs(M.supported_terms) do
    if prog:find(t) then
      return true
    end
  end

  return false
end

return M
