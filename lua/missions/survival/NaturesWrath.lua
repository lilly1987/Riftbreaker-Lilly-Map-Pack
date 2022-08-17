require("lua/utils/table_utils.lua")
require("lua/utils/rules_utils.lua")

local survival_base = require( "lua/missions/survival/survival_base.lua" )
class 'MasterExploder' ( survival_base )

function MasterExploder:__init()
    survival_base.__init(self,self)
end

function MasterExploder:init()

----------------------------------------------------------------------------------------------------------------------------
	
	self:PrepareSpawnPoints();

	local database = self.data

    	MissionService:ActivateMissionFlow("", "logic/missions/survival/default.logic", "default", database )
	local rules = require( GetRulesForDifficulty( "lua/missions/survival/dom_survival_jungle_rules_" ) )()
	MissionService:AddGameRule( "lua/missions/dom_manager.lua", rules )

	self.fsm = self:CreateStateMachine()
	self.fsm:AddState( "set_weather",	{ execute="OnSetWeather", interval=120.0 } )
	self.fsm:ChangeState("set_weather")	

end

------------------------------------------------------------------------------------------------------------------------------






function MasterExploder:OnSetWeather()

	local weatherType = RandInt( 1, 12 )

	if weatherType == 1 then
		MissionService:ActivateMissionFlow( "logic/weather/acid_rain.logic" )
	elseif weatherType == 2 then
		MissionService:ActivateMissionFlow( "logic/weather/blue_hail.logic" )
	elseif weatherType == 3 then
		MissionService:ActivateMissionFlow( "logic/weather/fog.logic" )
	elseif weatherType == 4 then
		MissionService:ActivateMissionFlow( "logic/weather/meteor_shower.logic" )
	elseif weatherType == 5 then
		MissionService:ActivateMissionFlow( "logic/weather/ion_storm.logic" )
	elseif weatherType == 6 then
		MissionService:ActivateMissionFlow( "logic/weather/tornado_near_base.logic" )
	elseif weatherType == 7 then
		MissionService:ActivateMissionFlow( "logic/weather/volcanic_ash_clouds" )
	elseif weatherType == 8 then
		MissionService:ActivateMissionFlow( "logic/weather/wind_strong.logic" )
	elseif weatherType == 9 then
		MissionService:ActivateMissionFlow( "logic/weather/wind_weak.logic" )
	elseif weatherType == 10 then
		MissionService:ActivateMissionFlow( "logic/weather/resource_earthquake.logic" )
	end

end









return MasterExploder
