-- push to the left of screen
hs.hotkey.bind({"cmd", "ctrl"}, "H", function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()
    f.x = max.x
    f.y = max.y
    f.w = max.w / 2
    f.h = max.h
    win:setFrame(f)
end)

-- push to the right of screen
hs.hotkey.bind({"cmd", "ctrl"}, "L", function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()
    f.x = max.x + (max.w / 2)
    f.y = max.y
    f.w = max.w / 2
    f.h = max.h
    win:setFrame(f)
end)

-- center
hs.hotkey.bind({"cmd", "ctrl"}, "C", function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()
    f.x = max.x + (max.w / 4)
    f.y = max.y
    f.w = max.w / 2
    f.h = max.h
    win:setFrame(f)
end)

-- fullscreen
hs.hotkey.bind({"cmd", "ctrl"}, "F", function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()
    f.x = max.x
    f.y = max.y
    f.w = max.w
    f.h = max.h
    win:setFrame(f)
end)

function moveWindowToDisplay(d)
    return function()
      local displays = hs.screen.allScreens()
      local win = hs.window.focusedWindow()
      win:moveToScreen(displays[d], false, true)
    end
  end
  
  hs.hotkey.bind({"ctrl", "cmd"}, "k", moveWindowToDisplay(1))
  hs.hotkey.bind({"ctrl", "cmd"}, "j", moveWindowToDisplay(2))