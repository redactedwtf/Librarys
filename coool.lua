--[[
 ██╗  ██╗███████╗██████╗  █████╗ ██╗   ██╗██╗
 ██║  ██║██╔════╝██╔══██╗██╔══██╗██║   ██║██║
 ███████║█████╗  ██████╔╝███████║██║   ██║██║
 ██╔══██║██╔══╝  ██╔═══╝ ██╔══██║██║   ██║██║
 ██║  ██║███████╗██║     ██║  ██║╚██████╔╝██║
 ╚═╝  ╚═╝╚══════╝╚═╝     ╚═╝  ╚═╝ ╚═════╝ ╚═╝
          HepaUI  ·  v2.1  ·  Mobile Ready
]]

local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local Players          = game:GetService("Players")
local CoreGui          = game:GetService("CoreGui")
local TextService      = game:GetService("TextService")
local HttpService      = game:GetService("HttpService")

local LP  = Players.LocalPlayer
local PGui = LP:WaitForChild("PlayerGui")

local T = {
    BG1          = Color3.fromRGB(24, 24, 28),
    BG2          = Color3.fromRGB(19, 19, 23),
    BG3          = Color3.fromRGB(32, 32, 38),
    BG4          = Color3.fromRGB(40, 40, 48),
    BGHover      = Color3.fromRGB(48, 48, 58),
    BGActive     = Color3.fromRGB(44, 36, 50),
    Accent       = Color3.fromRGB(198, 100, 145),
    AccentDark   = Color3.fromRGB(140, 60, 100),
    AccentLight  = Color3.fromRGB(230, 140, 175),
    TextPri      = Color3.fromRGB(228, 228, 232),
    TextSec      = Color3.fromRGB(150, 150, 160),
    TextDis      = Color3.fromRGB(80, 80, 92),
    TextAcc      = Color3.fromRGB(210, 120, 160),
    Border       = Color3.fromRGB(52, 52, 62),
    Divider      = Color3.fromRGB(42, 42, 52),
    SliderFill   = Color3.fromRGB(178, 78, 128),
    SliderBG     = Color3.fromRGB(36, 36, 44),
    TogOn        = Color3.fromRGB(198, 100, 145),
    TogOff       = Color3.fromRGB(52, 52, 62),
    Knob         = Color3.fromRGB(240, 240, 245),
    DropBG       = Color3.fromRGB(24, 24, 30),
    DropItem     = Color3.fromRGB(32, 32, 40),
    DropHover    = Color3.fromRGB(48, 36, 54),
    NotifBG      = Color3.fromRGB(26, 26, 34),
    WMbg         = Color3.fromRGB(20, 20, 26),
    LoadBG       = Color3.fromRGB(16, 16, 20),
    LoadBar      = Color3.fromRGB(198, 100, 145),
    LoadBarBG    = Color3.fromRGB(36, 36, 44),
    KeyBG        = Color3.fromRGB(20, 20, 26),
}

local F = {
    Title  = Enum.Font.GothamBold,
    Bold   = Enum.Font.GothamBold,
    Semi   = Enum.Font.GothamSemibold,
    Body   = Enum.Font.Gotham,
    Mono   = Enum.Font.Code,
}

local A = {
    Fast   = TweenInfo.new(0.12, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    Norm   = TweenInfo.new(0.20, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    Slow   = TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    Spring = TweenInfo.new(0.40, Enum.EasingStyle.Back,  Enum.EasingDirection.Out),
    Slide  = TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
    Linear = TweenInfo.new(0.20, Enum.EasingStyle.Linear),
}

local U = {}

function U.Tween(o, i, p)
    if not o or not o.Parent then return end
    local t = TweenService:Create(o, i, p)
    t:Play()
    return t
end

function U.New(cls, props)
    local ok, obj = pcall(Instance.new, cls)
    if not ok then return nil end
    local parent = props.Parent
    props.Parent = nil
    for k, v in pairs(props) do
        pcall(function() obj[k] = v end)
    end
    if parent then obj.Parent = parent end
    return obj
end

function U.Corner(p, r)
    return U.New("UICorner", { CornerRadius = UDim.new(0, r or 6), Parent = p })
end

function U.Pad(p, t, r, b, l)
    return U.New("UIPadding", {
        PaddingTop    = UDim.new(0, t or 8),
        PaddingRight  = UDim.new(0, r or 8),
        PaddingBottom = UDim.new(0, b or 8),
        PaddingLeft   = UDim.new(0, l or 8),
        Parent        = p,
    })
end

function U.Stroke(p, c, th, tr)
    return U.New("UIStroke", {
        Color        = c  or T.Border,
        Thickness    = th or 1,
        Transparency = tr or 0,
        Parent       = p,
    })
end

function U.Glow(frame, color, sz, tr)
    if not frame then return end
    sz = sz or 12; tr = tr or 0.85; color = color or T.Accent
    local g = U.New("ImageLabel", {
        Name                   = "Glow",
        Size                   = UDim2.new(1, sz*2, 1, sz*2),
        Position               = UDim2.new(0, -sz, 0, -sz),
        BackgroundTransparency = 1,
        Image                  = "rbxassetid://6014260067",
        ImageColor3            = color,
        ImageTransparency      = tr,
        ScaleType              = Enum.ScaleType.Slice,
        SliceCenter            = Rect.new(49, 49, 450, 450),
        ZIndex                 = math.max(0, frame.ZIndex - 1),
        Parent                 = frame,
    })
    return g
end

function U.Shadow(frame, sz, tr)
    if not frame then return end
    sz = sz or 15; tr = tr or 0.7
    local s = U.New("ImageLabel", {
        Name                   = "Shadow",
        Size                   = UDim2.new(1, sz*2, 1, sz*2),
        Position               = UDim2.new(0, -sz, 0, -sz),
        BackgroundTransparency = 1,
        Image                  = "rbxassetid://6014261993",
        ImageColor3            = Color3.new(0, 0, 0),
        ImageTransparency      = tr,
        ScaleType              = Enum.ScaleType.Slice,
        SliceCenter            = Rect.new(49, 49, 450, 450),
        ZIndex                 = math.max(0, frame.ZIndex - 1),
        Parent                 = frame,
    })
    return s
end

function U.IsMobile()
    return UserInputService.TouchEnabled and not UserInputService.MouseEnabled
end

function U.Draggable(root, handle)
    handle = handle or root
    local dragging, startPos, startFrame
    local conn1 = handle.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1
        or inp.UserInputType == Enum.UserInputType.Touch then
            dragging   = true
            startPos   = inp.Position
            startFrame = root.Position
        end
    end)
    local conn2 = UserInputService.InputChanged:Connect(function(inp)
        if dragging and (inp.UserInputType == Enum.UserInputType.MouseMovement
        or inp.UserInputType == Enum.UserInputType.Touch) then
            local d = inp.Position - startPos
            root.Position = UDim2.new(
                startFrame.X.Scale, startFrame.X.Offset + d.X,
                startFrame.Y.Scale, startFrame.Y.Offset + d.Y
            )
        end
    end)
    local conn3 = UserInputService.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1
        or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

local Signal = {}
Signal.__index = Signal
function Signal.new()
    return setmetatable({ _c = {} }, Signal)
end
function Signal:Connect(fn)
    local c = { fn = fn, sig = self }
    table.insert(self._c, c)
    function c:Disconnect()
        for i, x in ipairs(self.sig._c) do
            if x == self then table.remove(self.sig._c, i); break end
        end
    end
    return c
end
function Signal:Fire(...)
    for _, c in ipairs(self._c) do
        task.spawn(c.fn, ...)
    end
end
function Signal:Destroy()
    self._c = {}
end

local function MakeGui()
    local old = CoreGui:FindFirstChild("HepaUI")
    if old then old:Destroy() end
    local old2 = PGui:FindFirstChild("HepaUI")
    if old2 then old2:Destroy() end
    local g = Instance.new("ScreenGui")
    g.Name           = "HepaUI"
    g.IgnoreGuiInset = true
    g.DisplayOrder   = 50
    g.ResetOnSpawn   = false
    g.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    local ok = pcall(function() g.Parent = CoreGui end)
    if not ok then g.Parent = PGui end
    return g
end

local function BuildNotifManager(sg)
    local holder = U.New("Frame", {
        Name                   = "Notifs",
        Size                   = UDim2.new(0, 290, 1, 0),
        Position               = UDim2.new(1, -300, 0, 0),
        BackgroundTransparency = 1,
        ZIndex                 = 200,
        Parent                 = sg,
    })
    U.New("UIListLayout", {
        SortOrder         = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Bottom,
        Padding           = UDim.new(0, 6),
        Parent            = holder,
    })
    U.Pad(holder, 8, 0, 8, 0)

    local NM = {}
    function NM:Push(opts)
        opts = opts or {}
        local title    = opts.Title    or "Notice"
        local desc     = opts.Desc     or ""
        local dur      = opts.Duration or 4
        local ntype    = opts.Type     or "Info"
        local colors   = {
            Info    = T.Accent,
            Success = Color3.fromRGB(90, 195, 110),
            Warning = Color3.fromRGB(215, 165, 50),
            Error   = Color3.fromRGB(215, 75, 75),
        }
        local ac = colors[ntype] or T.Accent

        local notif = U.New("Frame", {
            Name                   = "Notif",
            Size                   = UDim2.new(1, 0, 0, 0),
            BackgroundColor3       = T.NotifBG,
            ClipsDescendants       = true,
            ZIndex                 = 201,
            Parent                 = holder,
        })
        U.Corner(notif, 8)
        U.Stroke(notif, ac, 1, 0.4)
        U.Shadow(notif, 8, 0.55)

        U.New("Frame", {
            Size             = UDim2.new(0, 3, 1, 0),
            BackgroundColor3 = ac,
            ZIndex           = 202,
            Parent           = notif,
        })

        local inner = U.New("Frame", {
            Size                   = UDim2.new(1, -12, 1, 0),
            Position               = UDim2.new(0, 8, 0, 0),
            BackgroundTransparency = 1,
            ZIndex                 = 202,
            Parent                 = notif,
        })

        U.New("TextLabel", {
            Size                   = UDim2.new(1, 0, 0, 18),
            Position               = UDim2.new(0, 0, 0, 8),
            BackgroundTransparency = 1,
            Text                   = title,
            TextColor3             = ac,
            TextSize               = 13,
            Font                   = F.Bold,
            TextXAlignment         = Enum.TextXAlignment.Left,
            ZIndex                 = 203,
            Parent                 = inner,
        })

        U.New("TextLabel", {
            Size                   = UDim2.new(1, 0, 0, 28),
            Position               = UDim2.new(0, 0, 0, 26),
            BackgroundTransparency = 1,
            Text                   = desc,
            TextColor3             = T.TextSec,
            TextSize               = 12,
            Font                   = F.Body,
            TextXAlignment         = Enum.TextXAlignment.Left,
            TextWrapped            = true,
            ZIndex                 = 203,
            Parent                 = inner,
        })

        local pbg = U.New("Frame", {
            Size             = UDim2.new(1, -10, 0, 3),
            Position         = UDim2.new(0, 5, 1, -7),
            BackgroundColor3 = T.BG4,
            ZIndex           = 203,
            Parent           = notif,
        })
        U.Corner(pbg, 2)
        local pbar = U.New("Frame", {
            Size             = UDim2.new(1, 0, 1, 0),
            BackgroundColor3 = ac,
            ZIndex           = 204,
            Parent           = pbg,
        })
        U.Corner(pbar, 2)

        local totalH = 72
        U.Tween(notif, A.Spring, { Size = UDim2.new(1, 0, 0, totalH) })

        local prog = TweenService:Create(pbar, TweenInfo.new(dur, Enum.EasingStyle.Linear), { Size = UDim2.new(0, 0, 1, 0) })
        prog:Play()
        prog.Completed:Connect(function()
            U.Tween(notif, A.Norm, { Size = UDim2.new(1, 0, 0, 0) }):Completed:Connect(function()
                pcall(function() notif:Destroy() end)
            end)
        end)
    end
    return NM
end

local function BuildKeybindList(sg)
    local frame = U.New("Frame", {
        Name             = "KeybindList",
        Size             = UDim2.new(0, 195, 0, 30),
        Position         = UDim2.new(0, 8, 1, -42),
        BackgroundColor3 = T.KeyBG,
        ZIndex           = 100,
        Parent           = sg,
    })
    U.Corner(frame, 7)
    U.Stroke(frame, T.Border, 1)
    U.Shadow(frame, 8, 0.6)
    U.Draggable(frame)

    local hdr = U.New("Frame", {
        Size             = UDim2.new(1, 0, 0, 28),
        BackgroundColor3 = T.BG2,
        ZIndex           = 101,
        Parent           = frame,
    })
    U.Corner(hdr, 7)
    U.New("Frame", {
        Size             = UDim2.new(1, 0, 0, 8),
        Position         = UDim2.new(0, 0, 1, -8),
        BackgroundColor3 = T.BG2,
        ZIndex           = 101,
        Parent           = hdr,
    })
    U.New("TextLabel", {
        Size                   = UDim2.new(1, -8, 1, 0),
        Position               = UDim2.new(0, 8, 0, 0),
        BackgroundTransparency = 1,
        Text                   = "KEYBINDS",
        TextColor3             = T.Accent,
        TextSize               = 10,
        Font                   = F.Bold,
        TextXAlignment         = Enum.TextXAlignment.Left,
        ZIndex                 = 102,
        Parent                 = hdr,
    })

    local list = U.New("Frame", {
        Size                   = UDim2.new(1, 0, 0, 0),
        Position               = UDim2.new(0, 0, 0, 30),
        BackgroundTransparency = 1,
        ZIndex                 = 101,
        Parent                 = frame,
    })
    local layout = U.New("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding   = UDim.new(0, 1),
        Parent    = list,
    })
    U.Pad(list, 3, 6, 3, 6)

    local KBL = {}
    local entries = {}

    local function Resize()
        local h = 32
        for _, c in ipairs(list:GetChildren()) do
            if c:IsA("Frame") then h = h + c.AbsoluteSize.Y + 1 end
        end
        U.Tween(frame, A.Fast, { Size = UDim2.new(0, 195, 0, h + 6) })
    end

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(Resize)

    function KBL:Add(lbl, key, cb)
        local row = U.New("Frame", {
            Size                   = UDim2.new(1, 0, 0, 22),
            BackgroundTransparency = 1,
            ZIndex                 = 102,
            Parent                 = list,
        })
        U.New("TextLabel", {
            Size                   = UDim2.new(0.6, 0, 1, 0),
            BackgroundTransparency = 1,
            Text                   = lbl,
            TextColor3             = T.TextSec,
            TextSize               = 11,
            Font                   = F.Body,
            TextXAlignment         = Enum.TextXAlignment.Left,
            ZIndex                 = 103,
            Parent                 = row,
        })
        local badge = U.New("Frame", {
            Size             = UDim2.new(0, 56, 0, 18),
            Position         = UDim2.new(1, -58, 0.5, -9),
            BackgroundColor3 = T.BG4,
            ZIndex           = 103,
            Parent           = row,
        })
        U.Corner(badge, 4)
        U.Stroke(badge, T.Border, 1)
        local kl = U.New("TextLabel", {
            Size                   = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Text                   = tostring(key or "None"),
            TextColor3             = T.Accent,
            TextSize               = 11,
            Font                   = F.Semi,
            ZIndex                 = 104,
            Parent                 = badge,
        })
        table.insert(entries, { row = row, lbl = lbl, key = key, keyLabel = kl, cb = cb })
        Resize()
        return { Row = row, KeyLabel = kl }
    end

    function KBL:Remove(lbl)
        for i, e in ipairs(entries) do
            if e.lbl == lbl then
                pcall(function() e.row:Destroy() end)
                table.remove(entries, i)
                break
            end
        end
        Resize()
    end

    function KBL:SetVisible(v)
        frame.Visible = v
    end

    return KBL
