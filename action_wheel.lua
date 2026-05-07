local mainPage = action_wheel:newPage("Basic")
action_wheel:setPage(mainPage)

function events.ENTITY_INIT()
      ActionActive = false
      DancingActive = false
end

local function playSoundRadius(radius, sound, position, volume, pitch, loop)
      local target = client:getViewer():getPos()
      local dir = position-target
      local dist = dir:length()
      if dist > radius then return end
      local vol = math.map(dist,0,radius,1,0)*volume
      local pos = target+dir:normalized()*10
      sounds:playSound(sound, pos, vol, pitch, loop)
end
function pings.helloWorld()
      animations.Walterv5.ground_holding_idle:stop()
      animations.Walterv5.ground_idle:stop()
      idle_time = 0
      ActionActive = true
      animations.Walterv5.wave:play()
      animations.Walterv5.talk:play()
      playSoundRadius(15, "WalterGreet", player:getPos(), 1, 1, false)
end
local wave = mainPage:newAction()
wave:setTitle("Say hello!")
wave:setItem("minecraft:stick")
wave:onLeftClick(function()
      pings.helloWorld()
end)

function pings.shimmy()
      animations.Walterv5.ground_holding_idle:stop()
      animations.Walterv5.ground_idle:stop()
      idle_time = 0
      DancingActive = true
      animations.Walterv5.dance1:play()
end
local dance = mainPage:newAction()
dance:setTitle("Shimmy")
dance:setItem("minecraft:music_disc_cat")
dance:onLeftClick(function()
      pings.shimmy()
end)

local part_hat = models.Walterv5.ralts.body.torso.chest.header.Hat
local hatonoff = mainPage:newAction()
function pings.hatonoff()
      if part_hat:getVisible() then
            part_hat:setVisible(false)
            hatonoff:setItem("minecraft:player_head")
      else
            part_hat:setVisible(true)
            hatonoff:setItem("minecraft:leather_helmet")
      end
end
hatonoff:setTitle("Hat Toggle")
hatonoff:setItem("minecraft:leather_helmet")
hatonoff:onLeftClick(function()
      pings.hatonoff()
end)