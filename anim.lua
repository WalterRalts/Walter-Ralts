local offset_cam = -0.75
local idle_time = 0
local healpart = 0
local blink_time = 0
local blink_signal = math.random(30, 250)
local hold = 0

local walter = models.Walterv5.ralts
local bag = walter.body.torso.Backpack
local head = walter.body.torso.chest.header
function events.tick()
      local bags = player:getNbt()["fabric:attachments"]["accessories:inventory_holder"]["accessories_containers"]["back"]["items"]
      if bags[1] and bags[1]["id"]:find("backpack") then
            bag:setVisible(true)
      else
            bag:setVisible(false)
      end
      head:offsetRot(vanilla_model.HEAD:getOriginRot())
      renderer:setEyeOffset(0, offset_cam, 0)
      nameplate.ENTITY:setPos(0, offset_cam, 0)
      renderer:setOffsetCameraPivot(0, offset_cam, 0)
      local riding = player:getVehicle() ~= nil
      local in_boat = riding and player:getVehicle():getName():find("Boat") ~= nil
      local rowing = in_boat and player:getVelocity().xyz:length() > 0
      --ground actions
      local crouching = player:getPose() == "CROUCHING"
      local sprinting = player:isSprinting() and player:getVelocity().xz:length() >= 0.23 and not riding
      local walking = player:getVelocity().xz:length() >= .01 and not sprinting and not riding
      local climbing = player:isClimbing()
      --ground moving
      
      local blocking = player:isBlocking()
      local fishing = player:isFishing()
      local sleeping = player:getPose() == "SLEEPING"
      local flying = player:getPose() == "FALL_FLYING"
      local jumping = player:getVelocity().y > 0

      local in_rain = player:isInRain()
      local in_water = player:isInWater()
      local in_air = not player:isOnGround()
      
      local hungry = player:getFood() <= 7
      local healing = player:getSaturation() > 0 and player:getHealth() < player:getMaxHealth() and player:getFood() > 18
      local hand = player:isLeftHanded()
      local holding_block = player:getHeldItem(hand):isBlockItem() and not in_rain
      local holding_food = player:getHeldItem(hand):isFood() and not holding_block and not in_rain
      local holding_item = player:getHeldItem(hand) and not player:getHeldItem(hand):isBlockItem()
      local shielding = player:isBlocking()
      local charging = player:getActiveItem():getUseAction() == "BOW"
      local nom = player:getActiveItem():getUseAction() == "EAT"
      local jousting = player:getActiveItem():getUseAction() == "SPEAR"
      
      
      local mining = player:getSwingArm() ~= nil
      local battle = player:getHeldItem(hand).id:find('sword') ~= nil
      local swimming = player:getPose() == "SWIMMING"
      --log(animations:getPlaying()[1], animations:getPlaying()[2], animations:getPlaying()[3])

      --COMBOS!
      local charge_action = nom or jousting or charging
      local leg_move = sprinting or walking or swimming
      local idle = not leg_move and not charge_action and not mining and not fishing and not riding and not in_air
      local empty_hands = not holding_block and not holding_food
      if animations:getPlaying()[1] ~= animations.Walterv5.bow and animations:getPlaying()[1] ~= animations.Walterv5.wave and animations:getPlaying()[1] ~= animations.Walterv5.talk and animations:getPlaying()[1] ~= animations.Walterv5.penello and not DancingActive then
            animations.Walterv5.air_idle:setPlaying(in_air and not battle and not swimming and not sprinting and not climbing and not riding)
            animations.Walterv5.ground_holding_idle:setPlaying(holding_block and idle and not battle and not swimming and not sprinting)
            animations.Walterv5.ground_holding_walk:setPlaying(holding_block and walking and not swimming)
            animations.Walterv5.ground_holding_run:setPlaying(holding_block and sprinting and not swimming)
            animations.Walterv5.ground_rain_idle:setPlaying(idle and in_rain)
            animations.Walterv5.ground_rain_walk:setPlaying(walking and in_rain and not crouching)
            animations.Walterv5.ground_rain_run:setPlaying(sprinting and in_rain)
            animations.Walterv5.ground_idle:setPlaying(idle and not crouching and not holding_food and not holding_block and not in_water and not battle and not swimming and not in_rain)
            animations.Walterv5.ground_walk:setPlaying(walking and not crouching and not holding_block and not swimming and not mining and not in_rain and not battle)
            animations.Walterv5.ground_run:setPlaying(sprinting and not holding_block and not swimming and not mining and not in_rain)
            animations.Walterv5.food_idle:setPlaying(holding_food and idle)
            animations.Walterv5.eat:setPlaying(nom)
            if not sprinting then
                  animations.Walterv5.ground_rain_run:stop()
                  animations.Walterv5.ground_run:stop()
                  animations.Walterv5.ground_holding_run:stop()
            end
            animations.Walterv5.ride:setPlaying(riding)
            animations.Walterv5.wade:setPlaying(idle and not holding_block and in_water)
            animations.Walterv5.crouching:setPlaying(crouching and idle)
            animations.Walterv5.crouch_walk:setPlaying(crouching and walking)
            animations.Walterv5.mining:setPlaying(mining)

            animations.Walterv5.battle_idle:setPlaying(battle and not crouching and idle)
            animations.Walterv5.battle_walk:setPlaying(battle and not crouching and walking and not idle)
            if riding then
                  walter:setPos(0, 8, 0)
            else
                  walter:setPos(0, 0, 0)
            end
            
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

            --check idle time
            if idle then
                  idle_time = idle_time + 1
            else
                  idle_time = 0
            end

            --idle animations
            if idle_time >= 300 then
                  idle_time = 0
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
            end

            --healing particles
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
      elseif animations:getPlaying()[1] ~= nil then
            animations.Walterv5.ground_holding_idle:stop()
            animations.Walterv5.food_idle:stop()
            animations.Walterv5.ground_idle:stop()
            if hold < 58 then
                  hold = hold + 1
                  if walking then
                        animations.Walterv5.dance1:stop()
                        animations.Walterv5.penello:stop()
                        DancingActive = false
                        animations.Walterv5.ground_idle:play()
                  end
            else
                  hold = 0
            end
      else
            animations.Walterv5.ground_idle:play()
      end

      if not idle then
            animations.Walterv5.quirk_idle:stop()
            animations.Walterv5.quirk_battle_idle:stop()
            animations.Walterv5.holding_quirk_idle:stop()
            animations.Walterv5.hungry_quirk_idle:stop()
      end
end