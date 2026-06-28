--[[
    ██╗  ██╗███████╗██████╗  █████╗     ██╗   ██╗██╗    ██╗██╗██████╗     
    ██║  ██║██╔════╝██╔══██╗██╔══██╗    ██║   ██║██║    ██║██║██╔══██╗    
    ███████║█████╗  ██████╔╝███████║    ██║   ██║██║    ██║██║██████╔╝    
    ██╔══██║██╔══╝  ██╔═══╝ ██╔══██║    ██║   ██║██║    ██║██║██╔══██╗    
    ██║  ██║███████╗██║     ██║  ██║    ╚██████╔╝╚██████╔╝██║██████╔╝    
    ╚═╝  ╚═╝╚══════╝╚═╝     ╚═╝  ╚═╝     ╚═════╝  ╚═════╝ ╚═╝╚═════╝     
    
    HepaUI Library v2.0.0
    Author: HepaUI
    Description: Professional Roblox UI Library with full mobile support,
                 custom keybinds, watermark, loader, animations, glow/shadow effects
    
    USAGE:
        local HepaUI = loadstring(game:HttpGet("..."))()
        
        local Loader = HepaUI:CreateLoader({
            Title = "My Cheat",
            SubTitle = "v1.0.0",
            Duration = 3,
        })
        
        local Window = HepaUI:CreateWindow({
            Title = "Hepa",
            SubTitle = "UI Library",
            TabWidth = 160,
        })
        
        local Tab = Window:AddTab("Aimbot", "rbxassetid://...")
        local Section = Tab:AddSection("General")
        Section:AddToggle("Enable", false, function(val) end)
]]

-- ============================================================
-- [1] SERVICES & GLOBALS
-- ============================================================
local RunService      = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService    = game:GetService("TweenService")
local Players         = game:GetService("Players")
local CoreGui         = game:GetService("CoreGui")
local TextService     = game:GetService("TextService")
local HttpService     = game:GetService("HttpService")

local LocalPlayer     = Players.LocalPlayer
local Mouse           = LocalPlayer:GetMouse()
local Camera          = workspace.CurrentCamera

-- ============================================================
-- [2] THEME / COLOR PALETTE  (matches screenshot exactly)
-- ============================================================
local Theme = {
    -- Backgrounds
    BG_Primary      = Color3.fromRGB(28,  28,  32 ),  -- main window bg
    BG_Secondary    = Color3.fromRGB(22,  22,  26 ),  -- sidebar, panels
    BG_Tertiary     = Color3.fromRGB(34,  34,  40 ),  -- section cards
    BG_Element      = Color3.fromRGB(40,  40,  48 ),  -- input fields, sliders
    BG_Hover        = Color3.fromRGB(50,  50,  60 ),
    BG_Active       = Color3.fromRGB(45,  38,  50 ),

    -- Accent (pink/rose from screenshot)
    Accent          = Color3.fromRGB(198, 100, 145 ),  -- primary pink
    AccentDark      = Color3.fromRGB(140,  60, 100 ),
    AccentLight     = Color3.fromRGB(230, 140, 175 ),
    AccentGlow      = Color3.fromRGB(198, 100, 145 ),

    -- Text
    Text_Primary    = Color3.fromRGB(230, 230, 235 ),
    Text_Secondary  = Color3.fromRGB(155, 155, 165 ),
    Text_Disabled   = Color3.fromRGB(90,  90,  100 ),
    Text_Accent     = Color3.fromRGB(210, 120, 160 ),

    -- Borders / Lines
    Border          = Color3.fromRGB(55,  55,  65 ),
    BorderActive    = Color3.fromRGB(198, 100, 145 ),
    Divider         = Color3.fromRGB(45,  45,  55 ),

    -- Slider fill
    SliderFill      = Color3.fromRGB(180,  80, 130 ),
    SliderBG        = Color3.fromRGB(38,  38,  46 ),

    -- Toggle
    ToggleOn        = Color3.fromRGB(198, 100, 145 ),
    ToggleOff       = Color3.fromRGB(55,  55,  65 ),
    ToggleKnob      = Color3.fromRGB(240, 240, 245 ),

    -- Checkbox
    CheckOn         = Color3.fromRGB(198, 100, 145 ),
    CheckOff        = Color3.fromRGB(38,  38,  46 ),

    -- Watermark
    Watermark_BG    = Color3.fromRGB(22,  22,  28 ),
    Watermark_Border= Color3.fromRGB(198, 100, 145 ),

    -- Loader
    Loader_BG       = Color3.fromRGB(18,  18,  22 ),
    Loader_Bar      = Color3.fromRGB(198, 100, 145 ),
    Loader_BarBG    = Color3.fromRGB(38,  38,  46 ),

    -- Notification
    Notif_BG        = Color3.fromRGB(28,  28,  35 ),
    Notif_Border    = Color3.fromRGB(198, 100, 145 ),

    -- Dropdown
    Dropdown_BG     = Color3.fromRGB(26,  26,  32 ),
    Dropdown_Item   = Color3.fromRGB(34,  34,  42 ),
    Dropdown_Hover  = Color3.fromRGB(50,  38,  56 ),

    -- Keybind list
    Keybind_BG      = Color3.fromRGB(22,  22,  28 ),
}

-- ============================================================
-- [3] TYPOGRAPHY / FONT
-- ============================================================
local Font = {
    Title   = Enum.Font.GothamBold,
    Bold    = Enum.Font.GothamBold,
    Semi    = Enum.Font.GothamSemibold,
    Body    = Enum.Font.Gotham,
    Mono    = Enum.Font.Code,
}

-- ============================================================
-- [4] ANIMATION PRESETS
-- ============================================================
local Anim = {
    Fast      = TweenInfo.new(0.12, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    Normal    = TweenInfo.new(0.20, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    Slow      = TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    Spring    = TweenInfo.new(0.40, Enum.EasingStyle.Back,  Enum.EasingDirection.Out),
    Bounce    = TweenInfo.new(0.50, Enum.EasingStyle.Bounce,Enum.EasingDirection.Out),
    Linear    = TweenInfo.new(0.20, Enum.EasingStyle.Linear),
    Slide     = TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
}

-- ============================================================
-- [5] UTILITY FUNCTIONS
-- ============================================================
local Util = {}

function Util.Tween(obj, info, props)
    local t = TweenService:Create(obj, info, props)
    t:Play()
    return t
end

function Util.Create(class, props, children)
    local obj = Instance.new(class)
    for k, v in pairs(props or {}) do
        if k ~= "Parent" then
            obj[k] = v
        end
    end
    for _, child in pairs(children or {}) do
        child.Parent = obj
    end
    if props and props.Parent then
        obj.Parent = props.Parent
    end
    return obj
end

function Util.AddGlow(frame, color, size, transparency)
    color = color or Theme.AccentGlow
    size  = size  or 12
    transparency = transparency or 0.85
    local glow = Util.Create("ImageLabel", {
        Name            = "Glow",
        Size            = UDim2.new(1, size*2, 1, size*2),
        Position        = UDim2.new(0, -size, 0, -size),
        BackgroundTransparency = 1,
        Image           = "rbxassetid://6014260067",
        ImageColor3     = color,
        ImageTransparency = transparency,
        ScaleType       = Enum.ScaleType.Slice,
        SliceCenter     = Rect.new(49, 49, 450, 450),
        ZIndex          = frame.ZIndex - 1,
        Parent          = frame,
    })
    return glow
end

function Util.AddShadow(frame, size, transparency)
    size = size or 15
    transparency = transparency or 0.7
    local shadow = Util.Create("ImageLabel", {
        Name            = "Shadow",
        Size            = UDim2.new(1, size*2, 1, size*2),
        Position        = UDim2.new(0, -size, 0, -size),
        BackgroundTransparency = 1,
        Image           = "rbxassetid://6014261993",
        ImageColor3     = Color3.fromRGB(0, 0, 0),
        ImageTransparency = transparency,
        ScaleType       = Enum.ScaleType.Slice,
        SliceCenter     = Rect.new(49, 49, 450, 450),
        ZIndex          = frame.ZIndex - 1,
        Parent          = frame,
    })
    return shadow
end

function Util.AddCorner(parent, radius)
    return Util.Create("UICorner", {
        CornerRadius = UDim.new(0, radius or 6),
        Parent = parent,
    })
end

function Util.AddPadding(parent, top, right, bottom, left)
    return Util.Create("UIPadding", {
        PaddingTop    = UDim.new(0, top    or 8),
        PaddingRight  = UDim.new(0, right  or 8),
        PaddingBottom = UDim.new(0, bottom or 8),
        PaddingLeft   = UDim.new(0, left   or 8),
        Parent        = parent,
    })
end

function Util.AddStroke(parent, color, thickness, transparency)
    return Util.Create("UIStroke", {
        Color        = color        or Theme.Border,
        Thickness    = thickness    or 1,
        Transparency = transparency or 0,
        Parent       = parent,
    })
end

function Util.GetTextSize(text, size, font, bound)
    return TextService:GetTextSize(text, size, font, bound or Vector2.new(1000, 1000))
end

function Util.IsMobile()
    return UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
end

function Util.Ripple(parent, x, y)
    local ripple = Util.Create("Frame", {
        Size            = UDim2.new(0, 0, 0, 0),
        Position        = UDim2.new(0, x, 0, y),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.85,
        ZIndex          = parent.ZIndex + 5,
        Parent          = parent,
    })
    Util.AddCorner(ripple, 999)
    local size = math.max(parent.AbsoluteSize.X, parent.AbsoluteSize.Y) * 2
    Util.Tween(ripple, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, size, 0, size),
        Position = UDim2.new(0, x - size/2, 0, y - size/2),
        BackgroundTransparency = 1,
    }):Completed:Connect(function()
        ripple:Destroy()
    end)
end

function Util.HoverEffect(frame, hoverColor, normalColor, useStroke)
    normalColor = normalColor or frame.BackgroundColor3
    frame.MouseEnter:Connect(function()
        Util.Tween(frame, Anim.Fast, {BackgroundColor3 = hoverColor})
    end)
    frame.MouseLeave:Connect(function()
        Util.Tween(frame, Anim.Fast, {BackgroundColor3 = normalColor})
    end)
end

function Util.Draggable(frame, dragHandle)
    dragHandle = dragHandle or frame
    local dragging, dragInput, startPos, startGuiPos
    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            startPos = input.Position
            startGuiPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    dragHandle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - startPos
            local newPos = UDim2.new(
                startGuiPos.X.Scale,
                startGuiPos.X.Offset + delta.X,
                startGuiPos.Y.Scale,
                startGuiPos.Y.Offset + delta.Y
            )
            frame.Position = newPos
        end
    end)
end

-- ============================================================
-- [6] ICON LIBRARY (Roblox-friendly asset IDs + inline SVG fallback labels)
-- ============================================================
local Icons = {
    aimbot       = "rbxassetid://11963556847",
    visuals      = "rbxassetid://11963550742",
    misc         = "rbxassetid://11963549329",
    configs      = "rbxassetid://11963547845",
    players      = "rbxassetid://11963551567",
    world        = "rbxassetid://11963553421",
    view         = "rbxassetid://11963552788",
    inventory    = "rbxassetid://11963548712",
    main         = "rbxassetid://11963549987",
    rage         = "rbxassetid://11963556240",
    legit        = "rbxassetid://11963555731",
    antiAim      = "rbxassetid://11963547123",
    check        = "rbxassetid://11963545762",
    close        = "rbxassetid://11963546312",
    minimize     = "rbxassetid://11963549701",
    arrow        = "rbxassetid://11963546827",
    keybind      = "rbxassetid://11963548201",
    search       = "rbxassetid://11963552011",
    notification = "rbxassetid://11963550213",
    user         = "rbxassetid://11963553789",
    settings     = "rbxassetid://11963552345",
    home         = "rbxassetid://11963548456",
    lock         = "rbxassetid://11963549178",
}

-- ============================================================
-- [7] SIGNAL CLASS  (lightweight event system)
-- ============================================================
local Signal = {}
Signal.__index = Signal

function Signal.new()
    return setmetatable({ _connections = {} }, Signal)
end

function Signal:Connect(fn)
    local conn = { _fn = fn, _signal = self }
    table.insert(self._connections, conn)
    function conn:Disconnect()
        for i, c in ipairs(self._signal._connections) do
            if c == self then table.remove(self._signal._connections, i) break end
        end
    end
    return conn
end

function Signal:Fire(...)
    for _, conn in ipairs(self._connections) do
        coroutine.wrap(conn._fn)(...)
    end
end

function Signal:Destroy()
    self._connections = {}
end

-- ============================================================
-- [8] NOTIFICATION SYSTEM
-- ============================================================
local NotificationManager = {}
NotificationManager.__index = NotificationManager

function NotificationManager.new(screenGui)
    local self = setmetatable({}, NotificationManager)
    self._holder = Util.Create("Frame", {
        Name            = "NotifHolder",
        Size            = UDim2.new(0, 300, 1, 0),
        Position        = UDim2.new(1, -310, 0, 0),
        BackgroundTransparency = 1,
        ZIndex          = 100,
        Parent          = screenGui,
    })
    local list = Util.Create("UIListLayout", {
        SortOrder       = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Bottom,
        Padding         = UDim.new(0, 8),
        Parent          = self._holder,
    })
    Util.AddPadding(self._holder, 8, 8, 8, 8)
    return self
end

