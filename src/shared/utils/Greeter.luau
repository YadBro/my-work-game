local Greeter = {}
Greeter.__index = Greeter

function Greeter:greet(person)
    return "Hello " .. person
end

return Greeter