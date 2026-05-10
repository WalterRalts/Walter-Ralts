-- Implementing math.mod for molang compatibility
-- Modified by ynrie to use native C functions
function math.mod(x, y)
	return x % y
end

math.random_integer = math.random

-- Native C trig calls avoid Lua instruction overhead. q.anim_time is
-- pre-scaled by DEG_TO_RAD so expressions like Math.sin(time * 360) produce
-- the correct oscillation frequency despite radians-vs-degrees mismatch.
Math = Math or {}
Math.sin = math.sin
Math.cos = math.cos

local DEG_TO_RAD = math.pi / 180

q = { anim_time = 0 }

local TICK_SECONDS = 0.05
local anim_time = 0
local rot = vec(0, 0, 0)
local last_rot = rot
local rot_change = vec(0, 0, 0)
local last_rot_change = vec(0, 0, 0)
local friction = 0.6

function events.tick()
	anim_time = anim_time + TICK_SECONDS
	q.anim_time = anim_time * DEG_TO_RAD
	last_rot = rot
	rot = (player:getRot().xy_ + 180) % 360 - 180
	last_rot_change = rot_change
	rot_acc = math.shortAngle(rot, last_rot) * -20
	rot_change = rot_change + rot_acc
	rot_change = rot_change * friction
end

function events.render(delta)
	local d = delta or 0
	q.anim_time = (anim_time + (TICK_SECONDS * d)) * DEG_TO_RAD
	rot_delta = math.lerp(last_rot_change, rot_change, d)
end

q.r = {
	velocity_x = function()
		return 0
	end,
	velocity_y = function()
		return 0
	end,
	velocity_z = function()
		return 0
	end,
	yaw_change = function()
		return math.clamp(rot_delta.y / 140, -1, 1)
	end,
	pitch_change = function()
		return math.clamp(rot_delta.x / 90, -1, 1) * -1
	end,
	roll_change = function()
		return 0
	end,
	speed = function()
		return 0
	end,
	velocity_right = function()
		return 0
	end,
	velocity_left = function()
		return 0
	end,
	velocity_forward = function()
		return 0
	end,
	velocity_up = function()
		return 0
	end,
	yaw = function()
		return 0
	end,
	pitch = function()
		return 0
	end,
	roll = function()
		return 0
	end,
	input_right = function()
		return 0
	end,
	input_forward = function()
		return 0
	end,
	input_up = function()
		return 0
	end
}
query = q
