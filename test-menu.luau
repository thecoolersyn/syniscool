local SRC_PATH = "NorepineUI/src.lua"
local raw = readfile(SRC_PATH)
local fn, cerr = loadstring(raw, "NorepineUI")
if not fn then
	error("NorepineUI compile error: " .. tostring(cerr))
end
local ok, Library = pcall(fn)
if not ok then
	error("NorepineUI runtime error on load: " .. tostring(Library))
end
pcall(function()
	if getgenv().NorepineUnloadUI then
		getgenv().NorepineUnloadUI()
	end
end)
local Window = Library:CreateWindow({
	Title = "Norepine",
	Size = UDim2.fromOffset(700, 460),
})

local cMain = Window:AddTab({ Name = "Main", Icon = "sword", Section = "Combat" })
local movSec = cMain:AddSection({ Name = "Movement" })
local modeDd = movSec:AddDropdown({
	Name = "Mode",
	Options = { "Fast", "Slow", "Medium" },
	Default = "Fast",
	Callback = function(v)
		print("[NorepineTest] Mode -> " .. tostring(v))
	end,
})
local targetsDd = movSec:AddDropdown({
	Name = "Detection Targets",
	Options = {"Players", "NPCs", "Objects", "Vehicles"},
	MultiSelect = true,
	Default = {"Players"},
	Placeholder = "Select targets",
	Searchable = true,
	MaxSelections = 3,
	Callback = function(selected)
		print("[NorepineTest] Targets -> " .. table.concat(selected, ", "))
	end,
})
movSec:AddToggle({ Name = "Fly Speed", Default = false, NotifyOnToggle = true })
movSec:AddKeybind({ Name = "Manual Rebind", Default = Enum.KeyCode.B })
movSec:AddColorPick({
	Name = "Aura Color",
	Default = Color3.fromRGB(120, 90, 255),
	Callback = function(c)
		print("[NorepineTest] Aura Color -> " .. tostring(c))
	end,
})
movSec:AddButton({
	Name = "Send Test Notification",
	Callback = function()
		Window:Notify({
			Title = "Norepine",
			Text = "This is a test notification from the Combat > Main tab.",
			Duration = 5,
		})
	end,
})

for i = 1, 6 do
	local t = Window:AddTab({ Name = "Guard Test " .. i, Icon = "list" })
	local sec = t:AddSection({ Name = "Guard Test " .. i })
	sec:AddLabel({ Text = "Content marker for Guard Test " .. i })
end
Window:AddTab({ Name = "Misc", Section = "Combat" })
	:AddSection({ Name = "Extra" })

Window:AddTab({ Name = "Main", Icon = "camera", Section = "Visuals" })
	:AddSection({ Name = "ESP" })
Window:AddTab({ Name = "Main", Icon = "skull", Section = "Exclusive" })
	:AddSection({ Name = "Identity Hider" })
Window:AddTab({ Name = "Main", Icon = "combat", Section = "Exclusive" })
	:AddSection({ Name = "Identity Hider" })

local slowEntry = modeDd.OptionEntry and modeDd:OptionEntry("Slow")
if slowEntry and slowEntry.Bind then
	slowEntry:Bind(Enum.KeyCode.X)
	print("[NorepineTest] Slow bound to X")
end
Window:SetWatermark(true)
Window:SetSessionInfo(true)
Window:SetKeybindList(true)
Window:Show()
Window:Notify({ Title = "Norepine", Text = "Test UI loaded", Icon = "check" })
getgenv().NorepineTestLib = Library
print("[NorepineTest] loaded; theme = " .. tostring(Library:GetTheme()))
print("[NorepineTest] themes = " .. table.concat(Library:GetThemeNames(), ", "))
