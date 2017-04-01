spawnRate = 1.0 --Higher = More spawns, Lower = Less, range 0-100, No Spawns to All Spawns

AggroZoneString = [[
function onObjectEnterScriptingZone(zone, ob)
    if zone == self then
        ob.setVar("aggro", true)
        ob.setColorTint({1,0,0})
        Global.call("killSpeed")
    end
end
]]

function onload()
    PLAYER = getObjectFromGUID("2839c4")
    print(PLAYER.tag)
    Global.setVar("GPLAYER", PLAYER)
    FLOOR = getObjectFromGUID("a7ad17")
    print(FLOOR.tag)
    WALL = getObjectFromGUID("c79a8c")
    print(WALL.tag)
    CHEST = getObjectFromGUID("57cb71")
    print(CHEST.tag)
    turnMarker = getObjectFromGUID("230989")
    testZone = spawnZone({-49,1,3}, 5, "test")

    dice = {
        d4 = getObjectFromGUID("31c53e"),
        d6 = getObjectFromGUID("967c90"),
        d8 = getObjectFromGUID("831e11"),
        d10 = getObjectFromGUID("2b7413"),
        d12 = getObjectFromGUID("56844d"),
        d20 = getObjectFromGUID("8d3f69")
    }


    mob = {
        getObjectFromGUID("a7f752"), --RAT
        getObjectFromGUID("a7f752"), --RAT
        getObjectFromGUID("a7f752"), --RAT
        getObjectFromGUID("7768d7"), --SNAKE
        getObjectFromGUID("7768d7"), --SNAKE
        getObjectFromGUID("324317")  --WOLF
    }
end

function click()

    --------------------------------
    --Initialize Values
    --------------------------------
    cursor = {}
    cursor.x = -1
    cursor.y = 1.5
    cursor.z = 1

    wallC = {}
    wallC.y = 1.5

    done = false
    wallsDone = false
    count = 0

    turnTable = {"NORTH", "EAST", "SOUTH", "WEST"}
    face = "NORTH"

    colTable = {}
    eColTable = {}
    enemies = {}
    chests = {}
    startLuaCoroutine(Global, "genMaze")
end

