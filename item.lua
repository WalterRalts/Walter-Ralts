function events.item_render(item)
if item.id:find('sword') ~= nil then
return models.Walterv5.Item
else
return
end
end

function events.arrow_render(delta, arrow)
if arrow:getVelocity() ~= vec(0, 0, 0) then
particles:newParticle("minecraft:end_rod", arrow:getPos())
end
end
