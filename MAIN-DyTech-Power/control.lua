require "defines"
require "util"

--[[TODO:
	Proper localisation
]]--

--Don't mind me:
--/c game.player.insert{name="nuclear-reactor",count=1}
	
--[[Debug Functions]]--
debug_master = true -- Master switch for debugging, shows most things!

function debug(str)
	if debug_master then
		for _,player in pairs(game.players) do
			player.print(str)
		end
	end
end

function datablock(str, strname)
	if debug_master then
		game.makefile("DataDump/"..strname..".txt", serpent.block(str))
		debug("Made serpent.block file: "..strname)
	end
end

function datadump(str, strname)
	if debug_master then
		game.makefile("DataDump/block "..strname..".txt", serpent.dump(str))
		debug("Made serpent.dump file: "..strname)
	end
end

--[[Insert Fancy Code Here:]]--
game.oninit(function()
glob.tick = {}
glob.tick[1] = 0
glob.usedFuel = {}
glob.entitypos = {}
glob.entityinfo = {}
glob.entitycount = 0

--glob.entitypos[glob.entitycount] = {}
--glob.entityinfo[glob.entitycount] = {}
end)

--[[Reactor Code]]--

game.onevent(defines.events.onbuiltentity, function(event)

	if event.createdentity.name == "nuclear-reactor" then
	
	--Saving the coordinates of the placed entity
	glob.entitycount = glob.entitycount + 1
	datadump(glob.entitycount, "glob.entitycount")
	
	glob.entitypos[glob.entitycount] = {}
	glob.entitypos[glob.entitycount].TopLeft = event.createdentity.position.x-2 --Left Top
	glob.entitypos[glob.entitycount].TopRight = event.createdentity.position.x+2
	
	glob.entitypos[glob.entitycount].BottomLeft = event.createdentity.position.y-2 --Right Bottom
	glob.entitypos[glob.entitycount].BottomRight = event.createdentity.position.y+2
	
	glob.entitypos[glob.entitycount].ContainerX = event.createdentity.position.x-3
	glob.entitypos[glob.entitycount].ContainerY = event.createdentity.position.y
	
	
		glob.entityinfo[glob.entitycount] = {}
		glob.entityinfo[glob.entitycount].ContainerEntity = {}
		glob.entityinfo[glob.entitycount].ReactorEntity = {}
		glob.entityinfo[glob.entitycount].ReactorEntity = event.createdentity
		datadump(glob.entityinfo[glob.entitycount].ReactorEntity, "glob.entityinfo[glob.entitycount].ReactorEntity")
		debug(glob.entityinfo[glob.entitycount].ReactorEntity.name)
		
		event.createdentity.operable = false
		if (game.canplaceentity{name = "nuclear-reactor-container", position = {glob.entitypos[glob.entitycount].ContainerX, glob.entitypos[glob.entitycount].ContainerY}}) then
			game.createentity{name = "nuclear-reactor-container", position = {glob.entitypos[glob.entitycount].ContainerX, glob.entitypos[glob.entitycount].ContainerY}, force=game.forces.player}
			glob.entityinfo[glob.entitycount].ContainerEntity = game.findentitiesfiltered{area = {{glob.entitypos[glob.entitycount].ContainerX, glob.entitypos[glob.entitycount].ContainerY}, {glob.entitypos[glob.entitycount].ContainerX, glob.entitypos[glob.entitycount].ContainerY}}, name = "nuclear-reactor-container"}
			if glob.entityinfo[glob.entitycount].ContainerEntity.name == "nuclear-reactor-container" then
				debug("Correct Entity Found!")
			elseif glob.entityinfo[glob.entitycount].ContainerEntity.name == "nuclear-reactor" then
				debug("Nuclear Reactor Found!")
			else
				debug("Incorrect Entity Found!")
				debug("I Found: ".. glob.entityinfo[glob.entitycount].ContainerEntity.name)
			end
			datadump(glob.entityinfo[glob.entitycount], "Placed-Entity")
		else
			for i,player in ipairs(game.players) do
				player.print("The nuclear reactor couldn't be placed. Please make sure the complete 6x6 area is clear, and you place the reactor in the middle.")
				game.players[i].insert({name = "nuclear-reactor", count = 1})
			end
			glob.entityinfo[glob.entitycount].ReactorEntity.destroy()
		end
	end
	
--[[if event.createdentity.name == "nuclear-reactor-container" then
		glob.entityinfo[2] = event.createdentity.getinventory(1)
		datadump(glob.entityinfo)
	end]]--
end)

--[[game.onevent(defines.events.onguiclick, function(event)
	if event.guielement.name = "nuclear-reactor-container" then
		nuclear-reactor-container[1] = true
	end
end)]]--

game.onevent(defines.events.ontick, function(event)
	if glob.tick[1] == 300 then
		moveFuel()
		calcEnergy()
		glob.tick[1] = 0
	else
		glob.tick[1] = glob.tick[1] + 1
	end
end)

function moveFuel()
for i, entitycount in pairs(glob.entityinfo) do
	if glob.entityinfo[i].ReactorEntity ~= nil and glob.entityinfo[i].ContainerEntity ~= nil then
		--[[if glob.entityinfo[i].ReactorEntity.valid and glob.entityinfo[i].ContainerEntity.valid and glob.entityinfo[i].ContainerEntity.name == "nuclear-reactor-container" then
			debug("It works!")
		else
			debug("Not valid")
		end]]--
		if glob.entityinfo[glob.entitycount].ContainerEntity.isempty() == false then
			debug("Ur a smartass u MagicLegend")
			glob.entityinfo[glob.entitycount].EntityContents = glob.entityinfo[glob.entitycount].ContainerEntity.getinventory(1).getcontents()
			datadump(glob.entityinfo[glob.entitycount].EntityContents, "glob.entityinfo[glob.entitycount].EntityContents")
			debug("The usedFuel variable contains: "..usedFuel[glob.entitycount].EntityContents)
			glob.entityinfo[glob.entitycount].removeitem(1)
		else
			debug("Container is empty")
		end
	else
	debug("glob.entityinfo[i].ReactorEntity = nil or glob.entityinfo[i].ReactorEntity = nil")
	end
end
end

function calcEnergy()
for i, entitycount in pairs(glob.entityinfo) do
	if glob.usedFuel[glob.entitycount] ~= nil then
		if glob.usedFuel[glob.entitycount] == "Plutonium" then
			debug("Plutonium all the way!")
		elseif glob.usedFuel[glob.entitycount] == "Uranium" then
			debug("Uranium is your friend!")
		else
			debug("I have no idea what that is... But it doesn't look like something burnable in a reactor!")
			game.player.insert({name=glob.usedFuel[1],count=1})
		end
	else
		debug("No fuel")
	end
end
end

--Don't mind me:
--/c game.player.insert{name="nuclear-reactor",count=1}