-- Slate.lua - Port of slate window management configuration

--[[
  This configuration ports features from the popular Slate window manager.
  It provides a comprehensive set of keyboard shortcuts for resizing,
  moving, and focusing windows, as well as moving them between displays.
--]]

-- ===================================================================
-- Push windows to screen edges
-- ===================================================================

-- push to a fraction of the screen horizontally
function pushHorizontal(x_offset, width_ratio)
  return function()
    local win = hs.window.focusedWindow()
    if not win then return end
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x + (max.w * x_offset)
    f.w = max.w * width_ratio

    win:setFrame(f)
  end
end

-- push to a fraction of the screen vertically
function pushVertical(y_offset, height_ratio)
    return function()
        local win = hs.window.focusedWindow()
        if not win then return end
        local f = win:frame()
        local screen = win:screen()
        local max = screen:frame()

        f.y = max.y + (max.h * y_offset)
        f.h = max.h * height_ratio
        win:setFrame(f)
    end
end

-- Push Bindings (thirds)
-- ctrl-cmd-h: left third
hs.hotkey.bind({"ctrl", "cmd"}, "h", pushHorizontal(0, 1/3))
-- ctrl-cmd-l: right third
hs.hotkey.bind({"ctrl", "cmd"}, "l", pushHorizontal(2/3, 1/3))

-- Push Bindings (halves)
-- ctrl-cmd-k: top half
hs.hotkey.bind({"ctrl", "cmd"}, "k", pushVertical(0, 1/2))
-- ctrl-cmd-j: bottom half
hs.hotkey.bind({"ctrl", "cmd"}, "j", pushVertical(0.5, 1/2))

-- Push Bindings / 3 (with shift)
-- ctrl-cmd-shift-h: left third
hs.hotkey.bind({"ctrl", "cmd", "shift"}, "h", pushHorizontal(0, 1/3))
-- ctrl-cmd-shift-l: right third
hs.hotkey.bind({"ctrl", "cmd", "shift"}, "l", pushHorizontal(2/3, 1/3))
-- ctrl-cmd-shift-k: top third
hs.hotkey.bind({"ctrl", "cmd", "shift"}, "k", pushVertical(0, 1/3))
-- ctrl-cmd-shift-j: bottom third
hs.hotkey.bind({"ctrl", "cmd", "shift"}, "j", pushVertical(2/3, 1/3))


-- ===================================================================
-- Resizing
-- ===================================================================

function resizeWindow(w_offset, h_offset)
  return function()
    local win = hs.window.focusedWindow()
    if not win then return end
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.w = f.w + (max.w * w_offset)
    f.h = f.h + (max.h * h_offset)

    win:setFrame(f)
  end
end

-- alt-l: wider
hs.hotkey.bind({"alt"}, "l", resizeWindow(0.1, 0))
-- alt-h: narrower
hs.hotkey.bind({"alt"}, "h", resizeWindow(-0.1, 0))
-- alt-k: shorter
hs.hotkey.bind({"alt"}, "k", resizeWindow(0, -0.1))
-- alt-j: taller
hs.hotkey.bind({"alt"}, "j", resizeWindow(0, 0.1))

function resizeWindowAnchoredBottomRight(w_offset, h_offset)
  return function()
    local win = hs.window.focusedWindow()
    if not win then return end
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    local w_change = max.w * w_offset
    local h_change = max.h * h_offset

    f.x = f.x - w_change
    f.y = f.y - h_change
    f.w = f.w + w_change
    f.h = f.h + h_change

    win:setFrame(f)
  end
end

-- ctrl-alt-l: narrower (from bottom right)
hs.hotkey.bind({"ctrl", "alt"}, "l", resizeWindowAnchoredBottomRight(-0.1, 0))
-- ctrl-alt-h: wider (from bottom right)
hs.hotkey.bind({"ctrl", "alt"}, "h", resizeWindowAnchoredBottomRight(0.1, 0))
-- ctrl-alt-k: taller (from bottom right)
hs.hotkey.bind({"ctrl", "alt"}, "k", resizeWindowAnchoredBottomRight(0, 0.1))
-- ctrl-alt-j: shorter (from bottom right)
hs.hotkey.bind({"ctrl", "alt"}, "j", resizeWindowAnchoredBottomRight(0, -0.1))


-- ===================================================================
-- Centering
-- ===================================================================

-- ctrl-cmd-c: center third
hs.hotkey.bind({"ctrl", "cmd"}, "c", pushHorizontal(1/3, 1/3))

-- ===================================================================
-- Nudging (moving without resizing)
-- ===================================================================