function NotificationManager:Push(opts)
    opts = opts or {}
    local title    = opts.Title    or "Notification"
    local desc     = opts.Desc     or ""
    local duration = opts.Duration or 4
    local ntype    = opts.Type     or "Info"  -- Info, Success, Warning, Error

    local typeColors = {
        Info    = Theme.Accent,
        Success = Color3.fromRGB(100, 200, 120),
        Warning = Color3.fromRGB(220, 170, 60),
        Error   = Color3.fromRGB(220, 80,  80),
    }
    local accentColor = typeColors[ntype] or Theme.Accent

    local notif = Util.Create("Frame", {
        Name            = "Notification",
        Size            = UDim2.new(1, 0, 0, 0),
        BackgroundColor3 = Theme.Notif_BG,
        ClipsDescendants = true,
        ZIndex          = 100,
        Parent          = self._holder,
    })
    Util.AddCorner(notif, 8)
    Util.AddStroke(notif, accentColor, 1, 0.3)
    Util.AddShadow(notif, 10, 0.5)

    local leftBar = Util.Create("Frame", {
        Name            = "Bar",
        Size            = UDim2.new(0, 3, 1, 0),
        BackgroundColor3 = accentColor,
        ZIndex          = 101,
        Parent          = notif,
    })
    Util.AddCorner(leftBar, 3)

    local content = Util.Create("Frame", {
        Name            = "Content",
        Size            = UDim2.new(1, -16, 1, 0),
        Position        = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        ZIndex          = 101,
        Parent          = notif,
    })

    local titleLabel = Util.Create("TextLabel", {
        Size            = UDim2.new(1, 0, 0, 18),
        Position        = UDim2.new(0, 0, 0, 8),
        BackgroundTransparency = 1,
        Text            = title,
        TextColor3      = accentColor,
        TextSize        = 13,
        Font            = Font.Bold,
        TextXAlignment  = Enum.TextXAlignment.Left,
        ZIndex          = 102,
        Parent          = content,
    })

    local descLabel = Util.Create("TextLabel", {
        Size            = UDim2.new(1, 0, 0, 0),
        Position        = UDim2.new(0, 0, 0, 28),
        BackgroundTransparency = 1,
        Text            = desc,
        TextColor3      = Theme.Text_Secondary,
        TextSize        = 12,
        Font            = Font.Body,
        TextXAlignment  = Enum.TextXAlignment.Left,
        TextWrapped     = true,
        ZIndex          = 102,
        Parent          = content,
    })

    -- Progress bar
    local progBG = Util.Create("Frame", {
        Size            = UDim2.new(1, -10, 0, 2),
        Position        = UDim2.new(0, 5, 1, -6),
        BackgroundColor3 = Theme.BG_Element,
        ZIndex          = 102,
        Parent          = notif,
    })
    Util.AddCorner(progBG, 2)
    local prog = Util.Create("Frame", {
        Size            = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = accentColor,
        ZIndex          = 103,
        Parent          = progBG,
    })
    Util.AddCorner(prog, 2)

    -- Compute height
    local descHeight = math.max(16, TextService:GetTextSize(desc, 12, Font.Body, Vector2.new(270, 999)).Y)
    local totalHeight = 28 + descHeight + 16 + 10

    -- Animate in
    notif.Size = UDim2.new(1, 0, 0, 0)
    Util.Tween(notif, Anim.Spring, { Size = UDim2.new(1, 0, 0, totalHeight) })

    -- Progress tween
    Util.Tween(prog, TweenInfo.new(duration, Enum.EasingStyle.Linear), { Size = UDim2.new(0, 0, 1, 0) }):Completed:Connect(function()
        Util.Tween(notif, Anim.Normal, { Size = UDim2.new(1, 0, 0, 0) }):Completed:Connect(function()
            notif:Destroy()
        end)
    end)

    return notif
end

-- ============================================================
-- [9] KEYBIND LIST OVERLAY
-- ============================================================
local KeybindList = {}
KeybindList.__index = KeybindList

function KeybindList.new(screenGui)
    local self = setmetatable({}, KeybindList)
    self._keybinds = {}
    self._visible  = true

    self._frame = Util.Create("Frame", {
        Name            = "KeybindList",
        Size            = UDim2.new(0, 200, 0, 30),
        Position        = UDim2.new(0, 10, 1, -40),
        BackgroundColor3 = Theme.Keybind_BG,
        ClipsDescendants = false,
        ZIndex          = 80,
        Parent          = screenGui,
    })
    Util.AddCorner(self._frame, 6)
    Util.AddStroke(self._frame, Theme.Border, 1)
    Util.AddShadow(self._frame, 8, 0.6)
    Util.Draggable(self._frame)

    local header = Util.Create("Frame", {
        Name            = "Header",
        Size            = UDim2.new(1, 0, 0, 28),
        BackgroundColor3 = Theme.BG_Secondary,
        ZIndex          = 81,
        Parent          = self._frame,
    })
    Util.AddCorner(header, 6)

    Util.Create("TextLabel", {
        Size            = UDim2.new(1, -8, 1, 0),
        Position        = UDim2.new(0, 8, 0, 0),
        BackgroundTransparency = 1,
        Text            = "⌨  Keybinds",
        TextColor3      = Theme.Text_Accent,
        TextSize        = 12,
        Font            = Font.Bold,
        TextXAlignment  = Enum.TextXAlignment.Left,
        ZIndex          = 82,
        Parent          = header,
    })

    self._list = Util.Create("Frame", {
        Name            = "List",
        Size            = UDim2.new(1, 0, 0, 0),
        Position        = UDim2.new(0, 0, 0, 30),
        BackgroundTransparency = 1,
        ZIndex          = 81,
        Parent          = self._frame,
    })

    local layout = Util.Create("UIListLayout", {
        SortOrder       = Enum.SortOrder.LayoutOrder,
        Padding         = UDim.new(0, 1),
        Parent          = self._list,
    })
    Util.AddPadding(self._list, 2, 4, 2, 4)

    layout.Changed:Connect(function()
        self:_Resize()
    end)

    return self
end

function KeybindList:_Resize()
    local totalH = 30
    for _, child in ipairs(self._list:GetChildren()) do
        if child:IsA("Frame") then
            totalH = totalH + child.AbsoluteSize.Y + 1
        end
    end
    totalH = totalH + 8
    Util.Tween(self._frame, Anim.Fast, { Size = UDim2.new(0, 200, 0, totalH) })
end

function KeybindList:Add(label, key, callback)
    local row = Util.Create("Frame", {
        Name            = label,
        Size            = UDim2.new(1, 0, 0, 22),
        BackgroundTransparency = 1,
        ZIndex          = 82,
        Parent          = self._list,
    })

    Util.Create("TextLabel", {
        Size            = UDim2.new(0.6, 0, 1, 0),
        BackgroundTransparency = 1,
        Text            = label,
        TextColor3      = Theme.Text_Secondary,
        TextSize        = 11,
        Font            = Font.Body,
        TextXAlignment  = Enum.TextXAlignment.Left,
        ZIndex          = 83,
        Parent          = row,
    })

    local keyBadge = Util.Create("Frame", {
        Size            = UDim2.new(0, 60, 0, 18),
        Position        = UDim2.new(1, -64, 0.5, -9),
        BackgroundColor3 = Theme.BG_Element,
        ZIndex          = 83,
        Parent          = row,
    })
    Util.AddCorner(keyBadge, 4)
    Util.AddStroke(keyBadge, Theme.Border, 1)

    local keyLabel = Util.Create("TextLabel", {
        Size            = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text            = key or "None",
        TextColor3      = Theme.Accent,
        TextSize        = 11,
        Font            = Font.Semi,
        ZIndex          = 84,
        Parent          = keyBadge,
    })

    table.insert(self._keybinds, { label = label, key = key, badge = keyLabel, callback = callback, row = row })
    self:_Resize()

    return { keyLabel = keyLabel, row = row }
end

function KeybindList:Remove(label)
    for i, kb in ipairs(self._keybinds) do
        if kb.label == label then
            kb.row:Destroy()
            table.remove(self._keybinds, i)
            break
        end
    end
    self:_Resize()
end

function KeybindList:SetVisible(v)
    self._visible = v
    Util.Tween(self._frame, Anim.Fast, { BackgroundTransparency = v and 0 or 1 })
    for _, obj in ipairs(self._frame:GetDescendants()) do
        if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("ImageLabel") then
            Util.Tween(obj, Anim.Fast, { TextTransparency = v and 0 or 1, ImageTransparency = v and 0 or 1 })
        end
    end
end

-- ============================================================
-- [10] WATERMARK
-- ============================================================
local Watermark = {}
Watermark.__index = Watermark

function Watermark.new(screenGui, opts)
    local self = setmetatable({}, Watermark)
    opts = opts or {}
    self._text     = opts.Text     or "HepaUI"
    self._subtext  = opts.SubText  or ""
    self._position = opts.Position or UDim2.new(0.5, 0, 0, 10)
    self._visible  = true

    self._frame = Util.Create("Frame", {
        Name            = "Watermark",
        Size            = UDim2.new(0, 200, 0, 34),
        Position        = self._position,
        AnchorPoint     = Vector2.new(0.5, 0),
        BackgroundColor3 = Theme.Watermark_BG,
        ClipsDescendants = false,
        ZIndex          = 90,
        Parent          = screenGui,
    })
    Util.AddCorner(self._frame, 6)
    Util.AddStroke(self._frame, Theme.Watermark_Border, 1, 0.3)
    Util.AddGlow(self._frame, Theme.AccentGlow, 8, 0.88)
    Util.AddShadow(self._frame, 10, 0.6)
    Util.Draggable(self._frame)

    -- Accent left bar
    local bar = Util.Create("Frame", {
        Size            = UDim2.new(0, 2, 1, -8),
        Position        = UDim2.new(0, 5, 0, 4),
        BackgroundColor3 = Theme.Accent,
        ZIndex          = 91,
        Parent          = self._frame,
    })
    Util.AddCorner(bar, 2)

    self._label = Util.Create("TextLabel", {
        Name            = "Title",
        Size            = UDim2.new(1, -18, 0, 18),
        Position        = UDim2.new(0, 12, 0, 4),
        BackgroundTransparency = 1,
        Text            = self._text,
        TextColor3      = Theme.Text_Primary,
        TextSize        = 13,
        Font            = Font.Bold,
        TextXAlignment  = Enum.TextXAlignment.Left,
        ZIndex          = 92,
        Parent          = self._frame,
    })

    self._subLabel = Util.Create("TextLabel", {
        Name            = "SubTitle",
        Size            = UDim2.new(1, -18, 0, 14),
        Position        = UDim2.new(0, 12, 0, 20),
        BackgroundTransparency = 1,
        Text            = self._subtext,
        TextColor3      = Theme.Text_Secondary,
        TextSize        = 11,
        Font            = Font.Body,
        TextXAlignment  = Enum.TextXAlignment.Left,
        ZIndex          = 92,
        Parent          = self._frame,
    })

    -- FPS counter
    self._fpsLabel = Util.Create("TextLabel", {
        Name            = "FPS",
        Size            = UDim2.new(0, 60, 0, 14),
        Position        = UDim2.new(1, -65, 0, 4),
        BackgroundTransparency = 1,
        Text            = "0 FPS",
        TextColor3      = Theme.Accent,
        TextSize        = 11,
        Font            = Font.Semi,
        TextXAlignment  = Enum.TextXAlignment.Right,
        ZIndex          = 92,
        Parent          = self._frame,
    })

    -- Clock
    self._clockLabel = Util.Create("TextLabel", {
        Name            = "Clock",
        Size            = UDim2.new(0, 60, 0, 14),
        Position        = UDim2.new(1, -65, 0, 18),
        BackgroundTransparency = 1,
        Text            = "00:00",
        TextColor3      = Theme.Text_Secondary,
        TextSize        = 11,
        Font            = Font.Body,
        TextXAlignment  = Enum.TextXAlignment.Right,
        ZIndex          = 92,
        Parent          = self._frame,
    })

    -- Auto-resize
    self:_Resize()

    -- FPS loop
    local frameCount = 0
    local lastCheck  = tick()
    RunService.RenderStepped:Connect(function()
        frameCount = frameCount + 1
        local now = tick()
        if now - lastCheck >= 1 then
            self._fpsLabel.Text = frameCount .. " FPS"
            frameCount = 0
            lastCheck = now
        end
        -- Clock
        local t = os.time()
        self._clockLabel.Text = os.date("%H:%M", t)
    end)

    return self
end

function Watermark:_Resize()
    local mainW  = TextService:GetTextSize(self._text,    13, Font.Bold, Vector2.new(1000,50)).X
    local subW   = TextService:GetTextSize(self._subtext, 11, Font.Body, Vector2.new(1000,50)).X
    local width  = math.max(mainW, subW) + 90 + 18
    Util.Tween(self._frame, Anim.Fast, { Size = UDim2.new(0, width, 0, 34) })
end

function Watermark:SetText(text, subtext)
    self._text = text or self._text
    self._subtext = subtext or self._subtext
    self._label.Text    = self._text
    self._subLabel.Text = self._subtext
    self:_Resize()
end

function Watermark:SetVisible(v)
    self._visible = v
    Util.Tween(self._frame, Anim.Fast, { BackgroundTransparency = v and 0 or 1 })
end

function Watermark:Destroy()
    self._frame:Destroy()
end

