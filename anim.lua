local offset_cam = -0.75
local idle_time = 0
local healpart = 0
local blink_time = 0
local blink_signal = math.random(30, 250)
models.Walterv5.ralts.body.torso.chest.header:setParentType("Head")

local mainPage = action_wheel:newPage("Basic")
local hold = 0
action_wheel:setPage(mainPage)

function events.ENTITY_INIT()
ActionActive = false
end

local wave = mainPage:newAction()
wave:setTitle("Say hello!")
wave:setItem("minecraft:stick")
wave:onLeftClick(function()
animations.Walterv5.ground_holding_idle:stop()
animations.Walterv5.ground_idle:stop()
idle_time = 0
ActionActive = true
animations.Walterv5.wave:play()
animations.Walterv5.talk:play()
sounds:playSound("WalterGreet", player:getPos(), 1, 1, false)
end)


local part_hat = models.Walterv5.ralts.body.torso.chest.header.Hat
local hatonoff = mainPage:newAction()
hatonoff:setTitle("Hat Toggle")
hatonoff:setItem("minecraft:leather_helmet")
hatonoff:onLeftClick(function()
      if part_hat:getVisible() then
            part_hat:setVisible(false)
            hatonoff:setItem("minecraft:player_head")
      else
            part_hat:setVisible(true)
            hatonoff:setItem("minecraft:leather_helmet")
      end
      end)

local bag = models.Walterv5.ralts.body.torso.Backpack
function events.tick()
      local bags = player:getNbt()["fabric:attachments"]["accessories:inventory_holder"]["accessories_containers"]["back"]["items"]
      if bags[1] and bags[1]["id"]:find("backpack") then
            bag:setVisible(true)
      else
            bag:setVisible(false)
      end

      local hats = player:getNbt()["fabric:attachments"]["accessories:inventory_holder"]["accessories_containers"]["hat"]["items"]
      local hats2 = player:getNbt()["cardinal_components"]["trinkets:trinkets"]["head"]["hat"]["Items"]
      if not (hats == nil and hats2 == nil) then
            if hats[1] and hats[1]["id"]:find("hat") or hats2[1] and hats2[1]["id"] and hats2[1]["id"]:find("hat") then
                  if part_hat:getVisible() then
                        vanilla_model.HELMET_HEAD:setScale(0, 0, 0)
                  else
                        vanilla_model.HELMET_HEAD:setScale(1, 1, 1)
                  end
            end
      end

      renderer:setEyeOffset(0, offset_cam, 0)
      nameplate.ENTITY:setPos(0, offset_cam, 0)
      renderer:setOffsetCameraPivot(0, offset_cam, 0)
      if not ActionActive then
            local crouching = player:getPose() == "CROUCHING"
            local sprinting = player:isSprinting() and player:getVelocity().xz:length() >= 0.23
            local blocking = player:isBlocking()
            local fishing = player:isFishing()
            local sleeping = player:getPose() == "SLEEPING"
            local flying = player:getPose() == "FALL_FLYING"
            local walking = player:getVelocity().xz:length() >= .01 and player:getVelocity().xz:length() < 0.23
            local hungry = player:getFood() <= 7
            local healing = player:getSaturation() > 0 and player:getHealth() < player:getMaxHealth() and player:getFood() > 18
            local hand = player:isLeftHanded()
            local holding_block = player:getHeldItem(hand):isBlockItem()
            local holding_item = player:getHeldItem(hand) and not player:getHeldItem(hand):isBlockItem()
            local shielding = player:isBlocking()
            local charging = player:getActiveItem():getUseAction() == "BOW"
            local nom = player:getActiveItem():getUseAction() == "EAT"
            local jousting = player:getActiveItem():getUseAction() == "SPEAR"
            local in_rain = player:isInRain()
            local in_water = player:isInWater()
            local mining = player:getSwingArm() ~= nil
            local battle = player:getHeldItem(hand).id:find('sword') ~= nil
            local swimming = player:getPose() == "SWIMMING"
            --local riding = player:getVehicle() ~= nil

            local charge_action = nom or jousting or charging
            local leg_move = crouching or sprinting or walking or swimming
            local idle = not leg_move and not charge_action and not mining and not fishing --and not riding

            if crouching then
                  models.Walterv5.ralts.body.torso.chest.header:setParentType("None")
            else
                  models.Walterv5.ralts.body.torso.chest.header:setParentType("Head")
            end

            animations.Walterv5.ground_holding_idle:setPlaying(holding_block and not battle and not swimming)
            animations.Walterv5.ground_holding_walk:setPlaying(holding_block and walking and not swimming)
            animations.Walterv5.ground_holding_run:setPlaying(holding_block and sprinting and not swimming)
            animations.Walterv5.ground_rain_idle:setPlaying(idle and in_rain and not holding_block and not battle)
            animations.Walterv5.ground_rain_walk:setPlaying(walking and in_rain and not holding_block)
            animations.Walterv5.ground_rain_run:setPlaying(sprinting and in_rain and not holding_block)
            animations.Walterv5.ground_idle:setPlaying(idle and not holding_block and not in_water and not in_rain and not battle and not swimming)
            animations.Walterv5.ground_walk:setPlaying(walking and not holding_block and not in_rain and not swimming)
            animations.Walterv5.wade:setPlaying(idle and not holding_block and in_water)
            animations.Walterv5.ground_run:setPlaying(sprinting and not holding_block and not in_rain and not swimming)
            animations.Walterv5.crouching:setPlaying(crouching)
            animations.Walterv5.mining:setPlaying(mining)

            --animations.Walterv5.shoulder_left:setPlaying(riding)

            animations.Walterv5.battle_idle:setPlaying(battle and not crouching)

            animations.Walterv5.sleep:setPlaying(sleeping)
            animations.Walterv5.swim:setPlaying(swimming)
            animations.Walterv5.charging:setPlaying(charging)
            animations.Walterv5.fishing:setPlaying(fishing)
            animations.Walterv5.fishing_walk:setPlaying(fishing and walking)
            blink_time = blink_time + 1
            if blink_time == blink_signal then
                  animations.Walterv5.blink:play()
                  blink_signal = math.random(30, 250)
                  blink_time = 0
            end

            if idle then
                  idle_time = idle_time + 1
            else
                  idle_time = 0
            end

            if idle_time >= 300 then
                  idle_time = 0
                  models.Walterv5.ralts.body.torso.chest.header:setParentType("None")
                  if hungry then
                        if not holding_block then
                              animations.Walterv5.hungry_quirk_idle:play()
                        end
                  else
                        if holding_block then
                              animations.Walterv5.holding_quirk_idle:play()
                        elseif battle then
                              animations.Walterv5.quirk_battle_idle:play()
                        elseif not in_rain then
                              animations.Walterv5.quirk_idle:play()
                        end
                  end
                  models.Walterv5.ralts.body.torso.chest.header:setParentType("Head")
            end
            if healing then
                  healpart = healpart + 1
                  if healpart == 30 then
                        for i = 1, 10, 1 do
                              local nplayer = player:getPos() - vec(math.random(-1, 1)/2, (math.random(-1, 1)/2) + 0.5,math.random(-1, 1)/2)
                              particles:newParticle("minecraft:happy_villager", nplayer, vec(0,0,1))
                        end
                        healpart = 0
                  end
            end
      else

            if hold < 58 then
                  hold = hold + 1
            else
                  ActionActive = false
                  hold = 0
            end
      end
end