end

local function BuildWatermark(sg, opts)
    opts = opts or {}
    local txt  = opts.Text    or "HepaUI"
    local sub  = opts.SubText or "v2.1"
    local pos  = opts.Position or UDim2.new(0.5, 0, 0, 8)

    local frame = U.New("Frame", {
        Name             = "Watermark",
        Size             = UDim2.new(0, 220, 0, 34),
        Position         = pos,
        AnchorPoint      = Vector2.new(0.5, 0),
        BackgroundColor3 = T.WMbg,
        ZIndex           = 150,
        Parent           = sg,
    })
    U.Corner(frame, 7)
    U.Stroke(frame, T.Accent, 1, 0.35)
    U.Glow(frame, T.Accent, 7, 0.88)
    U.Shadow(frame, 10, 0.58)
    U.Draggable(frame)

    U.New("Frame", {
        Size             = UDim2.new(0, 2, 0.6, 0),
        Position         = UDim2.new(0, 5, 0.2, 0),
        BackgroundColor3 = T.Accent,
        ZIndex           = 151,
        Parent           = frame,
    })

    local tl = U.New("TextLabel", {
        Size                   = UDim2.new(1, -80, 0, 18),
        Position               = UDim2.new(0, 12, 0, 4),
        BackgroundTransparency = 1,
        Text                   = txt,
        TextColor3             = T.TextPri,
        TextSize               = 13,
        Font                   = F.Bold,
        TextXAlignment         = Enum.TextXAlignment.Left,
        ZIndex                 = 152,
        Parent                 = frame,
    })
    local sl = U.New("TextLabel", {
        Size                   = UDim2.new(1, -80, 0, 14),
        Position               = UDim2.new(0, 12, 0, 20),
        BackgroundTransparency = 1,
        Text                   = sub,
        TextColor3             = T.TextSec,
        TextSize               = 11,
        Font                   = F.Body,
        TextXAlignment         = Enum.TextXAlignment.Left,
        ZIndex                 = 152,
        Parent                 = frame,
    })
    local fpsL = U.New("TextLabel", {
        Size                   = UDim2.new(0, 60, 0, 14),
        Position               = UDim2.new(1, -65, 0, 4),
        BackgroundTransparency = 1,
        Text                   = "60 FPS",
        TextColor3             = T.Accent,
        TextSize               = 11,
        Font                   = F.Semi,
        TextXAlignment         = Enum.TextXAlignment.Right,
        ZIndex                 = 152,
        Parent                 = frame,
    })
    local clkL = U.New("TextLabel", {
        Size                   = UDim2.new(0, 60, 0, 14),
        Position               = UDim2.new(1, -65, 0, 18),
        BackgroundTransparency = 1,
        Text                   = "00:00",
        TextColor3             = T.TextSec,
        TextSize               = 11,
        Font                   = F.Body,
        TextXAlignment         = Enum.TextXAlignment.Right,
        ZIndex                 = 152,
        Parent                 = frame,
    })

    local frames = 0
    local last   = tick()
    RunService.RenderStepped:Connect(function()
        frames = frames + 1
        local now = tick()
        if now - last >= 1 then
            pcall(function() fpsL.Text = frames .. " FPS" end)
            frames = 0; last = now
        end
        pcall(function() clkL.Text = os.date("%H:%M") end)
    end)

    local WM = {}
    function WM:SetText(t2, s2)
        pcall(function() tl.Text = t2 or txt end)
        pcall(function() sl.Text = s2 or sub end)
    end
    function WM:SetVisible(v)
        frame.Visible = v
    end
    function WM:Destroy()
        pcall(function() frame:Destroy() end)
    end
    return WM
end

