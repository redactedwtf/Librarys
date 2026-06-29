if getgenv().Library then
    getgenv().Library:Exit()
end

cloneref = cloneref or function(...) return ... end

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local GuiService = game:GetService("GuiService")
local TextService = game:GetService("TextService")
local CoreGui = cloneref(game:GetService("CoreGui"))
local Lighting = game:GetService("Lighting")

gethui = gethui or function() return CoreGui end

local LocalPlayer = Players.LocalPlayer
local IsMobile = UserInputService.TouchEnabled or false
local GuiInset = GuiService:GetGuiInset().Y
local Mouse = cloneref(LocalPlayer:GetMouse())

local Library = {
    Flags = {},
    MenuKeybind = tostring(Enum.KeyCode.X),
    Directory = "EnhancedLibrary",
    Folders = {
        Assets = "/Assets",
        Configs = "/Configs",
        Themes = "/Themes"
    },
    FontSize = 13,
    Animation = {
        Time = 0.3,
        Style = "Quint",
        Direction = "Out"
    },
    TabAnimation = {
        Time = 0.8,
        Style = "Exponential",
        Direction = "Out"
    },
    ColorpickerAnimation = {
        Time = 0.5,
        Style = "Exponential",
        Direction = "Out"
    },
    NotifAnimation = {
        Time = 0.85,
        Style = "Exponential",
        Direction = "Out"
    },
    ZIndexOrder = {
        OptionHolder = 4,
        KeybindWindow = 4,
        ColorpickerWindow = 6,
        DropdownWindow = 5,
        ContextMenu = 7,
        Notification = 8,
        Tooltip = 9
    },
    Threads = {},
    Connections = {},
    SetFlags = {},
    ThemingStuff = {},
    ThemeMap = {},
    OpenFrames = {},
    Holder = nil,
    UnusedHolder = nil,
    Font = nil,
    Notifications = {},
    KeyList = nil,
    Theme = nil,
    CurrentTheme = "Modern",
    Watermark = nil,
    KeybindList = nil,
    NotifHolder = nil,
    Tooltips = {},
    ContextMenus = {},
    ActivePopups = {},
}

