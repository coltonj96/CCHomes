if not global.cct then global.cct = {} end

function home_cmd(player, args)
  if #args == 0 then
    player.print("Please specify a home")
  elseif #args == 1 then
    if get_home(player, args) then
      local home = get_home(player, args)
      player.teleport(home)
    else
      player.print(args[1] .. " does not exist yet!")
    end
  else
    player.print("Too many arguments!")
  end
end

function list_cmd(player, args)
  if #args > 0 then
    player.print("Too many arguments!")
    return
  end
  local msg = "Your Homes Homes: "
  for k,v in pairs(get_homes(player)) do
    msg = msg .. k .. ", "
  end
  player.print(msg)
end

function set_cmd(player, args)
  if args == 0 then
    player.print("You must name this home before it can be set!")
    return
  elseif #args == 1 then
    if get_home(player, args) then
      player.print("This home exists already, to reset this home use '-r' as a second argument")
    else
      if not args[1] == "-r" then
          set_home(player, args)
          player.print("Successfully set " .. args[1])
        else
          player.print("Cannot name a home '-r' as it is a reserved argument.")
      end
    end
  elseif #args == 2 then
    if args[2] == "-r" then
      set_home(player, args)
      player.print("Successfully reset " .. args[1])
    else
      player.print("Too many arguments!")
    end
  else
    player.print("Too many arguments!")
  end
end

function remove_cmd(player, args)
  if args == 0 then
    player.print("You must specify a home!")
    return
  elseif #args == 1 then
    if not get_home(player, args) then
      player.print("This home does not exist!")
    else
      remove_home(player, args)
      player.print("Successfully removed " .. args[1])
    end
  else
    player.print("Too many arguments!")
  end
end

function get_home(player, args)
  return global.cct[player.name][args[1]]
end

function get_homes(player)
  return global.cct[player.name]
end

function set_home(player, args)
  global.cct[player.name][args[1]] = player.position
end

function remove_home(player, args)
  global.cct[player.name][args[1]] = nil
end

script.on_event(defines.events.on_player_joined_game, function(event)
  if not global.cct[player.name] then global.cct[player.name] = {} end
end)

remote.add_interface("cc_tp", {home = home_cmd, list = list_cmd, set = set_cmd, remove = remove_cmd})