-- NorepineUI test harness: loads src.lua as a library and builds a demo menu
local SRC_PATH = "NorephineUI/src.lua"
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

-- Combat tab with category separators
local combat = Window:AddTab({ Name = "Combat", Icon = "sword" })
combat:AddCategory("Main")
local movSec = combat:AddSection({ Name = "Movement" })
local modeDd = movSec:AddDropdown({
	Name = "Mode",
	Options = { "Fast", "Slow", "Medium" },
	Default = "Fast",
	Callback = function(v)
		print("[NorepineTest] Mode -> " .. tostring(v))
	end,
})
movSec:AddToggle({ Name = "Fly Speed", Default = false, NotifyOnToggle = true })
movSec:AddKeybind({ Name = "Manual Rebind", Default = Enum.KeyCode.B })
combat:AddCategory("Detections")
combat:AddSection({ Name = "Staff Detection" })
combat:AddCategory("Misc")
combat:AddSection({ Name = "Extra" })

local visuals = Window:AddTab({ Name = "Visuals", Icon = "eye" })
visuals:AddCategory("Main")
local espSec = visuals:AddSection({ Name = "ESP" })
espSec:AddColorPick({ Name = "Box Color", Default = Color3.fromRGB(255, 255, 255) })
espSec:AddSlider({ Name = "Opacity", Min = 0, Max = 100, Default = 80 })
visuals:AddSection({ Name = "Chams" })

local exclusive = Window:AddTab({ Name = "Exclusive", Icon = "crown" })
exclusive:AddCategory("Main")
exclusive:AddSection({ Name = "Identity Hider" })

-- Pre-bind the Slow option to X so the keybind list has an example entry
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
print("[NorepineTest] loaded; theme = " .. tostring(Library:GetTheme()))
print("[NorepineTest] themes = " .. table.concat(Library:GetThemeNames(), ", "))
