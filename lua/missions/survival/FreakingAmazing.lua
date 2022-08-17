require("lua/utils/table_utils.lua")
require("lua/utils/rules_utils.lua")

local survival_base = require( "lua/missions/survival/survival_base.lua" )
class 'amazing' ( survival_base )

function amazing:__init()
    survival_base.__init(self,self)
end

function amazing:init()
	
	LogService:Log( "amazing:init()" )


	--maze vars
	local sizeGrid = 48.0 --maze grid amount

	local mapOffset = 291.0
	local mapGridSize = 12.0

	local countNonVisited
	local chooseNonVisited
	local countWalls
	local entityId  --for rotations etc
	local entPosX
	local entPosZ
	local chooseWallEnt

	local veinPosX = {}
	local veinPosZ = {}
	local veinType = {}
	local veinCount = 0

	--init (virtual) stack for iterative maze junctions
	local stackPos = 1
	local stackCellX = {}
	local stackCellZ = {}
	for i = 1, 10000 do
		stackCellX[i] = 0
		stackCellZ[i] = 0
	end
	
	--init maze wall grid 2D array
	local mazeWalls = {}
	for i = 1, sizeGrid - 1 do
    		mazeWalls[i] = {}
    		for j = 1, sizeGrid - 1 do
        		mazeWalls[i][j] = 1 --start with all walls: 1 = wall, 0 = empty
		end
	end

	--init visited cells 2D array with pre-visited borders
	local visitedCells = {}
	for i = 0, sizeGrid do
    		visitedCells[i] = {}
    		for j = 0, sizeGrid do
        		if (i == 0) or (j == 0) or (i == sizeGrid) or (j == sizeGrid) then
				visitedCells[i][j] = 1 --make border visited so walls don't get removed
			else
				visitedCells[i][j] = 0 --everything other than border has not been visited
			end
		end
	end

	--interior pre-visited area for spawn/base
	for i = 0 + 19, sizeGrid - 19 do
    		for j = 0 + 19, sizeGrid - 19 do
			visitedCells[i][j] = 1
		end
	end

	--init possible maze branches for current cell
	local listNonVisited = {}
	for i = 1, 4 do
		listNonVisited[i] = 0
	end

	--put maze cell start position on the stack
	stackCellX[stackPos] = 2
	stackCellZ[stackPos] = 2

	--execute until no more maze branches exist
	while stackPos > 0 do
		
		--using current stack position visit and remove wall from current cell
		visitedCells[stackCellX[stackPos]][stackCellZ[stackPos]] = 1
		mazeWalls[stackCellX[stackPos]][stackCellZ[stackPos]] = 0	
		
		--count how many and where the non visited junctions are at the current cell
		--possible junctions: 1 = north, 2 = east, 3 = south, 4 = west
		countNonVisited = 0

		if visitedCells[stackCellX[stackPos] - 2][stackCellZ[stackPos]] == 0 then
			countNonVisited = countNonVisited + 1
			listNonVisited[countNonVisited] = 1 --north
		end
		
		if visitedCells[stackCellX[stackPos]][stackCellZ[stackPos] + 2] == 0 then
			countNonVisited = countNonVisited + 1
			listNonVisited[countNonVisited] = 2 --east
		end

		if visitedCells[stackCellX[stackPos] + 2][stackCellZ[stackPos]] == 0 then
			countNonVisited = countNonVisited + 1
			listNonVisited[countNonVisited] = 3 --south
		end

		if visitedCells[stackCellX[stackPos]][stackCellZ[stackPos] - 2] == 0 then
			countNonVisited = countNonVisited + 1
			listNonVisited[countNonVisited] = 4 --west
		end

		--if there are no more junctions at the current cell pop the stack to get new cell next iteration
		if countNonVisited == 0 then 

			stackPos = stackPos - 1

		else

			--pick a random non visited cell at junction
			chooseNonVisited = RandInt( 1, countNonVisited )
			
			--remove wall between current cell and selected cell
			--push selected cell to the stack so it is processed next iteration
			if 	listNonVisited[chooseNonVisited] == 1 then
				mazeWalls[stackCellX[stackPos] - 1][stackCellZ[stackPos]] = 0 --remove north wall from current cell
				stackCellX[stackPos + 1] = stackCellX[stackPos] - 2
				stackCellZ[stackPos + 1] = stackCellZ[stackPos]
			elseif 	listNonVisited[chooseNonVisited] == 2 then
				mazeWalls[stackCellX[stackPos]][stackCellZ[stackPos] + 1] = 0 --remove east wall from current cell
				stackCellX[stackPos + 1] = stackCellX[stackPos]
				stackCellZ[stackPos + 1] = stackCellZ[stackPos] + 2
			elseif 	listNonVisited[chooseNonVisited] == 3 then
				mazeWalls[stackCellX[stackPos] + 1][stackCellZ[stackPos]] = 0 --remove south wall from current cell
				stackCellX[stackPos + 1] = stackCellX[stackPos] + 2
				stackCellZ[stackPos + 1] = stackCellZ[stackPos]
			elseif 	listNonVisited[chooseNonVisited] == 4 then
				mazeWalls[stackCellX[stackPos]][stackCellZ[stackPos] - 1] = 0 --remove west wall from current cell
				stackCellX[stackPos + 1] = stackCellX[stackPos]
				stackCellZ[stackPos + 1] = stackCellZ[stackPos] - 2
			else --I AM ERROR
			end
			stackPos = stackPos + 1

		end
	end	


	--remove remaining walls for spawn/base
	for i = 0 + 18, sizeGrid - 18 do
    		for j = 0 + 18, sizeGrid - 18 do
			mazeWalls[i][j] = 0
		end
	end

	--parse maze grid and spawn entities if it is a wall
	for z = 1, sizeGrid - 1, 1 do
    		for x = 1, sizeGrid - 1, 1 do
			if mazeWalls[x][z] == 1 then
				entPosX = (x * mapGridSize) - mapOffset
				entPosZ = (z * mapGridSize) - mapOffset

				chooseWallEnt = RandInt( 1, 3 )
				if chooseWallEnt == 1 then
					entityId = EntityService:SpawnEntity( "props/modified/granite_rock_medium_01", entPosX, 0.0, entPosZ, "" )
					EntityService:SetOrientation( entityId, 1, 0, 0, RandInt( 0, 360 ) )
					EntityService:SetOrientation( entityId, 0, 1, 0, RandInt( 0, 360 ) )
					EntityService:SetOrientation( entityId, 0, 0, 1, RandInt( 0, 360 ) )
					EntityService:SetScale( entityId, 1.3, 1.3, 1.3 )
				elseif chooseWallEnt == 2 then
					entityId = EntityService:SpawnEntity( "props/modified/granite_rock_medium_02", entPosX, 0.0, entPosZ, "" )
					EntityService:SetOrientation( entityId, 1, 0, 0, RandInt( 0, 360 ) )
					EntityService:SetOrientation( entityId, 0, 1, 0, RandInt( 0, 360 ) )
					EntityService:SetOrientation( entityId, 0, 0, 1, RandInt( 0, 360 ) )
				elseif chooseWallEnt == 3 then
					entityId = EntityService:SpawnEntity( "props/modified/granite_rock_medium_03", entPosX, 0.0, entPosZ, "" )
					EntityService:SetOrientation( entityId, 1, 0, 0, RandInt( 0, 360 ) )
					EntityService:SetOrientation( entityId, 0, 1, 0, RandInt( 0, 360 ) )
					EntityService:SetOrientation( entityId, 0, 0, 1, RandInt( 0, 360 ) )
				end
				
				--fill wall gaps north
				if (x < sizeGrid - 1) then
					if mazeWalls[x + 1][z] == 1 then
						chooseWallEnt = RandInt( 1, 3 )
						if chooseWallEnt == 1 then
							entityId = EntityService:SpawnEntity( "props/modified/granite_rock_medium_01", entPosX + (mapGridSize / 2), 0.0, entPosZ, "" )
							EntityService:SetOrientation( entityId, 1, 0, 0, RandInt( 0, 360 ) )
							EntityService:SetOrientation( entityId, 0, 1, 0, RandInt( 0, 360 ) )
							EntityService:SetOrientation( entityId, 0, 0, 1, RandInt( 0, 360 ) )
							EntityService:SetScale( entityId, 1.4, 1.4, 1.4 )
						elseif chooseWallEnt == 2 then
							entityId = EntityService:SpawnEntity( "props/modified/granite_rock_medium_02", entPosX + (mapGridSize / 2), 0.0, entPosZ, "" )
							EntityService:SetOrientation( entityId, 1, 0, 0, RandInt( 0, 360 ) )
							EntityService:SetOrientation( entityId, 0, 1, 0, RandInt( 0, 360 ) )
							EntityService:SetOrientation( entityId, 0, 0, 1, RandInt( 0, 360 ) )
						elseif chooseWallEnt == 3 then
							entityId = EntityService:SpawnEntity( "props/modified/granite_rock_medium_03", entPosX + (mapGridSize / 2), 0.0, entPosZ, "" )
							EntityService:SetOrientation( entityId, 1, 0, 0, RandInt( 0, 360 ) )
							EntityService:SetOrientation( entityId, 0, 1, 0, RandInt( 0, 360 ) )
							EntityService:SetOrientation( entityId, 0, 0, 1, RandInt( 0, 360 ) )
						end
					end
				end

				--fill wall gaps east
				if (z < sizeGrid - 1) then
					if mazeWalls[x][z + 1] == 1 then
						chooseWallEnt = RandInt( 1, 3 )
						if chooseWallEnt == 1 then
							entityId = EntityService:SpawnEntity( "props/modified/granite_rock_medium_01", entPosX, 0.0, entPosZ + (mapGridSize / 2), "" )
							EntityService:SetOrientation( entityId, 1, 0, 0, RandInt( 0, 360 ) )
							EntityService:SetOrientation( entityId, 0, 1, 0, RandInt( 0, 360 ) )
							EntityService:SetOrientation( entityId, 0, 0, 1, RandInt( 0, 360 ) )
							EntityService:SetScale( entityId, 1.4, 1.4, 1.4 )
						elseif chooseWallEnt == 2 then
							entityId = EntityService:SpawnEntity( "props/modified/granite_rock_medium_02", entPosX, 0.0, entPosZ + (mapGridSize / 2), "" )
							EntityService:SetOrientation( entityId, 1, 0, 0, RandInt( 0, 360 ) )
							EntityService:SetOrientation( entityId, 0, 1, 0, RandInt( 0, 360 ) )
							EntityService:SetOrientation( entityId, 0, 0, 1, RandInt( 0, 360 ) )
						elseif chooseWallEnt == 3 then
							entityId = EntityService:SpawnEntity( "props/modified/granite_rock_medium_03", entPosX, 0.0, entPosZ + (mapGridSize / 2), "" )
							EntityService:SetOrientation( entityId, 1, 0, 0, RandInt( 0, 360 ) )
							EntityService:SetOrientation( entityId, 0, 1, 0, RandInt( 0, 360 ) )
							EntityService:SetOrientation( entityId, 0, 0, 1, RandInt( 0, 360 ) )
						end
					end
				end

			end
		end
	end


	--parse maze grid and count walls at current cell, z+
	--if there are 3 walls it is a dead end, spawn resource there
	for z = 2, sizeGrid - 2, 2 do
    		for x = 2, sizeGrid - 2, 2 do

			countWalls = 0
			if mazeWalls[x - 1][z] == 1 then countWalls = countWalls + 1 end
			if mazeWalls[x][z + 1] == 1 then countWalls = countWalls + 1 end
			if mazeWalls[x + 1][z] == 1 then countWalls = countWalls + 1 end
			if mazeWalls[x][z - 1] == 1 then countWalls = countWalls + 1 end

			if countWalls == 3 then
				entPosX = (x * mapGridSize) - mapOffset
				entPosZ = (z * mapGridSize) - mapOffset

				chooseWallEnt = RandInt( 1, 5 )
				if chooseWallEnt == 1 then
					veinPosX[veinCount] = entPosX
					veinPosZ[veinCount] = entPosZ
					veinType[veinCount] = 0
					veinCount = veinCount + 1
				elseif chooseWallEnt == 2 then
					veinPosX[veinCount] = entPosX
					veinPosZ[veinCount] = entPosZ
					veinType[veinCount] = 1
					veinCount = veinCount + 1
				elseif chooseWallEnt == 3 then
					EntityService:SpawnEntity( "units/ground/spawner_canoptrix_normal", entPosX, 0.0, entPosZ, "" )
				elseif chooseWallEnt == 4 then
					EntityService:SpawnEntity( "units/ground/spawner_arachnoid_sentinel_normal", entPosX, 0.0, entPosZ, "" )
				elseif chooseWallEnt == 5 then
					EntityService:SpawnEntity( "units/ground/spawner_bomogan_normal", entPosX, 0.0, entPosZ, "" )
				end

			end

		end
	end

	--spawning veins needs to be done twice, once from z+ and once from z- for some reason or not all will spawn
	for veinCurrent = 0, veinCount - 1, 1 do
		if veinType[veinCurrent] == 0 then
			EntityService:SpawnEntity( "resources/volume_resource_carbon", veinPosX[veinCurrent], 0.0, veinPosZ[veinCurrent], "" )
		else
			EntityService:SpawnEntity( "resources/volume_resource_iron", veinPosX[veinCurrent], 0.0, veinPosZ[veinCurrent], "" )
		end
	end

	for veinCurrent = veinCount - 1, 0, -1 do
		if veinType[veinCurrent] == 0 then
			EntityService:SpawnEntity( "resources/volume_resource_carbon", veinPosX[veinCurrent], 0.0, veinPosZ[veinCurrent], "" )
		else
			EntityService:SpawnEntity( "resources/volume_resource_iron", veinPosX[veinCurrent], 0.0, veinPosZ[veinCurrent], "" )
		end
	end