function genMaze(butt)

    --------------------------------
    --make floor
    --------------------------------
    lastTile = FLOOR.clone({position = cursor, snap_to_grid = true})
    posString = tostring(cursor.x) .. "x" .. tostring(cursor.z) .. "z"
    colTable[posString] = true
    count = count + 1
    lastTile.setColorTint({1,0,0})

    floorSize = 0


    while done == false do

        if face == "NORTH" then
            cursor.x = cursor.x + 2
        elseif face == "WEST" then
            cursor.z = cursor.z - 2
        elseif face == "EAST" then
            cursor.z = cursor.z + 2
        elseif face == "SOUTH" then
            cursor.x = cursor.x - 2
        end

        face = turnTable[math.random(1,4)]
        posString = tostring(cursor.x) .. "x" .. tostring(cursor.z) .. "z"
        if collision() == false then
            lastTile = FLOOR.clone({position = cursor, snap_to_grid = true})
            spawnExtras()
            --posString = tostring(cursor.x) .. "x" .. tostring(cursor.z) .. "z"
            colTable[posString] = true
            count = count + 1
            floorSize = floorSize + 1
			coroutine.yield(0)
            coroutine.yield(0)
        end
        done = outOfBounds()

    end
    lastTile.setColorTint({0,1,0})
    -------------------------------
    --make walls
    -------------------------------
    cursor.x = -43
    cursor.z = 25

    while wallsDone == false do
        if cursor.z < -25 then
            cursor.z = 25
            cursor.x = cursor.x + 2
        end
        if cursor.x > 43 then
            wallsDone = true
        end

        wallC.x = cursor.x
        wallC.z = cursor.z
        posString = tostring(wallC.x) .. "x" .. tostring(wallC.z) .. "z"


        if colTable[tostring(wallC.x) .. "x" .. tostring(wallC.z) .. "z"] == true then
            --Do nothing, floor here
        elseif colTable[tostring(wallC.x-2) .. "x" .. tostring(wallC.z-2) .. "z"] == true then
            WALL.clone({position = wallC, snap_to_grid = true})
            eColTable[posString] = true
            coroutine.yield(0)
            coroutine.yield(0)
        elseif colTable[tostring(wallC.x) .. "x" .. tostring(wallC.z-2) .. "z"] == true then
            WALL.clone({position = wallC, snap_to_grid = true})
            eColTable[posString] = true
            coroutine.yield(0)
            coroutine.yield(0)
        elseif colTable[tostring(wallC.x+2) .. "x" .. tostring(wallC.z-2) .. "z"] == true then
            WALL.clone({position = wallC, snap_to_grid = true})
            eColTable[posString] = true
            coroutine.yield(0)
            coroutine.yield(0)
        elseif colTable[tostring(wallC.x-2) .. "x" .. tostring(wallC.z) .. "z"] == true then
            WALL.clone({position = wallC, snap_to_grid = true})
            eColTable[posString] = true
            coroutine.yield(0)
            coroutine.yield(0)
        elseif colTable[tostring(wallC.x+2) .. "x" .. tostring(wallC.z) .. "z"] == true then
            WALL.clone({position = wallC, snap_to_grid = true})
            eColTable[posString] = true
            coroutine.yield(0)
            coroutine.yield(0)
        elseif colTable[tostring(wallC.x-2) .. "x" .. tostring(wallC.z+2) .. "z"] == true then
            WALL.clone({position = wallC, snap_to_grid = true})
            eColTable[posString] = true
            coroutine.yield(0)
            coroutine.yield(0)
        elseif colTable[tostring(wallC.x) .. "x" .. tostring(wallC.z+2) .. "z"] == true then
            WALL.clone({position = wallC, snap_to_grid = true})
            eColTable[posString] = true
            coroutine.yield(0)
            coroutine.yield(0)
        elseif colTable[tostring(wallC.x+2) .. "x" .. tostring(wallC.z+2) .. "z"] == true then
            WALL.clone({position = wallC, snap_to_grid = true})
            eColTable[posString] = true
            coroutine.yield(0)
            coroutine.yield(0)
        else
            --WALL.clone({position = wallC, snap_to_grid = true})
        end

        cursor.z = cursor.z - 2
    end

    for i=1,90 do
        coroutine.yield(0)
    end
    lockFloor()
    print("This floor is " .. floorSize .. " tiles.")

    PLAYER.setPosition({-1, 2, 1})
    return 1
end

