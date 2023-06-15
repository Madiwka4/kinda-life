VIRTUAL_WIDTH = 1280
VIRTUAL_HEIGHT = 720
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720
Class = require 'class'
require 'simpleScale'
require 'life'
require 'edible'
bugs = {}
edibles = {}
rules = {}
function love.load()
    math.randomseed(os.time())
    smallfont = love.graphics.newFont("font.ttf", 15)
    smallestfont = love.graphics.newFont("font.ttf", 5)
    love.keyboard.setKeyRepeat(true)
    simpleScale.setWindow(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT)
    table.insert(bugs, life(VIRTUAL_HEIGHT/2, VIRTUAL_WIDTH/2, 10, 159))
    table.insert(edibles, edible(20, VIRTUAL_WIDTH/2+5, 4))
    rules["abundantFood"] = false
end 
function love.update(dt)
    love.window.setTitle(#bugs)
    for i, bug in ipairs(bugs) do 
        bug:update(dt)
    end
    regulator()
end 
function regulator()
    for i, bug in ipairs(bugs) do 
        if bug.dead then 
            table.insert(edibles, edible(bug.y, bug.x, bug.fat))
            table.remove(bugs, i)
        end
    end 
    if #bugs == 0 then 
        table.insert(bugs, life(VIRTUAL_HEIGHT/2, VIRTUAL_WIDTH/2, 10, 159))
    end
    if #edibles < #bugs/3 and rules["abundantFood"] then 
        table.insert(edibles, edible(math.random(0, VIRTUAL_HEIGHT), math.random(0, VIRTUAL_WIDTH), 10))
    elseif #edibles <= 5 then 
        table.insert(edibles, edible(math.random(0, VIRTUAL_HEIGHT), math.random(0, VIRTUAL_WIDTH), 10))
    end
end 
function love.draw()
    simpleScale.set()
    love.graphics.clear(0,0,0,1)
    for i, bug in ipairs(bugs) do 
        bug:render(dt)
    end
    for i, edible in ipairs(edibles) do 
        edible:render(dt)
    end
    love.graphics.setColor(1,1,1,1)
    love.graphics.setFont(smallfont)
    simpleScale.unSet()
end 