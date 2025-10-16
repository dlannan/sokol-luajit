
local tinsert 	= table.insert
local tremove 	= table.remove
local tcount 	= table.getn

-- ---------------------------------------------------------------------------

local ENGINE_EVENT = {

	NONE                = 0, 
	POLL                = 1,    -- This just keeps the connect alive
	ENDSTATE            = 2,    -- Use this to move to next state

	REQUEST_GAME        = 20,   -- Client needs game state
	REQUEST_ROUND       = 21,   -- Client needs round state
	REQUEST_SCENARIOS   = 22,   -- Fetch the list of scenarios

	REQUEST_START       = 30,   -- Owner wants to start
	REQUEST_READY       = 31,   -- Player changing ready state in lobby

	REQUEST_WAITING     = 40,   -- Player is waiting after a timeout or similar

	SENDING_SCENARIO    = 50,   -- MAster chooses scenario
}

-- ---------------------------------------------------------------------------

local STATE_NAME 		= {
	[50]	= "MenuMain", 

	[60]	= "MenuNew", 
	[70] 	= "MenuLobby",
	[80]	= "NOT IN USE", 

	[90]	= "GameJoining",   
	[91]	= "GameStart",   
	[93]	= "GameScenario",   
	[94]	= "GameSelect",	
	[99] 	= "GameFinish",   
}

local function namelookup( state )

	return STATE_NAME[state]
end 

-- ---------------------------------------------------------------------------

local ENTITY_TYPE 	= {
	UNKNOWN 		= 0,	-- Not yet designated
	CIVILIAN 		= 1, 	-- Non combatants
	FRIENDLY 		= 2,	-- Friendly is on the same force
	ALLY 			= 3,	-- Ally is on the same team, but different force (usually another country)
	THREAT 			= 4,	-- Is an enemy force
	MISSILE			= 5,	-- A missile - not detectable on radar 
}

-- ---------------------------------------------------------------------------

return {
	namelookup 		= namelookup,
	
	ENGINE_EVENT	= ENGINE_EVENT,
}

-- ---------------------------------------------------------------------------
