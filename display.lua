-- requires
local defaults = {
  turtleX = 39,
  turtleY = 13,
}

local ccolors = {}
for k, v in pairs(colors) do
  ccolors[k] = v
  ccolors[v] = k
end
for k, v in pairs(colours) do
  ccolors[k] = v
  ccolors[v] = k
end


local function dread(def)
  def = def or ""
  local pos = string.len(def) + 1
  local sx, sy = term.getCursorPos()
  local mx = term.getSize()
  local ins = false
  local tmr = -1
  local bOn = false

  term.setCursorBlink(true)

  while true do
    -- draw --

    -- clear until end of line
    term.setCursorPos(sx, sy)
    io.write(string.rep(' ', mx - sx + 1))
    -- write what we've got
    term.setCursorPos(sx, sy)
    local pss = pos - (mx - sx + 1)
    if pss >= 0 then
      io.write(string.sub(def, pss + 1))
    else
      io.write(def)
    end
    -- set cursor to our cursor's position
    local psss = sx + pos - 1
    if psss > mx then
      psss = mx
    end
    term.setCursorPos(psss, sy)
    -- if insert mode, blink full cursor
    if bOn then
      local o = term.getBackgroundColor()
      term.setBackgroundColor(colors.white)
      io.write(' ')
      term.setBackgroundColor(o)
    end

    -- get user input --
    local ev = {os.pullEvent()}
    local event = ev[1]

    if event == "char" then
      local char = ev[2]

      -- insert character into string
      -- depending on read mode
      if ins then
        def = string.sub(def, 1, pos - 1) .. char .. string.sub(def, pos + 1)
      else
        def = string.sub(def, 1, pos - 1) .. char .. string.sub(def, pos)
      end
      -- move cursor right 1 position
      pos = pos + 1
    elseif event == "key" then
      local key = ev[2]

      if key == keys.backspace then
        local ps = pos - 2

        if pos - 2 < 0 then
          ps = 0
        end

        def = string.sub(def, 1, ps) .. string.sub(def, pos)
        pos = pos - 1
        if pos < 1 then
          pos = 1
        end
      elseif key == keys.enter then
        term.setCursorBlink(false)
        print()
        return def
      elseif key == keys.right then
        pos = pos + 1
        if pos > string.len(def) + 1 then
          pos = string.len(def) + 1
        end
      elseif key == keys.left then
        pos = pos - 1
        if pos < 1 then
          pos = 1
        end
      elseif key == keys.up then
        pos = 1
      elseif key == keys.down then
        pos = string.len(def) + 1
      elseif key == keys.delete then
        def = string.sub(def, 1, pos - 1) .. string.sub(def, pos + 1)
      elseif key == keys.insert then
        if ins then
          ins = false
          term.setCursorBlink(true)
          os.cancelTimer(tmr)
          tmr = -1
          bOn = false
        else
          ins = true
          term.setCursorBlink(false)
          tmr = os.startTimer(0.4)
        end
      end
    elseif event == "timer" then
      local tm = ev[2]
      if tm == tmr then
        bOn = not bOn
        tmr = os.startTimer(0.4)
      end
    end
  end
end

-- create error if variable a is not of type b
local function cerr(a, b, err, lvl)
  if type(a) ~= b then
    error(err .. " (expected " .. b .. ", got " .. type(a) .. ")",
          lvl and lvl + 1 or 3)
  end
end

-- create error if length of string 'a' is greater than a max 'b'
local function clen(a, b, name, lvl)
  if type(a) ~= "string" then error("Check failure: not string", 2) end
  if string.len(a) > b then
    error("Page layout string " .. name .. " is too long (max: " .. tostring(b)
          .. ", at: " .. tostring(string.len(a)) .. ")", lvl and lvl + 1 or 3)
  end
end

