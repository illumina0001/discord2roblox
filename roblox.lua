local DS = game:GetService("DataStoreService")
local P = game:GetService("Players")
local HS = game:GetService("HttpService")

local BStore = DS:GetDataStore("BannedUsers")

local endpoint = "https://(PROJECT NAME).glitch.me/execute" -- Again, replace with your server URL or Glitch project name
local function isBanned(uid)
	local success, data = pcall(function()
		return BStore:GetAsync(tostring(uid))
	end)
	if success and data then
		return true, data.reason
	else
		return false, nil
	end
end

local function ban(uid, reason)
	local success, err = pcall(function()
		BStore:SetAsync(tostring(uid), {reason = reason or "No reason"})
	end)
	if success then
		print("Banned user:", uid)
		for _, plr in ipairs(P:GetPlayers()) do
			if plr.UserId == tonumber(uid) then
				plr:Kick("You have been banned. Reason: " .. (reason or "No reason"))
				print("Kicked user:", uid)
				break
			end
		end
	else
		warn("Failed to ban user:", uid, "Error:", err)
	end
end

local function unban(uid)
	local success, err = pcall(function()
		BStore:RemoveAsync(tostring(uid))
	end)
	if success then
		print("Unbanned user:", uid)
	else
		warn("Failed to unban user:", uid, "Error:", err)
	end
end

P.PlayerAdded:Connect(function(plr)
	local uid = plr.UserId
	local banned, reason = isBanned(uid)
	if banned then
		if reason then
			plr:Kick("You have been banned. Reason: " .. reason)
		else
			plr:Kick("You have been banned.")
		end
	end
end)

local function execCmd(cmd)
	if cmd:sub(1, 4) == ":ban" then
		local args = string.split(cmd, " ")
		local uid = tonumber(args[2])
		local reason = table.concat(args, " ", 3)
		if uid then
			ban(uid, reason)
			print("Banned user ID:", uid, "Reason:", reason or "No reason")
		else
			print("Invalid UserId for :ban")
		end
	elseif cmd:sub(1, 6) == ":unban" then
		local args = string.split(cmd, " ")
		local uid = tonumber(args[2])
		if uid then
			unban(uid)
			print("Unbanned user ID:", uid)
		else
			print("Invalid UserId for :unban")
		end
	else
		local success, err = pcall(function()
			loadstring(cmd)()
		end)
		if not success then
			warn("Command error:", err)
		end
	end
end

local function pollCmds()
	while true do
		wait(5)
		local success, resp = pcall(function()
			return HS:GetAsync(endpoint)
		end)
		if success and resp then
			local data = HS:JSONDecode(resp)
			if data.command then
				execCmd(data.command)
			end
		else
			warn("Failed to fetch commands:", resp)
		end
	end
end

spawn(pollCmds)
