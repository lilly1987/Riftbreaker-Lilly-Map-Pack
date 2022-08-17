require("lua/utils/table_utils.lua")
require("lua/utils/rules_utils.lua")

local survival_base = require( "lua/missions/survival/survival_base.lua" )
class 'survival_xmas' ( survival_base )

function survival_xmas:__init()
    survival_base.__init(self,self)
end

----------------------------------------------------------------------------------------------------------------------------

function survival_xmas:init()
	
	self:PrepareSpawnPoints();

	local database = self.data

    	MissionService:ActivateMissionFlow("", "logic/missions/survival/default.logic", "default", database )
	local rules = require( GetRulesForDifficulty( "lua/missions/survival/dom_survival_jungle_rules_" ) )()
	MissionService:AddGameRule( "lua/missions/dom_manager.lua", rules )

	self:RegisterHandler( event_sink, "DestroyRequest",  "_OnDestroyRequest" )

end

------------------------------------------------------------------------------------------------------------------------------

local function SpawnCreeperLoot( entity, blueprint, minAmount, maxAmount, packageSize )

	local spawnCount = RandInt( minAmount, maxAmount )

	while ( spawnCount > 0 )
	do
	        local count = math.min( spawnCount, packageSize )
        	spawnCount = spawnCount - count

	        ItemService:SpawnLoot( entity, blueprint, count )
    	end
end


