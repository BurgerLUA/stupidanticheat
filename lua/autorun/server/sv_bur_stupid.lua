net.Receive("SAC_Check", function(len,ply)

	local DataTable = net.ReadTable()

	--PrintTable(DataTable)
	
	for k,v in pairs(DataTable) do
		if v >= 40 then
			ply:ChatPrint( v .. " out of 59")
			print(ply," MIGHT BE CHEATING! " .. v .. " out of " .. "59 frames detected aimbots!")
		end
	end

end)

function SAC_Think()




end


util.AddNetworkString("SAC_Check")
util.AddNetworkString("SAC_FoldersAsk")
util.AddNetworkString("SAC_FoldersSend")
util.AddNetworkString("SAC_FoldersFinal")

function SAC_AskForPlayersAddons(attacker,cmd,args,argStr)

	if attacker:IsSuperAdmin() then
	
		local PlayerToFind = args[1]
		
		if PlayerToFind then
		
			PlayerToFind = string.lower(PlayerToFind)
		
			local SelectedPlayer = nil
		
			for k,v in pairs(player.GetAll()) do
				if not SelectedPlayer then
					local Nick = string.lower(v:Name())
					
					--print(Nick,PlayerToFind)
					
					if string.find(Nick,PlayerToFind) then
						SelectedPlayer = v
					end
				end
			end
			
			if SelectedPlayer then
				attacker:ChatPrint("Found player " .. SelectedPlayer:Nick() .. ". If you don't get anything in the next minute, that means something went wrong.")

				SAC_GetPlayerAddons(attacker,SelectedPlayer)
				
			else
				attacker:ChatPrint("Player not found...")
			end
			
		end

	else
		attacker:ChatPrint("You're not an Admin.")
	end

end

concommand.Add("SAC_AskForPlayersAddons",SAC_AskForPlayersAddons)

function SAC_GetPlayerAddons(attacker,victim)

	--attacker:ChatPrint("Found player " .. SelectedPlayer:Nick() .. ". If you don't get anything in the next minute, that means something went wrong.")
	
	net.Start("SAC_FoldersAsk")
		net.WriteEntity(attacker)
	net.Send(victim)

end





net.Receive("SAC_FoldersSend", function(len,ply)

	local Victim = ply
	local Attacker = net.ReadEntity()
	local GmodFiles = net.ReadTable()
	local GmodFolders = net.ReadTable()
	
	--print("GOT MY SHIT")
	
	net.Start("SAC_FoldersFinal")
		net.WriteEntity(Victim)
		net.WriteTable(GmodFiles)
		net.WriteTable(GmodFolders)
	net.Send(Attacker)
	
	
	--PrintTable(GmodFiles)
	--PrintTable(GmodFolders)

end)







--print("stupid")