local function BuildLoader(sg, opts)
    opts = opts or {}
    local title   = opts.Title       or "HepaUI"
    local subT    = opts.SubTitle    or "Loading..."
    local dur     = opts.Duration    or 3
    local tasks   = opts.Tasks       or { "Initializing" }
    local ac      = opts.AccentColor or T.Accent
    local onDone  = opts.OnComplete  or function() end
    local showP   = opts.ShowPercentage ~= false

    local frame = U.New("Frame", {
        Size             = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = T.LoadBG,
        ZIndex           = 500,
        Parent           = sg,
    })

    for i = 1, 18 do
        local dot = U.New("Frame", {
            Size             = UDim2.new(0, math.random(3,6), 0, math.random(3,6)),
            Position         = UDim2.new(math.random()/1, 0, math.random()/1, 0),
            BackgroundColor3 = ac,
            BackgroundTransparency = math.random(75,95)/100,
            ZIndex           = 501,
            Parent           = frame,
        })
        U.Corner(dot, 99)
        local sy  = dot.Position.Y.Scale
        local amp = math.random(1,4)/100
        local spd = 1 + math.random()*2
        local off = math.random()*math.pi*2
        RunService.Heartbeat:Connect(function()
            pcall(function()
                dot.Position = UDim2.new(dot.Position.X.Scale, 0, sy + math.sin(tick()*spd+off)*amp, 0)
            end)
        end)
    end

    local card = U.New("Frame", {
        Size             = UDim2.new(0, 360, 0, 240),
        Position         = UDim2.new(0.5, -180, 0.5, -120),
        BackgroundColor3 = T.BG1,
        ZIndex           = 502,
        Parent           = frame,
    })
    U.Corner(card, 12)
    U.Stroke(card, ac, 1, 0.5)
    U.Glow(card, ac, 16, 0.83)
    U.Shadow(card, 18, 0.48)

    U.New("Frame", {
        Size             = UDim2.new(1, 0, 0, 3),
        BackgroundColor3 = ac,
        ZIndex           = 503,
        Parent           = card,
    })

    U.New("TextLabel", {
        Size                   = UDim2.new(1, 0, 0, 34),
        Position               = UDim2.new(0, 0, 0, 22),
        BackgroundTransparency = 1,
        Text                   = title,
        TextColor3             = T.TextPri,
        TextSize               = 26,
        Font                   = F.Title,
        ZIndex                 = 503,
        Parent                 = card,
    })
    U.New("TextLabel", {
        Size                   = UDim2.new(1, 0, 0, 20),
        Position               = UDim2.new(0, 0, 0, 56),
        BackgroundTransparency = 1,
        Text                   = subT,
        TextColor3             = T.TextSec,
        TextSize               = 13,
        Font                   = F.Body,
        ZIndex                 = 503,
        Parent                 = card,
    })

    local taskL = U.New("TextLabel", {
        Size                   = UDim2.new(1, -40, 0, 16),
        Position               = UDim2.new(0, 20, 0, 142),
        BackgroundTransparency = 1,
        Text                   = tasks[1] or "Loading...",
        TextColor3             = T.TextSec,
        TextSize               = 12,
        Font                   = F.Body,
        TextXAlignment         = Enum.TextXAlignment.Left,
        ZIndex                 = 503,
        Parent                 = card,
    })
    local percL = U.New("TextLabel", {
        Size                   = UDim2.new(0, 40, 0, 16),
        Position               = UDim2.new(1, -50, 0, 142),
        BackgroundTransparency = 1,
        Text                   = "0%",
        TextColor3             = ac,
        TextSize               = 12,
        Font                   = F.Semi,
        TextXAlignment         = Enum.TextXAlignment.Right,
        ZIndex                 = 503,
        Visible                = showP,
        Parent                 = card,
    })

    local barBG = U.New("Frame", {
        Size             = UDim2.new(1, -40, 0, 5),
        Position         = UDim2.new(0, 20, 0, 164),
        BackgroundColor3 = T.LoadBarBG,
        ZIndex           = 503,
        Parent           = card,
    })
    U.Corner(barBG, 3)
    local bar = U.New("Frame", {
        Size             = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = ac,
        ZIndex           = 504,
        Parent           = barBG,
    })
    U.Corner(bar, 3)

    local shimmer = U.New("Frame", {
        Size             = UDim2.new(0.25, 0, 1, 0),
        BackgroundColor3 = Color3.new(1, 1, 1),
        BackgroundTransparency = 0.82,
        ZIndex           = 505,
        Parent           = bar,
    })
    U.Corner(shimmer, 3)

    local dots = {}
    local dotF = U.New("Frame", {
        Size                   = UDim2.new(0, 36, 0, 8),
        Position               = UDim2.new(0.5, -18, 0, 182),
        BackgroundTransparency = 1,
        ZIndex                 = 503,
        Parent                 = card,
    })
    for i = 1, 3 do
        local d = U.New("Frame", {
            Size             = UDim2.new(0, 6, 0, 6),
            Position         = UDim2.new(0, (i-1)*15, 0.5, -3),
            BackgroundColor3 = i == 1 and ac or T.BG4,
            ZIndex           = 504,
            Parent           = dotF,
        })
        U.Corner(d, 3)
        dots[i] = d
    end

    local completed = Signal.new()
    local dIdx = 1

    task.spawn(function()
        while true do
            for i = 1, 3 do
                pcall(function() dots[i].BackgroundColor3 = i == dIdx and ac or T.BG4 end)
            end
            dIdx = dIdx % 3 + 1
            task.wait(0.33)
        end
    end)

    task.spawn(function()
        local n = math.max(#tasks, 1)
        local perT = dur / n
        for i, tname in ipairs(tasks) do
            pcall(function() taskL.Text = tname end)
            local s0 = (i-1)/n
            local s1 = i/n
            local st = tick()
            while tick()-st < perT do
                local frac = math.clamp((tick()-st)/perT, 0, 1)
                local p = s0 + (s1-s0)*frac
                pcall(function()
                    bar.Size = UDim2.new(p, 0, 1, 0)
                    percL.Text = math.floor(p*100) .. "%"
                end)
                task.wait()
            end
        end
        pcall(function()
            bar.Size = UDim2.new(1, 0, 1, 0)
            percL.Text = "100%"
        end)
        task.wait(0.4)
        U.Tween(frame, TweenInfo.new(0.45, Enum.EasingStyle.Quart), { BackgroundTransparency = 1 })
        for _, d in ipairs(frame:GetDescendants()) do
            pcall(function()
                if d:IsA("TextLabel") then U.Tween(d, A.Norm, { TextTransparency = 1 }) end
                if d:IsA("Frame") and d ~= frame then U.Tween(d, A.Norm, { BackgroundTransparency = 1 }) end
                if d:IsA("ImageLabel") then U.Tween(d, A.Norm, { ImageTransparency = 1 }) end
            end)
        end
        task.wait(0.55)
        pcall(function() frame:Destroy() end)
        onDone()
        completed:Fire()
    end)

    return { Completed = completed, Frame = frame }
end

local function MakeToggle(parent, opts, zbase)
    local lbl  = opts.Label    or "Toggle"
    local def  = opts.Default  or false
    local desc = opts.Desc     or ""
    local cb   = opts.Callback or function() end
    local z    = zbase or 10

    local state   = def
    local changed = Signal.new()

    local h = desc ~= "" and 46 or 34
    local f = U.New("Frame", {
        Size             = UDim2.new(1, 0, 0, h),
        BackgroundColor3 = T.BG3,
        ZIndex           = z,
        Parent           = parent,
    })
    U.Corner(f, 6)

    U.New("TextLabel", {
        Size                   = UDim2.new(1, -58, 0, 18),
        Position               = UDim2.new(0, 10, 0, desc ~= "" and 6 or 8),
        BackgroundTransparency = 1,
        Text                   = lbl,
        TextColor3             = T.TextPri,
        TextSize               = 13,
        Font                   = F.Semi,
        TextXAlignment         = Enum.TextXAlignment.Left,
        ZIndex                 = z+1,
        Parent                 = f,
    })

    if desc ~= "" then
        U.New("TextLabel", {
            Size                   = UDim2.new(1, -58, 0, 14),
            Position               = UDim2.new(0, 10, 0, 26),
            BackgroundTransparency = 1,
            Text                   = desc,
            TextColor3             = T.TextDis,
            TextSize               = 11,
            Font                   = F.Body,
            TextXAlignment         = Enum.TextXAlignment.Left,
            ZIndex                 = z+1,
            Parent                 = f,
        })
    end

    local tw, th = 38, 20
    local track = U.New("Frame", {
        Size             = UDim2.new(0, tw, 0, th),
        Position         = UDim2.new(1, -(tw+10), 0.5, -th/2),
        BackgroundColor3 = state and T.TogOn or T.TogOff,
        ZIndex           = z+1,
        Parent           = f,
    })
    U.Corner(track, 10)

    local ks = th - 6
    local knob = U.New("Frame", {
        Size             = UDim2.new(0, ks, 0, ks),
        Position         = state and UDim2.new(0, tw-ks-3, 0.5, -ks/2) or UDim2.new(0, 3, 0.5, -ks/2),
        BackgroundColor3 = T.Knob,
        ZIndex           = z+2,
        Parent           = track,
    })
    U.Corner(knob, ks)

    local function Set(v)
        state = v
        U.Tween(track, A.Fast, { BackgroundColor3 = v and T.TogOn or T.TogOff })
        U.Tween(knob,  A.Fast, { Position = v and UDim2.new(0, tw-ks-3, 0.5, -ks/2) or UDim2.new(0, 3, 0.5, -ks/2) })
        pcall(cb, v)
        changed:Fire(v)
    end

    local btn = U.New("TextButton", {
        Size                   = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text                   = "",
        ZIndex                 = z+3,
        Parent                 = f,
    })
    btn.MouseButton1Click:Connect(function() Set(not state) end)
    btn.MouseEnter:Connect(function() U.Tween(f, A.Fast, { BackgroundColor3 = T.BGHover }) end)
    btn.MouseLeave:Connect(function() U.Tween(f, A.Fast, { BackgroundColor3 = T.BG3 }) end)

    return { Frame = f, Set = function(_, v) Set(v) end, Get = function() return state end, Changed = changed }
end

local function MakeSlider(parent, opts, zbase)
    local lbl  = opts.Label    or "Slider"
    local mn   = opts.Min      or 0
    local mx   = opts.Max      or 100
    local def  = opts.Default  or mn
    local step = opts.Step     or 1
    local suf  = opts.Suffix   or ""
    local cb   = opts.Callback or function() end
    local z    = zbase or 10

    local val     = def
    local changed = Signal.new()
    local drag    = false

    local f = U.New("Frame", {
        Size             = UDim2.new(1, 0, 0, 52),
        BackgroundColor3 = T.BG3,
        ZIndex           = z,
        Parent           = parent,
    })
    U.Corner(f, 6)

    U.New("TextLabel", {
        Size                   = UDim2.new(0.65, 0, 0, 18),
        Position               = UDim2.new(0, 10, 0, 8),
        BackgroundTransparency = 1,
        Text                   = lbl,
        TextColor3             = T.TextPri,
        TextSize               = 13,
        Font                   = F.Semi,
        TextXAlignment         = Enum.TextXAlignment.Left,
        ZIndex                 = z+1,
        Parent                 = f,
    })

    local valL = U.New("TextLabel", {
        Size                   = UDim2.new(0.35, -10, 0, 18),
        Position               = UDim2.new(0.65, 0, 0, 8),
        BackgroundTransparency = 1,
        Text                   = tostring(val)..suf,
        TextColor3             = T.Accent,
        TextSize               = 13,
        Font                   = F.Semi,
        TextXAlignment         = Enum.TextXAlignment.Right,
        ZIndex                 = z+1,
        Parent                 = f,
    })

    local trackBG = U.New("Frame", {
        Size             = UDim2.new(1, -20, 0, 5),
        Position         = UDim2.new(0, 10, 0, 34),
        BackgroundColor3 = T.SliderBG,
        ZIndex           = z+1,
        Parent           = f,
    })
    U.Corner(trackBG, 3)

    local fill = U.New("Frame", {
        Size             = UDim2.new((val-mn)/(mx-mn), 0, 1, 0),
        BackgroundColor3 = T.SliderFill,
        ZIndex           = z+2,
        Parent           = trackBG,
    })
    U.Corner(fill, 3)

    local knobS = U.New("Frame", {
        Size        = UDim2.new(0, 13, 0, 13),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position    = UDim2.new((val-mn)/(mx-mn), 0, 0.5, 0),
        BackgroundColor3 = Color3.new(1,1,1),
        ZIndex      = z+3,
        Parent      = trackBG,
    })
    U.Corner(knobS, 7)
    U.Stroke(knobS, T.Accent, 2)

    local function SetVal(v)
        v = math.clamp(math.round((v-mn)/step)*step+mn, mn, mx)
        val = v
        local frac = (v-mn)/(mx-mn)
        U.Tween(fill,  A.Fast, { Size = UDim2.new(frac, 0, 1, 0) })
        U.Tween(knobS, A.Fast, { Position = UDim2.new(frac, 0, 0.5, 0) })
        pcall(function() valL.Text = tostring(v)..suf end)
        pcall(cb, v)
        changed:Fire(v)
    end

    local function FromInput(inp)
        local ax = trackBG.AbsolutePosition.X
        local aw = trackBG.AbsoluteSize.X
        local rel = math.clamp((inp.Position.X - ax)/aw, 0, 1)
        SetVal(mn + rel*(mx-mn))
    end

    local hit = U.New("TextButton", {
        Size                   = UDim2.new(1, 0, 0, 24),
        Position               = UDim2.new(0, 0, 0, 26),
        BackgroundTransparency = 1,
        Text                   = "",
        ZIndex                 = z+4,
        Parent                 = f,
    })
    hit.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            drag = true; FromInput(inp)
        end
    end)
    hit.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            drag = false
        end
    end)
    UserInputService.InputChanged:Connect(function(inp)
        if drag and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
            FromInput(inp)
        end
    end)

    f.MouseEnter:Connect(function() U.Tween(f, A.Fast, { BackgroundColor3 = T.BGHover }) end)
    f.MouseLeave:Connect(function() U.Tween(f, A.Fast, { BackgroundColor3 = T.BG3 }) end)

    return { Frame = f, Set = function(_, v) SetVal(v) end, Get = function() return val end, Changed = changed }
