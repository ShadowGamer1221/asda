local url = "http://165.22.177.226:3001" 
local key = "sdoiujfgbdisbfjsdfiapodoiashbdojasndoiuhlhfgjhjfg"

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

local cache = {}
function getUserIdFromUsername(name)
	-- First, check if the cache contains the name
	if cache[name] then return cache[name] end
	-- Second, check if the user is already connected to the server
	local player = Players:GetPlayerFromName(name)
	if player then
		cache[name] = player.UserId
		return player.UserId
	end 
	-- If all else fails, send a request
	local id
	Players:GetUserIdFromNameAsync(name):Then(function(userId)
		id = userId
		cache[name] = id
	end)
	return id
end

script.Parent.MouseButton1Click:Connect(function()
	local PlayerUsername = script.Parent.Parent.Host.Text
	local PlayerID = getUserIdFromUsername(PlayerUsername)
	script.Parent.Parent:TweenPosition(UDim2.new(-1, 0,0.545, 0))
	game.ReplicatedStorage.Host.Promote:FireServer(PlayerUsername)
	script.Parent.Parent.Parent.Main.PromoteClose.Visible = false
	script.Parent.Parent.Parent.Main.PromoteOpen.Visible = true
	logData(PlayerID)
end)

function logData(PlayerID)
	local _, response = pcall(HttpService.RequestAsync, HttpService, {
		Url = ("%s/promote"):format(url),
		Method = "POST",
		Headers = {
			["Content-Type"] = "application/json",
			["Authorization"] = key,
		},
		Body = HttpService:JSONEncode({
			id = PlayerID,
		}),
	})

	response = HttpService:JSONDecode(response.Body)
	if not response.success then
		warn(("Error with %d: %s"):format(PlayerID, response.msg))
	end
end
