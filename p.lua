p = {}
p.__index = p

function p.create(world, x, y, w, h, mass)
  local self = {}
  setmetatable(self, p)

  self:reset(world, x,y, w, h, mass)
  return self
end

function p:reset(world, x, y, w, h, mass)
  
  self.x = x
  self.y = y

  self.width = w or 20
  self.height = h or 20
  self.mass = mass or 20

  self.life = 100


  -- physics
  self.body = love.physics.newBody(world, self.x, self.y, "dynamic")
  self.body:setMass(self.mass) 
  self.shape = love.physics.newRectangleShape(self.width, self.height)
  self.fixture = love.physics.newFixture(self.body, self.shape, 1)
  self.fixture:setRestitution(0.3)
  self.fixture:setUserData("p")

end


function p:update(dt)
  

  if love.keyboard.isDown("right") then
      self.body:applyForce(5, 0)
      self.body:applyAngularImpulse(0.1)
  end 

  if love.keyboard.isDown("left") then
      self.body:applyForce(-5, 0)
      self.body:applyAngularImpulse(-0.1)
  end 

  if love.keyboard.isDown("up") then
      self.body:applyForce(0, -5)
  end 

  if love.keyboard.isDown("down") then
      self.body:applyForce(0, 5)
  end 

  if love.keyboard.isDown("r") then
    resetFlag = true
  end

end

function p:draw(p)

  love.graphics.setColor(255,255,255)

  if self.hurting then
    love.graphics.setBackgroundColor(math.random(0, 50), math.random(0, 50), math.random(0, 100))
    love.graphics.setColor(251,85, 63)
    self.hurting = false
  end

  if self.life < 25 then
    love.graphics.setColor(251,85, 63)
  end

  -- draw p
  love.graphics.polygon("fill", p.body:getWorldPoints(p.shape:getPoints()))  
end