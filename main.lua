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
local bgimage = nil
local speed = 5

-- Tableau de 10 colonnes et 20 lignes
local grid = {}

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
                --love.graphics.setColor(color[tetro][1], color[tetro][2], color[tetro][3])
                love.graphics.rectangle("fill", (j-1+x)*scale, (i-1+y)*scale, scale, scale)
                -- sous rectangle
                love.graphics.setColor(color[tetro][1], color[tetro][2], color[tetro][3])
                love.graphics.rectangle("fill", (j-1+x)*scale+1, (i-1+y)*scale+1, scale-2, scale-2)
            end
        end
    end
end

local function drawSquare(x, y)
    love.graphics.setColor(0, 0, 1)
    love.graphics.rectangle("fill", x*scale+1, y*scale+1, scale-2, scale-2)    
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
    love.graphics.setColor(1, 1, 1)

    for i = 1, gridY do
        -- Dessiner une ligne horizontale
        love.graphics.line(0, (i-1)*scale, gridX*scale, (i-1)*scale)
    end

    for j = 1, gridX do
        -- Dessiner une ligne verticale
        love.graphics.line((j-1)*scale, 0, (j-1)*scale, gridY*scale)
    end

    -- contour
    love.graphics.rectangle("line", 0, 0, gridX*scale, gridY*scale)
end


local function drawBg(method)
    if bgimage == false then
        return
    end

    if method == "simple" then
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(bgimage, 0, 0, 0, 0.2, 0.2, 0, 0)
        return
    end

    local windowWidth = love.graphics.getWidth()
    local windowHeight = love.graphics.getHeight()

    local imageWidth = bgimage:getWidth()
    local imageHeight = bgimage:getHeight()

    -- Calculer les dimensions de l'image en fonction de la taille de la fenêtre
    local scale = math.min(windowWidth / imageWidth, windowHeight / imageHeight)
    local scaledWidth = imageWidth * scale
    local scaledHeight = imageHeight * scale

    -- Calculer les coordonnées pour centrer l'image
    local x = (windowWidth - scaledWidth) / 2
    local y = (windowHeight - scaledHeight) / 2

    -- Dessiner l'image avec les coordonnées et les dimensions calculées
    love.graphics.draw(bgimage, x, y, 0, scale, scale)
end

local function drawInnerGridTetro()
    for i = 1, gridY do
        for j = 1, gridX do
            if grid[i][j] == 1 then
                drawSquare(j-1, i-1)
            end
        end
    end
end

function love.load()
    love.window.setTitle("Tetris")
    bgimage = love.graphics.newImage("michael-d-rnKqWvO80Y4-unsplash.jpg")
    initGrid()
end


local function randomTetros()
    return math.random(1, #Tetros)
end

local function newTetro()
    tetros = randomTetros()
    tetrosX = 0
    tetrosY = 0
    tetrosR = 1
end

function love.update(dt)
    if not love.window.hasFocus() and not devmode then
        return
    end

    timer = timer + dt

    -- Wait 1 second
    if timer < 1 then
        return
    end

    timer = timer - 1

    -- Drop jusqua ce qua touche un autre tetros present dans le grid
    

    -- Drop jusqu'en bas
    if tetrosY + #Tetros[tetrosR] < gridY - 1 then
        tetrosY = tetrosY + 1
        return
    end

    for i = 1, 4 do
        for j = 1, 4 do
            if Tetros[tetros][tetrosR][i][j] == 1 then
                local gridXPos = tetrosX + j
                local gridYPos = tetrosY + i
                grid[gridYPos][gridXPos] = 1
            end
        end
    end

    newTetro()
end

function love.draw()
    drawBg("simple")
    drawGrid()
    drawTetros(tetros, tetrosR, tetrosX, tetrosY)
    drawInnerGridTetro()
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
        local maxL = #Tetros[tetrosR]
        if tetrosY + maxL < gridY - 1 then
            tetrosY = tetrosY + 1
            timer = 0
        end
    end

    -- Fast drop
    if key == "z" then
        -- TODO
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