end

local function MakeDropdown(parent, opts, zbase)
    local lbl   = opts.Label    or "Dropdown"
    local items = opts.Items    or {}
    local def   = opts.Default  or items[1] or ""
    local multi = opts.Multi    or false
    local cb    = opts.Callback or function() end
    local z     = zbase or 10

    local sel     = multi and (type(def)=="table" and def or {def}) or def
    local open    = false
    local changed = Signal.new()

    local function Display()
        if multi then
            if #sel == 0 then return "None" end
            return #sel == 1 and sel[1] or sel[1].." +"..#sel-1
        end
        return tostring(sel)
    end

    local f = U.New("Frame", {
        Size             = UDim2.new(1, 0, 0, 34),
        BackgroundColor3 = T.BG3,
        ClipsDescendants = false,
        ZIndex           = z,
        Parent           = parent,
    })
    U.Corner(f, 6)

    U.New("TextLabel", {
        Size                   = UDim2.new(0.45, 0, 1, 0),
        Position               = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text                   = lbl,
        TextColor3             = T.TextPri,
        TextSize               = 13,
        Font                   = F.Semi,
        TextXAlignment         = Enum.TextXAlignment.Left,
        ZIndex                 = z+1,
        Parent                 = f,
    })

    local selBox = U.New("Frame", {
        Size             = UDim2.new(0.55, -12, 0, 24),
        Position         = UDim2.new(0.45, 6, 0.5, -12),
        BackgroundColor3 = T.BG4,
        ZIndex           = z+1,
        Parent           = f,
    })
    U.Corner(selBox, 5)
    U.Stroke(selBox, T.Border, 1)

    local selTxt = U.New("TextLabel", {
        Size                   = UDim2.new(1, -22, 1, 0),
        Position               = UDim2.new(0, 7, 0, 0),
        BackgroundTransparency = 1,
        Text                   = Display(),
        TextColor3             = T.TextPri,
        TextSize               = 12,
        Font                   = F.Body,
        TextXAlignment         = Enum.TextXAlignment.Left,

        ZIndex                 = z+2,
        Parent                 = selBox,
    })

    local arrL = U.New("TextLabel", {
        Size                   = UDim2.new(0, 16, 1, 0),
        Position               = UDim2.new(1, -18, 0, 0),
        BackgroundTransparency = 1,
        Text                   = "▾",
        TextColor3             = T.Accent,
        TextSize               = 13,
        Font                   = F.Bold,
        ZIndex                 = z+2,
        Parent                 = selBox,
    })

    local dropF = U.New("Frame", {
        Size             = UDim2.new(0.55, -12, 0, 0),
        Position         = UDim2.new(0.45, 6, 1, 4),
        BackgroundColor3 = T.DropBG,
        ClipsDescendants = true,
        ZIndex           = z+20,
        Parent           = f,
    })
    U.Corner(dropF, 6)
    U.Stroke(dropF, T.Border, 1)
    U.Shadow(dropF, 8, 0.55)

    local dropScroll = U.New("ScrollingFrame", {
        Size                   = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        ScrollBarThickness     = 2,
        ScrollBarImageColor3   = T.Accent,
        ZIndex                 = z+21,
        Parent                 = dropF,
    })
    U.New("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent    = dropScroll,
    })

    local function RebuildItems()
        for _, c in ipairs(dropScroll:GetChildren()) do
            if not c:IsA("UIListLayout") then c:Destroy() end
        end
        for _, item in ipairs(items) do
            local isSel = multi and (table.find(sel, item) ~= nil) or (sel == item)
            local row = U.New("Frame", {
                Size             = UDim2.new(1, 0, 0, 28),
                BackgroundColor3 = isSel and T.DropHover or T.DropItem,
                ZIndex           = z+22,
                Parent           = dropScroll,
            })
            local dot = U.New("Frame", {
                Size             = UDim2.new(0, 6, 0, 6),
                Position         = UDim2.new(0, 8, 0.5, -3),
                BackgroundColor3 = isSel and T.Accent or T.BG4,
                ZIndex           = z+23,
                Parent           = row,
            })
            U.Corner(dot, 3)
            U.New("TextLabel", {
                Size                   = UDim2.new(1, -24, 1, 0),
                Position               = UDim2.new(0, 22, 0, 0),
                BackgroundTransparency = 1,
                Text                   = tostring(item),
                TextColor3             = isSel and T.TextPri or T.TextSec,
                TextSize               = 12,
                Font                   = isSel and F.Semi or F.Body,
                TextXAlignment         = Enum.TextXAlignment.Left,
                ZIndex                 = z+23,
                Parent                 = row,
            })
            local rb = U.New("TextButton", {
                Size                   = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text                   = "",
                ZIndex                 = z+24,
                Parent                 = row,
            })
            rb.MouseEnter:Connect(function() U.Tween(row, A.Fast, { BackgroundColor3 = T.DropHover }) end)
            rb.MouseLeave:Connect(function() U.Tween(row, A.Fast, { BackgroundColor3 = isSel and T.DropHover or T.DropItem }) end)
            rb.MouseButton1Click:Connect(function()
                if multi then
                    local idx = table.find(sel, item)
                    if idx then table.remove(sel, idx) else table.insert(sel, item) end
                else
                    sel = item
                    open = false
                    U.Tween(dropF, A.Slide, { Size = UDim2.new(0.55,-12,0,0) })
                    U.Tween(arrL,  A.Fast,  { Rotation = 0 })
                end
                pcall(function() selTxt.Text = Display() end)
                pcall(cb, sel)
                changed:Fire(sel)
                RebuildItems()
            end)
        end
        dropScroll.CanvasSize = UDim2.new(0, 0, 0, #items*28)
    end

    RebuildItems()

    local clickBtn = U.New("TextButton", {
        Size                   = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text                   = "",
        ZIndex                 = z+3,
        Parent                 = f,
    })
    clickBtn.MouseButton1Click:Connect(function()
        open = not open
        local maxH = math.min(#items*28, 160)
        U.Tween(dropF, A.Slide, { Size = open and UDim2.new(0.55,-12,0,maxH) or UDim2.new(0.55,-12,0,0) })
        U.Tween(arrL,  A.Fast,  { Rotation = open and 180 or 0 })
    end)
    f.MouseEnter:Connect(function() U.Tween(f, A.Fast, { BackgroundColor3 = T.BGHover }) end)
    f.MouseLeave:Connect(function() U.Tween(f, A.Fast, { BackgroundColor3 = T.BG3 }) end)

    UserInputService.InputBegan:Connect(function(inp)
        if open and (inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch) then
            task.defer(function()
                local p = inp.Position
                local ap = f.AbsolutePosition; local as = f.AbsoluteSize
                if p.X<ap.X or p.X>ap.X+as.X or p.Y<ap.Y or p.Y>ap.Y+as.Y+170 then
                    open = false
                    U.Tween(dropF, A.Slide, { Size = UDim2.new(0.55,-12,0,0) })
                    U.Tween(arrL,  A.Fast,  { Rotation = 0 })
                end
            end)
        end
    end)

    return {
        Frame    = f,
        Set      = function(_, v) sel = v; pcall(function() selTxt.Text = Display() end); RebuildItems() end,
        Get      = function() return sel end,
        AddItem  = function(_, v) table.insert(items,v); RebuildItems() end,
        SetItems = function(_, v) items=v; sel=multi and {} or (v[1] or ""); pcall(function() selTxt.Text=Display() end); RebuildItems() end,
        Changed  = changed,
    }
end

local function MakeInput(parent, opts, zbase)
    local lbl   = opts.Label       or "Input"
    local ph    = opts.Placeholder or "Type here..."
    local def   = opts.Default     or ""
    local maxL  = opts.MaxLength   or 64
    local numO  = opts.NumbersOnly or false
    local cb    = opts.Callback    or function() end
    local z     = zbase or 10
    local changed = Signal.new()

    local f = U.New("Frame", {
        Size             = UDim2.new(1, 0, 0, 34),
        BackgroundColor3 = T.BG3,
        ZIndex           = z,
        Parent           = parent,
    })
    U.Corner(f, 6)

    U.New("TextLabel", {
        Size                   = UDim2.new(0.42, 0, 1, 0),
        Position               = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text                   = lbl,
        TextColor3             = T.TextPri,
        TextSize               = 13,
        Font                   = F.Semi,
        TextXAlignment         = Enum.TextXAlignment.Left,
        ZIndex                 = z+1,
        Parent                 = f,
    })

    local box = U.New("Frame", {
        Size             = UDim2.new(0.58, -12, 0, 24),
        Position         = UDim2.new(0.42, 6, 0.5, -12),
        BackgroundColor3 = T.BG4,
        ZIndex           = z+1,
        Parent           = f,
    })
    U.Corner(box, 5)
    local stroke = U.Stroke(box, T.Border, 1)

    local tb = U.New("TextBox", {
        Size                   = UDim2.new(1, -14, 1, 0),
        Position               = UDim2.new(0, 8, 0, 0),
        BackgroundTransparency = 1,
        Text                   = def,
        PlaceholderText        = ph,
        PlaceholderColor3      = T.TextDis,
        TextColor3             = T.TextPri,
        TextSize               = 12,
        Font                   = F.Body,
        TextXAlignment         = Enum.TextXAlignment.Left,
        ClearTextOnFocus       = false,
        ZIndex                 = z+2,
        Parent                 = box,
    })
    tb.Focused:Connect(function()
        U.Tween(stroke, A.Fast, { Color = T.Accent })
        U.Tween(box, A.Fast, { BackgroundColor3 = T.BGActive })
    end)
    tb.FocusLost:Connect(function()
        U.Tween(stroke, A.Fast, { Color = T.Border })
        U.Tween(box, A.Fast, { BackgroundColor3 = T.BG4 })
        local v = tb.Text
        if numO then v = v:gsub("[^%d%.%-]",""); pcall(function() tb.Text = v end) end
        pcall(cb, v); changed:Fire(v)
    end)
    tb:GetPropertyChangedSignal("Text"):Connect(function()
        if #tb.Text > maxL then pcall(function() tb.Text = tb.Text:sub(1,maxL) end) end
    end)

    f.MouseEnter:Connect(function() U.Tween(f, A.Fast, { BackgroundColor3 = T.BGHover }) end)
    f.MouseLeave:Connect(function() U.Tween(f, A.Fast, { BackgroundColor3 = T.BG3 }) end)

    return { Frame = f, Set = function(_, v) pcall(function() tb.Text = tostring(v) end) end, Get = function() return tb.Text end, Changed = changed }
end

local function MakeButton(parent, opts, zbase)
    local lbl  = opts.Label    or "Button"
    local desc = opts.Desc     or ""
    local cb   = opts.Callback or function() end
    local sty  = opts.Style    or "Default"
    local z    = zbase or 10

    local bgMap = { Default = T.BG3, Accent = T.AccentDark, Danger = Color3.fromRGB(96,32,42) }
    local hvMap = { Default = T.BGHover, Accent = T.Accent, Danger = Color3.fromRGB(155,46,60) }
    local bg = bgMap[sty] or T.BG3
    local hv = hvMap[sty] or T.BGHover

    local f = U.New("Frame", {
        Size             = UDim2.new(1, 0, 0, desc~="" and 44 or 34),
        BackgroundColor3 = bg,
        ZIndex           = z,
        Parent           = parent,
    })
    U.Corner(f, 6)
    if sty == "Accent" then U.Stroke(f, T.Accent, 1, 0.5) end

    U.New("TextLabel", {
        Size                   = UDim2.new(1, -24, 0, 18),
        Position               = UDim2.new(0, 10, 0, desc~="" and 6 or 8),
        BackgroundTransparency = 1,
        Text                   = lbl,
        TextColor3             = T.TextPri,
        TextSize               = 13,
        Font                   = F.Semi,
        TextXAlignment         = Enum.TextXAlignment.Left,
        ZIndex                 = z+1,
        Parent                 = f,
    })
    if desc ~= "" then
        U.New("TextLabel", {
            Size                   = UDim2.new(1, -24, 0, 14),
            Position               = UDim2.new(0, 10, 0, 26),
            BackgroundTransparency = 1,
            Text                   = desc,
            TextColor3             = T.TextDis,
            TextSize               = 11,
            Font                   = F.Body,
            TextXAlignment         = Enum.TextXAlignment.Left,
            ZIndex                 = z+1,
            Parent                 = f,
        })
    end
    U.New("TextLabel", {
        Size                   = UDim2.new(0, 14, 1, 0),
        Position               = UDim2.new(1, -18, 0, 0),
        BackgroundTransparency = 1,
        Text                   = "›",
        TextColor3             = T.TextAcc,
        TextSize               = 18,
        Font                   = F.Bold,
        ZIndex                 = z+1,
        Parent                 = f,
    })

    local btn = U.New("TextButton", {
        Size                   = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text                   = "",
        ZIndex                 = z+2,
        Parent                 = f,
    })
    btn.MouseButton1Click:Connect(function() pcall(cb) end)
    btn.MouseEnter:Connect(function() U.Tween(f, A.Fast, { BackgroundColor3 = hv }) end)
    btn.MouseLeave:Connect(function() U.Tween(f, A.Fast, { BackgroundColor3 = bg }) end)

    return { Frame = f }
end

local function MakeKeybind(parent, opts, zbase)
    local lbl  = opts.Label    or "Keybind"
    local def  = opts.Default  or Enum.KeyCode.Unknown
    local cb   = opts.Callback or function() end
    local z    = zbase or 10

    local curKey  = def
    local listen  = false
    local changed = Signal.new()

    local f = U.New("Frame", {
        Size             = UDim2.new(1, 0, 0, 34),
        BackgroundColor3 = T.BG3,
        ZIndex           = z,
        Parent           = parent,
    })
    U.Corner(f, 6)

    U.New("TextLabel", {
        Size                   = UDim2.new(0.6, 0, 1, 0),
        Position               = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text                   = lbl,
        TextColor3             = T.TextPri,
        TextSize               = 13,
        Font                   = F.Semi,
        TextXAlignment         = Enum.TextXAlignment.Left,
        ZIndex                 = z+1,
        Parent                 = f,
    })

    local badge = U.New("Frame", {
        Size             = UDim2.new(0, 68, 0, 22),
        Position         = UDim2.new(1, -76, 0.5, -11),
        BackgroundColor3 = T.BG4,
        ZIndex           = z+1,
        Parent           = f,
    })
    U.Corner(badge, 5)
    U.Stroke(badge, T.Border, 1)

    local kTxt = U.New("TextLabel", {
        Size                   = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text                   = curKey.Name,
        TextColor3             = T.Accent,
        TextSize               = 12,
        Font                   = F.Semi,
        ZIndex                 = z+2,
        Parent                 = badge,
    })

    local function StartListen()
        listen = true
        pcall(function() kTxt.Text = "..."; kTxt.TextColor3 = T.AccentLight end)
        U.Tween(badge, A.Fast, { BackgroundColor3 = T.BGActive })
    end
    local function StopListen(k)
        listen = false
        curKey = k or curKey
        pcall(function() kTxt.Text = curKey.Name; kTxt.TextColor3 = T.Accent end)
        U.Tween(badge, A.Fast, { BackgroundColor3 = T.BG4 })
        pcall(cb, curKey)
        changed:Fire(curKey)
    end

    local btn = U.New("TextButton", {
        Size                   = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text                   = "",
        ZIndex                 = z+3,
        Parent                 = f,
    })
    btn.MouseButton1Click:Connect(function()
        if not listen then StartListen() end
    end)
    UserInputService.InputBegan:Connect(function(inp, gpe)
        if listen and not gpe and inp.UserInputType == Enum.UserInputType.Keyboard then
            StopListen(inp.KeyCode == Enum.KeyCode.Escape and nil or inp.KeyCode)
        elseif not listen and inp.UserInputType == Enum.UserInputType.Keyboard and inp.KeyCode == curKey then
            pcall(cb, curKey)
        end
    end)

    f.MouseEnter:Connect(function() U.Tween(f, A.Fast, { BackgroundColor3 = T.BGHover }) end)
    f.MouseLeave:Connect(function() U.Tween(f, A.Fast, { BackgroundColor3 = T.BG3 }) end)

    return { Frame = f, Get = function() return curKey end, Set = function(_, k) StopListen(k) end, Changed = changed }
end

local function MakeColorPicker(parent, opts, zbase)
    local lbl  = opts.Label    or "Color"
    local def  = opts.Default  or Color3.fromRGB(198,100,145)
    local cb   = opts.Callback or function() end
    local z    = zbase or 10

    local H, S, V   = def:ToHSV()
    local col        = def
    local open       = false
    local changed    = Signal.new()
    local svDrag     = false
    local hueDrag    = false

    local f = U.New("Frame", {
        Size             = UDim2.new(1, 0, 0, 34),
        BackgroundColor3 = T.BG3,
        ClipsDescendants = false,
        ZIndex           = z,
        Parent           = parent,
    })
    U.Corner(f, 6)

    U.New("TextLabel", {
        Size                   = UDim2.new(0.6, 0, 1, 0),
        Position               = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text                   = lbl,
        TextColor3             = T.TextPri,
        TextSize               = 13,
        Font                   = F.Semi,
        TextXAlignment         = Enum.TextXAlignment.Left,
        ZIndex                 = z+1,
        Parent                 = f,
    })

    local swatch = U.New("Frame", {
        Size             = UDim2.new(0, 48, 0, 22),
        Position         = UDim2.new(1, -56, 0.5, -11),
        BackgroundColor3 = col,
        ZIndex           = z+1,
        Parent           = f,
    })
    U.Corner(swatch, 5)
    U.Stroke(swatch, T.Border, 1)

    local panel = U.New("Frame", {
        Size             = UDim2.new(0, 210, 0, 0),
        Position         = UDim2.new(1, -214, 1, 4),
        BackgroundColor3 = T.DropBG,
        ClipsDescendants = true,
        ZIndex           = z+30,
        Parent           = f,
    })
    U.Corner(panel, 8)
    U.Stroke(panel, T.Border, 1)
    U.Shadow(panel, 10, 0.52)

    local svPick = U.New("ImageLabel", {
        Size             = UDim2.new(1, -16, 0, 110),
        Position         = UDim2.new(0, 8, 0, 8),
        BackgroundColor3 = Color3.fromHSV(H,1,1),
        Image            = "rbxassetid://6020299385",
        ZIndex           = z+31,
        Parent           = panel,
    })
    U.Corner(svPick, 4)

    U.New("ImageLabel", {
        Size             = UDim2.new(1,0,1,0),
        BackgroundTransparency = 1,
        Image            = "rbxassetid://6020299769",
        ZIndex           = z+32,
        Parent           = svPick,
    })

    local svCur = U.New("Frame", {
        Size        = UDim2.new(0,10,0,10),
        AnchorPoint = Vector2.new(0.5,0.5),
        Position    = UDim2.new(S,0,1-V,0),
        BackgroundColor3 = Color3.new(1,1,1),
        ZIndex      = z+33,
        Parent      = svPick,
    })
    U.Corner(svCur, 5)
    U.Stroke(svCur, Color3.new(0,0,0), 1)

    local hueBar = U.New("ImageLabel", {
        Size     = UDim2.new(1,-16,0,12),
        Position = UDim2.new(0,8,0,126),
        Image    = "rbxassetid://6020299988",
        BackgroundColor3 = Color3.new(1,1,1),
        ZIndex   = z+31,
        Parent   = panel,
    })
    U.Corner(hueBar, 4)

    local hueCur = U.New("Frame", {
        Size        = UDim2.new(0,4,1,4),
        AnchorPoint = Vector2.new(0.5,0.5),
        Position    = UDim2.new(H,0,0.5,0),
        BackgroundColor3 = Color3.new(1,1,1),
        ZIndex      = z+32,
        Parent      = hueBar,
    })
    U.Corner(hueCur, 2)
    U.Stroke(hueCur, Color3.new(0,0,0), 1)

    local hexBG = U.New("Frame", {
        Size             = UDim2.new(1,-16,0,26),
        Position         = UDim2.new(0,8,0,146),
        BackgroundColor3 = T.BG4,
        ZIndex           = z+31,
        Parent           = panel,
    })
    U.Corner(hexBG, 5)
    U.Stroke(hexBG, T.Border, 1)

    local hexTB = U.New("TextBox", {
        Size                   = UDim2.new(1,-12,1,0),
        Position               = UDim2.new(0,7,0,0),
        BackgroundTransparency = 1,
        Text                   = string.format("#%02X%02X%02X", def.R*255, def.G*255, def.B*255),
        TextColor3             = T.TextPri,
        TextSize               = 12,
        Font                   = F.Mono,
        TextXAlignment         = Enum.TextXAlignment.Left,
        ClearTextOnFocus       = false,
        ZIndex                 = z+32,
        Parent                 = hexBG,
    })

    local function Apply()
        col = Color3.fromHSV(H,S,V)
        pcall(function()
            swatch.BackgroundColor3 = col
            svPick.BackgroundColor3 = Color3.fromHSV(H,1,1)
            svCur.Position = UDim2.new(S,0,1-V,0)
            hueCur.Position = UDim2.new(H,0,0.5,0)
            hexTB.Text = string.format("#%02X%02X%02X", col.R*255, col.G*255, col.B*255)
        end)
        pcall(cb, col)
        changed:Fire(col)
    end

    svPick.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then svDrag=true end
    end)
    svPick.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then svDrag=false end
    end)
    hueBar.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then hueDrag=true end
    end)
    hueBar.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then hueDrag=false end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if svDrag and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
            pcall(function()
                local ap=svPick.AbsolutePosition; local as=svPick.AbsoluteSize
                S=math.clamp((i.Position.X-ap.X)/as.X,0,1)
                V=1-math.clamp((i.Position.Y-ap.Y)/as.Y,0,1)
                Apply()
            end)
        end
        if hueDrag and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
            pcall(function()
                local ap=hueBar.AbsolutePosition; local as=hueBar.AbsoluteSize
                H=math.clamp((i.Position.X-ap.X)/as.X,0,1)
                Apply()
            end)
        end
    end)
    hexTB.FocusLost:Connect(function()
        local hex = hexTB.Text:gsub("#","")
        if #hex==6 then
            local r=tonumber(hex:sub(1,2),16) or 0
            local g=tonumber(hex:sub(3,4),16) or 0
            local b=tonumber(hex:sub(5,6),16) or 0
            col=Color3.fromRGB(r,g,b); H,S,V=col:ToHSV(); Apply()
        end
    end)

    local swBtn = U.New("TextButton", {
        Size                   = UDim2.new(0,48,0,22),
        Position               = UDim2.new(1,-56,0.5,-11),
        BackgroundTransparency = 1,
        Text                   = "",
        ZIndex                 = z+2,
        Parent                 = f,
    })
    swBtn.MouseButton1Click:Connect(function()
        open = not open
        U.Tween(panel, A.Slide, { Size = open and UDim2.new(0,210,0,180) or UDim2.new(0,210,0,0) })
    end)

    f.MouseEnter:Connect(function() U.Tween(f, A.Fast, { BackgroundColor3 = T.BGHover }) end)
    f.MouseLeave:Connect(function() U.Tween(f, A.Fast, { BackgroundColor3 = T.BG3 }) end)

    Apply()
    return { Frame=f, Get=function() return col end, Set=function(_,c) col=c; H,S,V=c:ToHSV(); Apply() end, Changed=changed }
