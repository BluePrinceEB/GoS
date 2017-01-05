class "Putin"

function Putin:__init(Menu)
        SlotToString = {[-6] = "P", [-5] = "R2", [-4] = "E2", [-3] = "W2", [-2] = "Q3", [-1] = "Q2", [_Q] = "Q", [_W] = "W", [_E] = "E", [_R] = "R"}

	if not Menu["CP"] then
		Menu:DropDown("CP", "Choose Prediction:", 2, {"Open Prediction", "GPrediction", "GoS Prediction"})
	end

	self:LoadPrediction(Menu)
end

function Putin:LoadPrediction(Menu)
	if not Menu["CP"] then return end
	if Menu.CP:Value() == 1 then
		self:LoadOPred()
	elseif Menu.CP:Value() == 2 then
		self:LoadGPred()
	end
end

function Putin:LoadOPred()
	if FileExist(COMMON_PATH.."\\OpenPredict.lua") then
	    require("OpenPredict")
	else
	    PrintChat("[Prediction] Downloading required lib, please wait...")
	    DownloadFileAsync("https://raw.githubusercontent.com/Jo7j/GoS/master/OpenPredict/OpenPredict.lua", COMMON_PATH .. "OpenPredict.lua", function() PrintChat("[Prediction] Download Completed") return end)
	    return
	end
end

function Putin:LoadGPred()
	if FileExist(COMMON_PATH.."\\GPrediction.lua") then
	    require("GPrediction")
	else
	    PrintChat("[Prediction] Downloading required lib, please wait...")
	    DownloadFileAsync("https://raw.githubusercontent.com/KeVuong/GoS/master/Common/GPrediction.lua", COMMON_PATH .. "GPrediction.lua", function() PrintChat("[Prediction] Download Completed") return end)
	    return
	end
end

function Putin:HitChance(Menu, Spell)
	Menu:DropDown("H"..SlotToString[Spell], "HitChance ".."["..SlotToString[Spell].."]", 2, {"Low", "Medium", "High"})
end

function Putin:Cast(From, To, Data, Spell, Menu)
    
    if not Menu["CP"] then return end

	Data.range  = Data.range or math.huge
	Data.speed  = Data.speed or math.huge
	Data.width  = Data.width or Data.radius
	Data.radius = Data.radius or Data.width/2
	Data.delay  = Data.delay or .25
	Data.col    = self:Collision(Spell, Data, Menu)
	Data.type   = self:Type(Spell, Data, Menu)
	Data.count  = Data.count or 1
	Data.aoe    = Data.aoe or false
	Data.angle  = Data.angle or 45

	if Menu.CP:Value() == 1 then
		if Data.col then
    		if Data.type:lower():find("lin") then
    			local Prediction = GetPrediction(To, Data, From)
    			if Prediction.hitChance >= self:HitChanceValue(Menu, Spell) and not Prediction:mCollision(Data.count) then
    				CastSkillShot(Spell, Prediction.castPos)
    			end
    		elseif Data.type:lower():find("cir") then
    			local Prediction = GetCircularAOEPrediction(To, Data, From)
    			if Prediction.hitChance >= self:HitChanceValue(Menu, Spell) and not Prediction:mCollision(Data.count) then
    				CastSkillShot(Spell, Prediction.castPos)
    			end
    		elseif Data.type:lower():find("con") then
    			local Prediction = GetConicAOEPrediction(To, Data, From)
    			if Prediction.hitChance >= self:HitChanceValue(Menu, Spell) and not Prediction:mCollision(Data.count) then
    				CastSkillShot(Spell, Prediction.castPos)
    			end
    		end
    	else
    		if Data.type:lower():find("lin") then
    			local Prediction = GetPrediction(To, Data, From)
    			if Prediction.hitChance >= self:HitChanceValue(Menu, Spell) then
    				CastSkillShot(Spell, Prediction.castPos)
    			end
    		elseif Data.type:lower():find("cir") then
    			local Prediction = GetCircularAOEPrediction(To, Data, From)
    			if Prediction.hitChance >= self:HitChanceValue(Menu, Spell) then
    				CastSkillShot(Spell, Prediction.castPos)
    			end
    		elseif Data.type:lower():find("con") then
    			local Prediction = GetConicAOEPrediction(To, Data, From)
    			if Prediction.hitChance >= self:HitChanceValue(Menu, Spell) then
    				CastSkillShot(Spell, Prediction.castPos)
    			end
    		end
    	end
	elseif Menu.CP:Value() == 2 then
    	        local Prediction = _G.gPred:GetPrediction(To, From, Data, Data.aoe, Data.col)
		if Prediction and Prediction.HitChance >= self:HitChanceValue(Menu, Spell) then
			CastSkillShot(Spell, Prediction.CastPosition)
		end
	elseif Menu.CP:Value() == 3 then
		local Prediction = GetPredictionForPlayer(From, To, GetMoveSpeed(To), Data.speed, Data.delay, Data.range, Data.width, Data.col, true)
		if Prediction and Prediction.HitChance == self:HitChanceValue(Menu, Spell) then
			CastSkillShot(Spell, Prediction.PredPos)
		end
	end
end

function Putin:Collision(Spell, Data, Menu)
	if not Menu["CP"] then return end
	if Menu.CP:Value() == 1 then
		return Data.col or false
	elseif Menu.CP:Value() == 2 then
		if Data.col then
			return {"minion", "champion"}
		else
			return nil
		end
	elseif Menu.CP:Value() == 3 then
		return Data.col or false
	end
end

function Putin:Type(Spell, Data, Menu)
	if not Menu["CP"] then return end
	return Data.type or "circular"
end

function Putin:HitChanceValue(Menu, Spell)
	if not Menu["CP"] then return end
	if Menu.CP:Value() == 1 then
		if Menu.HitChance["H"..SlotToString[Spell]]:Value() == 1 then
			return 0
		elseif Menu.HitChance["H"..SlotToString[Spell]]:Value() == 2 then
			return .35
		elseif Menu.HitChance["H"..SlotToString[Spell]]:Value() == 3 then
			return .7
		end
	elseif Menu.CP:Value() == 2 then
		if Menu.HitChance["H"..SlotToString[Spell]]:Value() == 1 then
			return 1
		elseif Menu.HitChance["H"..SlotToString[Spell]]:Value() == 2 then
			return 2
		elseif Menu.HitChance["H"..SlotToString[Spell]]:Value() == 3 then
			return 3
		end
	elseif Menu.CP:Value() == 3 then
		if Menu.HitChance["H"..SlotToString[Spell]]:Value() == 1 then
			return 0
		elseif Menu.HitChance["H"..SlotToString[Spell]]:Value() == 2 then
			return 1
		elseif Menu.HitChance["H"..SlotToString[Spell]]:Value() == 3 then
			return 1
		end
	end
end