----------------------------------------------------------------------------------------------------------------------------
	
	self:PrepareSpawnPoints();

	local database = self.data

	database:SetString( "mission_infinite", "1" )
	database:SetString( "difficulty", "sandbox" )

    	MissionService:ActivateMissionFlow("", "logic/missions/survival/no_waves.logic", "default", database )
	local rules = require( GetRulesForDifficulty( "lua/missions/survival/dom_survival_jungle_rules_" ) )()
	MissionService:AddGameRule( "lua/missions/dom_manager.lua", rules )

	self.fsm = self:CreateStateMachine()
	self.fsm:AddState( "win_check",	{ execute="OnWinCheck", interval=5.0 } )
	self.fsm:ChangeState("win_check")	
	self.hasWon = false
	self.spawnerDifficulty = 0

	self:RegisterHandler( event_sink, "DestroyRequest",  "_OnDestroyRequest" )

end

------------------------------------------------------------------------------------------------------------------------------



local function SpawnMobLoot( entity, blueprint, minAmount, maxAmount, packageSize )

	local spawnCount = RandInt( minAmount, maxAmount )

	while ( spawnCount > 0 )
	do
	        local count = math.min( spawnCount, packageSize )
        	spawnCount = spawnCount - count

	        ItemService:SpawnLoot( entity, blueprint, count )
    	end
