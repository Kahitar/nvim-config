local M = {}

M.get_env_value = function(key)
    local env_path = vim.fn.stdpath('config') .. '/.env'
    local env_contents = {}
    for line in io.lines(env_path) do
        local k, v = line:match("^([^=]+)=(.-)%s*$")
        if k and v then
            env_contents[k] = v
        end
    end
    return env_contents[key]
end

return M