function spawnExtras()
    rand = math.random(1,100)
    if rand < count*(spawnRate) then
        count = 0
        if rand%4 ~= 0 then
            eColTable[posString] = true
            enemies[#enemies+1] = mob[rand%6 + 1].clone({position = cursor, snap_to_grid = true})
        else
            eColTable[posString] = true
            chests[#chests+1] = CHEST.clone({position = cursor, snap_to_grid = true})
        end
    end
end

function lockFloor()
    obTable = getObjectFromGUID("075c49").getObjects()

    for k,v in pairs(obTable) do
        v.lock()
    end
end

function collision()
    if colTable[posString] == true then
        return true
    else
        return false
    end
end

function entityCol()
    if eColTable[posString] == true then
        return true
    else
        return false
    end
end

function outOfBounds()
    if math.abs(cursor.x) > 41 or  math.abs(cursor.z) > 23 then
        return true
    end
    return false
end

function endItAll()
    wallsDone = true
    done = true
    obTable = getObjectFromGUID("075c49").getObjects()

    for k,v in pairs(obTable) do
        v.destruct()
    end
end

function round(x)
    return (x + 0.5 - (x + 0.5) % 1)
end

function attack()
    leftBowl = getObjectFromGUID("5f0231").getObjects()
    rightBowl = getObjectFromGUID("566977").getObjects()

    for k,v in pairs(leftBowl) do
        if v.getName() ~= "Player" then
            v.destruct()
        end
    end

    for k,v in pairs(rightBowl) do
        if v.getName() ~= "Enemy" then
            v.destruct()
        end
    end

    playerDice = dice["d20"].clone({position = {-11,5,-35}})
    playerDice.unlock()
    coroutine.yield(0)
    coroutine.yield(0)
    playerDice.roll()
    mobDice = dice["d4"].clone({position = {9,5,-35}})
    mobDice.unlock()
    coroutine.yield(0)
    coroutine.yield(0)
    mobDice.roll()
    return 1
end

function checkVisit()
	if visTable[posString] == true then
        return true
    else
        return false
    end
end

function checkMove()
	if collision() == true and entityCol() == false and outOfBounds() == false and checkVisit() == false then
		return true
	else
		return false
	end
end

function mobAI()
    turnMarker.translate({0,3,0})
    turnMarker.flip()
    cursor = PLAYER.getPosition()
    PPos = PLAYER.getPosition()
    cursor.x = round(cursor.x)
    cursor.y = 2
    cursor.z = round(cursor.z)

    playerString = tostring(cursor.x) .. "x" .. tostring(cursor.z) .. "z"
    eColTable[playerString] = true

    --Create player aggro zone
    PAggro = spawnZone(PPos, 3.5, "PAggro")
    coroutine.yield(0)
    PAggro.setLuaScript(AggroZoneString)


    --Mob Pathing
    for i=1, #enemies do
        initCursor = {}
        enemies[i].setColorTint({0,0,1})
        speed = enemies[i].getVar("speed")
        cursor = enemies[i].getPosition()
        cursor.x = round(cursor.x)
        cursor.y = 2
        cursor.z = round(cursor.z)

        posString = tostring(cursor.x) .. "x" .. tostring(cursor.z) .. "z"
        eColTable[posString] = false
		aggro = enemies[i].getVar("aggro")

		if aggro == false then --patrol
	        for j=1, speed do

	            initCursor.x = cursor.x
	            initCursor.z = cursor.z
	            face = turnTable[math.random(1,4)]

	            if face == "NORTH" then
	                cursor.x = cursor.x + 2
	                enemies[i].setRotation({0,90,0})
	            elseif face == "WEST" then
	                enemies[i].setRotation({0,180,0})
	                cursor.z = cursor.z - 2
	            elseif face == "EAST" then
	                enemies[i].setRotation({0,0,0})
	                cursor.z = cursor.z + 2
	            elseif face == "SOUTH" then
	                enemies[i].setRotation({0,270,0})
	                cursor.x = cursor.x - 2
	            end

	            posString = tostring(cursor.x) .. "x" .. tostring(cursor.z) .. "z"
	            --check for other mob too.
	            if collision() == true and entityCol() == false and outOfBounds() == false then
	                enemies[i].translate({0,0.5,0})
	                enemies[i].setPositionSmooth(cursor)
	                for i=1,15 do
	                    coroutine.yield(0)
	                end
	            elseif posString == playerString then
	                enemies[i].RPGFigurine.attack()
	                enemies[i].setColorTint({1,0,0})
	                enemies[i].setVar("aggro", true)
	                printToAll(enemies[i].getDescription() .. " attacks!", {1,0,0})
	                break
	            else
	                cursor.x = initCursor.x
	                cursor.z = initCursor.z
	            end

			end
		else
			-- find player
            enemies[i].setColorTint({1,0,0})

			failSafe = 0
			exitLoop = false
			pathTable = {""}
			visTable = {}
			resetC = {}
			initCursor.x = cursor.x
			initCursor.z = cursor.z

			posString = tostring(cursor.x) .. "x" .. tostring(cursor.z) .. "z"
			visTable[posString] = true

			while posString ~= playerString do
				failSafe = failSafe + 1
				if failSafe > 50 then
					print(enemies[i].getDescription() .. " loses interest.")
					enemies[i].setColorTint({0,0,0})
                    enemies[i].setVar("aggro", false)
                    aggro = false
					exitLoop = true
					break
				end
				resetC.x = cursor.x
				resetC.z = cursor.z
				for ix=1,4 do
					cursor.x = resetC.x
					cursor.z = resetC.z

					if ix == 1 then
			            cursor.z = cursor.z + 2
			        elseif ix == 2 then
			            cursor.x = cursor.x + 2
			        elseif ix == 3 then
			            cursor.z = cursor.z - 2
			        elseif ix == 4 then
			            cursor.x = cursor.x - 2
			        end

			        posString = tostring(cursor.x) .. "x" .. tostring(cursor.z) .. "z"
					--print(posString)
					if posString == playerString then
						pathTable[#pathTable + 1] = pathTable[1] .. ix
						print("found player on path " .. pathTable[#pathTable])
						exitLoop = true
						break
					end

					if checkMove() == true then
						visTable[posString] = true
						pathTable[#pathTable + 1] = pathTable[1] .. ix
						--print(pathTable[#pathTable])
					end
					coroutine.yield(0)
				end

				if exitLoop == true then
					break
				end

				table.remove(pathTable, 1)

				if #pathTable == 0 then
					print(enemies[i].getDescription() .. " loses interest.")
					enemies[i].setColorTint({0,0,0})
                    enemies[i].setVar("aggro", false)
					exitLoop = true
					speed = 0
					break
				end
				--print("new 1spot: " .. pathTable[1])

				--find new cursor
				cursor.x = initCursor.x
				cursor.z = initCursor.z
				posString = tostring(cursor.x) .. "x" .. tostring(cursor.z) .. "z"
				--print("restart PS: " .. posString)
				for j=1, #pathTable[1] do


					dir = pathTable[1]:sub(j,j)
					dir = tonumber(dir)

					if dir == 1 then
			            cursor.z = cursor.z + 2
			        elseif dir == 2 then
			            cursor.x = cursor.x + 2
			        elseif dir == 3 then
			            cursor.z = cursor.z - 2
			        elseif dir == 4 then
			            cursor.x = cursor.x - 2
			        end
				end
			end


			pathString = pathTable[#pathTable]
            cursor.x = initCursor.x
            cursor.z = initCursor.z
			for sp=1, speed do
				--moving
				dir = pathString:sub(sp,sp)
				dir = tonumber(dir)

				if dir == 1 then
					cursor.z = cursor.z + 2
					enemies[i].setRotation({0,0,0})
				elseif dir == 2 then
					cursor.x = cursor.x + 2
					enemies[i].setRotation({0,90,0})
				elseif dir == 3 then
					cursor.z = cursor.z - 2
					enemies[i].setRotation({0,180,0})
				elseif dir == 4 then
					cursor.x = cursor.x - 2
					enemies[i].setRotation({0,270,0})
				end


                if sp == #pathString then
                    for cor=1,15 do
    					coroutine.yield(0)
    				end
					enemies[i].RPGFigurine.attack()
	                printToAll(enemies[i].getDescription() .. " attacks!", {1,0,0})
					break
				end

				enemies[i].translate({0,0.5,0})
				enemies[i].setPositionSmooth(cursor)

                for cor=1,15 do
					coroutine.yield(0)
				end

                if #pathString - sp == 1 and sp == speed then --checks for speed == #string - 1 bug
                    --check rotation
                    sp = sp+1
                    dir = pathString:sub(sp,sp)
    				dir = tonumber(dir)

    				if dir == 1 then
    					enemies[i].setRotation({0,0,0})
    				elseif dir == 2 then
    					enemies[i].setRotation({0,90,0})
    				elseif dir == 3 then
    					enemies[i].setRotation({0,180,0})
    				elseif dir == 4 then
    					enemies[i].setRotation({0,270,0})
    				end

                    --attack
					enemies[i].RPGFigurine.attack()
	                printToAll(enemies[i].getDescription() .. " attacks!", {1,0,0})
					break
				end
			end
		end

        coroutine.yield(0)
        if enemies[i].getVar("aggro") == true then
            enemies[i].setColorTint({1,0,0})
        else
            enemies[i].setColorTint({0,0,0})
        end
        posString = tostring(cursor.x) .. "x" .. tostring(cursor.z) .. "z"
        eColTable[posString] = true
    end

    for i=1,60 do
        coroutine.yield(0)
    end
    cursor = PLAYER.getPosition()
    cursor.x = round(cursor.x)
    cursor.y = 2
    cursor.z = round(cursor.z)

    posString = tostring(cursor.x) .. "x" .. tostring(cursor.z) .. "z"
    eColTable[playerString] = false

    --Destroy Player Aggro zone
    PAggro.destruct()

    turnMarker.translate({0,3,0})
    turnMarker.flip()
    return 1
end

function killSpeed()
    speed = 0
end

function spawnZone(pos,size,name)

    local params = {}
    params.type = "ScriptingTrigger"
    params.position = pos
    scriptZone = spawnObject(params)
    scriptZone.setName(name)
    scriptZone.setScale({size, 2, size})    -- set the dimensions you want

    return scriptZone
end