-- ============================================================
-- [11] LOADER SCREEN
-- ============================================================
local function CreateLoader(opts)
    opts = opts or {}
    local title       = opts.Title     or "HepaUI"
    local subTitle    = opts.SubTitle  or "Loading..."
    local duration    = opts.Duration  or 3
    local tasks       = opts.Tasks     or {}  -- { "Initializing modules", "Loading assets" }
    local logo        = opts.Logo      or nil
    local showPerc    = opts.ShowPercentage ~= false
    local bgColor     = opts.BgColor   or Theme.Loader_BG
    local accentColor = opts.AccentColor or Theme.Accent
    local onComplete  = opts.OnComplete or function() end

    local gui = Util.Create("ScreenGui", {
        Name            = "HepaLoader",
        IgnoreGuiInset  = true,
        DisplayOrder    = 999,
        ResetOnSpawn    = false,
        ZIndexBehavior  = Enum.ZIndexBehavior.Sibling,
        Parent          = CoreGui,
    })

    -- Full background
    local bg = Util.Create("Frame", {
        Size            = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = bgColor,
        ZIndex          = 1,
        Parent          = gui,
    })

    -- Ambient particles (decorative dots)
    for i = 1, 20 do
        local dot = Util.Create("Frame", {
            Size            = UDim2.new(0, math.random(2, 6), 0, math.random(2, 6)),
            Position        = UDim2.new(math.random(0, 100)/100, 0, math.random(0, 100)/100, 0),
            BackgroundColor3 = accentColor,
            BackgroundTransparency = math.random(70, 95)/100,
            ZIndex          = 2,
            Parent          = bg,
        })
        Util.AddCorner(dot, 999)
        -- Subtle float animation
        local startY = dot.Position.Y.Scale
        local amplitude = math.random(2, 6) / 100
        local speed = math.random(1, 3) + math.random() * 2
        local offset = math.random(0, 100) / 100 * math.pi * 2
        RunService.RenderStepped:Connect(function()
            local t = tick()
            dot.Position = UDim2.new(dot.Position.X.Scale, 0,
                startY + math.sin(t * speed + offset) * amplitude, 0)
        end)
    end

    -- Center card
    local card = Util.Create("Frame", {
        Size            = UDim2.new(0, 380, 0, 260),
        Position        = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint     = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Theme.BG_Primary,
        ZIndex          = 3,
        Parent          = bg,
    })
    Util.AddCorner(card, 12)
    Util.AddStroke(card, accentColor, 1, 0.6)
    Util.AddGlow(card, accentColor, 18, 0.82)
    Util.AddShadow(card, 20, 0.5)

    -- Card top accent strip
    local topStrip = Util.Create("Frame", {
        Size            = UDim2.new(1, 0, 0, 3),
        BackgroundColor3 = accentColor,
        ZIndex          = 4,
        Parent          = card,
    })
    Util.AddCorner(topStrip, 3)

    -- Logo area
    if logo then
        local logoImg = Util.Create("ImageLabel", {
            Size            = UDim2.new(0, 48, 0, 48),
            Position        = UDim2.new(0.5, -24, 0, 22),
            BackgroundTransparency = 1,
            Image           = logo,
            ZIndex          = 4,
            Parent          = card,
        })
    end

    -- Title label
    local titleLabel = Util.Create("TextLabel", {
        Size            = UDim2.new(1, 0, 0, 36),
        Position        = UDim2.new(0, 0, 0, logo and 78 or 30),
        BackgroundTransparency = 1,
        Text            = title,
        TextColor3      = Theme.Text_Primary,
        TextSize        = 26,
        Font            = Font.Title,
        ZIndex          = 4,
        Parent          = card,
    })

    -- Accent "H" color (match screenshot logo style)
    -- SubTitle
    local subLabel = Util.Create("TextLabel", {
        Size            = UDim2.new(1, 0, 0, 20),
        Position        = UDim2.new(0, 0, 0, logo and 116 or 66),
        BackgroundTransparency = 1,
        Text            = subTitle,
        TextColor3      = Theme.Text_Secondary,
        TextSize        = 13,
        Font            = Font.Body,
        ZIndex          = 4,
        Parent          = card,
    })

    -- Task label
    local taskLabel = Util.Create("TextLabel", {
        Size            = UDim2.new(1, -40, 0, 18),
        Position        = UDim2.new(0, 20, 0, logo and 145 or 100),
        BackgroundTransparency = 1,
        Text            = tasks[1] or "Initializing...",
        TextColor3      = Theme.Text_Secondary,
        TextSize        = 12,
        Font            = Font.Body,
        TextXAlignment  = Enum.TextXAlignment.Left,
        ZIndex          = 4,
        Parent          = card,
    })

    -- Percentage
    local percLabel = Util.Create("TextLabel", {
        Size            = UDim2.new(0, 50, 0, 18),
        Position        = UDim2.new(1, -60, 0, logo and 145 or 100),
        BackgroundTransparency = 1,
        Text            = "0%",
        TextColor3      = accentColor,
        TextSize        = 12,
        Font            = Font.Semi,
        TextXAlignment  = Enum.TextXAlignment.Right,
        ZIndex          = 4,
        Parent          = card,
        Visible         = showPerc,
    })

    -- Progress bar background
    local barBGY = logo and 168 or 124
    local barBG = Util.Create("Frame", {
        Size            = UDim2.new(1, -40, 0, 6),
        Position        = UDim2.new(0, 20, 0, barBGY),
        BackgroundColor3 = Theme.Loader_BarBG,
        ZIndex          = 4,
        Parent          = card,
    })
    Util.AddCorner(barBG, 3)

    local bar = Util.Create("Frame", {
        Size            = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = accentColor,
        ZIndex          = 5,
        Parent          = barBG,
    })
    Util.AddCorner(bar, 3)

    -- Shimmer on bar
    local shimmer = Util.Create("Frame", {
        Size            = UDim2.new(0, 60, 1, 0),
        Position        = UDim2.new(0, -60, 0, 0),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.8,
        ZIndex          = 6,
        ClipsDescendants = false,
        Parent          = bar,
    })
    Util.AddCorner(shimmer, 3)

    -- Dots indicator below bar
    local dotsY = barBGY + 20
    local dotsFrame = Util.Create("Frame", {
        Size            = UDim2.new(0, 40, 0, 8),
        Position        = UDim2.new(0.5, -20, 0, dotsY),
        BackgroundTransparency = 1,
        ZIndex          = 4,
        Parent          = card,
    })
    local dots = {}
    for i = 1, 3 do
        local dot = Util.Create("Frame", {
            Size            = UDim2.new(0, 6, 0, 6),
            Position        = UDim2.new(0, (i-1)*16, 0, 0),
            BackgroundColor3 = i == 1 and accentColor or Theme.BG_Element,
            ZIndex          = 5,
            Parent          = dotsFrame,
        })
        Util.AddCorner(dot, 3)
        dots[i] = dot
    end

    -- Animate dots
    local dotIdx = 1
    local dotConn = RunService.Heartbeat:Connect(function()
        -- Will be cleaned up
    end)
    local function cycleDots()
        while true do
            for i = 1, 3 do
                Util.Tween(dots[i], Anim.Fast, {
                    BackgroundColor3 = i == dotIdx and accentColor or Theme.BG_Element,
                })
            end
            dotIdx = dotIdx % 3 + 1
            task.wait(0.35)
        end
    end
    local dotThread = task.spawn(cycleDots)

    -- Animate progress
    local completed = Signal.new()

    task.spawn(function()
        local numTasks = math.max(#tasks, 1)
        local perTask  = duration / numTasks

        for i, taskName in ipairs(tasks) do
            Util.Tween(taskLabel, Anim.Fast, { TextTransparency = 1 })
            task.wait(0.1)
            taskLabel.Text = taskName
            Util.Tween(taskLabel, Anim.Fast, { TextTransparency = 0 })

            local startPerc = (i-1) / numTasks
            local endPerc   = i / numTasks
            local startTime = tick()

            while tick() - startTime < perTask do
                local elapsed = tick() - startTime
                local frac = math.min(elapsed / perTask, 1)
                local perc = startPerc + (endPerc - startPerc) * frac
                bar.Size = UDim2.new(perc, 0, 1, 0)
                percLabel.Text = math.floor(perc * 100) .. "%"
                -- shimmer
                shimmer.Position = UDim2.new(perc - 0.15, -30, 0, 0)
                task.wait()
            end
        end

        -- Complete
        bar.Size   = UDim2.new(1, 0, 1, 0)
        percLabel.Text = "100%"
        task.wait(0.3)

        -- Fade out
        task.cancel(dotThread)
        Util.Tween(bg, TweenInfo.new(0.5, Enum.EasingStyle.Quart), { BackgroundTransparency = 1 })
        for _, d in ipairs(bg:GetDescendants()) do
            if d:IsA("TextLabel") or d:IsA("Frame") or d:IsA("ImageLabel") then
                local prop = d:IsA("Frame") and "BackgroundTransparency" or
                             d:IsA("TextLabel") and "TextTransparency" or "ImageTransparency"
                pcall(function()
                    Util.Tween(d, TweenInfo.new(0.4, Enum.EasingStyle.Quart), { [prop] = 1 })
                end)
            end
        end
        task.wait(0.6)
        gui:Destroy()
        onComplete()
        completed:Fire()
    end)

    return {
        Completed = completed,
        Gui       = gui,
        SetTask   = function(_, text)
            taskLabel.Text = text
        end,
    }
end

-- ============================================================
-- [12]  ELEMENT BASE (all elements inherit from this)
-- ============================================================
local Element = {}
Element.__index = Element

function Element.new(opts)
    local self = setmetatable({}, Element)
    self.Changed = Signal.new()
    self._connections = {}
    return self
end

function Element:_Connect(signal, fn)
    local conn = signal:Connect(fn)
    table.insert(self._connections, conn)
    return conn
end

function Element:Destroy()
    for _, conn in ipairs(self._connections) do
        conn:Disconnect()
    end
    if self._frame then self._frame:Destroy() end
    self.Changed:Destroy()
end

-- ============================================================
-- [13] TOGGLE ELEMENT
-- ============================================================
local function CreateToggle(parent, opts)
    local label      = opts.Label    or "Toggle"
    local default    = opts.Default  or false
    local description = opts.Desc   or ""
    local callback   = opts.Callback or function() end
    local zindex     = opts.ZIndex   or 10

    local state = default
    local changed = Signal.new()

    local frame = Util.Create("Frame", {
        Name            = "Toggle_" .. label,
        Size            = UDim2.new(1, 0, 0, description ~= "" and 44 or 32),
        BackgroundColor3 = Theme.BG_Tertiary,
        ZIndex          = zindex,
        Parent          = parent,
    })
    Util.AddCorner(frame, 6)
    Util.AddPadding(frame, 0, 8, 0, 10)

    local labelTxt = Util.Create("TextLabel", {
        Size            = UDim2.new(1, -55, 0, 18),
        Position        = UDim2.new(0, 0, 0, description ~= "" and 6 or 7),
        BackgroundTransparency = 1,
        Text            = label,
        TextColor3      = Theme.Text_Primary,
        TextSize        = 13,
        Font            = Font.Semi,
        TextXAlignment  = Enum.TextXAlignment.Left,
        ZIndex          = zindex + 1,
        Parent          = frame,
    })

    if description ~= "" then
        Util.Create("TextLabel", {
            Size            = UDim2.new(1, -55, 0, 14),
            Position        = UDim2.new(0, 0, 0, 24),
            BackgroundTransparency = 1,
            Text            = description,
            TextColor3      = Theme.Text_Disabled,
            TextSize        = 11,
            Font            = Font.Body,
            TextXAlignment  = Enum.TextXAlignment.Left,
            ZIndex          = zindex + 1,
            Parent          = frame,
        })
    end

    -- Track (background of toggle)
    local trackW, trackH = 36, 20
    local track = Util.Create("Frame", {
        Size            = UDim2.new(0, trackW, 0, trackH),
        Position        = UDim2.new(1, -(trackW + 4), 0.5, -trackH/2),
        BackgroundColor3 = state and Theme.ToggleOn or Theme.ToggleOff,
        ZIndex          = zindex + 1,
        Parent          = frame,
    })
    Util.AddCorner(track, 10)

    -- Knob
    local knobSize = trackH - 6
    local knob = Util.Create("Frame", {
        Size            = UDim2.new(0, knobSize, 0, knobSize),
        Position        = state
            and UDim2.new(0, trackW - knobSize - 3, 0.5, -knobSize/2)
            or  UDim2.new(0, 3, 0.5, -knobSize/2),
        BackgroundColor3 = Theme.ToggleKnob,
        ZIndex          = zindex + 2,
        Parent          = track,
    })
    Util.AddCorner(knob, 99)
    Util.AddShadow(knob, 3, 0.5)

    -- Glow on track when on
    local trackGlow = Util.AddGlow(track, Theme.AccentGlow, 5, 0.92)
    trackGlow.Visible = state

    local function SetState(v, skipTween)
        state = v
        local knobX = v and (trackW - knobSize - 3) or 3
        if skipTween then
            track.BackgroundColor3 = v and Theme.ToggleOn or Theme.ToggleOff
            knob.Position = UDim2.new(0, knobX, 0.5, -knobSize/2)
        else
            Util.Tween(track, Anim.Normal, { BackgroundColor3 = v and Theme.ToggleOn or Theme.ToggleOff })
            Util.Tween(knob,  Anim.Normal, { Position = UDim2.new(0, knobX, 0.5, -knobSize/2) })
        end
        trackGlow.Visible = v
        callback(v)
        changed:Fire(v)
    end

    -- Click to toggle
    local button = Util.Create("TextButton", {
        Size            = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text            = "",
        ZIndex          = zindex + 3,
        Parent          = frame,
    })

    button.MouseButton1Click:Connect(function()
        SetState(not state)
        Util.Ripple(frame, button.AbsolutePosition.X - frame.AbsolutePosition.X + 10,
                           button.AbsolutePosition.Y - frame.AbsolutePosition.Y + 10)
    end)

    -- Hover highlight
    button.MouseEnter:Connect(function()
        Util.Tween(frame, Anim.Fast, { BackgroundColor3 = Theme.BG_Hover })
    end)
    button.MouseLeave:Connect(function()
        Util.Tween(frame, Anim.Fast, { BackgroundColor3 = Theme.BG_Tertiary })
    end)

    return {
        Frame    = frame,
        Set      = function(_, v) SetState(v, true) end,
        Get      = function() return state end,
        Changed  = changed,
    }
end

-- ============================================================
-- [14] SLIDER ELEMENT
-- ============================================================
local function CreateSlider(parent, opts)
    local label    = opts.Label    or "Slider"
    local min      = opts.Min      or 0
    local max      = opts.Max      or 100
    local default  = opts.Default  or min
    local step     = opts.Step     or 1
    local suffix   = opts.Suffix   or ""
    local callback = opts.Callback or function() end
    local zindex   = opts.ZIndex   or 10

    local value = default
    local changed = Signal.new()

    local frame = Util.Create("Frame", {
        Name            = "Slider_" .. label,
        Size            = UDim2.new(1, 0, 0, 48),
        BackgroundColor3 = Theme.BG_Tertiary,
        ZIndex          = zindex,
        Parent          = parent,
    })
    Util.AddCorner(frame, 6)
    Util.AddPadding(frame, 0, 10, 0, 10)

    -- Label row
    local labelTxt = Util.Create("TextLabel", {
        Size            = UDim2.new(0.6, 0, 0, 18),
        Position        = UDim2.new(0, 0, 0, 7),
        BackgroundTransparency = 1,
        Text            = label,
        TextColor3      = Theme.Text_Primary,
        TextSize        = 13,
        Font            = Font.Semi,
        TextXAlignment  = Enum.TextXAlignment.Left,
        ZIndex          = zindex + 1,
        Parent          = frame,
    })

    local valueTxt = Util.Create("TextLabel", {
        Size            = UDim2.new(0.4, 0, 0, 18),
        Position        = UDim2.new(0.6, 0, 0, 7),
        BackgroundTransparency = 1,
        Text            = tostring(value) .. suffix,
        TextColor3      = Theme.Accent,
        TextSize        = 13,
        Font            = Font.Semi,
        TextXAlignment  = Enum.TextXAlignment.Right,
        ZIndex          = zindex + 1,
        Parent          = frame,
    })

    -- Track
    local trackBG = Util.Create("Frame", {
        Size            = UDim2.new(1, 0, 0, 5),
        Position        = UDim2.new(0, 0, 0, 32),
        BackgroundColor3 = Theme.SliderBG,
        ZIndex          = zindex + 1,
        Parent          = frame,
    })
    Util.AddCorner(trackBG, 3)

    local fill = Util.Create("Frame", {
        Size            = UDim2.new((value - min) / (max - min), 0, 1, 0),
        BackgroundColor3 = Theme.SliderFill,
        ZIndex          = zindex + 2,
        Parent          = trackBG,
    })
    Util.AddCorner(fill, 3)
    Util.AddGlow(fill, Theme.AccentGlow, 4, 0.90)

    -- Knob
    local knob = Util.Create("Frame", {
        Size            = UDim2.new(0, 12, 0, 12),
        AnchorPoint     = Vector2.new(0.5, 0.5),
        Position        = UDim2.new((value - min) / (max - min), 0, 0.5, 0),
        BackgroundColor3 = Color3.fromRGB(240, 240, 245),
        ZIndex          = zindex + 3,
        Parent          = trackBG,
    })
    Util.AddCorner(knob, 6)
    Util.AddStroke(knob, Theme.Accent, 2)
    Util.AddShadow(knob, 4, 0.5)

    local function SetValue(v)
        v = math.clamp(math.round((v - min) / step) * step + min, min, max)
        value = v
        local frac = (v - min) / (max - min)
        Util.Tween(fill, Anim.Fast, { Size = UDim2.new(frac, 0, 1, 0) })
        Util.Tween(knob, Anim.Fast, { Position = UDim2.new(frac, 0, 0.5, 0) })
        valueTxt.Text = tostring(v) .. suffix
        callback(v)
        changed:Fire(v)
    end

    -- Input handling
    local dragging = false

    local function UpdateFromMouse(input)
        local absX = trackBG.AbsolutePosition.X
        local absW = trackBG.AbsoluteSize.X
        local relX = math.clamp((input.Position.X - absX) / absW, 0, 1)
        local rawVal = min + relX * (max - min)
        SetValue(rawVal)
    end

    local hitbox = Util.Create("TextButton", {
        Size            = UDim2.new(1, 0, 0, 20),
        Position        = UDim2.new(0, 0, 0, 25),
        BackgroundTransparency = 1,
        Text            = "",
        ZIndex          = zindex + 4,
        Parent          = frame,
    })

    hitbox.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            UpdateFromMouse(input)
        end
    end)

    hitbox.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then
            UpdateFromMouse(input)
        end
    end)

    -- Hover effect
    frame.MouseEnter:Connect(function()
        Util.Tween(frame, Anim.Fast, { BackgroundColor3 = Theme.BG_Hover })
    end)
    frame.MouseLeave:Connect(function()
        Util.Tween(frame, Anim.Fast, { BackgroundColor3 = Theme.BG_Tertiary })
    end)

    return {
        Frame   = frame,
        Set     = function(_, v) SetValue(v) end,
        Get     = function() return value end,
        Changed = changed,
    }
