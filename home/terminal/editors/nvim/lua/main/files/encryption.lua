vim.api.nvim_create_autocmd("BufReadCmd", {
  pattern = "*.aes",
  callback = function(args)
    local password = vim.fn.inputsecret("Decryption password: ")

    local out = vim.fn.systemlist(
        "openssl enc -d -aes-256-cbc -salt -pbkdf2 -pass stdin -in " .. vim.fn.shellescape(args.file),
            password .. "\n"
    )

    -- replace buffer contents with decrypted text
    vim.api.nvim_buf_set_lines(0, 0, -1, false, out)
    vim.bo.modified = false
    vim.bo.readonly = false
    vim.bo.swapfile = false
  end,
})

vim.api.nvim_create_autocmd("BufWriteCmd", {
  pattern = "*.aes",
  callback = function(args)
    local password = vim.fn.inputsecret("Encryption password: ")

    -- grab buffer contents
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local text = table.concat(lines, "\n")

    -- feed buffer into openssl via stdin
    local cmd = "openssl enc -aes-256-cbc -salt -pbkdf2 -pass stdin -out " .. vim.fn.shellescape(args.file)
    vim.fn.system(cmd, password .. "\n" .. text)

    vim.bo.modified = false
  end,
})

vim.api.nvim_create_user_command("Encrypt", function()
  local src = vim.fn.expand("%:p")          -- full path of current buffer
  local password = vim.fn.inputsecret("Encryption password: ")
  local dst = src .. ".aes"                  -- you can customize naming here

  -- Get buffer contents
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local text = table.concat(lines, "\n")

  -- Encrypt via openssl, pass password via stdin
  local cmd = "openssl enc -aes-256-cbc -salt -pbkdf2 -pass stdin -out " .. vim.fn.shellescape(dst)
  local ret = vim.fn.system(cmd, password .. "\n" .. text)

  -- Delete the original file
  os.remove(src)

  -- Open the new encrypted file
  vim.cmd("edit " .. vim.fn.fnameescape(dst))
  vim.api.nvim_out_write("Encrypted " .. src .. " → " .. dst .. "\n")
end, {})

