local TweenService      = game:GetService("TweenService")
local UserInputService  = game:GetService("UserInputService")
local RunService        = game:GetService("RunService")
local Players           = game:GetService("Players")
local HttpService       = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local Theme = {
	Background   = Color3.fromRGB(17, 17, 17),
	Group        = Color3.fromRGB(22, 22, 22),
	GroupStroke  = Color3.fromRGB(43, 43, 43),
	Control      = Color3.fromRGB(40, 40, 40),
	ControlHover = Color3.fromRGB(50, 50, 50),
	Divider      = Color3.fromRGB(32, 32, 32),
	Text         = Color3.fromRGB(229, 229, 232),
	TextDim      = Color3.fromRGB(158, 158, 164),
	TextSoft     = Color3.fromRGB(214, 214, 218),
	HeaderText   = Color3.fromRGB(140, 140, 146),
	TabSelected  = Color3.fromRGB(30, 30, 30),
	PillOff      = Color3.fromRGB(42, 42, 42),
	KnobOff      = Color3.fromRGB(216, 216, 216),
	PillOn       = Color3.fromRGB(236, 236, 236),
	KnobOn       = Color3.fromRGB(18, 18, 20),
	SliderTrack  = Color3.fromRGB(45, 45, 45),
	SliderFill   = Color3.fromRGB(255, 255, 255),
	CardTransparency = 0.45,
	NotifyTransparency = 0.45,
}
local LucideIcons = {
	["bell"]             = "rbxassetid://10709775704",
	["bell-off"]         = "rbxassetid://10709775320",
	["menu"]             = "rbxassetid://10734887784",
	["sliders"]          = "rbxassetid://10734963400",
	["chevrons-up-down"] = "rbxassetid://10709797508",
	["keyboard"]         = "rbxassetid://10723416765",
	["skull"]            = "rbxassetid://10734962068",
	["user"]             = "rbxassetid://10747373176",
	["eye-off"]          = "rbxassetid://10723346871",
	["list"]             = "rbxassetid://10723433811",
	["save"]             = "rbxassetid://10734941499",
	["book-open"]        = "rbxassetid://10709781717",
	["terminal"]         = "rbxassetid://10734982144",
	["database"]         = "rbxassetid://10709818996",
	["settings"]         = "rbxassetid://10734950309",
	["cog"]              = "rbxassetid://10709810948",
	["check"]            = "rbxassetid://10709790644",
	["x"]                = "rbxassetid://10747384394",
	["folder-plus"]      = "rbxassetid://10723386531",
	["folder"]           = "rbxassetid://10723387563",
}
local TWEEN_FAST   = TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local TWEEN_MED    = TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local TWEEN_PAGE   = TweenInfo.new(0.24, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local TWEEN_TOGGLE = TweenInfo.new(0.22, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
local TWEEN_NOTIFY_IN  = TweenInfo.new(0.24, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local TWEEN_NOTIFY_OUT = TweenInfo.new(0.20, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
local TWEEN_OPEN   = TweenInfo.new(0.20, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local FONT_SEMIBOLD = Font.new(
	"rbxasset://fonts/families/GothamSSm.json",
	Enum.FontWeight.SemiBold,
	Enum.FontStyle.Normal
)
local FONT_BOLD = Font.new(
	"rbxasset://fonts/families/GothamSSm.json",
	Enum.FontWeight.Bold,
	Enum.FontStyle.Normal
)
local NOTIFY_DURATION = 3.25
local NOTIFY_LOCATIONS = { "Corner Right", "Corner Left", "Top Right", "Top Left", "Middle Right", "Middle Left" }
local function New(className, props, children)
	local inst = Instance.new(className)
	for k, v in pairs(props or {}) do
		if k ~= "Parent" then
			inst[k] = v
		end
	end
	for _, child in ipairs(children or {}) do
		child.Parent = inst
	end
	if props and props.Parent ~= nil then
		inst.Parent = props.Parent
	end
	return inst
end
local function Tween(obj, info, props)
	TweenService:Create(obj, info or TWEEN_FAST, props):Play()
end
local function Corner(parent, radius)
	return New("UICorner", { CornerRadius = UDim.new(0, radius), Parent = parent })
end
local function Stroke(parent, color, transparency)
	return New("UIStroke", {
		Color = color or Theme.GroupStroke,
		Transparency = transparency or 0,
		Thickness = 1,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Parent = parent,
	})
end
local function Pad(parent, top, bottom, left, right)
	return New("UIPadding", {
		PaddingTop    = UDim.new(0, top or 0),
		PaddingBottom = UDim.new(0, bottom or 0),
		PaddingLeft   = UDim.new(0, left or 0),
		PaddingRight  = UDim.new(0, right or 0),
		Parent = parent,
	})
end
local function round(num, decimals)
	local mult = 10 ^ (decimals or 0)
	return math.floor(num * mult + 0.5) / mult
end
local function MakeIcon(parent, icon, size, color)
	local asset = icon and LucideIcons[icon]
	if asset then
		return New("ImageLabel", {
			Size = UDim2.fromOffset(size, size),
			BackgroundTransparency = 1,
			Image = asset,
			ImageColor3 = color,
			ScaleType = Enum.ScaleType.Fit,
			Parent = parent,
		})
	elseif typeof(icon) == "string" and icon:match("^rbxasset") then
		return New("ImageLabel", {
			Size = UDim2.fromOffset(size, size),
			BackgroundTransparency = 1,
			Image = icon,
			ImageColor3 = color,
			ScaleType = Enum.ScaleType.Fit,
			Parent = parent,
		})
	end
	return New("Frame", {
		Size = UDim2.fromOffset(4, 4),
		BackgroundColor3 = color,
		BorderSizePixel = 0,
		Parent = parent,
	})
end
local function IconButton(parent, size, radius)
	local btn = New("TextButton", {
		Size = UDim2.fromOffset(size, size),
		BackgroundColor3 = Theme.Control,
		BackgroundTransparency = 1,
		Text = "",
		AutoButtonColor = false,
		BorderSizePixel = 0,
		Parent = parent,
	})
	Corner(btn, radius or 7)
	btn.MouseEnter:Connect(function() Tween(btn, TWEEN_FAST, { BackgroundTransparency = 0.55 }) end)
	btn.MouseLeave:Connect(function() Tween(btn, TWEEN_FAST, { BackgroundTransparency = 1 }) end)
	return btn
end
local function KeybindText(key)
	return "[" .. (key and key.Name or "...") .. "]"
end
local function HueToColor(h)
	local c = math.clamp(1 - math.abs((h % (1 / 3)) * 6 - 3), 0, 1)
	if h < 1 / 6 then
		return Color3.new(1, c, 0)
	elseif h < 1 / 3 then
		return Color3.new(c, 1, 0)
	elseif h < 0.5 then
		return Color3.new(0, 1, c)
	elseif h < 2 / 3 then
		return Color3.new(0, c, 1)
	elseif h < 5 / 6 then
		return Color3.new(c, 0, 1)
	end
	return Color3.new(1, 0, c)
end
local function ColorToRgbTable(c)
	return { R = round(c.R, 4), G = round(c.G, 4), B = round(c.B, 4) }
end
local function RgbTableToColor(t, fallback)
	if type(t) ~= "table" then return fallback end
	local r, g, b = tonumber(t.R), tonumber(t.G), tonumber(t.B)
	if r == nil or g == nil or b == nil then return fallback end
	return Color3.new(math.clamp(r, 0, 1), math.clamp(g, 0, 1), math.clamp(b, 0, 1))
end
local function PreviousWindow()
	local ok, g = pcall(getgenv)
	if ok and type(g) == "table" then
		local w = g.HyperionUI
		if type(w) == "table" and type(w.Destroy) == "function" then
			return w
		end
	end
	return nil
end
-- ===========================================================================
-- Game-scoped storage. Owned entirely by the UI source: the main game script
-- never has to say which game it is or where anything is stored.
--
--   Hyperion/<game-id>/assets/
--   Hyperion/<game-id>/configs/
--   Hyperion/<game-id>/configs/Selected.txt   (last chosen config, per game)
-- ===========================================================================
local HYPERION_ROOT = "Hyperion"

-- Short identifiers for known games; extend here and nothing else changes.
local GAME_ID_BY_NAME = {
	["blade ball"]      = "bb",
	["bladeball"]       = "bb",
	["fisch"]           = "fisch",
	["murder mystery 2"] = "mm2",
	["murdermystery2"]  = "mm2",
	["evade"]           = "evade",
}

-- Exact overrides keyed by universe id when a name cannot be resolved.
local GAME_ID_BY_UNIVERSE = {}

local function FoldName(text)
	return tostring(text or ""):lower():gsub("[^%w]+", " "):gsub("^%s+", ""):gsub("%s+$", "")
end

local function SlugName(text)
	local s = FoldName(text):gsub("%s+", "_")
	if s == "" then return nil end
	if #s > 32 then s = s:sub(1, 32) end
	return s
end

local function CurrentPlaceName()
	local ok, name = pcall(function() return game.PlaceName end)
	if ok and type(name) == "string" and name ~= "" then return name end
	-- Some executors hand back a stub DataModel with no PlaceName; the
	-- marketplace lookup is the reliable fallback there.
	local ok2, info = pcall(function()
		return game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId, Enum.InfoType.Asset)
	end)
	if ok2 and type(info) == "table" then
		local n = tostring(info.Name or "")
		if n ~= "" then return n end
	end
	return nil
end

local function ResolveGameId()
	local okGid, gid = pcall(function() return game.GameId end)
	if okGid and gid and GAME_ID_BY_UNIVERSE[gid] then
		return GAME_ID_BY_UNIVERSE[gid]
	end
	local name = CurrentPlaceName()
	if name then
		local folded = FoldName(name)
		local known = GAME_ID_BY_NAME[folded] or GAME_ID_BY_NAME[folded:gsub("%s+", "")]
		if known then return known end
		local slug = SlugName(name)
		if slug then return slug end
	end
	if okGid and gid and gid ~= 0 then
		-- Unique per experience, so two unknown games can never share a folder.
		return "gid_" .. tostring(gid)
	end
	return "default"
end

local GameName = CurrentPlaceName()
local GameId = ResolveGameId()
local GameRoot = HYPERION_ROOT .. "/" .. GameId
local AssetDir = GameRoot .. "/assets"
local ConfigDir = GameRoot .. "/configs"
local SelectedFile = ConfigDir .. "/Selected.txt"

local function CanWriteFiles()
	return type(writefile) == "function" and type(readfile) == "function"
end

local function EnsureDir(path)
	if type(makefolder) ~= "function" then return end
	pcall(makefolder, HYPERION_ROOT)
	pcall(makefolder, GameRoot)
	pcall(makefolder, AssetDir)
	pcall(makefolder, ConfigDir)
end
EnsureDir()

local function ReadSelectedConfig()
	if not CanWriteFiles() then return nil end
	local ok, raw = pcall(readfile, SelectedFile)
	if not ok or type(raw) ~= "string" then return nil end
	local name = raw:gsub("^%s+", ""):gsub("%s+$", ""):gsub("[\r\n]", "")
	if name == "" then return nil end
	return name
end

local function WriteSelectedConfig(name)
	if not CanWriteFiles() or not name then return false end
	EnsureDir()
	return pcall(writefile, SelectedFile, tostring(name))
end

local Library = {}
function Library:GetGameId() return GameId end
function Library:GetGameName() return GameName end
function Library:GetGameRoot() return GameRoot end
function Library:GetAssetDirectory() return AssetDir end
function Library:GetConfigDirectory() return ConfigDir end
local GetLastSelectedConfig = ReadSelectedConfig
local SetLastSelectedConfig = WriteSelectedConfig
local activeWindow = nil
function Library:Notify(n, ...)
	if activeWindow then
		return activeWindow:Notify(n, ...)
	end
end
function Library:Toggle()
	if activeWindow then return activeWindow:Toggle() end
end
function Library:Show()
	if activeWindow then return activeWindow:Show() end
end
function Library:Hide()
	if activeWindow then return activeWindow:Hide() end
end
function Library:Destroy()
	if activeWindow then return activeWindow:Destroy() end
end
function Library:Window() return activeWindow end
function Library:CreateWindow(opts)
	opts = opts or {}
	local title = opts.Title or "Hyperion"
	local size  = opts.Size or UDim2.fromOffset(700, 460)
	local guiParent
	pcall(function()
		if gethui then guiParent = gethui() end
	end)
	if not guiParent then
		local ok, core = pcall(function() return game:GetService("CoreGui") end)
		if ok and core then
			local ok2 = pcall(function()
				local t = Instance.new("Folder")
				t.Parent = core
				t:Destroy()
			end)
			if ok2 then guiParent = core end
		end
	end
	if not guiParent then
		guiParent = LocalPlayer:WaitForChild("PlayerGui")
	end
	local winConns = {}
	local function Connect(signal, fn)
		local conn = signal:Connect(fn)
		table.insert(winConns, conn)
		return conn
	end
	local function Release(conn)
		local idx = table.find(winConns, conn)
		if idx then
			table.remove(winConns, idx)
		end
		pcall(function() conn:Disconnect() end)
	end
	local function ReleaseConns()
		local snapshot = {}
		for i, conn in ipairs(winConns) do snapshot[i] = conn end
		table.clear(winConns)
		for _, conn in ipairs(snapshot) do
			pcall(function()
				if conn.Connected then conn:Disconnect() end
			end)
		end
	end
	local prev = PreviousWindow()
	if prev then
		pcall(prev.Destroy, prev)
	end
	local old = guiParent:FindFirstChild("HyperionUI")
	if old then old:Destroy() end
	local Gui = New("ScreenGui", {
		Name = "HyperionUI",
		ResetOnSpawn = false,
		IgnoreGuiInset = true,
		DisplayOrder = 999,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		Parent = guiParent,
	})
	local Main = New("CanvasGroup", {
		Name = "Main",
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = size,
		BackgroundColor3 = Theme.Background,
		BackgroundTransparency = 0.15,
		BorderSizePixel = 0,
		GroupTransparency = 1,
		Parent = Gui,
	})
	Corner(Main, 12)
	Stroke(Main, Theme.GroupStroke, 0.4)
	local uiScale = New("UIScale", { Scale = 0.96, Parent = Main })
	local uiHomePos = UDim2.fromScale(0.5, 0.5)
	local HEADER_H = 46
	local Sidebar = New("Frame", {
		Name = "Sidebar",
		Position = UDim2.new(0, 0, 0, HEADER_H),
		Size = UDim2.new(0, 160, 1, -HEADER_H),
		BackgroundTransparency = 1,
		Parent = Main,
	})
	Pad(Sidebar, 10, 10, 10, 10)
	New("UIListLayout", {
		Padding = UDim.new(0, 6),
		SortOrder = Enum.SortOrder.LayoutOrder,
		Parent = Sidebar,
	})
	local Content = New("Frame", {
		Name = "Content",
		Position = UDim2.new(0, 161, 0, HEADER_H),
		Size = UDim2.new(1, -161, 1, -HEADER_H),
		BackgroundTransparency = 1,
		Parent = Main,
	})
	local Header = New("Frame", {
		Name = "Header",
		Size = UDim2.new(1, 0, 0, HEADER_H),
		BackgroundTransparency = 1,
		ZIndex = 6,
		Parent = Main,
	})
	local titleLabel = New("TextLabel", {
		Name = "Title",
		Position = UDim2.new(0, 16, 0, 0),
		Size = UDim2.new(1, -104, 1, 0),
		BackgroundTransparency = 1,
		Text = title,
		Font = Enum.Font.GothamBold,
		TextSize = 16,
		TextColor3 = Theme.Text,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 7,
		Parent = Header,
	})
	if opts.Logo then
		local logo = MakeIcon(Header, opts.Logo, 20, Theme.Text)
		logo.AnchorPoint = Vector2.new(1, 0.5)
		logo.Position = UDim2.new(1, -52, 0.5, 0)
		logo.ZIndex = 7
	end
	New("Frame", {
		Position = UDim2.new(0, 0, 0, HEADER_H),
		Size = UDim2.new(1, 0, 0, 1),
		BackgroundColor3 = Theme.Divider,
		BorderSizePixel = 0,
		ZIndex = 6,
		Parent = Main,
	})
local openColorPicker = nil
local function ColorPreview(parent, order, o)
	o = o or {}
	local self = {}
	local value = o.Default or o.Color or o.Value
	if typeof(value) ~= "Color3" then
		value = Color3.fromRGB(255, 255, 255)
	end
	local hsvH, hsvS, hsvV = value:ToHSV()
	local row = New("Frame", {
		Name = "Color_" .. tostring(o.Name or "Colors"),
		LayoutOrder = order,
		Size = UDim2.new(1, 0, 0, 26),
		BackgroundTransparency = 1,
		Parent = parent,
	})
	New("TextLabel", {
		Name = "ColorName",
		Size = UDim2.new(1, -46, 1, 0),
		BackgroundTransparency = 1,
		Text = o.Name or "Colors",
		FontFace = FONT_SEMIBOLD,
		TextSize = 15,
		TextColor3 = Theme.TextSoft,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
		Parent = row,
	})
	local swatch = New("TextButton", {
		Name = "Swatch",
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, 0, 0.5, 0),
		Size = UDim2.fromOffset(34, 16),
		BackgroundColor3 = value,
		Text = "",
		AutoButtonColor = false,
		BorderSizePixel = 0,
		Parent = row,
	})
	Corner(swatch, 4)
	Stroke(swatch, Theme.GroupStroke, 0.1)
	local POPUP_W, POPUP_H = 216, 158
	local SPECTRUM_H, BAR_H = 98, 12
	local popup = New("Frame", {
		Name = "ColorPopup",
		Visible = false,
		Size = UDim2.fromOffset(POPUP_W, POPUP_H),
		BackgroundColor3 = Theme.Background,
		BackgroundTransparency = 0.05,
		BorderSizePixel = 0,
		ZIndex = 40,
		Parent = Main,
	})
	Corner(popup, 9)
	Stroke(popup, Theme.GroupStroke, 0)
	local guard = New("TextButton", {
		Name = "ColorGuard",
		Visible = false,
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Text = "",
		AutoButtonColor = false,
		ZIndex = 39,
		Parent = Main,
	})
	local spectrum = New("TextButton", {
		Name = "Spectrum",
		Position = UDim2.new(0, 10, 0, 10),
		Size = UDim2.new(0, POPUP_W - 20, 0, SPECTRUM_H),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		AutoButtonColor = false,
		BorderSizePixel = 0,
		ZIndex = 41,
		Parent = popup,
	})
	Corner(spectrum, 5)
	New("UIGradient", {
		Rotation = 90,
		Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(0, 0, 0)),
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 1),
			NumberSequenceKeypoint.new(1, 0),
		}),
		Parent = spectrum,
	})
	local satGrad = New("UIGradient", {
		Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(255, 255, 255)),
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0),
			NumberSequenceKeypoint.new(1, 1),
		}),
		Parent = spectrum,
	})
	local specDot = New("Frame", {
		Name = "Dot",
		AnchorPoint = Vector2.new(0.5, 0.5),
		Size = UDim2.fromOffset(10, 10),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BorderSizePixel = 0,
		ZIndex = 43,
		Parent = spectrum,
	})
	Corner(specDot, 5)
	Stroke(specDot, Color3.fromRGB(20, 20, 20), 0)
	local hueBar = New("TextButton", {
		Name = "Hue",
		Position = UDim2.new(0, 10, 0, 10 + SPECTRUM_H + 8),
		Size = UDim2.new(0, POPUP_W - 20, 0, BAR_H),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		AutoButtonColor = false,
		BorderSizePixel = 0,
		ZIndex = 41,
		Parent = popup,
	})
	Corner(hueBar, 5)
	do
		local stops = {}
		for i = 0, 6 do
			stops[i + 1] = ColorSequenceKeypoint.new(i / 6, HueToColor(i / 6))
		end
		New("UIGradient", { Color = ColorSequence.new(stops), Parent = hueBar })
	end
	local hueKnob = New("Frame", {
		Name = "Knob",
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(hsvH, 0, 0.5, 0),
		Size = UDim2.fromOffset(4, BAR_H + 4),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BorderSizePixel = 0,
		ZIndex = 43,
		Parent = hueBar,
	})
	local preview = New("Frame", {
		Name = "Preview",
		Position = UDim2.new(0, 10, 1, -26),
		Size = UDim2.fromOffset(34, 16),
		BackgroundColor3 = value,
		BorderSizePixel = 0,
		ZIndex = 42,
		Parent = popup,
	})
	Corner(preview, 4)
	Stroke(preview, Theme.GroupStroke, 0.1)
	local valueLabel = New("TextLabel", {
		Name = "ValueLabel",
		Position = UDim2.new(0, 52, 1, -26),
		Size = UDim2.new(1, -62, 0, 16),
		BackgroundTransparency = 1,
		Text = "",
		FontFace = FONT_SEMIBOLD,
		TextSize = 11,
		TextColor3 = Theme.TextDim,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 42,
		Parent = popup,
	})
	local function refresh()
		swatch.BackgroundColor3 = value
		preview.BackgroundColor3 = value
		satGrad.Color = ColorSequence.new(HueToColor(hsvH), HueToColor(hsvH))
		specDot.Position = UDim2.new(hsvS, 0, 1 - hsvV, 0)
		specDot.BackgroundColor3 = value
		hueKnob.Position = UDim2.new(hsvH, 0, 0.5, 0)
		hueKnob.BackgroundColor3 = HueToColor(hsvH)
		valueLabel.Text = ("R%d G%d B%d"):format(
			math.floor(value.R * 255 + 0.5),
			math.floor(value.G * 255 + 0.5),
			math.floor(value.B * 255 + 0.5))
	end
	local function emit()
		if o.Callback then task.spawn(o.Callback, value) end
	end
	local function dragFrom(obj, applyXY)
		local active = false
		local function sample(input)
			local p, s = obj.AbsolutePosition, obj.AbsoluteSize
			if s.X <= 0 or s.Y <= 0 then return end
			local beforeR = value.R
			local beforeG = value.G
			local beforeB = value.B
			applyXY(
				math.clamp((input.Position.X - p.X) / s.X, 0, 1),
				math.clamp((input.Position.Y - p.Y) / s.Y, 0, 1))
			refresh()
			if value.R ~= beforeR or value.G ~= beforeG or value.B ~= beforeB then
				emit()
			end
		end
		obj.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then
				active = true
				sample(input)
			end
		end)
		Connect(UserInputService.InputChanged, function(input)
			if active and (input.UserInputType == Enum.UserInputType.MouseMovement
				or input.UserInputType == Enum.UserInputType.Touch) then
				sample(input)
			end
		end)
		Connect(UserInputService.InputEnded, function(input)
			if active and (input.UserInputType == Enum.UserInputType.MouseButton1
				or input.UserInputType == Enum.UserInputType.Touch) then
				active = false
				emit()
			end
		end)
	end
	dragFrom(spectrum, function(x, y)
		hsvS = x
		hsvV = 1 - y
		value = Color3.fromHSV(hsvH, hsvS, hsvV)
	end)
	dragFrom(hueBar, function(x)
		hsvH = x
		value = Color3.fromHSV(hsvH, hsvS, hsvV)
	end)
	local function place()
		local mx, my = Main.AbsolutePosition.X, Main.AbsolutePosition.Y
		local mw, mh = Main.AbsoluteSize.X, Main.AbsoluteSize.Y
		local sy = swatch.AbsolutePosition.Y - my + swatch.AbsoluteSize.Y + 6
		if sy + POPUP_H > mh - 6 then
			sy = swatch.AbsolutePosition.Y - my - POPUP_H - 6
		end
		sy = math.max(6, math.min(sy, mh - POPUP_H - 6))
		local sx = swatch.AbsolutePosition.X - mx + swatch.AbsoluteSize.X - POPUP_W
		sx = math.max(6, math.min(sx, mw - POPUP_W - 6))
		popup.Position = UDim2.new(0, sx, 0, sy)
	end
	local function setOpen(v)
		v = v == true
		if v then
			if openColorPicker and openColorPicker ~= self then
				openColorPicker:Close()
			end
			place()
			openColorPicker = self
		elseif openColorPicker == self then
			openColorPicker = nil
		end
		popup.Visible = v
		guard.Visible = v
	end
	swatch.MouseButton1Click:Connect(function()
		setOpen(not popup.Visible)
	end)
	guard.MouseButton1Click:Connect(function()
		setOpen(false)
	end)
	refresh()
	self.Kind = "Color"
	self.Get = function() return value end
	self.GetValue = function() return value end
	self.Set = function(_, v, fire)
		if typeof(v) ~= "Color3" then return end
		value = v
		hsvH, hsvS, hsvV = value:ToHSV()
		refresh()
		if fire ~= false then emit() end
	end
	self.SetValue = function(_, v, fire) self:Set(v, fire) end
	self.IsOpen = function() return popup.Visible end
	self.Open = function() setOpen(true) end
	self.Close = function() setOpen(false) end
	self.Row = row
	self.Destroy = function()
		setOpen(false)
		if popup and popup.Parent then popup:Destroy() end
		if guard and guard.Parent then guard:Destroy() end
		if row and row.Parent then row:Destroy() end
	end
	return self
