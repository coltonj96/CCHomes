if not global.cch then global.cch = {} end

function home_cmd(player, args)
  if not global.cch[player.name] then global.cch[player.name] = {} end
  if #args == 0 then
    player.print("Please specify a home")
  elseif #args == 1 then
    if global.cch[player.name][args[1]] then
      local home = global.cch[player.name][args[1]]
      if not home.surface then
        global.cch[player.name][args[1]] = {position = home, surface = game.surfaces["nauvis"]}
        home = global.cch[player.name][args[1]]
      end
      local offset = home.surface.find_non_colliding_position(game.entity_prototypes["player"].name, home.position, 5.0, 0.5)
      if offset then
        player.teleport(offset, home.surface)
      else
        player.print("Home is covered by something!")
      end
    else
      player.print(args[1] .. " does not exist yet!")
    end
  else
    player.print("Too many arguments!")
  end
end

function list_cmd(player, args)
  if not global.cch[player.name] then global.cch[player.name] = {} end
  if #args > 0 then
    player.print("Too many arguments!")
    return
  end
  local msg = "Your Homes: "
  local homes = global.cch[player.name]
  if homes then
    for k,v in pairs(homes) do
      msg = msg .. k .. ", "
    end
  else
    msg = "You have no homes!"
  end
  player.print(msg)
end

function set_cmd(player, args)
  if not global.cch[player.name] then global.cch[player.name] = {} end
  if #args == 0 then
    player.print("You must name this home before it can be set!")
    return
  elseif #args == 1 then
    if global.cch[player.name][args[1]] then
      player.print("This home exists already, to reset this home use '-r' as a second argument")
    else
      if not (args[1] == "-r") then
        global.cch[player.name][args[1]] = {position = player.position, surface = player.surface}
        player.print("Successfully set " .. args[1])
      else
        player.print("Cannot name a home '-r' as it is a reserved keyword!")
      end
    end
  elseif #args == 2 then
    if args[2] == "-r" then
      global.cch[player.name][args[1]] = {position = player.position, surface = player.surface}
      player.print("Successfully reset " .. args[1])
    else
      player.print("Too many arguments!")
    end
  elseif #args > 2 then
    player.print("Too many arguments!")
  end
end

function remove_cmd(player, args)
  if not global.cch[player.name] then global.cch[player.name] = {} end
  if args == 0 then
    player.print("You must specify a home!")
    return
  elseif #args == 1 then
    if not global.cch[player.name][args[1]] then
      player.print("This home does not exist!")
    else
      global.cch[player.name][args[1]] = nil
      player.print("Successfully removed " .. args[1])
    end
  else
    player.print("Too many arguments!")
  end
end

script.on_event(defines.events.on_player_joined_game, function(event)
  local player = game.players[event.player_index]
  if not global.cch[player.name] then global.cch[player.name] = {} end
end)

remote.add_interface("cc_homes", {home = home_cmd, list = list_cmd, set = set_cmd, remove = remove_cmd})

function desc()
  local tble = {
      cc_homes = {
        {
          command = "home",
          description = "Teleport to a home"
        },
        {
          command = "list",
          description = "List all your homes"
        },
        {
          command = "set",
          description = "Set/reset a home"
        },
        {
          command = "remove",
          description = "Remove a home"
        }
      }
    }
  return tble
end

remote.add_interface("ccd_homes", {descriptions = desc})