end

local function MakeCheckbox(parent, opts, zbase)
    local lbl  = opts.Label    or "Checkbox"
    local def  = opts.Default  or false
    local cb   = opts.Callback or function() end
    local z    = zbase or 10
    local state   = def
    local changed = Signal.new()

    local f = U.New("Frame", {
        Size             = UDim2.new(1, 0, 0, 30),
        BackgroundColor3 = T.BG3,
        ZIndex           = z,
        Parent           = parent,
    })
    U.Corner(f, 6)

    local box = U.New("Frame", {
        Size             = UDim2.new(0, 16, 0, 16),
        Position         = UDim2.new(0, 10, 0.5, -8),
        BackgroundColor3 = state and T.Accent or T.BG4,
        ZIndex           = z+1,
        Parent           = f,
    })
    U.Corner(box, 4)
    U.Stroke(box, state and T.Accent or T.Border, 1)

    local chk = U.New("TextLabel", {
        Size                   = UDim2.new(1,0,1,0),
        BackgroundTransparency = 1,
        Text                   = "✓",
        TextColor3             = Color3.new(1,1,1),
        TextSize               = 11,
        Font                   = F.Bold,
        TextTransparency       = state and 0 or 1,
        ZIndex                 = z+2,
        Parent                 = box,
    })

    U.New("TextLabel", {
        Size                   = UDim2.new(1, -36, 1, 0),
        Position               = UDim2.new(0, 34, 0, 0),
        BackgroundTransparency = 1,
        Text                   = lbl,
        TextColor3             = T.TextPri,
        TextSize               = 13,
        Font                   = F.Semi,
        TextXAlignment         = Enum.TextXAlignment.Left,
        ZIndex                 = z+1,
        Parent                 = f,
    })

    local function Set(v)
        state = v
        U.Tween(box, A.Fast, { BackgroundColor3 = v and T.Accent or T.BG4 })
        U.Tween(chk, A.Fast, { TextTransparency = v and 0 or 1 })
        pcall(cb, v); changed:Fire(v)
    end

    local btn = U.New("TextButton", {
        Size                   = UDim2.new(1,0,1,0),
        BackgroundTransparency = 1,
        Text                   = "",
        ZIndex                 = z+3,
        Parent                 = f,
    })
    btn.MouseButton1Click:Connect(function() Set(not state) end)
    f.MouseEnter:Connect(function() U.Tween(f, A.Fast, { BackgroundColor3 = T.BGHover }) end)
    f.MouseLeave:Connect(function() U.Tween(f, A.Fast, { BackgroundColor3 = T.BG3 }) end)

    return { Frame=f, Set=function(_,v) Set(v) end, Get=function() return state end, Changed=changed }
