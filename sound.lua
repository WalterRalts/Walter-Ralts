function events.tick()
      local hungry = player:getFood() <= 7
      local hungry_time = 0
      if hungry then
            if hungry_time < 200 then
                  hungry_time = hungry_time + 1
            else
                  sounds:playSound("DUN_Belly", player:getPos(), 1, 1, false)
                  hungry_time = 0
            end
      end
end

--thanks to Ma nu e ru
function events.ON_PLAY_SOUND(id, pos, vol, pitch, loop, category, path)
      if not path then return end -- don't trigger if the sound was played by figura (prevent infinite loop)
      if not player:isLoaded() then return end -- don't trigger if the player isn't loaded
      local nearest, uuid = math.huge -- we will find the nearest player to the sound location
      for _, plr in pairs(world.getPlayers()) do
            local dist = (plr:getPos() - pos):length()
            if dist < nearest then nearest,uuid = dist,plr:getUUID() end
      end
      if player:getUUID() ~= uuid or nearest > 1.2 then return end -- don't trigger if the sound isn't near you

      ---------------------------------------------------------
      -- actual replacing starts here, feel free to edit below:
      
      if id == "minecraft:entity.item.pickup" then
            sounds:playSound("DUN_Item", pos, vol, 1 , false)
            return true
      end
      if id:find(".step") then
            if player:isSprinting() then
                  if math.random(1, 5) == 1 then
                        --sounds:playSound("minecraft:block.azalea_leaves.fall", pos, vol, pitch)
                  end
            else
                  --sounds:playSound("minecraft:block.bubble_column.bubble_pop", pos, vol, pitch)
            end
            return true
      end
end