function survival_xmas:_OnDestroyRequest( evt )
	
	local entity = evt:GetEntity()
	local blueprint = EntityService:GetBlueprintName( entity )
	local randomExtraLoot
	local randomPresentLoot

	--creeper_branch loot
	if (blueprint == "units/ground/creeper_branch_01_xmas") or
	   (blueprint == "units/ground/creeper_branch_02_xmas") or
	   (blueprint == "units/ground/creeper_branch_03_xmas") then
		--common resources

		randomPresentLoot = RandInt( 1, 400 )
		if (randomPresentLoot >= 1) and (randomPresentLoot <= 190) then
			SpawnCreeperLoot( entity, "items/loot/resources/shard_carbonium_item", 0, 3, 3 )

		elseif (randomPresentLoot >= 191) and (randomPresentLoot <= 380) then
			SpawnCreeperLoot( entity, "items/loot/resources/shard_steel_item", 0, 3, 3 )




		elseif (randomPresentLoot >= 381) and (randomPresentLoot <= 388) then
			local xPos = EntityService:GetPositionX( entity )
			local zPos = EntityService:GetPositionX( entity )

			local rand_xPos = RandInt( xPos - 4, xPos + 4 )
			local rand_zPos = RandInt( zPos - 4, zPos + 4 )
			EntityService:SpawnEntity( "units/ground/canoptrix", rand_xPos, 0, rand_zPos, "hostility" )

			rand_xPos = RandInt( xPos - 4, xPos + 4 )
			rand_zPos = RandInt( zPos - 4, zPos + 4 )
			EntityService:SpawnEntity( "units/ground/canoptrix", rand_xPos, 0, rand_zPos, "hostility" )

			rand_xPos = RandInt( xPos - 4, xPos + 4 )
			rand_zPos = RandInt( zPos - 4, zPos + 4 )
			EntityService:SpawnEntity( "units/ground/canoptrix", rand_xPos, 0, rand_zPos, "hostility" )

			rand_xPos = RandInt( xPos - 4, xPos + 4 )
			rand_zPos = RandInt( zPos - 4, zPos + 4 )
			EntityService:SpawnEntity( "units/ground/canoptrix", rand_xPos, 0, rand_zPos, "hostility" )

			rand_xPos = RandInt( xPos - 4, xPos + 4 )
			rand_zPos = RandInt( zPos - 4, zPos + 4 )
			EntityService:SpawnEntity( "units/ground/canoptrix", rand_xPos, 0, rand_zPos, "hostility" )




		elseif (randomPresentLoot >= 389) and (randomPresentLoot <= 391) then
			EntityService:SpawnEntity( "units/ground/arachnoid_sentinel", entity, "hostility" )

		elseif (randomPresentLoot >= 392) and (randomPresentLoot <= 394) then
			EntityService:SpawnEntity( "units/ground/kafferroceros", entity, "hostility" )




		elseif randomPresentLoot == 395 then
			EntityService:SpawnEntity( "units/ground/kermon", entity, "hostility" )

		elseif randomPresentLoot == 396 then
			EntityService:SpawnEntity( "units/ground/bomogan", entity, "hostility" )

		elseif randomPresentLoot == 397 then
			EntityService:SpawnEntity( "units/ground/nurglax", entity, "hostility" )

		elseif randomPresentLoot == 398 then
			EntityService:SpawnEntity( "units/ground/baxmoth", entity, "hostility" )

		elseif randomPresentLoot == 399 then
			EntityService:SpawnEntity( "units/ground/phirian", entity, "hostility" )

		elseif randomPresentLoot == 400 then
			EntityService:SpawnEntity( "units/ground/lesigian", entity, "hostility" )


		end

	end


	--creeper_root loot
	if (blueprint == "units/ground/creeper_root_01_xmas") or
	   (blueprint == "units/ground/creeper_root_02_xmas") then

		--common resources
		SpawnCreeperLoot( entity, "items/loot/resources/shard_carbonium_item", 5, 10, 3 )
		SpawnCreeperLoot( entity, "items/loot/resources/shard_steel_item", 5, 10, 3 )

		--rare resources
		randomExtraLoot = RandInt( 1, 8 )
		if randomExtraLoot == 1 then
			SpawnCreeperLoot( entity, "items/loot/resources/shard_cobalt_item", 10, 20, 3 )
		elseif randomExtraLoot == 2 then
			SpawnCreeperLoot( entity, "items/loot/resources/shard_ferdonite_item", 10, 20, 3 )
		elseif randomExtraLoot == 3 then
			SpawnCreeperLoot( entity, "items/loot/resources/shard_hazenite_item", 10, 20, 3 )
		elseif randomExtraLoot == 4 then
			SpawnCreeperLoot( entity, "items/loot/resources/shard_palladium_item", 10, 20, 3 )
		elseif randomExtraLoot == 5 then
			SpawnCreeperLoot( entity, "items/loot/resources/shard_rhodonite_item", 10, 20, 3 )
		elseif randomExtraLoot == 6 then
			SpawnCreeperLoot( entity, "items/loot/resources/shard_tanzanite_item", 10, 20, 3 )
		elseif randomExtraLoot == 7 then
			SpawnCreeperLoot( entity, "items/loot/resources/shard_titanium_item", 10, 20, 3 )
		elseif randomExtraLoot == 8 then
			SpawnCreeperLoot( entity, "items/loot/resources/shard_uranium_ore_item", 10, 20, 3 )
		end

	end

	--creeper_root_origin loot
	if (blueprint == "units/ground/creeper_root_origin_xmas") then

		--common resources
		SpawnCreeperLoot( entity, "items/loot/resources/shard_carbonium_item", 50, 100, 3 )
		SpawnCreeperLoot( entity, "items/loot/resources/shard_steel_item", 50, 100, 3 )

		--rare resources
		randomExtraLoot = RandInt( 1, 8 )
		if randomExtraLoot == 1 then
			SpawnCreeperLoot( entity, "items/loot/resources/shard_cobalt_item", 100, 200, 3 )
		elseif randomExtraLoot == 2 then
			SpawnCreeperLoot( entity, "items/loot/resources/shard_ferdonite_item", 100, 200, 3 )
		elseif randomExtraLoot == 3 then
			SpawnCreeperLoot( entity, "items/loot/resources/shard_hazenite_item", 100, 200, 3 )
		elseif randomExtraLoot == 4 then
			SpawnCreeperLoot( entity, "items/loot/resources/shard_palladium_item", 100, 200, 3 )
		elseif randomExtraLoot == 5 then
			SpawnCreeperLoot( entity, "items/loot/resources/shard_rhodonite_item", 100, 200, 3 )
		elseif randomExtraLoot == 6 then
			SpawnCreeperLoot( entity, "items/loot/resources/shard_tanzanite_item", 100, 200, 3 )
		elseif randomExtraLoot == 7 then
			SpawnCreeperLoot( entity, "items/loot/resources/shard_titanium", 100, 200, 3 )
		elseif randomExtraLoot == 8 then
			SpawnCreeperLoot( entity, "items/loot/resources/shard_uranium_ore_item", 100, 200, 3 )
		end

		--extreme weapon mods (limited resource)
		randomExtraLoot = RandInt( 1, 24 )
		if randomExtraLoot == 1 then
			SpawnCreeperLoot( entity, "items/loot/weapon_mods/mod_ammo_cost_extreme_item", 1, 1, 1 )
		elseif randomExtraLoot == 2 then
			SpawnCreeperLoot( entity, "items/loot/weapon_mods/mod_ammo_spread_add_extreme_item", 1, 1, 1 )
		elseif randomExtraLoot == 3 then
			SpawnCreeperLoot( entity, "items/loot/weapon_mods/mod_ammo_spread_sub_extreme_item", 1, 1, 1 )
		elseif randomExtraLoot == 4 then
			SpawnCreeperLoot( entity, "items/loot/weapon_mods/mod_autoaim_extreme_item", 1, 1, 1 )
		elseif randomExtraLoot == 5 then
			SpawnCreeperLoot( entity, "items/loot/weapon_mods/mod_autoaim_enable_extreme_item", 1, 1, 1 )
		elseif randomExtraLoot == 6 then
			SpawnCreeperLoot( entity, "items/loot/weapon_mods/mod_cluster_projectiles_extreme_item", 1, 1, 1 )
		elseif randomExtraLoot == 7 then
			SpawnCreeperLoot( entity, "items/loot/weapon_mods/mod_cluster_projectiles_enable_extreme_item", 1, 1, 1 )
		elseif randomExtraLoot == 8 then
			SpawnCreeperLoot( entity, "items/loot/weapon_mods/mod_critical_chance_extreme_item", 1, 1, 1 )
		elseif randomExtraLoot == 9 then
			SpawnCreeperLoot( entity, "items/loot/weapon_mods/mod_damage_extreme_item", 1, 1, 1 )
		elseif randomExtraLoot == 10 then
			SpawnCreeperLoot( entity, "items/loot/weapon_mods/mod_damage_over_time_extreme_item", 1, 1, 1 )
		elseif randomExtraLoot == 11 then
			SpawnCreeperLoot( entity, "items/loot/weapon_mods/mod_damage_over_time_enable_extreme_item", 1, 1, 1 )
		elseif randomExtraLoot == 12 then
			SpawnCreeperLoot( entity, "items/loot/weapon_mods/mod_damage_penetration_extreme_item", 1, 1, 1 )
		elseif randomExtraLoot == 13 then
			SpawnCreeperLoot( entity, "items/loot/weapon_mods/mod_damage_penetration_enable_extreme_item", 1, 1, 1 )
		elseif randomExtraLoot == 14 then
			SpawnCreeperLoot( entity, "items/loot/weapon_mods/mod_fire_per_shot_extreme_item", 1, 1, 1 )
		elseif randomExtraLoot == 15 then
			SpawnCreeperLoot( entity, "items/loot/weapon_mods/mod_fire_rate_extreme_item", 1, 1, 1 )
		elseif randomExtraLoot == 16 then
			SpawnCreeperLoot( entity, "items/loot/weapon_mods/mod_homing_extreme_item", 1, 1, 1 )
		elseif randomExtraLoot == 17 then
			SpawnCreeperLoot( entity, "items/loot/weapon_mods/mod_homing_enable_extreme_item", 1, 1, 1 )
		elseif randomExtraLoot == 18 then
			SpawnCreeperLoot( entity, "items/loot/weapon_mods/mod_lifesteal_extreme_item", 1, 1, 1 )
		elseif randomExtraLoot == 19 then
			SpawnCreeperLoot( entity, "items/loot/weapon_mods/mod_lifesteal_enable_extreme_item", 1, 1, 1 )
		elseif randomExtraLoot == 20 then
			SpawnCreeperLoot( entity, "items/loot/weapon_mods/mod_range_extreme_item", 1, 1, 1 )
		elseif randomExtraLoot == 21 then
			SpawnCreeperLoot( entity, "items/loot/weapon_mods/mod_splash_damage_extreme_item", 1, 1, 1 )
		elseif randomExtraLoot == 22 then
			SpawnCreeperLoot( entity, "items/loot/weapon_mods/mod_splash_damage_enable_extreme_item", 1, 1, 1 )
		elseif randomExtraLoot == 23 then
			SpawnCreeperLoot( entity, "items/loot/weapon_mods/mod_stun_chance_extreme_item", 1, 1, 1 )
		elseif randomExtraLoot == 24 then
			SpawnCreeperLoot( entity, "items/loot/weapon_mods/mod_stun_chance_enable_extreme_item", 1, 1, 1 )
		end

	end


end

return survival_xmas
