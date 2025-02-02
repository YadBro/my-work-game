return function()
    local Greeter = require(script.Parent.Parent.utils.Greeter)

    describe("greet", function()
        it("should include the customary English greeting", function()
            local greeting = Greeter:greet("X")
            expect(greeting).to.be.equal("Hello X")
        end)

        it("should include the person being greeted", function()
            local greeting = Greeter:greet("Joe")
            expect(greeting).to.be.equal("Hello Adrian")
        end)
    end)
end

local GameConfig = require(game.ReplicatedStorage.Shared.utils.GameConfig)

local counterInstance = GameConfig.getConfigInstance("Counter")