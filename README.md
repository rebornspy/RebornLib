# RebornLibExec

## Getting Started
To use this library, you first need to load it. Paste this line at the top of your script to load RebornLib.

```lua
local RebornLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/rebornspy/RebornLib/refs/heads/main/RebornLibExec.lua"))()
```

## Making a Window
To make a window, use the method RebornLib:CreateWindow({})

Example:
```lua
local ExampleWindow = RebornLib:CreateWindow({ -- ExampleWindow is the name you will reference to add tabs.
    Name = "Example Window",    -- Name of the window in the explorer, not very useful
    BootTitle = "Boot Name",    -- Title displayed on the boot window
    MainTitle = "Main Name",    -- Title displayed on the main window
    Theme = "Default"           -- Theme used for the UI, can be one of many packaged themes, I'll add the ability to make custom themes in a future update.
})
```

## Creating a Tab
To make a tab, use the method Window:CreateTab({})

Example:
```lua
local ExampleTab = Window:CreateTab({   -- ExampleTab is the name you will reference to add elements.
    Name = "Example Tab"        -- Title displayed on the tab
})
```
or
```lua
local ExampleTab = Window:CreateTab({ Name = "Example Tab" }) -- Same thing as the other one but in one line.
```

## Creating a Section
To create a section, use the method Tab:CreateSection({})

Example:
```lua
local ExampleSection = Tab:CreateSection({
    Name = "ExampleSection"             -- Title displayed in the content area
})
```
or
```lua
local ExampleSection = Tab:CreateSection({ Name = "Example Section" }) -- Same thing as the other one but in one line.
```

## Creating Content
There are many different components you can create in the content.
List of Current Elements:
- Button
- Toggle
- Slider
- Text Input
- Note
- Dropdown
- Player Dropdown

Creating a Button:
```lua
Section:CreateButton({
    Name = "Button",     -- Displayed name of the button
    Callback = function()
    -- Script for the button to execute goes here
    end,
})
```

Creating a Toggle:
```lua
Section:CreateToggle({
    Name = "Toggle",     -- Displayed name of the toggle
    Default = False,     -- Default state of the toggle
    Callback = function(state)
    -- Toggle logic goes here
    end,
})
```

Creating a Slider:
```lua
Section:CreateSlider({
    Name = "Slider",    -- Displayed name of the slider
    Default = 5,        -- Default value of the slider
    Step = 1,           -- Step value
    Min = 0,            -- Minimum value
    Max = 10,           -- Maximum value
    Callback = function(value)
    -- Slider logic goes here
    end,
})
```

Creating a Text Input:
```lua
Section:CreateInput({
    Name = "Input",     -- Displayed name of the Input
    Placeholder = "Input",   -- Displayed text when user is typing
    Default = "",        -- Displayed text when Input is empty
    Callback = function(text)
    -- Input logic goes here
    end,
})
```

Creating a Note:
```lua
Section:CreateNote({
    Text = "Note"   -- Text displayed
})
```

Creating a Dropdown:
```lua
Section:CreateDropdown({
    Name = "Dropdown",  -- Displayed name of the Dropdown
    Options = {         -- Option list, can be however many you need
        "Option 1",     -- List option 1
        "Option 2",     -- List option 2
        "Option 3",     -- List option 3
        -- etc. for however many options you want
    },
    Default = "Pick an Option",
    Callback = function(opt)
    -- Dropdown logic goes here
    end,
})
```

Creating a Player Dropdown:
```lua
Section:CreatePlayerDropdown({
    Name = "Players",
    Default = "Select",
    Callback = function(playerObj, playerName)
    -- Dropdown logic goes here
})
```

## Notifying the User
To create/attach a notification, use the method :Notify({})

Example:
```lua
Section:CreateButton({
    Name = "Notification",
    Callback = function()
        Window:Notify({
            Title = "Title",        -- Displayed text in the title section of the notification
            Content = "Content",    -- Displayed text in the contents section of the notification
            Duration = 2.5,         -- Duration of the notification
        })
    end,
})
```

## Themes
You can choose from a selection of premade themes with custom theme support coming in the future.
List of current themes:
- Default
- Blood Moon
- Acid Trip
- Cerulean Wave
- Deep Forest
- Monochrome
- Red Stained Glass

More premade themes coming, as well as custom theme support

## Example Script:
```lua
local RebornLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/rebornspy/RebornLib/refs/heads/main/RebornLibExec.lua"))()

local Window = RebornLib:CreateWindow({
    Name = "Example Window",
    BootTitle = "Boot",
    MainTitle = "Main",
    Theme = "Deep Forest"
})

local Tab = Window:CreateTab({ Name = "Example Tab" })

local Section = Tab:CreateSection({ Name = "Example Section" })

Section:CreateButton({
    Name = "Notification",
    Callback = function()
        Window:Notify({
            Title = "Button Pressed",
            Content = "The Button has been pressed",
            Duration = 2.5,
        })
    end,
})

Section:CreateToggle({
    Name = "Toggle",
    Default = False,
    Callback = function(state)
        print("Toggled to:", state)
    end,
})

Section:CreateSlider({
    Name = "Slider",
    Default = 5,
    Step = 1,
    Min = 0,
    Max = 10,
    Callback = function(value)
        print("Changed slider to:", value)
    end,
})

Section:CreateInput({
    Name = "Input",
    Placeholder = "Input"
    Default = ""
    Callback = function(text)
        print("Changed text to:", text)
    end,
})

Section:CreateNote({
    Text = "Note"
})

Section:CreateDropdown({
    Name = "Dropdown",
    Options = {
        "Option 1",
        "Option 2",
        "Option 3",
    },
    Default = "Pick an Option",
    Callback = function(opt)
        print("Changed selection to:", opt)
    end,
})

Section:CreatePlayerDropdown({
    Name = "Players"
    Default = "Select"
    Callback = function(playerObj, playerName)
        print("Selected Player:", playerName, playerObj)
})

```