-- check the page for errors
local function checkPage(page)
  -- the readability of this function is horrifying

  -- length of titles/pagenames: 12
  -- length of infos:            25
  -- length of bigInfos:         defX * 3


  cerr(page, "table", "Page layout is not a table.")

  cerr(page.name, "string", "Page: name is of wrong type.")
  clen(page.name, 12, "page.name")

  local errString = "Page " .. page.name .. ": %s is of wrong type."

  cerr(page.info, "string", string.format(errString, "info"))
  clen(page.info, 25, "page.info")

  cerr(page.bigInfo, "string", string.format(errString, "bigInfo"))
  clen(page.bigInfo, defaults.turtleX * 3 - 10, "page.bigInfo")

  cerr(page.colors, "table", string.format(errString, "colors"))
  cerr(page.colors.bg, "table", string.format(errString, "colors.bg"))
  local exp = {"main"}
  for i = 1, #exp do
    cerr(page.colors.bg[exp[i]], "string", string.format(errString, "colors.bg." .. exp[i]))
  end
  cerr(page.colors.fg, "table", string.format(errString, "colors.fg"))
  exp = {"main", "title", "info", "listInfo", "listTitle", "bigInfo", "selector", "arrowDisabled", "arrowEnabled", "input"}
  for i = 1, #exp do
    cerr(page.colors.fg[exp[i]], "string", string.format(errString, "colors.fg." .. exp[i]))
  end

  if page.selections then
    for i = 1, #page.selections do
      local cur = page.selections[i]
      local errorString = "Page " .. page.name .. ", selection " .. tostring(i) .. ": %s is of wrong type."
      local lenString = "page.settings[" .. tostring(i) .. "].%s"

      cerr(cur.title, "string", string.format(errorString, "title"))
      clen(cur.title, 12, string.format(lenString, "title"))

      cerr(cur.info, "string", string.format(errorString, "info"))
      clen(cur.info, 25, string.format(lenString, "info"))

      cerr(cur.bigInfo, "string", string.format(errorString, "bigInfo"))
      clen(cur.bigInfo, defaults.turtleX * 3 - 10, string.format(lenString, "bigInfo"))
    end
  else
    page.selections = {}
  end

  if page.settings then
    for i = 1, #page.settings do
      local cur = page.settings[i]
      local errorString = "Page " .. page.name .. ", setting " .. tostring(i) .. ": %s is of wrong type."
      local lenString = "page.settings[" .. tostring(i) .. "].%s"

      cerr(cur.title, "string", string.format(errorString, "title"))
      clen(cur.title, 12, "title")

      cerr(cur.bigInfo, "string", string.format(errorString, "bigInfo"))
      clen(cur.bigInfo, defaults.turtleX * 3 - 10, string.format(lenString, "bigInfo"))

      cerr(cur.setting, "string", string.format(errorString, "setting"))

      cerr(cur.tp, "string", string.format(errorString, "tp"))
      if cur.min then
        cerr(cur.min, "number", string.format(errorString, "min"))
      end
      if cur.max then
        cerr(cur.max, "number", string.format(errorString, "max"))
      end
    end
  else
    page.settings = {}
  end

  if page.subPages then
    -- ONLY CHECK TOPMOST SUBPAGE, DON'T RECURSIVE CHECK
    for i = 1, #page.subPages do
      local cur = page.subPages[i]

      cerr(cur.name, "string", string.format("Subpage %d: name is of wrong type.", i))
      cerr(cur.info, "string", string.format("Subpage %s: info is of wrong type.", cur.name))
    end
  else
    page.subPages = {}
  end
end

-- returns:
-- 1: number 0, 1, 2, 3 (0:empty, 1:selection, 2:setting, 3:subpage)
-- 2: table item or nil
local function iter(obj, i)
  local sels = #obj.selections
  local sets = #obj.settings
  local subs = #obj.subPages
  if i > sels then
    if i > sels + sets then
      -- if the last, return final object
      if i == sels + sets + subs + 1 then
        return 1, {title = obj.final or "Exit", info = "", bigInfo = ""}
      end
      -- if past the last, return 0
      if i > sels + sets + subs then
        return 0
      end
      -- return a subpage
      return 3, obj.subPages[i - sels - sets]
    end
    -- return a setting
    return 2, obj.settings[i - sels]
  end
  -- return a selection
  return 1, obj.selections[i]
end

-- return the size of the objects selections/settings/subPages together
local function size(obj)
  return #obj.selections + #obj.settings + #obj.subPages
end

local function readNumber(obj, set, p)
  local str = tostring(settings.get(set.setting))
  local mx, my = term.getSize()

  if str == "nil" then str = "0" end

  while true do
    term.setCursorPos(15, 4 + p)
    io.write(string.rep(' ', mx - 14))
    term.setCursorPos(15, 4 + p)
    local inp = tonumber(dread(str))

    if not inp then
      -- NaN
      term.setCursorPos(15, 4 + p)
      io.write(string.rep(' ', mx - 14))
      term.setCursorPos(15, 4 + p)
      io.write("Not a number.")
      os.sleep(2)
    else
      local ok = true
      -- check if number is below min
      if set.min and inp < set.min then
        ok = false
        term.setCursorPos(15, 4 + p)
        io.write(string.rep(' ', mx - 14))
        term.setCursorPos(15, 4 + p)
        io.write(string.format("Minimum: %d", set.min))
        str = tostring(set.min)
      end

      -- check if number is above max
      if set.max and inp > set.max then
        ok = false
        term.setCursorPos(15, 4 + p)
        io.write(string.rep(' ', mx - 14))
        term.setCursorPos(15, 4 + p)
        io.write(string.format("Maximum: %d", set.max))
        str = tostring(set.max)
      end

      if ok then
        return inp
      else
        os.sleep(2)
      end
    end
  end
