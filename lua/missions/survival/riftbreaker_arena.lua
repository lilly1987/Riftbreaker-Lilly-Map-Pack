require("lua/utils/table_utils.lua")
require("lua/utils/rules_utils.lua")

local survival_base = require( "lua/missions/survival/survival_base.lua" )
class 'riftbreaker_arena' ( survival_base )

function riftbreaker_arena:__init()
    survival_base.__init(self,self)
end

function riftbreaker_arena:init()
	LogService:Log( "riftbreaker_arena:init()" )
	self:PrepareSpawnPoints()

    	local database = self.data
	database:SetFloat("mission_duration", DifficultyService:GetMissionDuration() )
	database:SetFloat("final_wave_time", DifficultyService:GetMissionDuration() - 120)
	database:SetFloat("warmup_duration", 5 )

	if ( DifficultyService:IsMissionInfinite() == true ) then
		database:SetString("mission_infinite", "1" )
	else
		database:SetString("mission_infinite", "0" )
	end

	MissionService:ActivateMissionFlow("", "logic/missions/survival/default.logic", "default", database )

	local rules = require( GetRulesForDifficulty( "lua/missions/survival/dom_riftbreaker_arena_rules_" ) )()
	MissionService:AddGameRule( "lua/missions/dom_manager.lua", rules )

	self:RegisterHandler( event_sink, "DestroyRequest",  "_OnDestroyRequest" )
end

local function SpawnMobLoot( entity, blueprint, minAmount, maxAmount, packageSize )

	local spawnCount = RandInt( minAmount, maxAmount )

	while ( spawnCount > 0 )
	do
	        local count = math.min( spawnCount, packageSize )
        	spawnCount = spawnCount - count

	        ItemService:SpawnLoot( entity, blueprint, count )
    	end
end

function riftbreaker_arena:_OnDestroyRequest( evt )
	
	local entity = evt:GetEntity()
	local blueprint = EntityService:GetBlueprintName( entity )
	local randomExtraLoot

	if (blueprint == "units/ground/canoptrix_1") or
	   (blueprint == "units/ground/canoptrix_2") or
	   (blueprint == "units/ground/canoptrix_3") or
	   (blueprint == "units/ground/canoptrix_base") then
		--common resources
		SpawnMobLoot( entity, "items/loot/resources/shard_carbonium_item", 0, 2, 2 )
		SpawnMobLoot( entity, "items/loot/resources/shard_steel_item", 0, 2, 2 )
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
		--common resources
		SpawnMobLoot( entity, "items/loot/resources/shard_carbonium_item", 0, 4, 4 )
		SpawnMobLoot( entity, "items/loot/resources/shard_steel_item", 0, 4, 4 )
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
		--common resources
		SpawnMobLoot( entity, "items/loot/resources/shard_carbonium_item", 0, 6, 6 )
		SpawnMobLoot( entity, "items/loot/resources/shard_steel_item", 0, 6, 6 )
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
		--common resources
		SpawnMobLoot( entity, "items/loot/resources/shard_carbonium_item", 0, 2, 2 )
		SpawnMobLoot( entity, "items/loot/resources/shard_steel_item", 0, 2, 2 )
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
		--common resources
		SpawnMobLoot( entity, "items/loot/resources/shard_carbonium_item", 0, 4, 4 )
		SpawnMobLoot( entity, "items/loot/resources/shard_steel_item", 0, 4, 4 )
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
		--common resources
		SpawnMobLoot( entity, "items/loot/resources/shard_carbonium_item", 0, 6, 6 )
		SpawnMobLoot( entity, "items/loot/resources/shard_steel_item", 0, 6, 6 )
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


	if (blueprint == "units/ground/kafferroceros") or
	   (blueprint == "units/ground/kafferroceros_base") then
		--common resources
		SpawnMobLoot( entity, "items/loot/resources/shard_carbonium_item", 0, 2, 2 )
		SpawnMobLoot( entity, "items/loot/resources/shard_steel_item", 0, 2, 2 )
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

	if (blueprint == "units/ground/kafferroceros_alpha") then
		--common resources
		SpawnMobLoot( entity, "items/loot/resources/shard_carbonium_item", 0, 4, 4 )
		SpawnMobLoot( entity, "items/loot/resources/shard_steel_item", 0, 4, 4 )
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

	if (blueprint == "units/ground/kafferroceros_ultra") then
		--common resources
		SpawnMobLoot( entity, "items/loot/resources/shard_carbonium_item", 0, 6, 6 )
		SpawnMobLoot( entity, "items/loot/resources/shard_steel_item", 0, 6, 6 )
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

	if (blueprint == "units/ground/gnerot") then
		--common resources
		SpawnMobLoot( entity, "items/loot/resources/shard_carbonium_item", 0, 2, 2 )
		SpawnMobLoot( entity, "items/loot/resources/shard_steel_item", 0, 2, 2 )
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

	if (blueprint == "units/ground/gnerot_alpha") then
		--common resources
		SpawnMobLoot( entity, "items/loot/resources/shard_carbonium_item", 0, 4, 4 )
		SpawnMobLoot( entity, "items/loot/resources/shard_steel_item", 0, 4, 4 )
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

	if (blueprint == "units/ground/gnerot_burning") or
	   (blueprint == "units/ground/gnerot_ultra") then
		--common resources
		SpawnMobLoot( entity, "items/loot/resources/shard_carbonium_item", 0, 6, 6 )
		SpawnMobLoot( entity, "items/loot/resources/shard_steel_item", 0, 6, 6 )
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

	if (blueprint == "units/ground/baxmoth") then
		--common resources
		SpawnMobLoot( entity, "items/loot/resources/shard_carbonium_item", 0, 2, 2 )
		SpawnMobLoot( entity, "items/loot/resources/shard_steel_item", 0, 2, 2 )
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

	if (blueprint == "units/ground/baxmoth_alpha") then
		--common resources
		SpawnMobLoot( entity, "items/loot/resources/shard_carbonium_item", 0, 4, 4 )
		SpawnMobLoot( entity, "items/loot/resources/shard_steel_item", 0, 4, 4 )
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

	if (blueprint == "units/ground/baxmoth_base") or
	   (blueprint == "units/ground/baxmoth_ultra") then
		--common resources
		SpawnMobLoot( entity, "items/loot/resources/shard_carbonium_item", 0, 6, 6 )
		SpawnMobLoot( entity, "items/loot/resources/shard_steel_item", 0, 6, 6 )
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
		--common resources
		SpawnMobLoot( entity, "items/loot/resources/shard_carbonium_item", 0, 2, 2 )
		SpawnMobLoot( entity, "items/loot/resources/shard_steel_item", 0, 2, 2 )
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
		--common resources
		SpawnMobLoot( entity, "items/loot/resources/shard_carbonium_item", 0, 4, 4 )
		SpawnMobLoot( entity, "items/loot/resources/shard_steel_item", 0, 4, 4 )
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
		--common resources
		SpawnMobLoot( entity, "items/loot/resources/shard_carbonium_item", 0, 6, 6 )
		SpawnMobLoot( entity, "items/loot/resources/shard_steel_item", 0, 6, 6 )
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








return riftbreaker_arena