end

local function MakeLabel(parent, opts, zbase)
    local txt   = opts.Text   or ""
    local color = opts.Color  or T.TextSec
    local sz    = opts.Size   or 12
    local z     = zbase or 10
    local el = U.New("TextLabel", {
        Size                   = UDim2.new(1,0,0,22),
        Position               = UDim2.new(0,10,0,0),
        BackgroundTransparency = 1,
        Text                   = txt,
        TextColor3             = color,
        TextSize               = sz,
        Font                   = F.Body,
        TextXAlignment         = Enum.TextXAlignment.Left,
        TextWrapped            = true,
        ZIndex                 = z,
        Parent                 = parent,
    })
    return { Frame=el, Set=function(_,v) pcall(function() el.Text=v end) end, Get=function() return el.Text end }
end

local function MakeSeparator(parent, zbase)
    local el = U.New("Frame", {
        Size             = UDim2.new(1,-16,0,1),
        Position         = UDim2.new(0,8,0,0),
        BackgroundColor3 = T.Divider,
        ZIndex           = zbase or 10,
        Parent           = parent,
    })
    return { Frame = el }
end

local Section = {}
Section.__index = Section

function Section.new(parent, title, z)
    local self = setmetatable({}, Section)
    self._z    = z or 10

    self._frame = U.New("Frame", {
        Size             = UDim2.new(1,0,0,28),
        BackgroundTransparency = 1,
        ClipsDescendants = false,
        ZIndex           = self._z,
        Parent           = parent,
    })

    local hdr = U.New("Frame", {
        Size             = UDim2.new(1,0,0,24),
        BackgroundTransparency = 1,
        ZIndex           = self._z,
        Parent           = self._frame,
    })

    local dot = U.New("Frame", {
        Size             = UDim2.new(0,3,0,12),
        Position         = UDim2.new(0,0,0.5,-6),
        BackgroundColor3 = T.Accent,
        ZIndex           = self._z+1,
        Parent           = hdr,
    })
    U.Corner(dot, 2)

    local titleL = U.New("TextLabel", {
        Size                   = UDim2.new(1,-22,1,0),
        Position               = UDim2.new(0,10,0,0),
        BackgroundTransparency = 1,
        Text                   = title:upper(),
        TextColor3             = T.TextSec,
        TextSize               = 10,
        Font                   = F.Bold,
        TextXAlignment         = Enum.TextXAlignment.Left,
        ZIndex                 = self._z+1,
        Parent                 = hdr,
    })

    local arrowBtn = U.New("TextButton", {
        Size                   = UDim2.new(0,20,0,20),
        Position               = UDim2.new(1,-20,0.5,-10),
        BackgroundTransparency = 1,
        Text                   = "▾",
        TextColor3             = T.TextDis,
        TextSize               = 11,
        Font                   = F.Bold,
        ZIndex                 = self._z+2,
        Parent                 = hdr,
    })

    self._content = U.New("Frame", {
        Size             = UDim2.new(1,0,0,0),
        Position         = UDim2.new(0,0,0,26),
        BackgroundColor3 = T.BG3,
        ClipsDescendants = true,
        ZIndex           = self._z,
        Parent           = self._frame,
    })
    U.Corner(self._content, 6)
    U.Stroke(self._content, T.Border, 1)

    self._layout = U.New("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding   = UDim.new(0,2),
        Parent    = self._content,
    })
    U.Pad(self._content, 4, 6, 4, 6)

    self._layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        self:_Resize()
    end)

    self._collapsed = false
    arrowBtn.MouseButton1Click:Connect(function()
        self._collapsed = not self._collapsed
        U.Tween(arrowBtn, A.Fast, { Rotation = self._collapsed and -90 or 0 })
        self:_Resize()
    end)

    self:_Resize()
    return self
end

function Section:_Resize()
    if self._collapsed then
        U.Tween(self._content, A.Slide, { Size = UDim2.new(1,0,0,0) })
        U.Tween(self._frame,   A.Slide, { Size = UDim2.new(1,0,0,28) })
        return
    end
    local h = self._layout.AbsoluteContentSize.Y + 12
    h = math.max(h, 10)
    U.Tween(self._content, A.Slide, { Size = UDim2.new(1,0,0,h) })
    U.Tween(self._frame,   A.Slide, { Size = UDim2.new(1,0,0,26+h+4) })
end

function Section:AddToggle(lbl, def, cb, desc)
    local el = MakeToggle(self._content, { Label=lbl, Default=def, Callback=cb, Desc=desc or "" }, self._z+2)
    return el
end
function Section:AddSlider(lbl, mn, mx, def, cb, extra)
    extra = extra or {}
    local el = MakeSlider(self._content, { Label=lbl, Min=mn, Max=mx, Default=def, Callback=cb, Step=extra.Step, Suffix=extra.Suffix }, self._z+2)
    return el