end


function amazing:_OnDestroyRequest( evt )
	
	local entity = evt:GetEntity()
	local blueprint = EntityService:GetBlueprintName( entity )
	local randomExtraLoot

	if (blueprint == "units/ground/canoptrix_1") or
	   (blueprint == "units/ground/canoptrix_2") or
	   (blueprint == "units/ground/canoptrix_3") or
	   (blueprint == "units/ground/canoptrix_base") then
		--rare resources
		randomExtraLoot = RandInt( 1, 8 )
		if randomExtraLoot == 1 then
			SpawnMobLoot( entity, "items/loot/resources/shard_cobalt_item", 0, 1, 1 )
		elseif randomExtraLoot == 2 then
			SpawnMobLoot( entity, "items/loot/resources/shard_ferdonite_item", 0, 1, 1 )
		elseif randomExtraLoot == 3 then
			SpawnMobLoot( entity, "items/loot/resources/shard_hazenite_item", 0, 1, 1 )
		elseif randomExtraLoot == 4 then
			SpawnMobLoot( entity, "items/loot/resources/shard_palladium_item", 0, 1, 1 )
		elseif randomExtraLoot == 5 then
			SpawnMobLoot( entity, "items/loot/resources/shard_rhodonite_item", 0, 1, 1 )
		elseif randomExtraLoot == 6 then
			SpawnMobLoot( entity, "items/loot/resources/shard_tanzanite_item", 0, 1, 1 )
		elseif randomExtraLoot == 7 then
			SpawnMobLoot( entity, "items/loot/resources/shard_titanium_item", 0, 1, 1 )
		elseif randomExtraLoot == 8 then
			SpawnMobLoot( entity, "items/loot/resources/shard_uranium_item", 0, 1, 1 )
		end

	end

	if (blueprint == "units/ground/canoptrix_alpha_1") or
	   (blueprint == "units/ground/canoptrix_alpha_2") or
	   (blueprint == "units/ground/canoptrix_alpha_3") or
	   (blueprint == "units/ground/canoptrix_alpha_base") then
		--rare resources
		randomExtraLoot = RandInt( 1, 8 )
		if randomExtraLoot == 1 then
			SpawnMobLoot( entity, "items/loot/resources/shard_cobalt_item", 0, 2, 2 )
		elseif randomExtraLoot == 2 then
			SpawnMobLoot( entity, "items/loot/resources/shard_ferdonite_item", 0, 2, 2 )
		elseif randomExtraLoot == 3 then
			SpawnMobLoot( entity, "items/loot/resources/shard_hazenite_item", 0, 2, 2 )
		elseif randomExtraLoot == 4 then
			SpawnMobLoot( entity, "items/loot/resources/shard_palladium_item", 0, 2, 2 )
		elseif randomExtraLoot == 5 then
			SpawnMobLoot( entity, "items/loot/resources/shard_rhodonite_item", 0, 2, 2 )
		elseif randomExtraLoot == 6 then
			SpawnMobLoot( entity, "items/loot/resources/shard_tanzanite_item", 0, 2, 2 )
		elseif randomExtraLoot == 7 then
			SpawnMobLoot( entity, "items/loot/resources/shard_titanium_item", 0, 2, 2 )
		elseif randomExtraLoot == 8 then
			SpawnMobLoot( entity, "items/loot/resources/shard_uranium_item", 0, 2, 2 )
		end

	end

	if (blueprint == "units/ground/canoptrix_ultra_1") or
	   (blueprint == "units/ground/canoptrix_ultra_2") or
	   (blueprint == "units/ground/canoptrix_ultra_3") or
	   (blueprint == "units/ground/canoptrix_ultra_base") then
		--rare resources
		randomExtraLoot = RandInt( 1, 8 )
		if randomExtraLoot == 1 then
			SpawnMobLoot( entity, "items/loot/resources/shard_cobalt_item", 0, 3, 3 )
		elseif randomExtraLoot == 2 then
			SpawnMobLoot( entity, "items/loot/resources/shard_ferdonite_item", 0, 3, 3 )
		elseif randomExtraLoot == 3 then
			SpawnMobLoot( entity, "items/loot/resources/shard_hazenite_item", 0, 3, 3 )
		elseif randomExtraLoot == 4 then
			SpawnMobLoot( entity, "items/loot/resources/shard_palladium_item", 0, 3, 3 )
		elseif randomExtraLoot == 5 then
			SpawnMobLoot( entity, "items/loot/resources/shard_rhodonite_item", 0, 3, 3 )
		elseif randomExtraLoot == 6 then
			SpawnMobLoot( entity, "items/loot/resources/shard_tanzanite_item", 0, 3, 3 )
		elseif randomExtraLoot == 7 then
			SpawnMobLoot( entity, "items/loot/resources/shard_titanium_item", 0, 3, 3 )
		elseif randomExtraLoot == 8 then
			SpawnMobLoot( entity, "items/loot/resources/shard_uranium_item", 0, 3, 3 )
		end

	end

	if (blueprint == "units/ground/arachnoid_sentinel_1") or
	   (blueprint == "units/ground/arachnoid_sentinel_2") or
	   (blueprint == "units/ground/arachnoid_sentinel_3") or
	   (blueprint == "units/ground/arachnoid_sentinel_base") then
		--rare resources
		randomExtraLoot = RandInt( 1, 8 )
		if randomExtraLoot == 1 then
			SpawnMobLoot( entity, "items/loot/resources/shard_cobalt_item", 0, 1, 1 )
		elseif randomExtraLoot == 2 then
			SpawnMobLoot( entity, "items/loot/resources/shard_ferdonite_item", 0, 1, 1 )
		elseif randomExtraLoot == 3 then
			SpawnMobLoot( entity, "items/loot/resources/shard_hazenite_item", 0, 1, 1 )
		elseif randomExtraLoot == 4 then
			SpawnMobLoot( entity, "items/loot/resources/shard_palladium_item", 0, 1, 1 )
		elseif randomExtraLoot == 5 then
			SpawnMobLoot( entity, "items/loot/resources/shard_rhodonite_item", 0, 1, 1 )
		elseif randomExtraLoot == 6 then
			SpawnMobLoot( entity, "items/loot/resources/shard_tanzanite_item", 0, 1, 1 )
		elseif randomExtraLoot == 7 then
			SpawnMobLoot( entity, "items/loot/resources/shard_titanium_item", 0, 1, 1 )
		elseif randomExtraLoot == 8 then
			SpawnMobLoot( entity, "items/loot/resources/shard_uranium_item", 0, 1, 1 )
		end

	end

	if (blueprint == "units/ground/arachnoid_sentinel_alpha_1") or
	   (blueprint == "units/ground/arachnoid_sentinel_alpha_2") or
	   (blueprint == "units/ground/arachnoid_sentinel_alpha_3") or
	   (blueprint == "units/ground/arachnoid_sentinel_alpha_base") then
		--rare resources
		randomExtraLoot = RandInt( 1, 8 )
		if randomExtraLoot == 1 then
			SpawnMobLoot( entity, "items/loot/resources/shard_cobalt_item", 0, 2, 2 )
		elseif randomExtraLoot == 2 then
			SpawnMobLoot( entity, "items/loot/resources/shard_ferdonite_item", 0, 2, 2 )
		elseif randomExtraLoot == 3 then
			SpawnMobLoot( entity, "items/loot/resources/shard_hazenite_item", 0, 2, 2 )
		elseif randomExtraLoot == 4 then
			SpawnMobLoot( entity, "items/loot/resources/shard_palladium_item", 0, 2, 2 )
		elseif randomExtraLoot == 5 then
			SpawnMobLoot( entity, "items/loot/resources/shard_rhodonite_item", 0, 2, 2 )
		elseif randomExtraLoot == 6 then
			SpawnMobLoot( entity, "items/loot/resources/shard_tanzanite_item", 0, 2, 2 )
		elseif randomExtraLoot == 7 then
			SpawnMobLoot( entity, "items/loot/resources/shard_titanium_item", 0, 2, 2 )
		elseif randomExtraLoot == 8 then
			SpawnMobLoot( entity, "items/loot/resources/shard_uranium_item", 0, 2, 2 )
		end

	end

	if (blueprint == "units/ground/arachnoid_sentinel_ultra_1") or
	   (blueprint == "units/ground/arachnoid_sentinel_ultra_2") or
	   (blueprint == "units/ground/arachnoid_sentinel_ultra_3") or
	   (blueprint == "units/ground/arachnoid_sentinel_ultra_base") then
		--rare resources
		randomExtraLoot = RandInt( 1, 8 )
		if randomExtraLoot == 1 then
			SpawnMobLoot( entity, "items/loot/resources/shard_cobalt_item", 0, 3, 3 )
		elseif randomExtraLoot == 2 then
			SpawnMobLoot( entity, "items/loot/resources/shard_ferdonite_item", 0, 3, 3 )
		elseif randomExtraLoot == 3 then
			SpawnMobLoot( entity, "items/loot/resources/shard_hazenite_item", 0, 3, 3 )
		elseif randomExtraLoot == 4 then
			SpawnMobLoot( entity, "items/loot/resources/shard_palladium_item", 0, 3, 3 )
		elseif randomExtraLoot == 5 then
			SpawnMobLoot( entity, "items/loot/resources/shard_rhodonite_item", 0, 3, 3 )
		elseif randomExtraLoot == 6 then
			SpawnMobLoot( entity, "items/loot/resources/shard_tanzanite_item", 0, 3, 3 )
		elseif randomExtraLoot == 7 then
			SpawnMobLoot( entity, "items/loot/resources/shard_titanium_item", 0, 3, 3 )
		elseif randomExtraLoot == 8 then
			SpawnMobLoot( entity, "items/loot/resources/shard_uranium_item", 0, 3, 3 )
		end

	end


	if (blueprint == "units/ground/bomogan") then
		--rare resources
		randomExtraLoot = RandInt( 1, 8 )
		if randomExtraLoot == 1 then
			SpawnMobLoot( entity, "items/loot/resources/shard_cobalt_item", 0, 1, 1 )
		elseif randomExtraLoot == 2 then
			SpawnMobLoot( entity, "items/loot/resources/shard_ferdonite_item", 0, 1, 1 )
		elseif randomExtraLoot == 3 then
			SpawnMobLoot( entity, "items/loot/resources/shard_hazenite_item", 0, 1, 1 )
		elseif randomExtraLoot == 4 then
			SpawnMobLoot( entity, "items/loot/resources/shard_palladium_item", 0, 1, 1 )
		elseif randomExtraLoot == 5 then
			SpawnMobLoot( entity, "items/loot/resources/shard_rhodonite_item", 0, 1, 1 )
		elseif randomExtraLoot == 6 then
			SpawnMobLoot( entity, "items/loot/resources/shard_tanzanite_item", 0, 1, 1 )
		elseif randomExtraLoot == 7 then
			SpawnMobLoot( entity, "items/loot/resources/shard_titanium_item", 0, 1, 1 )
		elseif randomExtraLoot == 8 then
			SpawnMobLoot( entity, "items/loot/resources/shard_uranium_item", 0, 1, 1 )
		end

	end

	if (blueprint == "units/ground/bomogan_alpha") then
		--rare resources
		randomExtraLoot = RandInt( 1, 8 )
		if randomExtraLoot == 1 then
			SpawnMobLoot( entity, "items/loot/resources/shard_cobalt_item", 0, 2, 2 )
		elseif randomExtraLoot == 2 then
			SpawnMobLoot( entity, "items/loot/resources/shard_ferdonite_item", 0, 2, 2 )
		elseif randomExtraLoot == 3 then
			SpawnMobLoot( entity, "items/loot/resources/shard_hazenite_item", 0, 2, 2 )
		elseif randomExtraLoot == 4 then
			SpawnMobLoot( entity, "items/loot/resources/shard_palladium_item", 0, 2, 2 )
		elseif randomExtraLoot == 5 then
			SpawnMobLoot( entity, "items/loot/resources/shard_rhodonite_item", 0, 2, 2 )
		elseif randomExtraLoot == 6 then
			SpawnMobLoot( entity, "items/loot/resources/shard_tanzanite_item", 0, 2, 2 )
		elseif randomExtraLoot == 7 then
			SpawnMobLoot( entity, "items/loot/resources/shard_titanium_item", 0, 2, 2 )
		elseif randomExtraLoot == 8 then
			SpawnMobLoot( entity, "items/loot/resources/shard_uranium_item", 0, 2, 2 )
		end

	end

	if (blueprint == "units/ground/bomogan_base") or
	   (blueprint == "units/ground/bomogan_ultra") then
		--rare resources
		randomExtraLoot = RandInt( 1, 8 )
		if randomExtraLoot == 1 then
			SpawnMobLoot( entity, "items/loot/resources/shard_cobalt_item", 0, 3, 3 )
		elseif randomExtraLoot == 2 then
			SpawnMobLoot( entity, "items/loot/resources/shard_ferdonite_item", 0, 3, 3 )
		elseif randomExtraLoot == 3 then
			SpawnMobLoot( entity, "items/loot/resources/shard_hazenite_item", 0, 3, 3 )
		elseif randomExtraLoot == 4 then
			SpawnMobLoot( entity, "items/loot/resources/shard_palladium_item", 0, 3, 3 )
		elseif randomExtraLoot == 5 then
			SpawnMobLoot( entity, "items/loot/resources/shard_rhodonite_item", 0, 3, 3 )
		elseif randomExtraLoot == 6 then
			SpawnMobLoot( entity, "items/loot/resources/shard_tanzanite_item", 0, 3, 3 )
		elseif randomExtraLoot == 7 then
			SpawnMobLoot( entity, "items/loot/resources/shard_titanium_item", 0, 3, 3 )
		elseif randomExtraLoot == 8 then
			SpawnMobLoot( entity, "items/loot/resources/shard_uranium_item", 0, 3, 3 )
		end

	end

