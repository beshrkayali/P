require "level"

nowLev = 1
function restart()
  level = Level.create(nowLev)
end

function love.load()
    -- define sounds, fonts, blah blah blah
    gameMusic = love.audio.newSource("bu-on-the-cheeses-ship.it")
    gameMusic:setLooping(true)

    hitSound = love.audio.newSource("sfx/hit.wav")
    deathSound = love.audio.newSource("sfx/death.wav")
    winSound = love.audio.newSource("sfx/win.wav")
	font = love.graphics.newFont('fnt/8-BIT_WONDER.TTF', 9)

	gameMusic:stop()
	gameMusic:play()
	
    -- Start game
    restart()
end

function love.update(dt)
	level:update(dt)
end

function love.draw()
	level:draw()
end