end
function Section:AddDropdown(lbl, items, def, cb, extra)
    extra = extra or {}
    local el = MakeDropdown(self._content, { Label=lbl, Items=items, Default=def, Callback=cb, Multi=extra.Multi }, self._z+2)
    return el
end
function Section:AddInput(lbl, ph, def, cb, extra)
    extra = extra or {}
    local el = MakeInput(self._content, { Label=lbl, Placeholder=ph, Default=def, Callback=cb, NumbersOnly=extra.NumbersOnly, MaxLength=extra.MaxLength }, self._z+2)
    return el
end
function Section:AddButton(lbl, cb, extra)
    extra = extra or {}
    local el = MakeButton(self._content, { Label=lbl, Callback=cb, Desc=extra.Desc, Style=extra.Style }, self._z+2)
    return el
end
function Section:AddKeybind(lbl, def, cb)
    local el = MakeKeybind(self._content, { Label=lbl, Default=def, Callback=cb }, self._z+2)
    return el
end
function Section:AddColorPicker(lbl, def, cb)
    local el = MakeColorPicker(self._content, { Label=lbl, Default=def, Callback=cb }, self._z+2)
    return el
end
function Section:AddCheckbox(lbl, def, cb)
    local el = MakeCheckbox(self._content, { Label=lbl, Default=def, Callback=cb }, self._z+2)
    return el
end
function Section:AddLabel(txt, color)
    local el = MakeLabel(self._content, { Text=txt, Color=color }, self._z+2)
    return el
end
function Section:AddSeparator()
    return MakeSeparator(self._content, self._z+2)
end

local TabClass = {}
TabClass.__index = TabClass

function TabClass.new(contentArea, z)
    local self = setmetatable({}, TabClass)
    self._z = z or 12

    self._frame = U.New("ScrollingFrame", {
        Size                   = UDim2.new(1,0,1,0),
        BackgroundTransparency = 1,
        ScrollBarThickness     = 2,
        ScrollBarImageColor3   = T.Accent,
        ScrollBarImageTransparency = 0.4,
        ZIndex                 = z,
        Visible                = false,
        ClipsDescendants       = true,
        Parent                 = contentArea,
    })

    local layout = U.New("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding   = UDim.new(0,8),
        Parent    = self._frame,
    })
    U.Pad(self._frame, 8, 8, 8, 8)

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        pcall(function()
            self._frame.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y+20)
        end)
    end)

    return self
end

function TabClass:AddSection(title)
    return Section.new(self._frame, title, self._z+2)
end

local Window = {}
Window.__index = Window

function Window.new(sg, opts)
    local self = setmetatable({}, Window)
    opts = opts or {}

    self._title     = opts.Title     or "HepaUI"
    self._subtitle  = opts.SubTitle  or "Library"
    self._tabW      = opts.TabWidth  or 155
    self._toggleKey = opts.ToggleKey or Enum.KeyCode.RightShift
    self._license   = opts.License   or "Lifetime"
    self._visible   = true
    self._minimized = false
    self._tabs      = {}
    self._activeTab = nil
    self._curGroup  = nil
    self._locked    = false

    local isMob = U.IsMobile()
    local winW  = isMob and (workspace.CurrentCamera.ViewportSize.X - 16) or 680
    local winH  = isMob and (workspace.CurrentCamera.ViewportSize.Y - 80) or 460
    local winX  = isMob and 8 or math.floor((workspace.CurrentCamera.ViewportSize.X - winW)/2)
    local winY  = isMob and 38 or math.floor((workspace.CurrentCamera.ViewportSize.Y - winH)/2)

    self._sz = UDim2.new(0, winW, 0, winH)
    self._pos = UDim2.new(0, winX, 0, winY)

    self._root = U.New("Frame", {
        Name             = "Window",
        Size             = UDim2.new(0, winW, 0, 0),
        Position         = self._pos,
        BackgroundColor3 = T.BG1,
        ClipsDescendants = false,
        ZIndex           = 10,
        Parent           = sg,
    })
    U.Corner(self._root, 10)
    U.Shadow(self._root, 18, 0.46)
    U.Glow(self._root, T.Accent, 10, 0.92)
    U.Stroke(self._root, T.Border, 1)

    local titleBar = U.New("Frame", {
        Size             = UDim2.new(1,0,0,46),
        BackgroundColor3 = T.BG2,
        ZIndex           = 11,
        Parent           = self._root,
    })
    U.Corner(titleBar, 10)
    U.New("Frame", {
        Size             = UDim2.new(1,0,0,10),
        Position         = UDim2.new(0,0,1,-10),
        BackgroundColor3 = T.BG2,
        ZIndex           = 11,
        Parent           = titleBar,
    })
    U.New("Frame", {
        Size             = UDim2.new(1,0,0,2),
        Position         = UDim2.new(0,0,1,-2),
        BackgroundColor3 = T.Accent,
        ZIndex           = 12,
        Parent           = titleBar,
    })

    local logoLetter = U.New("TextLabel", {
        Size                   = UDim2.new(0,28,0,28),
        Position               = UDim2.new(0,12,0.5,-14),
        BackgroundTransparency = 1,
        Text                   = self._title:sub(1,1),
        TextColor3             = T.Accent,
        TextSize               = 20,
        Font                   = F.Title,
        ZIndex                 = 12,
        Parent                 = titleBar,
    })
    U.New("TextLabel", {
        Size                   = UDim2.new(0,self._tabW-42,0,20),
        Position               = UDim2.new(0,40,0.5,-10),
        BackgroundTransparency = 1,
        Text                   = self._title:sub(2),
        TextColor3             = T.TextPri,
        TextSize               = 15,
        Font                   = F.Title,
        TextXAlignment         = Enum.TextXAlignment.Left,
        ZIndex                 = 12,
        Parent                 = titleBar,
    })
    U.New("TextLabel", {
        Size                   = UDim2.new(0,180,1,0),
        Position               = UDim2.new(0.5,-90,0,0),
        BackgroundTransparency = 1,
        Text                   = self._subtitle,
        TextColor3             = T.TextSec,
        TextSize               = 12,
        Font                   = F.Body,
        ZIndex                 = 12,
        Parent                 = titleBar,
    })

    local ctrlFrame = U.New("Frame", {
        Size                   = UDim2.new(0,72,0,28),
        Position               = UDim2.new(1,-78,0.5,-14),
        BackgroundTransparency = 1,
        ZIndex                 = 12,
        Parent                 = titleBar,
    })

    local function MakeCtrl(xoff, txt, hc, action)
        local b = U.New("TextButton", {
            Size             = UDim2.new(0,22,0,22),
            Position         = UDim2.new(0,xoff,0.5,-11),
            BackgroundColor3 = T.BG4,
            Text             = txt,
            TextColor3       = hc,
            TextSize         = 12,
            Font             = F.Bold,
            ZIndex           = 13,
            Parent           = ctrlFrame,
        })
        U.Corner(b, 5)
        b.MouseButton1Click:Connect(action)
        b.MouseEnter:Connect(function() U.Tween(b, A.Fast, { BackgroundColor3 = hc, TextColor3 = Color3.new(1,1,1) }) end)
        b.MouseLeave:Connect(function() U.Tween(b, A.Fast, { BackgroundColor3 = T.BG4, TextColor3 = hc }) end)
        return b
    end

    MakeCtrl(0,  "−", T.TextSec, function() self:Minimize() end)
    self._lockBtn = MakeCtrl(24, "🔒", T.TextSec, function() self:ToggleLock() end)
    MakeCtrl(48, "×", Color3.fromRGB(210,70,70), function() self:Toggle() end)

    U.Draggable(self._root, titleBar)

    self._sidebar = U.New("Frame", {
        Name             = "Sidebar",
        Size             = UDim2.new(0,self._tabW,1,-48),
        Position         = UDim2.new(0,0,0,48),
        BackgroundColor3 = T.BG2,
        ZIndex           = 11,
        Parent           = self._root,
    })
    U.New("UICorner", { CornerRadius = UDim.new(0,10), Parent = self._sidebar })
    U.New("Frame", {
        Size             = UDim2.new(1,0,0,10),
        BackgroundColor3 = T.BG2,
        ZIndex           = 11,
        Parent           = self._sidebar,
    })
    U.New("Frame", {
        Size             = UDim2.new(0,1,1,0),
        Position         = UDim2.new(1,-1,0,0),
        BackgroundColor3 = T.Border,
        ZIndex           = 11,
        Parent           = self._sidebar,
    })

    local sideScroll = U.New("ScrollingFrame", {
        Size                   = UDim2.new(1,0,1,-52),
        Position               = UDim2.new(0,0,0,0),
        BackgroundTransparency = 1,
        ScrollBarThickness     = 0,
        ZIndex                 = 12,
        Parent                 = self._sidebar,
    })
    local sideList = U.New("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding   = UDim.new(0,2),
        Parent    = sideScroll,
    })
    U.Pad(sideScroll, 6, 5, 6, 5)
    sideList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        pcall(function() sideScroll.CanvasSize = UDim2.new(0,0,0,sideList.AbsoluteContentSize.Y+14) end)
    end)

    self._sideScroll = sideScroll

    local userFrame = U.New("Frame", {
        Name             = "UserBar",
        Size             = UDim2.new(1,0,0,50),
        Position         = UDim2.new(0,0,1,-50),
        BackgroundColor3 = T.BG1,
        ZIndex           = 12,
        Parent           = self._sidebar,
    })
    U.New("Frame", {
        Size             = UDim2.new(1,0,0,1),
        BackgroundColor3 = T.Divider,
        ZIndex           = 12,
        Parent           = userFrame,
    })
    local avHolder = U.New("Frame", {
        Size             = UDim2.new(0,28,0,28),
        Position         = UDim2.new(0,8,0.5,-14),
        BackgroundColor3 = T.Accent,
        ZIndex           = 13,
        Parent           = userFrame,
    })
    U.Corner(avHolder, 14)
    local av = U.New("ImageLabel", {
        Size                   = UDim2.new(1,0,1,0),
        BackgroundTransparency = 1,
        Image                  = "https://www.roblox.com/headshot-thumbnail/image?userId="..LP.UserId.."&width=48&height=48&format=png",
        ZIndex                 = 14,
        Parent                 = avHolder,
    })
    U.Corner(av, 14)
    U.New("TextLabel", {
        Size                   = UDim2.new(1,-44,0,15),
        Position               = UDim2.new(0,42,0,9),
        BackgroundTransparency = 1,
        Text                   = LP.DisplayName,
        TextColor3             = T.TextPri,
        TextSize               = 12,
        Font                   = F.Semi,
        TextXAlignment         = Enum.TextXAlignment.Left,
        ZIndex                 = 13,
        Parent                 = userFrame,
    })
    U.New("TextLabel", {
        Size                   = UDim2.new(1,-44,0,13),
        Position               = UDim2.new(0,42,0,26),
        BackgroundTransparency = 1,
        Text                   = "Till: "..(opts.License or "Lifetime"),
        TextColor3             = T.Accent,
        TextSize               = 11,
        Font                   = F.Body,
        TextXAlignment         = Enum.TextXAlignment.Left,
        ZIndex                 = 13,
        Parent                 = userFrame,
    })

    self._contentArea = U.New("Frame", {
        Name                   = "Content",
        Size                   = UDim2.new(1,-self._tabW-2,1,-48),
        Position               = UDim2.new(0,self._tabW+2,0,48),
        BackgroundTransparency = 1,
        ClipsDescendants       = true,
        ZIndex                 = 11,
        Parent                 = self._root,
    })

    UserInputService.InputBegan:Connect(function(inp, gpe)
        if not gpe and inp.KeyCode == self._toggleKey then
            self:Toggle()
        end
    end)

    if isMob then
        self:_BuildMobileControls(sg)
    end

    U.Tween(self._root, A.Spring, { Size = self._sz })

    return self
