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

-- Combat section: separators appear in the SIDEBAR between tab groups
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
movSec:AddToggle({ Name = "Fly Speed", Default = false, NotifyOnToggle = true })
movSec:AddKeybind({ Name = "Manual Rebind", Default = Enum.KeyCode.B })

Window:AddTab({ Name = "Detections", Section = "Combat" })
	:AddSection({ Name = "Staff Detection" })
Window:AddTab({ Name = "Misc", Section = "Combat" })
	:AddSection({ Name = "Extra" })

Window:AddTab({ Name = "Main", Icon = "eye", Section = "Visuals" })
	:AddSection({ Name = "ESP" })
Window:AddTab({ Name = "Main", Icon = "crown", Section = "Exclusive" })
	:AddSection({ Name = "Identity Hider" })

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
