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