end

local function readColor(obj, set, p)
  local str = tostring(ccolors[settings.get(set.setting)])
  local mx, my = term.getSize()

  if str == "nil" then str = "?" end

  while true do
    term.setCursorPos(15, 4 + p)
    io.write(string.rep(' ', mx - 14))
    term.setCursorPos(15, 4 + p)
    local inp = dread(str)
    local ninp = tonumber(inp)

    if ninp then
      -- number input
      if ccolors[ninp] then
        return ninp
      else
        term.setCursorPos(15, 4 + p)
        io.write(string.rep(' ', mx - 14))
        term.setCursorPos(15, 4 + p)
        io.write("Not a color.")
        os.sleep(2)
      end
    else
      -- color-name input
      if ccolors[inp] then
        return ccolors[inp]
      else
        term.setCursorPos(15, 4 + p)
        io.write(string.rep(' ', mx - 14))
        term.setCursorPos(15, 4 + p)
        io.write("Not a color.")
        os.sleep(2)
      end
    end
  end
end

-- ask the user if they are sure they want to edit the password
local function askPass(obj, set, p)
  local mx, my = term.getSize()
  local affirm = false

  term.setTextColor(ccolors[obj.colors.fg.listTitle])

  term.setCursorPos(2, 4 + p)
  io.write(string.rep(' ', mx - 1))
  term.setCursorPos(2, 4 + p)
  io.write("You sure?")


  while true do
    term.setCursorPos(15, 4 + p)
    io.write(string.rep(' ', mx - 14))
    term.setCursorPos(15, 4 + p)
    io.write(affirm and "[ YES ] NO" or "  YES [ NO ]")

    local ev, key = os.pullEvent("key")

    if key == keys.right or key == keys.left or key == keys.tab then
      affirm = not affirm
    elseif key == keys.enter then
      return affirm
    end
  end
end

-- edit the setting at index i, in terminal position p
local function edit(obj, i, p)
  local mx, my = term.getSize()
  local tp, set = iter(obj, i)
  if tp ~= 2 then
    error("Dawg something happened!", 2)
  end

  term.setCursorPos(15, 4 + p)
  term.setTextColor(colors[obj.colors.fg.input])

  -- handle the editing
  if set.tp == "string" then
    -- get a string input, with the input starting with the currently set setting
    settings.set(set.setting, dread(settings.get(set.setting)))
    settings.save(obj.settings.location)
  elseif set.tp == "number" then
    local inp = readNumber(obj, set, p)

    settings.set(set.setting, inp)
    settings.save(obj.settings.location)
  elseif set.tp == "color" then
    local col = readColor(obj, set, p)

    settings.set(set.setting, col)
    settings.save(obj.settings.location)
  elseif set.tp == "boolean" then
    local sete = settings.get(set.setting)
    if sete == nil then
      sete = true
    else
      sete = not sete
    end
    settings.set(set.setting, sete)
    settings.save(obj.settings.location)
  elseif set.tp == "password" then
    if askPass(obj, set, p) then
      settings.set(set.setting, getPass(obj, set, p))
      settings.save(obj.settings.location)
    end
  else
    io.write(string.format("Cannot edit type '%s'.", set.tp))
    os.sleep(2)
  end
end