end

-- ============================================================
-- [15] DROPDOWN ELEMENT
-- ============================================================
local function CreateDropdown(parent, opts)
    local label    = opts.Label    or "Dropdown"
    local items    = opts.Items    or {}
    local default  = opts.Default  or items[1] or "None"
    local multi    = opts.Multi    or false
    local callback = opts.Callback or function() end
    local zindex   = opts.ZIndex   or 10

    local selected = multi and {} or default
    if multi and default then
        if type(default) == "table" then
            selected = default
        else
            selected = { default }
        end
    end
    local open     = false
    local changed  = Signal.new()

    local frame = Util.Create("Frame", {
        Name            = "Dropdown_" .. label,
        Size            = UDim2.new(1, 0, 0, 32),
        BackgroundColor3 = Theme.BG_Tertiary,
        ClipsDescendants = false,
        ZIndex          = zindex,
        Parent          = parent,
    })
    Util.AddCorner(frame, 6)
    Util.AddPadding(frame, 0, 8, 0, 10)

    local labelTxt = Util.Create("TextLabel", {
        Size            = UDim2.new(0.5, 0, 0, 18),
        Position        = UDim2.new(0, 0, 0.5, -9),
        BackgroundTransparency = 1,
        Text            = label,
        TextColor3      = Theme.Text_Primary,
        TextSize        = 13,
        Font            = Font.Semi,
        TextXAlignment  = Enum.TextXAlignment.Left,
        ZIndex          = zindex + 1,
        Parent          = frame,
    })

    -- Selected display
    local selectedBox = Util.Create("Frame", {
        Size            = UDim2.new(0.5, -8, 0, 22),
        Position        = UDim2.new(0.5, 4, 0.5, -11),
        BackgroundColor3 = Theme.BG_Element,
        ZIndex          = zindex + 1,
        Parent          = frame,
    })
    Util.AddCorner(selectedBox, 5)
    Util.AddStroke(selectedBox, Theme.Border, 1)

    local selectedTxt = Util.Create("TextLabel", {
        Size            = UDim2.new(1, -20, 1, 0),
        Position        = UDim2.new(0, 6, 0, 0),
        BackgroundTransparency = 1,
        Text            = multi and (selected[1] or "None") or tostring(selected),
        TextColor3      = Theme.Text_Primary,
        TextSize        = 12,
        Font            = Font.Body,
        TextXAlignment  = Enum.TextXAlignment.Left,
        ZIndex          = zindex + 2,
        Parent          = selectedBox,
    })

    -- Arrow
    local arrowLabel = Util.Create("TextLabel", {
        Size            = UDim2.new(0, 14, 1, 0),
        Position        = UDim2.new(1, -16, 0, 0),
        BackgroundTransparency = 1,
        Text            = "▾",
        TextColor3      = Theme.Accent,
        TextSize        = 13,
        Font            = Font.Bold,
        ZIndex          = zindex + 2,
        Parent          = selectedBox,
    })

    -- Dropdown list
    local dropFrame = Util.Create("Frame", {
        Name            = "DropList",
        Size            = UDim2.new(0.5, -8, 0, 0),
        Position        = UDim2.new(0.5, 4, 1, 4),
        BackgroundColor3 = Theme.Dropdown_BG,
        ClipsDescendants = true,
        ZIndex          = zindex + 10,
        Parent          = frame,
    })
    Util.AddCorner(dropFrame, 6)
    Util.AddStroke(dropFrame, Theme.Border, 1)
    Util.AddShadow(dropFrame, 8, 0.55)

    local dropList = Util.Create("ScrollingFrame", {
        Size            = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = Theme.Accent,
        ZIndex          = zindex + 11,
        Parent          = dropFrame,
    })

    local dropLayout = Util.Create("UIListLayout", {
        SortOrder       = Enum.SortOrder.LayoutOrder,
        Parent          = dropList,
    })

    local function GetDisplay()
        if multi then
            if #selected == 0 then return "None" end
            if #selected == 1 then return selected[1] end
            return selected[1] .. " +" .. (#selected - 1)
        end
        return tostring(selected)
    end

    local function BuildItems()
        for _, child in ipairs(dropList:GetChildren()) do
            if not child:IsA("UIListLayout") then child:Destroy() end
        end

        for _, item in ipairs(items) do
            local isSelected = multi
                and (table.find(selected, item) ~= nil)
                or  (selected == item)

            local row = Util.Create("Frame", {
                Name            = "Item_" .. tostring(item),
                Size            = UDim2.new(1, 0, 0, 26),
                BackgroundColor3 = isSelected and Theme.Dropdown_Hover or Theme.Dropdown_Item,
                ZIndex          = zindex + 12,
                Parent          = dropList,
            })

            local checkDot = Util.Create("Frame", {
                Size            = UDim2.new(0, 6, 0, 6),
                Position        = UDim2.new(0, 8, 0.5, -3),
                BackgroundColor3 = isSelected and Theme.Accent or Theme.BG_Element,
                ZIndex          = zindex + 13,
                Parent          = row,
            })
            Util.AddCorner(checkDot, 3)

            Util.Create("TextLabel", {
                Size            = UDim2.new(1, -24, 1, 0),
                Position        = UDim2.new(0, 22, 0, 0),
                BackgroundTransparency = 1,
                Text            = tostring(item),
                TextColor3      = isSelected and Theme.Text_Primary or Theme.Text_Secondary,
                TextSize        = 12,
                Font            = isSelected and Font.Semi or Font.Body,
                TextXAlignment  = Enum.TextXAlignment.Left,
                ZIndex          = zindex + 13,
                Parent          = row,
            })

            local btn = Util.Create("TextButton", {
                Size            = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text            = "",
                ZIndex          = zindex + 14,
                Parent          = row,
            })

            btn.MouseEnter:Connect(function()
                Util.Tween(row, Anim.Fast, { BackgroundColor3 = Theme.Dropdown_Hover })
            end)
            btn.MouseLeave:Connect(function()
                Util.Tween(row, Anim.Fast, { BackgroundColor3 = isSelected and Theme.Dropdown_Hover or Theme.Dropdown_Item })
            end)

            btn.MouseButton1Click:Connect(function()
                if multi then
                    local idx = table.find(selected, item)
                    if idx then
                        table.remove(selected, idx)
                    else
                        table.insert(selected, item)
                    end
                    callback(selected)
                    changed:Fire(selected)
                else
                    selected = item
                    open = false
                    Util.Tween(dropFrame, Anim.Slide, { Size = UDim2.new(0.5, -8, 0, 0) })
                    Util.Tween(arrowLabel, Anim.Fast, { Rotation = 0 })
                    callback(item)
                    changed:Fire(item)
                end
                selectedTxt.Text = GetDisplay()
                BuildItems()
            end)
        end

        -- Update scrolling frame canvas
        local totalH = #items * 26
        dropList.CanvasSize = UDim2.new(0, 0, 0, totalH)
    end

    BuildItems()

    -- Toggle open
    local clickBtn = Util.Create("TextButton", {
        Size            = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text            = "",
        ZIndex          = zindex + 3,
        Parent          = frame,
    })

    clickBtn.MouseButton1Click:Connect(function()
        open = not open
        if open then
            local maxH = math.min(#items * 26, 150)
            Util.Tween(dropFrame, Anim.Slide, { Size = UDim2.new(0.5, -8, 0, maxH) })
            Util.Tween(arrowLabel, Anim.Fast, { Rotation = 180 })
        else
            Util.Tween(dropFrame, Anim.Slide, { Size = UDim2.new(0.5, -8, 0, 0) })
            Util.Tween(arrowLabel, Anim.Fast, { Rotation = 0 })
        end
    end)

    -- Close when clicking elsewhere
    UserInputService.InputBegan:Connect(function(input)
        if open and (input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch) then
            -- crude check: if click is outside
            task.defer(function()
                local pos = input.Position
                local absPos = frame.AbsolutePosition
                local absSize = frame.AbsoluteSize
                if pos.X < absPos.X or pos.X > absPos.X + absSize.X
                or pos.Y < absPos.Y or pos.Y > absPos.Y + absSize.Y + 160 then
                    open = false
                    Util.Tween(dropFrame, Anim.Slide, { Size = UDim2.new(0.5, -8, 0, 0) })
                    Util.Tween(arrowLabel, Anim.Fast, { Rotation = 0 })
                end
            end)
        end
    end)

    return {
        Frame   = frame,
        Set     = function(_, v)
            selected = v
            selectedTxt.Text = GetDisplay()
            BuildItems()
        end,
        Get     = function() return selected end,
        AddItem = function(_, item)
            table.insert(items, item)
            BuildItems()
        end,
        RemoveItem = function(_, item)
            local idx = table.find(items, item)
            if idx then table.remove(items, idx) end
            BuildItems()
        end,
        SetItems = function(_, newItems)
            items = newItems
            selected = multi and {} or items[1]
            selectedTxt.Text = GetDisplay()
            BuildItems()
        end,
        Changed = changed,
    }
end

-- ============================================================
-- [16] TEXT INPUT ELEMENT
-- ============================================================
local function CreateInput(parent, opts)
    local label       = opts.Label       or "Input"
    local placeholder = opts.Placeholder or "Type here..."
    local default     = opts.Default     or ""
    local maxLen      = opts.MaxLength   or 50
    local numbersOnly = opts.NumbersOnly or false
    local callback    = opts.Callback    or function() end
    local zindex      = opts.ZIndex      or 10

    local changed = Signal.new()

    local frame = Util.Create("Frame", {
        Name            = "Input_" .. label,
        Size            = UDim2.new(1, 0, 0, 32),
        BackgroundColor3 = Theme.BG_Tertiary,
        ZIndex          = zindex,
        Parent          = parent,
    })
    Util.AddCorner(frame, 6)
    Util.AddPadding(frame, 0, 8, 0, 10)

    Util.Create("TextLabel", {
        Size            = UDim2.new(0.4, 0, 1, 0),
        BackgroundTransparency = 1,
        Text            = label,
        TextColor3      = Theme.Text_Primary,
        TextSize        = 13,
        Font            = Font.Semi,
        TextXAlignment  = Enum.TextXAlignment.Left,
        ZIndex          = zindex + 1,
        Parent          = frame,
    })

    local inputBox = Util.Create("Frame", {
        Size            = UDim2.new(0.6, -8, 0, 22),
        Position        = UDim2.new(0.4, 4, 0.5, -11),
        BackgroundColor3 = Theme.BG_Element,
        ZIndex          = zindex + 1,
        Parent          = frame,
    })
    Util.AddCorner(inputBox, 5)

    local stroke = Util.AddStroke(inputBox, Theme.Border, 1)

    local textbox = Util.Create("TextBox", {
        Size            = UDim2.new(1, -10, 1, 0),
        Position        = UDim2.new(0, 6, 0, 0),
        BackgroundTransparency = 1,
        Text            = default,
        PlaceholderText = placeholder,
        PlaceholderColor3 = Theme.Text_Disabled,
        TextColor3      = Theme.Text_Primary,
        TextSize        = 12,
        Font            = Font.Body,
        TextXAlignment  = Enum.TextXAlignment.Left,
        ClearTextOnFocus = false,
        ZIndex          = zindex + 2,
        Parent          = inputBox,
    })

    textbox.Focused:Connect(function()
        Util.Tween(stroke, Anim.Fast, { Color = Theme.Accent })
        Util.Tween(inputBox, Anim.Fast, { BackgroundColor3 = Theme.BG_Active })
    end)

    textbox.FocusLost:Connect(function()
        Util.Tween(stroke, Anim.Fast, { Color = Theme.Border })
        Util.Tween(inputBox, Anim.Fast, { BackgroundColor3 = Theme.BG_Element })
        local v = textbox.Text
        if numbersOnly then v = v:gsub("[^%d%.%-]", "") textbox.Text = v end
        callback(v)
        changed:Fire(v)
    end)

    textbox:GetPropertyChangedSignal("Text"):Connect(function()
        if #textbox.Text > maxLen then
            textbox.Text = textbox.Text:sub(1, maxLen)
        end
    end)

    return {
        Frame   = frame,
        Set     = function(_, v) textbox.Text = tostring(v) end,
        Get     = function() return textbox.Text end,
        Changed = changed,
    }
end

-- ============================================================
-- [17] BUTTON ELEMENT
-- ============================================================
local function CreateButton(parent, opts)
    local label    = opts.Label    or "Button"
    local desc     = opts.Desc     or ""
    local callback = opts.Callback or function() end
    local style    = opts.Style    or "Default" -- Default, Accent, Danger
    local zindex   = opts.ZIndex   or 10

    local bgColors = {
        Default = Theme.BG_Tertiary,
        Accent  = Theme.AccentDark,
        Danger  = Color3.fromRGB(100, 35, 45),
    }
    local hoverColors = {
        Default = Theme.BG_Hover,
        Accent  = Theme.Accent,
        Danger  = Color3.fromRGB(160, 50, 65),
    }

    local frame = Util.Create("Frame", {
        Name            = "Button_" .. label,
        Size            = UDim2.new(1, 0, 0, desc ~= "" and 42 or 30),
        BackgroundColor3 = bgColors[style] or Theme.BG_Tertiary,
        ZIndex          = zindex,
        Parent          = parent,
    })
    Util.AddCorner(frame, 6)
    Util.AddPadding(frame, 0, 8, 0, 10)

    if style == "Accent" then
        Util.AddGlow(frame, Theme.AccentGlow, 6, 0.90)
        Util.AddStroke(frame, Theme.Accent, 1, 0.5)
    end

    Util.Create("TextLabel", {
        Size            = UDim2.new(1, -24, 0, 18),
        Position        = UDim2.new(0, 0, 0, desc ~= "" and 6 or 6),
        BackgroundTransparency = 1,
        Text            = label,
        TextColor3      = style == "Default" and Theme.Text_Primary or Theme.Text_Primary,
        TextSize        = 13,
        Font            = Font.Semi,
        TextXAlignment  = Enum.TextXAlignment.Left,
        ZIndex          = zindex + 1,
        Parent          = frame,
    })

    if desc ~= "" then
        Util.Create("TextLabel", {
            Size            = UDim2.new(1, 0, 0, 14),
            Position        = UDim2.new(0, 0, 0, 24),
            BackgroundTransparency = 1,
            Text            = desc,
            TextColor3      = Theme.Text_Disabled,
            TextSize        = 11,
            Font            = Font.Body,
            TextXAlignment  = Enum.TextXAlignment.Left,
            ZIndex          = zindex + 1,
            Parent          = frame,
        })
    end

    -- Right arrow indicator
    Util.Create("TextLabel", {
        Size            = UDim2.new(0, 14, 0, 18),
        Position        = UDim2.new(1, -16, 0.5, -9),
        BackgroundTransparency = 1,
        Text            = "›",
        TextColor3      = Theme.Text_Accent,
        TextSize        = 16,
        Font            = Font.Bold,
        ZIndex          = zindex + 1,
        Parent          = frame,
    })

    local btn = Util.Create("TextButton", {
        Size            = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text            = "",
        ZIndex          = zindex + 2,
        Parent          = frame,
    })

    btn.MouseButton1Click:Connect(function()
        Util.Ripple(frame, btn.AbsolutePosition.X - frame.AbsolutePosition.X + 10,
                           btn.AbsolutePosition.Y - frame.AbsolutePosition.Y + 10)
        callback()
    end)

    btn.MouseEnter:Connect(function()
        Util.Tween(frame, Anim.Fast, { BackgroundColor3 = hoverColors[style] or Theme.BG_Hover })
    end)
    btn.MouseLeave:Connect(function()
        Util.Tween(frame, Anim.Fast, { BackgroundColor3 = bgColors[style] or Theme.BG_Tertiary })
    end)

    return { Frame = frame }
end

-- ============================================================
-- [18] KEYBIND ELEMENT (with rebind UX)
-- ============================================================
local function CreateKeybind(parent, opts)
    local label    = opts.Label    or "Keybind"
    local default  = opts.Default  or Enum.KeyCode.Unknown
    local callback = opts.Callback or function() end
    local zindex   = opts.ZIndex   or 10

    local currentKey = default
    local listening  = false
    local changed    = Signal.new()

    local frame = Util.Create("Frame", {
        Name            = "Keybind_" .. label,
        Size            = UDim2.new(1, 0, 0, 32),
        BackgroundColor3 = Theme.BG_Tertiary,
        ZIndex          = zindex,
        Parent          = parent,
    })
    Util.AddCorner(frame, 6)
    Util.AddPadding(frame, 0, 8, 0, 10)

    Util.Create("TextLabel", {
        Size            = UDim2.new(0.6, 0, 1, 0),
        BackgroundTransparency = 1,
        Text            = label,
        TextColor3      = Theme.Text_Primary,
        TextSize        = 13,
        Font            = Font.Semi,
        TextXAlignment  = Enum.TextXAlignment.Left,
        ZIndex          = zindex + 1,
        Parent          = frame,
    })

    local badge = Util.Create("Frame", {
        Size            = UDim2.new(0, 70, 0, 22),
        Position        = UDim2.new(1, -74, 0.5, -11),
        BackgroundColor3 = Theme.BG_Element,
        ZIndex          = zindex + 1,
        Parent          = frame,
    })
    Util.AddCorner(badge, 5)
    Util.AddStroke(badge, Theme.Border, 1)

    local keyTxt = Util.Create("TextLabel", {
        Size            = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text            = currentKey.Name,
        TextColor3      = Theme.Accent,
        TextSize        = 12,
        Font            = Font.Semi,
        ZIndex          = zindex + 2,
        Parent          = badge,
    })

    local btn = Util.Create("TextButton", {
        Size            = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text            = "",
        ZIndex          = zindex + 3,
        Parent          = frame,
    })

    local function StartListen()
        listening = true
        keyTxt.Text = "..."
        keyTxt.TextColor3 = Theme.AccentLight
        Util.Tween(badge, Anim.Fast, { BackgroundColor3 = Theme.BG_Active })
    end

    local function StopListen(key)
        listening = false
        currentKey = key or currentKey
        keyTxt.Text = currentKey.Name
        keyTxt.TextColor3 = Theme.Accent
        Util.Tween(badge, Anim.Fast, { BackgroundColor3 = Theme.BG_Element })
        callback(currentKey)
        changed:Fire(currentKey)
    end

    btn.MouseButton1Click:Connect(function()
        if not listening then
            StartListen()
        end
    end)

    UserInputService.InputBegan:Connect(function(input, gpe)
        if listening and not gpe then
            if input.UserInputType == Enum.UserInputType.Keyboard then
                if input.KeyCode == Enum.KeyCode.Escape then
                    StopListen()
                else
                    StopListen(input.KeyCode)
                end
            end
        else
            -- Fire callback when key is pressed
            if input.UserInputType == Enum.UserInputType.Keyboard
            and input.KeyCode == currentKey then
                callback(currentKey)
            end
        end
    end)

    btn.MouseEnter:Connect(function()
        Util.Tween(frame, Anim.Fast, { BackgroundColor3 = Theme.BG_Hover })
    end)
    btn.MouseLeave:Connect(function()
        Util.Tween(frame, Anim.Fast, { BackgroundColor3 = Theme.BG_Tertiary })
    end)

    return {
        Frame   = frame,
        Get     = function() return currentKey end,
        Set     = function(_, k) StopListen(k) end,
        Changed = changed,
    }
end

-- ============================================================
-- [19] COLOR PICKER ELEMENT
-- ============================================================
local function CreateColorPicker(parent, opts)
    local label    = opts.Label    or "Color"
    local default  = opts.Default  or Color3.fromRGB(198, 100, 145)
    local callback = opts.Callback or function() end
    local zindex   = opts.ZIndex   or 10

    local color   = default
    local open    = false
    local changed = Signal.new()

    local frame = Util.Create("Frame", {
        Name            = "ColorPicker_" .. label,
        Size            = UDim2.new(1, 0, 0, 32),
        BackgroundColor3 = Theme.BG_Tertiary,
        ClipsDescendants = false,
        ZIndex          = zindex,
        Parent          = parent,
    })
    Util.AddCorner(frame, 6)
    Util.AddPadding(frame, 0, 8, 0, 10)

    Util.Create("TextLabel", {
        Size            = UDim2.new(0.6, 0, 1, 0),
        BackgroundTransparency = 1,
        Text            = label,
        TextColor3      = Theme.Text_Primary,
        TextSize        = 13,
        Font            = Font.Semi,
        TextXAlignment  = Enum.TextXAlignment.Left,
        ZIndex          = zindex + 1,
        Parent          = frame,
    })

    -- Preview swatch
    local swatch = Util.Create("Frame", {
        Size            = UDim2.new(0, 50, 0, 22),
        Position        = UDim2.new(1, -54, 0.5, -11),
        BackgroundColor3 = color,
        ZIndex          = zindex + 1,
        Parent          = frame,
    })
    Util.AddCorner(swatch, 5)
    Util.AddStroke(swatch, Theme.Border, 1)
    Util.AddGlow(swatch, color, 5, 0.85)

    -- Picker panel
    local panel = Util.Create("Frame", {
        Name            = "ColorPanel",
        Size            = UDim2.new(0, 220, 0, 0),
        Position        = UDim2.new(1, -224, 1, 4),
        BackgroundColor3 = Theme.Dropdown_BG,
        ClipsDescendants = true,
        ZIndex          = zindex + 20,
        Parent          = frame,
    })
    Util.AddCorner(panel, 8)
    Util.AddStroke(panel, Theme.Border, 1)
    Util.AddShadow(panel, 10, 0.5)

    -- Saturation/Value picker (gradient square)
    local svPicker = Util.Create("ImageLabel", {
        Size            = UDim2.new(1, -16, 0, 120),
        Position        = UDim2.new(0, 8, 0, 8),
        BackgroundColor3 = Color3.fromHSV(color:ToHSV()),
        Image           = "rbxassetid://6020299385", -- white-to-transparent gradient
        ZIndex          = zindex + 21,
        Parent          = panel,
    })
    Util.AddCorner(svPicker, 4)

    -- Dark overlay
    local darkOverlay = Util.Create("ImageLabel", {
        Size            = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Image           = "rbxassetid://6020299769", -- black overlay
        ZIndex          = zindex + 22,
        Parent          = svPicker,
    })

    -- SV cursor
    local svCursor = Util.Create("Frame", {
        Size            = UDim2.new(0, 10, 0, 10),
        AnchorPoint     = Vector2.new(0.5, 0.5),
        Position        = UDim2.new(1, 0, 0, 0),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        ZIndex          = zindex + 23,
        Parent          = svPicker,
    })
    Util.AddCorner(svCursor, 5)
    Util.AddStroke(svCursor, Color3.fromRGB(0,0,0), 1)

    -- Hue bar
    local hueBar = Util.Create("ImageLabel", {
        Size            = UDim2.new(1, -16, 0, 14),
        Position        = UDim2.new(0, 8, 0, 136),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        Image           = "rbxassetid://6020299988", -- hue gradient
        ZIndex          = zindex + 21,
        Parent          = panel,
    })
    Util.AddCorner(hueBar, 4)

    local hueCursor = Util.Create("Frame", {
        Size            = UDim2.new(0, 4, 1, 4),
        AnchorPoint     = Vector2.new(0.5, 0.5),
        Position        = UDim2.new(0, 0, 0.5, 0),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        ZIndex          = zindex + 22,
        Parent          = hueBar,
    })
    Util.AddCorner(hueCursor, 2)
    Util.AddStroke(hueCursor, Color3.fromRGB(0,0,0), 1)

    -- Hex input
    local hexBox = Util.Create("Frame", {
        Size            = UDim2.new(1, -16, 0, 26),
        Position        = UDim2.new(0, 8, 0, 158),
        BackgroundColor3 = Theme.BG_Element,
        ZIndex          = zindex + 21,
        Parent          = panel,
    })
    Util.AddCorner(hexBox, 5)
    Util.AddStroke(hexBox, Theme.Border, 1)

    local hexInput = Util.Create("TextBox", {
        Size            = UDim2.new(1, -10, 1, 0),
        Position        = UDim2.new(0, 6, 0, 0),
        BackgroundTransparency = 1,
        Text            = string.format("#%02X%02X%02X", color.R*255, color.G*255, color.B*255),
        TextColor3      = Theme.Text_Primary,
        TextSize        = 12,
        Font            = Font.Mono,
        TextXAlignment  = Enum.TextXAlignment.Left,
        ClearTextOnFocus = false,
        ZIndex          = zindex + 22,
        Parent          = hexBox,
    })

    local panelH = 192

    -- H, S, V tracking
    local H, S, V = color:ToHSV()

    local function ApplyColor()
        color = Color3.fromHSV(H, S, V)
        swatch.BackgroundColor3 = color
        -- update glow
        svPicker.BackgroundColor3 = Color3.fromHSV(H, 1, 1)
        svCursor.Position = UDim2.new(S, 0, 1 - V, 0)
        hueCursor.Position = UDim2.new(H, 0, 0.5, 0)
        hexInput.Text = string.format("#%02X%02X%02X", color.R*255, color.G*255, color.B*255)
        callback(color)
        changed:Fire(color)
    end

    -- SV picker interaction
    local svDrag = false
    svPicker.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            svDrag = true
        end
    end)
    svPicker.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            svDrag = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if svDrag and (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then
            local pos = input.Position
            local abs = svPicker.AbsolutePosition
            local sz  = svPicker.AbsoluteSize
            S = math.clamp((pos.X - abs.X) / sz.X, 0, 1)
            V = 1 - math.clamp((pos.Y - abs.Y) / sz.Y, 0, 1)
            ApplyColor()
        end
    end)

    -- Hue bar interaction
    local hueDrag = false
    hueBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            hueDrag = true
        end
    end)
    hueBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            hueDrag = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if hueDrag and (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then
            local pos = input.Position
            local abs = hueBar.AbsolutePosition
            local sz  = hueBar.AbsoluteSize
            H = math.clamp((pos.X - abs.X) / sz.X, 0, 1)
            ApplyColor()
        end
    end)

    -- Hex input
    hexInput.FocusLost:Connect(function()
        local hex = hexInput.Text:gsub("#", "")
        if #hex == 6 then
            local r = tonumber(hex:sub(1,2), 16) or 0
            local g = tonumber(hex:sub(3,4), 16) or 0
            local b = tonumber(hex:sub(5,6), 16) or 0
            color = Color3.fromRGB(r, g, b)
            H, S, V = color:ToHSV()
            ApplyColor()
        end
    end)

    -- Toggle panel
    local swatchBtn = Util.Create("TextButton", {
        Size            = UDim2.new(0, 50, 0, 22),
        Position        = UDim2.new(1, -54, 0.5, -11),
        BackgroundTransparency = 1,
        Text            = "",
        ZIndex          = zindex + 2,
        Parent          = frame,
    })
    swatchBtn.MouseButton1Click:Connect(function()
        open = not open
        Util.Tween(panel, Anim.Slide, {
            Size = open and UDim2.new(0, 220, 0, panelH) or UDim2.new(0, 220, 0, 0)
        })
    end)

    ApplyColor()

    return {
        Frame   = frame,
        Get     = function() return color end,
        Set     = function(_, c)
            color = c
            H, S, V = c:ToHSV()
            ApplyColor()
        end,
        Changed = changed,
    }
