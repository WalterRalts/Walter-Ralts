local CONFIG = {
      useNickname = true,
      nickname = "Walter Mindir",
      nicknameColor = "#717BD6",


      showGuild = true,
      showGuildIcon = true,
      guildNameplate = "Imagination Station",
      guildChat = "IS",
      guildColor = "#FF911B",

      verticalOffset = 30,
      horizontalOffset = 12,

      showInThirdPerson = true,
      overwriteNameInChat = false,
      textureName = "nameplate",
      spriteSize = 40,
      frameCount = 3,
      iconSize = 16,
      displaySize = 16,
      barWidth = 28,
      barHeight = 1.6,
      healthColor = { 0.20, 0.90, 0.20 },
      armorColor = { 1.00, 0.90, 0.90 },
      hungerColor = { 0.90, 0.60, 0.10 },
      saturColor = { 0.10, 0.20, 0.90 },
      barBgColor = { 0.20, 0.20, 0.25 },
      expressions = {
            default = 0,
            hurt = 1,
            low_health = 1,
            sleeping = 2,
      },
      expressionPriority = { "hurt", "low_health", "sleeping", "default" },
      nameplateScale = 0.72,
}

local CONDITIONS = {
      hurt = function() return player:getNbt().HurtTime > 0 end,
      low_health = function() return player:getHealth() <= player:getMaxHealth() * 0.25 end,
      sleeping = function() return player:getPose() == "SLEEPING" end,
      default = function() return true end,
}






local function resolveExpression()
for _, key in ipairs(CONFIG.expressionPriority) do
local fn = CONDITIONS[key]
if fn and fn() then
return CONFIG.expressions[key] or 0
end
end
return 0
end


local function getPlayerUsername()
if player:isLoaded() then
return player:getName() or ""
end
return ""
end


local function getDisplayName()
if CONFIG.useNickname then
return CONFIG.nickname or ""
end
return getPlayerUsername()
end


