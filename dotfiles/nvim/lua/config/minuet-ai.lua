local has_vectorcode, vectorcode_plugin = pcall(require, 'vectorcode')
local RAG_CONTEXT_SIZE = 8000
local TOTAL_CTX_SIZE = 16000
local cacher = nil

-- 1. Initialize VectorCode
if has_vectorcode then
  vectorcode_plugin.setup({
    cli_cmds = { vectorcode = "vectorcode" },
    async_opts = {
      n_query = 2,
      debounce = 10,
      notify = false,
      run_on_register = true,
    },
  })

  local has_vc_conf, vc_config = pcall(require, 'vectorcode.config')
  if has_vc_conf then
    local status, backend = pcall(vc_config.get_cacher_backend)
    if status then
      cacher = backend
    else
      vim.notify("VectorCode: Could not retrieve backend", vim.log.levels.WARN)
    end
  end
else
  vim.notify("VectorCode plugin not found!", vim.log.levels.WARN)
end

-- 2. Define Template Function
local function template_function(pref, suff, _)
  local context_parts = {}
  local current_length = 0

  if cacher then
    local status, results = pcall(cacher.query_from_cache, 0)
    if status and results and #results > 0 then
      for _, file in ipairs(results) do
        if file.path and file.document then
          local snippet = '<|file_sep|>' .. file.path .. '\n' .. file.document .. '\n'
          local snippet_len = vim.fn.strchars(snippet)

          if current_length + snippet_len > RAG_CONTEXT_SIZE then break end

          table.insert(context_parts, snippet)
          current_length = current_length + snippet_len
        end
      end
    end
  end

  local prompt_message = table.concat(context_parts, "")
  local current_file = vim.fn.expand('%')

  return prompt_message ..
      '<|file_sep|>' .. current_file .. '\n' ..
      '<|fim_prefix|>' .. pref ..
      '<|fim_suffix|>' .. suff ..
      '<|fim_middle|>'
end

-- 3. Setup Minuet
require('minuet').setup {
  provider = 'openai_fim_compatible',
  n_completions = 1,
  context_window = TOTAL_CTX_SIZE,

  provider_options = {
    openai_fim_compatible = {
      api_key = 'TERM',
      name = 'Ollama',
      end_point = 'http://darkmac:11434/v1/completions',
      model = 'qwen2.5-fast-complete-mini',
      stream = true,
      optional = {
        stop = { "<|file_sep|>", "<|fim_prefix|>", "<|fim_suffix|>", "<|fim_middle|>", "<|endoftext|>" },
        max_tokens = 256,
        temperature = 0.1,
        top_p = 0.9,
      },
      template = {
        prompt = template_function,
        suffix = false,
      },
    },
  },
  throttle = 100,
  debounce = 200,
}

-- 4. Autocmd for VectorCode Context
vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
  callback = function()
    if not cacher then return end

    local bufnr = vim.api.nvim_get_current_buf()
    local has_vc_cacher, vc_cacher_mod = pcall(require, "vectorcode.cacher")

    if has_vc_cacher and vc_cacher_mod.utils and vc_cacher_mod.utils.async_check then
      vc_cacher_mod.utils.async_check("config", function()
        cacher.register_buffer(bufnr, { n_query = 1 })
      end, nil)
    elseif cacher.async_check then
      cacher.async_check("config", function()
        cacher.register_buffer(bufnr, { n_query = 1 })
      end, nil)
    end
  end,
  desc = "Auto-register buffer for VectorCode context",
})