end

-- ============================================================
-- [20] CHECKBOX ELEMENT
-- ============================================================
local function CreateCheckbox(parent, opts)
    local label    = opts.Label    or "Checkbox"
    local default  = opts.Default  or false
    local callback = opts.Callback or function() end
    local zindex   = opts.ZIndex   or 10

    local state   = default
    local changed = Signal.new()

    local frame = Util.Create("Frame", {
        Name            = "Checkbox_" .. label,
        Size            = UDim2.new(1, 0, 0, 28),
        BackgroundColor3 = Theme.BG_Tertiary,
        ZIndex          = zindex,
        Parent          = parent,
    })
    Util.AddCorner(frame, 6)
    Util.AddPadding(frame, 0, 8, 0, 10)

    -- Checkbox box
    local box = Util.Create("Frame", {
        Size            = UDim2.new(0, 16, 0, 16),
        Position        = UDim2.new(0, 0, 0.5, -8),
        BackgroundColor3 = state and Theme.CheckOn or Theme.CheckOff,
        ZIndex          = zindex + 1,
        Parent          = frame,
    })
    Util.AddCorner(box, 4)
    Util.AddStroke(box, state and Theme.Accent or Theme.Border, 1)

    local checkMark = Util.Create("TextLabel", {
        Size            = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text            = "✓",
        TextColor3      = Color3.fromRGB(255, 255, 255),
        TextSize        = 11,
        Font            = Font.Bold,
        ZIndex          = zindex + 2,
        TextTransparency = state and 0 or 1,
        Parent          = box,
    })

    Util.Create("TextLabel", {
        Size            = UDim2.new(1, -24, 1, 0),
        Position        = UDim2.new(0, 24, 0, 0),
        BackgroundTransparency = 1,
        Text            = label,
        TextColor3      = Theme.Text_Primary,
        TextSize        = 13,
        Font            = Font.Semi,
        TextXAlignment  = Enum.TextXAlignment.Left,
        ZIndex          = zindex + 1,
        Parent          = frame,
    })

    local function SetState(v)
        state = v
        Util.Tween(box, Anim.Fast, { BackgroundColor3 = v and Theme.CheckOn or Theme.CheckOff })
        Util.Tween(checkMark, Anim.Fast, { TextTransparency = v and 0 or 1 })
        callback(v)
        changed:Fire(v)
    end

    local btn = Util.Create("TextButton", {
        Size            = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text            = "",
        ZIndex          = zindex + 3,
        Parent          = frame,
    })

    btn.MouseButton1Click:Connect(function()
        SetState(not state)
    end)

    btn.MouseEnter:Connect(function()
        Util.Tween(frame, Anim.Fast, { BackgroundColor3 = Theme.BG_Hover })
    end)
    btn.MouseLeave:Connect(function()
        Util.Tween(frame, Anim.Fast, { BackgroundColor3 = Theme.BG_Tertiary })
    end)

    return {
        Frame   = frame,
        Set     = function(_, v) SetState(v) end,
        Get     = function() return state end,
        Changed = changed,
    }
