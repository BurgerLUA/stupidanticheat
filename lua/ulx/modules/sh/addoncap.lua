function ulx.ogwhid( calling_ply, victim, link, time )
	calling_ply:ChatPrint("Check Console")
	for k,v in pairs(victim) do
		SAC_GetPlayerAddons(calling_ply,v)
	end
end

local ULXADDONCAP= ulx.command("Fun","ulx addoncap",ulx.ogwhid,"!addoncap",true,true)
ULXADDONCAP:addParam{type=ULib.cmds.PlayersArg}
ULXADDONCAP:defaultAccess( ULib.ACCESS_ADMIN )
ULXADDONCAP:help( "Gets a list of the player's installed addons." )