-- display the page
local function display(obj)
  -- DEVNOTE: colors "push" themselves downstream

  local sel = 1
  local pointer = 1
  local pStart = 1
  local over = {}

  -- check that the page is OK
  checkPage(obj)
  if not obj.settings.location then
    obj.settings.location = ".settings"
  end

  settings.load(obj.settings.location)

  while true do
    -- clear
    term.setBackgroundColor(colors[obj.colors.bg.main])
    term.setTextColor(colors[obj.colors.fg.title])
    term.clear()

    -- display the page title
    term.setCursorPos(1, 1)
    io.write(obj.name)

    -- display the page info
    term.setCursorPos(1, 2)
    term.setTextColor(colors[obj.colors.fg.info])
    io.write(obj.info)

    -- display the four items.
    for i = 0, 3 do
      local ctype, cur = iter(obj, pStart + i)
      term.setCursorPos(2, 5 + i)

      -- discriminate by type
      if ctype == 1 then
        -- selection
        term.setTextColor(colors[obj.colors.fg.listTitle])
        io.write(cur.title)

        term.setCursorPos(15, 5 + i)
        term.setTextColor(colors[obj.colors.fg.listInfo])
        io.write(cur.info)
      elseif ctype == 2 then
        -- setting changer
        local set = settings.get(cur.setting)
        if type(set) == "string" and string.len(set) > 25 then
          set = set:sub(1, 22)
          set = set .. "..."
        end

        term.setTextColor(colors[obj.colors.fg.listTitle])
        io.write(cur.title)

        term.setCursorPos(15, 5 + i)
        term.setTextColor(colors[obj.colors.fg.listInfo])
        if cur.tp == "string" or cur.tp == "number" then
          io.write(set or "Error: empty")
        elseif cur.tp == "boolean" then
          if set == true then
            io.write("  false [ true ]")
          elseif set == false then
            io.write("[ false ] true")
          else
            -- nil or broke
            io.write("? false ? true ?")
          end
        elseif cur.tp == "color" then
          io.write(set and string.format("%s (%d)", ccolors[set], set)
                   or "? (nil)")
        else
          io.write("Unsupported type.")
        end
      elseif ctype == 3 then
        -- subpage selection
        term.setTextColor(colors[obj.colors.fg.listTitle])
        io.write(cur.name)

        term.setTextColor(colors[obj.colors.fg.listInfo])
        term.setCursorPos(15, 5 + i)
        io.write(cur.info)
      elseif ctype ~= 0 then
        io.write("Broken.")
      end
    end

    -- get the selected item
    local seltp, selected = iter(obj, sel)

    -- print the info of the selected item
    term.setTextColor(colors[obj.colors.fg.bigInfo])
    term.setCursorPos(1, defaults.turtleY - 2)
    io.write(selected.bigInfo)

    -- print the pointer
    term.setCursorPos(1, 4 + pointer)
    term.setTextColor(colors[obj.colors.fg.selector])
    io.write(">")

    -- draw down arrow
    term.setCursorPos(1, 9)
    if pStart + 3 >= size(obj) + 1 then
      term.setTextColor(colors[obj.colors.fg.arrowDisabled])
    else
      term.setTextColor(colors[obj.colors.fg.arrowEnabled])
    end
    io.write(string.char(31))

    -- draw up arrow
    term.setCursorPos(1, 4)
    if pStart > 1 then
      term.setTextColor(colors[obj.colors.fg.arrowEnabled])
    else
      term.setTextColor(colors[obj.colors.fg.arrowDisabled])
    end
    io.write(string.char(30))

    local ev, key = os.pullEvent("key")
    if key == keys.up then
      sel = sel - 1
      if pointer == 1 then
        pStart = pStart - 1
      end
      if pStart < 1 then
        pStart = 1
      end
      pointer = pointer - 1
      if pointer < 1 then
        pointer = 1
      end
      if sel < 1 then
        sel = size(obj) + 1
        pointer = (size(obj) + 1) < 4 and (size(obj) + 1) or 4
        pStart = sel - 3
        if pStart < 1 then
          pStart = 1
        end
      end
    elseif key == keys.down then
      sel = sel + 1
      if pointer == 4 then
        pStart = pStart + 1
      end
      pointer = pointer + 1
      if pointer > 4 then
        pointer = 4
      end
      if sel > size(obj) + 1 then
        sel = 1
        pStart = 1
        pointer = 1
      end
    elseif key == keys.enter then
      if seltp == 1 then
        -- selection
        return sel
      elseif seltp == 2 then
        -- setting
        edit(obj, sel, pointer)
      elseif seltp == 3 then
        -- subPage
        -- get the page
        local i, cur = iter(obj, sel)
        -- clone-downs
        if not cur.colors then
          cur.colors = obj.colors
        end
        if not cur.settings then
          cur.settings = {location = obj.settings.location}
        end
        if not cur.settings.location then
          cur.settings.location = obj.settings.location
        end

        -- run the sub page
        display(cur)
      end
    end
  end
  printError("This shouldn't happen.")
  printError("Please report to le github with your layout file.")
  os.sleep(30)
end

return display