end

function Window:_BuildMobileControls(sg)
    local isMob = U.IsMobile()

    local mobileBar = U.New("Frame", {
        Name             = "MobileBar",
        Size             = UDim2.new(1, 0, 0, 34),
        Position         = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = T.BG2,
        ZIndex           = 300,
        Parent           = sg,
    })
    U.Stroke(mobileBar, T.Border, 1)

    U.New("TextLabel", {
        Size                   = UDim2.new(1,0,1,0),
        BackgroundTransparency = 1,
        Text                   = self._title .. "  ·  " .. self._subtitle,
        TextColor3             = T.Accent,
        TextSize               = 13,
        Font                   = F.Bold,
        ZIndex                 = 301,
        Parent                 = mobileBar,
    })

    local toggleBtn = U.New("TextButton", {
        Size             = UDim2.new(0,56,0,26),
        Position         = UDim2.new(1,-62,0.5,-13),
        BackgroundColor3 = self._visible and T.AccentDark or T.BG4,
        Text             = self._visible and "HIDE" or "SHOW",
        TextColor3       = Color3.new(1,1,1),
        TextSize         = 11,
        Font             = F.Bold,
        ZIndex           = 301,
        Parent           = mobileBar,
    })
    U.Corner(toggleBtn, 5)

    local lockBtn = U.New("TextButton", {
        Size             = UDim2.new(0,56,0,26),
        Position         = UDim2.new(1,-124,0.5,-13),
        BackgroundColor3 = T.BG4,
        Text             = "LOCK",
        TextColor3       = T.TextSec,
        TextSize         = 11,
        Font             = F.Bold,
        ZIndex           = 301,
        Parent           = mobileBar,
    })
    U.Corner(lockBtn, 5)

    toggleBtn.MouseButton1Click:Connect(function()
        self:Toggle()
        pcall(function()
            toggleBtn.Text = self._visible and "HIDE" or "SHOW"
            U.Tween(toggleBtn, A.Fast, { BackgroundColor3 = self._visible and T.AccentDark or T.BG4 })
        end)
    end)

    lockBtn.MouseButton1Click:Connect(function()
        self:ToggleLock()
        pcall(function()
            lockBtn.Text = self._locked and "UNLK" or "LOCK"
            U.Tween(lockBtn, A.Fast, { BackgroundColor3 = self._locked and T.AccentDark or T.BG4 })
            lockBtn.TextColor3 = self._locked and Color3.new(1,1,1) or T.TextSec
        end)
    end)

    self._root.Position = UDim2.new(0, 8, 0, 38)

    self._mobileBar    = mobileBar
    self._mobileToggle = toggleBtn
    self._mobileLock   = lockBtn
end

function Window:ToggleLock()
    self._locked = not self._locked
    if self._locked then
        self._root.Active = false
        pcall(function()
            for _, c in ipairs(self._root:GetDescendants()) do
                if c:IsA("TextButton") or c:IsA("TextBox") then
                    c.Active = false
                end
            end
        end)
        pcall(function()
            if self._lockBtn then
                self._lockBtn.Text = "🔓"
                U.Tween(self._lockBtn, A.Fast, { BackgroundColor3 = T.AccentDark })
            end
        end)
    else
        self._root.Active = true
        pcall(function()
            for _, c in ipairs(self._root:GetDescendants()) do
                if c:IsA("TextButton") or c:IsA("TextBox") then
                    c.Active = true
                end
            end
        end)
        pcall(function()
            if self._lockBtn then
                self._lockBtn.Text = "🔒"
                U.Tween(self._lockBtn, A.Fast, { BackgroundColor3 = T.BG4 })
            end
        end)
    end
end

function Window:AddGroupLabel(name)
    if self._curGroup == name then return end
    self._curGroup = name
    U.New("TextLabel", {
        Size                   = UDim2.new(1,-10,0,20),
        BackgroundTransparency = 1,
        Text                   = name,
        TextColor3             = T.TextDis,
        TextSize               = 9,
        Font                   = F.Bold,
        TextXAlignment         = Enum.TextXAlignment.Left,
        ZIndex                 = 13,
        Parent                 = self._sideScroll,
    })
end

function Window:AddTab(name, icon, group)
    if group then self:AddGroupLabel(group) end

    local tab = TabClass.new(self._contentArea, 12)

    local tabBtn = U.New("Frame", {
        Name             = "Tab_"..name,
        Size             = UDim2.new(1,0,0,32),
        BackgroundColor3 = T.BG2,
        ZIndex           = 13,
        Parent           = self._sideScroll,
    })
    U.Corner(tabBtn, 6)

    local activeBar = U.New("Frame", {
        Size             = UDim2.new(0,3,0.6,0),
        Position         = UDim2.new(0,0,0.2,0),
        BackgroundColor3 = T.Accent,
        ZIndex           = 14,
        Parent           = tabBtn,
    })
    U.Corner(activeBar, 2)
    activeBar.Visible = false

    local iconRef = nil
    if icon and icon ~= "" then
        iconRef = U.New("ImageLabel", {
            Size                   = UDim2.new(0,15,0,15),
            Position               = UDim2.new(0,10,0.5,-7),
            BackgroundTransparency = 1,
            Image                  = icon,
            ImageColor3            = T.TextDis,
            ZIndex                 = 14,
            Parent                 = tabBtn,
        })
    end

    local tabLbl = U.New("TextLabel", {
        Size                   = UDim2.new(1,icon and -30 or -10, 1, 0),
        Position               = UDim2.new(0,icon and 30 or 10,0,0),
        BackgroundTransparency = 1,
        Text                   = name,
        TextColor3             = T.TextDis,
        TextSize               = 13,
        Font                   = F.Semi,
        TextXAlignment         = Enum.TextXAlignment.Left,
        ZIndex                 = 14,
        Parent                 = tabBtn,
    })

    local clickBtn = U.New("TextButton", {
        Size                   = UDim2.new(1,0,1,0),
        BackgroundTransparency = 1,
        Text                   = "",
        ZIndex                 = 15,
        Parent                 = tabBtn,
    })

    local entry = { tab=tab, btn=tabBtn, lbl=tabLbl, bar=activeBar, icon=iconRef }

    local function Activate()
        for _, e in ipairs(self._tabs) do
            e.tab._frame.Visible = false
            U.Tween(e.btn, A.Fast, { BackgroundColor3 = T.BG2 })
            U.Tween(e.lbl, A.Fast, { TextColor3 = T.TextDis })
            e.bar.Visible = false
            if e.icon then U.Tween(e.icon, A.Fast, { ImageColor3 = T.TextDis }) end
        end
        tab._frame.Visible = true
        tab._frame.Position = UDim2.new(0.04,0,0,0)
        U.Tween(tab._frame, A.Slide, { Position = UDim2.new(0,0,0,0) })
        U.Tween(tabBtn, A.Fast, { BackgroundColor3 = T.BGActive })
        U.Tween(tabLbl, A.Fast, { TextColor3 = T.TextPri })
        activeBar.Visible = true
        if iconRef then U.Tween(iconRef, A.Fast, { ImageColor3 = T.Accent }) end
        self._activeTab = tab
    end

    clickBtn.MouseButton1Click:Connect(function()
        if not self._locked then Activate() end
    end)
    clickBtn.MouseEnter:Connect(function()
        if self._activeTab ~= tab then U.Tween(tabBtn, A.Fast, { BackgroundColor3 = T.BGHover }) end
    end)
    clickBtn.MouseLeave:Connect(function()
        if self._activeTab ~= tab then U.Tween(tabBtn, A.Fast, { BackgroundColor3 = T.BG2 }) end
    end)

    table.insert(self._tabs, entry)
    if #self._tabs == 1 then task.defer(Activate) end

    return tab
end

function Window:Toggle()
    if self._locked then return end
    self._visible = not self._visible
    if self._visible then
        self._root.Visible = true
        U.Tween(self._root, A.Spring, { Size = self._minimized and UDim2.new(0,self._sz.X.Offset,0,46) or self._sz })
    else
        U.Tween(self._root, A.Norm, { Size = UDim2.new(0,self._sz.X.Offset,0,0) }):Completed:Connect(function()
            if not self._visible then self._root.Visible = false end
        end)
    end
end

function Window:Minimize()
    if self._locked then return end
    self._minimized = not self._minimized
    U.Tween(self._root, A.Spring, { Size = self._minimized and UDim2.new(0,self._sz.X.Offset,0,46) or self._sz })
end

local HepaUI = {}
HepaUI.__index = HepaUI

function HepaUI:Init()
    local old = CoreGui:FindFirstChild("HepaUI")
    if old then old:Destroy() end
    self._sg  = MakeGui()
    self._nm  = BuildNotifManager(self._sg)
    self._kbl = BuildKeybindList(self._sg)
    self._wms = {}
    self._wins = {}
    return self
end

function HepaUI:CreateLoader(opts)
    if not self._sg then self:Init() end
    return BuildLoader(self._sg, opts)
end

function HepaUI:CreateWindow(opts)
    if not self._sg then self:Init() end
    local w = Window.new(self._sg, opts)
    table.insert(self._wins, w)
    return w
end

function HepaUI:CreateWatermark(opts)
    if not self._sg then self:Init() end
    local wm = BuildWatermark(self._sg, opts)
    table.insert(self._wms, wm)
    return wm
end

function HepaUI:Notify(opts)
    if not self._sg then self:Init() end
    self._nm:Push(opts)
end

function HepaUI:GetKeybindList()
    if not self._sg then self:Init() end
    return self._kbl
end

function HepaUI:SetTheme(nt)
    for k,v in pairs(nt) do T[k] = v end
end

function HepaUI:Destroy()
    pcall(function() if self._sg then self._sg:Destroy() end end)
end

game:GetService("Players").PlayerRemoving:Connect(function(p)
    if p == LP then pcall(function() HepaUI:Destroy() end) end
end)

HepaUI:Init()
return HepaUI
