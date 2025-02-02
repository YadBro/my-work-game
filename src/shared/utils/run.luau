local module = {}
module.__index = module

function module.once(callback: () -> ())
    local result
    local ran = false

    return function()
        if not ran then
            ran = true
            result = callback()
        end

        return result
    end
end

return module