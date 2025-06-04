-- Below is a small example program where you can move a circle
-- around with the crank. You can delete everything in this file,
-- but make sure to add back in a playdate.update function since
-- one is required for every Playdate game!
-- =============================================================

-- Importing libraries used for drawCircleAtPoint and crankIndicator
import "CoreLibs/graphics"
import "CoreLibs/ui"

-- Localizing commonly used globals
local pd <const> = playdate
local gfx <const> = playdate.graphics

-- Defining player variables
local playerSize = 10
local playerVelocity = 3
local playerX, playerY = 200, 120
local playerDir = 0
local accel = 0.5
local burst = 2.5
local xVelocity,yVelocity = 0, 0
local dir = 0

-- Defining enemy variables
local enemySize = 16
local enemyX = {math.random(0,400),math.random(0,400),math.random(0,400),math.random(0,400)}
local enemyY = {math.random(0,240),math.random(0,240),math.random(0,240),math.random(0,240)}


-- Drawing player image
local playerImage = gfx.image.new(32, 32)
gfx.pushContext(playerImage)
    -- Draw outline
    gfx.drawRoundRect(4, 3, 24, 26, 1)
    -- Draw screen
    gfx.drawRect(7, 6, 18, 12)
    -- Draw eyes
    gfx.drawLine(10, 12, 12, 10)
    gfx.drawLine(12, 10, 14, 12)
    gfx.drawLine(17, 12, 19, 10)
    gfx.drawLine(19, 10, 21, 12)
    -- Draw crank
    gfx.drawRect(27, 15, 3, 9)
    -- Draw A/B buttons
    gfx.drawCircleInRect(16, 20, 4, 4)
    gfx.drawCircleInRect(21, 20, 4, 4)
    -- Draw D-Pad
    gfx.drawRect(8, 22, 6, 2)
    gfx.drawRect(10, 20, 2, 6)
gfx.popContext()

-- Draw Enemies
local enemyImage = gfx.image.new(32,32)
gfx.pushContext(enemyImage)
    -- Draw outline
    gfx.drawRoundRect(4, 3, 24, 26, 1)
    -- Draw screen
    gfx.drawRect(7, 6, 18, 12)
    -- Draw eyes
    gfx.drawLine(10, 12, 12, 10)
    gfx.drawLine(12, 10, 14, 12)
    gfx.drawLine(17, 12, 19, 10)
    gfx.drawLine(19, 10, 21, 12)
    -- Draw crank
    gfx.drawRect(27, 15, 3, 9)
    -- Draw A/B buttons
    gfx.drawCircleInRect(16, 20, 4, 4)
    gfx.drawCircleInRect(21, 20, 4, 4)
    -- Draw D-Pad
    gfx.drawRect(8, 22, 6, 2)
    gfx.drawRect(10, 20, 2, 6)
gfx.popContext()



-- Defining helper function
local function ring(value, min, max)
	if (min > max) then
		min, max = max, min
	end
	return min + (value - min) % (max - min)
end

-- playdate.update function is required in every project!
function playdate.update()
    -- Clear screen
    gfx.clear()
    
    -- Get Input from Dpad
    local iLeft = playdate.buttonJustPressed("left")
    local iRight = playdate.buttonJustPressed("right")
    local iDown = playdate.buttonJustPressed("down")
    local iUp = playdate.buttonJustPressed("up")

    -- Calculate velocity from inputs
    if(iDown) then
        dir = 0
        yVelocity += burst
    elseif(iLeft) then
        dir = 1
        xVelocity -= burst
    elseif(iUp) then
        dir = 2
        yVelocity -= burst
    elseif(iRight) then
        dir = 3
        xVelocity += burst
    end

    if(dir == 0) then
        yVelocity += accel
        if(xVelocity > 0) then
            xVelocity -= accel
        elseif(xVelocity < 0) then
            xVelocity += accel
        end
    end
    if(dir == 1) then
        xVelocity -= accel
        if(yVelocity > 0) then
            yVelocity -= accel
        elseif(yVelocity < 0) then
            yVelocity += accel
        end
    end
    if(dir == 2) then
        yVelocity -= accel
        if(xVelocity > 0) then
            xVelocity -= accel
        elseif(xVelocity < 0) then
            xVelocity += accel
        end
    end
    if(dir == 3) then
        xVelocity += accel
        if(yVelocity > 0) then
            yVelocity -= accel
        elseif(yVelocity < 0) then
            yVelocity += accel
        end
    end

    -- Move player
    playerX += xVelocity
    playerY += yVelocity
    -- Loop player position
    playerX = ring(playerX, -playerSize, 400 + playerSize)
    playerY = ring(playerY, -playerSize, 240 + playerSize)
    -- Loop enemy position
    for i = 1,4,1
    do 
        enemyX[i] = ring(enemyX[i], -enemySize, 400 + enemySize)
        enemyY[i] = ring(enemyY[i], -enemySize, 240 + enemySize)
    end
    -- Draw player
    playerImage:drawAnchored(playerX, playerY, 0.5, 0.5)
    -- Draw enemies
    for i = 1,4,1
    do 
        enemyImage:drawAnchored(enemyX[i], enemyY[i], 0.5, 0.5)
    end

end
