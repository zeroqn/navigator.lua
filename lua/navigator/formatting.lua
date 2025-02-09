-- https://github.com/wention/dotfiles/blob/master/.config/nvim/lua/config/lsp.lua
-- https://github.com/lukas-reineke/dotfiles/blob/master/vim/lua/lsp/handlers.lua
return {
  format_hdl = function(err, _, result, _, bufnr) -- FIXME: bufnr is nil
    if err ~= nil or result == nil then
      return
    end

    -- If the buffer hasn't been modified before the formatting has finished,
    -- update the buffer
    if not vim.api.nvim_buf_get_option(bufnr, 'modified') then
      local view = vim.fn.winsaveview()
      vim.lsp.util.apply_text_edits(result, bufnr)
      vim.fn.winrestview(view)
      -- FIXME: commented out as a workaround
      -- if bufnr == vim.api.nvim_get_current_buf() then
      vim.api.nvim_command('noautocmd :update')

      -- Trigger post-formatting autocommand which can be used to refresh gitgutter
      -- vim.api.nvim_command('silent doautocmd <nomodeline> User FormatterPost')
      -- end
    end
  end
}
