require("codecompanion").setup({
  strategies = {
    chat = {
      adapter = "local_ollama",
    },
    inline = {
      adapter = "codegemma",
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
          default = "deepseek-r1:14b"
        },
      })
    end,
    codegemma = function()
      return require("codecompanion.adapters").extend("ollama", {
        name = "codegemma",
        env = {
          url = vim.env.OLLAMA_API,
        },
        parameters = {
          sync = true,
        },
        model = {
          default = "codegemma:latest"
        },
      })
    end,
  },
})
