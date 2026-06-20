function get_password(confirm) 
    local correct_password = "$invalid"
    while correct_password == "$invalid" do
        correct_password = test_password(confirm) 
    end
    return correct_password
end

function test_password(confirm)
    local password = vim.fn.inputsecret("Password: ")

    if not confirm then
        return password
    end

    local password_2 = vim.fn.inputsecret("Enter password again: ")
    if password == password_2 then
        return password
    else
        vim.notify("Passwords do not match. Try again.", vim.log.levels.WARN)
        return "$invalid"
    end
end

vim.api.nvim_create_autocmd("BufReadCmd", {
    pattern = "*.aes",
    callback = function(args)
    local password
    if vim.g.is_encrypting_password then
        password = vim.g.is_encrypting_password
    else
        password = get_password(false)
    end

    local out = vim.fn.systemlist(
        "openssl enc -d -aes-256-cbc -salt -pbkdf2 -pass stdin -in " .. vim.fn.shellescape(args.file),
            password .. "\n"
    )

    vim.api.nvim_buf_set_lines(0, 0, -1, false, out)
    vim.bo.modified = false
    vim.bo.readonly = false
    vim.bo.swapfile = false
  end,
})

vim.api.nvim_create_autocmd("BufWriteCmd", {
    pattern = "*.aes",
    callback = function(args)
    local password = get_password(false)

    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local text = table.concat(lines, "\n")

    local cmd = "openssl enc -aes-256-cbc -salt -pbkdf2 -pass stdin -out " .. vim.fn.shellescape(args.file)
    vim.fn.system(cmd, password .. "\n" .. text)

    vim.bo.modified = false
  end,
})

vim.api.nvim_create_user_command("Encrypt", function()
  local src_buf = vim.api.nvim_get_current_buf() -- 1. Grab the current buffer ID
  local src = vim.fn.expand("%:p")          
  local password = get_password(true) 
  local dst = src .. ".aes"                  

  local lines = vim.api.nvim_buf_get_lines(src_buf, 0, -1, false)
  local text = table.concat(lines, "\n")

  local cmd = "openssl enc -aes-256-cbc -salt -pbkdf2 -pass stdin -out " .. vim.fn.shellescape(dst)
  vim.fn.system(cmd, password .. "\n" .. text)

  os.remove(src)

  vim.g.is_encrypting_password = password

  vim.cmd("edit " .. vim.fn.fnameescape(dst))

  vim.api.nvim_buf_delete(src_buf, { force = true })

  vim.g.is_encrypting_password = nil

  vim.api.nvim_out_write("Encrypted & cleaned up: " .. src .. " → " .. dst .. "\n")
end, {})