end




function amazing:OnWinCheck()

	local countSpawners
	local upgradeSpawners
	local posSpawnersX
	local posSpawnersZ
	

	countSpawners = #FindService:FindEntitiesByBlueprint( "units/ground/spawner_canoptrix_normal" )
	countSpawners = #FindService:FindEntitiesByBlueprint( "units/ground/spawner_canoptrix_hard" ) + countSpawners
	countSpawners = #FindService:FindEntitiesByBlueprint( "units/ground/spawner_canoptrix_brutal" ) + countSpawners
	countSpawners = #FindService:FindEntitiesByBlueprint( "units/ground/spawner_arachnoid_sentinel_normal" ) + countSpawners
	countSpawners = #FindService:FindEntitiesByBlueprint( "units/ground/spawner_arachnoid_sentinel_hard" ) + countSpawners
	countSpawners = #FindService:FindEntitiesByBlueprint( "units/ground/spawner_arachnoid_sentinel_brutal" ) + countSpawners
	countSpawners = #FindService:FindEntitiesByBlueprint( "units/ground/spawner_bomogan_normal" ) + countSpawners
	countSpawners = #FindService:FindEntitiesByBlueprint( "units/ground/spawner_bomogan_hard" ) + countSpawners
	countSpawners = #FindService:FindEntitiesByBlueprint( "units/ground/spawner_bomogan_brutal" ) + countSpawners


	if ( countSpawners < 20 ) and ( self.spawnerDifficulty < 1 ) then

		upgradeSpawners = FindService:FindEntitiesByBlueprint( "units/ground/spawner_canoptrix_normal" )
		for spawner in Iter( upgradeSpawners ) do
			posSpawnersX = EntityService:GetPositionX( spawner )
			posSpawnersZ = EntityService:GetPositionZ( spawner )
			EntityService:RemoveComponent( spawner, "TeamComponent" )
			EntityService:DissolveEntity( spawner, 1 )
			EntityService:SpawnEntity( "units/ground/spawner_canoptrix_hard", posSpawnersX, 0.0, posSpawnersZ, "" )
		end

		upgradeSpawners = FindService:FindEntitiesByBlueprint( "units/ground/spawner_arachnoid_sentinel_normal" )
		for spawner in Iter( upgradeSpawners ) do
			posSpawnersX = EntityService:GetPositionX( spawner )
			posSpawnersZ = EntityService:GetPositionZ( spawner )
			EntityService:RemoveComponent( spawner, "TeamComponent" )
			EntityService:DissolveEntity( spawner, 1 )
			EntityService:SpawnEntity( "units/ground/spawner_arachnoid_sentinel_hard", posSpawnersX, 0.0, posSpawnersZ, "" )
		end

		upgradeSpawners = FindService:FindEntitiesByBlueprint( "units/ground/spawner_bomogan_normal" )
		for spawner in Iter( upgradeSpawners ) do
			posSpawnersX = EntityService:GetPositionX( spawner )
			posSpawnersZ = EntityService:GetPositionZ( spawner )
			EntityService:RemoveComponent( spawner, "TeamComponent" )
			EntityService:DissolveEntity( spawner, 1 )
			EntityService:SpawnEntity( "units/ground/spawner_bomogan_hard", posSpawnersX, 0.0, posSpawnersZ, "" )
		end

		self.spawnerDifficulty = 1

	elseif ( countSpawners < 10 ) and ( self.spawnerDifficulty < 2 ) then

		upgradeSpawners = FindService:FindEntitiesByBlueprint( "units/ground/spawner_canoptrix_hard" )
		for spawner in Iter( upgradeSpawners ) do
			posSpawnersX = EntityService:GetPositionX( spawner )
			posSpawnersZ = EntityService:GetPositionZ( spawner )
			EntityService:RemoveComponent( spawner, "TeamComponent" )
			EntityService:DissolveEntity( spawner, 1 )
			EntityService:SpawnEntity( "units/ground/spawner_canoptrix_brutal", posSpawnersX, 0.0, posSpawnersZ, "" )
		end

		upgradeSpawners = FindService:FindEntitiesByBlueprint( "units/ground/spawner_arachnoid_sentinel_hard" )
		for spawner in Iter( upgradeSpawners ) do
			posSpawnersX = EntityService:GetPositionX( spawner )
			posSpawnersZ = EntityService:GetPositionZ( spawner )
			EntityService:RemoveComponent( spawner, "TeamComponent" )
			EntityService:DissolveEntity( spawner, 1 )
			EntityService:SpawnEntity( "units/ground/spawner_arachnoid_sentinel_brutal", posSpawnersX, 0.0, posSpawnersZ, "" )
		end

		upgradeSpawners = FindService:FindEntitiesByBlueprint( "units/ground/spawner_bomogan_hard" )
		for spawner in Iter( upgradeSpawners ) do
			posSpawnersX = EntityService:GetPositionX( spawner )
			posSpawnersZ = EntityService:GetPositionZ( spawner )
			EntityService:RemoveComponent( spawner, "TeamComponent" )
			EntityService:DissolveEntity( spawner, 1 )
			EntityService:SpawnEntity( "units/ground/spawner_bomogan_brutal", posSpawnersX, 0.0, posSpawnersZ, "" )
		end

		self.spawnerDifficulty = 2

	end


	if ( (countSpawners == 0) and (self.hasWon == false) ) then
		self.hasWon = true
		MissionService:ShowEndGameHud( 1.0, true )
        end   
end









return amazing
