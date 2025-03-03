if setreadonly == nil then warn("executor not supported :(") end
function serializeTable(val, name, skipnewlines, depth)
	local skipnewlines = skipnewlines
    depth = depth or 0

    local tmp = string.rep(" ", depth)
    if type(name) == "number" then
        name = "["..name.."]"
    end
    if name then tmp = tmp .. name .. " = " end

    if type(val) == "table" then
        tmp = tmp .. "{" .. (not skipnewlines and "\n" or "")

        for k, v in pairs(val) do
            tmp =  tmp .. serializeTable(v, k, skipnewlines, depth + 1) .. "," .. (not skipnewlines and "\n" or "")
        end

        tmp = tmp .. string.rep(" ", depth) .. "}"
    elseif type(val) == "number" then
        tmp = tmp .. tostring(val)
    elseif type(val) == "string" then
        tmp = tmp .. string.format("%q", val)
    elseif type(val) == "boolean" then
        tmp = tmp .. (val and "true" or "false")
    elseif typeof(val) == "Vector3" then
        tmp = tmp .. "Vector3.new( " .. tostring( val ) .. ")"
    elseif typeof(val) == "Vector2" then
        tmp = tmp .. "Vector2.new( " .. tostring( val ) .. ")"
    elseif typeof(val) == "UDim2" then
        tmp = tmp .. "UDim2.new( " .. tostring( val ) .. ")"
    elseif typeof(val) == "UDim" then
        tmp = tmp .. "UDim.new( " .. tostring( val ) .. ")"
    elseif typeof(val) == "Instance" then
        tmp = tmp .. val:GetFullName()
    elseif typeof(val) == "Color3" then
        tmp = tmp .. "Color3.new( " .. val.R .. "," .. val.G .. "," .. val.B .. ")"
	elseif typeof(val) == "buffer" then	
		print("got buffer -> "..buffer.tostring(val))
		tmp = tmp .. buffer.tostring(val) .. "--buffer deserealize in beta"
	else
        --tmp = tmp .. tostring(val)
        tmp = tmp .. "\"[inserializeable datatype:" .. type(val) .. "]\""
    end

    return tmp
end
function getPath(Inst)
    local newParent = Inst
    local Path = '["'..Inst.Name..'"]'
    while newParent.Parent ~= nil do
        newParent = newParent.Parent
        if newParent.Parent == nil then
            Path = 'game' .. Path
        else
            Path = '["' .. newParent.Name .. '"]' .. Path
        end
    end
    return Path
end
local gui = {
	core = {
		access = false,
		place = game.CoreGui,
	},
	font = {
		Inconsolata = Font.new(
			"rbxasset://fonts/families/Inconsolata.json",
			Enum.FontWeight.Regular,
			Enum.FontStyle.Normal
		),
	},
}
gui.objs = {}
local iconLib = {}
local Convert = {}
function Convert:Img(id)
	local decal = game:GetObjects("rbxassetid://" .. tostring(id))[1]
	return decal.Texture
end
function iconLib:Source()
	return Convert:Img("130245432481655")
end
function iconLib:GetIcon(name)
	local offsets = {
		RemoteFunction = 0,
		RemoteEvent = 1,
		BindableFunction = 2,
		BindableEvent = 3,
		Script = 4,
		LocalScript = 5,
		ServerToClient = 6,
		ClientToClient = 7,
		ClientToServer = 8,
		TitleIcon = 9,
	}
	return 16 * offsets[name]
end
pcall(function()
	local a = Instance.new("Folder", game:GetService("CoreGui"))
	a:Remove()
	gui.core.access = true
	gui.core.place = game:GetService("CoreGui")
end)

local fonts = {}

gui.objs["Surface"] = Instance.new("ScreenGui", gui.core.place)
gui.objs["Surface"].IgnoreGuiInset = true
gui.objs["Surface"].DisplayOrder = 999999999
gui.objs["Surface"].ResetOnSpawn = false

gui.objs["MainFrame"] = Instance.new("Frame", gui.objs["Surface"])
gui.objs["MainFrame"]["BorderSizePixel"] = 2
gui.objs["MainFrame"]["BackgroundColor3"] = Color3.fromRGB(211, 211, 211)
gui.objs["MainFrame"]["Size"] = UDim2.new(0, 600, 0, 400)
gui.objs["MainFrame"]["Position"] = UDim2.new(0, 611, 0, 249)
gui.objs["MainFrame"]["BorderColor3"] = Color3.fromRGB(151, 151, 151)
gui.objs["MainFrame"]["Name"] = [[MainFrame]]