end
	local panel = nil
	local panelScale = nil
	local panelOpen = false
	local syncPanelPosition = nil
	local setPanel = nil
	local modal = nil
	local closeModal = nil
	local dragConn
	do
		local dragging = false
		local dragStart, startPos
		local dragScaleX, dragScaleY = 0.5, 0.5
		local targetX, targetY, displayX, displayY
		local DRAG_SMOOTH = opts.DragSmooth or 14
		Header.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then
				dragging = true
				dragStart = input.Position
				startPos = Main.Position
				dragScaleX, dragScaleY = startPos.X.Scale, startPos.Y.Scale
				targetX, targetY = startPos.X.Offset, startPos.Y.Offset
				displayX, displayY = targetX, targetY
			end
		end)
		Connect(UserInputService.InputChanged, function(input)
			if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
				or input.UserInputType == Enum.UserInputType.Touch) then
				local delta = input.Position - dragStart
				targetX = startPos.X.Offset + delta.X
				targetY = startPos.Y.Offset + delta.Y
			end
		end)
		Connect(UserInputService.InputEnded, function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then
				dragging = false
			end
		end)
		dragConn = Connect(RunService.RenderStepped, function(dt)
			if displayX == nil then return end
			local dx = targetX - displayX
			local dy = targetY - displayY
			if not dragging and math.abs(dx) < 0.5 and math.abs(dy) < 0.5 then
				Main.Position = UDim2.new(dragScaleX, targetX, dragScaleY, targetY)
				uiHomePos = Main.Position
				displayX = nil
				if syncPanelPosition then syncPanelPosition() end
				return
			end
			local step = math.min(1, dt * DRAG_SMOOTH)
			displayX += dx * step
			displayY += dy * step
			Main.Position = UDim2.new(dragScaleX, displayX, dragScaleY, displayY)
			uiHomePos = Main.Position
			if syncPanelPosition then syncPanelPosition() end
		end)
	end
	local SidebarFX = New("Frame", {
		Name = "SidebarFX",
		Position = UDim2.new(0, 0, 0, HEADER_H),
		Size = UDim2.new(0, 160, 1, -HEADER_H),
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		Parent = Main,
	})
	local Indicator = New("Frame", {
		Name = "TabIndicator",
		Size = UDim2.new(0, 3, 0, 16),
		Position = UDim2.new(0, 13, 0, 0),
		BackgroundColor3 = Theme.Text,
		BorderSizePixel = 0,
		Visible = false,
		ZIndex = 5,
		Parent = SidebarFX,
	})
	Corner(Indicator, 2)
	local NotifyHolder = New("Frame", {
		Name = "Notifications",
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(1, 1),
		Position = UDim2.new(1, -16, 1, -16),
		Size = UDim2.new(0, 262, 1, -32),
		Parent = Gui,
	})
	local NotifyLayout = New("UIListLayout", {
		Padding = UDim.new(0, 8),
		SortOrder = Enum.SortOrder.LayoutOrder,
		VerticalAlignment = Enum.VerticalAlignment.Bottom,
		HorizontalAlignment = Enum.HorizontalAlignment.Right,
		Parent = NotifyHolder,
	})
	local Window = {}
	local sidebarOrder = 0
	local tabs = {}
	local keybinds = {}
	local modules = {}
	local rebinding = nil
	local currentTab = nil
	local uiVisible = false
	local indicatorConn = nil
	local destroyed = false
	local smoothSliders = {}
	local SMOOTH_SPEED = 12
	local notifyLocation = opts.NotifyLocation or "Corner Right"
	local notifyDirection = 24
	local heartbeatConn = Connect(RunService.Heartbeat, function(dt)
		local step = math.min(1, dt * SMOOTH_SPEED)
		for slider in pairs(smoothSliders) do
			local diff = slider.Target - slider.Display
			if math.abs(diff) < 0.0005 then
				slider.Display = slider.Target
				slider.Render()
				if not slider.Dragging then
					smoothSliders[slider] = nil
				end
			else
				slider.Display = slider.Display + diff * step
				slider.Render()
			end
		end
	end)
	local function setVisible(visible, instant)
		uiVisible = visible
		if instant then
			Main.Visible = visible
			Main.GroupTransparency = visible and 0 or 1
			uiScale.Scale = visible and 1 or 0.96
			Main.Position = uiHomePos
			if panel then
				panel.Visible = visible and panelOpen
				panel.GroupTransparency = visible and 0 or 1
				panelScale.Scale = visible and 1 or 0.96
				if visible and panelOpen and syncPanelPosition then syncPanelPosition() end
			end
			return
		end
		if visible then
			Main.Visible = true
			Main.GroupTransparency = 1
			Main.Position = UDim2.new(
				uiHomePos.X.Scale,
				uiHomePos.X.Offset + 18,
				uiHomePos.Y.Scale,
				uiHomePos.Y.Offset + 10)
			Tween(Main, TWEEN_OPEN, {
				GroupTransparency = 0,
				Position = uiHomePos,
			})
			Tween(uiScale, TWEEN_OPEN, { Scale = 1 })
			if panel and panelOpen then
				panel.Visible = true
				if syncPanelPosition then syncPanelPosition() end
				panel.GroupTransparency = 1
				Tween(panel, TWEEN_OPEN, { GroupTransparency = 0 })
				Tween(panelScale, TWEEN_OPEN, { Scale = 1 })
				task.delay(TWEEN_OPEN.Time, function()
					if uiVisible and syncPanelPosition then syncPanelPosition() end
				end)
			end
		else
			Tween(Main, TWEEN_MED, { GroupTransparency = 1 })
			Tween(uiScale, TWEEN_MED, { Scale = 0.96 })
			if panel and panel.Visible then
				Tween(panel, TWEEN_MED, { GroupTransparency = 1 })
				Tween(panelScale, TWEEN_MED, { Scale = 0.96 })
				task.delay(0.24, function()
					if not uiVisible and panel then panel.Visible = false end
				end)
			end
			task.delay(0.24, function()
				if not uiVisible then Main.Visible = false end
			end)
		end
	end
	local function SetNotifyLocation(name)
		local known = false
		for _, loc in ipairs(NOTIFY_LOCATIONS) do
			if loc == name then known = true break end
		end
		if not known then name = "Corner Right" end
		notifyLocation = name
		local right = name:match("Right") ~= nil
		notifyDirection = right and 24 or -24
		local ax = right and 1 or 0
		local alignH = right and Enum.HorizontalAlignment.Right or Enum.HorizontalAlignment.Left
		local alignV, ay, pos
		if name:match("^Top") then
			alignV, ay = Enum.VerticalAlignment.Top, 0
			pos = UDim2.new(ax, right and -16 or 16, 0, HEADER_H + 10)
			NotifyHolder.Size = UDim2.new(0, 262, 1, -(HEADER_H + 20))
		elseif name:match("^Middle") then
			alignV, ay = Enum.VerticalAlignment.Center, 0.5
			pos = UDim2.new(ax, right and -16 or 16, 0.5, 0)
			NotifyHolder.Size = UDim2.new(0, 262, 0.9, 0)
		else
			alignV, ay = Enum.VerticalAlignment.Bottom, 1
			pos = UDim2.new(ax, right and -16 or 16, 1, -16)
			NotifyHolder.Size = UDim2.new(0, 262, 1, -32)
		end
		NotifyHolder.AnchorPoint = Vector2.new(ax, ay)
		NotifyHolder.Position = pos
		NotifyLayout.HorizontalAlignment = alignH
		NotifyLayout.VerticalAlignment = alignV
	end
	Window.NotifyLocations = NOTIFY_LOCATIONS
	function Window:GetNotifyLocation() return notifyLocation end
	function Window:SetNotifyLocation(name) SetNotifyLocation(name) end
	function Window:Notify(n)
		n = n or {}
		local duration = tonumber(n.Duration) or NOTIFY_DURATION
		local dir = notifyDirection
		local toast = New("CanvasGroup", {
			Name = "Toast",
			Size = UDim2.new(1, 0, 0, 52),
			Position = UDim2.fromOffset(dir, 0),
			BackgroundColor3 = Theme.Group,
			BackgroundTransparency = Theme.NotifyTransparency,
			GroupTransparency = 1,
			BorderSizePixel = 0,
			Parent = NotifyHolder,
		})
		Corner(toast, 10)
		Stroke(toast, Theme.GroupStroke, 0.2)
		local iconKey = n.Icon
		if iconKey == nil then
			iconKey = (n.Kind == "error" or n.State == false) and "x" or "check"
		end
		local icon = MakeIcon(toast, iconKey, 24, n.IconColor or Theme.Text)
		icon.AnchorPoint = Vector2.new(0, 0.5)
		icon.Position = UDim2.new(0, 14, 0.5, 0)
		icon.ZIndex = 2
		local textCol = New("Frame", {
			Name = "TextColumn",
			Position = UDim2.new(0, 48, 0, 0),
			Size = UDim2.new(1, -60, 1, 0),
			BackgroundTransparency = 1,
			Parent = toast,
		})
		New("TextLabel", {
			Name = "NotifyTitle",
			Position = UDim2.new(0, 0, 0, 11),
			Size = UDim2.new(1, 0, 0, 15),
			BackgroundTransparency = 1,
			Text = n.Title or "Hyperion",
			Font = Enum.Font.GothamBold,
			TextSize = 13,
			TextColor3 = Theme.Text,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextTruncate = Enum.TextTruncate.AtEnd,
			ZIndex = 2,
			Parent = textCol,
		})
		New("TextLabel", {
			Name = "NotifyBody",
			Position = UDim2.new(0, 0, 0, 27),
			Size = UDim2.new(1, 0, 0, 14),
			BackgroundTransparency = 1,
			Text = n.Text or "",
			FontFace = FONT_SEMIBOLD,
			TextSize = 12,
			TextColor3 = Theme.TextDim,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			ZIndex = 2,
			Parent = textCol,
		})
		local cdTrack = New("Frame", {
			Name = "CountdownTrack",
			Position = UDim2.new(0, 12, 1, -7),
			Size = UDim2.new(1, -24, 0, 2),
			BackgroundColor3 = Theme.Divider,
			BackgroundTransparency = 0.4,
			BorderSizePixel = 0,
			ZIndex = 3,
			Parent = toast,
		})
		Corner(cdTrack, 1)
		local cdFill = New("Frame", {
			Name = "Countdown",
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, 0, 0.5, 0),
			Size = UDim2.fromScale(0, 1),
			BackgroundColor3 = Theme.Text,
			BackgroundTransparency = 0.25,
			BorderSizePixel = 0,
			ZIndex = 4,
			Parent = cdTrack,
		})
		Corner(cdFill, 1)
		Tween(toast, TWEEN_NOTIFY_IN, { GroupTransparency = 0, Position = UDim2.fromOffset(0, 0) })
		Tween(cdFill, TweenInfo.new(duration, Enum.EasingStyle.Linear), { Size = UDim2.fromScale(1, 1) })
		task.delay(duration, function()
			if toast and toast.Parent then
				local outTw = TweenService:Create(toast, TWEEN_NOTIFY_OUT, {
					GroupTransparency = 1,
					Position = UDim2.fromOffset(dir, 0),
				})
				outTw.Completed:Once(function()
					if toast and toast.Parent then toast:Destroy() end
				end)
				outTw:Play()
			end
		end)
		return toast
	end
	local function AttachKeybind(chip, entry, keyCode)
		local function refresh()
			chip.Text = KeybindText(entry.Keybind)
			Tween(chip, TWEEN_FAST, {
				TextColor3 = entry.Keybind and Theme.TextSoft or Theme.TextDim,
			})
		end
		function entry:RefreshChip()
			refresh()
		end
		function entry:Bind(newKey)
			entry.Keybind = newKey
			if entry.OnBind then entry.OnBind(newKey) end
			refresh()
		end
		function entry:BeginRebind()
			chip.Text = "[...]"
			Tween(chip, TWEEN_FAST, {
				BackgroundColor3 = Theme.TextSoft,
				BackgroundTransparency = 0,
				TextColor3 = Theme.Background,
			})
		end
		function entry:EndRebind()
			Tween(chip, TWEEN_FAST, { BackgroundTransparency = 1 })
			refresh()
		end
		chip.MouseButton1Click:Connect(function()
			if rebinding then return end
			rebinding = { Entry = entry }
			entry:BeginRebind()
		end)
		entry:Bind(keyCode)
		table.insert(keybinds, entry)
		return entry
	end
	local function BuildToggle(parent, order, o)
		local state = o.Default == true
		local keyCode = nil
		if o.Keybind and Enum.KeyCode[o.Keybind] then
			keyCode = Enum.KeyCode[o.Keybind]
		end
		local row = New("Frame", {
			Name = "Toggle_" .. o.Name,
			LayoutOrder = order,
			Size = UDim2.new(1, 0, 0, 26),
			BackgroundTransparency = 1,
			Parent = parent,
		})
		local click = New("TextButton", {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			Text = "",
			AutoButtonColor = false,
			Parent = row,
		})
		New("TextLabel", {
			Size = UDim2.new(1, -96, 1, 0),
			BackgroundTransparency = 1,
			Text = o.Name,
			FontFace = FONT_SEMIBOLD,
			TextSize = 15,
			TextColor3 = Theme.Text,
			TextXAlignment = Enum.TextXAlignment.Left,
			Parent = click,
		})
		local pill = New("Frame", {
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, 0, 0.5, 0),
			Size = UDim2.fromOffset(30, 17),
			BackgroundColor3 = state and Theme.PillOn or Theme.PillOff,
			BorderSizePixel = 0,
			Parent = click,
		})
		Corner(pill, 9)
		local knob = New("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = state and UDim2.new(1, -8, 0.5, 0) or UDim2.new(0, 8, 0.5, 0),
			Size = UDim2.fromOffset(12, 12),
			BackgroundColor3 = state and Theme.KnobOn or Theme.KnobOff,
			BorderSizePixel = 0,
			Parent = pill,
		})
		Corner(knob, 6)
		local entry = { Keybind = nil, Kind = "Toggle" }
		local function apply(fire)
			Tween(pill, TWEEN_MED, { BackgroundColor3 = state and Theme.PillOn or Theme.PillOff })
			Tween(knob, TWEEN_TOGGLE, {
				Position = state and UDim2.new(1, -8, 0.5, 0) or UDim2.new(0, 8, 0.5, 0),
				BackgroundColor3 = state and Theme.KnobOn or Theme.KnobOff,
			})
			if fire and o.Callback then
				task.spawn(o.Callback, state)
			end
		end
		function entry:Get() return state end
		function entry:Set(v, fire)
			state = v == true
			apply(fire ~= false)
		end
		click.MouseButton1Click:Connect(function()
			entry:Set(not entry:Get())
		end)
		local chip = New("TextButton", {
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, -44, 0.5, 0),
			Size = UDim2.new(0, 0, 0, 20),
			AutomaticSize = Enum.AutomaticSize.X,
			BackgroundTransparency = 1,
			BackgroundColor3 = Theme.TextSoft,
			Text = KeybindText(keyCode),
			FontFace = FONT_SEMIBOLD,
			TextSize = 13,
			TextColor3 = Theme.TextDim,
			AutoButtonColor = false,
			BorderSizePixel = 0,
			Parent = row,
		})
		Corner(chip, 5)
		Pad(chip, 0, 0, 5, 5)
		return AttachKeybind(chip, entry, keyCode)
	end
	local function BuildSlider(parent, order, o)
		local min = o.Min or 0
		local max = o.Max or 100
		local decimals = o.Decimals or 0
		local value = math.clamp(round(o.Default or min, decimals), min, max)
		local startAlpha = (value - min) / (max - min)
		local box = New("Frame", {
			Name = "Slider_" .. o.Name,
			LayoutOrder = order,
			Size = UDim2.new(1, 0, 0, 42),
			BackgroundTransparency = 1,
			Parent = parent,
		})
		New("TextLabel", {
			Size = UDim2.new(1, -40, 0, 15),
			BackgroundTransparency = 1,
			Text = o.Name,
			FontFace = FONT_SEMIBOLD,
			TextSize = 15,
			TextColor3 = Theme.TextSoft,
			TextXAlignment = Enum.TextXAlignment.Left,
			Parent = box,
		})
		local valueLabel = New("TextLabel", {
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.new(1, 0, 0, 0),
			Size = UDim2.new(0, 0, 0, 14),
			AutomaticSize = Enum.AutomaticSize.X,
			BackgroundTransparency = 1,
			Text = tostring(value),
			FontFace = FONT_SEMIBOLD,
			TextSize = 14,
			TextColor3 = Theme.Text,
			TextXAlignment = Enum.TextXAlignment.Right,
			Parent = box,
		})
		local hitbox = New("TextButton", {
			AnchorPoint = Vector2.new(0, 1),
			Position = UDim2.new(0, 0, 1, -2),
			Size = UDim2.new(1, 0, 0, 20),
			BackgroundTransparency = 1,
			Text = "",
			AutoButtonColor = false,
			Parent = box,
		})
		local track = New("Frame", {
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, 0, 0.5, 0),
			Size = UDim2.new(1, 0, 0, 6),
			BackgroundColor3 = Theme.SliderTrack,
			BorderSizePixel = 0,
			Parent = hitbox,
		})
		Corner(track, 3)
		local fill = New("Frame", {
			Size = UDim2.new(startAlpha, 0, 1, 0),
			BackgroundColor3 = Theme.SliderFill,
			BorderSizePixel = 0,
			Parent = track,
		})
		Corner(fill, 3)
		local knob = New("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(startAlpha, 0, 0.5, 0),
			Size = UDim2.fromOffset(14, 14),
			BackgroundColor3 = Theme.SliderFill,
			BorderSizePixel = 0,
			Parent = track,
		})
		Corner(knob, 8)
		local slider = {
			Kind = "Slider",
			Display = startAlpha,
			Target = startAlpha,
			Dragging = false,
			Fire = false,
			LastValue = value,
		}
		function slider.Render()
			local a = slider.Display
			fill.Size = UDim2.new(a, 0, 1, 0)
			knob.Position = UDim2.new(a, 0, 0.5, 0)
			local newValue = round(min + (max - min) * a, decimals)
			if newValue ~= slider.LastValue then
				slider.LastValue = newValue
				value = newValue
				valueLabel.Text = tostring(newValue)
				if slider.Fire and o.Callback then
					task.spawn(o.Callback, newValue)
				end
			end
		end
		local function knobSize(px)
			Tween(knob, TWEEN_FAST, { Size = UDim2.fromOffset(px, px) })
		end
		local function setTargetFromX(x)
			local rel = math.clamp((x - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
			local snapped = round(min + (max - min) * rel, decimals)
			slider.Target = (snapped - min) / (max - min)
			smoothSliders[slider] = true
		end
		local function startDrag(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then
				slider.Dragging = true
				slider.Fire = true
				knobSize(17)
				setTargetFromX(input.Position.X)
			end
		end
		hitbox.MouseButton1Down:Connect(function() end)
		hitbox.InputBegan:Connect(startDrag)
		knob.InputBegan:Connect(startDrag)
		track.InputBegan:Connect(startDrag)
		Connect(UserInputService.InputChanged, function(input)
			if slider.Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
				or input.UserInputType == Enum.UserInputType.Touch) then
				setTargetFromX(input.Position.X)
			end
		end)
		Connect(UserInputService.InputEnded, function(input)
			if slider.Dragging and (input.UserInputType == Enum.UserInputType.MouseButton1
				or input.UserInputType == Enum.UserInputType.Touch) then
				slider.Dragging = false
				knobSize(14)
			end
		end)
		hitbox.MouseEnter:Connect(function()
			if not slider.Dragging then knobSize(16) end
		end)
		hitbox.MouseLeave:Connect(function()
			if not slider.Dragging then knobSize(14) end
		end)
		slider.Get = function() return value end
		slider.Set = function(_, v)
			local snapped = math.clamp(round(tonumber(v) or min, decimals), min, max)
			slider.Target = (snapped - min) / (max - min)
			slider.Fire = true
			smoothSliders[slider] = true
		end
		return slider
	end
	local function BuildDropdown(parent, order, o)
		local options = o.Options or {}
		local value = o.Default or options[1]
		local HEADER_H = 26
		local ROW_H = 23
		local box = New("Frame", {
			Name = "Dropdown_" .. o.Name,
			LayoutOrder = order,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			Parent = parent,
		})
		New("UIListLayout", { Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder, Parent = box })
		New("TextLabel", {
			LayoutOrder = 1,
			Size = UDim2.new(1, 0, 0, 14),
			BackgroundTransparency = 1,
			Text = o.Name,
			FontFace = FONT_SEMIBOLD,
			TextSize = 15,
			TextColor3 = Theme.TextSoft,
			TextXAlignment = Enum.TextXAlignment.Left,
			Parent = box,
		})
		local holder = New("Frame", {
			LayoutOrder = 2,
			Size = UDim2.new(1, 0, 0, HEADER_H),
			BackgroundColor3 = Theme.Control,
			ClipsDescendants = true,
			BorderSizePixel = 0,
			Parent = box,
		})
		Corner(holder, 7)
		local header = New("TextButton", {
			Size = UDim2.new(1, 0, 0, HEADER_H),
			BackgroundTransparency = 1,
			Text = "",
			AutoButtonColor = false,
			Parent = holder,
		})
		local valueText = New("TextLabel", {
			Position = UDim2.new(0, 10, 0, 0),
			Size = UDim2.new(1, -36, 1, 0),
			BackgroundTransparency = 1,
			Text = tostring(value),
			FontFace = FONT_SEMIBOLD,
			TextSize = 14,
			TextColor3 = Theme.TextSoft,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextTruncate = Enum.TextTruncate.AtEnd,
			Parent = header,
		})
		local chev = MakeIcon(header, "chevrons-up-down", 14, Theme.TextDim)
		chev.AnchorPoint = Vector2.new(1, 0.5)
		chev.Position = UDim2.new(1, -8, 0.5, 0)
		local optionsFrame = New("Frame", {
			Position = UDim2.new(0, 0, 0, HEADER_H),
			Size = UDim2.new(1, 0, 0, #options * ROW_H),
			BackgroundTransparency = 1,
			Parent = holder,
		})
		local optionsLayout = New("UIListLayout", {
			Padding = UDim.new(0, 0),
			SortOrder = Enum.SortOrder.LayoutOrder,
			Parent = optionsFrame,
		})
		local open = false
		local animating = false
		local setOpen
		local function bindRow(rowBtn, lbl, opt)
			rowBtn.MouseEnter:Connect(function()
				Tween(lbl, TWEEN_FAST, { TextColor3 = Theme.Text })
			end)
			rowBtn.MouseLeave:Connect(function()
				Tween(lbl, TWEEN_FAST, { TextColor3 = Theme.TextDim })
			end)
			rowBtn.MouseButton1Click:Connect(function()
				value = tostring(opt)
				valueText.Text = value
				setOpen(false)
				if o.Callback then task.spawn(o.Callback, value) end
			end)
		end
		local function buildRows()
			for _, ch in ipairs(optionsFrame:GetChildren()) do
				if ch:IsA("TextButton") then
					ch:Destroy()
				end
			end
			for i, opt in ipairs(options) do
				local rowBtn = New("TextButton", {
					LayoutOrder = i,
					Size = UDim2.new(1, 0, 0, ROW_H),
					BackgroundTransparency = 1,
					Text = "",
					AutoButtonColor = false,
					Parent = optionsFrame,
				})
				local lbl = New("TextLabel", {
					Position = UDim2.new(0, 10, 0, 0),
					Size = UDim2.new(1, -20, 1, 0),
					BackgroundTransparency = 1,
					Text = tostring(opt),
					FontFace = FONT_SEMIBOLD,
					TextSize = 13,
					TextColor3 = Theme.TextDim,
					TextXAlignment = Enum.TextXAlignment.Left,
					Parent = rowBtn,
				})
				bindRow(rowBtn, lbl, opt)
			end
			optionsFrame.Size = UDim2.new(1, 0, 0, #options * ROW_H)
			holder.Size = UDim2.new(1, 0, 0, HEADER_H + (open and (#options * ROW_H) or 0))
		end
		buildRows()
		setOpen = function(state)
			if animating or state == open then return end
			open = state
			animating = true
			Tween(chev, TWEEN_MED, { Rotation = open and 180 or 0 })
			local target = HEADER_H + (open and (#options * ROW_H) or 0)
			local tw = TweenService:Create(holder, open and TWEEN_MED or TWEEN_FAST,
				{ Size = UDim2.new(1, 0, 0, target) })
			tw.Completed:Once(function() animating = false end)
			tw:Play()
		end
		header.MouseButton1Click:Connect(function()
			setOpen(not open)
		end)
		header.MouseEnter:Connect(function()
			Tween(valueText, TWEEN_FAST, { TextColor3 = Theme.Text })
		end)
		header.MouseLeave:Connect(function()
			Tween(valueText, TWEEN_FAST, { TextColor3 = Theme.TextSoft })
		end)
		local self = { Kind = "Dropdown" }
		self.Get = function() return value end
		self.Set = function(_, v)
			value = tostring(v)
			valueText.Text = value
			if o.Callback then task.spawn(o.Callback, value) end
		end
		self.SetSilent = function(_, v)
			value = tostring(v)
			valueText.Text = value
		end
		self.SetOptions = function(_, list, keep)
			options = {}
			for _, v in ipairs(list or {}) do options[#options + 1] = v end
			local stillValid = false
			for _, v in ipairs(options) do
				if tostring(v) == value then stillValid = true break end
			end
			if not stillValid and #options > 0 then
				value = tostring(options[1])
				valueText.Text = value
			elseif #options == 0 then
				value = ""
				valueText.Text = ""
			end
			buildRows()
		end
		self.OptionCount = function() return #options end
		return self
	end
	local function BuildInput(parent, order, o)
		o = o or {}
		local value = o.Default or ""
		local box = New("Frame", {
			Name = "Input_" .. tostring(o.Name or "Input"),
			LayoutOrder = order,
			Size = UDim2.new(1, 0, 0, 42),
			BackgroundTransparency = 1,
			Parent = parent,
		})
		New("TextLabel", {
			Size = UDim2.new(1, 0, 0, 14),
			BackgroundTransparency = 1,
			Text = o.Name or "Input",
			FontFace = FONT_SEMIBOLD,
			TextSize = 15,
			TextColor3 = Theme.TextSoft,
			TextXAlignment = Enum.TextXAlignment.Left,
			Parent = box,
		})
		local field = New("TextBox", {
			Position = UDim2.new(0, 0, 0, 18),
			Size = UDim2.new(1, 0, 0, 24),
			BackgroundColor3 = Theme.Control,
			Text = value,
			ClearTextOnFocus = false,
			PlaceholderText = o.Placeholder or "",
			FontFace = FONT_SEMIBOLD,
			TextSize = 14,
			TextColor3 = Theme.Text,
			TextXAlignment = Enum.TextXAlignment.Left,
			BorderSizePixel = 0,
			Parent = box,
		})
		Corner(field, 7)
		Pad(field, 0, 0, 10, 10)
		field.FocusLost:Connect(function(enterPressed)
			value = field.Text
			if enterPressed or value ~= "" then
				if o.Callback then task.spawn(o.Callback, value) end
			end
		end)
		local self = { Kind = "Input" }
		self.Get = function() return value end
		self.Set = function(_, v, fire)
			value = tostring(v or "")
			field.Text = value
			if fire ~= false and o.Callback then task.spawn(o.Callback, value) end
		end
		self.SetValue = function(_, v, fire) self:Set(v, fire) end
		self.Object = field
		return self
	end
	local function BuildKeybindRow(parent, order, o)
		o = o or {}
		local keyCode = nil
		if o.Keybind and Enum.KeyCode[o.Keybind] then
			keyCode = Enum.KeyCode[o.Keybind]
		elseif typeof(o.Default) == "EnumItem" then
			keyCode = o.Default
		end
		local row = New("Frame", {
			Name = "Keybind_" .. tostring(o.Name or "Keybind"),
			LayoutOrder = order,
			Size = UDim2.new(1, 0, 0, 26),
			BackgroundTransparency = 1,
			Parent = parent,
		})
		New("TextLabel", {
			Size = UDim2.new(1, -58, 1, 0),
			BackgroundTransparency = 1,
			Text = o.Name or "Keybind",
			FontFace = FONT_SEMIBOLD,
			TextSize = 15,
			TextColor3 = Theme.TextSoft,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextTruncate = Enum.TextTruncate.AtEnd,
			Parent = row,
		})
		local chip = New("TextButton", {
			Name = "Keybind",
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, 0, 0.5, 0),
			Size = UDim2.new(0, 0, 0, 20),
			AutomaticSize = Enum.AutomaticSize.X,
			BackgroundTransparency = 1,
			BackgroundColor3 = Theme.TextSoft,
			Text = KeybindText(keyCode),
			FontFace = FONT_SEMIBOLD,
			TextSize = 13,
			TextColor3 = Theme.TextDim,
			AutoButtonColor = false,
			BorderSizePixel = 0,
			Parent = row,
		})
		Corner(chip, 5)
		Pad(chip, 0, 0, 5, 5)
		local entry = { Keybind = nil, Kind = "Keybind" }
		function entry:Get() return true end
		function entry:Set()
			if o.Callback then task.spawn(o.Callback) end
		end
		AttachKeybind(chip, entry, keyCode)
		entry.Row = row
		return entry
	end
	local function BuildButton(parent, order, o)
		local btn = New("TextButton", {
			Name = "Button_" .. o.Name,
			LayoutOrder = order,
			Size = UDim2.new(1, 0, 0, 26),
			BackgroundColor3 = Theme.Control,
			Text = o.Name,
			FontFace = FONT_SEMIBOLD,
			TextSize = 14,
			TextColor3 = Theme.TextSoft,
			AutoButtonColor = false,
			BorderSizePixel = 0,
			Parent = parent,
		})
		Corner(btn, 7)
		btn.MouseEnter:Connect(function() Tween(btn, TWEEN_FAST, { BackgroundColor3 = Theme.ControlHover }) end)
		btn.MouseLeave:Connect(function() Tween(btn, TWEEN_FAST, { BackgroundColor3 = Theme.Control }) end)
		btn.MouseButton1Down:Connect(function() Tween(btn, TWEEN_FAST, { TextColor3 = Theme.Text }) end)
		btn.MouseButton1Up:Connect(function() Tween(btn, TWEEN_FAST, { TextColor3 = Theme.TextSoft }) end)
		btn.MouseButton1Click:Connect(function()
			if o.Callback then task.spawn(o.Callback) end
		end)
		return btn
	end
	local function BuildLabel(parent, order, o)
		return New("TextLabel", {
			Name = "Label",
			LayoutOrder = order,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			Text = o.Text or "",
			FontFace = FONT_SEMIBOLD,
			TextSize = 13,
			TextColor3 = o.Color or Theme.TextDim,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			Parent = parent,
		})
	end
	local CARD_H   = 76
	local BOTTOM_Y = 42
	local BOTTOM_H = 26
	local CARD_GAP = 10
	local function CreateModule(o, columnFrame, order)
		o = o or {}
		local Module = { Name = o.Name or "Module" }
		local state = o.Default == true
		local notifyOn = o.Notifications ~= false
		local manualOpen = false
		local controlCount = 0
		local resizeHooks = {}
		local settings = {}
		local card = New("Frame", {
			Name = "Module_" .. Module.Name,
			LayoutOrder = order or 1000,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundColor3 = Theme.Group,
			BackgroundTransparency = Theme.CardTransparency,
			BorderSizePixel = 0,
			Parent = columnFrame,
		})
		Corner(card, 11)
		Stroke(card, Theme.GroupStroke, 0.3)
		New("UIListLayout", {
			Padding = UDim.new(0, 0),
			SortOrder = Enum.SortOrder.LayoutOrder,
			Parent = card,
		})
		local head = New("Frame", {
			Name = "Head",
			LayoutOrder = 1,
			Size = UDim2.new(1, 0, 0, CARD_H),
			BackgroundTransparency = 1,
			Parent = card,
		})
		New("TextLabel", {
			Name = "ModuleName",
			Position = UDim2.new(0, 14, 0, 12),
			Size = UDim2.new(1, -104, 0, 18),
			BackgroundTransparency = 1,
			Text = Module.Name,
			FontFace = FONT_BOLD,
			TextSize = 15,
			TextColor3 = Theme.Text,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextTruncate = Enum.TextTruncate.AtEnd,
			Parent = head,
		})
		local bellBtn = IconButton(head, 26)
		bellBtn.Name = "Bell"
		bellBtn.AnchorPoint = Vector2.new(1, 0)
		bellBtn.Position = UDim2.new(1, -12, 0, 8)
		local bellIcon = MakeIcon(bellBtn, "bell", 16, Theme.Text)
		bellIcon.AnchorPoint = Vector2.new(0.5, 0.5)
		bellIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
		local function refreshBell()
			local asset = LucideIcons[notifyOn and "bell" or "bell-off"]
			if asset then bellIcon.Image = asset end
			Tween(bellIcon, TWEEN_FAST, {
				ImageColor3 = notifyOn and Theme.Text or Theme.TextDim,
			})
		end
		bellBtn.MouseButton1Click:Connect(function()
			notifyOn = not notifyOn
			refreshBell()
		end)
		refreshBell()
		local bottom = New("Frame", {
			Name = "Controls",
			Position = UDim2.new(0, 0, 0, BOTTOM_Y),
			Size = UDim2.new(1, 0, 0, BOTTOM_H),
			BackgroundTransparency = 1,
			Parent = head,
		})
		local cfgBtn = IconButton(bottom, 28, 6)
		cfgBtn.Name = "Configure"
		cfgBtn.AnchorPoint = Vector2.new(0, 0.5)
		cfgBtn.Position = UDim2.new(0, 10, 0.5, 0)
		local cfgIcon = MakeIcon(cfgBtn, "menu", 16, Theme.TextDim)
		cfgIcon.AnchorPoint = Vector2.new(0.5, 0.5)
		cfgIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
		local switchBtn = New("TextButton", {
			Name = "Toggle",
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, -12, 0.5, 0),
			Size = UDim2.fromOffset(72, BOTTOM_H),
			BackgroundTransparency = 1,
			Text = "",
			AutoButtonColor = false,
			BorderSizePixel = 0,
			Parent = bottom,
		})
		local pill = New("Frame", {
			Name = "Pill",
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, 0, 0.5, 0),
			Size = UDim2.fromOffset(30, 17),
			BackgroundColor3 = state and Theme.PillOn or Theme.PillOff,
			BorderSizePixel = 0,
			Parent = switchBtn,
		})
		Corner(pill, 9)
		local knob = New("Frame", {
			Name = "Knob",
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = state and UDim2.new(1, -8, 0.5, 0) or UDim2.new(0, 8, 0.5, 0),
			Size = UDim2.fromOffset(12, 12),
			BackgroundColor3 = state and Theme.KnobOn or Theme.KnobOff,
			BorderSizePixel = 0,
			Parent = pill,
		})
		Corner(knob, 6)
		local stateLabel = New("TextLabel", {
			Name = "StateLabel",
			Position = UDim2.new(0, 0, 0, 0),
			Size = UDim2.new(1, -38, 1, 0),
			BackgroundTransparency = 1,
			Text = state and "ON" or "OFF",
			FontFace = FONT_SEMIBOLD,
			TextSize = 12,
			TextColor3 = state and Theme.Text or Theme.TextDim,
			TextXAlignment = Enum.TextXAlignment.Right,
			Parent = switchBtn,
		})
		local chip = New("TextButton", {
			Name = "Keybind",
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, -92, 0.5, 0),
			Size = UDim2.new(0, 0, 0, 20),
			AutomaticSize = Enum.AutomaticSize.X,
			BackgroundTransparency = 1,
			BackgroundColor3 = Theme.TextSoft,
			Text = "[...]",
			FontFace = FONT_SEMIBOLD,
			TextSize = 13,
			TextColor3 = Theme.TextDim,
			AutoButtonColor = false,
			BorderSizePixel = 0,
			Parent = bottom,
		})
		Corner(chip, 5)
		Pad(chip, 0, 0, 5, 5)
		local settingsHolder = New("Frame", {
			Name = "Settings",
			LayoutOrder = 2,
			Size = UDim2.new(1, 0, 0, 0),
			BackgroundTransparency = 1,
			ClipsDescendants = true,
			BorderSizePixel = 0,
			Parent = card,
		})
		local settingsInner = New("Frame", {
			Name = "Inner",
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			Parent = settingsHolder,
		})
		Pad(settingsInner, 2, 12, 14, 14)
		local settingsLayout = New("UIListLayout", {
			Padding = UDim.new(0, 9),
			SortOrder = Enum.SortOrder.LayoutOrder,
			Parent = settingsInner,
		})
		local divider = New("Frame", {
			Name = "SettingsDivider",
			LayoutOrder = 1,
			Size = UDim2.new(1, 0, 0, 12),
			BackgroundTransparency = 1,
			Visible = false,
			Parent = settingsInner,
		})
		New("TextLabel", {
			Position = UDim2.new(0, 0, 0, 0),
			Size = UDim2.new(0, 52, 1, 0),
			BackgroundTransparency = 1,
			Text = "Settings",
			Font = Enum.Font.GothamBold,
			TextSize = 10,
			TextColor3 = Theme.HeaderText,
			TextXAlignment = Enum.TextXAlignment.Left,
			Parent = divider,
		})
		New("Frame", {
			Position = UDim2.new(0, 58, 0, 6),
			Size = UDim2.new(1, -58, 0, 1),
			BackgroundColor3 = Theme.Divider,
			BorderSizePixel = 0,
			Parent = divider,
		})
		local function fireResize()
			for _, fn in ipairs(resizeHooks) do
				task.spawn(fn, CARD_H + settingsHolder.AbsoluteSize.Y + CARD_GAP)
			end
		end
		local animConn = nil
		local function settingsVisible()
			return state == true or manualOpen == true
		end
		local function targetHeight()
			if not settingsVisible() or controlCount <= 0 then return 0 end
			local h = settingsLayout.AbsoluteContentSize.Y
			if h <= 0 then return 0 end
			return h + 14
		end
		local function syncHeight()
			if animConn then return end
			local last = settingsHolder.Size.Y.Offset
			animConn = Connect(RunService.Heartbeat, function(dt)
				local want = targetHeight()
				local diff = want - last
				if math.abs(diff) < 0.5 then
					settingsHolder.Size = UDim2.new(1, 0, 0, want)
					Release(animConn)
					animConn = nil
					fireResize()
					return
				end
				local step = math.min(1, dt * 16)
				last += diff * step
				settingsHolder.Size = UDim2.new(1, 0, 0, last)
			end)
		end
		local function refreshCfgIcon()
			local on = settingsVisible()
			Tween(cfgIcon, TWEEN_MED, {
				Rotation = on and 90 or 0,
				ImageColor3 = on and Theme.Text or Theme.TextDim,
			})
		end
		local function refreshSettings()
			refreshCfgIcon()
			syncHeight()
		end
		local function setOpen(v)
			v = v == true
			if state then
				return
			end
			if v and controlCount <= 0 then return end
			if v == manualOpen then return end
			manualOpen = v
			refreshSettings()
		end
		local function registerControl()
			controlCount += 1
			divider.Visible = controlCount > 0
			if settingsVisible() then syncHeight() end
			task.defer(fireResize)
			return controlCount + 1
		end
		settingsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			if settingsVisible() then syncHeight() end
			fireResize()
		end)
		cfgBtn.MouseButton1Click:Connect(function()
			setOpen(not manualOpen)
		end)
		local entry = { Keybind = nil, Kind = "ModuleToggle" }
		local function sendNotify(n)
			if not notifyOn then return end
			n = n or {}
			local copy = {}
			for k, v in pairs(n) do copy[k] = v end
			if copy.Title == nil then copy.Title = Module.Name end
			return Window:Notify(copy)
		end
		local function applySwitch(fire)
			Tween(pill, TWEEN_MED, { BackgroundColor3 = state and Theme.PillOn or Theme.PillOff })
			Tween(knob, TWEEN_TOGGLE, {
				Position = state and UDim2.new(1, -8, 0.5, 0) or UDim2.new(0, 8, 0.5, 0),
				BackgroundColor3 = state and Theme.KnobOn or Theme.KnobOff,
			})
			stateLabel.Text = state and "ON" or "OFF"
			Tween(stateLabel, TWEEN_FAST, {
				TextColor3 = state and Theme.Text or Theme.TextDim,
			})
			if fire then
				if o.Callback then task.spawn(o.Callback, state) end
				if o.NotifyOnToggle then
					sendNotify({
						Title = Module.Name,
						Text = state and "Enabled" or "Disabled",
						Icon = state and "check" or "x",
						IconColor = state and Theme.Text or Theme.TextDim,
					})
				end
			end
		end
		local function setModuleState(v, fire)
			local newState = v == true
			if newState == state then
				return
			end
			state = newState
			manualOpen = false
			applySwitch(fire ~= false)
			refreshSettings()
		end
		function entry:Get() return state end
		function entry:Set(v, fire)
			setModuleState(v, fire)
		end
		switchBtn.MouseButton1Click:Connect(function()
			entry:Set(not entry:Get())
		end)
		local function track(kind, name, obj)
			settings[#settings + 1] = { Kind = kind, Name = name, Obj = obj }
			return obj
		end
		local function gateSetting(sub)
			if type(sub) ~= "table" or type(sub.Callback) ~= "function" then return sub end
			local wrapped = {}
			for k, v in pairs(sub) do wrapped[k] = v end
			local fn = sub.Callback
			wrapped.Callback = function(...)
				if not state then return end
				return fn(...)
			end
			return wrapped
		end
		function Module:AddToggle(sub)
			sub = gateSetting(sub)
			return track("Toggle", sub and sub.Name, BuildToggle(settingsInner, registerControl(), sub))
		end
		function Module:AddSlider(sub)
			sub = gateSetting(sub)
			return track("Slider", sub and sub.Name, BuildSlider(settingsInner, registerControl(), sub))
		end
		function Module:AddDropdown(sub)
			sub = gateSetting(sub)
			return track("Dropdown", sub and sub.Name, BuildDropdown(settingsInner, registerControl(), sub))
		end
		function Module:AddColorPick(sub)
			sub = gateSetting(sub)
			return track("Color", sub and sub.Name, ColorPreview(settingsInner, registerControl(), sub))
		end
		function Module:AddInput(sub)
			sub = gateSetting(sub)
			return track("Input", sub and sub.Name, BuildInput(settingsInner, registerControl(), sub))
		end
		function Module:AddButton(sub)    return BuildButton(settingsInner, registerControl(), sub) end
		function Module:AddLabel(sub)     return BuildLabel(settingsInner, registerControl(), sub) end
		function Module:AddKeybind(sub)
			sub = gateSetting(sub)
			return track("Keybind", sub and sub.Name, BuildKeybindRow(settingsInner, registerControl(), sub))
		end
		Module.CreateToggle = function(_, sub) return Module:AddToggle(sub) end
		Module.CreateSlider = function(_, sub) return Module:AddSlider(sub) end
		Module.CreateDropdown = function(_, sub) return Module:AddDropdown(sub) end
		Module.CreateButton = function(_, sub) return Module:AddButton(sub) end
		Module.CreateLabel = function(_, sub) return Module:AddLabel(sub) end
		Module.CreateInput = function(_, sub) return Module:AddInput(sub) end
		Module.CreateKeybind = function(_, sub) return Module:AddKeybind(sub) end
		Module.CreateColorPick = function(_, sub) return Module:AddColorPick(sub) end
		Module.CreateSection = function(_, name)
			local Section = { Name = type(name) == "table" and (name.Name or name.Title) or name }
			Section.AddToggle = function(_, sub) return Module:AddToggle(sub) end
			Section.AddSlider = function(_, sub) return Module:AddSlider(sub) end
			Section.AddDropdown = function(_, sub) return Module:AddDropdown(sub) end
			Section.AddButton = function(_, sub) return Module:AddButton(sub) end
			Section.AddLabel = function(_, sub) return Module:AddLabel(sub) end
			Section.AddInput = function(_, sub) return Module:AddInput(sub) end
			Section.AddColorPick = function(_, sub) return Module:AddColorPick(sub) end
			Section.AddKeybind = function(_, sub) return Module:AddKeybind(sub) end
			Section.CreateToggle = Section.AddToggle
			Section.CreateSlider = Section.AddSlider
			Section.CreateDropdown = Section.AddDropdown
			Section.CreateButton = Section.AddButton
			Section.CreateLabel = Section.AddLabel
			Section.CreateInput = Section.AddInput
			Section.CreateColorPick = Section.AddColorPick
			Section.CreateKeybind = Section.AddKeybind
			Section.AddGroupbox = function(_, sub) return Module:AddToggle(sub) end
			return Section
		end
		Module.AddSection = Module.CreateSection
		Module.AddGroupbox = function(_, sub) return Module:AddToggle(sub) end
		function Module:Get() return state end
		function Module:Set(v, fire)
			setModuleState(v, fire)
		end
		function Module:Toggle()
			setModuleState(not state)
		end
		function Module:Notify(n)
			return sendNotify(n)
		end
		function Module:NotificationsEnabled() return notifyOn end
		function Module:SetNotifications(v)
			notifyOn = v == true
			refreshBell()
		end
		function Module:GetSettings() return settings end
		function Module:FindSetting(name)
			for _, s in ipairs(settings) do
				if s.Name == name then return s.Obj end
			end
			return nil
		end
		function Module:GetConfig()
			local t = {
				Enabled = state,
				Notifications = notifyOn,
				Keybind = entry.Keybind and entry.Keybind.Name or nil,
				Settings = {},
			}
			for _, s in ipairs(settings) do
				if s.Obj and s.Obj.Get and s.Kind ~= "Toggle" and s.Kind ~= "ModuleToggle" then
					if s.Kind == "Keybind" then
						t.Settings[s.Name] = {
							Kind = "Keybind",
							Value = s.Obj.Keybind and s.Obj.Keybind.Name or "",
						}
					else
						local v = s.Obj:Get()
						if s.Kind == "Color" then
							t.Settings[s.Name] = { Kind = "Color", Color = ColorToRgbTable(v) }
						elseif s.Kind == "Slider" then
							t.Settings[s.Name] = { Kind = "Slider", Value = v }
						elseif s.Kind == "Dropdown" then
							t.Settings[s.Name] = { Kind = "Dropdown", Value = v }
						elseif s.Kind == "Input" then
							t.Settings[s.Name] = { Kind = "Input", Value = v }
						end
					end
				end
			end
			return t
		end
		function Module:ApplyConfig(t)
			if type(t) ~= "table" then return end
			if type(t.Settings) == "table" then
				for _, s in ipairs(settings) do
					local saved = t.Settings[s.Name]
					if type(saved) == "table" then
						if s.Kind == "Color" then
							s.Obj:Set(RgbTableToColor(saved.Color, Color3.fromRGB(255, 255, 255)))
						elseif saved.Value ~= nil and s.Obj.Set then
							s.Obj:Set(saved.Value)
						end
					end
				end
			end
			if t.Keybind ~= nil then
				entry:Bind(t.Keybind and Enum.KeyCode[t.Keybind] or nil)
			end
			if t.Notifications ~= nil then
				Module:SetNotifications(t.Notifications == true)
			end
			if t.Enabled ~= nil then
				setModuleState(t.Enabled == true)
			end
		end
		function Module:IsExpanded() return settingsVisible() end
		function Module:IsManuallyOpen() return manualOpen end
		function Module:SetExpanded(v) setOpen(v == true) end
		function Module:IsEnabled() return state end
		function Module:GetCard() return card end
		function Module:GetHeight()
			return CARD_H + settingsHolder.AbsoluteSize.Y + CARD_GAP
		end
		function Module:OnResize(fn)
			table.insert(resizeHooks, fn)
		end
		Module.Entry = entry
		Module.Name = Module.Name
		if o.Keybind and Enum.KeyCode[o.Keybind] then
			entry.Keybind = Enum.KeyCode[o.Keybind]
		end
		AttachKeybind(chip, entry, entry.Keybind)
		table.insert(modules, Module)
		return Module
	end
	local function moveIndicatorTo(tab, instant)
		if indicatorConn then
			indicatorConn:Disconnect()
			indicatorConn = nil
		end
		local btn = tab.Button
		local function place(inst)
			if not btn.Parent then return end
			local y = btn.AbsolutePosition.Y - Sidebar.AbsolutePosition.Y
				+ (btn.AbsoluteSize.Y - 16) / 2
			Indicator.Visible = true
			if inst then
				Indicator.Position = UDim2.new(0, 13, 0, y)
			else
				Tween(Indicator, TWEEN_MED, { Position = UDim2.new(0, 13, 0, y) })
			end
		end
		task.defer(place, instant)
		indicatorConn = btn:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
			place(true)
		end)
	end
	local function selectTab(tab, instant)
		local previous = currentTab
		currentTab = tab
		for _, t in ipairs(tabs) do
			local selected = (t == tab)
			if selected then
				if t.Page ~= (previous and previous.Page) then
					t.Page.Visible = true
					t.Page.Position = UDim2.new(0, 0, 0, 12)
					t.Page.GroupTransparency = 1
					Tween(t.Page, TWEEN_PAGE, {
						Position = UDim2.new(0, 0, 0, 0),
						GroupTransparency = 0,
					})
				else
					t.Page.Visible = true
				end
				t.Scroller.CanvasPosition = Vector2.new(0, 0)
			else
				t.Page.Visible = false
			end
			Tween(t.Button, TWEEN_FAST, {
				BackgroundTransparency = selected and 0 or 1,
			})
			t.NameLabel.TextColor3 = selected and Theme.Text or Theme.TextDim
			if t.IconRef then
				if t.IconRef:IsA("ImageLabel") then
					Tween(t.IconRef, TWEEN_FAST, { ImageColor3 = selected and Theme.Text or Theme.TextDim })
				else
					Tween(t.IconRef, TWEEN_FAST, { BackgroundColor3 = selected and Theme.Text or Theme.TextDim })
				end
			end
		end
		moveIndicatorTo(tab, instant)
	end
	function Window:AddTab(tabOpts)
		tabOpts = tabOpts or {}
		sidebarOrder += 1
		local Tab = { Name = tabOpts.Name or "Tab" }
		local button = New("TextButton", {
			Name = "Tab_" .. Tab.Name,
			LayoutOrder = sidebarOrder,
			Size = UDim2.new(1, 0, 0, 36),
			BackgroundTransparency = 1,
			BackgroundColor3 = Theme.TabSelected,
			Text = "",
			AutoButtonColor = false,
			BorderSizePixel = 0,
			Parent = Sidebar,
		})
		Corner(button, 8)
		local iconRef = MakeIcon(button, tabOpts.Icon, 17, Theme.TextDim)
		iconRef.AnchorPoint = Vector2.new(0, 0.5)
		iconRef.Position = UDim2.new(0, 12, 0.5, 0)
		local nameLabel = New("TextLabel", {
			Position = UDim2.new(0, 36, 0, 0),
			Size = UDim2.new(1, -42, 1, 0),
			BackgroundTransparency = 1,
			Text = Tab.Name,
			FontFace = FONT_SEMIBOLD,
			TextSize = 14,
			TextColor3 = Theme.TextDim,
			TextXAlignment = Enum.TextXAlignment.Left,
			Parent = button,
		})
		button.MouseEnter:Connect(function()
			if currentTab ~= Tab then
				Tween(button, TWEEN_FAST, { BackgroundTransparency = 0.6 })
			end
		end)
		button.MouseLeave:Connect(function()
			if currentTab ~= Tab then
				Tween(button, TWEEN_FAST, { BackgroundTransparency = 1 })
			end
		end)
		local page = New("CanvasGroup", {
			Name = "Page_" .. Tab.Name,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			GroupTransparency = 0,
			Visible = false,
			BorderSizePixel = 0,
			Parent = Content,
		})
		local scroller = New("ScrollingFrame", {
			Name = "Scroller",
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			ScrollBarThickness = 4,
			ScrollBarImageColor3 = Color3.fromRGB(60, 60, 66),
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			CanvasSize = UDim2.new(0, 0, 0, 0),
			ScrollingDirection = Enum.ScrollingDirection.Y,
			BorderSizePixel = 0,
			Parent = page,
		})
		Pad(scroller, 0, 0, 0, 4)
		local holder = New("Frame", {
			Name = "Columns",
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			Parent = scroller,
		})
		local gutter = CARD_GAP
		local leftCol = New("Frame", {
			Name = "Left",
			Position = UDim2.new(0, 0, 0, 0),
			Size = UDim2.new(0.5, -gutter / 2, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			Parent = holder,
		})
		New("UIListLayout", { Padding = UDim.new(0, CARD_GAP), SortOrder = Enum.SortOrder.LayoutOrder, Parent = leftCol })
		local rightCol = New("Frame", {
			Name = "Right",
			Position = UDim2.new(0.5, gutter / 2, 0, 0),
			Size = UDim2.new(0.5, -gutter / 2, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			Parent = holder,
		})
		New("UIListLayout", { Padding = UDim.new(0, CARD_GAP), SortOrder = Enum.SortOrder.LayoutOrder, Parent = rightCol })
		local colHeight = { [leftCol] = 0, [rightCol] = 0 }
		local colCount = { [leftCol] = 0, [rightCol] = 0 }
		local function pickColumn(override)
			if override == "Left" then return leftCol end
			if override == "Right" then return rightCol end
			if colHeight[leftCol] <= colHeight[rightCol] then
				return leftCol
			end
			return rightCol
		end
		Tab.Page = page
		Tab.Scroller = scroller
		Tab.Button = button
		Tab.NameLabel = nameLabel
		Tab.IconRef = iconRef
		Tab.Modules = {}
		function Tab:AddModule(mOpts)
			mOpts = mOpts or {}
			local column = pickColumn(mOpts.Column)
			colCount[column] += 1
			local mod = CreateModule(mOpts, column, colCount[column])
			local last = mod:GetHeight()
			colHeight[column] += last
			mod:OnResize(function(h)
				colHeight[column] += h - last
				last = h
			end)
			table.insert(Tab.Modules, mod)
			return mod
		end
		function Tab:Select()
			if currentTab ~= Tab then
				selectTab(Tab)
			end
		end
		local function forwardToModule(Section, mod)
			Section.AddToggle = function(_, sub) return mod:AddToggle(sub) end
			Section.AddSlider = function(_, sub) return mod:AddSlider(sub) end
			Section.AddDropdown = function(_, sub) return mod:AddDropdown(sub) end
			Section.AddButton = function(_, sub) return mod:AddButton(sub) end
			Section.AddLabel = function(_, sub) return mod:AddLabel(sub) end
			Section.AddInput = function(_, sub) return mod:AddInput(sub) end
			Section.AddColorPick = function(_, sub) return mod:AddColorPick(sub) end
			Section.AddKeybind = function(_, sub) return mod:AddKeybind(sub) end
			Section.CreateToggle = Section.AddToggle
			Section.CreateSlider = Section.AddSlider
			Section.CreateDropdown = Section.AddDropdown
			Section.CreateButton = Section.AddButton
			Section.CreateLabel = Section.AddLabel
			Section.CreateInput = Section.AddInput
			Section.CreateColorPick = Section.AddColorPick
			Section.CreateKeybind = Section.AddKeybind
			Section.AddGroupbox = Section.AddToggle
		end
		function Tab:AddSection(sOpts)
			local name = type(sOpts) == "table" and (sOpts.Name or sOpts.Title) or tostring(sOpts or "Section")
			local mod = Tab:AddModule({
				Name = name,
				Keybind = type(sOpts) == "table" and sOpts.Keybind or nil,
				Default = type(sOpts) == "table" and sOpts.Default or nil,
				Callback = type(sOpts) == "table" and sOpts.Callback or nil,
			})
			local Section = { Name = name, Module = mod }
			forwardToModule(Section, mod)
			return Section
		end
		Tab.CreateSection = Tab.AddSection
		function Tab:AddGroupbox(gOpts)
			return Tab:AddSection(gOpts)
		end
		Tab.CreateGroupbox = Tab.AddGroupbox
		table.insert(tabs, Tab)
		button.MouseButton1Click:Connect(function()
			if currentTab ~= Tab then
				selectTab(Tab)
			end
		end)
		if #tabs == 1 then
			selectTab(Tab, true)
		end
		return Tab
	end
	function Window:Modules() return modules end
	function Window:FindModule(name)
		for _, m in ipairs(modules) do
			if m.Name == name then return m end
		end
		return nil
	end
	local toggleKey = Enum.KeyCode.LeftControl
	if opts.ToggleKey and Enum.KeyCode[opts.ToggleKey] then
		toggleKey = Enum.KeyCode[opts.ToggleKey]
	end
	local inputConn
	inputConn = Connect(UserInputService.InputBegan, function(input, gameProcessed)
		if rebinding then
			if input.UserInputType == Enum.UserInputType.Keyboard then
				local pending = rebinding
				rebinding = nil
				local entry = pending.Entry
				if input.KeyCode == Enum.KeyCode.Escape then
					entry:EndRebind()
				elseif input.KeyCode == Enum.KeyCode.Backspace or input.KeyCode == Enum.KeyCode.Delete then
					entry:Bind(nil)
					entry:EndRebind()
				else
					entry:Bind(input.KeyCode)
					entry:EndRebind()
				end
			end
			return
		end
		if gameProcessed then return end
		if input.KeyCode == toggleKey then
			setVisible(not uiVisible)
			return
		end
		if input.UserInputType == Enum.UserInputType.Keyboard then
			for _, entry in ipairs(keybinds) do
				if entry.Keybind and entry.Keybind == input.KeyCode then
					entry:Set(not entry:Get())
				end
			end
		end
	end)
	Window.SetToggleKey = function(_, key)
		if typeof(key) == "EnumItem" then
			toggleKey = key
		elseif type(key) == "string" and Enum.KeyCode[key] then
			toggleKey = Enum.KeyCode[key]
		end
		return toggleKey
	end
	function Window:GetToggleKey() return toggleKey end
	local PANEL_W = 250
	local PANEL_GAP = 12
	panel = New("CanvasGroup", {
		Name = "GlobalSettings",
		AnchorPoint = Vector2.new(0, 0),
		Position = UDim2.fromOffset(0, 0),
		Size = UDim2.new(Main.Size.X.Scale, 0, Main.Size.Y.Scale, 0),
		BackgroundColor3 = Theme.Background,
		BackgroundTransparency = 0.08,
		BorderSizePixel = 0,
		GroupTransparency = 1,
		Visible = false,
		ZIndex = 20,
		Parent = Gui,
	})
	Corner(panel, 12)
	Stroke(panel, Theme.GroupStroke, 0.4)
	panelScale = New("UIScale", { Scale = 0.96, Parent = panel })
	syncPanelPosition = function()
		if not (panel and panel.Parent) then return end
		local mw = Main.Size.X.Offset
		local mh = Main.Size.Y.Offset
		if mw <= 0 or mh <= 0 then
			mw, mh = Main.AbsoluteSize.X, Main.AbsoluteSize.Y
		end
		local newPos = UDim2.new(
			Main.Position.X.Scale,
			Main.Position.X.Offset + mw / 2 + PANEL_GAP,
			Main.Position.Y.Scale,
			Main.Position.Y.Offset - mh / 2
		)
		panel.Position = newPos
		panel.Size = UDim2.fromOffset(PANEL_W, mh)
	end
	local function setPanelBinding(v)
		v = v == true
		if v == panelOpen then return end
		panelOpen = v
		if v then
			panel.Visible = true
			if syncPanelPosition then syncPanelPosition() end
		end
		local openPos = panel.Position
		local hiddenPos = UDim2.new(
			openPos.X.Scale,
			openPos.X.Offset + PANEL_W + PANEL_GAP,
			openPos.Y.Scale,
			openPos.Y.Offset
		)
		if v then
			panel.Position = hiddenPos
			Tween(panel, TWEEN_MED, {
				Position = openPos,
				GroupTransparency = 0,
			})
		else
			if closeModal then pcall(closeModal) end
			Tween(panel, TWEEN_MED, {
				Position = hiddenPos,
				GroupTransparency = 1,
			})
			task.delay(0.24, function()
				if not panelOpen then panel.Visible = false end
			end)
		end
		if panelScale then
			Tween(panelScale, TWEEN_MED, { Scale = v and 1 or 0.96 })
		end
	end
	setPanel = setPanelBinding
	New("Frame", {
		AnchorPoint = Vector2.new(0, 0),
		Position = UDim2.new(0, 0, 0, 0),
		Size = UDim2.new(0, 1, 1, 0),
		BackgroundColor3 = Theme.Divider,
		BorderSizePixel = 0,
		ZIndex = 21,
		Parent = panel,
	})
	local panelScroll = New("ScrollingFrame", {
		Name = "Body",
		Position = UDim2.new(0, 0, 0, 0),
		Size = UDim2.new(1, -8, 1, 0),
		BackgroundTransparency = 1,
		ScrollBarThickness = 4,
		ScrollBarImageColor3 = Color3.fromRGB(60, 60, 66),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		CanvasSize = UDim2.new(0, 0, 0, 0),
		BorderSizePixel = 0,
		ZIndex = 21,
		Parent = panel,
	})
	Pad(panelScroll, 12, 12, 14, 10)
	local panelLayout = New("UIListLayout", {
		Padding = UDim.new(0, 9),
		SortOrder = Enum.SortOrder.LayoutOrder,
		Parent = panelScroll,
	})
	local function panelLabel(text, order)
		return New("TextLabel", {
			Name = "H_" .. text,
			LayoutOrder = order,
			Size = UDim2.new(1, 0, 0, 12),
			BackgroundTransparency = 1,
			Text = string.upper(text),
			Font = Enum.Font.GothamBold,
			TextSize = 10,
			TextColor3 = Theme.HeaderText,
			TextXAlignment = Enum.TextXAlignment.Left,
			ZIndex = 22,
			Parent = panelScroll,
		})
	end
	local gearBtn = IconButton(Header, 28, 7)
	gearBtn.Name = "SettingsGear"
	gearBtn.AnchorPoint = Vector2.new(1, 0.5)
	gearBtn.Position = UDim2.new(1, -14, 0.5, 0)
	gearBtn.ZIndex = 7
	local gearIcon = MakeIcon(gearBtn, "cog", 17, Theme.TextDim)
	gearIcon.AnchorPoint = Vector2.new(0.5, 0.5)
	gearIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
	gearIcon.ImageColor3 = Theme.TextDim
	gearBtn.MouseButton1Click:Connect(function()
		setPanel(not panelOpen)
	end)
	do
		local spin = 0
		Connect(RunService.RenderStepped, function(dt)
			if not gearBtn.Parent then return end
			if panelOpen then
				spin += dt * 45
				gearIcon.Rotation = spin % 360
			end
		end)
	end
	local CONFIG_DIR = ConfigDir
	local CONFIG_DEFAULT = "Default"
	-- Filenames owned by the main script's own store that shares this folder.
	-- They must never appear as UI-selectable configs nor become the fallback.
	local CONFIG_RESERVED = { HyperionMain = true, Autosave = true }
	local configCache = {}
	local configWatchers = {}
	local selectedConfig = CONFIG_DEFAULT
	local notifyLocationDd, configDd, guiKeyEntry
	local function configFile(name)
		return CONFIG_DIR .. "/" .. name .. ".json"
	end
	local function sanitizeName(name)
		name = tostring(name or "")
		name = name:gsub("^%s+", ""):gsub("%s+$", "")
		name = name:gsub('[<>:"/\\|?%*%.]', "")
		if #name == 0 then return nil end
		if #name > 32 then name = name:sub(1, 32) end
		return name
	end
	local function hasFs()
		return type(writefile) == "function" and type(readfile) == "function"
	end
	local function refreshConfigCache()
		table.clear(configCache)
		configCache[CONFIG_DEFAULT] = true
		if hasFs() and type(listfiles) == "function" then
			local ok, files = pcall(listfiles, CONFIG_DIR)
			if ok and type(files) == "table" then
				for _, path in ipairs(files) do
					local base = tostring(path):match("([^/\\]+)%.json$")
					if base and #base > 0 and not CONFIG_RESERVED[base] then
						configCache[base] = true
					end
				end
			end
		end
	end
	local function configNames()
		local names = { CONFIG_DEFAULT }
		local sorted = {}
		for k in pairs(configCache) do
			if k ~= CONFIG_DEFAULT then sorted[#sorted + 1] = k end
		end
		table.sort(sorted)
		for _, n in ipairs(sorted) do names[#names + 1] = n end
		return names
	end
	local function guiSettings()
		return {
			ToggleKey = toggleKey and toggleKey.Name or nil,
			NotifyLocation = notifyLocation,
		}
	end
	local function buildConfigData()
		local data = { Version = 1, Gui = guiSettings(), Modules = {} }
		for _, m in ipairs(modules) do
			data.Modules[m.Name] = m:GetConfig()
		end
		return data
	end
	local function applyConfigData(data)
		if type(data) ~= "table" then return end
		if type(data.Gui) == "table" then
			if data.Gui.NotifyLocation then
				SetNotifyLocation(data.Gui.NotifyLocation)
				if notifyLocationDd then notifyLocationDd:SetSilent(data.Gui.NotifyLocation) end
			end
			if data.Gui.ToggleKey and Enum.KeyCode[data.Gui.ToggleKey] then
				Window:SetToggleKey(Enum.KeyCode[data.Gui.ToggleKey])
				if guiKeyEntry then guiKeyEntry:Bind(Enum.KeyCode[data.Gui.ToggleKey]) end
			end
		end
		if type(data.Modules) == "table" then
			for _, m in ipairs(modules) do
				local t = data.Modules[m.Name]
				if t then m:ApplyConfig(t) end
			end
		end
	end
	local function saveConfigFile(name)
		if not hasFs() then return false end
		local ok = pcall(function()
			writefile(configFile(name), HttpService:JSONEncode(buildConfigData()))
		end)
		return ok
	end
	local function loadConfigFile(name)
		if name == CONFIG_DEFAULT or not hasFs() then
			Window:Notify({ Title = "Configs", Text = "Loaded " .. name, Icon = "check" })
			return true
		end
		local ok, raw = pcall(readfile, configFile(name))
		if not ok or type(raw) ~= "string" or #raw == 0 then
			Window:Notify({ Title = "Configs", Text = "Could not read " .. name, Icon = "x" })
			return false
		end
		local decoded = nil
		local dok = pcall(function() decoded = HttpService:JSONDecode(raw) end)
		if not dok or type(decoded) ~= "table" then
			Window:Notify({ Title = "Configs", Text = "Corrupted config: " .. name, Icon = "x" })
			return false
		end
		applyConfigData(decoded)
		return true
	end
	local function deleteConfigFile(name)
		if name == CONFIG_DEFAULT then return false end
		if not hasFs() then return false end
		local ok = pcall(delfile, configFile(name))
		return ok
	end
	refreshConfigCache()
	panelLabel("Global Settings", 1)
	local keyRow = New("Frame", {
		Name = "GuiKeyRow",
		LayoutOrder = 2,
		Size = UDim2.new(1, 0, 0, 26),
		BackgroundTransparency = 1,
		ZIndex = 22,
		Parent = panelScroll,
	})
	New("TextLabel", {
		Size = UDim2.new(1, -74, 1, 0),
		BackgroundTransparency = 1,
		Text = "GUI Keybind",
		FontFace = FONT_SEMIBOLD,
		TextSize = 14,
		TextColor3 = Theme.Text,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 23,
		Parent = keyRow,
	})
	local guiChip = New("TextButton", {
		Name = "Keybind",
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, 0, 0.5, 0),
		Size = UDim2.new(0, 0, 0, 20),
		AutomaticSize = Enum.AutomaticSize.X,
		BackgroundTransparency = 1,
		BackgroundColor3 = Theme.TextSoft,
		Text = KeybindText(toggleKey),
		FontFace = FONT_SEMIBOLD,
		TextSize = 13,
		TextColor3 = Theme.TextDim,
		AutoButtonColor = false,
		BorderSizePixel = 0,
		ZIndex = 23,
		Parent = keyRow,
	})
	Corner(guiChip, 5)
	Pad(guiChip, 0, 0, 5, 5)
	guiKeyEntry = { Keybind = nil, Kind = "GuiKey" }
	function guiKeyEntry:Get() return uiVisible end
	function guiKeyEntry:Set(v)
		setVisible(v == true)
	end
	guiKeyEntry.OnBind = function(newKey)
		Window:SetToggleKey(newKey)
	end
	AttachKeybind(guiChip, guiKeyEntry, toggleKey)
	panelLabel("Notification Location", 3)
	notifyLocationDd = BuildDropdown(panelScroll, 4, {
		Name = "Location",
		Options = NOTIFY_LOCATIONS,
		Default = notifyLocation,
		Callback = function(v)
			SetNotifyLocation(v)
		end,
	})
	panelLabel("Config Manager", 5)
	configDd = BuildDropdown(panelScroll, 6, {
		Name = "Config",
		Options = configNames(),
		Default = selectedConfig,
		Callback = function(v)
			if loadConfigFile(v) then
				refreshConfigDropdown(v)
			else
				refreshConfigDropdown()
			end
		end,
	})
	local function refreshConfigDropdown(selectName, skipPersist)
		refreshConfigCache()
		local names = configNames()
		configDd:SetOptions(names)
		local target = selectName or selectedConfig
		local ok = false
		for _, n in ipairs(names) do
			if n == target then ok = true break end
		end
		if not ok then target = names[1] end
		selectedConfig = target
		configDd:SetSilent(target)
		if not skipPersist then
			pcall(SetLastSelectedConfig, target)
		end
		for _, dd in ipairs(configWatchers) do
			if dd and dd.SetOptions then
				dd:SetOptions(names)
				if dd.SetSilent then dd:SetSilent(selectedConfig) end
			end
		end
	end
	function Window:WatchConfigDropdown(dd)
		if dd and dd.SetOptions then
			table.insert(configWatchers, dd)
			dd:SetOptions(configNames())
			if dd.SetSilent then dd:SetSilent(selectedConfig) end
		end
		return dd
	end
	function Window:RefreshConfigs()
		refreshConfigDropdown()
	end
	BuildButton(panelScroll, 7, {
		Name = "Save Config",
		Callback = function()
			if selectedConfig == CONFIG_DEFAULT then
				Window:Notify({ Title = "Configs", Text = "Create a config first", Icon = "x" })
				return
			end
			if saveConfigFile(selectedConfig) then
				Window:Notify({ Title = "Configs", Text = "Saved " .. selectedConfig, Icon = "check" })
			else
				Window:Notify({ Title = "Configs", Text = "Could not save config", Icon = "x" })
			end
		end,
	})
	BuildButton(panelScroll, 8, {
		Name = "Reload Configs",
		Callback = function()
			refreshConfigDropdown()
			Window:Notify({ Title = "Configs", Text = "Config list refreshed", Icon = "check" })
		end,
	})
	closeModal = function()
		if modal then
			local m = modal
			modal = nil
			local bd, dl = m:FindFirstChild("Backdrop"), m:FindFirstChild("Dialog")
			if bd then Tween(bd, TWEEN_FAST, { BackgroundTransparency = 1 }) end
			if dl then Tween(dl, TWEEN_FAST, { GroupTransparency = 1 }) end
			task.delay(0.22, function()
				if m and m.Parent then m:Destroy() end
			end)
		end
	end
	local function openNameModal()
		if modal then return end
		local overlay = New("Frame", {
			Name = "NewConfigModal",
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ZIndex = 60,
			Parent = panel,
		})
		modal = overlay
		local backdrop = New("TextButton", {
			Name = "Backdrop",
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = Color3.fromRGB(0, 0, 0),
			BackgroundTransparency = 1,
			Text = "",
			AutoButtonColor = false,
			BorderSizePixel = 0,
			ZIndex = 60,
			Parent = overlay,
		})
		local dialog = New("CanvasGroup", {
			Name = "Dialog",
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromOffset(234, 144),
			BackgroundColor3 = Theme.Group,
			BackgroundTransparency = Theme.CardTransparency,
			GroupTransparency = 1,
			BorderSizePixel = 0,
			ZIndex = 61,
			Parent = overlay,
		})
		Corner(dialog, 11)
		Stroke(dialog, Theme.GroupStroke, 0.1)
		New("TextLabel", {
			Position = UDim2.new(0, 14, 0, 12),
			Size = UDim2.new(1, -28, 0, 16),
			BackgroundTransparency = 1,
			Text = "New Config",
			FontFace = FONT_BOLD,
			TextSize = 14,
			TextColor3 = Theme.Text,
			TextXAlignment = Enum.TextXAlignment.Left,
			ZIndex = 62,
			Parent = dialog,
		})
		local box = New("TextBox", {
			Name = "NameBox",
			Position = UDim2.new(0, 14, 0, 36),
			Size = UDim2.new(1, -28, 0, 26),
			BackgroundColor3 = Theme.Control,
			Text = "",
			ClearTextOnFocus = false,
			MultiLine = false,
			PlaceholderText = "Config name",
			FontFace = FONT_SEMIBOLD,
			TextSize = 14,
			TextColor3 = Theme.Text,
			TextXAlignment = Enum.TextXAlignment.Left,
			BorderSizePixel = 0,
			ZIndex = 62,
			Parent = dialog,
		})
		Corner(box, 7)
		Pad(box, 0, 0, 10, 10)
		local hint = New("TextLabel", {
			Name = "Hint",
			Position = UDim2.new(0, 14, 0, 66),
			Size = UDim2.new(1, -28, 0, 12),
			BackgroundTransparency = 1,
			Text = "",
			FontFace = FONT_SEMIBOLD,
			TextSize = 11,
			TextColor3 = Color3.fromRGB(226, 120, 120),
			TextXAlignment = Enum.TextXAlignment.Left,
			TextTruncate = Enum.TextTruncate.AtEnd,
			ZIndex = 62,
			Parent = dialog,
		})
		local saveBtn = New("TextButton", {
			Name = "SaveButton",
			Position = UDim2.new(0, 14, 1, -38),
			Size = UDim2.new(1, -86, 0, 26),
			BackgroundColor3 = Theme.Control,
			Text = "  Save",
			FontFace = FONT_SEMIBOLD,
			TextSize = 13,
			TextColor3 = Theme.TextSoft,
			AutoButtonColor = false,
			BorderSizePixel = 0,
			ZIndex = 62,
			Parent = dialog,
		})
		Corner(saveBtn, 7)
		local saveIcon = MakeIcon(saveBtn, "folder-plus", 14, Theme.TextSoft)
		saveIcon.AnchorPoint = Vector2.new(0, 0.5)
		saveIcon.Position = UDim2.new(0, 10, 0.5, 0)
		saveIcon.ZIndex = 63
		local cancelBtn = New("TextButton", {
			Name = "CancelButton",
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.new(1, -14, 1, -38),
			Size = UDim2.fromOffset(58, 26),
			BackgroundColor3 = Theme.Control,
			Text = "  Cancel",
			FontFace = FONT_SEMIBOLD,
			TextSize = 13,
			TextColor3 = Theme.TextDim,
			AutoButtonColor = false,
			BorderSizePixel = 0,
			ZIndex = 62,
			Parent = dialog,
		})
		Corner(cancelBtn, 7)
		local cancelIcon = MakeIcon(cancelBtn, "x", 13, Theme.TextDim)
		cancelIcon.AnchorPoint = Vector2.new(0, 0.5)
		cancelIcon.Position = UDim2.new(0, 9, 0.5, 0)
		cancelIcon.ZIndex = 63
		saveBtn.MouseEnter:Connect(function() Tween(saveBtn, TWEEN_FAST, { BackgroundColor3 = Theme.ControlHover }) end)
		saveBtn.MouseLeave:Connect(function() Tween(saveBtn, TWEEN_FAST, { BackgroundColor3 = Theme.Control }) end)
		cancelBtn.MouseEnter:Connect(function() Tween(cancelBtn, TWEEN_FAST, { BackgroundColor3 = Theme.ControlHover }) end)
		cancelBtn.MouseLeave:Connect(function() Tween(cancelBtn, TWEEN_FAST, { BackgroundColor3 = Theme.Control }) end)
		local function commit()
			local name = sanitizeName(box.Text)
			if not name then
				hint.Text = "Enter a valid name"
				return
			end
			refreshConfigCache()
			if configCache[name] or CONFIG_RESERVED[name] then
				hint.Text = "A config named '" .. name .. "' already exists"
				return
			end
			if not saveConfigFile(name) then
				hint.Text = "File writing is unavailable here"
				return
			end
			refreshConfigDropdown(name)
			closeModal()
			Window:Notify({ Title = "Configs", Text = "Created " .. name, Icon = "check" })
		end
		saveBtn.MouseButton1Click:Connect(commit)
		cancelBtn.MouseButton1Click:Connect(closeModal)
		box.FocusLost:Connect(function(enterPressed)
			if enterPressed then
				commit()
			end
		end)
		backdrop.MouseButton1Click:Connect(closeModal)
		Tween(backdrop, TWEEN_MED, { BackgroundTransparency = 0.5 })
		Tween(dialog, TWEEN_MED, { GroupTransparency = 0 })
		task.defer(function()
			pcall(function() box:CaptureFocus() end)
		end)
	end
	BuildButton(panelScroll, 9, {
		Name = "Add New Config",
		Callback = openNameModal,
	})
	BuildButton(panelScroll, 10, {
		Name = "Delete Selected Config",
		Callback = function()
			if selectedConfig == CONFIG_DEFAULT then
				Window:Notify({ Title = "Configs", Text = "Default cannot be deleted", Icon = "x" })
				return
			end
			local gone = selectedConfig
			if deleteConfigFile(gone) then
				refreshConfigDropdown(CONFIG_DEFAULT)
				Window:Notify({ Title = "Configs", Text = "Deleted " .. gone, Icon = "check" })
			else
				refreshConfigDropdown()
				Window:Notify({ Title = "Configs", Text = "Could not delete " .. gone, Icon = "x" })
			end
		end,
	})
	-- Boot-time UI sync only: must NOT persist, or it would overwrite the
	-- remembered selection before the deferred auto-load reads it.
	refreshConfigDropdown(nil, true)
	function Window:OpenGlobalSettings() setPanel(true) end
	function Window:CloseGlobalSettings() setPanel(false) end
	function Window:IsGlobalSettingsOpen() return panelOpen end
	function Window:GetSelectedConfig() return selectedConfig end
	function Window:SetSelectedConfig(name)
		refreshConfigDropdown(name)
		return selectedConfig
	end
	function Window:SaveConfig(name)
		local target = sanitizeName(name or selectedConfig)
		if not target or CONFIG_RESERVED[target] then return false end
		if name and name ~= selectedConfig then
			refreshConfigDropdown(target)
		end
		return saveConfigFile(target)
	end
	function Window:LoadConfig(name)
		local target = name or selectedConfig
		if loadConfigFile(target) then
			refreshConfigDropdown(target)
			return true
		end
		return false
	end
	function Window:DeleteConfig(name)
		local target = name or selectedConfig
		if target == CONFIG_DEFAULT then return false end
		local ok = deleteConfigFile(target)
		-- Prefer a remaining config over Default; Default only if nothing left.
		refreshConfigCache()
		local fallback = CONFIG_DEFAULT
		for _, cand in ipairs(configNames()) do
			if cand ~= CONFIG_DEFAULT then fallback = cand break end
		end
		refreshConfigDropdown(fallback)
		return ok
	end
	function Window:AddConfig(name)
		local target = sanitizeName(name)
		if not target or CONFIG_RESERVED[target] then return nil end
		refreshConfigCache()
		if configCache[target] then return nil end
		if not saveConfigFile(target) then return nil end
		refreshConfigDropdown(target)
		return target
	end
	function Window:ConfigNames()
		refreshConfigCache()
		return configNames()
	end
	function Window:GetModuleStates() return buildConfigData() end
	function Window:ApplyModuleStates(data) applyConfigData(data) end
	Window.GearButton = gearBtn
	Window.SettingsPanel = panel
	function Window:Toggle()
		setVisible(not uiVisible)
	end
	function Window:Show()
		setVisible(true)
	end
	function Window:Hide()
		setVisible(false)
	end
	function Window:Destroy()
		destroyed = true
		ReleaseConns()
		if indicatorConn then
			pcall(function() indicatorConn:Disconnect() end)
			indicatorConn = nil
		end
		pcall(function() Gui:Destroy() end)
	end
	-- Re-apply this game's remembered config. Deferred because modules are
	-- registered after CreateWindow returns; silent so startup stays quiet.
	function Window:LoadRememberedConfig(silent)
		local wanted = ReadSelectedConfig()
		if not wanted or wanted == CONFIG_DEFAULT then
			refreshConfigDropdown()
			return Window:GetSelectedConfig()
		end
		refreshConfigCache()
		if not configCache[wanted] then
			-- Deleted or never existed: fall back and remember the valid choice.
			refreshConfigDropdown(CONFIG_DEFAULT)
			return Window:GetSelectedConfig()
		end
		if silent == true then
			local ok, raw = pcall(readfile, configFile(wanted))
			local decoded
			if ok and type(raw) == "string" and #raw > 0 then
				pcall(function() decoded = HttpService:JSONDecode(raw) end)
			end
			if type(decoded) == "table" then
				applyConfigData(decoded)
				refreshConfigDropdown(wanted)
				return wanted
			end
			refreshConfigDropdown(CONFIG_DEFAULT)
			return Window:GetSelectedConfig()
		end
		if loadConfigFile(wanted) then
			refreshConfigDropdown(wanted)
			return wanted
		end
		refreshConfigDropdown(CONFIG_DEFAULT)
		return Window:GetSelectedConfig()
	end
	EnsureDir()
	task.defer(function()
		if destroyed then return end
		pcall(function() Window:LoadRememberedConfig(true) end)
	end)
	SetNotifyLocation(notifyLocation)
	setVisible(true)
	do
		activeWindow = Window
		local ok, g = pcall(getgenv)
		if ok and type(g) == "table" then
			g.HyperionUI = Window
		end
	end
	return Window
end
return Library
