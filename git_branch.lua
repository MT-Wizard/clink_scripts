function isempty(s)
    return s == nil or s == ""
end

function parent(str)
    res1 = str:gsub("/[^/]*$", "")
    res2 = str:gsub("\\[^\\]*$", "")

    if not isempty(res1) and isempty(res2) then return res1 end
    if isempty(res1) and not isempty(res2) then return res2 end
    if not isempty(res1) and not isempty(res2) then
        if res1:len() > res2:len() then return res2 end
        if res1:len() == res2:len() then return "" end -- root
        return res1
    end
    return "" -- ??
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