end

-- ============================================================
-- [21] LABEL / SEPARATOR ELEMENTS
-- ============================================================
local function CreateLabel(parent, opts)
    local text   = opts.Text   or "Label"
    local color  = opts.Color  or Theme.Text_Secondary
    local size   = opts.Size   or 12
    local zindex = opts.ZIndex or 10

    local frame = Util.Create("TextLabel", {
        Name            = "Label",
        Size            = UDim2.new(1, 0, 0, 22),
        BackgroundTransparency = 1,
        Text            = text,
        TextColor3      = color,
        TextSize        = size,
        Font            = Font.Body,
        TextXAlignment  = Enum.TextXAlignment.Left,
        ZIndex          = zindex,
        Parent          = parent,
    })

    return {
        Frame = frame,
        Set   = function(_, v) frame.Text = v end,
        Get   = function() return frame.Text end,
    }
end

local function CreateSeparator(parent, opts)
    local zindex = opts and opts.ZIndex or 10
    local sep = Util.Create("Frame", {
        Name            = "Separator",
        Size            = UDim2.new(1, 0, 0, 1),
        BackgroundColor3 = Theme.Divider,
        ZIndex          = zindex,
        Parent          = parent,
    })
    return { Frame = sep }
end

-- ============================================================
-- [22] SECTION CLASS
-- ============================================================
local Section = {}
Section.__index = Section

function Section.new(parent, title, zindex)
    local self = setmetatable({}, Section)
    self._zindex    = zindex or 10
    self._elements  = {}
    self._collapsed = false

    self._frame = Util.Create("Frame", {
        Name            = "Section_" .. title,
        Size            = UDim2.new(1, 0, 0, 30),
        BackgroundColor3 = Theme.BG_Primary,
        ClipsDescendants = false,
        ZIndex          = zindex,
        Parent          = parent,
    })

    -- Section header
    local header = Util.Create("Frame", {
        Name            = "Header",
        Size            = UDim2.new(1, 0, 0, 26),
        BackgroundTransparency = 1,
        ZIndex          = zindex,
        Parent          = self._frame,
    })

    -- Title label with left accent dot
    local dot = Util.Create("Frame", {
        Size            = UDim2.new(0, 3, 0, 14),
        Position        = UDim2.new(0, 0, 0.5, -7),
        BackgroundColor3 = Theme.Accent,
        ZIndex          = zindex + 1,
        Parent          = header,
    })
    Util.AddCorner(dot, 2)

    local titleLabel = Util.Create("TextLabel", {
        Size            = UDim2.new(1, -20, 1, 0),
        Position        = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text            = title:upper(),
        TextColor3      = Theme.Text_Secondary,
        TextSize        = 11,
        Font            = Font.Bold,
        TextXAlignment  = Enum.TextXAlignment.Left,
        LetterSpacing   = 1,
        ZIndex          = zindex + 1,
        Parent          = header,
    })

    -- Collapse arrow
    local arrowBtn = Util.Create("TextButton", {
        Size            = UDim2.new(0, 20, 0, 20),
        Position        = UDim2.new(1, -20, 0.5, -10),
        BackgroundTransparency = 1,
        Text            = "▾",
        TextColor3      = Theme.Text_Disabled,
        TextSize        = 12,
        Font            = Font.Bold,
        ZIndex          = zindex + 2,
        Parent          = header,
    })

    -- Content frame
    self._content = Util.Create("Frame", {
        Name            = "Content",
        Size            = UDim2.new(1, 0, 0, 0),
        Position        = UDim2.new(0, 0, 0, 28),
        BackgroundColor3 = Theme.BG_Tertiary,
        ClipsDescendants = true,
        ZIndex          = zindex,
        Parent          = self._frame,
    })
    Util.AddCorner(self._content, 6)
    Util.AddStroke(self._content, Theme.Border, 1)

    local layout = Util.Create("UIListLayout", {
        SortOrder       = Enum.SortOrder.LayoutOrder,
        Padding         = UDim.new(0, 2),
        Parent          = self._content,
    })
    Util.AddPadding(self._content, 4, 6, 4, 6)

    -- Auto-size the content frame
    layout.Changed:Connect(function()
        self:_Resize()
    end)

    -- Collapse toggle
    arrowBtn.MouseButton1Click:Connect(function()
        self._collapsed = not self._collapsed
        self:_Resize()
        Util.Tween(arrowBtn, Anim.Fast, { Rotation = self._collapsed and -90 or 0 })
    end)

    self:_Resize()
    return self
end

function Section:_Resize()
    if self._collapsed then
        Util.Tween(self._content, Anim.Slide, { Size = UDim2.new(1, 0, 0, 0) })
        Util.Tween(self._frame,   Anim.Slide, { Size = UDim2.new(1, 0, 0, 30) })
        return
    end

    local contentH = 8  -- top+bottom padding
    for _, child in ipairs(self._content:GetChildren()) do
        if child:IsA("Frame") or child:IsA("TextLabel") then
            contentH = contentH + child.AbsoluteSize.Y + 2
        end
    end
    contentH = math.max(contentH, 8)

    Util.Tween(self._content, Anim.Slide, { Size = UDim2.new(1, 0, 0, contentH) })
    Util.Tween(self._frame,   Anim.Slide, { Size = UDim2.new(1, 0, 0, 30 + contentH + 4) })
end

-- Element adders
function Section:AddToggle(label, default, callback, desc)
    local el = CreateToggle(self._content, {
        Label = label, Default = default, Callback = callback,
        Desc = desc or "", ZIndex = self._zindex + 2
    })
    table.insert(self._elements, el)
    task.defer(function() self:_Resize() end)
    return el
end

function Section:AddSlider(label, min, max, default, callback, opts)
    opts = opts or {}
    local el = CreateSlider(self._content, {
        Label = label, Min = min, Max = max, Default = default,
        Callback = callback, Step = opts.Step, Suffix = opts.Suffix,
        ZIndex = self._zindex + 2
    })
    table.insert(self._elements, el)
    task.defer(function() self:_Resize() end)
    return el
end

function Section:AddDropdown(label, items, default, callback, opts)
    opts = opts or {}
    local el = CreateDropdown(self._content, {
        Label = label, Items = items, Default = default,
        Callback = callback, Multi = opts.Multi,
        ZIndex = self._zindex + 2
    })
    table.insert(self._elements, el)
    task.defer(function() self:_Resize() end)
    return el
end

function Section:AddInput(label, placeholder, default, callback, opts)
    opts = opts or {}
    local el = CreateInput(self._content, {
        Label = label, Placeholder = placeholder, Default = default,
        Callback = callback, NumbersOnly = opts.NumbersOnly, MaxLength = opts.MaxLength,
        ZIndex = self._zindex + 2
    })
    table.insert(self._elements, el)
    task.defer(function() self:_Resize() end)
    return el
