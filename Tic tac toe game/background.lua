local backgroundGroup = display.newGroup()
local shapeCreationTimer

local function createSymbol(x, y, symbol)
    local textObject = display.newText(symbol, x, y, native.systemFont, 40)
    if textObject then
        textObject:setFillColor(math.random(), math.random(), math.random())
        if backgroundGroup then
            backgroundGroup:insert(textObject)
        else
            print("Error: backgroundGroup is nil")
        end
    else
        print("Error: failed to create text object")
    end
    return textObject
end

local function animateSymbols()
    if backgroundGroup and backgroundGroup.numChildren then
        local numChildren = backgroundGroup.numChildren
        if type(numChildren) == "number" then
            for i = numChildren, 1, -1 do
                local child = backgroundGroup[i]
                child:removeSelf()
                child = nil
            end
        end
    end
    for i = 1, 20 do
        local x = math.random(display.contentWidth)
        local y = math.random(display.contentHeight)
        local symbol = math.random() < 0.5 and "X" or "O"
        local textObject = createSymbol(x, y, symbol)
        if textObject then
            transition.to(textObject, {
                x = x + math.random(-50, 50),
                y = y + math.random(-50, 50),
                time = math.random(1000, 3000),
                onComplete = function()
                    if backgroundGroup and backgroundGroup.numChildren then
                        local numChildren = backgroundGroup.numChildren
                        if type(numChildren) == "number" then
                            for i = numChildren, 1, -1 do
                                local child = backgroundGroup[i]
                                if child == textObject then
                                    child:removeSelf()
                                    child = nil
                                end
                            end
                        end
                    end
                end
            })
        end
    end
end

-- Updated startBackgroundAnimation function
local function startBackgroundAnimation()
    -- Re-create the backgroundGroup if it doesn't exist
    if not backgroundGroup then
        backgroundGroup = display.newGroup()
    end

    -- Ensure you only start the timer if it doesn't already exist
    if not shapeCreationTimer then
        animateSymbols()
        shapeCreationTimer = timer.performWithDelay(1000, function()
            animateSymbols()
        end, 0)
    end

    return backgroundGroup
end

local function stopBackgroundAnimation()
    if shapeCreationTimer then
        timer.cancel(shapeCreationTimer)
        shapeCreationTimer = nil
    end
    if backgroundGroup and backgroundGroup.numChildren then
        local numChildren = backgroundGroup.numChildren
        if type(numChildren) == "number" then
            for i = numChildren, 1, -1 do
                local child = backgroundGroup[i]
                child:removeSelf()
                child = nil
            end
        end
        backgroundGroup:removeSelf()
        backgroundGroup = nil
    end
end

return {
    startBackgroundAnimation = startBackgroundAnimation,
    stopBackgroundAnimation = stopBackgroundAnimation
}