gui.objs["RemoteList"] = Instance.new("ScrollingFrame", gui.objs["MainFrame"])
gui.objs["RemoteList"]["BorderSizePixel"] = 0
gui.objs["RemoteList"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
gui.objs["RemoteList"]["Size"] = UDim2.new(0, 176, 0, 104)
gui.objs["RemoteList"]["Position"] = UDim2.new(0, 12, 0, 50)
gui.objs["RemoteList"]["BottomImage"] = "rbxassetid://122693187016793"
gui.objs["RemoteList"]["MidImage"] = "rbxassetid://122693187016793"
gui.objs["RemoteList"]["TopImage"] = "rbxassetid://122693187016793"
gui.objs["RemoteList"]["ScrollBarImageColor3"] = Color3.fromRGB(171, 171, 171)
gui.objs["RemoteList"]["CanvasSize"] = UDim2.new(0, 0, 0, 0)
gui.objs["RemoteList"]["Name"] = [[RemoteList]]

gui.objs["Title"] = Instance.new("Frame", gui.objs["MainFrame"])
gui.objs["Title"]["BorderSizePixel"] = 2
gui.objs["Title"]["BackgroundColor3"] = Color3.fromRGB(234, 234, 234)
gui.objs["Title"]["Size"] = UDim2.new(0, 600, 0, 30)
gui.objs["Title"]["BorderColor3"] = Color3.fromRGB(151, 151, 151)
gui.objs["Title"]["Name"] = [[Title]]

gui.objs["TIcon"] = Instance.new("ImageLabel", gui.objs["Title"])
gui.objs["TIcon"]["Image"] = [[http://www.roblox.com/asset/?id=85057566236357]]
gui.objs["TIcon"]["ImageRectSize"] = Vector2.new(16, 16)
gui.objs["TIcon"]["Size"] = UDim2.new(0, 20, 0, 20)
gui.objs["TIcon"]["BackgroundTransparency"] = 1
gui.objs["TIcon"]["ImageRectOffset"] = Vector2.new(144, 0)
gui.objs["TIcon"]["Name"] = [[Icon]]
gui.objs["TIcon"]["Position"] = UDim2.new(0, 0, 0, 4)

gui.objs["TextTitle"] = Instance.new("TextLabel", gui.objs["Title"])
gui.objs["TextTitle"]["TextWrapped"] = true
gui.objs["TextTitle"]["TextXAlignment"] = Enum.TextXAlignment.Left
gui.objs["TextTitle"]["TextScaled"] = true
gui.objs["TextTitle"]["FontFace"] =
	Font.new([[rbxasset://fonts/families/Inconsolata.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal)
gui.objs["TextTitle"]["TextColor3"] = Color3.fromRGB(0, 0, 0)
gui.objs["TextTitle"]["BackgroundTransparency"] = 1
gui.objs["TextTitle"]["Size"] = UDim2.new(0, 570, 0, 21)
gui.objs["TextTitle"]["Text"] = [[Remote Hijacker | v0.2]]
gui.objs["TextTitle"]["Name"] = [[Title]]
gui.objs["TextTitle"]["Position"] = UDim2.new(0, 20, 0, 4)

gui.objs["Actionbar"] = Instance.new("Frame", gui.objs["MainFrame"])
gui.objs["Actionbar"]["ZIndex"] = 2
gui.objs["Actionbar"]["BorderSizePixel"] = 2
gui.objs["Actionbar"]["BackgroundColor3"] = Color3.fromRGB(211, 211, 211)
gui.objs["Actionbar"]["Size"] = UDim2.new(0, 600, 0, 20)
gui.objs["Actionbar"]["Position"] = UDim2.new(0, 0, 0, 30)
gui.objs["Actionbar"]["BorderColor3"] = Color3.fromRGB(151, 151, 151)
gui.objs["Actionbar"]["Name"] = [[Actionbar]]

gui.objs["ClearButton"] = Instance.new("Frame", gui.objs["Actionbar"])
gui.objs["ClearButton"]["ZIndex"] = 2
gui.objs["ClearButton"]["BorderSizePixel"] = 2
gui.objs["ClearButton"]["BackgroundColor3"] = Color3.fromRGB(234, 234, 234)
gui.objs["ClearButton"]["Size"] = UDim2.new(0, 70, 0, 20)
gui.objs["ClearButton"]["BorderColor3"] = Color3.fromRGB(151, 151, 151)
gui.objs["ClearButton"]["Name"] = [[Clear]]

gui.objs["Text"] = Instance.new("TextLabel", gui.objs["ClearButton"])
gui.objs["Text"]["ZIndex"] = 2
gui.objs["Text"]["BorderSizePixel"] = 0
gui.objs["Text"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
gui.objs["Text"]["TextSize"] = 14
gui.objs["Text"]["FontFace"] =
	Font.new([[rbxasset://fonts/families/Inconsolata.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal)
gui.objs["Text"]["TextColor3"] = Color3.fromRGB(0, 0, 0)
gui.objs["Text"]["BackgroundTransparency"] = 1
gui.objs["Text"]["Size"] = UDim2.new(1, 0, 1, 0)
gui.objs["Text"]["BorderColor3"] = Color3.fromRGB(0, 0, 0)
gui.objs["Text"]["Text"] = [[Clear]]

gui.objs["Actionbar2"] = Instance.new("Frame", gui.objs["MainFrame"])
gui.objs["Actionbar2"]["BorderSizePixel"] = 0
gui.objs["Actionbar2"]["BackgroundColor3"] = Color3.fromRGB(211, 211, 211)
gui.objs["Actionbar2"]["Size"] = UDim2.new(0, 158, 0, 221)
gui.objs["Actionbar2"]["Position"] = UDim2.new(0, 432, 0, 165)
gui.objs["Actionbar2"]["BorderColor3"] = Color3.fromRGB(151, 151, 151)
gui.objs["Actionbar2"]["Name"] = [[Actionbar2]]

gui.objs["RunButton"] = Instance.new("Frame", gui.objs["Actionbar2"])
gui.objs["RunButton"]["BorderSizePixel"] = 2
gui.objs["RunButton"]["BackgroundColor3"] = Color3.fromRGB(234, 234, 234)
gui.objs["RunButton"]["Size"] = UDim2.new(0, 70, 0, 20)
gui.objs["RunButton"]["BorderColor3"] = Color3.fromRGB(151, 151, 151)
gui.objs["RunButton"]["Name"] = [[Run]]

gui.objs["RunText"] = Instance.new("TextLabel", gui.objs["RunButton"])
gui.objs["RunText"]["BorderSizePixel"] = 0
gui.objs["RunText"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
gui.objs["RunText"]["TextSize"] = 14
gui.objs["RunText"]["FontFace"] =
	Font.new([[rbxasset://fonts/families/Inconsolata.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal)
gui.objs["RunText"]["TextColor3"] = Color3.fromRGB(0, 0, 0)
gui.objs["RunText"]["BackgroundTransparency"] = 1
gui.objs["RunText"]["Size"] = UDim2.new(1, 0, 1, 0)
gui.objs["RunText"]["BorderColor3"] = Color3.fromRGB(0, 0, 0)
gui.objs["RunText"]["Text"] = [[Run]]

gui.objs["CopyCodeButton"] = Instance.new("Frame", gui.objs["Actionbar2"])
gui.objs["CopyCodeButton"]["BorderSizePixel"] = 2
gui.objs["CopyCodeButton"]["BackgroundColor3"] = Color3.fromRGB(234, 234, 234)
gui.objs["CopyCodeButton"]["Size"] = UDim2.new(0, 70, 0, 20)
gui.objs["CopyCodeButton"]["Position"] = UDim2.new(0, 87, 0, 0)
gui.objs["CopyCodeButton"]["BorderColor3"] = Color3.fromRGB(151, 151, 151)
gui.objs["CopyCodeButton"]["Name"] = [[CopyCode]]

gui.objs["CopyCodeText"] = Instance.new("TextLabel", gui.objs["CopyCodeButton"])
gui.objs["CopyCodeText"]["BorderSizePixel"] = 0
gui.objs["CopyCodeText"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
gui.objs["CopyCodeText"]["TextSize"] = 14
gui.objs["CopyCodeText"]["FontFace"] =
	Font.new([[rbxasset://fonts/families/Inconsolata.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal)
gui.objs["CopyCodeText"]["TextColor3"] = Color3.fromRGB(0, 0, 0)
gui.objs["CopyCodeText"]["BackgroundTransparency"] = 1
gui.objs["CopyCodeText"]["Size"] = UDim2.new(1, 0, 1, 0)
gui.objs["CopyCodeText"]["BorderColor3"] = Color3.fromRGB(0, 0, 0)
gui.objs["CopyCodeText"]["Text"] = [[Copy code]]

gui.objs["BlockButton"] = Instance.new("Frame", gui.objs["Actionbar2"])
gui.objs["BlockButton"]["BorderSizePixel"] = 2
gui.objs["BlockButton"]["BackgroundColor3"] = Color3.fromRGB(234, 234, 234)
gui.objs["BlockButton"]["Size"] = UDim2.new(0, 70, 0, 20)
gui.objs["BlockButton"]["Position"] = UDim2.new(0, 0, 0, 35)
gui.objs["BlockButton"]["BorderColor3"] = Color3.fromRGB(151, 151, 151)
gui.objs["BlockButton"]["Name"] = [[Block]]

gui.objs["BlockText"] = Instance.new("TextLabel", gui.objs["BlockButton"])
gui.objs["BlockText"]["BorderSizePixel"] = 0
gui.objs["BlockText"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
gui.objs["BlockText"]["TextSize"] = 14
gui.objs["BlockText"]["FontFace"] =
	Font.new([[rbxasset://fonts/families/Inconsolata.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal)
gui.objs["BlockText"]["TextColor3"] = Color3.fromRGB(0, 0, 0)
gui.objs["BlockText"]["BackgroundTransparency"] = 1
gui.objs["BlockText"]["Size"] = UDim2.new(1, 0, 1, 0)
gui.objs["BlockText"]["BorderColor3"] = Color3.fromRGB(0, 0, 0)
gui.objs["BlockText"]["Text"] = [[Block]]

gui.objs["CodeSpace"] = Instance.new("ScrollingFrame", gui.objs["MainFrame"])
gui.objs["CodeSpace"].Name = "CodeSpace"
gui.objs["CodeSpace"].Active = true
gui.objs["CodeSpace"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
gui.objs["CodeSpace"].BorderColor3 = Color3.fromRGB(0, 0, 0)
gui.objs["CodeSpace"].BorderSizePixel = 0
gui.objs["CodeSpace"].Position = UDim2.new(0, 12, 0, 166)
gui.objs["CodeSpace"].Size = UDim2.new(0, 408, 0, 221)
gui.objs["CodeSpace"].BottomImage = "rbxassetid://122693187016793"
gui.objs["CodeSpace"].CanvasSize = UDim2.new(0, 0, 0, 0)
gui.objs["CodeSpace"].MidImage = "rbxassetid://122693187016793"
gui.objs["CodeSpace"].TopImage = "rbxassetid://122693187016793"

gui.objs["CodeSpaceLines"] = Instance.new("TextLabel", gui.objs["MainFrame"])
gui.objs["CodeSpaceLines"].Parent = gui.objs["CodeSpace"]
gui.objs["CodeSpaceLines"].BackgroundColor3 = Color3.fromRGB(175, 175, 175)
gui.objs["CodeSpaceLines"].BorderColor3 = Color3.fromRGB(0, 0, 0)
gui.objs["CodeSpaceLines"].BorderSizePixel = 0
gui.objs["CodeSpaceLines"].Size = UDim2.new(0, 20, 1, 0)
gui.objs["CodeSpaceLines"].Font = Enum.Font.SourceSans
gui.objs["CodeSpaceLines"].Text = "1"
gui.objs["CodeSpaceLines"].TextColor3 = Color3.fromRGB(0, 0, 0)
gui.objs["CodeSpaceLines"].TextSize = 17.000
gui.objs["CodeSpaceLines"].TextWrapped = true
gui.objs["CodeSpaceLines"].TextXAlignment = Enum.TextXAlignment.Right
gui.objs["CodeSpaceLines"].TextYAlignment = Enum.TextYAlignment.Top

gui.objs["CodeSpaceInput"] = Instance.new("TextBox", gui.objs["MainFrame"])
gui.objs["CodeSpaceInput"].Parent = gui.objs["CodeSpace"]
gui.objs["CodeSpaceInput"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
gui.objs["CodeSpaceInput"].BackgroundTransparency = 0.800
gui.objs["CodeSpaceInput"].BorderColor3 = Color3.fromRGB(0, 0, 0)
gui.objs["CodeSpaceInput"].BorderSizePixel = 0
gui.objs["CodeSpaceInput"].Position = UDim2.new(0, 23, 0, -1)
gui.objs["CodeSpaceInput"].Size = UDim2.new(0, 373, 0, 221)
gui.objs["CodeSpaceInput"].ClearTextOnFocus = false
gui.objs["CodeSpaceInput"].RichText = true
gui.objs["CodeSpaceInput"].FontFace = gui.font.Inconsolata
gui.objs["CodeSpaceInput"].TextEditable = false
gui.objs["CodeSpaceInput"].MultiLine = true
gui.objs["CodeSpaceInput"].Text = ""
gui.objs["CodeSpaceInput"].TextColor3 = Color3.fromRGB(0, 0, 0)
gui.objs["CodeSpaceInput"].TextSize = 17.000
gui.objs["CodeSpaceInput"].TextWrapped = true
gui.objs["CodeSpaceInput"].TextXAlignment = Enum.TextXAlignment.Left
gui.objs["CodeSpaceInput"].TextYAlignment = Enum.TextYAlignment.Top

gui.objs["Explorer"] = Instance.new("Frame", gui.objs["MainFrame"])
gui.objs["Explorer"]["BorderSizePixel"] = 0
gui.objs["Explorer"]["ClipsDescendants"] = true
gui.objs["Explorer"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
gui.objs["Explorer"]["Size"] = UDim2.new(0, 389, 0, 104)
gui.objs["Explorer"]["Position"] = UDim2.new(0, 201, 0, 50)
gui.objs["Explorer"]["BorderColor3"] = Color3.fromRGB(56, 56, 56)
gui.objs["Explorer"]["Name"] = "Explorer"

gui.objs["ExplorerText"] = Instance.new("TextLabel")
gui.objs["ExplorerText"].Parent = gui.objs["Explorer"]
gui.objs["ExplorerText"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
gui.objs["ExplorerText"].BackgroundTransparency = 1.000
gui.objs["ExplorerText"].BorderColor3 = Color3.fromRGB(0, 0, 0)
gui.objs["ExplorerText"].BorderSizePixel = 0
gui.objs["ExplorerText"].Position = UDim2.new(0, 6, 0, 8)
gui.objs["ExplorerText"].Size = UDim2.new(2, 0, 0, 88)
gui.objs["ExplorerText"].Font = Enum.Font.Code
gui.objs["ExplorerText"].RichText = true
gui.objs["ExplorerText"].Text = ""
gui.objs["ExplorerText"].TextWrapped = true
gui.objs["ExplorerText"].TextColor3 = Color3.fromRGB(0, 0, 0)
gui.objs["ExplorerText"].TextSize = 14
gui.objs["ExplorerText"].TextXAlignment = Enum.TextXAlignment.Left
gui.objs["ExplorerText"].TextYAlignment = Enum.TextYAlignment.Top

gui.objs["ExplorerIcon1"] = Instance.new("ImageLabel")
gui.objs["ExplorerIcon1"].Parent = gui.objs["Explorer"]
gui.objs["ExplorerIcon1"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
gui.objs["ExplorerIcon1"].BackgroundTransparency = 1.000
gui.objs["ExplorerIcon1"].BorderColor3 = Color3.fromRGB(0, 0, 0)
gui.objs["ExplorerIcon1"].BorderSizePixel = 0
gui.objs["ExplorerIcon1"].Position = UDim2.new(0, 15, 0, 23)
gui.objs["ExplorerIcon1"].Size = UDim2.new(0, 16, 0, 16)
gui.objs["ExplorerIcon1"].Visible = false
gui.objs["ExplorerIcon1"].Image = "http://www.roblox.com/asset/?id=85057566236357"
gui.objs["ExplorerIcon1"].ImageRectOffset = Vector2.new(80, 0)
gui.objs["ExplorerIcon1"].ImageRectSize = Vector2.new(16, 16)

gui.objs["ExplorerIcon2"] = Instance.new("ImageLabel")
gui.objs["ExplorerIcon2"].Parent = gui.objs["Explorer"]
gui.objs["ExplorerIcon2"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
gui.objs["ExplorerIcon2"].BackgroundTransparency = 1.000
gui.objs["ExplorerIcon2"].BorderColor3 = Color3.fromRGB(0, 0, 0)
gui.objs["ExplorerIcon2"].BorderSizePixel = 0
gui.objs["ExplorerIcon2"].Position = UDim2.new(0, 15, 0, 42)
gui.objs["ExplorerIcon2"].Size = UDim2.new(0, 16, 0, 16)
gui.objs["ExplorerIcon2"].Visible = false
gui.objs["ExplorerIcon2"].Image = "http://www.roblox.com/asset/?id=85057566236357"
gui.objs["ExplorerIcon2"].ImageRectOffset = Vector2.new(80, 0)
gui.objs["ExplorerIcon2"].ImageRectSize = Vector2.new(16, 16)

gui.objs["ExplorerLoad"] = Instance.new("Frame")
gui.objs["ExplorerLoad"].Parent = gui.objs["Explorer"]
gui.objs["ExplorerLoad"].AnchorPoint = Vector2.new(0, 1)
gui.objs["ExplorerLoad"].BackgroundColor3 = Color3.fromRGB(117, 194, 35)
gui.objs["ExplorerLoad"].BorderColor3 = Color3.fromRGB(0, 0, 0)
gui.objs["ExplorerLoad"].BorderSizePixel = 0
gui.objs["ExplorerLoad"].Position = UDim2.new(0, 0, 1, 0)
gui.objs["ExplorerLoad"].ZIndex = 2
gui.objs["ExplorerLoad"].Size = UDim2.new(0, 0, 0, 4)

gui.objs["ExplorerScroll"] = Instance.new("Frame", gui.objs["Explorer"])
gui.objs["ExplorerScroll"].AnchorPoint = Vector2.new(0, 1)
gui.objs["ExplorerScroll"].BackgroundColor3 = Color3.fromRGB(171, 171, 171)
gui.objs["ExplorerScroll"].BorderColor3 = Color3.fromRGB(0, 0, 0)
gui.objs["ExplorerScroll"].BorderSizePixel = 0
gui.objs["ExplorerScroll"].Position = UDim2.new(0, 0, 1, 0)
gui.objs["ExplorerScroll"].Size = UDim2.new(0.2, 0, 0, 4)
local scrolling = false
do
	local UserInputService = game:GetService("UserInputService")

	local guii = gui.objs["ExplorerScroll"]

	local dragging
	local dragInput
	local dragStart
	local startPos

	local startTextX = gui.objs["ExplorerText"].Position.X.Offset
	local startImgX = gui.objs["ExplorerIcon1"].Position.X.Offset

	local function update(input)
		local delta = input.Position - dragStart
		guii.Position = UDim2.new(0, math.clamp(startPos.X.Offset + delta.X, 0, gui.objs["Explorer"]["AbsoluteSize"].X-gui.objs["ExplorerScroll"].AbsoluteSize.X), 1, 0)
		gui.objs["ExplorerText"].Position = UDim2.fromOffset(startTextX-guii.Position.X.Offset,gui.objs["ExplorerText"].Position.Y.Offset)
		gui.objs["ExplorerIcon1"].Position = UDim2.fromOffset(startImgX-guii.Position.X.Offset,gui.objs["ExplorerIcon1"].Position.Y.Offset)
	end

	guii.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			scrolling = true
			dragStart = input.Position
			startPos = guii.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
					scrolling = false
				end
			end)
		end
	end)

	guii.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			update(input)
		end
	end)
end

function gui:OnClick(button, connected)
    button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            connected(input)
        end
    end)
end

do
	local UserInputService = game:GetService("UserInputService")

	local gui = gui.objs["MainFrame"]

	local dragging
	local dragInput
	local dragStart
	local startPos

	local function update(input)
		local delta = input.Position - dragStart
		gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end

	gui.InputBegan:Connect(function(input)
		if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and not scrolling then
			dragging = true
			dragStart = input.Position
			startPos = gui.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	gui.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			update(input)
		end
	end)
end


local markup = {
    cyan = {"getrawmetatable", "newcclosure", "islclosure", "setclipboard", "game", "workspace", "script", "math", "string", "table", "print", "wait", "BrickColor", "Color3", "next", "pairs", "ipairs", "select", "Instance", "Vector2", "Vector3", "CFrame", "Ray", "UDim2", "Enum", "assert", "error", "warn", "tick", "loadstring", "_G", "shared", "getfenv", "setfenv", "newproxy", "setmetatable", "getmetatable", "os", "debug", "pcall", "ypcall", "xpcall", "rawequal", "rawset", "rawget", "tonumber", "tostring","_VERSION", "coroutine", "delay", "require", "spawn", "LoadLibrary", "settings", "stats", "time", "UserSettings", "version", "Axes", "ColorSequence", "Faces", "ColorSequenceKeypoint", "NumberRange", "NumberSequence", "NumberSequenceKeypoint", "gcinfo", "elapsedTime", "collectgarbage", "PhysicalProperties", "Rect", "Region3", "Region3int16", "UDim", "Vector2int16", "Vector3int16", "load"},
    redB = {"and", "break", "do", "else", "elseif", "end", "for", "function", "goto", "if", "in", "local", "not", "or", "repeat", "return", "then", "until", "while", "unpack"},
    yellowB = {"false", "true", "nil"},
    yellow = {"WaitForChild", "FindFirstChild", "GetService"},
}

local syntaxPatterns = {
    [ [=[(%".-%")]=] ] = [[<font color='rgb(103,137,56)'>%1</font>]],
    --["(%-%-[^\%n]*)"] = [[<font color='rgb(102,102,102)'>%1</font>]],
    ["(%-%-%[%[.-%]%])"] = [[<font color='rgb(102,102,102)'>%1</font>]],
    --["(%d+)"] = [[<font color='rgb(102,102,102)'>%1</font>]],
}

for _,name in pairs(markup.cyan) do
    syntaxPatterns["("..name..")"] = [[<font color='rgb(132,213,246)'>%1</font>]]
end

for _,name in pairs(markup.redB) do
    syntaxPatterns["("..name.."%s+)"] = [[<font color='rgb(248,109,124)'><b>%1</b></font>]]
end

for _,name in pairs(markup.yellowB) do
    syntaxPatterns["("..name.."%s+)"] = [[<font color='rgb(255,198,0)'><b>%1</b></font>]]
end

for _,name in pairs(markup.yellow) do
    syntaxPatterns["("..name.."%s+)"] = [[<font color='rgb(246,244,168)'><b>%1</b></font>]]
end


function HighlightSyntax(source)
	for pattern, repl in pairs(syntaxPatterns) do
		source = string.gsub(source, pattern, repl)
	end
	return source
end
local function LinesSplit(str)
    lines = {}
    for s in str:gmatch("[^\r\n]+") do
        table.insert(lines, s)
    end
    return lines
end

local scriptMarkup = ""
local defText = ""

function gui:Traceback(code)
    gui.objs["ExplorerText"].Text = code
end

function gui:ChangeCode(code)
    defText = code
	scriptMarkup = HighlightSyntax(code)
	local split = LinesSplit(code)
	local linesOut = ""
	for i = 1, #split do
		linesOut = linesOut .. i .. "\n"
	end
	gui.objs["CodeSpaceLines"].Text = linesOut
    gui.objs["CodeSpaceInput"].Text = scriptMarkup
end

gui.objs["CodeSpaceInput"].Focused:Connect(function()
    gui.objs["CodeSpaceInput"].Text = defText
end)
gui.objs["CodeSpaceInput"].FocusLost:Connect(function()
    gui.objs["CodeSpaceInput"].Text = scriptMarkup
end)

gui:ChangeCode([=[]=])

local gameMT = getrawmetatable(game)
print(serializeTable(gameMT))
local old = gameMT.__namecall
setreadonly(gameMT, false)

local events = {}
local blockedEvents = {}
local selectedEvent = {}

local lastE = 0
spawn(function()
	game:GetService("RunService").RenderStepped:Connect(function()
		if lastE ~= #events then
			lastE = #events

			local ColorType = {
				RemoteEvent = Color3.fromRGB(255, 255, 0),
				BindableEvent = Color3.fromRGB(255, 255, 0),
				RemoteFunction = Color3.fromRGB(255, 0, 255),
				BindableFunction = Color3.fromRGB(255, 0, 255),
			}

			local IconType = {
				RemoteEvent = 1,
				BindableEvent = 3,
				RemoteFunction = 0,
				BindableFunction = 2,
			}

			events[lastE]["Visual"] = {}
			events[lastE]["Visual"]["Object"] = Instance.new("Frame", gui.objs["RemoteList"])
			events[lastE]["Visual"]["Object"]["BorderSizePixel"] = 2
			events[lastE]["Visual"]["Object"]["BackgroundColor3"] = Color3.fromRGB(211, 211, 211)
			events[lastE]["Visual"]["Object"]["Size"] = UDim2.new(0, 150, 0, 20)
			events[lastE]["Visual"]["Object"]["Position"] = UDim2.new(0, 12, 0, 10)
			events[lastE]["Visual"]["Object"]["BorderColor3"] = Color3.fromRGB(151, 151, 151)
			events[lastE]["Visual"]["Object"]["Name"] = [[Ex]]

			events[lastE]["Visual"]["Underline"] = Instance.new("Frame", events[lastE]["Visual"]["Object"])
			events[lastE]["Visual"]["Underline"]["BorderSizePixel"] = 0
			events[lastE]["Visual"]["Underline"]["BackgroundColor3"] = ColorType[events[lastE]["Remote"].ClassName]
			events[lastE]["Visual"]["Underline"]["AnchorPoint"] = Vector2.new(0, 1)
			events[lastE]["Visual"]["Underline"]["Size"] = UDim2.new(0, 150, 0, 4)
			events[lastE]["Visual"]["Underline"]["Position"] = UDim2.new(0, 0, 1, 0)
			events[lastE]["Visual"]["Underline"]["BorderColor3"] = Color3.fromRGB(0, 0, 0)
			events[lastE]["Visual"]["Underline"]["Name"] = [[Underline]]

			events[lastE]["Visual"]["Title"] = Instance.new("TextLabel", events[lastE]["Visual"]["Object"])
			events[lastE]["Visual"]["Title"]["BorderSizePixel"] = 0
			events[lastE]["Visual"]["Title"]["TextXAlignment"] = Enum.TextXAlignment.Left
			events[lastE]["Visual"]["Title"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
			events[lastE]["Visual"]["Title"]["TextSize"] = 14
			events[lastE]["Visual"]["Title"]["FontFace"] = Font.new([[rbxasset://fonts/families/Inconsolata.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal)
			events[lastE]["Visual"]["Title"]["TextColor3"] = Color3.fromRGB(0, 0, 0)
			events[lastE]["Visual"]["Title"]["BackgroundTransparency"] = 1
			events[lastE]["Visual"]["Title"]["Size"] = UDim2.new(0.84667, 0, 1, -4)
			events[lastE]["Visual"]["Title"]["BorderColor3"] = Color3.fromRGB(0, 0, 0)
			events[lastE]["Visual"]["Title"]["Text"] = events[lastE]["RemoteName"]
			events[lastE]["Visual"]["Title"]["Name"] = [[Title]]
			events[lastE]["Visual"]["Title"]["Position"] = UDim2.new(0.15333, 0, 0, 0)

			events[lastE]["Visual"]["RLIcon"] = Instance.new("ImageLabel", events[lastE]["Visual"]["Object"])
			events[lastE]["Visual"]["RLIcon"]["BorderSizePixel"] = 0
			events[lastE]["Visual"]["RLIcon"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
			events[lastE]["Visual"]["RLIcon"]["Image"] = [[http://www.roblox.com/asset/?id=85057566236357]]
			events[lastE]["Visual"]["RLIcon"]["ImageRectSize"] = Vector2.new(16, 16)
			events[lastE]["Visual"]["RLIcon"]["Size"] = UDim2.new(0, 16, 0, 16)
			events[lastE]["Visual"]["RLIcon"]["BorderColor3"] = Color3.fromRGB(0, 0, 0)
			events[lastE]["Visual"]["RLIcon"]["BackgroundTransparency"] = 1
			events[lastE]["Visual"]["RLIcon"]["ImageRectOffset"] = Vector2.new(16 * IconType[events[lastE]["Remote"].ClassName], 0)
			events[lastE]["Visual"]["RLIcon"]["Name"] = [[Icon]]

			------------------
			events[lastE]["Visual"]["Object"].Position = UDim2.fromOffset(12, 10 + (25 * (lastE - 1)))
			gui.objs["RemoteList"]["CanvasSize"] = UDim2.new(0, 0, 0, 35 + (25 * (lastE - 1)))

			events[lastE]["CompiledScript"] = "local args = "..serializeTable( events[lastE]["Arguments"] ).."\n \n"..getPath(events[lastE]["Remote"])..":"..events[lastE]["ExecuteType"] .."(unpack(args))"
			local oldId = lastE
			events[lastE]["ScriptPath"] = getPath(events[lastE]["Script"])
			events[lastE]["RemotePath"] = getPath(events[lastE]["Remote"])
			
            events[lastE]["Visual"]["Object"].InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
					gui:ChangeCode(events[oldId]["CompiledScript"])
					selectedEvent = events[oldId]
					gui.objs["ExplorerIcon1"].Visible = false
					gui:Traceback("")
					local timer = math.random(1,10)/10
					game:GetService("TweenService"):Create(gui.objs["ExplorerLoad"], TweenInfo.new(timer), {Size = UDim2.new(1, 0, 0, 4)}):Play()
					wait(timer)
					gui:Traceback(
	[[<font color='rgb(248,109,124)'><b>Traceback</b></font>:
		]]..events[oldId]["ScriptPath"]..[[<font color='rgb(125, 149, 255)'><b></b></font>]])
					gui.objs["ExplorerIcon1"].Visible = true
					wait(0.05)
					gui.objs["ExplorerLoad"].Size = UDim2.new(0, 0, 0, 4)
				end
            end)
		end
	end)
end)

local eventsCN = {"RemoteEvent","RemoteFunction","BindableEvent","BindableFunction"}

gameMT.__namecall = newcclosure(function(self, ...)
	local args = { ... }
	local method = (getnamecallmethod ~= nil and getnamecallmethod()) or "NGNM"
	if method == "FireServer" or method == "InvokeServer" or method == "Fire" or method == "Invoke" or method == "NGNM" then
		local callerScript = rawget(getfenv(0), "script")
		if callerScript and callerScript.Name == "CameraInput" and self.Name == "Event" then
			return old(self, ...)
		end
		local remote = self
		if method == "NGNM" then
			if remote.ClassName == "BindableEvent" then
				method = "Fire"
			elseif remote.ClassName == "BindableFunction" then
				method = "Invoke"
			elseif remote.ClassName == "RemoteEvent" then
				method = "FireServer"
			elseif remote.ClassName == "RemoteFunction" then	
				method = "InvokeServer"
			end
		end
		local accessed = false
		for _,cName in pairs(eventsCN) do
			if remote.ClassName == cName then
				accessed = true
			end
		end
		if not accessed then
			return old(self, ...)
		end
		local id = #events + 1

		local nEv = {}

		nEv["Arguments"] = args
        nEv["ExecuteType"] = method

		nEv["Remote"] = remote
		nEv["RemoteName"] = self.Name
		--nEv["Traceback"] = debug.info(gameMT.__namecall)

		nEv["Script"] = callerScript
		nEv["ScriptName"] = callerScript.Name
		--nEv["ScriptPath"] = callerScript.GetFullName(callerScript)

        for _,remote in pairs(blockedEvents) do
            if nEv["Remote"] == remote then
				return old(self, ...)
            end
        end

        events[id] = nEv
		
		print("Event:", nEv["RemoteName"])
	end
	return old(self, ...)
end)

gui:OnClick(gui.objs["RunButton"], function(input)
    loadstring(defText)()
end)

gui:OnClick(gui.objs["CopyCodeButton"], function(input)
    setclipboard(defText)
end)

gui:OnClick(gui.objs["BlockButton"], function(input)
    local id = #blockedEvents+1
    blockedEvents[id] = selectedEvent["Remote"]
end)

gui:OnClick(gui.objs["ClearButton"], function(input)
	gui.objs["RemoteList"]["CanvasSize"] = UDim2.new(0, 0, 0, 0)
    for index,obj in pairs(events) do
		spawn(function ()
			obj["Visual"]["Object"]:Destroy()
        	events[index] = nil
		end)
    end
end)

gui:OnClick(gui.objs["Explorer"], function(input)
	if selectedEvent["ScriptPath"] then
		setclipboard(selectedEvent["ScriptPath"])
	end
end)
