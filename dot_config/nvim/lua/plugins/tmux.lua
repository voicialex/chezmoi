return {
  {
    "christoomey/vim-tmux-navigator",
    keys = {
      { "<C-h>", "<cmd>TmuxNavigateLeft<cr>", mode = "n", desc = "Navigate left" },
      { "<C-j>", "<cmd>TmuxNavigateDown<cr>", mode = "n", desc = "Navigate down" },
      { "<C-k>", "<cmd>TmuxNavigateUp<cr>", mode = "n", desc = "Navigate up" },
      { "<C-l>", "<cmd>TmuxNavigateRight<cr>", mode = "n", desc = "Navigate right" },
      { "<C-h>", [[<C-\><C-n><cmd>TmuxNavigateLeft<cr>]], mode = "t", desc = "Navigate left (terminal)" },
      { "<C-j>", [[<C-\><C-n><cmd>TmuxNavigateDown<cr>]], mode = "t", desc = "Navigate down (terminal)" },
      { "<C-k>", [[<C-\><C-n><cmd>TmuxNavigateUp<cr>]], mode = "t", desc = "Navigate up (terminal)" },
      { "<C-l>", [[<C-\><C-n><cmd>TmuxNavigateRight<cr>]], mode = "t", desc = "Navigate right (terminal)" },
    },
  },
}
