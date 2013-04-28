camera = require "hump.camera"
require "p"

Level = {}
Level.__index = Level

-- split a string using an identifier
function splitter(inputstr, sep)
  if sep == nil then
      sep = "%s"
  end
  t={}; i=1
  for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
      t[i] = str
      i = i + 1
  end
  return t
end


function Level.create(level)
  require("levels/level"..level)
  -- physics stuff
  local self = {}
  setmetatable(self, Level)
  self:load()
  cam = camera(pixel_x, pixel_y)
  return self
end

function Level:load()
  -- physics objects
  objects = {} 

  levelWon = false

  love.physics.setMeter(64)
  self.world = love.physics.newWorld(0, 100, false)
  self.world:setCallbacks(beginContact, endContact, preSolve, postSolve)

  -- level: physics
  levelBlocks = {}
  levelBlocksGray = {}
  for y=1, #map_code do
    for x=1, #map_code[y] do
        if map_code[y][x] == 1 then
          block = {}
          block.body = love.physics.newBody(self.world, x*20-15, y*20-15)
          block.shape = love.physics.newRectangleShape(20, 20)
          block.fixture = love.physics.newFixture(block.body, block.shape, 1)
          block.fixture:setUserData("Wall")
          table.insert(levelBlocks, block)
        end

        if map_code[y][x] == 2 then
          spawn_location_x = x*20-15
          spawn_location_y = y*20-15
        end

        if map_code[y][x] == 9 then
          win_location_x = x*20-15
          win_location_y = y*20-10
        end
    end
  end

  -- level: winning location
  objects.winning = {}
  objects.winning.body = love.physics.newBody(self.world, win_location_x, win_location_y)
  objects.winning.shape = love.physics.newRectangleShape(50, 10)
  objects.winning.fixture = love.physics.newFixture(objects.winning.body, objects.winning.shape, 1)
  objects.winning.fixture:setUserData("WIN")

  -- set env
  love.graphics.setBackgroundColor(math.random(0, 50), math.random(0, 50), math.random(0, 100)) -- background color

  -- player
  objects.p = p.create(self.world, spawn_location_x, spawn_location_y, 10, 10, 20) -- x, y, width, height, mass, canMove, isChild, life points  
end



function beginContact(a, b, coll)
  
end


function preSolve(a, b, coll)    
    if a:getUserData() == "Wall" and b:getUserData() == "p" or a:getUserData() == "p" and b:getUserData() == "Wall"  then
      
      objects.p.life = objects.p.life - 3
      
      if objects.p.life < 0 then
        deathSound:stop()
        deathSound:play()
        resetFlag = true
      end

      objects.p.hurting = true

      hitSound:stop()
      hitSound:play()
    end
    
    if a:getUserData() == "p" and b:getUserData() == "WIN"  or a:getUserData() == "WIN" and b:getUserData() == "p" then
      objects.winning.body:destroy()
      levelWon = true
      winSound:stop()
      winSound:play()
    end

end

function postSolve(a, b, coll)

end

function Level:update(dt)

  if levelWon then
  	nowLev = nowLev + 1
    if nowLev == 2 then nowLev = 1 end
  	level = Level.create(nowLev)
  end

  -- update level 
  self.world:update(dt) -- activate physics 
  objects.p:update(dt) -- update pixel

  if resetFlag then
    resetFlag=false
    restart()
  end


  pixel_x, pixel_y  = objects.p.body:getPosition()
  cam:lookAt(pixel_x, pixel_y)

end


function Level:draw(dt)
  cam:attach()
  
  -- draw pixel
  objects.p:draw(objects.p)

  -- draw level
  love.graphics.setColor(255,255,255)
  for i in ipairs(levelBlocks) do
    love.graphics.polygon("fill", levelBlocks[i].body:getWorldPoints(levelBlocks[i].shape:getPoints()))
  end

  -- draw winning location
  if levelWon == false then
    r = math.random(0,255)
    g = math.random(0,255)
    b = math.random(0,255)
    love.graphics.setColor(r,g,b)
    love.graphics.polygon("fill", objects.winning.body:getWorldPoints(objects.winning.shape:getPoints()))
  end

  cam:detach()

  love.graphics.setColor(251,85, 63)
  love.graphics.setFont(font)
  love.graphics.printf(objects.p.life,love.graphics.getWidth()/2-80, love.graphics.getHeight()/2+5, 200,"center")

end