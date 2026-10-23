local Hyperion

local REMOTE_URL = "https://raw.githubusercontent.com/thecoolersyn/syniscool/refs/heads/main/src.lua"

local function loadLibrary()
	if not (game and game.HttpGet) then
		error("[Hyperion] game.HttpGet is unavailable - the library is loaded from the remote URL only")
	end
	local ok, content = pcall(game.HttpGet, game, REMOTE_URL)
	if not ok or type(content) ~= "string" or #content == 0 then
		error(("[Hyperion] failed to fetch library from %s: %s"):format(REMOTE_URL, tostring(content)))
	end
	local fn, err = loadstring(content, "hyperion:remote")
	if not fn then
		error(("[Hyperion] remote library did not compile: %s"):format(tostring(err)))
	end
	local ok2, result = pcall(fn)
	if not ok2 or type(result) ~= "table" then
		error(("[Hyperion] remote library chunk returned invalid result: %s"):format(tostring(result)))
	end
	print("[Hyperion] library loaded from remote URL")
	return result
end

Hyperion = loadLibrary()

local Window = Hyperion:CreateWindow({
	Title = "Hyperion",
	ToggleKey = "LeftControl",
})

local function demo(name)
	return function(value)
		print(("[Hyperion] %s → %s"):format(name, tostring(value)))
	end
end

local Blatant = Window:AddTab({ Name = "Blatant", Icon = "skull" })
local Player  = Window:AddTab({ Name = "Player",  Icon = "user" })
local Visuals = Window:AddTab({ Name = "Visuals", Icon = "eye-off" })
local Misc    = Window:AddTab({ Name = "Miscellaneous", Icon = "list" })
local Configs = Window:AddTab({ Name = "Configs", Icon = "save" })
local LuaTab  = Window:AddTab({ Name = "Lua",     Icon = "book-open" })

local KillAura = Blatant:AddModule({
	Name = "Kill Aura",
	Keybind = "K",
	NotifyOnToggle = true,
	Callback = function(state)
		print("[Hyperion] Kill Aura " .. (state and "ON" or "OFF"))
	end,
})
KillAura:AddSlider({
	Name = "Attack Range",
	Min = 5, Max = 25, Default = 12,
	Callback = demo("Attack Range"),
})
KillAura:AddDropdown({
	Name = "Target Priority",
	Options = { "Closest", "Lowest Health", "Strongest" },
	Default = "Closest",
	Callback = demo("Target Priority"),
})

local AutoCollect = Blatant:AddModule({
	Name = "Auto Collect",
	Keybind = "C",
	NotifyOnToggle = true,
	Callback = demo("Auto Collect"),
})
AutoCollect:AddSlider({
	Name = "Collect Delay",
	Min = 0, Max = 2, Default = 0.5, Decimals = 2,
	Callback = demo("Collect Delay"),
})
AutoCollect:AddDropdown({
	Name = "Sell Location",
	Options = { "Nearest", "Spawn", "Shop" },
	Default = "Nearest",
	Callback = demo("Sell Location"),
})

Blatant:AddModule({
	Name = "Auto Sell",
	Callback = demo("Auto Sell"),
})

local Fly = Blatant:AddModule({
	Name = "Fly",
	Keybind = "F",
	NotifyOnToggle = true,
	Callback = demo("Fly"),
})
Fly:AddSlider({
	Name = "Fly Speed",
	Min = 16, Max = 250, Default = 60,
	Callback = demo("Fly Speed"),
})
Fly:AddSlider({
	Name = "Walk Speed",
	Min = 16, Max = 100, Default = 16,
	Callback = function(v)
		demo("Walk Speed")(v)
	end,
})

Player:AddModule({
	Name = "Infinite Jump",
	Keybind = "J",
	Callback = demo("Infinite Jump"),
})

local AntiVoid = Player:AddModule({
	Name = "Anti Void",
	Callback = demo("Anti Void"),
})
AntiVoid:AddDropdown({
	Name = "Anti Void Mode",
	Options = { "Teleport Up", "Reset", "Platform" },
	Default = "Teleport Up",
	Callback = demo("Anti Void Mode"),
})

local PlayerESP = Visuals:AddModule({
	Name = "Player ESP",
	Keybind = "P",
	NotifyOnToggle = true,
	Callback = demo("Player ESP"),
})
PlayerESP:AddDropdown({
	Name = "ESP Style",
	Options = { "Box", "Corner Box", "Name Only" },
	Default = "Box",
	Callback = demo("ESP Style"),
})
PlayerESP:AddColorPick({
	Name = "Colors",
	Color = Color3.fromRGB(255, 255, 255),
	Callback = demo("ESP Color"),
})

Visuals:AddModule({
	Name = "Tracers",
	Callback = demo("Tracers"),
})

local WorldVisuals = Visuals:AddModule({
	Name = "World Visuals",
	Callback = demo("World Visuals"),
})
WorldVisuals:AddDropdown({
	Name = "Time of Day",
	Options = { "Day", "Night", "Sunset" },
	Default = "Day",
	Callback = demo("Time of Day"),
})
WorldVisuals:AddSlider({
	Name = "Field of View",
	Min = 70, Max = 120, Default = 70,
	Callback = demo("Field of View"),
})

local ServerUtils = Misc:AddModule({
	Name = "Server Utilities",
	Callback = demo("Server Utilities"),
})
ServerUtils:AddButton({
	Name = "Rejoin Server",
	Callback = function()
		print("[Hyperion] Rejoin Server")
	end,
})
ServerUtils:AddButton({
	Name = "Server Hop",
	Callback = function()
		print("[Hyperion] Server Hop")
	end,
})

local Performance = Misc:AddModule({
	Name = "Performance",
	Callback = demo("Performance"),
})
Performance:AddDropdown({
	Name = "FPS Cap",
	Options = { "60", "120", "240", "Unlimited" },
	Default = "60",
	Callback = demo("FPS Cap"),
})

Misc:AddModule({
	Name = "Disable Effects",
	Callback = demo("Disable Effects"),
})

local ConfigGroup = Configs:AddModule({
	Name = "Profiles",
	Callback = demo("Profiles"),
})
local ProfileConfigs = ConfigGroup:AddDropdown({
	Name = "Config",
	Options = Window:ConfigNames(),
	Default = Window:GetSelectedConfig(),
	Callback = function(v)
		demo("Selected Config")(v)
		Window:LoadConfig(v)
	end,
})
Window:WatchConfigDropdown(ProfileConfigs)
ConfigGroup:AddButton({
	Name = "Save Config",
	Callback = function()
		if Window:SaveConfig() then
			print("[Hyperion] Config saved")
		else
			print("[Hyperion] Config not saved - create one from the gear panel first")
		end
	end,
})
ConfigGroup:AddButton({
	Name = "Load Config",
	Callback = function()
		if Window:LoadConfig() then
			print("[Hyperion] Config loaded")
		end
	end,
})

local Scripting = LuaTab:AddModule({
	Name = "Snippet Runner",
	Callback = demo("Snippet Runner"),
})
Scripting:AddLabel({
	Text = "A script editor would go here. This is just a placeholder example.",
})
Scripting:AddButton({
	Name = "Execute Snippet",
	Callback = function()
		print("[Hyperion] Snippet executed")
	end,
})

task.delay(0.5, function()
	Window:Notify({
		Title = "Hyperion",
		Text = "UI loaded. Press LeftControl to minimize.",
		Duration = 4,
	})
end)

if getgenv then
	local ok, g = pcall(getgenv)
	if ok and type(g) == "table" then
		g.HyperionUI = Window
		g.HyperionModules = Window:Modules()
	end
end

return Window
