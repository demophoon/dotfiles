require 'cmp'.setup {
  snippet = {
    expand = function(args)
      require 'snippy'.expand_snippet(args.body)
    end
  },

  sources = {
    { name = 'snippy' }
  }
}
