CONFIG = {}

function love.conf(t)
    t.window.title = "RATS"
    t.window.icon = "assets/sprites/small/hero.png" -- Filepath to an image to use as the windows icon (string)
    t.window.width = 1280                           -- The window width (number)
    t.window.height = 1024                          -- The window height (number)
    t.window.resizable = false                      -- Let the window be user-resizable (boolean)
    t.window.vsync = 0                              -- Vertical sync mode (number)
    t.debug = false                                 -- Enable debug mode
    CONFIG = t
    CONFIG.GodMod = false
end