do
    Library.__index = Library
    local Flags = Library.Flags
    local SetFlags = Library.SetFlags

    local Keys = {
        ["Unknown"] = "Unknown",
        ["Backspace"] = "Back",
        ["Tab"] = "Tab",
        ["Clear"] = "Clear",
        ["Return"] = "Return",
        ["Pause"] = "Pause",
        ["Escape"] = "Escape",
        ["Space"] = "Space",
        ["QuotedDouble"] = '"',
        ["Hash"] = "#",
        ["Dollar"] = "$",
        ["Percent"] = "%",
        ["Ampersand"] = "&",
        ["Quote"] = "'",
        ["LeftParenthesis"] = "(",
        ["RightParenthesis"] = ")",
        ["Asterisk"] = "*",
        ["Plus"] = "+",
        ["Comma"] = ",",
        ["Minus"] = "-",
        ["Period"] = ".",
        ["Slash"] = "`",
        ["Three"] = "3",
        ["Seven"] = "7",
        ["Eight"] = "8",
        ["Colon"] = ":",
        ["Semicolon"] = ";",
        ["LessThan"] = "<",
        ["GreaterThan"] = ">",
        ["Question"] = "?",
        ["Equals"] = "=",
        ["At"] = "@",
        ["LeftBracket"] = "[",
        ["RightBracket"] = "]",
        ["BackSlash"] = "\\",
        ["Caret"] = "^",
        ["Underscore"] = "_",
        ["Backquote"] = "`",
        ["LeftCurly"] = "{",
        ["Pipe"] = "|",
        ["RightCurly"] = "}",
        ["Tilde"] = "~",
        ["Delete"] = "Delete",
        ["End"] = "End",
        ["KeypadZero"] = "0",
        ["KeypadOne"] = "1",
        ["KeypadTwo"] = "2",
        ["KeypadThree"] = "3",
        ["KeypadFour"] = "4",
        ["KeypadFive"] = "5",
        ["KeypadSix"] = "6",
        ["KeypadSeven"] = "7",
        ["KeypadEight"] = "8",
        ["KeypadNine"] = "9",
        ["KeypadPeriod"] = ".",
        ["KeypadDivide"] = "/",
        ["KeypadMultiply"] = "*",
        ["KeypadMinus"] = "-",
        ["KeypadPlus"] = "+",
        ["KeypadEnter"] = "Enter",
        ["KeypadEquals"] = "=",
        ["Insert"] = "Insert",
        ["Home"] = "Home",
        ["PageUp"] = "PgUp",
        ["PageDown"] = "PgDn",
        ["RightShift"] = "RShift",
        ["LeftShift"] = "LShift",
        ["RightControl"] = "RCtrl",
        ["LeftControl"] = "LCtrl",
        ["LeftAlt"] = "LAlt",
        ["RightAlt"] = "RAlt"
    }

    if not isfolder(Library.Directory) then
        makefolder(Library.Directory)
    end

    for _, Folder in Library.Folders do
        if not isfolder(Library.Directory .. Folder) then
            makefolder(Library.Directory .. Folder)
        end
    end

    if not isfile(Library.Directory .. "/autoload.json") then
        writefile(Library.Directory .. "/autoload.json", "")
    end

    local ThemePresets = {
        ["Modern"] = {
            ["Border"] = Color3.fromRGB(30, 30, 35),
            ["Outline"] = Color3.fromRGB(45, 45, 55),
            ["Background"] = Color3.fromRGB(18, 18, 22),
            ["Inline"] = Color3.fromRGB(28, 28, 34),
            ["Accent"] = Color3.fromRGB(180, 120, 220),
            ["Accent2"] = Color3.fromRGB(140, 80, 190),
            ["Text"] = Color3.fromRGB(235, 235, 240),
            ["TextSec"] = Color3.fromRGB(160, 160, 175),
            ["TextDis"] = Color3.fromRGB(90, 90, 105),
            ["Inactive Text"] = Color3.fromRGB(130, 130, 145),
            ["Element"] = Color3.fromRGB(35, 35, 42),
            ["Element2"] = Color3.fromRGB(50, 50, 60),
            ["Hovered Element"] = Color3.fromRGB(55, 55, 68),
            ["Active Element"] = Color3.fromRGB(70, 50, 90),
            ["Divider"] = Color3.fromRGB(40, 40, 48),
            ["SliderFill"] = Color3.fromRGB(180, 120, 220),
            ["SliderBG"] = Color3.fromRGB(38, 38, 46),
            ["ToggleOn"] = Color3.fromRGB(180, 120, 220),
            ["ToggleOff"] = Color3.fromRGB(55, 55, 65),
            ["Knob"] = Color3.fromRGB(240, 240, 245),
            ["DropdownBG"] = Color3.fromRGB(24, 24, 30),
            ["DropdownHover"] = Color3.fromRGB(55, 45, 70),
            ["NotificationBG"] = Color3.fromRGB(26, 26, 34),
            ["WatermarkBG"] = Color3.fromRGB(20, 20, 26),
            ["LoaderBG"] = Color3.fromRGB(16, 16, 20),
            ["LoaderBar"] = Color3.fromRGB(180, 120, 220),
            ["LoaderBarBG"] = Color3.fromRGB(36, 36, 44),
            ["KeyBG"] = Color3.fromRGB(20, 20, 26),
            ["Shadow"] = Color3.fromRGB(0, 0, 0),
            ["Success"] = Color3.fromRGB(80, 210, 120),
            ["Warning"] = Color3.fromRGB(220, 180, 50),
            ["Error"] = Color3.fromRGB(220, 70, 70),
            ["Info"] = Color3.fromRGB(70, 160, 220)
        },
        ["Cyberpunk"] = {
            ["Border"] = Color3.fromRGB(20, 10, 30),
            ["Outline"] = Color3.fromRGB(40, 20, 50),
            ["Background"] = Color3.fromRGB(10, 5, 18),
            ["Inline"] = Color3.fromRGB(25, 15, 35),
            ["Accent"] = Color3.fromRGB(255, 0, 200),
            ["Accent2"] = Color3.fromRGB(0, 200, 255),
            ["Text"] = Color3.fromRGB(220, 200, 240),
            ["TextSec"] = Color3.fromRGB(150, 130, 170),
            ["TextDis"] = Color3.fromRGB(80, 60, 100),
            ["Inactive Text"] = Color3.fromRGB(120, 100, 140),
            ["Element"] = Color3.fromRGB(30, 18, 40),
            ["Element2"] = Color3.fromRGB(45, 30, 55),
            ["Hovered Element"] = Color3.fromRGB(55, 40, 65),
            ["Active Element"] = Color3.fromRGB(65, 20, 80),
            ["Divider"] = Color3.fromRGB(35, 20, 45),
            ["SliderFill"] = Color3.fromRGB(255, 0, 200),
            ["SliderBG"] = Color3.fromRGB(30, 18, 40),
            ["ToggleOn"] = Color3.fromRGB(255, 0, 200),
            ["ToggleOff"] = Color3.fromRGB(50, 30, 60),
            ["Knob"] = Color3.fromRGB(240, 240, 245),
            ["DropdownBG"] = Color3.fromRGB(20, 10, 30),
            ["DropdownHover"] = Color3.fromRGB(65, 30, 85),
            ["NotificationBG"] = Color3.fromRGB(22, 12, 32),
            ["WatermarkBG"] = Color3.fromRGB(16, 8, 24),
            ["LoaderBG"] = Color3.fromRGB(12, 6, 20),
            ["LoaderBar"] = Color3.fromRGB(255, 0, 200),
            ["LoaderBarBG"] = Color3.fromRGB(30, 18, 40),
            ["KeyBG"] = Color3.fromRGB(18, 8, 26),
            ["Shadow"] = Color3.fromRGB(0, 0, 0),
            ["Success"] = Color3.fromRGB(0, 255, 150),
            ["Warning"] = Color3.fromRGB(255, 200, 0),
            ["Error"] = Color3.fromRGB(255, 50, 50),
            ["Info"] = Color3.fromRGB(0, 150, 255)
        },
        ["Navy"] = {
            ["Border"] = Color3.fromRGB(10, 15, 30),
            ["Outline"] = Color3.fromRGB(25, 35, 50),
            ["Background"] = Color3.fromRGB(12, 18, 30),
            ["Inline"] = Color3.fromRGB(20, 28, 42),
            ["Accent"] = Color3.fromRGB(60, 150, 255),
            ["Accent2"] = Color3.fromRGB(40, 100, 220),
            ["Text"] = Color3.fromRGB(220, 225, 240),
            ["TextSec"] = Color3.fromRGB(150, 160, 180),
            ["TextDis"] = Color3.fromRGB(80, 90, 110),
            ["Inactive Text"] = Color3.fromRGB(120, 130, 150),
            ["Element"] = Color3.fromRGB(28, 38, 55),
            ["Element2"] = Color3.fromRGB(42, 52, 70),
            ["Hovered Element"] = Color3.fromRGB(50, 62, 82),
            ["Active Element"] = Color3.fromRGB(40, 70, 120),
            ["Divider"] = Color3.fromRGB(35, 45, 60),
            ["SliderFill"] = Color3.fromRGB(60, 150, 255),
            ["SliderBG"] = Color3.fromRGB(30, 40, 55),
            ["ToggleOn"] = Color3.fromRGB(60, 150, 255),
            ["ToggleOff"] = Color3.fromRGB(50, 60, 75),
            ["Knob"] = Color3.fromRGB(240, 240, 245),
            ["DropdownBG"] = Color3.fromRGB(18, 25, 40),
            ["DropdownHover"] = Color3.fromRGB(45, 70, 120),
            ["NotificationBG"] = Color3.fromRGB(20, 28, 45),
            ["WatermarkBG"] = Color3.fromRGB(15, 22, 38),
            ["LoaderBG"] = Color3.fromRGB(12, 18, 32),
            ["LoaderBar"] = Color3.fromRGB(60, 150, 255),
            ["LoaderBarBG"] = Color3.fromRGB(30, 40, 55),
            ["KeyBG"] = Color3.fromRGB(16, 22, 38),
            ["Shadow"] = Color3.fromRGB(0, 0, 0),
            ["Success"] = Color3.fromRGB(60, 210, 140),
            ["Warning"] = Color3.fromRGB(220, 190, 50),
            ["Error"] = Color3.fromRGB(220, 60, 60),
            ["Info"] = Color3.fromRGB(60, 160, 220)
        },
        ["Magma"] = {
            ["Border"] = Color3.fromRGB(30, 10, 10),
            ["Outline"] = Color3.fromRGB(50, 25, 20),
            ["Background"] = Color3.fromRGB(20, 10, 10),
            ["Inline"] = Color3.fromRGB(35, 18, 15),
            ["Accent"] = Color3.fromRGB(255, 80, 40),
            ["Accent2"] = Color3.fromRGB(220, 50, 20),
            ["Text"] = Color3.fromRGB(240, 220, 215),
            ["TextSec"] = Color3.fromRGB(180, 155, 150),
            ["TextDis"] = Color3.fromRGB(100, 80, 75),
            ["Inactive Text"] = Color3.fromRGB(150, 125, 120),
            ["Element"] = Color3.fromRGB(40, 20, 18),
            ["Element2"] = Color3.fromRGB(55, 30, 25),
            ["Hovered Element"] = Color3.fromRGB(65, 40, 35),
            ["Active Element"] = Color3.fromRGB(90, 45, 35),
            ["Divider"] = Color3.fromRGB(45, 25, 20),
            ["SliderFill"] = Color3.fromRGB(255, 80, 40),
            ["SliderBG"] = Color3.fromRGB(40, 20, 18),
            ["ToggleOn"] = Color3.fromRGB(255, 80, 40),
            ["ToggleOff"] = Color3.fromRGB(55, 30, 25),
            ["Knob"] = Color3.fromRGB(240, 240, 245),
            ["DropdownBG"] = Color3.fromRGB(25, 12, 12),
            ["DropdownHover"] = Color3.fromRGB(80, 35, 28),
            ["NotificationBG"] = Color3.fromRGB(28, 14, 14),
            ["WatermarkBG"] = Color3.fromRGB(22, 11, 11),
            ["LoaderBG"] = Color3.fromRGB(18, 9, 9),
            ["LoaderBar"] = Color3.fromRGB(255, 80, 40),
            ["LoaderBarBG"] = Color3.fromRGB(40, 20, 18),
            ["KeyBG"] = Color3.fromRGB(22, 11, 11),
            ["Shadow"] = Color3.fromRGB(0, 0, 0),
            ["Success"] = Color3.fromRGB(80, 210, 120),
            ["Warning"] = Color3.fromRGB(220, 180, 50),
            ["Error"] = Color3.fromRGB(220, 60, 60),
            ["Info"] = Color3.fromRGB(70, 160, 220)
        }
    }

    Library.Theme = ThemePresets.Modern

    local CustomFont = {}
    do
        function CustomFont:New(Name, Weight, Style, Data)
            if not isfile(Data.Id) then
                writefile(Data.Id, game:HttpGet(Data.Url))
            end

            local FontData = {
                name = Name,
                faces = {
                    {
                        name = Name,
                        weight = Weight,
                        style = Style,
                        assetId = getcustomasset(Data.Id)
                    }
                }
            }

            writefile(Library.Directory .. Library.Folders.Assets .. "/" .. Name .. ".font", HttpService:JSONEncode(FontData))
            return Font.new(getcustomasset(Library.Directory .. Library.Folders.Assets .. "/" .. Name .. ".font"))
        end

        Library.Font = CustomFont:New("Inter", 400, "Regular", {
            Id = "InterFont",
            Url = "https://github.com/rsms/inter/raw/master/docs/font-files/Inter-Regular.otf"
        })

        Library.FontBold = CustomFont:New("InterBold", 700, "Bold", {
            Id = "InterBoldFont",
            Url = "https://github.com/rsms/inter/raw/master/docs/font-files/Inter-Bold.otf"
        })

        Library.FontSemi = CustomFont:New("InterSemi", 600, "SemiBold", {
            Id = "InterSemiFont",
            Url = "https://github.com/rsms/inter/raw/master/docs/font-files/Inter-SemiBold.otf"
        })
    end

    Library.Exit = function(Self)
        for _, Connection in Library.Connections do
            Connection:Disconnect()
        end

        for _, Thread in Library.Threads do
            coroutine.close(Thread)
        end

        if Self.Holder then
            Self.Holder.Instance:Destroy()
        end

        if Self.UnusedHolder then
            Self.UnusedHolder.Instance:Destroy()
        end

        if Self.NotifHolder then
            Self.NotifHolder.Instance:Destroy()
        end

        for Index, Value in Library.Notifications do
            if Value and Value.Items and Value.Items.Notification then
                Value.Items.Notification.Instance:Destroy()
            end
        end

        for Index, Tooltip in Library.Tooltips do
            if Tooltip and Tooltip.Instance then
                Tooltip.Instance:Destroy()
            end
        end

        Library = nil
        getgenv().Library = nil
    end

    Library.Create = function(Self, Class, Properties)
        local Data = {
            Class = Class,
            Properties = Properties,
            Instance = Instance.new(Class)
        }

        for Index, Property in Properties do
            if Index == "FontFace" then
                Data.Instance[Index] = Library.Font
                continue
            end

            if Index == "FontFaceBold" then
                Data.Instance[Index] = Library.FontBold
                continue
            end

            if Index == "FontFaceSemi" then
                Data.Instance[Index] = Library.FontSemi
                continue
            end

            if Index == "TextSize" then
                Data.Instance[Index] = Library.FontSize
                continue
            end

            if Index == "Name" then
                Data.Instance[Index] = "\0"
                continue
            end

            if Class == "TextButton" then
                if Index == "AutoButtonColor" then
                    Data.Instance[Index] = false
                    continue
                end

                if Index == "Text" then
                    Data.Instance[Index] = ""
                    continue
                end
            end

            if Class == "TextBox" then
                if Index == "ClearTextOnFocus" then
                    Data.Instance[Index] = false
                    continue
                end
            end

            Data.Instance[Index] = Property
        end

        return setmetatable(Data, Library)
    end

    Library.Thread = function(Self, Function)
        local NewThread = coroutine.create(Function)

        coroutine.wrap(function()
            coroutine.resume(NewThread)
        end)()

        table.insert(Library.Threads, NewThread)
        return NewThread
    end

    Library.Connect = function(Self, Signal, Callback)
        local Connection

        if Self.Instance then
            if Self.Instance[Signal] then
                if IsMobile and Signal == "MouseButton1Down" then
                    Connection = Self.Instance.InputBegan:Connect(function(Input)
                        if Input.UserInputType == Enum.UserInputType.Touch or Input.UserInputType == Enum.UserInputType.MouseButton1 then
                            Callback(Input)
                        end
                    end)
                    return Connection
                end

                Connection = Self.Instance[Signal]:Connect(Callback)
            else
                Connection = Signal:Connect(Callback)
            end
        else
            Connection = Signal:Connect(Callback)
        end

        table.insert(Library.Connections, Connection)
        return Connection
    end

    Library.Tween = function(Self, Properties, Info, IsRawItem)
        if not Library then return end

        local Object = Self.Instance or IsRawItem
        Info = Info or TweenInfo.new(Library.Animation.Time, Enum.EasingStyle[Library.Animation.Style], Enum.EasingDirection[Library.Animation.Direction])

        if not Object then
            return
        end

        local NewTween = TweenService:Create(Object, Info, Properties)
        NewTween:Play()

        return NewTween
    end

    Library.GetTweenProperty = function(Self, IsRawItem)
        local Object = Self.Instance or IsRawItem

        if not Object then
            return {}
        end

        if Object:IsA("Frame") then
            return {"BackgroundTransparency"}
        elseif Object:IsA("TextLabel") or Object:IsA("TextButton") then
            return {"TextTransparency", "BackgroundTransparency"}
        elseif Object:IsA("ImageLabel") or Object:IsA("ImageButton") then
            return {"BackgroundTransparency", "ImageTransparency"}
        elseif Object:IsA("ScrollingFrame") then
            return {"BackgroundTransparency", "ScrollBarImageTransparency"}
        elseif Object:IsA("TextBox") then
            return {"TextTransparency", "BackgroundTransparency"}
        elseif Object:IsA("UIStroke") then
            return {"Transparency"}
        end
    end

    Library.Fade = function(Self, Property, Visibility, IsRawItem)
        local Object = Self.Instance or IsRawItem

        if not Object then
            return
        end

        local OldTransparency = Object[Property]
        Object[Property] = Visibility and 1 or OldTransparency

        local NewTween = Library:Tween({[Property] = Visibility and OldTransparency or 1}, nil, Object)

        Library:Connect(NewTween.Completed, function()
            if not Visibility then
                task.wait()
                Object[Property] = OldTransparency
            end
        end)

        return NewTween
    end

    Library.FadeDescendants = function(Self, Visibility, Callback)
        if Visibility then
            Self.Instance.Visible = true
        end

        local NewTween
        local Children = Self.Instance:GetDescendants()
        table.insert(Children, Self.Instance)

        for _, Child in Children do
            local TransparencyProperty = Library:GetTweenProperty(Child)

            if not TransparencyProperty then
                continue
            end

            if type(TransparencyProperty) == "table" then
                for _, Property in TransparencyProperty do
                    NewTween = Library:Fade(Property, Visibility, Child)
                end
            else
                NewTween = Library:Fade(TransparencyProperty, Visibility, Child)
            end
        end

        if NewTween then
            Library:Connect(NewTween.Completed, function()
                if Callback and type(Callback) == "function" then
                    Callback()
                end

                Self.Instance.Visible = Visibility
            end)
        else
            if Callback and type(Callback) == "function" then
                Callback()
            end
            Self.Instance.Visible = Visibility
        end
    end

    Library.MakeDraggable = function(Self, Handle)
        if not Self.Instance then
            return
        end

        local Gui = Self.Instance
        local DragHandle = Handle and Handle.Instance or Gui
        local Dragging = false
        local DragStart
        local StartPosition

        local Set = function(Input)
            local Scale = Library:GetScreenScale()
            local DragDelta = (Input.Position - DragStart) / Scale

            local NewX = StartPosition.X.Offset + DragDelta.X
            local NewY = StartPosition.Y.Offset + DragDelta.Y

            local ScreenSize = Gui.Parent.AbsoluteSize / Scale
            local GuiSize = Gui.AbsoluteSize / Scale

            NewX = math.clamp(NewX, 0, ScreenSize.X - GuiSize.X)
            NewY = math.clamp(NewY, 0, ScreenSize.Y - GuiSize.Y)

            Self:Tween({Position = UDim2.new(0, NewX, 0, NewY)}, TweenInfo.new(0.65, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out))
        end

        local InputChanged

        Self:Connect(DragHandle, "InputBegan", function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                Dragging = true
                DragStart = Input.Position
                StartPosition = Gui.Position

                if InputChanged then
                    return
                end

                InputChanged = Input.Changed:Connect(function()
                    if Input.UserInputState == Enum.UserInputState.End then
                        Dragging = false
                        InputChanged:Disconnect()
                        InputChanged = nil
                    end
                end)
            end
        end)

        Library:Connect(UserInputService.InputChanged, function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
                if Dragging then
                    Set(Input)
                end
            end
        end)

        return Dragging
    end

    Library.MakeResizeable = function(Self, Minimum)
        if not Self.Instance then
            return
        end

        local Gui = Self.Instance
        local Resizing = false
        local CurrentSide = nil
        local StartMouse = nil
        local StartPosition = nil
        local StartSize = nil
        local EdgeThickness = 3

        local MakeEdge = function(Name, Position, Size)
            local Button = Library:Create("TextButton", {
                Name = "\0",
                Size = Size,
                Position = Position,
                BackgroundColor3 = Library.Theme.Accent,
                BackgroundTransparency = 1,
                Text = "",
                BorderSizePixel = 0,
                AutoButtonColor = false,
                Parent = Gui,
                ZIndex = 100
            })
            Button:AddToTheme({BackgroundColor3 = "Accent"})
            return Button
        end

        local Edges = {
            {Button = MakeEdge("Left", UDim2.new(0, 0, 0, 0), UDim2.new(0, EdgeThickness, 1, 0)), Side = "L"},
            {Button = MakeEdge("Right", UDim2.new(1, -EdgeThickness, 0, 0), UDim2.new(0, EdgeThickness, 1, 0)), Side = "R"},
            {Button = MakeEdge("Top", UDim2.new(0, 0, 0, 0), UDim2.new(1, 0, 0, EdgeThickness)), Side = "T"},
            {Button = MakeEdge("Bottom", UDim2.new(0, 0, 1, -EdgeThickness), UDim2.new(1, 0, 0, EdgeThickness)), Side = "B"},
        }

        local BeginResizing = function(Side)
            Resizing = true
            CurrentSide = Side
            StartMouse = UserInputService:GetMouseLocation()
            StartPosition = Vector2.new(Gui.Position.X.Offset, Gui.Position.Y.Offset)
            StartSize = Vector2.new(Gui.Size.X.Offset, Gui.Size.Y.Offset)

            for Index, Value in Edges do
                Value.Button.Instance.BackgroundTransparency = (Value.Side == Side) and 0.6 or 1
            end
        end

        local EndResizing = function()
            Resizing = false
            CurrentSide = nil

            for Index, Value in Edges do
                Value.Button.Instance.BackgroundTransparency = 1
            end
        end

        for Index, Value in Edges do
            Value.Button:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    BeginResizing(Value.Side)
                end
            end)
        end

        Library:Connect(UserInputService.InputEnded, function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                if Resizing then
                    EndResizing()
                end
            end
        end)

        Library:Connect(RunService.RenderStepped, function()
            if not Resizing or not CurrentSide then
                return
            end

            local MouseLocation = UserInputService:GetMouseLocation()
            local dx = MouseLocation.X - StartMouse.X
            local dy = MouseLocation.Y - StartMouse.Y

            local x, y = StartPosition.X, StartPosition.Y
            local w, h = StartSize.X, StartSize.Y

            if CurrentSide == "L" then
                x = StartPosition.X + dx
                w = StartSize.X - dx
            elseif CurrentSide == "R" then
                w = StartSize.X + dx
            elseif CurrentSide == "T" then
                y = StartPosition.Y + dy
                h = StartSize.Y - dy
            elseif CurrentSide == "B" then
                h = StartSize.Y + dy
            end

            if w < Minimum.X then
                if CurrentSide == "L" then
                    x = x - (Minimum.X - w)
                end
                w = Minimum.X
            end
            if h < Minimum.Y then
                if CurrentSide == "T" then
                    y = y - (Minimum.Y - h)
                end
                h = Minimum.Y
            end

            Self:Tween({Position = UDim2.fromOffset(x, y)}, TweenInfo.new(0.65, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out))
            Self:Tween({Size = UDim2.fromOffset(w, h)}, TweenInfo.new(0.65, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out))
        end)
    end

    Library.IsMouseOverFrame = function(Self)
        if not Self.Instance then
            return false
        end

        local Object = Self.Instance
        local MousePosition = Vector2.new(Mouse.X, Mouse.Y)

        return MousePosition.X >= Object.AbsolutePosition.X and MousePosition.X <= Object.AbsolutePosition.X + Object.AbsoluteSize.X
            and MousePosition.Y >= Object.AbsolutePosition.Y and MousePosition.Y <= Object.AbsolutePosition.Y + Object.AbsoluteSize.Y
    end

    Library.SafeCall = function(Self, Function, ...)
        local Arguments = {...}
        local Success, Result = pcall(Function, table.unpack(Arguments))

        if not Success then
            warn(Result)
            return false
        end

        return Success, Result
    end

    Library.Round = function(Self, Number, Float)
        local Multiplier = 1 / (Float or 1)
        return math.floor(Number * Multiplier + 0.5) / Multiplier
    end

    Library.Clamp = function(Self, Value, Min, Max)
        return math.max(Min, math.min(Max, Value))
    end

    Library.Lerp = function(Self, A, B, T)
        return A + (B - A) * T
    end

    Library.HexToRGB = function(Self, Hex)
        Hex = Hex:gsub("#", "")
        local R = tonumber(Hex:sub(1, 2), 16) or 0
        local G = tonumber(Hex:sub(3, 4), 16) or 0
        local B = tonumber(Hex:sub(5, 6), 16) or 0
        return Color3.fromRGB(R, G, B)
    end

    Library.RGBToHex = function(Self, Color)
        return string.format("#%02X%02X%02X", Color.R * 255, Color.G * 255, Color.B * 255)
    end

    Library.GetConfig = function(Self)
        local Config = {}

        local Success, Result = Library:SafeCall(function()
            for Index, Value in Library.Flags do
                if type(Value) == "table" and Value.Key then
                    Config[Index] = {Key = tostring(Value.Key), Mode = Value.Mode, Toggled = Value.Toggled}
                elseif type(Value) == "table" and Value.Color then
                    Config[Index] = {Color = "#" .. Value.HexValue, Alpha = Value.Alpha}
                elseif type(Value) == "table" and type(Value[1]) == "string" then
                    Config[Index] = Value
                else
                    Config[Index] = Value
                end
            end
        end)

        if not Success then
            warn("Failed to get config:\n" .. Result)
            return
        end

        return HttpService:JSONEncode(Config)
    end

    Library.LoadConfig = function(Self, Config)
        local Decoded = HttpService:JSONDecode(Config)

        local Success, Result = Library:SafeCall(function()
            for Index, Value in Decoded do
                local SetFunction = Library.SetFlags[Index]

                if not SetFunction then
                    continue
                end

                if type(Value) == "table" and Value.Key then
                    SetFunction(Value)
                elseif type(Value) == "table" and Value.Color then
                    SetFunction(Value.Color, Value.Alpha)
                elseif type(Value) == "table" and type(Value[1]) == "string" then
                    SetFunction(Value)
                else
                    SetFunction(Value)
                end
            end
        end)

        return Success, Result
    end

    Library.GetConfigsList = function(Self, Element)
        local List = {}
        local ReturnList = {}

        List = listfiles(Library.Directory .. Library.Folders.Configs)

        for Index = 1, #List do
            local File = List[Index]

            if File:sub(-5) == ".json" then
                local Position = File:find(".json", 1, true)
                local StartPosition = Position

                local Character = File:sub(Position, Position)
                while Character ~= "/" and Character ~= "\\" and Character ~= "" do
                    Position = Position - 1
                    Character = File:sub(Position, Position)
                end

                if Character == "/" or Character == "\\" then
                    table.insert(ReturnList, File:sub(Position + 1, StartPosition - 1))
                end
            end
        end

        if Element and Element.Refresh then
            Element:Refresh(ReturnList)
        end

        return ReturnList
    end

    Library.AddToTheme = function(Self, Properties)
        local Object = Self.Instance

        local ThemeData = {
            Item = Object,
            Properties = Properties,
        }

        for Property, Value in ThemeData.Properties do
            if type(Value) == "string" then
                if not Library.Theme[Value] then
                    Object[Property] = Value
                else
                    Object[Property] = Library.Theme[Value]
                end
            else
                Object[Property] = Value()
            end
        end

        table.insert(Library.ThemingStuff, ThemeData)
        Library.ThemeMap[Object] = ThemeData
        return Self
    end

    Library.ChangeItemTheme = function(Self, Properties)
        local Object = Self.Instance

        if not Library.ThemeMap[Object] then
            return
        end

        Library.ThemeMap[Object].Properties = Properties
        Library.ThemeMap[Object] = Library.ThemeMap[Object]
    end

    Library.ChangeTheme = function(Self, Theme, Color)
        Library.Theme[Theme] = Color

        for _, Item in Library.ThemingStuff do
            for Property, Value in Item.Properties do
                if type(Value) == "string" and Value == Theme then
                    Item.Item[Property] = Color
                elseif type(Value) == "function" then
                    Item.Item[Property] = Value()
                end
            end
        end
    end

    Library.SetThemePreset = function(Self, ThemeName)
        if ThemePresets[ThemeName] then
            for Index, Value in ThemePresets[ThemeName] do
                Library:ChangeTheme(Index, Value)
            end
            Library.CurrentTheme = ThemeName
        end
    end

    Library.OnHover = function(Self, OnHoverEnter, OnHoverLeave)
        local Object = Self.Instance

        if not Object then
            return
        end

        Library:Connect(Object.MouseEnter, OnHoverEnter)
        Library:Connect(Object.MouseLeave, OnHoverLeave)
    end

    Library.GetScreenScale = function(Self)
        local Scale = 1

        if Library.Holder and Library.Holder.Instance then
            for _, Obj in Library.Holder.Instance:GetDescendants() do
                if Obj:IsA("UIScale") then
                    Scale = Scale * Obj.Scale
                end
            end
        end

        return Scale
    end

    Library.PopupPosition = function(Self, Anchor, Popup, ExtraY, ExtraX)
        local Scale = Library:GetScreenScale()
        ExtraY = ExtraY or 0
        ExtraX = ExtraX or 0

        local X = (Anchor.AbsolutePosition.X + ExtraX) / Scale
        local Y = (Anchor.AbsolutePosition.Y + Anchor.AbsoluteSize.Y + GuiInset + ExtraY) / Scale

        local PopupSize = Popup.AbsoluteSize / Scale

        if X + PopupSize.X > 1 then
            X = 1 - PopupSize.X
        end

        if Y + PopupSize.Y > 1 then
            Y = (Anchor.AbsolutePosition.Y - PopupSize.Y - GuiInset) / Scale
        end

        return UDim2.new(0, X, 0, Y)
    end

    Library.VisibleCheck = function(Self)
        local Object = Self.Instance

        if not Object then
            return
        end

        local OriginalParent = Object.Parent

        Library:Connect(Object:GetPropertyChangedSignal("Visible"), function()
            local IsVisible = Object.Visible
            if Library.UnusedHolder and Library.UnusedHolder.Instance then
                Object.Parent = IsVisible and OriginalParent or Library.UnusedHolder.Instance
            end
        end)
    end

    Library.GetTheme = function(Self)
        local Config = {}

        local Success, Result = Library:SafeCall(function()
            for Index, Value in Library.Flags do
                if type(Value) == "table" and Value.Color and Value.Flag:find("Theming") then
                    Config[Index] = {Color = "#" .. Value.HexValue, Alpha = Value.Alpha}
                end
            end
        end)

        if not Success then
            warn("Failed to get theme:\n" .. Result)
            return
        end

        return HttpService:JSONEncode(Config)
    end

    Library.LoadTheme = function(Self, Config)
        local Decoded = HttpService:JSONDecode(Config)

        local Success, Result = Library:SafeCall(function()
            for Index, Value in Decoded do
                local SetFunction = Library.SetFlags[Index]

                if not SetFunction then
                    continue
                end

                if type(Value) == "table" and Value.Color then
                    SetFunction(Value.Color, Value.Alpha)
                end
            end
        end)

        return Success, Result
    end

    Library.GetThemesList = function(Self, Element)
        local List = {}
        local ReturnList = {}

        List = listfiles(Library.Directory .. Library.Folders.Themes)

        for Index = 1, #List do
            local File = List[Index]

            if File:sub(-5) == ".json" then
                local Position = File:find(".json", 1, true)
                local StartPosition = Position

                local Character = File:sub(Position, Position)
                while Character ~= "/" and Character ~= "\\" and Character ~= "" do
                    Position = Position - 1
                    Character = File:sub(Position, Position)
                end

                if Character == "/" or Character == "\\" then
                    table.insert(ReturnList, File:sub(Position + 1, StartPosition - 1))
                end
            end
        end

        if Element and Element.Refresh then
            Element:Refresh(ReturnList)
        end

        return ReturnList
    end

    Library.CreateCorner = function(Self, Radius)
        return Library:Create("UICorner", {
            CornerRadius = UDim.new(0, Radius or 6),
            Parent = Self.Instance
        })
    end

    Library.CreateStroke = function(Self, Color, Thickness, Transparency)
        return Library:Create("UIStroke", {
            Color = Color or Library.Theme.Border,
            Thickness = Thickness or 1,
            Transparency = Transparency or 0,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
            LineJoinMode = Enum.LineJoinMode.Miter,
            Parent = Self.Instance
        })
    end

    Library.CreateShadow = function(Self, Size, Transparency)
        Size = Size or 15
        Transparency = Transparency or 0.7

        return Library:Create("ImageLabel", {
            Name = "\0",
            Size = UDim2.new(1, Size * 2, 1, Size * 2),
            Position = UDim2.new(0, -Size, 0, -Size),
            BackgroundTransparency = 1,
            Image = "rbxassetid://6014261993",
            ImageColor3 = Library.Theme.Shadow,
            ImageTransparency = Transparency,
            ScaleType = Enum.ScaleType.Slice,
            SliceCenter = Rect.new(49, 49, 450, 450),
            ZIndex = 0,
            Parent = Self.Instance
        })
    end

    Library.CreateGlow = function(Self, Size, Transparency)
        Size = Size or 12
        Transparency = Transparency or 0.85

        return Library:Create("ImageLabel", {
            Name = "\0",
            Size = UDim2.new(1, Size * 2, 1, Size * 2),
            Position = UDim2.new(0, -Size, 0, -Size),
            BackgroundTransparency = 1,
            Image = "rbxassetid://6014260067",
            ImageColor3 = Library.Theme.Accent,
            ImageTransparency = Transparency,
            ScaleType = Enum.ScaleType.Slice,
            SliceCenter = Rect.new(49, 49, 450, 450),
            ZIndex = 0,
            Parent = Self.Instance
        })
    end

    Library.CreateGradient = function(Self, Rotation, Colors, Transparency)
        local ColorSequence = ColorSequence.new()

        if Colors then
            local Keypoints = {}
            for Index, Color in Colors do
                table.insert(Keypoints, ColorSequenceKeypoint.new(Index / #Colors, Color))
            end
            ColorSequence = ColorSequence.new(Keypoints)
        end

        return Library:Create("UIGradient", {
            Rotation = Rotation or 90,
            Color = ColorSequence,
            Transparency = Transparency or NumberSequence.new(0),
            Parent = Self.Instance
        })
    end

    Library.Tooltip = function(Self, Text, Duration)
        Duration = Duration or 2

        local Tooltip = Library:Create("Frame", {
            Name = "\0",
            Parent = Library.Holder.Instance,
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            BackgroundColor3 = Library.Theme.Background,
            BackgroundTransparency = 1,
            AutomaticSize = Enum.AutomaticSize.XY,
            BorderSizePixel = 0,
            Visible = false,
            ZIndex = Library.ZIndexOrder.Tooltip
        })

        Tooltip:CreateCorner(8)
        Tooltip:CreateStroke(Library.Theme.Border, 1)
        Tooltip:CreateShadow(10, 0.5)

        local Label = Library:Create("TextLabel", {
            Name = "\0",
            FontFace = Library.Font,
            TextSize = Library.FontSize,
            Parent = Tooltip.Instance,
            TextColor3 = Library.Theme.Text,
            Text = Text,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            AutomaticSize = Enum.AutomaticSize.XY,
            TextXAlignment = Enum.TextXAlignment.Center,
            TextYAlignment = Enum.TextYAlignment.Center
        })

        Label:AddToTheme({TextColor3 = "Text"})

        Library:Create("UIPadding", {
            Parent = Tooltip.Instance,
            PaddingTop = UDim.new(0, 8),
            PaddingBottom = UDim.new(0, 8),
            PaddingLeft = UDim.new(0, 12),
            PaddingRight = UDim.new(0, 12)
        })

        local ScreenSize = Library.Holder.Instance.AbsoluteSize
        Tooltip.Instance.Visible = true

        local MousePos = Vector2.new(Mouse.X, Mouse.Y)
        local TooltipSize = Tooltip.Instance.AbsoluteSize

        local X = MousePos.X + 15
        local Y = MousePos.Y + 15

        if X + TooltipSize.X > ScreenSize.X then
            X = MousePos.X - TooltipSize.X - 15
        end

        if Y + TooltipSize.Y > ScreenSize.Y then
            Y = MousePos.Y - TooltipSize.Y - 15
        end

        Tooltip.Instance.Position = UDim2.new(0, X, 0, Y)
        Tooltip:SetVisibility(true)

        table.insert(Library.Tooltips, Tooltip)

        task.delay(Duration, function()
            Tooltip:SetVisibility(false)
            Tooltip.Instance:Destroy()
            for Index, Value in Library.Tooltips do
                if Value == Tooltip then
                    table.remove(Library.Tooltips, Index)
                    break
                end
            end
        end)

        return Tooltip
    end

    Library.Holder = Library:Create("ScreenGui", {
        Parent = gethui(),
        IgnoreGuiInset = true,
        Name = "\0",
        ZIndexBehavior = Enum.ZIndexBehavior.Global,
        ResetOnSpawn = false
    })

    Library.NotifHolder = Library:Create("ScreenGui", {
        Parent = gethui(),
        IgnoreGuiInset = true,
        Name = "\0",
        ZIndexBehavior = Enum.ZIndexBehavior.Global,
        ResetOnSpawn = false
    })

    Library.UnusedHolder = Library:Create("ScreenGui", {
        Parent = gethui(),
        Name = "\0",
        Enabled = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Global,
        ResetOnSpawn = false
    })

    do
        local ColorpickerInfo = TweenInfo.new(Library.ColorpickerAnimation.Time, Enum.EasingStyle[Library.ColorpickerAnimation.Style], Enum.EasingDirection[Library.ColorpickerAnimation.Direction])

        Library.CreateColorpicker = function(Self, Data)
            local Colorpicker = {
                Hue = 0,
                Saturation = 1,
                Value = 1,
                Alpha = 1,
                Color = Color3.fromRGB(255, 255, 255),
                HexValue = "#FFFFFF",
                Flag = Data.Flag,
                IsOpen = false,
                Items = {}
            }

            local Items = {}
            do
                Items.ColorpickerButton = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Data.Parent.Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Size = UDim2.new(0, 24, 0, 10),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(255, 57, 83)
                })

                Items.ColorpickerButton:CreateGradient(90, {
                    Color3.fromRGB(255, 255, 255),
                    Color3.fromRGB(200, 200, 200)
                })

                Items.ColorpickerWindow = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Library.Holder.Instance,
                    Visible = false,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Position = UDim2.new(0, 1049, 0, 216),
                    Size = UDim2.new(0, 250, 0, 210),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme.Background,
                    ZIndex = Library.ZIndexOrder.ColorpickerWindow
                })

                Items.ColorpickerWindow:AddToTheme({BackgroundColor3 = "Background"})
                Items.ColorpickerWindow:CreateCorner(10)
                Items.ColorpickerWindow:CreateStroke(Library.Theme.Border, 1)
                Items.ColorpickerWindow:CreateStroke(Library.Theme.Outline, 1)
                Items.ColorpickerWindow:CreateShadow(15, 0.5)

                Items.CurrentColor = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items.ColorpickerWindow.Instance,
                    AnchorPoint = Vector2.new(0, 1),
                    Position = UDim2.new(0, 10, 1, -10),
                    Size = UDim2.new(1, -20, 0, 12),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(255, 57, 83)
                })

                Items.CurrentColor:CreateGradient(90, {
                    Color3.fromRGB(255, 255, 255),
                    Color3.fromRGB(200, 200, 200)
                })
                Items.CurrentColor:CreateStroke(Library.Theme.Outline, 1)
                Items.CurrentColor:CreateStroke(Library.Theme.Border, 1)

                Items.Alpha = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items.ColorpickerWindow.Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    AnchorPoint = Vector2.new(1, 0),
                    Position = UDim2.new(1, -10, 0, 10),
                    Size = UDim2.new(0, 16, 1, -50),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(255, 57, 83)
                })

                Items.AlphaFill = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items.Alpha.Instance,
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BorderSizePixel = 0
                })

                Items.AlphaFill:CreateGradient(-90, nil, NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0),
                    NumberSequenceKeypoint.new(1, 1)
                }))

                Items.AlphaDragger = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items.Alpha.Instance,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Size = UDim2.new(1, 0, 0, 2),
                    BorderSizePixel = 0
                })

                Items.AlphaDragger:CreateStroke(Library.Theme.Border, 1)
                Items.Alpha:CreateStroke(Library.Theme.Border, 1)
                Items.Alpha:CreateStroke(Library.Theme.Outline, 1)

                Items.Hue = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items.ColorpickerWindow.Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Text = "",
                    AutoButtonColor = false,
                    AnchorPoint = Vector2.new(1, 0),
                    Position = UDim2.new(1, -36, 0, 10),
                    Size = UDim2.new(0, 16, 1, -50),
                    BorderSizePixel = 0
                })

                Items.Hue:CreateGradient(90, {
                    Color3.fromRGB(255, 0, 0),
                    Color3.fromRGB(255, 255, 0),
                    Color3.fromRGB(0, 255, 0),
                    Color3.fromRGB(0, 255, 255),
                    Color3.fromRGB(0, 0, 255),
                    Color3.fromRGB(255, 0, 255),
                    Color3.fromRGB(255, 0, 0)
                })

                Items.HueDragger = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items.Hue.Instance,
                    Size = UDim2.new(1, 0, 0, 2),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BorderSizePixel = 0
                })

                Items.HueDragger:CreateStroke(Library.Theme.Border, 1)
                Items.Hue:CreateStroke(Library.Theme.Border, 1)
                Items.Hue:CreateStroke(Library.Theme.Outline, 1)

                Items.Palette = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items.ColorpickerWindow.Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Position = UDim2.new(0, 10, 0, 10),
                    Size = UDim2.new(1, -72, 1, -50),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(255, 57, 83)
                })

                Items.Palette:CreateStroke(Library.Theme.Border, 1)
                Items.Palette:CreateStroke(Library.Theme.Outline, 1)

                Items.PaletteSaturation = Library:Create("Frame", {
                    Name = "\0",
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Parent = Items.Palette.Instance,
                    Size = UDim2.new(1, 1, 1, 0),
                    BorderSizePixel = 0
                })

                Items.PaletteSaturation:CreateGradient(0, nil, NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 1),
                    NumberSequenceKeypoint.new(1, 0)
                }))

                Items.PaletteValue = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items.Palette.Instance,
                    Size = UDim2.new(1, 1, 1, 1),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                })

                Items.PaletteValue:CreateGradient(90, nil, NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 1),
                    NumberSequenceKeypoint.new(1, 0)
                }))

                Items.PaletteDragger = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items.Palette.Instance,
                    Size = UDim2.new(0, 10, 0, 10),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BorderSizePixel = 0,
                    AnchorPoint = Vector2.new(0.5, 0.5)
                })

                Items.PaletteDragger:CreateCorner(5)
                Items.PaletteDragger:CreateStroke(Library.Theme.Border, 1)

                Items.HexInput = Library:Create("TextBox", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items.ColorpickerWindow.Instance,
                    Position = UDim2.new(0, 10, 0, 180),
                    Size = UDim2.new(1, -20, 0, 20),
                    Text = "#FFFFFF",
                    TextColor3 = Library.Theme.Text,
                    BackgroundColor3 = Library.Theme.Element,
                    BorderSizePixel = 0,
                    ClearTextOnFocus = false,
                    PlaceholderText = "#FFFFFF",
                    PlaceholderColor3 = Library.Theme.TextDis
                })

                Items.HexInput:AddToTheme({
                    TextColor3 = "Text",
                    BackgroundColor3 = "Element",
                    PlaceholderColor3 = "TextDis"
                })
                Items.HexInput:CreateCorner(5)
                Items.HexInput:CreateStroke(Library.Theme.Border, 1)

                Colorpicker.Items = Items
            end

            function Colorpicker:SetVisibility(Bool)
                Items.ColorpickerButton.Instance.Visible = Bool
            end

            function Colorpicker:Update(IsFromAlpha)
                local Hue, Saturation, Value = Colorpicker.Hue, Colorpicker.Saturation, Colorpicker.Value
                Colorpicker.Color = Color3.fromHSV(Hue, Saturation, Value)
                Colorpicker.HexValue = Colorpicker.Color:ToHex()

                Items.ColorpickerButton:Tween({BackgroundColor3 = Colorpicker.Color})
                Items.Palette:Tween({BackgroundColor3 = Color3.fromHSV(Hue, 1, 1)})

                Flags[Colorpicker.Flag] = {
                    Alpha = Colorpicker.Alpha,
                    Color = Colorpicker.Color,
                    HexValue = Colorpicker.HexValue,
                    Flag = Colorpicker.Flag,
                    Transparency = 1 - Colorpicker.Alpha
                }

                Items.CurrentColor:Tween({BackgroundColor3 = Colorpicker.Color})
                Items.HexInput.Instance.Text = "#" .. Colorpicker.HexValue

                if not IsFromAlpha then
                    Items.Alpha:Tween({BackgroundColor3 = Colorpicker.Color})
                end

                if Data.Callback then
                    Library:SafeCall(Data.Callback, Colorpicker.Color, Colorpicker.Alpha)
                end
            end

            local Debounce = false
            local ColorpickerWindow = Items.ColorpickerWindow.Instance
            local ColorpickerButton = Items.ColorpickerButton.Instance
            local IsSettings = Data.Section and Data.Section.IsSettings

            function Colorpicker:SetOpen(Bool)
                if Debounce then
                    return
                end

                Colorpicker.IsOpen = Bool
                Debounce = true

                if Colorpicker.IsOpen then
                    ColorpickerWindow.Position = Library:PopupPosition(ColorpickerButton, ColorpickerWindow, 0)
                    ColorpickerWindow.Visible = true

                    Items.ColorpickerWindow:Tween({
                        Position = Library:PopupPosition(ColorpickerButton, ColorpickerWindow, 10)
                    })

                    Items.ColorpickerWindow:FadeDescendants(true, function()
                        Debounce = false
                    end)

                    for Index, Value in Library.OpenFrames do
                        if Value ~= IsSettings then
                            Value:SetOpen(false)
                        end
                    end

                    Library.OpenFrames[Colorpicker] = Colorpicker
                else
                    Items.ColorpickerWindow:Tween({
                        Position = Library:PopupPosition(ColorpickerButton, ColorpickerWindow, -10)
                    })

                    Items.ColorpickerWindow:FadeDescendants(false, function()
                        Debounce = false
                    end)

                    if Library.OpenFrames[Colorpicker] then
                        Library.OpenFrames[Colorpicker] = nil
                    end
                end

                local Descendants = ColorpickerWindow:GetDescendants()
                table.insert(Descendants, ColorpickerWindow)

                for Index, Value in Descendants do
                    if Value.ClassName:find("UI") then
                        continue
                    end

                    if IsSettings then
                        Value.ZIndex = Colorpicker.IsOpen and Library.ZIndexOrder.ColorpickerWindow + 4 or 1
                    else
                        Value.ZIndex = Colorpicker.IsOpen and Library.ZIndexOrder.ColorpickerWindow or 1
                    end
                end
            end

            Items.ColorpickerWindow:VisibleCheck()

            local SlidingPalette = false
            local PaletteChanged

            function Colorpicker:SlidePalette(Input)
                if not Input or not SlidingPalette then
                    return
                end

                local Palette = Items.Palette.Instance
                local X = (Input.Position.X - Palette.AbsolutePosition.X) / Palette.AbsoluteSize.X
                local Y = (Input.Position.Y - Palette.AbsolutePosition.Y) / Palette.AbsoluteSize.Y

                Colorpicker.Saturation = Library:Clamp(X, 0, 1)
                Colorpicker.Value = Library:Clamp(1 - Y, 0, 1)

                Items.PaletteDragger.Instance.Position = UDim2.new(X, 0, Y, 0)
                Colorpicker:Update()
            end

            local SlidingHue = false
            local HueChanged

            function Colorpicker:SlideHue(Input)
                if not Input or not SlidingHue then
                    return
                end

                local HueBar = Items.Hue.Instance
                local Y = (Input.Position.Y - HueBar.AbsolutePosition.Y) / HueBar.AbsoluteSize.Y

                Colorpicker.Hue = Library:Clamp(Y, 0, 1)

                Items.HueDragger.Instance.Position = UDim2.new(0, 0, Y, 0)
                Colorpicker:Update()
            end

            local SlidingAlpha = false
            local AlphaChanged

            function Colorpicker:SlideAlpha(Input)
                if not Input or not SlidingAlpha then
                    return
                end

                local AlphaBar = Items.Alpha.Instance
                local Y = (Input.Position.Y - AlphaBar.AbsolutePosition.Y) / AlphaBar.AbsoluteSize.Y

                Colorpicker.Alpha = Library:Clamp(1 - Y, 0, 1)

                Items.AlphaDragger.Instance.Position = UDim2.new(0, 0, Y, 0)
                Colorpicker:Update(true)
            end

            function Colorpicker:Set(Color, Alpha)
                if type(Color) == "string" then
                    Color = Library:HexToRGB(Color)
                elseif type(Color) == "table" and not Color.__type then
                    Color = Color3.fromRGB(Color[1], Color[2], Color[3])
                elseif type(Color) == "table" and Color.__type == "Color3" then
                    Color = Color
                end

                local H, S, V = Color:ToHSV()
                Colorpicker.Hue = H
                Colorpicker.Saturation = S
                Colorpicker.Value = V
                Colorpicker.Alpha = Alpha or 0

                Items.PaletteDragger.Instance.Position = UDim2.new(S, 0, 1 - V, 0)
                Items.HueDragger.Instance.Position = UDim2.new(0, 0, H, 0)
                Items.AlphaDragger.Instance.Position = UDim2.new(0, 0, 1 - (Alpha or 0), 0)

                Colorpicker:Update()
            end

            Items.ColorpickerButton:Connect("MouseButton1Down", function()
                Colorpicker:SetOpen(not Colorpicker.IsOpen)
            end)

            Items.Palette:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    SlidingPalette = true
                    Colorpicker:SlidePalette(Input)

                    if PaletteChanged then
                        return
                    end

                    PaletteChanged = Input.Changed:Connect(function()
                        if Input.UserInputState == Enum.UserInputState.End then
                            SlidingPalette = false
                            PaletteChanged:Disconnect()
                            PaletteChanged = nil
                        end
                    end)
                end
            end)

            Items.Hue:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    SlidingHue = true
                    Colorpicker:SlideHue(Input)

                    if HueChanged then
                        return
                    end

                    HueChanged = Input.Changed:Connect(function()
                        if Input.UserInputState == Enum.UserInputState.End then
                            SlidingHue = false
                            HueChanged:Disconnect()
                            HueChanged = nil
                        end
                    end)
                end
            end)

            Items.Alpha:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    SlidingAlpha = true
                    Colorpicker:SlideAlpha(Input)

                    if AlphaChanged then
                        return
                    end

                    AlphaChanged = Input.Changed:Connect(function()
                        if Input.UserInputState == Enum.UserInputState.End then
                            SlidingAlpha = false
                            AlphaChanged:Disconnect()
                            AlphaChanged = nil
                        end
                    end)
                end
            end)

            Library:Connect(UserInputService.InputChanged, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
                    if SlidingPalette then
                        Colorpicker:SlidePalette(Input)
                    end

                    if SlidingHue then
                        Colorpicker:SlideHue(Input)
                    end

                    if SlidingAlpha then
                        Colorpicker:SlideAlpha(Input)
                    end
                end
            end)

            Items.HexInput:Connect("FocusLost", function(EnterPressed)
                if EnterPressed then
                    local Hex = Items.HexInput.Instance.Text
                    if Hex:match("^#?%x%x%x%x%x%x$") then
                        local Color = Library:HexToRGB(Hex)
                        Colorpicker:Set(Color, Colorpicker.Alpha)
                    end
                end
            end)

            Library:Connect(UserInputService.InputBegan, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    if Colorpicker.IsOpen then
                        if Items.ColorpickerWindow:IsMouseOverFrame() then
                            return
                        end

                        Colorpicker:SetOpen(false)
                    end
                end
            end)

            if Data.Default then
                Colorpicker:Set(Data.Default, Data.Alpha or 0)
            end

            SetFlags[Colorpicker.Flag] = function(Value, Alpha)
                Colorpicker:Set(Value, Alpha)
            end

            return Colorpicker, Items
        end

        Library.CreateKeybind = function(Self, Data)
            local Keybind = {
                Flag = Data.Flag,
                IsOpen = false,
                Key = "",
                Mode = "",
                Value = "",
                Toggled = false,
                Picking = false,
                Items = {}
            }

            local Items = {}
            do
                Items.KeyButtonOutline = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Data.Parent.Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Size = UDim2.new(0, 0, 0, 14),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundColor3 = Library.Theme.Border
                })

                Items.KeyButtonOutline:AddToTheme({BackgroundColor3 = "Border"})

                Library:Create("UIPadding", {
                    Parent = Items.KeyButtonOutline.Instance,
                    PaddingTop = UDim.new(0, 1),
                    PaddingBottom = UDim.new(0, 1),
                    PaddingRight = UDim.new(0, 1),
                    PaddingLeft = UDim.new(0, 1)
                })

                Items.KeyButton = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items.KeyButtonOutline.Instance,
                    TextColor3 = Library.Theme.Text,
                    Text = "none",
                    AutoButtonColor = false,
                    Size = UDim2.new(1, 0, 1, 0),
                    BorderSizePixel = 0,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundColor3 = Library.Theme.Element2
                })

                Items.KeyButton:AddToTheme({
                    BackgroundColor3 = "Element2",
                    TextColor3 = "Text"
                })

                Items.KeyButton:CreateGradient(90, {
                    Color3.fromRGB(255, 255, 255),
                    Color3.fromRGB(200, 200, 200)
                })

                Library:Create("UIPadding", {
                    Parent = Items.KeyButton.Instance,
                    PaddingBottom = UDim.new(0, 2),
                    PaddingRight = UDim.new(0, 6),
                    PaddingLeft = UDim.new(0, 6)
                })

                Items.KeybindWindow = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Library.Holder.Instance,
                    Visible = false,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Size = UDim2.new(0, 220, 0, 50),
                    Position = UDim2.new(0.5749104022979736, 0, 0.8196721076965332, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundColor3 = Library.Theme.Background,
                    ZIndex = Library.ZIndexOrder.KeybindWindow
                })

                Items.KeybindWindow:AddToTheme({BackgroundColor3 = "Background"})
                Items.KeybindWindow:CreateCorner(10)
                Items.KeybindWindow:CreateStroke(Library.Theme.Border, 1)
                Items.KeybindWindow:CreateStroke(Library.Theme.Outline, 1)
                Items.KeybindWindow:CreateShadow(15, 0.5)

                Library:Create("UIPadding", {
                    Parent = Items.KeybindWindow.Instance,
                    PaddingTop = UDim.new(0, 10),
                    PaddingBottom = UDim.new(0, 10),
                    PaddingRight = UDim.new(0, 10),
                    PaddingLeft = UDim.new(0, 10)
                })

                Library:Create("UIListLayout", {
                    Parent = Items.KeybindWindow.Instance,
                    Padding = UDim.new(0, 8),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Keybind.Items = Items
            end

            Items.KeyButton:OnHover(function()
                Items.KeyButton:Tween({BackgroundColor3 = Library.Theme.HoveredElement})
            end, function()
                Items.KeyButton:Tween({BackgroundColor3 = Library.Theme.Element2})
            end)

            local Debounce = false
            local KeybindWindow = Items.KeybindWindow.Instance
            local KeyButton = Items.KeyButton.Instance
            local IsSettings = Data.Section and Data.Section.IsSettings

            function Keybind:SetOpen(Bool)
                if Debounce then
                    return
                end

                Keybind.IsOpen = Bool
                Debounce = true

                if Keybind.IsOpen then
                    KeybindWindow.Visible = true
                    KeybindWindow.Position = Library:PopupPosition(KeyButton, KeybindWindow, 0)

                    Items.KeybindWindow:Tween({
                        Position = Library:PopupPosition(KeyButton, KeybindWindow, 10)
                    })

                    Items.KeybindWindow:FadeDescendants(true, function()
                        Debounce = false
                    end)

                    for Index, Value in Library.OpenFrames do
                        if Value ~= IsSettings then
                            Value:SetOpen(false)
                        end
                    end

                    Library.OpenFrames[Keybind] = Keybind
                else
                    Items.KeybindWindow:Tween({
                        Position = Library:PopupPosition(KeyButton, KeybindWindow, -10)
                    })

                    Items.KeybindWindow:FadeDescendants(false, function()
                        Debounce = false
                    end)

                    if Library.OpenFrames[Keybind] then
                        Library.OpenFrames[Keybind] = nil
                    end
                end

                local Descendants = KeybindWindow:GetDescendants()
                table.insert(Descendants, KeybindWindow)

                for Index, Value in Descendants do
                    if Value.ClassName:find("UI") then
                        continue
                    end

                    if IsSettings then
                        Value.ZIndex = Keybind.IsOpen and Library.ZIndexOrder.KeybindWindow + 4 or 1
                    else
                        Value.ZIndex = Keybind.IsOpen and Library.ZIndexOrder.KeybindWindow + 1 or 1
                    end
                end
            end

            Items.KeybindWindow:VisibleCheck()

            function Keybind:SetMode()
                Flags[Keybind.Flag] = {
                    Mode = Keybind.Mode,
                    Key = Keybind.Key,
                    Toggled = Keybind.Toggled
                }

                if Data.Callback then
                    Library:SafeCall(Data.Callback, Keybind.Toggled)
                end
            end

            local KeybindObject

            if Library.KeyList and Data.Name ~= "Menu Keybind" then
                KeybindObject = Library.KeyList:Add("", "", "")
            end

            local Update = function()
                if KeybindObject then
                    KeybindObject:Set(Data.Name, Keybind.Mode, Keybind.Value)
                    KeybindObject:SetStatus(Keybind.Toggled)
                end
            end

            local ModeDropdown = Library:Dropdown({
                Name = "Mode",
                Flag = Keybind.Flag .. "ModeDropdown",
                Parent = Items.KeybindWindow,
                Items = {"Toggle", "Hold", "Always"},
                Default = "Toggle",
                Callback = function(Value)
                    Keybind.Mode = Value
                    Keybind:SetMode()

                    if Value == "Always" then
                        Keybind:Press(true)
                    end

                    Update()
                end
            })

            local ShowInKeybindsList = Library:Toggle({
                Name = "Show in keybinds list",
                Flag = Keybind.Flag .. "ShowInKeybindsList",
                Parent = Items.KeybindWindow,
                Default = true,
                Callback = function(Value)
                    if KeybindObject then
                        KeybindObject:SetVis(Value)
                        Update()
                    end
                end
            })

            function Keybind:Press(Bool)
                if Keybind.Mode == "Toggle" then
                    Keybind.Toggled = not Keybind.Toggled
                elseif Keybind.Mode == "Hold" then
                    Keybind.Toggled = Bool
                elseif Keybind.Mode == "Always" then
                    Keybind.Toggled = true
                end

                Flags[Keybind.Flag] = {
                    Mode = Keybind.Mode,
                    Key = Keybind.Key,
                    Toggled = Keybind.Toggled
                }

                if Data.Callback then
                    Library:SafeCall(Data.Callback, Keybind.Toggled)
                end

                Update()
            end

            function Keybind:Set(Key)
                if string.find(tostring(Key), "Enum") then
                    Keybind.Key = tostring(Key)
                    Key = Key.Name == "Backspace" and "none" or Key.Name

                    local KeyString = Keys[Keybind.Key] or string.gsub(Key, "Enum.", "") or "none"
                    local TextToDisplay = string.gsub(string.gsub(KeyString, "KeyCode.", ""), "UserInputType.", "") or "none"

                    Keybind.Value = TextToDisplay
                    Items.KeyButton.Instance.Text = TextToDisplay:lower()

                    Flags[Keybind.Flag] = {
                        Mode = Keybind.Mode,
                        Key = Keybind.Key,
                        Toggled = Keybind.Toggled
                    }

                    if Data.Callback then
                        Library:SafeCall(Data.Callback, Keybind.Toggled)
                    end

                    Update()
                elseif type(Key) == "table" then
                    local RealKey = Key.Key == "Backspace" and "none" or Key.Key
                    Keybind.Key = tostring(Key.Key)

                    if Key.Mode then
                        Keybind.Mode = Key.Mode
                        Keybind:SetMode()
                    else
                        Keybind.Mode = "Toggle"
                        Keybind:SetMode()
                    end

                    local KeyString = Keys[Keybind.Key] or string.gsub(tostring(RealKey), "Enum.", "") or RealKey
                    local TextToDisplay = string.gsub(string.gsub(KeyString, "KeyCode.", ""), "UserInputType.", "") or "none"

                    Keybind.Value = TextToDisplay
                    Items.KeyButton.Instance.Text = TextToDisplay:lower()

                    if Data.Callback then
                        Library:SafeCall(Data.Callback, Keybind.Toggled)
                    end

                    Update()
                elseif table.find({"Toggle", "Hold", "Always"}, Key) then
                    Keybind.Mode = Key
                    Keybind:SetMode()

                    if Data.Callback then
                        Library:SafeCall(Data.Callback, Keybind.Toggled)
                    end

                    Update()
                end

                Keybind.Picking = false
            end

            Items.KeyButton:Connect("MouseButton1Click", function()
                Keybind.Picking = true
                Items.KeyButton.Instance.Text = ". . ."

                local InputBegan
                InputBegan = UserInputService.InputBegan:Connect(function(Input)
                    if Input.UserInputType == Enum.UserInputType.Keyboard then
                        Keybind:Set(Input.KeyCode)
                    else
                        Keybind:Set(Input.UserInputType)
                    end

                    InputBegan:Disconnect()
                    InputBegan = nil
                end)
            end)

            Library:Connect(UserInputService.InputBegan, function(Input, GPE)
                if Keybind.Value == "none" then
                    return
                end

                if not GPE then
                    if tostring(Input.KeyCode) == Keybind.Key then
                        if Keybind.Mode == "Toggle" then
                            Keybind:Press()
                        elseif Keybind.Mode == "Hold" then
                            Keybind:Press(true)
                        elseif Keybind.Mode == "Always" then
                            Keybind:Press(true)
                        end
                    elseif tostring(Input.UserInputType) == Keybind.Key then
                        if Keybind.Mode == "Toggle" then
                            Keybind:Press()
                        elseif Keybind.Mode == "Hold" then
                            Keybind:Press(true)
                        elseif Keybind.Mode == "Always" then
                            Keybind:Press(true)
                        end
                    end
                end

                if Input.UserInputType == Enum.UserInputType.MouseButton1 and Keybind.IsOpen then
                    if not Items.KeybindWindow:IsMouseOverFrame() and not ModeDropdown.Items.OptionHolder:IsMouseOverFrame() then
                        Keybind:SetOpen(false)
                    end
                end
            end)

            Library:Connect(UserInputService.InputEnded, function(Input, GPE)
                if GPE then
                    return
                end

                if Keybind.Value == "None" then
                    return
                end

                if tostring(Input.KeyCode) == Keybind.Key then
                    if Keybind.Mode == "Hold" then
                        Keybind:Press(false)
                    elseif Keybind.Mode == "Always" then
                        Keybind:Press(true)
                    end
                elseif tostring(Input.UserInputType) == Keybind.Key then
                    if Keybind.Mode == "Hold" then
                        Keybind:Press(false)
                    elseif Keybind.Mode == "Always" then
                        Keybind:Press(true)
                    end
                end
            end)

            Items.KeyButton:Connect("MouseButton2Down", function()
                Keybind:SetOpen(not Keybind.IsOpen)
            end)

            if Data.Default then
                Keybind:Set({
                    Mode = Data.Mode or "Toggle",
                    Key = Data.Default,
                })
            end

            SetFlags[Keybind.Flag] = function(Value)
                Keybind:Set(Value)
            end

            return Keybind, Items
        end

        Library.Watermark = function(Self, Params)
            Params = Params or {}

            local Watermark = {
                Name = Params.Name or "Watermark",
                SubText = Params.SubText or "v2.0",
                Items = {}
            }

            local Items = {}
            do
                Items.Watermark = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Library.Holder.Instance,
                    AnchorPoint = Vector2.new(0, 0),
                    Position = UDim2.new(0, 10, 0, GuiInset + 10),
                    Size = UDim2.new(0, 0, 0, 40),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundColor3 = Library.Theme.WatermarkBG,
                    ZIndex = 150
                })

                Items.Watermark:AddToTheme({BackgroundColor3 = "WatermarkBG"})
                Items.Watermark:CreateCorner(8)
                Items.Watermark:CreateStroke(Library.Theme.Accent, 1, 0.35)
                Items.Watermark:CreateGlow(10, 0.88)
                Items.Watermark:CreateShadow(12, 0.5)
                Items.Watermark:MakeDraggable()

                Library:Create("UIPadding", {
                    Parent = Items.Watermark.Instance,
                    PaddingTop = UDim.new(0, 8),
                    PaddingBottom = UDim.new(0, 8),
                    PaddingRight = UDim.new(0, 12),
                    PaddingLeft = UDim.new(0, 12)
                })

                Items.AccentBar = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items.Watermark.Instance,
                    Size = UDim2.new(0, 2, 0.6, 0),
                    Position = UDim2.new(0, 4, 0.2, 0),
                    BackgroundColor3 = Library.Theme.Accent,
                    BorderSizePixel = 0
                })

                Items.AccentBar:AddToTheme({BackgroundColor3 = "Accent"})

                Items.Title = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.FontBold,
                    TextSize = Library.FontSize + 1,
                    Parent = Items.Watermark.Instance,
                    TextColor3 = Library.Theme.Text,
                    Text = Watermark.Name,
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY,
                    TextXAlignment = Enum.TextXAlignment.Left
                })

                Items.Title:AddToTheme({TextColor3 = "Text"})

                Items.SubTitle = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize - 1,
                    Parent = Items.Watermark.Instance,
                    TextColor3 = Library.Theme.TextSec,
                    Text = Watermark.SubText,
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Position = UDim2.new(0, 0, 0, 18)
                })

                Items.SubTitle:AddToTheme({TextColor3 = "TextSec"})

                Items.FPS = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.FontSemi,
                    TextSize = Library.FontSize - 1,
                    Parent = Items.Watermark.Instance,
                    TextColor3 = Library.Theme.Accent,
                    Text = "60 FPS",
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY,
                    TextXAlignment = Enum.TextXAlignment.Right,
                    AnchorPoint = Vector2.new(1, 0),
                    Position = UDim2.new(1, 0, 0, 2)
                })

                Items.FPS:AddToTheme({TextColor3 = "Accent"})

                Items.Time = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize - 1,
                    Parent = Items.Watermark.Instance,
                    TextColor3 = Library.Theme.TextSec,
                    Text = os.date("%H:%M"),
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY,
                    TextXAlignment = Enum.TextXAlignment.Right,
                    AnchorPoint = Vector2.new(1, 0),
                    Position = UDim2.new(1, 0, 0, 20)
                })

                Items.Time:AddToTheme({TextColor3 = "TextSec"})

                Watermark.Items = Items
            end

            local Frames = 0
            local LastTime = tick()

            Library:Connect(RunService.RenderStepped, function()
                Frames = Frames + 1
                local Now = tick()
                if Now - LastTime >= 1 then
                    Items.FPS.Instance.Text = Frames .. " FPS"
                    Frames = 0
                    LastTime = Now
                end
                Items.Time.Instance.Text = os.date("%H:%M")
            end)

            function Watermark:SetVisibility(Bool)
                Items.Watermark.Instance.Visible = Bool
            end

            function Watermark:SetText(Text)
                Items.Title.Instance.Text = tostring(Text)
            end

            function Watermark:SetSubText(Text)
                Items.SubTitle.Instance.Text = tostring(Text)
            end

            function Watermark:Add(Text)
                local Seperator = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items.Watermark.Instance,
                    Size = UDim2.new(0, 1, 0.6, 0),
                    Position = UDim2.new(0, 0, 0.2, 0),
                    BackgroundColor3 = Library.Theme.Divider,
                    BorderSizePixel = 0
                })

                Seperator:AddToTheme({BackgroundColor3 = "Divider"})

                local NewItem = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize - 1,
                    Parent = Items.Watermark.Instance,
                    TextColor3 = Library.Theme.Text,
                    Text = Text,
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY,
                    TextXAlignment = Enum.TextXAlignment.Left
                })

                NewItem:AddToTheme({TextColor3 = "Text"})

                function NewItem:SetText(Text)
                    NewItem.Instance.Text = tostring(Text)
                end

                function NewItem:SetVisibility(Bool)
                    NewItem.Instance.Visible = Bool
                end

                return NewItem
            end

            Self.Watermark = Watermark
            return setmetatable(Watermark, Library)
        end

        local KeybindTweenInfo = TweenInfo.new(0.55, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)

        Library.KeybindList = function(Self)
            local KeybindList = {
                Items = {},
                Keys = {}
            }

            local Items = {}
            do
                Items.KeybindList = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Library.Holder.Instance,
                    AnchorPoint = Vector2.new(0, 0.5),
                    Position = UDim2.new(0, 10, 0.5, 0),
                    Size = UDim2.new(0, 34, 0, 53),
                    ClipsDescendants = true,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme.KeyBG,
                    ZIndex = 100
                })

                Items.KeybindList:AddToTheme({BackgroundColor3 = "KeyBG"})
                Items.KeybindList:MakeDraggable()
                Items.KeybindList:CreateCorner(8)
                Items.KeybindList:CreateStroke(Library.Theme.Border, 1)
                Items.KeybindList:CreateShadow(10, 0.5)

                Library:Create("UIPadding", {
                    Parent = Items.KeybindList.Instance,
                    PaddingTop = UDim.new(0, 10),
                    PaddingBottom = UDim.new(0, 12),
                    PaddingRight = UDim.new(0, 10),
                    PaddingLeft = UDim.new(0, 10)
                })

                Items.Liner = Library:Create("Frame", {
                    Parent = Items.KeybindList.Instance,
                    AnchorPoint = Vector2.new(1, 0),
                    Position = UDim2.new(1, 1, 0, 0),
                    Size = UDim2.new(1, 2, 0, 2),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme.Accent
                })

                Items.Liner:AddToTheme({BackgroundColor3 = "Accent"})

                Items.Glow = Library:Create("ImageLabel", {
                    Parent = Items.Liner.Instance,
                    ImageColor3 = Library.Theme.Accent,
                    ScaleType = Enum.ScaleType.Slice,
                    ImageTransparency = 0.8,
                    Size = UDim2.new(1, 25, 1, 25),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Image = "http://www.roblox.com/asset/?id=18245826428",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    BorderSizePixel = 0,
                    SliceCenter = Rect.new(Vector2.new(21, 21), Vector2.new(79, 79))
                })

                Items.Glow:AddToTheme({ImageColor3 = "Accent"})

                Items.Inline = Library:Create("Frame", {
                    Parent = Items.KeybindList.Instance,
                    Size = UDim2.new(0, 8, 0, 25),
                    Position = UDim2.new(0, 0, 0, 6),
                    ClipsDescendants = true,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme.Inline
                })

                Items.Inline:AddToTheme({BackgroundColor3 = "Inline"})
                Items.Inline:CreateStroke(Library.Theme.Outline, 1)
                Items.Inline:CreateStroke(Library.Theme.Border, 1)

                Items.Content = Library:Create("Frame", {
                    Parent = Items.Inline.Instance,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0, 0),
                    Size = UDim2.new(0, 0, 0, 25),
                    BorderSizePixel = 0
                })
            end

            Library.KeyList = KeybindList
            Self.KeybindList = KeybindList

            function KeybindList:SetVisibility(Bool)
                Items.KeybindList.Instance.Visible = Bool
            end

            function KeybindList:UpdateSize()
                local Width = 0
                local Y = 6
                local Count = 0

                for Index, Value in KeybindList.Keys do
                    if Value.Showing then
                        local RowHeight = 14

                        Value.Object.Instance.Visible = true
                        Width = math.max(Width, Value.Object.Instance.TextBounds.X)

                        Value.Object:Tween({
                            Position = UDim2.new(0, 8, 0, Y),
                            Size = UDim2.new(0, Value.Object.Instance.TextBounds.X, 0, RowHeight),
                            TextTransparency = 0
                        }, KeybindTweenInfo)

                        Y = Y + RowHeight + 4
                        Count = Count + 1
                    end
                end

                local TargetHeight = Count > 0 and math.max(25, Y + 5) or 25

                Items.Content.Instance.Size = UDim2.new(0, Width, 0, TargetHeight)
                Items.Inline:Tween({Size = UDim2.new(0, Width + 14, 0, TargetHeight)}, KeybindTweenInfo)
                Items.KeybindList:Tween({Size = UDim2.new(0, Width + 34, 0, TargetHeight + 28)}, KeybindTweenInfo)

                local ActiveKeys = {}

                for Index, Value in KeybindList.Keys do
                    if Value.Showing then
                        table.insert(ActiveKeys, Value.Object.Instance.Text)
                    end
                end

                if #ActiveKeys == 0 then
                    Items.KeybindList.Instance.Visible = false
                else
                    Items.KeybindList.Instance.Visible = true
                end
            end

            function KeybindList:Add(Name, Mode, Key)
                local NewKeyText = Library:Create("TextLabel", {
                    Parent = Items.Content.Instance,
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    TextColor3 = Library.Theme.Text,
                    Text = Name .. " - " .. Mode .. " [" .. Key .. "]",
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    Size = UDim2.new(0, 0, 0, 14),
                    Position = UDim2.new(0, -8, 0, 6),
                    TextTransparency = 1,
                    Visible = false,
                    TextYAlignment = Enum.TextYAlignment.Center,
                    TextXAlignment = Enum.TextXAlignment.Left
                })

                NewKeyText:AddToTheme({TextColor3 = "Text"})

                local CanShow = true

                local NewKey = {
                    Object = NewKeyText,
                    Showing = false
                }

                table.insert(KeybindList.Keys, NewKey)

                function NewKey:SetVis(Bool)
                    CanShow = Bool

                    if not Bool then
                        NewKey:SetStatus(false)
                    end
                end

                function NewKey:Set(Name, Mode, Key)
                    NewKey.Object.Instance.Text = Name .. " - " .. Mode .. " [" .. Key .. "]"
                    KeybindList:UpdateSize()
                end

                function NewKey:SetStatus(Bool)
                    Bool = Bool and CanShow

                    if NewKey.Showing == Bool then
                        return
                    end

                    NewKey.Showing = Bool

                    if Bool then
                        NewKeyText.Instance.Visible = true
                        NewKeyText.Instance.Position = UDim2.new(0, 0, 0, NewKeyText.Instance.Position.Y.Offset)
                        NewKeyText.Instance.TextTransparency = 1

                        KeybindList:UpdateSize()
                    else
                        NewKeyText:Tween({
                            Position = UDim2.new(0, 0, 0, NewKeyText.Instance.Position.Y.Offset),
                            TextTransparency = 1
                        }, KeybindTweenInfo)

                        KeybindList:UpdateSize()

                        task.delay(KeybindTweenInfo.Time, function()
                            if not NewKey.Showing then
                                NewKeyText.Instance.Visible = false
                            end
                        end)
                    end
                end

                return NewKey
            end

            KeybindList:UpdateSize()
            return setmetatable(KeybindList, Library)
        end

        local NotifTweenInfo = TweenInfo.new(Library.NotifAnimation.Time, Enum.EasingStyle[Library.NotifAnimation.Style], Enum.EasingDirection[Library.NotifAnimation.Direction])

        Library.Notification = function(Self, Name, Duration, Color, Type)
            Duration = Duration or 5
            Color = Color or Library.Theme.Accent
            Type = Type or "Info"

            local Notification = {
                Duration = Duration,
                Removing = false,
                Items = {}
            }

            local Padding = 8
            local Spacing = 8

            local function UpdatePositions()
                local Y = GuiInset + Padding + 5

                for Index, Value in Library.Notifications do
                    if Value and Value.Items and Value.Items.Notification then
                        local Height = Value.Items.Notification.Instance.AbsoluteSize.Y
                        Value.Items.Notification:Tween({Position = UDim2.new(0, Padding, 0, Y)}, NotifTweenInfo)
                        Y = Y + Height + Spacing
                    end
                end
            end

            local Items = {}
            do
                Items.Notification = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Library.NotifHolder.Instance,
                    Size = UDim2.new(0, 0, 0, 25),
                    AnchorPoint = Vector2.new(0, 0),
                    Position = UDim2.new(0, -260, 0, GuiInset + Padding + 5),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundColor3 = Library.Theme.NotificationBG,
                    ZIndex = Library.ZIndexOrder.Notification
                })

                Items.Notification:AddToTheme({BackgroundColor3 = "NotificationBG"})
                Items.Notification:CreateCorner(8)
                Items.Notification:CreateStroke(Color, 1, 0.4)
                Items.Notification:CreateShadow(10, 0.5)

                Items.AccentBar = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items.Notification.Instance,
                    Size = UDim2.new(0, 3, 1, 0),
                    BackgroundColor3 = Color,
                    BorderSizePixel = 0
                })

                Library:Create("UIPadding", {
                    Parent = Items.Notification.Instance,
                    PaddingRight = UDim.new(0, 10),
                    PaddingLeft = UDim.new(0, 10)
                })

                Items.Text = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items.Notification.Instance,
                    TextColor3 = Library.Theme.Text,
                    Text = Name,
                    AnchorPoint = Vector2.new(0, 0.5),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 5, 0.5, -1),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY
                })

                Items.Text:AddToTheme({TextColor3 = "Text"})

                Items.DurationBar = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items.Notification.Instance,
                    Position = UDim2.new(0, 0, 1, -3),
                    Size = UDim2.new(1, 0, 0, 2),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color
                })

                Notification.Items = Items
            end

            local FadeNotification = function(Transparency)
                Items.Notification:Tween({BackgroundTransparency = Transparency}, NotifTweenInfo)

                for _, Value in Items.Notification.Instance:GetDescendants() do
                    if Value:IsA("TextLabel") then
                        Library:Tween({TextTransparency = Transparency}, NotifTweenInfo, Value)
                    elseif Value:IsA("Frame") then
                        Library:Tween({BackgroundTransparency = Transparency}, NotifTweenInfo, Value)
                    elseif Value:IsA("UIStroke") then
                        Library:Tween({Transparency = Transparency}, NotifTweenInfo, Value)
                    end
                end
            end

            table.insert(Library.Notifications, 1, Notification)

            task.wait()

            local Width = Items.Notification.Instance.AbsoluteSize.X
            local Height = Items.Notification.Instance.AbsoluteSize.Y

            Items.Notification.Instance.Size = UDim2.new(0, Width, 0, Height)
            Items.Notification.Instance.AutomaticSize = Enum.AutomaticSize.None
            Items.Notification.Instance.BackgroundTransparency = 1

            for Index, Value in Items.Notification.Instance:GetDescendants() do
                if Value:IsA("TextLabel") then
                    Value.TextTransparency = 1
                elseif Value:IsA("Frame") then
                    Value.BackgroundTransparency = 1
                elseif Value:IsA("UIStroke") then
                    Value.Transparency = 1
                end
            end

            UpdatePositions()
            FadeNotification(0)

            Items.DurationBar:Tween({Size = UDim2.new(0, 0, 0, 2)}, TweenInfo.new(Duration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out))

            task.spawn(function()
                local TickTime = tick()

                while tick() - TickTime < Duration and not Notification.Removing do
                    task.wait(0.05)
                end

                if Notification.Removing then
                    return
                end

                Notification.Removing = true

                if not Library then
                    return
                end

                for Index, Value in Library.Notifications do
                    if Value == Notification then
                        table.remove(Library.Notifications, Index)
                        break
                    end
                end

                Items.Notification:Tween({Position = UDim2.new(0, -(Width + Padding + 20), 0, Items.Notification.Instance.Position.Y.Offset)}, NotifTweenInfo)
                FadeNotification(1)

                task.delay(NotifTweenInfo.Time, function()
                    Items.Notification.Instance:Destroy()
                    UpdatePositions()
                end)
            end)

            return Notification
        end

        Library.Window = function(Self, Params)
            Params = Params or {}

            local Window = {
                Name = Params.Name or "Window",
                SubTitle = Params.SubTitle or "Library",
                IsOpen = true,
                Minimized = false,
                Locked = false,
                Pages = {},
                Items = {},
                Tabs = {},
                ActiveTab = nil
            }

            local IsMobile = UserInputService.TouchEnabled and not UserInputService.MouseEnabled
            local WinWidth = IsMobile and (workspace.CurrentCamera.ViewportSize.X - 16) or 720
            local WinHeight = IsMobile and (workspace.CurrentCamera.ViewportSize.Y - 80) or 480
            local WinX = IsMobile and 8 or math.floor((workspace.CurrentCamera.ViewportSize.X - WinWidth) / 2)
            local WinY = IsMobile and 38 or math.floor((workspace.CurrentCamera.ViewportSize.Y - WinHeight) / 2)

            local TabWidth = Params.TabWidth or 155

            local Items = {}
            do
                if IsMobile then
                    Library:Create("UIScale", {
                        Parent = Library.Holder.Instance,
                        Scale = 0.7
                    })
                end

                Items.Window = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Library.Holder.Instance,
                    Position = UDim2.new(0, WinX, 0, WinY),
                    Size = UDim2.new(0, WinWidth, 0, WinHeight),
                    BackgroundColor3 = Library.Theme.Background,
                    BorderSizePixel = 0,
                    ClipsDescendants = false,
                    ZIndex = 10
                })

                Items.Window:AddToTheme({BackgroundColor3 = "Background"})
                Items.Window:CreateCorner(12)
                Items.Window:CreateShadow(18, 0.46)
                Items.Window:CreateGlow(12, 0.92)
                Items.Window:CreateStroke(Library.Theme.Border, 1)
                Items.Window:MakeDraggable()
                Items.Window:MakeResizeable(Vector2.new(400, 300))

                Items.TitleBar = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items.Window.Instance,
                    Size = UDim2.new(1, 0, 0, 46),
                    BackgroundColor3 = Library.Theme.Inline,
                    BorderSizePixel = 0,
                    ZIndex = 11
                })

                Items.TitleBar:AddToTheme({BackgroundColor3 = "Inline"})
                Items.TitleBar:CreateCorner(12)

                Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items.TitleBar.Instance,
                    Size = UDim2.new(1, 0, 0, 10),
                    Position = UDim2.new(0, 0, 1, -10),
                    BackgroundColor3 = Library.Theme.Inline,
                    BorderSizePixel = 0,
                    ZIndex = 11
                })

                Items.AccentLine = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items.TitleBar.Instance,
                    Size = UDim2.new(1, 0, 0, 2),
                    Position = UDim2.new(0, 0, 1, -2),
                    BackgroundColor3 = Library.Theme.Accent,
                    BorderSizePixel = 0,
                    ZIndex = 12
                })

                Items.AccentLine:AddToTheme({BackgroundColor3 = "Accent"})

                Items.Logo = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.FontBold,
                    TextSize = 20,
                    Parent = Items.TitleBar.Instance,
                    TextColor3 = Library.Theme.Accent,
                    Text = Window.Name:sub(1, 1),
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    Position = UDim2.new(0, 12, 0.5, -12),
                    Size = UDim2.new(0, 28, 0, 28),
                    ZIndex = 12
                })

                Items.Logo:AddToTheme({TextColor3 = "Accent"})

                Items.Title = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.FontBold,
                    TextSize = 15,
                    Parent = Items.TitleBar.Instance,
                    TextColor3 = Library.Theme.Text,
                    Text = Window.Name:sub(2),
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    Position = UDim2.new(0, 40, 0.5, -10),
                    Size = UDim2.new(0, 0, 0, 20),
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 12
                })

                Items.Title:AddToTheme({TextColor3 = "Text"})

                Items.SubTitle = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = 12,
                    Parent = Items.TitleBar.Instance,
                    TextColor3 = Library.Theme.TextSec,
                    Text = Window.SubTitle,
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    Position = UDim2.new(0.5, -80, 0, 0),
                    Size = UDim2.new(0, 160, 1, 0),
                    TextXAlignment = Enum.TextXAlignment.Center,
                    ZIndex = 12
                })

                Items.SubTitle:AddToTheme({TextColor3 = "TextSec"})

                Items.Controls = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items.TitleBar.Instance,
                    Size = UDim2.new(0, 72, 0, 28),
                    Position = UDim2.new(1, -78, 0.5, -14),
                    BackgroundTransparency = 1,
                    ZIndex = 12
                })

                local function MakeControl(X, Text, Color, Action)
                    local Button = Library:Create("TextButton", {
                        Name = "\0",
                        FontFace = Library.FontBold,
                        TextSize = 12,
                        Parent = Items.Controls.Instance,
                        TextColor3 = Color,
                        Text = Text,
                        AutoButtonColor = false,
                        Size = UDim2.new(0, 22, 0, 22),
                        Position = UDim2.new(0, X, 0.5, -11),
                        BackgroundColor3 = Library.Theme.Element,
                        BorderSizePixel = 0,
                        ZIndex = 13
                    })

                    Button:AddToTheme({BackgroundColor3 = "Element"})
                    Button:CreateCorner(5)

                    Button:Connect("MouseButton1Click", Action)

                    Button:OnHover(function()
                        Button:Tween({BackgroundColor3 = Color, TextColor3 = Color3.fromRGB(255, 255, 255)})
                    end, function()
                        Button:Tween({BackgroundColor3 = Library.Theme.Element, TextColor3 = Color})
                    end)

                    return Button
                end

                Items.MinimizeBtn = MakeControl(0, "−", Library.Theme.TextSec, function()
                    Window:Minimize()
                end)

                Items.LockBtn = MakeControl(24, "🔒", Library.Theme.TextSec, function()
                    Window:ToggleLock()
                end)

                Items.CloseBtn = MakeControl(48, "×", Color3.fromRGB(210, 70, 70), function()
                    Window:SetOpen(false)
                end)

                Items.Sidebar = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items.Window.Instance,
                    Size = UDim2.new(0, TabWidth, 1, -48),
                    Position = UDim2.new(0, 0, 0, 48),
                    BackgroundColor3 = Library.Theme.Inline,
                    BorderSizePixel = 0,
                    ZIndex = 11
                })

                Items.Sidebar:AddToTheme({BackgroundColor3 = "Inline"})
                Items.Sidebar:CreateCorner(12)

                Items.SidebarDivider = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items.Sidebar.Instance,
                    Size = UDim2.new(0, 1, 1, 0),
                    Position = UDim2.new(1, -1, 0, 0),
                    BackgroundColor3 = Library.Theme.Divider,
                    BorderSizePixel = 0,
                    ZIndex = 11
                })

                Items.SidebarDivider:AddToTheme({BackgroundColor3 = "Divider"})

                Items.SideScroll = Library:Create("ScrollingFrame", {
                    Name = "\0",
                    Parent = Items.Sidebar.Instance,
                    Size = UDim2.new(1, 0, 1, -52),
                    Position = UDim2.new(0, 0, 0, 0),
                    BackgroundTransparency = 1,
                    ScrollBarThickness = 0,
                    ZIndex = 12,
                    CanvasSize = UDim2.new(0, 0, 0, 0)
                })

                Items.SideList = Library:Create("UIListLayout", {
                    Parent = Items.SideScroll.Instance,
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Padding = UDim.new(0, 2)
                })

                Library:Create("UIPadding", {
                    Parent = Items.SideScroll.Instance,
                    PaddingTop = UDim.new(0, 6),
                    PaddingBottom = UDim.new(0, 6),
                    PaddingRight = UDim.new(0, 5),
                    PaddingLeft = UDim.new(0, 5)
                })

                Items.SideList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                    Items.SideScroll.Instance.CanvasSize = UDim2.new(0, 0, 0, Items.SideList.AbsoluteContentSize.Y + 14)
                end)

                Items.UserBar = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items.Sidebar.Instance,
                    Size = UDim2.new(1, 0, 0, 50),
                    Position = UDim2.new(0, 0, 1, -50),
                    BackgroundColor3 = Library.Theme.Background,
                    BorderSizePixel = 0,
                    ZIndex = 12
                })

                Items.UserBar:AddToTheme({BackgroundColor3 = "Background"})

                Items.UserDivider = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items.UserBar.Instance,
                    Size = UDim2.new(1, 0, 0, 1),
                    BackgroundColor3 = Library.Theme.Divider,
                    BorderSizePixel = 0,
                    ZIndex = 12
                })

                Items.UserDivider:AddToTheme({BackgroundColor3 = "Divider"})

                Items.Avatar = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items.UserBar.Instance,
                    Size = UDim2.new(0, 28, 0, 28),
                    Position = UDim2.new(0, 8, 0.5, -14),
                    BackgroundColor3 = Library.Theme.Accent,
                    BorderSizePixel = 0,
                    ZIndex = 13
                })

                Items.Avatar:AddToTheme({BackgroundColor3 = "Accent"})
                Items.Avatar:CreateCorner(14)

                Items.AvatarImage = Library:Create("ImageLabel", {
                    Name = "\0",
                    Parent = Items.Avatar.Instance,
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. LocalPlayer.UserId .. "&width=48&height=48&format=png",
                    ZIndex = 14
                })

                Items.AvatarImage:CreateCorner(14)

                Items.UserName = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.FontSemi,
                    TextSize = 12,
                    Parent = Items.UserBar.Instance,
                    TextColor3 = Library.Theme.Text,
                    Text = LocalPlayer.DisplayName,
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    Position = UDim2.new(0, 42, 0, 9),
                    Size = UDim2.new(1, -44, 0, 15),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 13
                })

                Items.UserName:AddToTheme({TextColor3 = "Text"})

                Items.UserLicense = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = 11,
                    Parent = Items.UserBar.Instance,
                    TextColor3 = Library.Theme.Accent,
                    Text = Params.License or "Lifetime",
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    Position = UDim2.new(0, 42, 0, 26),
                    Size = UDim2.new(1, -44, 0, 13),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 13
                })

                Items.UserLicense:AddToTheme({TextColor3 = "Accent"})

                Items.Content = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items.Window.Instance,
                    Size = UDim2.new(1, -TabWidth - 2, 1, -48),
                    Position = UDim2.new(0, TabWidth + 2, 0, 48),
                    BackgroundTransparency = 1,
                    ClipsDescendants = true,
                    ZIndex = 11
                })

                Window.Items = Items
            end

            local Debounce = false

            function Window:SetOpen(Bool)
                if Debounce then
                    return
                end

                for Index, Value in Window.Pages do
                    if Value.Debounce then
                        return
                    end
                end

                Debounce = true
                Window.IsOpen = Bool

                if Bool then
                    Items.Window.Instance.Visible = true
                    Items.Window:Tween({Size = Window.Minimized and UDim2.new(0, WinWidth, 0, 46) or UDim2.new(0, WinWidth, 0, WinHeight)})
                else
                    Items.Window:Tween({Size = UDim2.new(0, WinWidth, 0, 0)}):Completed:Connect(function()
                        if not Window.IsOpen then
                            Items.Window.Instance.Visible = false
                        end
                        Debounce = false
                    end)
                    return
                end

                Debounce = false
            end

            function Window:Toggle()
                if Window.Locked then
                    return
                end
                Window:SetOpen(not Window.IsOpen)
            end

            function Window:Minimize()
                if Window.Locked then
                    return
                end
                Window.Minimized = not Window.Minimized
                Items.Window:Tween({Size = Window.Minimized and UDim2.new(0, WinWidth, 0, 46) or UDim2.new(0, WinWidth, 0, WinHeight)})
            end

            function Window:ToggleLock()
                Window.Locked = not Window.Locked

                if Window.Locked then
                    Items.Window.Instance.Active = false
                    Items.LockBtn.Instance.Text = "🔓"
                    Items.LockBtn:Tween({BackgroundColor3 = Library.Theme.Accent})
                else
                    Items.Window.Instance.Active = true
                    Items.LockBtn.Instance.Text = "🔒"
                    Items.LockBtn:Tween({BackgroundColor3 = Library.Theme.Element})
                end
            end

            function Window:Center()
                local Viewport = workspace.CurrentCamera.ViewportSize
                local WindowSize = Items.Window.Instance.AbsoluteSize

                Items.Window.Instance.Position = UDim2.new(
                    0, (Viewport.X - WindowSize.X) / 2,
                    0, (Viewport.Y - WindowSize.Y) / 2 + GuiInset
                )
            end

            Library:Connect(UserInputService.InputBegan, function(Input)
                if tostring(Input.KeyCode) == Library.MenuKeybind or tostring(Input.UserInputType) == Library.MenuKeybind then
                    if UserInputService:GetFocusedTextBox() then
                        return
                    end

                    Window:Toggle()
                end
            end)

            if IsMobile then
                local MobileBar = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Library.Holder.Instance,
                    Size = UDim2.new(1, 0, 0, 34),
                    Position = UDim2.new(0, 0, 0, 0),
                    BackgroundColor3 = Library.Theme.Inline,
                    BorderSizePixel = 0,
                    ZIndex = 300
                })

                MobileBar:AddToTheme({BackgroundColor3 = "Inline"})
                MobileBar:CreateStroke(Library.Theme.Border, 1)

                Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.FontBold,
                    TextSize = 13,
                    Parent = MobileBar.Instance,
                    TextColor3 = Library.Theme.Accent,
                    Text = Window.Name .. " · " .. Window.SubTitle,
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    Size = UDim2.new(1, 0, 1, 0),
                    ZIndex = 301
                })

                local ToggleBtn = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.FontBold,
                    TextSize = 11,
                    Parent = MobileBar.Instance,
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    Text = "HIDE",
                    BackgroundColor3 = Library.Theme.Accent2,
                    Size = UDim2.new(0, 56, 0, 26),
                    Position = UDim2.new(1, -62, 0.5, -13),
                    BorderSizePixel = 0,
                    ZIndex = 301
                })

                ToggleBtn:AddToTheme({BackgroundColor3 = "Accent2"})
                ToggleBtn:CreateCorner(5)

                ToggleBtn:Connect("MouseButton1Click", function()
                    Window:Toggle()
                    ToggleBtn.Instance.Text = Window.IsOpen and "HIDE" or "SHOW"
                    ToggleBtn:Tween({BackgroundColor3 = Window.IsOpen and Library.Theme.Accent2 or Library.Theme.Element})
                end)

                Window.Items.Window.Instance.Position = UDim2.new(0, 8, 0, 38)
            end

            Window:Center()

            return setmetatable(Window, Library)
        end

        local PageInfo = TweenInfo.new(Library.TabAnimation.Time, Enum.EasingStyle[Library.TabAnimation.Style], Enum.EasingDirection[Library.TabAnimation.Direction])

        Library.Page = function(Self, Params)
            Params = Params or {}

            local Page = {
                Name = Params.Name or "Page",
                Icon = Params.Icon or "",
                Window = Self,
                ColumnsData = {},
                Items = {},
                Active = false,
                Debounce = false
            }

            local Items = {}
            do
                Items.TabButton = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.FontSemi,
                    TextSize = 13,
                    Parent = Page.Window.Items.SideScroll.Instance,
                    TextColor3 = Library.Theme.TextDis,
                    Text = Page.Name,
                    AutoButtonColor = false,
                    Size = UDim2.new(1, 0, 0, 32),
                    BackgroundColor3 = Library.Theme.Inline,
                    BorderSizePixel = 0,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 13
                })

                Items.TabButton:AddToTheme({
                    TextColor3 = "TextDis",
                    BackgroundColor3 = "Inline"
                })
                Items.TabButton:CreateCorner(6)

                Items.ActiveBar = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items.TabButton.Instance,
                    Size = UDim2.new(0, 3, 0.6, 0),
                    Position = UDim2.new(0, 0, 0.2, 0),
                    BackgroundColor3 = Library.Theme.Accent,
                    BorderSizePixel = 0,
                    ZIndex = 14,
                    Visible = false
                })

                Items.ActiveBar:AddToTheme({BackgroundColor3 = "Accent"})

                if Page.Icon and Page.Icon ~= "" then
                    Items.Icon = Library:Create("ImageLabel", {
                        Name = "\0",
                        Parent = Items.TabButton.Instance,
                        Size = UDim2.new(0, 15, 0, 15),
                        Position = UDim2.new(0, 10, 0.5, -7),
                        BackgroundTransparency = 1,
                        Image = Page.Icon,
                        ImageColor3 = Library.Theme.TextDis,
                        ZIndex = 14
                    })

                    Items.Icon:AddToTheme({ImageColor3 = "TextDis"})
                    Items.TabButton.Instance.Text = ""
                    Items.TabButton.Instance.TextXAlignment = Enum.TextXAlignment.Left

                    Library:Create("UIPadding", {
                        Parent = Items.TabButton.Instance,
                        PaddingLeft = UDim.new(0, 32)
                    })
                end

                Library:Create("UIPadding", {
                    Parent = Items.TabButton.Instance,
                    PaddingLeft = Page.Icon and UDim.new(0, 32) or UDim.new(0, 12)
                })

                Items.Page = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Library.UnusedHolder.Instance,
                    BackgroundTransparency = 1,
                    Visible = false,
                    Size = UDim2.new(1, 0, 1, 0),
                    BorderSizePixel = 0
                })

                Items.PageLayout = Library:Create("UIListLayout", {
                    Parent = Items.Page.Instance,
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalFlex = Enum.UIFlexAlignment.Fill,
                    Padding = UDim.new(0, 11),
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    VerticalFlex = Enum.UIFlexAlignment.Fill
                })

                Items.LeftColumn = Library:Create("ScrollingFrame", {
                    Name = "\0",
                    Parent = Items.Page.Instance,
                    ScrollBarImageColor3 = Library.Theme.Accent,
                    Active = true,
                    AutomaticCanvasSize = Enum.AutomaticSize.Y,
                    ScrollBarThickness = 2,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 100, 0, 100),
                    BorderSizePixel = 0,
                    CanvasSize = UDim2.new(0, 0, 0, 0)
                })

                Items.LeftColumn:AddToTheme({ScrollBarImageColor3 = "Accent"})

                Items.LeftColumnLayout = Library:Create("UIListLayout", {
                    Parent = Items.LeftColumn.Instance,
                    Padding = UDim.new(0, 15),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Library:Create("UIPadding", {
                    Parent = Items.LeftColumn.Instance,
                    PaddingTop = UDim.new(0, 19),
                    PaddingBottom = UDim.new(0, 15),
                    PaddingRight = UDim.new(0, 2),
                    PaddingLeft = UDim.new(0, 10)
                })

                Items.RightColumn = Library:Create("ScrollingFrame", {
                    Name = "\0",
                    Parent = Items.Page.Instance,
                    ScrollBarImageColor3 = Library.Theme.Accent,
                    Active = true,
                    AutomaticCanvasSize = Enum.AutomaticSize.Y,
                    ScrollBarThickness = 2,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 100, 0, 100),
                    BorderSizePixel = 0,
                    CanvasSize = UDim2.new(0, 0, 0, 0)
                })

                Items.RightColumn:AddToTheme({ScrollBarImageColor3 = "Accent"})

                Items.RightColumnLayout = Library:Create("UIListLayout", {
                    Parent = Items.RightColumn.Instance,
                    Padding = UDim.new(0, 15),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Library:Create("UIPadding", {
                    Parent = Items.RightColumn.Instance,
                    PaddingTop = UDim.new(0, 19),
                    PaddingBottom = UDim.new(0, 15),
                    PaddingRight = UDim.new(0, 10),
                    PaddingLeft = UDim.new(0, 2)
                })

                Page.ColumnsData[1] = Items.LeftColumn
                Page.ColumnsData[2] = Items.RightColumn

                Page.Items = Items
            end

            Items.TabButton:OnHover(function()
                if Page.Active then
                    return
                end
                Items.TabButton:Tween({TextColor3 = Library.Theme.Text})
            end, function()
                if Page.Active then
                    return
                end
                Items.TabButton:Tween({TextColor3 = Library.Theme.TextDis})
            end)

            function Page:Turn()
                local Old = Page.Window.ActiveTab

                if Old == Page then
                    return
                end

                if Page.Debounce then
                    return
                end

                if Old and Old.Debounce then
                    return
                end

                Page.Debounce = true

                if Old then
                    Old.Items.Page.Instance.Position = UDim2.new(0, 0, 0, 0)
                    Old.Items.TabButton:ChangeItemTheme({TextColor3 = "TextDis", BackgroundColor3 = "Inline"})
                    Old.Items.TabButton:Tween({TextColor3 = Library.Theme.TextDis, BackgroundColor3 = Library.Theme.Inline})
                    Old.Items.ActiveBar.Visible = false

                    if Old.Items.Icon then
                        Old.Items.Icon:ChangeItemTheme({ImageColor3 = "TextDis"})
                        Old.Items.Icon:Tween({ImageColor3 = Library.Theme.TextDis})
                    end

                    Old.Items.Page:Tween({Position = UDim2.new(-1, 0, 0, 0)}, PageInfo)

                    Old.Items.Page:FadeDescendants(false, function()
                        Old.Items.Page.Instance.Parent = Library.UnusedHolder.Instance
                    end)

                    Old.Active = false
                end

                Items.Page.Instance.Position = UDim2.new(1, 0, 0, 0)
                Items.Page.Instance.Parent = Page.Window.Items.Content.Instance
                Items.Page.Instance.Visible = true
                Items.Page:FadeDescendants(true, function()
                    Page.Debounce = false
                end)

                Items.TabButton:ChangeItemTheme({TextColor3 = "Accent", BackgroundColor3 = "Active Element"})
                Items.TabButton:Tween({TextColor3 = Library.Theme.Accent, BackgroundColor3 = Library.Theme.ActiveElement})
                Items.ActiveBar.Visible = true

                if Items.Icon then
                    Items.Icon:ChangeItemTheme({ImageColor3 = "Accent"})
                    Items.Icon:Tween({ImageColor3 = Library.Theme.Accent})
                end

                Items.Page:Tween({Position = UDim2.new(0, 0, 0, 0)}, PageInfo)

                Page.Window.ActiveTab = Page
                Page.Active = true
            end

            Items.TabButton:Connect("MouseButton1Down", function()
                if not Page.Window.Locked then
                    Page:Turn()
                end
            end)

            if #Page.Window.Pages == 0 then
                Page:Turn()
            end

            table.insert(Page.Window.Pages, Page)
            return setmetatable(Page, Library)
        end

        Library.Section = function(Self, Params)
            Params = Params or {}

            local Section = {
                Name = Params.Name or "Section",
                Side = Params.Side or 1,
                Collapsed = false,
                Window = Self.Window,
                Page = Self,
                Items = {}
            }

            local Items = {}
            do
                Items.Section = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Section.Page.ColumnsData[Section.Side].Instance,
                    Size = UDim2.new(1, 0, 0, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundColor3 = Library.Theme.Element,
                    ClipsDescendants = false
                })

                Items.Section:AddToTheme({BackgroundColor3 = "Element"})
                Items.Section:CreateCorner(8)
                Items.Section:CreateStroke(Library.Theme.Border, 1)

                Items.Header = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.FontSemi,
                    TextSize = 13,
                    Parent = Items.Section.Instance,
                    TextColor3 = Library.Theme.Text,
                    Text = Section.Name,
                    AutoButtonColor = false,
                    Size = UDim2.new(1, 0, 0, 30),
                    BackgroundColor3 = Library.Theme.Element,
                    BorderSizePixel = 0,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 2
                })

                Items.Header:AddToTheme({
                    TextColor3 = "Text",
                    BackgroundColor3 = "Element"
                })

                Items.Header:CreateCorner(8)

                Library:Create("UIPadding", {
                    Parent = Items.Header.Instance,
                    PaddingLeft = UDim.new(0, 12)
                })

                Items.Arrow = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.FontBold,
                    TextSize = 14,
                    Parent = Items.Header.Instance,
                    TextColor3 = Library.Theme.TextSec,
                    Text = "▾",
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    Position = UDim2.new(1, -16, 0.5, 0),
                    Size = UDim2.new(0, 16, 0, 16),
                    ZIndex = 3
                })

                Items.Arrow:AddToTheme({TextColor3 = "TextSec"})

                Items.Content = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items.Section.Instance,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 8, 0, 30),
                    Size = UDim2.new(1, -16, 0, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.Y
                })

                Items.ContentLayout = Library:Create("UIListLayout", {
                    Parent = Items.Content.Instance,
                    Padding = UDim.new(0, 8),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Library:Create("UIPadding", {
                    Parent = Items.Section.Instance,
                    PaddingBottom = UDim.new(0, 8)
                })

                Section.Items = Items
            end

            Items.Header:OnHover(function()
                Items.Header:Tween({BackgroundColor3 = Library.Theme.HoveredElement})
            end, function()
                Items.Header:Tween({BackgroundColor3 = Library.Theme.Element})
            end)

            Items.Header:Connect("MouseButton1Down", function()
                Section.Collapsed = not Section.Collapsed
                Items.Arrow.Instance.Text = Section.Collapsed and "▸" or "▾"

                if Section.Collapsed then
                    Items.Content.Instance.Visible = false
                    Items.Section.Instance.Size = UDim2.new(1, 0, 0, 30)
                else
                    Items.Content.Instance.Visible = true
                    Items.Section.Instance.Size = UDim2.new(1, 0, 0, 0)
                    task.wait()
                    Items.Section.Instance.Size = UDim2.new(1, 0, 0, Items.Content.Instance.AbsoluteSize.Y + 38)
                end
            end)

            function Section:SetText(Text)
                Items.Header.Instance.Text = tostring(Text)
            end

            function Section:SetVisibility(Bool)
                Items.Section.Instance.Visible = Bool
            end

            return setmetatable(Section, Library)
        end

        Library.Toggle = function(Self, Params)
            Params = Params or {}

            local Toggle = {
                Name = Params.Name or "Toggle",
                Flag = Params.Flag or Params.Name or "Toggle",
                Default = Params.Default or false,
                Callback = Params.Callback or function() end,
                Desc = Params.Desc or "",
                Window = Self.Window,
                Page = Self.Page,
                Section = Self,
                Value = false,
                Items = {}
            }

            local Parent = Params.Parent or Toggle.Section.Items.Content

            local Items = {}
            do
                Items.Toggle = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Parent.Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, Toggle.Desc ~= "" and 46 or 34),
                    BorderSizePixel = 0
                })

                Items.Outline = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items.Toggle.Instance,
                    AnchorPoint = Vector2.new(0, 0.5),
                    Position = UDim2.new(0, 0, 0.5, 0),
                    Size = UDim2.new(0, 9, 0, 9),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme.Border
                })

                Items.Outline:AddToTheme({BackgroundColor3 = "Border"})

                Items.Indicator = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items.Outline.Instance,
                    Position = UDim2.new(0, 1, 0, 1),
                    Size = UDim2.new(1, -2, 1, -2),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme.Element2
                })

                Items.Indicator:AddToTheme({BackgroundColor3 = "Element2"})
                Items.Indicator:CreateGradient(90, {
                    Color3.fromRGB(255, 255, 255),
                    Color3.fromRGB(200, 200, 200)
                })

                Items.Text = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.FontSemi,
                    TextSize = Library.FontSize,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = Items.Toggle.Instance,
                    TextColor3 = Library.Theme.Text,
                    Text = Toggle.Name,
                    Position = UDim2.new(0, 18, 0, Toggle.Desc ~= "" and 4 or 6),
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY
                })

                Items.Text:AddToTheme({TextColor3 = "Text"})

                if Toggle.Desc ~= "" then
                    Items.Desc = Library:Create("TextLabel", {
                        Name = "\0",
                        FontFace = Library.Font,
                        TextSize = Library.FontSize - 1,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Parent = Items.Toggle.Instance,
                        TextColor3 = Library.Theme.TextDis,
                        Text = Toggle.Desc,
                        Position = UDim2.new(0, 18, 0, 26),
                        BackgroundTransparency = 1,
                        BorderSizePixel = 0,
                        AutomaticSize = Enum.AutomaticSize.XY
                    })

                    Items.Desc:AddToTheme({TextColor3 = "TextDis"})
                end

                Items.SubElements = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items.Toggle.Instance,
                    AnchorPoint = Vector2.new(1, 0),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, 0, 0, 0),
                    Size = UDim2.new(0, 0, 1, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X
                })

                Library:Create("UIListLayout", {
                    Parent = Items.SubElements.Instance,
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    FillDirection = Enum.FillDirection.Horizontal,
                    Padding = UDim.new(0, 8),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Toggle.Items = Items
            end

            Items.Toggle:OnHover(function()
                if Toggle.Value then
                    return
                end
                Items.Indicator:Tween({BackgroundColor3 = Library.Theme.HoveredElement})
            end, function()
                if Toggle.Value then
                    return
                end
                Items.Indicator:Tween({BackgroundColor3 = Library.Theme.Element2})
            end)

            function Toggle:Set(Bool)
                Toggle.Value = Bool

                if Bool then
                    Items.Indicator:ChangeItemTheme({BackgroundColor3 = "ToggleOn"})
                    Items.Indicator:Tween({BackgroundColor3 = Library.Theme.ToggleOn})
                else
                    Items.Indicator:ChangeItemTheme({BackgroundColor3 = "Element2"})
                    Items.Indicator:Tween({BackgroundColor3 = Library.Theme.Element2})
                end

                Flags[Toggle.Flag] = Bool
                Library:SafeCall(Toggle.Callback, Bool)
            end

            function Toggle:SetVisibility(Bool)
                Items.Toggle.Instance.Visible = Bool
            end

            function Toggle:SetText(Text)
                Items.Text.Instance.Text = tostring(Text)
            end

            function Toggle:SetDesc(Text)
                if Items.Desc then
                    Items.Desc.Instance.Text = tostring(Text)
                end
            end

            function Toggle:Colorpicker(Data)
                Data = Data or {}

                local Colorpicker = {
                    Flag = Data.Flag or Data.Name or Toggle.Name,
                    Default = Data.Default or Color3.fromRGB(255, 255, 255),
                    Callback = Data.Callback or function() end,
                    Alpha = Data.Alpha or 0,
                    Window = Toggle.Window,
                    Page = Toggle.Page,
                    Section = Toggle.Section
                }

                local NewColorpicker = Library:CreateColorpicker({
                    Parent = Items.SubElements,
                    Page = Colorpicker.Page,
                    Section = Colorpicker.Section,
                    Flag = Colorpicker.Flag,
                    Default = Colorpicker.Default,
                    Callback = Colorpicker.Callback,
                    Alpha = Colorpicker.Alpha
                })

                return NewColorpicker
            end

            function Toggle:Keybind(Data)
                Data = Data or {}

                local Keybind = {
                    Name = Data.Name or Toggle.Name,
                    Flag = Data.Flag or Data.Name or Toggle.Name,
                    Default = Data.Default or nil,
                    Callback = Data.Callback or function() end,
                    Mode = Data.Mode or "Toggle",
                    Window = Toggle.Window,
                    Page = Toggle.Page,
                    Section = Toggle.Section
                }

                local NewKeybind = Library:CreateKeybind({
                    Parent = Items.SubElements,
                    Name = Keybind.Name,
                    Page = Keybind.Page,
                    Section = Keybind.Section,
                    Flag = Keybind.Flag,
                    Default = Keybind.Default,
                    Mode = Keybind.Mode,
                    Callback = Keybind.Callback
                })

                return NewKeybind
            end

            Items.Toggle:Connect("MouseButton1Down", function()
                Toggle:Set(not Toggle.Value)
            end)

            Toggle:Set(Toggle.Default)

            SetFlags[Toggle.Flag] = function(Value)
                Toggle:Set(Value)
            end

            return setmetatable(Toggle, Library)
        end

        Library.Button = function(Self, Params)
            Params = Params or {}

            local Button = {
                Name = Params.Name or "Button",
                Callback = Params.Callback or function() end,
                Desc = Params.Desc or "",
                Style = Params.Style or "Default",
                Window = Self.Window,
                Page = Self.Page,
                Section = Self,
                Items = {}
            }

            local Parent = Params.Parent or Button.Section.Items.Content

            local Items = {}
            do
                Items.Button = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Parent.Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Size = UDim2.new(1, 0, 0, Button.Desc ~= "" and 44 or 34),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme.Element
                })

                Items.Button:AddToTheme({BackgroundColor3 = "Element"})
                Items.Button:CreateCorner(6)

                if Button.Style == "Accent" then
                    Items.Button:CreateStroke(Library.Theme.Accent, 1, 0.5)
                elseif Button.Style == "Danger" then
                    Items.Button:CreateStroke(Color3.fromRGB(220, 60, 60), 1, 0.5)
                end

                Items.Text = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.FontSemi,
                    TextSize = Library.FontSize,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = Items.Button.Instance,
                    TextColor3 = Library.Theme.Text,
                    Text = Button.Name,
                    Position = UDim2.new(0, 10, 0, Button.Desc ~= "" and 6 or 8),
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY,
                    ZIndex = 2
                })

                Items.Text:AddToTheme({TextColor3 = "Text"})

                if Button.Desc ~= "" then
                    Items.Desc = Library:Create("TextLabel", {
                        Name = "\0",
                        FontFace = Library.Font,
                        TextSize = Library.FontSize - 1,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Parent = Items.Button.Instance,
                        TextColor3 = Library.Theme.TextDis,
                        Text = Button.Desc,
                        Position = UDim2.new(0, 10, 0, 26),
                        BackgroundTransparency = 1,
                        BorderSizePixel = 0,
                        AutomaticSize = Enum.AutomaticSize.XY,
                        ZIndex = 2                    })

                    Items.Desc:AddToTheme({TextColor3 = "TextDis"})
                end

                Items.Arrow = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.FontBold,
                    TextSize = 18,
                    Parent = Items.Button.Instance,
                    TextColor3 = Library.Theme.Accent,
                    Text = "›",
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    Position = UDim2.new(1, -18, 0.5, 0),
                    Size = UDim2.new(0, 18, 0, 18),
                    ZIndex = 2
                })

                Items.Arrow:AddToTheme({TextColor3 = "Accent"})

                Button.Items = Items
            end

            Items.Button:OnHover(function()
                Items.Button:Tween({BackgroundColor3 = Library.Theme.HoveredElement})
            end, function()
                Items.Button:Tween({BackgroundColor3 = Library.Theme.Element})
            end)

            function Button:Press()
                Library:SafeCall(Button.Callback)

                Items.Button:Tween({BackgroundColor3 = Library.Theme.ActiveElement})
                task.wait(0.15)
                Items.Button:Tween({BackgroundColor3 = Library.Theme.Element})
            end

            function Button:SetVisibility(Bool)
                Items.Button.Instance.Visible = Bool
            end

            function Button:SetText(Text)
                Items.Text.Instance.Text = tostring(Text)
            end

            function Button:SetDesc(Text)
                if Items.Desc then
                    Items.Desc.Instance.Text = tostring(Text)
                end
            end

            Items.Button:Connect("MouseButton1Down", function()
                Button:Press()
            end)

            return setmetatable(Button, Library)
        end

        Library.Slider = function(Self, Params)
            Params = Params or {}

            local Slider = {
                Name = Params.Name or "Slider",
                Flag = Params.Flag or Params.Name or "Slider",
                Default = Params.Default or 0,
                Min = Params.Min or 0,
                Max = Params.Max or 100,
                Callback = Params.Callback or function() end,
                Decimals = Params.Decimals or 1,
                Suffix = Params.Suffix or "",
                Step = Params.Step or 1,
                Window = Self.Window,
                Page = Self.Page,
                Section = Self,
                Value = 0,
                Sliding = false,
                Items = {}
            }

            local Parent = Params.Parent or Slider.Section.Items.Content

            local Items = {}
            do
                Items.Slider = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Parent.Instance,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 52),
                    BorderSizePixel = 0
                })

                Items.Text = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.FontSemi,
                    TextSize = Library.FontSize,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = Items.Slider.Instance,
                    TextColor3 = Library.Theme.Text,
                    Text = Slider.Name,
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    Position = UDim2.new(0, 0, 0, 8),
                    AutomaticSize = Enum.AutomaticSize.XY
                })

                Items.Text:AddToTheme({TextColor3 = "Text"})

                Items.Value = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.FontSemi,
                    TextSize = Library.FontSize,
                    Parent = Items.Slider.Instance,
                    TextColor3 = Library.Theme.Accent,
                    Text = "0",
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    Position = UDim2.new(1, 0, 0, 8),
                    AnchorPoint = Vector2.new(1, 0),
                    AutomaticSize = Enum.AutomaticSize.XY
                })

                Items.Value:AddToTheme({TextColor3 = "Accent"})

                Items.TrackBG = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items.Slider.Instance,
                    Size = UDim2.new(1, 0, 0, 5),
                    Position = UDim2.new(0, 0, 0, 34),
                    BackgroundColor3 = Library.Theme.SliderBG,
                    BorderSizePixel = 0
                })

                Items.TrackBG:AddToTheme({BackgroundColor3 = "SliderBG"})
                Items.TrackBG:CreateCorner(3)

                Items.Fill = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items.TrackBG.Instance,
                    Size = UDim2.new(0.5, 0, 1, 0),
                    BackgroundColor3 = Library.Theme.SliderFill,
                    BorderSizePixel = 0
                })

                Items.Fill:AddToTheme({BackgroundColor3 = "SliderFill"})
                Items.Fill:CreateCorner(3)

                Items.Knob = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items.TrackBG.Instance,
                    Size = UDim2.new(0, 14, 0, 14),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    BackgroundColor3 = Library.Theme.Knob,
                    BorderSizePixel = 0
                })

                Items.Knob:AddToTheme({BackgroundColor3 = "Knob"})
                Items.Knob:CreateCorner(7)
                Items.Knob:CreateStroke(Library.Theme.Accent, 2)

                Items.HitBox = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items.Slider.Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 24),
                    Position = UDim2.new(0, 0, 0, 26),
                    BorderSizePixel = 0,
                    ZIndex = 10
                })

                Slider.Items = Items
            end

            function Slider:Set(Value)
                local Clamped = Library:Clamp(Value, Slider.Min, Slider.Max)
                local Rounded = Library:Round(Clamped, Slider.Decimals)
                local Fraction = (Rounded - Slider.Min) / (Slider.Max - Slider.Min)

                Slider.Value = Rounded

                Items.Fill:Tween({Size = UDim2.new(Fraction, 0, 1, 0)})
                Items.Knob:Tween({Position = UDim2.new(Fraction, 0, 0.5, 0)})
                Items.Value.Instance.Text = tostring(Rounded) .. Slider.Suffix

                Flags[Slider.Flag] = Rounded
                Library:SafeCall(Slider.Callback, Rounded)
            end

            function Slider:GetValueFromInput(Input)
                local Track = Items.TrackBG.Instance
                local X = (Input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X
                local Value = Slider.Min + (Slider.Max - Slider.Min) * Library:Clamp(X, 0, 1)
                return Value
            end

            function Slider:SetVisibility(Bool)
                Items.Slider.Instance.Visible = Bool
            end

            function Slider:SetText(Text)
                Items.Text.Instance.Text = tostring(Text)
            end

            local InputChanged

            Items.HitBox:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    Slider.Sliding = true
                    local Value = Slider:GetValueFromInput(Input)
                    Slider:Set(Value)

                    if InputChanged then
                        return
                    end

                    InputChanged = Input.Changed:Connect(function()
                        if Input.UserInputState == Enum.UserInputState.End then
                            Slider.Sliding = false
                            InputChanged:Disconnect()
                            InputChanged = nil
                        end
                    end)
                end
            end)

            Library:Connect(UserInputService.InputChanged, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
                    if Slider.Sliding then
                        local Value = Slider:GetValueFromInput(Input)
                        Slider:Set(Value)
                    end
                end
            end)

            Slider:Set(Slider.Default)

            SetFlags[Slider.Flag] = function(Value)
                Slider:Set(Value)
            end

            return setmetatable(Slider, Library)
        end

        Library.Dropdown = function(Self, Params)
            Params = Params or {}

            local Dropdown = {
                Name = Params.Name or "Dropdown",
                OptionItems = Params.Items or {},
                Flag = Params.Flag or Params.Name or "Dropdown",
                Default = Params.Default or "",
                Callback = Params.Callback or function() end,
                Multi = Params.Multi or false,
                Window = Self.Window,
                Page = Self.Page,
                Section = Self,
                Value = {},
                Options = {},
                IsOpen = false,
                Items = {}
            }

            local Parent = Params.Parent or Dropdown.Section.Items.Content

            local Items = {}
            do
                Items.Dropdown = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Parent.Instance,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 42),
                    BorderSizePixel = 0
                })

                Items.Text = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.FontSemi,
                    TextSize = Library.FontSize,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = Items.Dropdown.Instance,
                    TextColor3 = Library.Theme.Text,
                    Text = Dropdown.Name,
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    Position = UDim2.new(0, 0, 0, 4),
                    AutomaticSize = Enum.AutomaticSize.XY
                })

                Items.Text:AddToTheme({TextColor3 = "Text"})

                Items.Selector = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items.Dropdown.Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Size = UDim2.new(1, 0, 0, 20),
                    Position = UDim2.new(0, 0, 0, 22),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme.Element
                })

                Items.Selector:AddToTheme({BackgroundColor3 = "Element"})
                Items.Selector:CreateCorner(5)
                Items.Selector:CreateStroke(Library.Theme.Border, 1)

                Items.Selector:OnHover(function()
                    Items.Selector:Tween({BackgroundColor3 = Library.Theme.HoveredElement})
                end, function()
                    Items.Selector:Tween({BackgroundColor3 = Library.Theme.Element})
                end)

                Items.Value = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize - 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = Items.Selector.Instance,
                    TextColor3 = Library.Theme.Text,
                    Text = "none",
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    Position = UDim2.new(0, 8, 0.5, -1),
                    AnchorPoint = Vector2.new(0, 0.5),
                    Size = UDim2.new(1, -32, 0, 0),
                    TextTruncate = Enum.TextTruncate.AtEnd
                })

                Items.Value:AddToTheme({TextColor3 = "Text"})

                Items.Arrow = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.FontBold,
                    TextSize = 14,
                    Parent = Items.Selector.Instance,
                    TextColor3 = Library.Theme.Accent,
                    Text = "▾",
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    Position = UDim2.new(1, -12, 0.5, 0),
                    Size = UDim2.new(0, 12, 0, 12),
                    ZIndex = 2
                })

                Items.Arrow:AddToTheme({TextColor3 = "Accent"})

                Items.OptionHolder = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Library.Holder.Instance,
                    Visible = false,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Size = UDim2.new(0, 200, 0, 50),
                    Position = UDim2.new(0, 792, 0, 649),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundColor3 = Library.Theme.DropdownBG,
                    ZIndex = Library.ZIndexOrder.OptionHolder
                })

                Items.OptionHolder:AddToTheme({BackgroundColor3 = "DropdownBG"})
                Items.OptionHolder:CreateCorner(8)
                Items.OptionHolder:CreateStroke(Library.Theme.Border, 1)
                Items.OptionHolder:CreateShadow(12, 0.5)

                Library:Create("UIPadding", {
                    Parent = Items.OptionHolder.Instance,
                    PaddingTop = UDim.new(0, 6),
                    PaddingBottom = UDim.new(0, 6),
                    PaddingRight = UDim.new(0, 4),
                    PaddingLeft = UDim.new(0, 4)
                })

                Items.OptionList = Library:Create("UIListLayout", {
                    Parent = Items.OptionHolder.Instance,
                    Padding = UDim.new(0, 2),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Dropdown.Items = Items
            end

            function Dropdown:Set(Value)
                if Dropdown.Multi then
                    if type(Value) ~= "table" then
                        return
                    end

                    Dropdown.Value = Value

                    for Index, Val in Dropdown.Options do
                        local IsSelected = table.find(Value, Index) ~= nil
                        Val.IsSelected = IsSelected
                        Val:ToggleState(IsSelected and "Active" or "Inactive")
                    end

                    Flags[Dropdown.Flag] = Value
                    Items.Value.Instance.Text = #Value > 0 and table.concat(Value, ", ") or "none"
                else
                    if not Dropdown.Options[Value] then
                        return
                    end

                    Dropdown.Value = Value

                    for Index, Val in Dropdown.Options do
                        local IsSelected = Index == Value
                        Val.IsSelected = IsSelected
                        Val:ToggleState(IsSelected and "Active" or "Inactive")
                    end

                    Flags[Dropdown.Flag] = Value
                    Items.Value.Instance.Text = Value
                end

                Library:SafeCall(Dropdown.Callback, Dropdown.Value)
            end

            function Dropdown:Add(Value)
                local OptionButton = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize - 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = Items.OptionHolder.Instance,
                    TextColor3 = Library.Theme.TextDis,
                    Text = Value,
                    AutoButtonColor = false,
                    Size = UDim2.new(1, 0, 0, 28),
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.Y
                })

                OptionButton:AddToTheme({TextColor3 = "TextDis"})
                OptionButton:CreateCorner(4)

                Library:Create("UIPadding", {
                    Parent = OptionButton.Instance,
                    PaddingLeft = UDim.new(0, 8)
                })

                local Dot = Library:Create("Frame", {
                    Name = "\0",
                    Parent = OptionButton.Instance,
                    Size = UDim2.new(0, 6, 0, 6),
                    Position = UDim2.new(0, 8, 0.5, -3),
                    BackgroundColor3 = Library.Theme.Element,
                    BorderSizePixel = 0,
                    Visible = false
                })

                Dot:AddToTheme({BackgroundColor3 = "Element"})
                Dot:CreateCorner(3)

                local OptionData = {
                    Button = OptionButton,
                    Name = Value,
                    IsSelected = false,
                    Dot = Dot
                }

                OptionButton:OnHover(function()
                    if OptionData.IsSelected then
                        return
                    end
                    OptionButton:Tween({TextColor3 = Library.Theme.Text})
                end, function()
                    if OptionData.IsSelected then
                        return
                    end
                    OptionButton:Tween({TextColor3 = Library.Theme.TextDis})
                end)

                function OptionData:ToggleState(State)
                    if State == "Active" then
                        OptionButton:ChangeItemTheme({TextColor3 = "Accent"})
                        OptionButton:Tween({TextColor3 = Library.Theme.Accent})
                        Dot.Visible = true
                        Dot:Tween({BackgroundColor3 = Library.Theme.Accent})
                    else
                        OptionButton:ChangeItemTheme({TextColor3 = "TextDis"})
                        OptionButton:Tween({TextColor3 = Library.Theme.TextDis})
                        Dot.Visible = false
                    end
                end

                function OptionData:Set()
                    if Dropdown.Multi then
                        local Index = table.find(Dropdown.Value, OptionData.Name)

                        if Index then
                            table.remove(Dropdown.Value, Index)
                            OptionData.IsSelected = false
                            OptionData:ToggleState("Inactive")
                        else
                            table.insert(Dropdown.Value, OptionData.Name)
                            OptionData.IsSelected = true
                            OptionData:ToggleState("Active")
                        end

                        Flags[Dropdown.Flag] = Dropdown.Value
                        Items.Value.Instance.Text = #Dropdown.Value > 0 and table.concat(Dropdown.Value, ", ") or "none"
                    else
                        if OptionData.IsSelected then
                            Dropdown.Value = {}
                            OptionData.IsSelected = false
                            OptionData:ToggleState("Inactive")
                        else
                            Dropdown.Value = OptionData.Name
                            OptionData.IsSelected = true
                            OptionData:ToggleState("Active")

                            for Index, Val in Dropdown.Options do
                                if Val ~= OptionData then
                                    Val.IsSelected = false
                                    Val:ToggleState("Inactive")
                                end
                            end
                        end

                        Flags[Dropdown.Flag] = Dropdown.Value
                        Items.Value.Instance.Text = Dropdown.Value ~= "" and Dropdown.Value or "none"
                    end

                    Library:SafeCall(Dropdown.Callback, Dropdown.Value)
                    Dropdown:SetOpen(false)
                end

                OptionData.Button:Connect("MouseButton1Down", function()
                    OptionData:Set()
                end)

                Dropdown.Options[OptionData.Name] = OptionData
                return OptionData
            end

            function Dropdown:Remove(Option)
                if Dropdown.Options[Option] then
                    Dropdown.Options[Option].Button.Instance:Destroy()
                    Dropdown.Options[Option] = nil
                end
            end

            function Dropdown:Refresh(List)
                for Index, Value in Dropdown.Options do
                    Dropdown:Remove(Value.Name)
                end

                for Index, Value in List do
                    Dropdown:Add(Value)
                end
            end

            function Dropdown:SetText(Text)
                Items.Text.Instance.Text = tostring(Text)
            end

            function Dropdown:SetVisibility(Bool)
                Items.Dropdown.Instance.Visible = Bool
            end

            local Debounce = false
            local OptionHolder = Items.OptionHolder.Instance
            local Selector = Items.Selector.Instance

            function Dropdown:SetOpen(Bool)
                if Debounce then
                    return
                end

                Dropdown.IsOpen = Bool
                Debounce = true

                if Dropdown.IsOpen then
                    OptionHolder.Visible = true
                    OptionHolder.Size = UDim2.new(0, Selector.AbsoluteSize.X, 0, 0)

                    Items.OptionHolder:Tween({
                        Position = Library:PopupPosition(Selector, OptionHolder, 10)
                    })

                    Items.OptionHolder:FadeDescendants(true, function()
                        Debounce = false
                    end)

                    for Index, Value in Library.OpenFrames do
                        if Value ~= Dropdown and not Params.Parent then
                            Value:SetOpen(false)
                        end
                    end

                    Library.OpenFrames[Dropdown] = Dropdown
                else
                    Items.OptionHolder:Tween({
                        Position = Library:PopupPosition(Selector, OptionHolder, -10)
                    })

                    Items.OptionHolder:FadeDescendants(false, function()
                        Debounce = false
                    end)

                    if Library.OpenFrames[Dropdown] then
                        Library.OpenFrames[Dropdown] = nil
                    end
                end
            end

            Items.OptionHolder:VisibleCheck()

            Library:Connect(UserInputService.InputBegan, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                    if Dropdown.IsOpen and not Items.OptionHolder:IsMouseOverFrame() then
                        Dropdown:SetOpen(false)
                    end
                end
            end)

            Items.Selector:Connect("MouseButton1Down", function()
                Dropdown:SetOpen(not Dropdown.IsOpen)
            end)

            for Index, Value in Dropdown.OptionItems do
                Dropdown:Add(Value)
            end

            Dropdown:Set(Dropdown.Default)

            SetFlags[Dropdown.Flag] = function(Value)
                Dropdown:Set(Value)
            end

            return setmetatable(Dropdown, Library)
        end

        Library.List = function(Self, Params)
            Params = Params or {}

            local List = {
                OptionItems = Params.Items or {},
                Flag = Params.Flag or Params.Name or "List",
                Default = Params.Default or "",
                Callback = Params.Callback or function() end,
                Multi = Params.Multi or false,
                Window = Self.Window,
                Page = Self.Page,
                Section = Self,
                Value = {},
                Options = {},
                Items = {}
            }

            local Parent = Params.Parent or List.Section.Items.Content

            local Items = {}
            do
                Items.List = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Parent.Instance,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 200),
                    BorderSizePixel = 0
                })

                Items.SearchOutline = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items.List.Instance,
                    Size = UDim2.new(1, 0, 0, 22),
                    Active = true,
                    Selectable = true,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme.Border
                })

                Items.SearchOutline:AddToTheme({BackgroundColor3 = "Border"})

                Items.SearchInline = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items.SearchOutline.Instance,
                    Active = true,
                    Position = UDim2.new(0, 1, 0, 1),
                    Selectable = true,
                    Size = UDim2.new(1, -2, 1, -2),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme.Outline
                })

                Items.SearchInline:AddToTheme({BackgroundColor3 = "Outline"})

                Items.SearchBackground = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items.SearchInline.Instance,
                    ClipsDescendants = true,
                    Size = UDim2.new(1, -2, 1, -2),
                    Position = UDim2.new(0, 1, 0, 1),
                    Selectable = true,
                    Active = true,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme.Element
                })

                Items.SearchBackground:AddToTheme({BackgroundColor3 = "Element"})
                Items.SearchBackground:CreateGradient(90, {
                    Color3.fromRGB(255, 255, 255),
                    Color3.fromRGB(200, 200, 200)
                })

                Items.Search = Library:Create("TextBox", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize - 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = Items.SearchBackground.Instance,
                    AnchorPoint = Vector2.new(0, 0.5),
                    PlaceholderColor3 = Library.Theme.TextDis,
                    PlaceholderText = "Search...",
                    Size = UDim2.new(1, -8, 0, 0),
                    TextColor3 = Library.Theme.Text,
                    Text = "",
                    Position = UDim2.new(0, 4, 0.5, -1),
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    ClearTextOnFocus = false,
                    AutomaticSize = Enum.AutomaticSize.Y
                })

                Items.Search:AddToTheme({
                    TextColor3 = "Text",
                    PlaceholderColor3 = "TextDis"
                })

                Items.ListOutline = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items.List.Instance,
                    Position = UDim2.new(0, 0, 0, 26),
                    Size = UDim2.new(1, 0, 1, -26),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme.Border
                })

                Items.ListOutline:AddToTheme({BackgroundColor3 = "Border"})

                Items.ListInline = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items.ListOutline.Instance,
                    Position = UDim2.new(0, 1, 0, 1),
                    Size = UDim2.new(1, -2, 1, -2),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme.Outline
                })

                Items.ListInline:AddToTheme({BackgroundColor3 = "Outline"})

                Items.ListBackground = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items.ListInline.Instance,
                    Position = UDim2.new(0, 1, 0, 1),
                    Size = UDim2.new(1, -2, 1, -2),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme.Element
                })

                Items.ListBackground:AddToTheme({BackgroundColor3 = "Element"})
                Items.ListBackground:CreateGradient(90, {
                    Color3.fromRGB(255, 255, 255),
                    Color3.fromRGB(200, 200, 200)
                })

                Items.Holder = Library:Create("ScrollingFrame", {
                    Name = "\0",
                    Parent = Items.ListBackground.Instance,
                    Active = true,
                    AutomaticCanvasSize = Enum.AutomaticSize.Y,
                    BorderSizePixel = 0,
                    CanvasSize = UDim2.new(0, 0, 0, 0),
                    ScrollBarImageColor3 = Library.Theme.Accent,
                    ScrollBarThickness = 2,
                    Size = UDim2.new(1, -16, 1, -16),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 8, 0, 8)
                })

                Items.Holder:AddToTheme({ScrollBarImageColor3 = "Accent"})

                Items.HolderLayout = Library:Create("UIListLayout", {
                    Parent = Items.Holder.Instance,
                    Padding = UDim.new(0, 4),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Library:Create("UIPadding", {
                    Parent = Items.Holder.Instance,
                    PaddingBottom = UDim.new(0, 8)
                })

                List.Items = Items
            end

            function List:Set(Value)
                if List.Multi then
                    if type(Value) ~= "table" then
                        return
                    end

                    List.Value = Value

                    for Index, Val in List.Options do
                        local IsSelected = table.find(Value, Index) ~= nil
                        Val.IsSelected = IsSelected
                        Val:ToggleState(IsSelected and "Active" or "Inactive")
                    end

                    Flags[List.Flag] = Value
                else
                    if not List.Options[Value] then
                        return
                    end

                    List.Value = Value

                    for Index, Val in List.Options do
                        local IsSelected = Index == Value
                        Val.IsSelected = IsSelected
                        Val:ToggleState(IsSelected and "Active" or "Inactive")
                    end

                    Flags[List.Flag] = Value
                end

                Library:SafeCall(List.Callback, List.Value)
            end

            function List:Add(Value)
                local OptionButton = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize - 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = Items.Holder.Instance,
                    TextColor3 = Library.Theme.TextDis,
                    Text = Value,
                    AutoButtonColor = false,
                    Size = UDim2.new(1, 0, 0, 24),
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.Y
                })

                OptionButton:AddToTheme({TextColor3 = "TextDis"})

                Library:Create("UIPadding", {
                    Parent = OptionButton.Instance,
                    PaddingLeft = UDim.new(0, 8)
                })

                local Dot = Library:Create("Frame", {
                    Name = "\0",
                    Parent = OptionButton.Instance,
                    Size = UDim2.new(0, 5, 0, 5),
                    Position = UDim2.new(0, 8, 0.5, -2.5),
                    BackgroundColor3 = Library.Theme.Element,
                    BorderSizePixel = 0,
                    Visible = false
                })

                Dot:AddToTheme({BackgroundColor3 = "Element"})
                Dot:CreateCorner(3)

                local OptionData = {
                    Button = OptionButton,
                    Name = Value,
                    IsSelected = false,
                    Dot = Dot
                }

                OptionButton:OnHover(function()
                    if OptionData.IsSelected then
                        return
                    end
                    OptionButton:Tween({TextColor3 = Library.Theme.Text})
                end, function()
                    if OptionData.IsSelected then
                        return
                    end
                    OptionButton:Tween({TextColor3 = Library.Theme.TextDis})
                end)

                function OptionData:ToggleState(State)
                    if State == "Active" then
                        OptionButton:ChangeItemTheme({TextColor3 = "Accent"})
                        OptionButton:Tween({TextColor3 = Library.Theme.Accent})
                        Dot.Visible = true
                        Dot:Tween({BackgroundColor3 = Library.Theme.Accent})
                    else
                        OptionButton:ChangeItemTheme({TextColor3 = "TextDis"})
                        OptionButton:Tween({TextColor3 = Library.Theme.TextDis})
                        Dot.Visible = false
                    end
                end

                function OptionData:Set()
                    if List.Multi then
                        local Index = table.find(List.Value, OptionData.Name)

                        if Index then
                            table.remove(List.Value, Index)
                            OptionData.IsSelected = false
                            OptionData:ToggleState("Inactive")
                        else
                            table.insert(List.Value, OptionData.Name)
                            OptionData.IsSelected = true
                            OptionData:ToggleState("Active")
                        end

                        Flags[List.Flag] = List.Value
                    else
                        if OptionData.IsSelected then
                            List.Value = {}
                            OptionData.IsSelected = false
                            OptionData:ToggleState("Inactive")
                        else
                            List.Value = OptionData.Name
                            OptionData.IsSelected = true
                            OptionData:ToggleState("Active")

                            for Index, Val in List.Options do
                                if Val ~= OptionData then
                                    Val.IsSelected = false
                                    Val:ToggleState("Inactive")
                                end
                            end
                        end

                        Flags[List.Flag] = List.Value
                    end

                    Library:SafeCall(List.Callback, List.Value)
                end

                OptionData.Button:Connect("MouseButton1Down", function()
                    OptionData:Set()
                end)

                List.Options[OptionData.Name] = OptionData
                return OptionData
            end

            function List:Remove(Option)
                if List.Options[Option] then
                    List.Options[Option].Button.Instance:Destroy()
                    List.Options[Option] = nil
                end
            end

            function List:Refresh(NewList)
                for Index, Value in List.Options do
                    List:Remove(Value.Name)
                end

                for Index, Value in NewList do
                    List:Add(Value)
                end
            end

            function List:SetVisibility(Bool)
                Items.List.Instance.Visible = Bool
            end

            Items.Search:Connect("Changed", function(Property)
                if Property == "Text" then
                    local Query = string.lower(Items.Search.Instance.Text)

                    for Index, Value in List.Options do
                        local Visible = Query == "" or string.find(string.lower(Value.Name), Query) ~= nil
                        Value.Button.Instance.Visible = Visible
                    end
                end
            end)

            for Index, Value in List.OptionItems do
                List:Add(Value)
            end

            List:Set(List.Default)

            SetFlags[List.Flag] = function(Value)
                List:Set(Value)
            end

            return setmetatable(List, Library)
        end

        Library.Label = function(Self, Params)
            Params = Params or {}

            local Label = {
                Name = Params.Name or "Label",
                Color = Params.Color or Library.Theme.Text,
                Window = Self.Window,
                Page = Self.Page,
                Section = Self,
                Items = {}
            }

            local Parent = Params.Parent or Label.Section.Items.Content

            local Items = {}
            do
                Items.Label = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Parent.Instance,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 22),
                    BorderSizePixel = 0
                })

                Items.Text = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Params.Bold and Library.FontBold or Library.Font,
                    TextSize = Params.Size or Library.FontSize,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = Items.Label.Instance,
                    TextColor3 = Label.Color,
                    Text = Label.Name,
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    Position = UDim2.new(0, 0, 0.5, -1),
                    AnchorPoint = Vector2.new(0, 0.5),
                    AutomaticSize = Enum.AutomaticSize.XY
                })

                Items.Text:AddToTheme({TextColor3 = "Text"})

                Items.SubElements = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items.Label.Instance,
                    AnchorPoint = Vector2.new(1, 0),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, 0, 0, 0),
                    Size = UDim2.new(0, 0, 1, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X
                })

                Library:Create("UIListLayout", {
                    Parent = Items.SubElements.Instance,
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    FillDirection = Enum.FillDirection.Horizontal,
                    Padding = UDim.new(0, 8),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Label.Items = Items
            end

            function Label:SetVisibility(Bool)
                Items.Label.Instance.Visible = Bool
            end

            function Label:SetText(Text)
                Items.Text.Instance.Text = tostring(Text)
            end

            function Label:SetColor(Color)
                Items.Text.Instance.TextColor3 = Color
            end

            function Label:Colorpicker(Data)
                Data = Data or {}

                local Colorpicker = {
                    Flag = Data.Flag or Data.Name or Label.Name,
                    Default = Data.Default or Color3.fromRGB(255, 255, 255),
                    Callback = Data.Callback or function() end,
                    Alpha = Data.Alpha or 0,
                    Window = Label.Window,
                    Page = Label.Page,
                    Section = Label.Section
                }

                local NewColorpicker = Library:CreateColorpicker({
                    Parent = Items.SubElements,
                    Page = Colorpicker.Page,
                    Section = Colorpicker.Section,
                    Flag = Colorpicker.Flag,
                    Default = Colorpicker.Default,
                    Callback = Colorpicker.Callback,
                    Alpha = Colorpicker.Alpha
                })

                return NewColorpicker
            end

            function Label:Keybind(Data)
                Data = Data or {}

                local Keybind = {
                    Name = Data.Name or Label.Name,
                    Flag = Data.Flag or Data.Name or Label.Name,
                    Default = Data.Default or nil,
                    Callback = Data.Callback or function() end,
                    Mode = Data.Mode or "Toggle",
                    Window = Label.Window,
                    Page = Label.Page,
                    Section = Label.Section
                }

                local NewKeybind = Library:CreateKeybind({
                    Parent = Items.SubElements,
                    Name = Keybind.Name,
                    Page = Keybind.Page,
                    Section = Keybind.Section,
                    Flag = Keybind.Flag,
                    Default = Keybind.Default,
                    Mode = Keybind.Mode,
                    Callback = Keybind.Callback
                })

                return NewKeybind
            end

            return setmetatable(Label, Library)
        end

        Library.Textbox = function(Self, Params)
            Params = Params or {}

            local Textbox = {
                Name = Params.Name or "Textbox",
                Flag = Params.Flag or Params.Name or "Textbox",
                Default = Params.Default or "",
                Callback = Params.Callback or function() end,
                Finished = Params.Finished or false,
                Placeholder = Params.Placeholder or "",
                Numeric = Params.Numeric or false,
                MaxLength = Params.MaxLength or 64,
                Window = Self.Window,
                Page = Self.Page,
                Section = Self,
                Value = "",
                Items = {}
            }

            local Parent = Params.Parent or Textbox.Section.Items.Content

            local Items = {}
            do
                Items.Textbox = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Parent.Instance,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 42),
                    BorderSizePixel = 0
                })

                Items.Text = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.FontSemi,
                    TextSize = Library.FontSize,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = Items.Textbox.Instance,
                    TextColor3 = Library.Theme.Text,
                    Text = Textbox.Name,
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    Position = UDim2.new(0, 0, 0, 4),
                    AutomaticSize = Enum.AutomaticSize.XY
                })

                Items.Text:AddToTheme({TextColor3 = "Text"})

                Items.Outline = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items.Textbox.Instance,
                    Active = true,
                    AnchorPoint = Vector2.new(0, 1),
                    Position = UDim2.new(0, 0, 1, 0),
                    Size = UDim2.new(1, 0, 0, 20),
                    Selectable = true,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme.Border
                })

                Items.Outline:AddToTheme({BackgroundColor3 = "Border"})

                Items.Inline = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items.Outline.Instance,
                    Active = true,
                    Position = UDim2.new(0, 1, 0, 1),
                    Selectable = true,
                    Size = UDim2.new(1, -2, 1, -2),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme.Outline
                })

                Items.Inline:AddToTheme({BackgroundColor3 = "Outline"})

                Items.Background = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items.Inline.Instance,
                    ClipsDescendants = true,
                    Size = UDim2.new(1, -2, 1, -2),
                    Position = UDim2.new(0, 1, 0, 1),
                    Selectable = true,
                    Active = true,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme.Element
                })

                Items.Background:AddToTheme({BackgroundColor3 = "Element"})
                Items.Background:CreateGradient(90, {
                    Color3.fromRGB(255, 255, 255),
                    Color3.fromRGB(200, 200, 200)
                })

                Items.Background:OnHover(function()
                    Items.Background:Tween({BackgroundColor3 = Library.Theme.HoveredElement})
                end, function()
                    Items.Background:Tween({BackgroundColor3 = Library.Theme.Element})
                end)

                Items.Input = Library:Create("TextBox", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize - 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = Items.Background.Instance,
                    AnchorPoint = Vector2.new(0, 0.5),
                    PlaceholderColor3 = Library.Theme.TextDis,
                    PlaceholderText = Textbox.Placeholder,
                    Size = UDim2.new(1, -8, 0, 0),
                    TextColor3 = Library.Theme.Text,
                    Text = "",
                    Position = UDim2.new(0, 4, 0.5, -1),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    ClearTextOnFocus = false,
                    AutomaticSize = Enum.AutomaticSize.Y
                })

                Items.Input:AddToTheme({
                    TextColor3 = "Text",
                    PlaceholderColor3 = "TextDis"
                })

                Textbox.Items = Items
            end

            function Textbox:SetVisibility(Bool)
                Items.Textbox.Instance.Visible = Bool
            end

            function Textbox:SetText(Text)
                Items.Text.Instance.Text = tostring(Text)
            end

            function Textbox:Set(Value)
                if Textbox.Numeric and string.len(tostring(Value)) > 0 and not tonumber(Value) then
                    Value = Textbox.Value
                end

                if string.len(tostring(Value)) > Textbox.MaxLength then
                    Value = tostring(Value):sub(1, Textbox.MaxLength)
                end

                Textbox.Value = Value
                Items.Input.Instance.Text = Value
                Flags[Textbox.Flag] = Value

                Library:SafeCall(Textbox.Callback, Value)
            end

            if Textbox.Finished then
                Items.Input:Connect("FocusLost", function(EnterPressed)
                    if EnterPressed then
                        Textbox:Set(Items.Input.Instance.Text)
                    end
                end)
            else
                Items.Input:Connect("Changed", function(Property)
                    if Property == "Text" then
                        Textbox:Set(Items.Input.Instance.Text)
                    end
                end)
            end

            Textbox:Set(Textbox.Default)

            SetFlags[Textbox.Flag] = function(Value)
                Textbox:Set(Value)
            end

            return setmetatable(Textbox, Library)
        end

        Library.Separator = function(Self, Params)
            Params = Params or {}

            local Separator = {
                Window = Self.Window,
                Page = Self.Page,
                Section = Self,
                Items = {}
            }

            local Parent = Params.Parent or Separator.Section.Items.Content

            local Items = {}
            do
                Items.Separator = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Parent.Instance,
                    Size = UDim2.new(1, 0, 0, 1),
                    BackgroundColor3 = Library.Theme.Divider,
                    BorderSizePixel = 0
                })

                Items.Separator:AddToTheme({BackgroundColor3 = "Divider"})

                Separator.Items = Items
            end

            function Separator:SetVisibility(Bool)
                Items.Separator.Instance.Visible = Bool
            end

            return setmetatable(Separator, Library)
        end

        Library.Init = function(Self)
            local SettingsPage = Self:Page({Name = "Settings", Icon = "rbxassetid://7734083590"})

            local GeneralSection = SettingsPage:Section({Name = "General", Side = 1})

            GeneralSection:Label({Name = "Theme Presets"})

            local ThemeDropdown = GeneralSection:Dropdown({
                Name = "Theme",
                Flag = "ThemeSelector",
                Items = {"Modern", "Cyberpunk", "Navy", "Magma"},
                Default = "Modern",
                Callback = function(Value)
                    Library:SetThemePreset(Value)
                end
            })

            GeneralSection:Separator()

            GeneralSection:Label({Name = "Menu Settings"})

            GeneralSection:Button({
                Name = "Exit",
                Style = "Danger",
                Callback = function()
                    Library:Exit()
                end
            })

            GeneralSection:Label({Name = "Menu Keybind"}):Keybind({
                Name = "Menu Keybind",
                Flag = "MenuKeybind",
                Default = Library.MenuKeybind,
                Mode = "Toggle",
                Callback = function(Value)
                    Library.MenuKeybind = Library.Flags["MenuKeybind"].Key
                end
            })

            if Self.Watermark then
                GeneralSection:Toggle({
                    Name = "Watermark",
                    Flag = "Watermark",
                    Default = true,
                    Callback = function(Value)
                        Self.Watermark:SetVisibility(Value)
                    end
                })
            end

            if Self.KeybindList then
                GeneralSection:Toggle({
                    Name = "Keybind List",
                    Flag = "KeybindList",
                    Default = true,
                    Callback = function(Value)
                        Self.KeybindList:SetVisibility(Value)
                    end
                })
            end

            local ThemingSection = SettingsPage:Section({Name = "Theming", Side = 2})

            for Index, Value in Library.Theme do
                ThemingSection:Label({Name = Index}):Colorpicker({
                    Name = Index,
                    Flag = Index .. "Theming",
                    Default = Value,
                    Callback = function(Color)
                        Library.Theme[Index] = Color
                        Library:ChangeTheme(Index, Color)
                    end
                })
            end

            local ThemeSelected
            local ThemeName
            local ThemesFolder = Library.Directory .. Library.Folders.Themes .. "/"

            local ThemesDropdown = ThemingSection:Dropdown({
                Name = "Saved Themes",
                Flag = "SavedThemes",
                Default = "",
                Items = {},
                Callback = function(Value)
                    ThemeSelected = Value
                end
            })

            ThemingSection:Textbox({
                Name = "Theme Name",
                Flag = "ThemeName",
                Default = "",
                Placeholder = "Enter theme name",
                Callback = function(Value)
                    ThemeName = Value
                end
            })

            ThemingSection:Button({
                Name = "Save Theme",
                Callback = function()
                    if ThemeName and ThemeName ~= "" then
                        if isfile(ThemesFolder .. ThemeName .. ".json") then
                            Library:Notification("Theme '" .. ThemeName .. "' already exists", 3, Library.Theme.Warning)
                            return
                        end

                        writefile(ThemesFolder .. ThemeName .. ".json", Library:GetTheme())
                        Library:GetThemesList(ThemesDropdown)
                        Library:Notification("Theme '" .. ThemeName .. "' saved successfully", 3, Library.Theme.Success)
                    end
                end
            })

            ThemingSection:Button({
                Name = "Load Theme",
                Callback = function()
                    if ThemeSelected and ThemeSelected ~= "" then
                        local Path = ThemesFolder .. ThemeSelected .. ".json"
                        if not isfile(Path) then
                            Library:Notification("Theme not found", 3, Library.Theme.Error)
                            return
                        end

                        local Success = Library:LoadTheme(readfile(Path))
                        if Success then
                            Library:Notification("Theme '" .. ThemeSelected .. "' loaded", 3, Library.Theme.Success)
                        else
                            Library:Notification("Failed to load theme", 3, Library.Theme.Error)
                        end
                    end
                end
            })

            ThemingSection:Button({
                Name = "Delete Theme",
                Style = "Danger",
                Callback = function()
                    if ThemeSelected and ThemeSelected ~= "" then
                        local Path = ThemesFolder .. ThemeSelected .. ".json"
                        if not isfile(Path) then
                            Library:Notification("Theme not found", 3, Library.Theme.Error)
                            return
                        end

                        delfile(Path)
                        Library:GetThemesList(ThemesDropdown)
                        Library:Notification("Theme '" .. ThemeSelected .. "' deleted", 3, Library.Theme.Warning)
                    end
                end
            })

            Library:GetThemesList(ThemesDropdown)

            local ConfigName
            local ConfigSelected
            local ConfigsFolder = Library.Directory .. Library.Folders.Configs .. "/"

            local ConfigsSection = SettingsPage:Section({Name = "Configs", Side = 1})

            local ConfigsList = ConfigsSection:List({
                Name = "Configs",
                Flag = "ConfigsList",
                Items = {},
                Multi = false,
                Callback = function(Value)
                    ConfigSelected = Value
                end
            })

            ConfigsSection:Textbox({
                Name = "Config Name",
                Flag = "ConfigName",
                Placeholder = "Enter config name",
                Callback = function(Value)
                    ConfigName = Value
                end
            })

            ConfigsSection:Button({
                Name = "Save Config",
                Callback = function()
                    if ConfigName and ConfigName ~= "" then
                        local Path = ConfigsFolder .. ConfigName .. ".json"
                        if isfile(Path) then
                            Library:Notification("Config already exists", 3, Library.Theme.Warning)
                            return
                        end

                        writefile(Path, Library:GetConfig())
                        Library:GetConfigsList(ConfigsList)
                        Library:Notification("Config '" .. ConfigName .. "' saved", 3, Library.Theme.Success)
                    end
                end
            })

            ConfigsSection:Button({
                Name = "Load Config",
                Callback = function()
                    if ConfigSelected and ConfigSelected ~= "" then
                        local Path = ConfigsFolder .. ConfigSelected .. ".json"
                        if not isfile(Path) then
                            Library:Notification("Config not found", 3, Library.Theme.Error)
                            return
                        end

                        local Success = Library:LoadConfig(readfile(Path))
                        if Success then
                            Library:Notification("Config '" .. ConfigSelected .. "' loaded", 3, Library.Theme.Success)
                        else
                            Library:Notification("Failed to load config", 3, Library.Theme.Error)
                        end
                    end
                end
            })

            ConfigsSection:Button({
                Name = "Overwrite Config",
                Style = "Danger",
                Callback = function()
                    if ConfigSelected and ConfigSelected ~= "" then
                        local Path = ConfigsFolder .. ConfigSelected .. ".json"
                        if not isfile(Path) then
                            Library:Notification("Config not found", 3, Library.Theme.Error)
                            return
                        end

                        writefile(Path, Library:GetConfig())
                        Library:Notification("Config '" .. ConfigSelected .. "' overwritten", 3, Library.Theme.Success)
                    end
                end
            })

            ConfigsSection:Button({
                Name = "Delete Config",
                Style = "Danger",
                Callback = function()
                    if ConfigSelected and ConfigSelected ~= "" then
                        local Path = ConfigsFolder .. ConfigSelected .. ".json"
                        if not isfile(Path) then
                            Library:Notification("Config not found", 3, Library.Theme.Error)
                            return
                        end

                        delfile(Path)
                        Library:GetConfigsList(ConfigsList)
                        Library:Notification("Config '" .. ConfigSelected .. "' deleted", 3, Library.Theme.Warning)
                    end
                end
            })

            Library:GetConfigsList(ConfigsList)

            local AutoloadSection = SettingsPage:Section({Name = "Autoload", Side = 2})

            AutoloadSection:Button({
                Name = "Set Selected as Autoload",
                Callback = function()
                    if ConfigSelected and ConfigSelected ~= "" then
                        local Path = ConfigsFolder .. ConfigSelected .. ".json"
                        if not isfile(Path) then
                            Library:Notification("Config not found", 3, Library.Theme.Error)
                            return
                        end

                        writefile(Library.Directory .. "/autoload.json", readfile(Path))
                        Library:Notification("'" .. ConfigSelected .. "' set as autoload", 3, Library.Theme.Success)
                    end
                end
            })

            AutoloadSection:Button({
                Name = "Remove Autoload",
                Style = "Danger",
                Callback = function()
                    writefile(Library.Directory .. "/autoload.json", "")
                    Library:Notification("Autoload removed", 3, Library.Theme.Warning)
                end
            })

            AutoloadSection:Button({
                Name = "Load Autoload",
                Callback = function()
                    local Content = readfile(Library.Directory .. "/autoload.json")
                    if Content and Content ~= "" then
                        local Success = Library:LoadConfig(Content)
                        if Success then
                            Library:Notification("Autoload loaded successfully", 3, Library.Theme.Success)
                        else
                            Library:Notification("Failed to load autoload", 3, Library.Theme.Error)
                        end
                    else
                        Library:Notification("No autoload set", 3, Library.Theme.Warning)
                    end
                end
            })

            local AutoloadContent = readfile(Library.Directory .. "/autoload.json")
            if AutoloadContent and AutoloadContent ~= "" then
                Library:LoadConfig(AutoloadContent)
            end
        end
    end
end

getgenv().Library = Library
return Library
