function love.load()
  --libs
  Timer = require 'lib/timer'
  
  
  love.graphics.setDefaultFilter("nearest", "nearest", 1)
  
  --enemey vars
  enemys = {}
  enemySprite = love.graphics.newImage("sprites/enemy.png")
  math.randomseed(os.time())
  Timer.every(1, function() table.insert(enemys, {math.random(0, 750), 0}) end)
  
  --bullet vars
  bullets = {}
  bulletSprite = love.graphics.newImage("sprites/bullet.png")
  
  --player vars
  player = {}
  player.sprite = love.graphics.newImage("sprites/player.png") 
  player.x = 100
  player.y = 500
  player.state = "full"
  player.size = 50
  player.speed = 250
  player.OriginX = player.sprite:getWidth()/2
  player.OriginY = player.sprite:getHeight()/2

end

function keyboardInput(who, dt)
  -- left and right movement
  if love.keyboard.isDown("d") then
    who.x = who.x + who.speed * dt
  end

  if love.keyboard.isDown("a") then
    who.x = who.x - who.speed * dt
  end

end

function borderCollions(who, dt)
  if who.x > 750 then
    who.x = who.x - 100 * dt
  end
  
  if who.x < 0 then
    who.x = who.x + 100 * dt
  end
end

function love.update(dt)
  keyboardInput(player, dt)
  borderCollions(player, dt)
  Timer.update(dt)

  
  -- this is for removing bullets or moving them
  for i=1,#bullets do
    if bullets[i][2] == nil then
      table.remove(bullets, i)
    else
      bullets[i][2] = bullets[i][2] - 2
    end
  end
  -- this is for adding bullets to array and changing the state of player
  function love.keypressed(key, scancode, isrepeat)
    if key == "h" then
      if #bullets >= 5 then
        player.state = "reloading..."
        
        Timer.after(1, function() 
          bullets = {} 
          player.state = "full"
        end)
      
      else
        player.state = "full"
        table.insert(bullets, {player.x, player.y})
      end
    end
  end
  -----------
  -- this is for enemy moving
  for i=1,#enemys do
    if enemys[i][2] == nil then
      table.remove(enemys, i)
    else
      enemys[i][2] = enemys[i][2] + 2
    end
  end

  if #enemys > 20 then
    enemys = {}
  end
end

--love.graphics.rectangle("fill", player.x, player.y, player.size, player.size)
function love.draw()
  love.graphics.getBackgroundColor(1, 1, 1) 
  love.graphics.print(#enemys, 100, 0)
  
  for i=1,#enemys do
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", enemys[i][1], enemys[i][2], 16 * 2, 16 * 2)
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(enemySprite, enemys[i][1], enemys[i][2], 0, 2, 2)
  end
  
  for i=1,#bullets do
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", bullets[i][1], bullets[i][2], 8, 8)
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(bulletSprite, bullets[i][1], bullets[i][2], 0, 1, 1)
  end
  love.graphics.setColor(1, 0, 0)
  love.graphics.print(player.state)
  
  love.graphics.setColor(1, 1, 1)
  love.graphics.scale(3, 3)
  love.graphics.draw(player.sprite, player.x/3, player.y/3, 0,1,1,player.OriginX,player.OriginY)
end