local function nameJson()
local username = getPlayerUsername()
local guildChat = CONFIG.guildChat or ""
local showGuild = CONFIG.showGuild ~= false and guildChat ~= ""
local parts = {}
if showGuild then
parts[#parts + 1] = { text = "[", color = "#ffffff" }
parts[#parts + 1] = { text = guildChat, color = CONFIG.guildColor }
parts[#parts + 1] = { text = "] ", color = "#ffffff" }
end
parts[#parts + 1] = { text = getDisplayName(), color = CONFIG.nicknameColor }
if CONFIG.useNickname then
parts[#parts + 1] = { text = " [", color = "#aaaaaa" }
parts[#parts + 1] = { text = username, color = "#aaaaaa" }
parts[#parts + 1] = { text = "]", color = "#aaaaaa" }
end
return toJson(parts)
end


local function titleJson()
local parts = {
{ text = getDisplayName(), color = CONFIG.nicknameColor },
}
if CONFIG.useNickname then
parts[#parts + 1] = { text = " [", color = "#aaaaaa" }
parts[#parts + 1] = { text = getPlayerUsername(), color = "#aaaaaa" }
parts[#parts + 1] = { text = "]", color = "#aaaaaa" }
end
return toJson(parts)
end





if models.nameplate then models.nameplate:setVisible(false) end


local tn = CONFIG.textureName
local SRC = textures[tn]
or textures[tn .. ".png"]
or textures["nameplate." .. tn .. ".png"]
or textures["nameplate." .. tn]

if not SRC then
local ok, allTex = pcall(textures.getTextures, textures)
if ok and allTex then
for key, tex in pairs(allTex) do
if type(key) == "string" and key:find(tn, 1, true) then
SRC = tex
break
end
end
end
end

local SZ = CONFIG.spriteSize
local ICO_SZ = CONFIG.iconSize


local hpTex = textures:newTexture("nameplate_hp", 1, 1)
hpTex:fill(0, 0, 1, 1,
CONFIG.healthColor[1], CONFIG.healthColor[2], CONFIG.healthColor[3], 1)
hpTex:update()

local armorTex = textures:newTexture("nameplate_armor", 1, 1)
armorTex:fill(0, 0, 1, 1,
CONFIG.armorColor[1], CONFIG.armorColor[2], CONFIG.armorColor[3], 1)
armorTex:update()

local foodTex = textures:newTexture("nameplate_food", 1, 1)
foodTex:fill(0, 0, 1, 1,
CONFIG.hungerColor[1], CONFIG.hungerColor[2], CONFIG.hungerColor[3], 1)
foodTex:update()

local saturTex = textures:newTexture("nameplate_saturation", 1, 1)
saturTex:fill(0, 0, 1, 1,
CONFIG.saturColor[1], CONFIG.saturColor[2], CONFIG.saturColor[3], 1)
saturTex:update()

local barBgTex = textures:newTexture("nameplate_barbg", 1, 1)
barBgTex:fill(0, 0, 1, 1,
CONFIG.barBgColor[1], CONFIG.barBgColor[2], CONFIG.barBgColor[3], 0.80)
barBgTex:update()


local DS = CONFIG.displaySize
local GAP = 2
local PAD = 2
local TOTAL_W = DS + GAP + CONFIG.barWidth + PAD * 2
local TOTAL_H = DS + PAD * 2





local nameplatePart = models:newPart("nameplateHud")
if nameplatePart.setParentType then
nameplatePart:setParentType("World")
end
nameplatePart:setPos(0, CONFIG.verticalOffset, 0)
local cs = CONFIG.nameplateScale or 1
nameplatePart:setScale(cs, cs, cs)


local HALF_W = TOTAL_W / 2
local HALF_H = TOTAL_H / 2
local hOff = CONFIG.horizontalOffset
local porLeft = -HALF_W + PAD + hOff
local porTop = HALF_H - PAD
local infoLeft = porLeft + DS + GAP
local infoTop = porTop

local TEXT_SC = 0.5
local LINE_H = 4.5
local BAR_GAP = 1.5
local EMBLEM_DS = LINE_H - 0.5
local SECTION_GAP = 0.5
local nameY = infoTop
local GUILD_NAMEPLATE = CONFIG.guildNameplate or ""
local SHOW_GUILD = CONFIG.showGuild ~= false and GUILD_NAMEPLATE ~= ""
local SHOW_GUILD_ICON = SHOW_GUILD and CONFIG.showGuildIcon ~= false
local guildY = nameY - LINE_H - SECTION_GAP - 0.2
local hpY = SHOW_GUILD and (guildY - LINE_H - SECTION_GAP) or (nameY - LINE_H - SECTION_GAP)

local function addSprite(name)
return nameplatePart:newSprite(name)
end

local function addText(name)
return nameplatePart:newText(name)
end


local portraitSprite = addSprite("portrait")
if SRC then
local dim = SRC:getDimensions()
portraitSprite
:setTexture(SRC)
:setDimensions(dim.x, dim.y)
:setRegion(SZ, SZ)
:setSize(DS, DS)
:setUVPixels(0, 0)
:setPos(porLeft + 35.7, porTop + 0.3, 0)
:setRenderType("CUTOUT_EMISSIVE_SOLID")
:setLight(15, 15)
end


local nameText = addText("displayName")
nameText
:setText(titleJson())
:setScale(TEXT_SC, TEXT_SC, TEXT_SC)
:setPos(infoLeft, nameY, -0.01)
:setLight(15, 15)
:setShadow(true)


local emblemSprite = addSprite("emblem")
if SRC then
local dim = SRC:getDimensions()
local eOx = CONFIG.frameCount * SZ
emblemSprite
:setTexture(SRC)
:setDimensions(dim.x, dim.y)
:setRegion(ICO_SZ, ICO_SZ)
:setSize(EMBLEM_DS, EMBLEM_DS)
:setUVPixels(eOx, 0)
:setPos(infoLeft, guildY + 0.35)
:setRenderType("CUTOUT_EMISSIVE_SOLID")
:setLight(15, 15)
end

local guildText = addText("guildLabel")
guildText
:setText(toJson({ { text = GUILD_NAMEPLATE, color = CONFIG.guildColor } }))
:setScale(TEXT_SC, TEXT_SC, TEXT_SC)
:setPos(SHOW_GUILD_ICON and (infoLeft + EMBLEM_DS - 9) or infoLeft, guildY, -0.01)
:setLight(15, 15)
:setShadow(true)

if not SHOW_GUILD then
emblemSprite:setVisible(false)
guildText:setVisible(false)
elseif not SHOW_GUILD_ICON then
emblemSprite:setVisible(false)
end


local hpBg = addSprite("hpBg")
hpBg
:setTexture(barBgTex)
:setSize(CONFIG.barWidth, CONFIG.barHeight)
:setPos(infoLeft, hpY, 0.1)
:setRenderType("EMISSIVE_SOLID")
:setLight(15, 15)

local hpFill = addSprite("hpFill")
hpFill
:setTexture(hpTex)
:setSize(CONFIG.barWidth, CONFIG.barHeight)
:setPos(infoLeft, hpY, 0)
:setRenderType("EMISSIVE_SOLID")
:setLight(15, 15)

local armorFill = addSprite("armorFill")
armorFill
:setTexture(armorTex)
:setSize(CONFIG.barWidth, CONFIG.barHeight)
:setPos(infoLeft, hpY + 1, 0)
:setRenderType("EMISSIVE_SOLID")
:setLight(15, 15)


local foodY = hpY - CONFIG.barHeight - BAR_GAP

local foodBg = addSprite("foodBg")
foodBg
:setTexture(barBgTex)
:setSize(CONFIG.barWidth, CONFIG.barHeight)
:setPos(infoLeft, foodY, 0.1)
:setRenderType("EMISSIVE_SOLID")
:setLight(15, 15)

local foodFill = addSprite("foodFill")
foodFill
:setTexture(foodTex)
:setSize(CONFIG.barWidth, CONFIG.barHeight)
:setPos(infoLeft, foodY, 0)
:setRenderType("EMISSIVE_SOLID")
:setLight(15, 15)

local saturFill = addSprite("saturFill")
saturFill
:setTexture(saturTex)
:setSize(CONFIG.barWidth, CONFIG.barHeight / 10)
:setPos(infoLeft, foodY - 2, 0)
:setRenderType("EMISSIVE_SOLID")
:setLight(15, 15)



function events.entity_init()
nameplate.Entity:setVisible(false)
nameText:setText(titleJson())
if CONFIG.overwriteNameInChat then
nameplate.All:setText(nameJson())
end

if host:isHost() then
pings.syncFood(player:getFood())
end
end




local currentFrame = 0
local syncedFood = 20
local syncedSatur = 20
local lastSentFood = -1
local lastSentSatur = -1
local initFoodSyncTicks = 40
local foodResyncTimer = 0
local foodCheckTimer = 0
local lastHpWidth = -1
local lastArmorWidth = -1
local lastSaturWidth = -1
local lastFoodWidth = -1




function events.tick()

local frame = resolveExpression()
if frame ~= currentFrame then
currentFrame = frame
if SRC then
portraitSprite:setUVPixels(frame * SZ, 0)
end
end


local maxHp = player:getMaxHealth()
local hpRatio = maxHp > 0 and (player:getHealth() / maxHp) or 0
local hpWidth = math.max(CONFIG.barWidth * hpRatio, 0)
if hpWidth ~= lastHpWidth then
lastHpWidth = hpWidth
hpFill:setSize(hpWidth, CONFIG.barHeight)
end


local armor = player:getArmor()
local armorRatio = maxHp > 0 and (armor / 20) or 0
local armorWidth = math.max(CONFIG.barWidth * armorRatio, 0)
if armorWidth ~= lastArmorWidth then
lastArmorWidth = armorWidth
armorFill:setSize(armorWidth, 0.5)
end


if host:isHost() then
foodCheckTimer = foodCheckTimer + 1
if foodCheckTimer >= 4 then
foodCheckTimer = 0
local food = player:getFood()
local satur = player:getSaturation()
local shouldSync = food ~= lastSentFood


if initFoodSyncTicks > 0 then
initFoodSyncTicks = initFoodSyncTicks - 1
shouldSync = true
end


foodResyncTimer = foodResyncTimer + 1
if foodResyncTimer >= 75 then
foodResyncTimer = 0
shouldSync = true
end

if shouldSync then
lastSentFood = food
lastSentSatur = satur
pings.syncFood(food)
pings.syncSatur(satur)
end
end
end


local foodRatio = syncedFood / 20
local saturRatio = syncedSatur / 20
local foodWidth = math.max(CONFIG.barWidth * foodRatio, 0)
local saturWidth = math.max(CONFIG.barWidth * saturRatio, 0)
if foodWidth ~= lastFoodWidth then
lastFoodWidth = foodWidth
foodFill:setSize(foodWidth, CONFIG.barHeight)
saturFill:setSize(foodWidth, CONFIG.barHeight)
end
if saturWidth ~= lastSaturWidth then
lastSaturWidth = saturWidth
saturFill:setSize(saturWidth, 0.5)
end
end




function events.render(delta, context)
local hudVisible = client:isHudEnabled()
local localFirstPerson = false
if host:isHost() then
local firstPersonByContext = context == "FIRST_PERSON"
local firstPersonByRenderer = renderer.isFirstPerson and renderer:isFirstPerson() or false
localFirstPerson = firstPersonByContext or firstPersonByRenderer


if not localFirstPerson then
local camPos = client:getCameraPos()
local p = player:getPos(delta)
local eyeY = p.y + player:getEyeHeight()
local dx = camPos.x - p.x
local dy = camPos.y - eyeY
local dz = camPos.z - p.z
localFirstPerson = (dx * dx + dy * dy + dz * dz) < 0.04
end
end
local thirdPersonAllowed = (not host:isHost()) or CONFIG.showInThirdPerson or localFirstPerson
local showNameplate = hudVisible and not localFirstPerson and thirdPersonAllowed
nameplatePart:setVisible(showNameplate)
if not showNameplate then return end
local p = player:getPos(delta)
nameplatePart:setPos(p.x * 16, p.y * 16 + CONFIG.verticalOffset, p.z * 16)


local camYaw = client:getCameraRot().y
local billboard = -camYaw

nameplatePart:setRot(0, billboard, 0)
end





function pings.syncFood(food)
      syncedFood = food
end

function pings.syncSatur(satur)
      syncedSatur = satur
end