end

function Section:AddButton(label, callback, opts)
    opts = opts or {}
    local el = CreateButton(self._content, {
        Label = label, Callback = callback, Desc = opts.Desc, Style = opts.Style,
        ZIndex = self._zindex + 2
    })
    table.insert(self._elements, el)
    task.defer(function() self:_Resize() end)
    return el
end

function Section:AddKeybind(label, default, callback)
    local el = CreateKeybind(self._content, {
        Label = label, Default = default, Callback = callback,
        ZIndex = self._zindex + 2
    })
    table.insert(self._elements, el)
    task.defer(function() self:_Resize() end)
    return el
end

function Section:AddColorPicker(label, default, callback)
    local el = CreateColorPicker(self._content, {
        Label = label, Default = default, Callback = callback,
        ZIndex = self._zindex + 2
    })
    table.insert(self._elements, el)
    task.defer(function() self:_Resize() end)
    return el
end

function Section:AddCheckbox(label, default, callback)
    local el = CreateCheckbox(self._content, {
        Label = label, Default = default, Callback = callback,
        ZIndex = self._zindex + 2
    })
    table.insert(self._elements, el)
    task.defer(function() self:_Resize() end)
    return el
end

function Section:AddLabel(text, color)
    local el = CreateLabel(self._content, { Text = text, Color = color, ZIndex = self._zindex + 2 })
    task.defer(function() self:_Resize() end)
    return el
end

function Section:AddSeparator()
    local el = CreateSeparator(self._content, { ZIndex = self._zindex + 2 })
    task.defer(function() self:_Resize() end)
    return el
end

-- ============================================================
-- [23] TAB CLASS
-- ============================================================
local Tab = {}
Tab.__index = Tab

function Tab.new(contentParent, zindex)
    local self = setmetatable({}, Tab)
    self._zindex   = zindex or 10
    self._sections = {}

    self._frame = Util.Create("ScrollingFrame", {
        Name            = "TabContent",
        Size            = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = Theme.Accent,
        ScrollBarImageTransparency = 0.5,
        ZIndex          = zindex,
        Visible         = false,
        Parent          = contentParent,
    })

    local layout = Util.Create("UIListLayout", {
        SortOrder       = Enum.SortOrder.LayoutOrder,
        Padding         = UDim.new(0, 8),
        Parent          = self._frame,
    })
    Util.AddPadding(self._frame, 8, 8, 8, 8)

    layout.Changed:Connect(function()
        local h = layout.AbsoluteContentSize.Y + 20
        self._frame.CanvasSize = UDim2.new(0, 0, 0, h)
    end)

    return self
end

function Tab:AddSection(title)
    local sec = Section.new(self._frame, title, self._zindex + 2)
    table.insert(self._sections, sec)
    return sec
end

-- ============================================================
-- [24] SEARCH BAR (inside window)
-- ============================================================
local function CreateSearchBar(parent, zindex, onSearch)
    local frame = Util.Create("Frame", {
        Name            = "SearchBar",
        Size            = UDim2.new(1, -16, 0, 28),
        Position        = UDim2.new(0, 8, 0, 4),
        BackgroundColor3 = Theme.BG_Element,
        ZIndex          = zindex,
        Parent          = parent,
    })
    Util.AddCorner(frame, 6)
    Util.AddStroke(frame, Theme.Border, 1)

    Util.Create("TextLabel", {
        Size            = UDim2.new(0, 16, 1, 0),
        Position        = UDim2.new(0, 6, 0, 0),
        BackgroundTransparency = 1,
        Text            = "🔍",
        TextSize        = 11,
        Font            = Font.Body,
        ZIndex          = zindex + 1,
        Parent          = frame,
    })

    local tb = Util.Create("TextBox", {
        Size            = UDim2.new(1, -28, 1, 0),
        Position        = UDim2.new(0, 24, 0, 0),
        BackgroundTransparency = 1,
        Text            = "",
        PlaceholderText = "Search elements...",
        PlaceholderColor3 = Theme.Text_Disabled,
        TextColor3      = Theme.Text_Primary,
        TextSize        = 12,
        Font            = Font.Body,
        TextXAlignment  = Enum.TextXAlignment.Left,
        ClearTextOnFocus = false,
        ZIndex          = zindex + 1,
        Parent          = frame,
    })

    tb:GetPropertyChangedSignal("Text"):Connect(function()
        if onSearch then onSearch(tb.Text) end
    end)

    return frame
end

-- ============================================================
-- [25] MAIN WINDOW CLASS
-- ============================================================
local Window = {}
Window.__index = Window

function Window.new(screenGui, opts)
    local self = setmetatable({}, Window)
    opts = opts or {}

    self._title      = opts.Title    or "HepaUI"
    self._subTitle   = opts.SubTitle or "Library"
    self._tabWidth   = opts.TabWidth or 160
    self._size       = opts.Size     or UDim2.new(0, 680, 0, 460)
    self._position   = opts.Position or UDim2.new(0.5, -340, 0.5, -230)
    self._tabs       = {}
    self._activeTab  = nil
    self._minimized  = false
    self._visible    = true
    self._toggleKey  = opts.ToggleKey or Enum.KeyCode.RightShift

    -- Root frame
    self._root = Util.Create("Frame", {
        Name            = "HepaWindow",
        Size            = self._size,
        Position        = self._position,
        BackgroundColor3 = Theme.BG_Primary,
        ClipsDescendants = false,
        ZIndex          = 10,
        Parent          = screenGui,
    })
    Util.AddCorner(self._root, 10)
    Util.AddShadow(self._root, 20, 0.45)
    Util.AddGlow(self._root, Theme.AccentGlow, 10, 0.92)

    -- Outer border
    Util.AddStroke(self._root, Theme.Border, 1)

    -- Title bar
    local titleBar = Util.Create("Frame", {
        Name            = "TitleBar",
        Size            = UDim2.new(1, 0, 0, 48),
        BackgroundColor3 = Theme.BG_Secondary,
        ZIndex          = 11,
        Parent          = self._root,
    })
    Util.AddCorner(titleBar, 10)

    -- Cover bottom corners of titlebar
    Util.Create("Frame", {
        Size            = UDim2.new(1, 0, 0, 10),
        Position        = UDim2.new(0, 0, 1, -10),
        BackgroundColor3 = Theme.BG_Secondary,
        ZIndex          = 11,
        Parent          = titleBar,
    })

    -- Accent bar under title
    local accentBar = Util.Create("Frame", {
        Name            = "AccentBar",
        Size            = UDim2.new(1, 0, 0, 2),
        Position        = UDim2.new(0, 0, 1, -2),
        BackgroundColor3 = Theme.Accent,
        ZIndex          = 12,
        Parent          = titleBar,
    })

    -- Logo area (left side of title bar)
    local logoFrame = Util.Create("Frame", {
        Size            = UDim2.new(0, self._tabWidth, 1, 0),
        BackgroundTransparency = 1,
        ZIndex          = 12,
        Parent          = titleBar,
    })

    -- Logo "H" letter in accent color  
    local logoLabel = Util.Create("TextLabel", {
        Size            = UDim2.new(0, 32, 0, 32),
        Position        = UDim2.new(0, 12, 0.5, -16),
        BackgroundTransparency = 1,
        Text            = self._title:sub(1,1),
        TextColor3      = Theme.Accent,
        TextSize        = 22,
        Font            = Font.Title,
        ZIndex          = 13,
        Parent          = logoFrame,
    })

    local titleFull = Util.Create("TextLabel", {
        Size            = UDim2.new(1, -48, 0, 20),
        Position        = UDim2.new(0, 44, 0.5, -10),
        BackgroundTransparency = 1,
        Text            = self._title:sub(2),
        TextColor3      = Theme.Text_Primary,
        TextSize        = 16,
        Font            = Font.Title,
        TextXAlignment  = Enum.TextXAlignment.Left,
        ZIndex          = 13,
        Parent          = logoFrame,
    })

    -- Window title (center of title bar)
    Util.Create("TextLabel", {
        Size            = UDim2.new(0, 200, 1, 0),
        Position        = UDim2.new(0.5, -100, 0, 0),
        BackgroundTransparency = 1,
        Text            = self._subTitle,
        TextColor3      = Theme.Text_Secondary,
        TextSize        = 12,
        Font            = Font.Body,
        ZIndex          = 12,
        Parent          = titleBar,
    })

    -- Window controls (top right)
    local controls = Util.Create("Frame", {
        Size            = UDim2.new(0, 70, 0, 30),
        Position        = UDim2.new(1, -75, 0.5, -15),
        BackgroundTransparency = 1,
        ZIndex          = 12,
        Parent          = titleBar,
    })

    local function MakeControl(x, text, color, clickFn)
        local btn = Util.Create("TextButton", {
            Size            = UDim2.new(0, 22, 0, 22),
            Position        = UDim2.new(0, x, 0.5, -11),
            BackgroundColor3 = Theme.BG_Element,
            Text            = text,
            TextColor3      = color,
            TextSize        = 12,
            Font            = Font.Bold,
            ZIndex          = 13,
            Parent          = controls,
        })
        Util.AddCorner(btn, 5)
        btn.MouseButton1Click:Connect(clickFn)
        btn.MouseEnter:Connect(function()
            Util.Tween(btn, Anim.Fast, { BackgroundColor3 = color, TextColor3 = Color3.fromRGB(255,255,255) })
        end)
        btn.MouseLeave:Connect(function()
            Util.Tween(btn, Anim.Fast, { BackgroundColor3 = Theme.BG_Element, TextColor3 = color })
        end)
        return btn
    end

    MakeControl(0,  "_", Theme.Text_Secondary, function()
        self:Minimize()
    end)
    MakeControl(24, "×", Color3.fromRGB(220, 80, 80), function()
        self:Toggle()
    end)

    -- Make draggable
    Util.Draggable(self._root, titleBar)

    -- Left sidebar (tab list)
    self._sidebar = Util.Create("Frame", {
        Name            = "Sidebar",
        Size            = UDim2.new(0, self._tabWidth, 1, -50),
        Position        = UDim2.new(0, 0, 0, 50),
        BackgroundColor3 = Theme.BG_Secondary,
        ZIndex          = 11,
        Parent          = self._root,
    })

    -- Round bottom-left corner
    local sideCorner = Util.Create("UICorner", {
        CornerRadius = UDim.new(0, 10),
        Parent = self._sidebar,
    })

    -- Fill top of sidebar gap
    Util.Create("Frame", {
        Size    = UDim2.new(1, 0, 0, 10),
        BackgroundColor3 = Theme.BG_Secondary,
        ZIndex  = 11,
        Parent  = self._sidebar,
    })

    -- Sidebar top section labels
    local sideLayout = Util.Create("ScrollingFrame", {
        Name            = "SideScroll",
        Size            = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        ScrollBarThickness = 0,
        ZIndex          = 12,
        Parent          = self._sidebar,
    })

    local listLayout = Util.Create("UIListLayout", {
        SortOrder       = Enum.SortOrder.LayoutOrder,
        Padding         = UDim.new(0, 2),
        Parent          = sideLayout,
    })
    Util.AddPadding(sideLayout, 8, 6, 8, 6)

    listLayout.Changed:Connect(function()
        sideLayout.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 20)
    end)

    self._sideLayout  = sideLayout
    self._listLayout  = listLayout

    -- User info at bottom of sidebar
    local userFrame = Util.Create("Frame", {
        Name            = "UserInfo",
        Size            = UDim2.new(1, 0, 0, 50),
        Position        = UDim2.new(0, 0, 1, -50),
        BackgroundColor3 = Theme.BG_Primary,
        ZIndex          = 12,
        Parent          = self._sidebar,
    })

    local avatarHolder = Util.Create("Frame", {
        Size            = UDim2.new(0, 28, 0, 28),
        Position        = UDim2.new(0, 8, 0.5, -14),
        BackgroundColor3 = Theme.Accent,
        ZIndex          = 13,
        Parent          = userFrame,
    })
    Util.AddCorner(avatarHolder, 14)

    -- Try to load avatar
    local avatar = Util.Create("ImageLabel", {
        Size            = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Image           = "https://www.roblox.com/headshot-thumbnail/image?userId="
                        .. LocalPlayer.UserId .. "&width=48&height=48&format=png",
        ZIndex          = 14,
        Parent          = avatarHolder,
    })
    Util.AddCorner(avatar, 14)

    Util.Create("TextLabel", {
        Size            = UDim2.new(1, -44, 0, 16),
        Position        = UDim2.new(0, 42, 0, 9),
        BackgroundTransparency = 1,
        Text            = LocalPlayer.DisplayName,
        TextColor3      = Theme.Text_Primary,
        TextSize        = 12,
        Font            = Font.Semi,
        TextXAlignment  = Enum.TextXAlignment.Left,
        ZIndex          = 13,
        Parent          = userFrame,
    })

    Util.Create("TextLabel", {
        Size            = UDim2.new(1, -44, 0, 14),
        Position        = UDim2.new(0, 42, 0, 27),
        BackgroundTransparency = 1,
        Text            = "Till: " .. (opts.License or "Lifetime"),
        TextColor3      = Theme.Accent,
        TextSize        = 11,
        Font            = Font.Body,
        TextXAlignment  = Enum.TextXAlignment.Left,
        ZIndex          = 13,
        Parent          = userFrame,
    })

    -- Content area
    self._contentArea = Util.Create("Frame", {
        Name            = "ContentArea",
        Size            = UDim2.new(1, -(self._tabWidth + 2), 1, -50),
        Position        = UDim2.new(0, self._tabWidth + 2, 0, 50),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        ZIndex          = 11,
        Parent          = self._root,
    })

    -- Sidebar group labels tracker
    self._currentGroup = nil

    -- Toggle key
    UserInputService.InputBegan:Connect(function(input, gpe)
        if not gpe and input.KeyCode == self._toggleKey then
            self:Toggle()
        end
    end)

    -- Mobile toggle button
    if Util.IsMobile() then
        self:_SetupMobileToggle(screenGui)
    end

    -- Animate in
    self._root.Size = UDim2.new(0, self._size.X.Offset, 0, 0)
    self._root.BackgroundTransparency = 1
    Util.Tween(self._root, Anim.Spring, {
        Size = self._size,
        BackgroundTransparency = 0,
    })

    return self