function nudgeWindow(x_offset, y_offset)
    return function()
        local win = hs.window.focusedWindow()
        if not win then return end
        local f = win:frame()
        local screen = win:screen()
        local max = screen:frame()

        f.x = f.x + (max.w * x_offset)
        f.y = f.y + (max.h * y_offset)

        win:setFrame(f)
    end
end

-- shift-alt-l: nudge right
hs.hotkey.bind({"shift", "alt"}, "l", nudgeWindow(0.1, 0))
-- shift-alt-h: nudge left
hs.hotkey.bind({"shift", "alt"}, "h", nudgeWindow(-0.1, 0))
-- shift-alt-k: nudge up
hs.hotkey.bind({"shift", "alt"}, "k", nudgeWindow(0, -0.1))
-- shift-alt-j: nudge down
hs.hotkey.bind({"shift", "alt"}, "j", nudgeWindow(0, 0.1))


-- ===================================================================
-- Throwing windows between screens
-- ===================================================================

function moveWindowToDisplay(d)
    return function()
      local win = hs.window.focusedWindow()
      local screen = hs.screen.allScreens()[d]
      if not (win and screen) then return end

      win:moveToScreen(screen)

      -- After moving, resize to fit screen height while preserving width and horizontal position
      local frame = win:frame()
      local screenFrame = screen:frame()
      frame.y = screenFrame.y
      frame.h = screenFrame.h
      win:setFrame(frame)
    end
end

-- ctrl-alt-1/2/3: throw to display 1/2/3
hs.hotkey.bind({"ctrl", "alt"}, "1", moveWindowToDisplay(1))
hs.hotkey.bind({"ctrl", "alt"}, "2", moveWindowToDisplay(2))
hs.hotkey.bind({"ctrl", "alt"}, "3", moveWindowToDisplay(3))

function throwToNextScreen(direction)
    return function()
        local win = hs.window.focusedWindow()
        if not win then return end
        if direction == "right" then
            win:moveOneScreenEast(true, true)
        elseif direction == "left" then
            win:moveOneScreenWest(true, true)
        elseif direction == "up" then
            win:moveOneScreenNorth(true, true)
        elseif direction == "down" then
            win:moveOneScreenSouth(true, true)
        end
    end
end

-- ctrl-alt-cmd-l/h/k/j: throw to next screen in direction
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "l", throwToNextScreen("right"))
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "h", throwToNextScreen("left"))
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "k", throwToNextScreen("up"))
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "j", throwToNextScreen("down"))


-- ===================================================================
-- Focusing windows
-- ===================================================================

function focusDirection(direction)
    return function()
        if direction == "right" then
            hs.window.focusWindowEast()
        elseif direction == "left" then
            hs.window.focusWindowWest()
        elseif direction == "behind" then
            local windows = hs.window.orderedWindows()
            if #windows > 1 then
                -- orderedWindows() returns windows on the current space, front-to-back
                -- so the 2nd window is the one behind the focused one.
                windows[2]:focus()
            end
        end
    end
end

-- cmd-alt-l/h: focus right/left
hs.hotkey.bind({"cmd", "alt"}, "l", focusDirection("right"))
hs.hotkey.bind({"cmd", "alt"}, "h", focusDirection("left"))
-- cmd-alt-k/j: focus behind
hs.hotkey.bind({"cmd", "alt"}, "k", focusDirection("behind"))
hs.hotkey.bind({"cmd", "alt"}, "j", focusDirection("behind"))


-- ===================================================================
-- Window Hints
-- ===================================================================

-- cmd-esc: show window hints
hs.hotkey.bind({"cmd"}, "escape", hs.hints.windowHints)


-- ===================================================================
-- Fullscreen
-- ===================================================================

-- ctrl-cmd-f: fullscreen
hs.hotkey.bind({"ctrl", "cmd"}, "f", function()
    local win = hs.window.focusedWindow()
    if not win then return end
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()
    f.x = max.x
    f.y = max.y
    f.w = max.w
    f.h = max.h
    win:setFrame(f)
end)

--[[
  Original init.lua content has been ported and replaced.
  The following bindings from the original file have been changed or replaced:
  - {"cmd", "ctrl"}, "H" -> {"ctrl", "cmd"}, "h" (push left)
  - {"cmd", "ctrl"}, "L" -> {"ctrl", "cmd"}, "l" (push right)
  - {"cmd", "ctrl"}, "C" -> new centering logic
  - {"cmd", "ctrl"}, "F" -> {"ctrl", "cmd"}, "f" (fullscreen)
  - {"ctrl", "cmd"}, "k" -> push top half (was move to display 1)
  - {"ctrl", "cmd"}, "j" -> push bottom half (was move to display 2)
]]