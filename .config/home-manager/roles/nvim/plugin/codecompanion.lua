require("codecompanion").setup({
  strategies = {
    chat = {
      adapter = "local_ollama",
    },
    inline = {
      adapter = "local_ollama",
    },
  },
  adapters = {
    local_ollama = function()
      return require("codecompanion.adapters").extend("ollama", {
        env = {
          url = vim.env.OLLAMA_API,
        },
        parameters = {
          sync = true,
        },
        model = {
          -- default = "deepseek-coder:6.7b"
          default = "deepseek-coder-v2:16b"
        },
      })
    end,
  },
})
