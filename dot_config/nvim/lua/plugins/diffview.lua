-- 模块级状态和函数（keys 属性需要提前注册，config 里的函数无法被 which-key 发现）
local state = { depth = 0, file = "", cycling = false }

local function git_short(rev)
  local out = vim.fn.systemlist("git rev-parse --short " .. rev .. " 2>/dev/null")
  return (out and out[1] ~= "") and out[1] or rev
end

local function show_diff(depth, file)
  state.cycling = true
  pcall(vim.cmd, "DiffviewClose")
  if depth == 0 then
    local h = git_short("HEAD")
    vim.notify(string.format("Diff: 工作区 vs HEAD (%s)", h), vim.log.levels.INFO)
    vim.cmd("DiffviewOpen HEAD -- " .. vim.fn.fnameescape(file))
  else
    local old_h = git_short("HEAD~" .. depth)
    local new_h = git_short("HEAD~" .. (depth - 1))
    vim.notify(
      string.format("Diff: HEAD~%d (%s) vs HEAD~%d (%s)", depth, old_h, depth - 1, new_h),
      vim.log.levels.INFO
    )
    vim.cmd(string.format(
      "DiffviewOpen HEAD~%d..HEAD~%d -- %s",
      depth, depth - 1, vim.fn.fnameescape(file)
    ))
  end
end

local function diff_prev()
  local ok, lib = pcall(require, "diffview.lib")
  local in_diffview = ok and lib and lib.get_current_view() ~= nil
  if not in_diffview then
    state.file = vim.fn.expand("%")
    state.depth = 0
  end
  show_diff(state.depth, state.file)
  state.depth = state.depth + 1
end

local function diff_next()
  if state.file == "" or state.depth <= 1 then
    vim.notify("已在最新版本，无法回退", vim.log.levels.WARN)
    return
  end
  show_diff(state.depth - 2, state.file)
  state.depth = state.depth - 1
end

-- 覆盖 snacks.nvim 的 gp（GitHub Pull Requests）→ 我们的 diff 往历史翻
vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  once = true,
  callback = function()
    vim.keymap.set("n", "<leader>gp", diff_prev, { desc = "Diff: 往历史翻" })
  end,
})

return {
  -- 统一 gitsigns 跳转为 ]c/[c（与 diff 模式一致）
  {
    "lewis6991/gitsigns.nvim",
    optional = true,
    opts = function(_, opts)
      local orig = opts.on_attach
      opts.on_attach = function(bufnr)
        if orig then orig(bufnr) end
        pcall(vim.keymap.del, "n", "]h", { buffer = bufnr })
        pcall(vim.keymap.del, "n", "[h", { buffer = bufnr })
        local gs = require("gitsigns")
        vim.keymap.set("n", "]c", function()
          if vim.wo.diff then return "]c" end
          gs.nav_hunk("next")
        end, { buffer = bufnr, expr = true, desc = "Next Git Hunk" })
        vim.keymap.set("n", "[c", function()
          if vim.wo.diff then return "[c" end
          gs.nav_hunk("prev")
        end, { buffer = bufnr, expr = true, desc = "Prev Git Hunk" })
      end
    end,
  },

  -- Diffview：Space g p 往历史翻，Space g n 往回翻
  {
    "sindrets/diffview.nvim",
    keys = {
      { "<leader>gp", diff_prev, desc = "Diff: 往历史翻" },
      { "<leader>gn", diff_next, desc = "Diff: 往回翻（较新版本）" },
    },
    config = function()
      -- 用户手动关闭 diffview 时重置状态
      vim.api.nvim_create_autocmd("User", {
        pattern = "DiffviewViewClosed",
        callback = function()
          if state.cycling then
            state.cycling = false
            return
          end
          state.depth = 0
          state.file = ""
        end,
      })
    end,
  },
}
