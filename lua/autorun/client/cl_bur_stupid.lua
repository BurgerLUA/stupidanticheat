local NextSendTime = 0
local ChecksToDo = 0
local CheaterChecks = 0
local Sensitivity = 0.25

local Delay = 5

function SAC_ClientThink()

	if NextSendTime <= CurTime() and not (NextSendTime + Delay*1.1 >= CurTime()) then
		
		for k,v in pairs(player.GetAll()) do
			v.CheaterChecks = 0
		end
		
		ChecksToDo = 60
		NextSendTime = CurTime() + Delay	
		
	end
	
	if ChecksToDo > 0 then
		SAC_AnalyzeAngles()
	end
	

end

hook.Add("Think","SAC_ClientThink",SAC_ClientThink)


function SAC_AnalyzeAngles()

	local ply = LocalPlayer()

	for k,v in pairs(player.GetAll()) do
		if v ~= LocalPlayer() then
		
			local ShootPos = ply:GetShootPos()
		
			local Angles = ply:EyeAngles()
			Angles:Normalize()
			
			local BadAngle01 = ( (v:GetPos() + v:OBBCenter()) - ShootPos ):Angle();
			BadAngle01:Normalize()
			local BadAngle02 = (v:EyePos() - ShootPos):Angle()
			BadAngle02:Normalize()

			
			if v == Entity(2) then
				--ply:SetEyeAngles(BadAngle02)
			end
			
			local Difference01 = (Angles - BadAngle01)
			Difference01:Normalize()
			local Difference02 = (Angles - BadAngle02)
			Difference02:Normalize()
			
			Difference01 = math.abs(Difference01.p) + math.abs(Difference01.y)
			Difference02 = math.abs(Difference02.p) + math.abs(Difference02.y)
			
			--print(Difference01)
			
			
			
			
			if Difference01 < Sensitivity or Difference02 < Sensitivity then
				if not v.CheaterChecks then
					v.CheaterChecks = 1
				else
					v.CheaterChecks = v.CheaterChecks + 1
				end
			else
			
			end
	
		end
	end
	
	ChecksToDo = ChecksToDo - 1
		
	if ChecksToDo == 0 then
		
		local Players = player.GetAll()
		
		local PlayerData = {}
		
		for k,v in pairs(Players) do
			if v ~= LocalPlayer() then	
				PlayerData[v] = v.CheaterChecks
			
			end
		end
	
		net.Start("SAC_Check")	
			net.WriteTable(PlayerData)
		net.SendToServer()
		
	end

end


net.Receive("SAC_FoldersAsk", function(len)

	local Asker = net.ReadEntity()
	
	local GmodFiles, GmodFolders = file.Find('addons/*', 'GAME') 
	
	--print("SENDING FOLDERS TO SERVER")

	net.Start("SAC_FoldersSend")
		net.WriteEntity(Asker)
		net.WriteTable(GmodFiles)
		net.WriteTable(GmodFolders)
	net.SendToServer()


end)

local ScaryWords = {
	"hack",
	"aim",
	"bot",
	"cheat",
	"radar",
	"crosshair",
	"bypass",
	"wall",
	"esp"
}

net.Receive("SAC_FoldersFinal", function(len)

	local Victim = net.ReadEntity()
	local GMAs = net.ReadTable()
	local Folders = net.ReadTable()
	
	MsgC(Color(255,255,255,255),"--------------------------------------")	; MsgN("")
	MsgC(Color(255,255,255,255),Victim:Nick() .. "'s Addon's Folder")		; MsgN("")
	MsgC(Color(255,255,255,255),"--------------------------------------")	; MsgN("")
	MsgC(Color(255,255,255,255),"-----------------GMA------------------")	; MsgN("")
	MsgC(Color(255,255,255,255),"--------------------------------------")	; MsgN("")
	
	for k,filename in pairs(GMAs) do
	
		local PrintColor = Color(255,255,0,255)

		for l,scary in pairs(ScaryWords) do
			if string.find(string.lower(filename),scary) then
				PrintColor = Color(255,0,0,255)
			end
		end
		
		MsgC(PrintColor,filename);MsgN("")

	end
	
	MsgC(Color(255,255,255,255),"--------------------------------------")	; MsgN("")
	MsgC(Color(255,255,255,255),"----------------FOLDERS---------------")	; MsgN("")
	MsgC(Color(255,255,255,255),"--------------------------------------")	; MsgN("")
	
	
	for k,filename in pairs(Folders) do
	
		local PrintColor = Color(255,255,0,255)

		for l,scary in pairs(ScaryWords) do
			if string.find(string.lower(filename),scary) then
				PrintColor = Color(255,0,0,255)
			end
		end
		
		MsgC(PrintColor,filename);MsgN("")

	end
	
	
	
	
	
	
	
	
	
	

end)