end

function Window:_SetupMobileToggle(screenGui)
    local mobileBtn = Util.Create("TextButton", {
        Name            = "MobileToggle",
        Size            = UDim2.new(0, 44, 0, 44),
        Position        = UDim2.new(0, 10, 0.5, -22),
        BackgroundColor3 = Theme.Accent,
        Text            = "H",
        TextColor3      = Color3.fromRGB(255, 255, 255),
        TextSize        = 18,
        Font            = Font.Bold,
        ZIndex          = 200,
        Parent          = screenGui,
    })
    Util.AddCorner(mobileBtn, 22)
    Util.AddGlow(mobileBtn, Theme.AccentGlow, 8, 0.88)
    Util.AddShadow(mobileBtn, 8, 0.5)
    Util.Draggable(mobileBtn)

    mobileBtn.MouseButton1Click:Connect(function()
        self:Toggle()
    end)
end

function Window:_AddGroupLabel(text)
    Util.Create("TextLabel", {
        Size            = UDim2.new(1, -10, 0, 22),
        BackgroundTransparency = 1,
        Text            = text,
        TextColor3      = Theme.Text_Disabled,
        TextSize        = 10,
        Font            = Font.Bold,
        TextXAlignment  = Enum.TextXAlignment.Left,
        ZIndex          = 13,
        Parent          = self._sideLayout,
    })
end

function Window:AddTab(name, icon, group)
    if group and group ~= self._currentGroup then
        self._currentGroup = group
        self:_AddGroupLabel(group)
    end

    local tab = Tab.new(self._contentArea, 12)

    -- Sidebar tab button
    local tabBtn = Util.Create("Frame", {
        Name            = "Tab_" .. name,
        Size            = UDim2.new(1, 0, 0, 32),
        BackgroundColor3 = Theme.BG_Secondary,
        ZIndex          = 13,
        Parent          = self._sideLayout,
    })
    Util.AddCorner(tabBtn, 6)

    -- Active indicator bar
    local activeBar = Util.Create("Frame", {
        Size            = UDim2.new(0, 3, 0.6, 0),
        Position        = UDim2.new(0, 0, 0.2, 0),
        BackgroundColor3 = Theme.Accent,
        ZIndex          = 14,
        Parent          = tabBtn,
    })
    Util.AddCorner(activeBar, 2)
    activeBar.Visible = false

    -- Icon
    if icon then
        Util.Create("ImageLabel", {
            Size            = UDim2.new(0, 16, 0, 16),
            Position        = UDim2.new(0, 10, 0.5, -8),
            BackgroundTransparency = 1,
            Image           = icon,
            ImageColor3     = Theme.Text_Disabled,
            ZIndex          = 14,
            Parent          = tabBtn,
        })
    end

    local tabLabel = Util.Create("TextLabel", {
        Size            = UDim2.new(1, icon and -32 or -12, 1, 0),
        Position        = UDim2.new(0, icon and 30 or 10, 0, 0),
        BackgroundTransparency = 1,
        Text            = name,
        TextColor3      = Theme.Text_Disabled,
        TextSize        = 13,
        Font            = Font.Semi,
        TextXAlignment  = Enum.TextXAlignment.Left,
        ZIndex          = 14,
        Parent          = tabBtn,
    })

    local clickBtn = Util.Create("TextButton", {
        Size            = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text            = "",
        ZIndex          = 15,
        Parent          = tabBtn,
    })

    local function Activate()
        -- Deactivate all
        for _, t in ipairs(self._tabs) do
            t.tab._frame.Visible = false
            Util.Tween(t.btn, Anim.Fast, { BackgroundColor3 = Theme.BG_Secondary })
            Util.Tween(t.label, Anim.Fast, { TextColor3 = Theme.Text_Disabled })
            t.activeBar.Visible = false
            if t.icon then
                Util.Tween(t.icon, Anim.Fast, { ImageColor3 = Theme.Text_Disabled })
            end
        end

        -- Activate this
        tab._frame.Visible = true
        tab._frame.Position = UDim2.new(0.05, 0, 0, 0)
        tab._frame.BackgroundTransparency = 1
        Util.Tween(tab._frame, Anim.Slide, {
            Position = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1,
        })
        Util.Tween(tabBtn, Anim.Fast, { BackgroundColor3 = Theme.BG_Active })
        Util.Tween(tabLabel, Anim.Fast, { TextColor3 = Theme.Text_Primary })
        activeBar.Visible = true
        self._activeTab = tab
    end

    clickBtn.MouseButton1Click:Connect(Activate)

    clickBtn.MouseEnter:Connect(function()
        if self._activeTab ~= tab then
            Util.Tween(tabBtn, Anim.Fast, { BackgroundColor3 = Theme.BG_Hover })
        end
    end)
    clickBtn.MouseLeave:Connect(function()
        if self._activeTab ~= tab then
            Util.Tween(tabBtn, Anim.Fast, { BackgroundColor3 = Theme.BG_Secondary })
        end
    end)

    local tabData = {
        tab = tab,
        btn = tabBtn,
        label = tabLabel,
        activeBar = activeBar,
        icon = nil,
    }

    -- Store icon reference
    for _, child in ipairs(tabBtn:GetChildren()) do
        if child:IsA("ImageLabel") then
            tabData.icon = child
        end
    end

    table.insert(self._tabs, tabData)

    -- Activate first tab automatically
    if #self._tabs == 1 then
        task.defer(Activate)
    end

    return tab
end

function Window:Toggle()
    self._visible = not self._visible
    if self._visible then
        self._root.Visible = true
        Util.Tween(self._root, Anim.Spring, {
            Size = self._minimized and UDim2.new(0, self._size.X.Offset, 0, 48) or self._size,
            BackgroundTransparency = 0,
        })
    else
        Util.Tween(self._root, Anim.Normal, {
            Size = UDim2.new(0, self._size.X.Offset, 0, 0),
            BackgroundTransparency = 1,
        }):Completed:Connect(function()
            if not self._visible then
                self._root.Visible = false
            end
        end)
    end
end

function Window:Minimize()
    self._minimized = not self._minimized
    if self._minimized then
        Util.Tween(self._root, Anim.Spring, { Size = UDim2.new(0, self._size.X.Offset, 0, 48) })
    else
        Util.Tween(self._root, Anim.Spring, { Size = self._size })
    end
end

function Window:SetTitle(title, sub)
    -- update labels (kept in a real impl)
end

-- ============================================================
-- [26] MAIN LIBRARY API
-- ============================================================
local HepaUI = {}
HepaUI.__index = HepaUI

function HepaUI:Init()
    -- Create the ScreenGui
    local gui = Instance.new("ScreenGui")
    gui.Name            = "HepaUI_" .. HttpService:GenerateGUID(false):sub(1,8)
    gui.IgnoreGuiInset  = true
    gui.DisplayOrder    = 10
    gui.ResetOnSpawn    = false
    gui.ZIndexBehavior  = Enum.ZIndexBehavior.Sibling

    -- Try CoreGui first, fallback to PlayerGui
    local ok = pcall(function() gui.Parent = CoreGui end)
    if not ok then
        gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end

    self._gui              = gui
    self._windows          = {}
    self._notifications    = NotificationManager.new(gui)
    self._keybindList      = KeybindList.new(gui)
    self._watermarks       = {}

    return self
end

function HepaUI:CreateLoader(opts)
    return CreateLoader(opts)
end

function HepaUI:CreateWindow(opts)
    if not self._gui then self:Init() end
    local win = Window.new(self._gui, opts)
    table.insert(self._windows, win)
    return win
end

function HepaUI:CreateWatermark(opts)
    if not self._gui then self:Init() end
    local wm = Watermark.new(self._gui, opts)
    table.insert(self._watermarks, wm)
    return wm
end

function HepaUI:Notify(opts)
    if not self._gui then self:Init() end
    return self._notifications:Push(opts)
end

function HepaUI:GetKeybindList()
    return self._keybindList
end

function HepaUI:SetTheme(newTheme)
    for k, v in pairs(newTheme) do
        Theme[k] = v
    end
end

function HepaUI:Destroy()
    if self._gui then
        self._gui:Destroy()
    end
end

-- ============================================================
-- [27] DESTROY SAFETY (handle game:GetService calls gracefully)
-- ============================================================
game:GetService("Players").PlayerRemoving:Connect(function(p)
    if p == LocalPlayer then
        pcall(function()
            if HepaUI._gui then
                HepaUI._gui:Destroy()
            end
        end)
    end
end)

-- ============================================================
-- [28] SELF-INIT & RETURN
-- ============================================================
HepaUI:Init()

-- ============================================================
-- [EXAMPLE USAGE - Remove or comment out when using as a library]
-- ============================================================
--[[
    -- ── LOADER ──────────────────────────────────────────────────
    local Loader = HepaUI:CreateLoader({
        Title       = "Hepa",
        SubTitle    = "Initializing modules...",
        Duration    = 4,
        ShowPercentage = true,
        AccentColor = Color3.fromRGB(198, 100, 145),
        Tasks = {
            "Loading core modules",
            "Connecting to server",
            "Applying configurations",
            "Finalizing setup",
        },
        OnComplete = function()
            print("Loader finished!")
        end,
    })

    Loader.Completed:Connect(function()
        -- ── WATERMARK ───────────────────────────────────────────
        local WM = HepaUI:CreateWatermark({
            Text    = "HEPA",
            SubText = "v2.0 | Legit",
        })

        -- ── WINDOW ──────────────────────────────────────────────
        local Window = HepaUI:CreateWindow({
            Title     = "HEPA",
            SubTitle  = "UI Library",
            TabWidth  = 160,
            ToggleKey = Enum.KeyCode.RightShift,
            License   = "25.09.2023",
        })

        -- ── AIMBOT TAB ──────────────────────────────────────────
        local AimbotTab = Window:AddTab("Legit Bot",  Icons.legit,   "Aimbot")
        local RageTab   = Window:AddTab("Rage Bot",   Icons.rage,    "Aimbot")
        local AntiAim   = Window:AddTab("Anti-Aims",  Icons.antiAim, "Aimbot")

        local VisPlayers = Window:AddTab("Players", Icons.players, "Visuals")
        local VisWorld   = Window:AddTab("World",   Icons.world,   "Visuals")
        local VisView    = Window:AddTab("View",    Icons.view,    "Visuals")

        local MiscMain  = Window:AddTab("Main",      Icons.main,      "Miscellaneous")
        local MiscInv   = Window:AddTab("Inventory", Icons.inventory, "Miscellaneous")
        local MiscConf  = Window:AddTab("Configs",   Icons.configs,   "Miscellaneous")

        -- ── GENERAL SECTION ─────────────────────────────────────
        local General = AimbotTab:AddSection("General")

        General:AddToggle("Enable Particles", true, function(v)
            print("Enable Particles:", v)
        end)

        General:AddSlider("FOV", 0, 360, 100, function(v)
            print("FOV:", v)
        end, { Suffix = "°" })

        General:AddToggle("Autofire", false, function(v) end)
        General:AddToggle("Autowall", true,  function(v) end)
        General:AddToggle("Silent Aim", true, function(v) end)
        General:AddToggle("Quick Peek", true, function(v) end)

        -- ── ACCURACY SECTION ────────────────────────────────────
        local Accuracy = AimbotTab:AddSection("Accuracy")

        Accuracy:AddToggle("Automatic Stop", true, function(v) end)

        Accuracy:AddDropdown("Combo Type", {"None","Low","Medium","High"}, "None", function(v) end)

        Accuracy:AddToggle("Hitchance", true, function(v) end)

        Accuracy:AddSlider("Hitchance Value", 0, 100, 0, function(v) end, { Suffix = "%" })

        Accuracy:AddSlider("Damage Value", 0, 100, 20, function(v) end, { Suffix = "%" })

        Accuracy:AddSlider("Damage Override Value", 0, 100, 56, function(v) end, { Suffix = "%" })

        -- ── EXPLOITS SECTION ────────────────────────────────────
        local Exploits = AimbotTab:AddSection("Exploits")

        Exploits:AddToggle("Lag Peek", true, function(v) end)
        Exploits:AddToggle("Hide Shots", true, function(v) end)
        Exploits:AddToggle("Double Tab", true, function(v) end)

        -- ── MISC SECTION ────────────────────────────────────────
        local Misc = AimbotTab:AddSection("Misc")

        Misc:AddToggle("Prefer A Pont", false, function(v) end)
        Misc:AddToggle("Prefer Body Aim", true, function(v) end)
        Misc:AddToggle("Ignore Limbs When Moving", true, function(v) end)
        Misc:AddColorPicker("Aim Line Color", Color3.fromRGB(198, 100, 145), function(v) end)

        -- ── OVERRIDE CONFIG SECTION ─────────────────────────────
        local Override = AimbotTab:AddSection("Override Config")
        Override:AddDropdown("Types", {"Default","Aggressive","Passive","Custom"}, "Default", function(v) end)

        -- ── KEYBINDS ────────────────────────────────────────────
        local KBL = HepaUI:GetKeybindList()
        KBL:Add("Aimbot Toggle",  "Z")
        KBL:Add("Menu Toggle",    "RShift")
        KBL:Add("Triggerbot",     "X")
        KBL:Add("Backtrack",      "C")

        -- ── NOTIFICATIONS ───────────────────────────────────────
        HepaUI:Notify({
            Title    = "HepaUI Loaded",
            Desc     = "Library initialized successfully.",
            Type     = "Success",
            Duration = 4,
        })
    end)
]]

return HepaUI
