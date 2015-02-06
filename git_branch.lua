function isempty(s)
    return s == nil or s == ""
end

function parent(str)
    if str == "\\" or str == "/" then return "" end -- *nix or network root
    res = str:gsub("[/\\]+[^/\\]+[/\\]*$", "")
    if res == str then return "" end -- Windows root
    if isempty(res) then return "" end
    if isempty(res:gsub("\\\\[^/\\]+$", "")) then return "" end -- network root reached

    return res
end

function git_prompt_filter()
    cur_dir = clink.get_cwd()
    while cur_dir ~= "" do
        if clink.is_dir(cur_dir .. "/.git") then
            line = io.input(cur_dir .. "/.git/HEAD"):read("*l")
            io.input():close()
            if isempty(line) then break end -- something's wrong
            branch = line:gsub(".*/", ""):gsub("%.$", "")
            if isempty(branch) then break end -- something's wrong

            clink.prompt.value = "[git: \x1b[93m"..branch.."\x1b[0m] "..clink.prompt.value
            break
        end

        cur_dir = parent(cur_dir)
    end
    return false
end

clink.prompt.register_filter(git_prompt_filter, 50)
