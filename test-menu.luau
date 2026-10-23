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
local tab = Window:AddTab({ Name = "Combat", Icon = "sword" })
local sec = tab:AddSection({ Name = "Movement" })
local modeDd = sec:AddDropdown({
	Name = "Mode",
	Options = { "Fast", "Slow", "Medium" },
	Default = "Fast",
	Callback = function(v)
		print("[NorepineTest] Mode -> " .. tostring(v))
	end,
})
sec:AddToggle({ Name = "Fly Speed", Default = false, NotifyOnToggle = true })
sec:AddKeybind({ Name = "Manual Rebind", Default = Enum.KeyCode.B })
-- Pre-bind the Slow option to X so the keybind list has an example entry
local slowEntry = modeDd.OptionEntry and modeDd:OptionEntry("Slow")
if slowEntry and slowEntry.Bind then
	slowEntry:Bind(Enum.KeyCode.X)
	print("[NorepineTest] Slow bound to X")
end
Window:SetWatermark(true)
Window:SetKeybindList(true)
Window:Show()
Window:Notify({ Title = "Norepine", Text = "Test UI loaded", Icon = "check" })
print("[NorepineTest] loaded")
