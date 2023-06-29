require "pieces"


local timer = 0 -- Variable pour suivre le temps écoulé
local tetros = 1
local tetrosX = 0
local tetrosY = 0
local tetrosR = 1
local scale = 20
local devmode = true
local gridX = 10
local gridY = 20
local nlog = 0
local bgimage = nil

-- Tableau de 10 colonnes et 20 lignes
local grid = {}

local function console(str)
    if devmode then
        nlog = nlog + 1
        love.window.setTitle("Tetris - " .. str .. " (" .. nlog .. ")")
        --love.graphics.print(str .. ' (' .. nlog .. ')', 0, 0)
    end
end

local function drawTetros(tetro, rot, x, y)

    local color = {
        {1, 0, 0},
        {0, 1, 0},
        {0, 0, 1},
        {1, 1, 0},
        {1, 0, 1},
        {0, 1, 1},
        {1, 1, 1}
    }

    for i = 1, 4 do
        for j = 1, 4 do
            if Tetros[tetro][rot][i][j] == 1 then
                -- rectangle
                love.graphics.setColor(1, 1, 1)
                love.graphics.rectangle("fill", (j-1+x)*scale, (i-1+y)*scale, scale, scale)
                -- sous rectangle
                love.graphics.setColor(color[tetro])
                love.graphics.rectangle("fill", (j-1+x)*scale+1, (i-1+y)*scale+1, scale-2, scale-2)
            end
        end
    end
end

local function initGrid()
    for i = 1, gridY do
        grid[i] = {}
        for j = 1, gridX do
            grid[i][j] = 0
        end
    end
end

local function drawGrid()
    for i = 1, gridY do
        for j = 1, gridX do
            love.graphics.setColor(0.25, 0.25, 0.25)
            love.graphics.rectangle("fill", (j-1)*scale, (i-1)*scale, scale, scale)
            love.graphics.setColor(0, 0, 0)
            love.graphics.rectangle("fill", (j-1)*scale+1, (i-1)*scale+1, scale-2, scale-2)
        end
    end
end

function love.load()
    love.window.setTitle("Tetris")
    bgimage = love.graphics.newImage("michael-d-rnKqWvO80Y4-unsplash.jpg")
    initGrid()
end

function love.update(dt)
    timer = timer + dt

    -- All 1 second
    if timer >= 1 then
        tetrosY = tetrosY + 1
        timer = timer - 1
    end
end

function love.draw()
    if bgimage then
        love.graphics.draw(bgimage, 0, 0, 0, 0.5, 0.5)
    end


    drawGrid()
    drawTetros(tetros, tetrosR, tetrosX, tetrosY)
    --drawTetros(1, 1, 0, 0) 
    --drawTetros(3, 1, 8, 0)
    --drawTetros(4, 1, 12, 0)
    --drawTetros(5, 1, 16, 0)
    --drawTetros(6, 1, 20, 0)
    --drawTetros(7, 1, 24, 0)
end

function love.keypressed(key)
    -- Quit
    if key == "escape" then
        love.event.quit()
    end

    -- Right
    if key == "d" then
        local maxC = #Tetros[tetrosR][1]
        if tetrosX + maxC < 10 then
            tetrosX = tetrosX + 1
        end
    end

    -- Left
    if key == "q" then
        if tetrosX > 0 then
            tetrosX = tetrosX - 1
        end
    end

    -- Slow drop
    if key == "s" then
        -- check if we can go down
        local maxL = #Tetros[tetrosR]
        if tetrosY + maxL < 20 then
            tetrosY = tetrosY + 1
        end

        --tetrosY = tetrosY + 1
    end

    -- Rotate
    if key == "r" then
        tetrosR = tetrosR + 1
        if tetrosR > #Tetros[tetros] then
            tetrosR = 1
        end
    end

    -- Change tetros
    if key == "t" and devmode then
        tetros = tetros + 1
        if tetros > #Tetros then
            tetros = 1
        end
    end

    -- Reset
    if key == "p" and devmode then
        tetrosX = 0
        tetrosY = 0
        tetrosR = 1
    end
end