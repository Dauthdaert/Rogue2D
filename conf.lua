function love.conf(t)
    t.console = false                   -- Attach a console (boolean, Windows only)
 
    t.window.title = "Rogue2D"         -- The window title (string)
    t.window.icon = nil                 -- Filepath to an image to use as the window's icon (string)
    t.window.width = 800                -- The window width (number)
    t.window.height = 600               -- The window height (number)
    t.window.borderless = false         -- Remove all border visuals from the window (boolean)
    t.window.resizable = false          -- Let the window be user-resizable (boolean)
    t.window.fullscreen = false         -- Enable fullscreen (boolean)
    t.window.vsync = 1                  -- Vertical sync mode (number)
 
    t.modules.audio = true
    t.modules.data = true
    t.modules.event = true
    t.modules.joystick = false
    t.modules.math = true
    t.modules.mouse = true
    t.modules.physics = false
    t.modules.sound = true
    t.modules.system = false
    t.modules.thread = false
    t.modules.touch = false
    t.modules.video = false
end