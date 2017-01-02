class "_Prediction"

function _Prediction:__init(Menu)
	self.GPP_D, self.GMP_D, self.OP_D, self.CLP_D = false, false, false, false
	self.GPP_P, self.GMP_P, self.OP_P, self.CLP_P = false, false, false, false
	self:DownloadLib()
	self:PredictionMenu(Menu)
	_____SlotToString = { [_Q] = "Q", [_W] = "W", [_E] = "E", [_R] = "R"}
end

function _Prediction:MSG(TEXT)
	PrintChat("<b><font color=\"#F5D76E\">></font></b> <font color=\"#FEFEE2\"> " .. TEXT .. "</font>");
end

function _Prediction:PredictionMenu(Menu)
	Menu:DropDown("ChoosePrediction", "Choose Prediction:", 1, {"Open Prediction", "GPrediction", "GamSteRon Prediction -WIP", "Cloud Prediction", "GoS Prediction", "IPrediction -WIP"}, function() self:PredictionCB(Menu) end)
	self:CurrentPrediction(Menu)
	self:Require(Menu)
end

function _Prediction:HitChanceMenu(Menu, Spell)
	Menu:DropDown("H".._____SlotToString[Spell], "HitChance ".."[".._____SlotToString[Spell].."]", 2, {"Low", "Medium", "High"})
end

function _Prediction:DownloadLib()
	self:DownloadOPred()
	self:DownloadGPred()
	self:DownloadGMPred()
	self:DownloadCLPred()
	self:Status()
end

function _Prediction:DownloadOPred()
	if not FileExist(COMMON_PATH.."\\OpenPredict.lua") then
		self.OP_D = false
	    self:MSG("[OpenPrediction] Downloading required lib, please wait...")
	    DownloadFileAsync("https://raw.githubusercontent.com/Jo7j/GoS/master/OpenPredict/OpenPredict.lua", COMMON_PATH .. "OpenPredict.lua", function() self:MSG("[OpenPrediction] Download Completed") self.GPP_P = true return end)
	    return
    else
    	self.OP_D = true
    	self.OP_P = true
    end
end

function _Prediction:DownloadGPred()
	if not FileExist(COMMON_PATH.."\\GPrediction.lua") then
		self.GPP_D = false
	    self:MSG("[GPrediction] Downloading required lib, please wait...")
	    DownloadFileAsync("https://raw.githubusercontent.com/KeVuong/GoS/master/Common/GPrediction.lua", COMMON_PATH .. "GPrediction.lua", function() self:MSG("[GPrediction] Download Completed") self.GPP_P = true return end)
	    return
    else
    	self.GPP_D = true
    	self.GPP_P = true
    end
end

function _Prediction:DownloadGMPred()
	if not FileExist(COMMON_PATH.."\\gsopath.lua") then
		self.GMP_D = false
	    self:MSG("[Gamsteron Prediction] Downloading required lib, please wait...")
	    DownloadFileAsync("https://raw.githubusercontent.com/gamsteron/GameOnSteroids/master/Common/gsopath.lua", COMMON_PATH .. "gsopath.lua", function() self:MSG("[Gamsteron Prediction] Download Completed") self.GMP_P = true return end)
	    return
    else
    	self.GMP_D = true
    	self.GMP_P = true
    end
end

function _Prediction:DownloadCLPred()
	if not FileExist(COMMON_PATH.."\\CloudPred.lua") then
		self.CLP_D = false
	    self:MSG("[Cloud Prediction] Downloading required lib, please wait...")
	    DownloadFileAsync("https://raw.githubusercontent.com/Cloudhax23/GoS/master/Common/CloudPred.lua", COMMON_PATH .. "CloudPred.lua", function() self:MSG("[Cloud Prediction] Download Completed") self.CLP_P = true return end)
	    return
    else
    	self.CLP_D = true
    	self.CLP_P = true
    end
end

function _Prediction:Status()
	if self.GPP_P and self.GMP_P and self.OP_P and self.CLP_P then
		self:MSG("All Libs Updated!")
	end
end

function _Prediction:Require(Menu)
	if Menu.ChoosePrediction:Value() == 1 then
		if self.OP_D then require("OpenPredict") end
	elseif Menu.ChoosePrediction:Value() == 2 then
		if self.GPP_D then require("GPrediction") end
	elseif Menu.ChoosePrediction:Value() == 3 then
		if self.GMP_D then require("gsopath") end
	elseif Menu.ChoosePrediction:Value() == 4 then
		if self.CLP_D then require("CloudPred") end
	elseif Menu.ChoosePrediction:Value() == 6 then
		require("IPrediction")
	end
end

function _Prediction:CurrentPrediction(Menu)
	if Menu.ChoosePrediction:Value() == 1 then
		if self.OP_D then Menu:Info("OP", "Current Prediction: OpenPredict") end
	elseif Menu.ChoosePrediction:Value() == 2 then
		if self.GPP_D then Menu:Info("GPP", "Current Prediction: GPrediction") end
	elseif Menu.ChoosePrediction:Value() == 3 then
		if self.GMP_D then Menu:Info("GMP", "Current Prediction: GamSteRon Pred") end
	elseif Menu.ChoosePrediction:Value() == 4 then
		if self.CLP_D then Menu:Info("CLP", "Current Prediction: Cloud Pred") end
	elseif Menu.ChoosePrediction:Value() == 5 then
		if self.CLP_D then Menu:Info("CLP", "Current Prediction: GoS Pred") end
	elseif Menu.ChoosePrediction:Value() == 6 then
		Menu:Info("CLP", "Current Prediction: IPred")
	end
end

function _Prediction:PredictionCB(Menu)
	if Menu.ChoosePrediction:Value() == 1 then
		self:MSG("OpenPrediction Selected! x2 F6")
	elseif Menu.ChoosePrediction:Value() == 2 then
		self:MSG("GPrediction Selected! x2 F6")
	elseif Menu.ChoosePrediction:Value() == 3 then
		self:MSG("GamSterOn Prediction Selected! x2 F6")
	elseif Menu.ChoosePrediction:Value() == 4 then
		self:MSG("Cloud Prediction Selected! x2 F6")
	elseif Menu.ChoosePrediction:Value() == 5 then
		self:MSG("GoS Prediction Selected! x2 F6")
	elseif Menu.ChoosePrediction:Value() == 6 then
		self:MSG("IPrediction Selected! x2 F6")
	end
end

function _Prediction:Collision(Spell, Menu, Data)
	if Menu.ChoosePrediction:Value() == 1 then
		return Data.col or false
	elseif Menu.ChoosePrediction:Value() == 2 then
		if Data.col then
			return {"minion", "champion"}
		else
			return nil
		end
	elseif Menu.ChoosePrediction:Value() == 3 then
		return Data.col or false
	elseif Menu.ChoosePrediction:Value() == 4 then
		return Data.collision or false
	elseif Menu.ChoosePrediction:Value() == 5 then
		return Data.col or false
	end
end

function _Prediction:HitChanceValue(Menu, Spell)
	if Menu.ChoosePrediction:Value() == 1 then
		if Menu.HitChance["H".._____SlotToString[Spell]]:Value() == 1 then
			return 0
		elseif Menu.HitChance["H".._____SlotToString[Spell]]:Value() == 2 then
			return .35
		elseif Menu.HitChance["H".._____SlotToString[Spell]]:Value() == 3 then
			return .7
		end
	elseif Menu.ChoosePrediction:Value() == 2 then
		if Menu.HitChance["H".._____SlotToString[Spell]]:Value() == 1 then
			return 1
		elseif Menu.HitChance["H".._____SlotToString[Spell]]:Value() == 2 then
			return 2
		elseif Menu.HitChance["H".._____SlotToString[Spell]]:Value() == 3 then
			return 3
		end
	elseif Menu.ChoosePrediction:Value() == 3 then
		if Menu.HitChance["H".._____SlotToString[Spell]]:Value() == 1 then
			return 0
		elseif Menu.HitChance["H".._____SlotToString[Spell]]:Value() == 2 then
			return 0
		elseif Menu.HitChance["H".._____SlotToString[Spell]]:Value() == 3 then
			return 0
		end
	elseif Menu.ChoosePrediction:Value() == 4 then
		if Menu.HitChance["H".._____SlotToString[Spell]]:Value() == 1 then
			return "Low"
		elseif Menu.HitChance["H".._____SlotToString[Spell]]:Value() == 2 then
			return "Medium"
		elseif Menu.HitChance["H".._____SlotToString[Spell]]:Value() == 3 then
			return "High"
		end
	elseif Menu.ChoosePrediction:Value() == 5 then
		if Menu.HitChance["H".._____SlotToString[Spell]]:Value() == 1 then
			return 0
		elseif Menu.HitChance["H".._____SlotToString[Spell]]:Value() == 2 then
			return 1
		elseif Menu.HitChance["H".._____SlotToString[Spell]]:Value() == 3 then
			return 1
		end
	end
end

function _Prediction:SpellType(Spell, Menu, Data)
    if Menu.ChoosePrediction:Value() == 3 then
		if Data.type == "line" then
			return "linear"
		else
			return "circular"
		end
	else
		return Data.type or "circular"
	end
end

function _Prediction:_CastSkillShot(From, To, Data, Spell, Menu)
	Data.range = Data.range or math.huge
	Data.speed = Data.speed or math.huge
	Data.width = Data.width or Data.radius
	Data.radius = Data.radius or Data.width/2
	Data.delay = Data.delay or .25
	Data.col = self:Collision(Spell, Menu, Data)
	Data.collision = self:Collision(Spell, Menu, Data)
	Data.type = self:SpellType(Spell, Menu, Data)
	Data.count = Data.count or 1
	Data.aoe = Data.aoe or false
	Data.angle = Data.angle or 45

	if Menu.ChoosePrediction:Value() == 1 then
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
	elseif Menu.ChoosePrediction:Value() == 2 then
    	local Prediction = _G.gPred:GetPrediction(To, From, Data, Data.aoe, Data.col)
		if Prediction and Prediction.HitChance >= self:HitChanceValue(Menu, Spell) then
			CastSkillShot(Spell, Prediction.CastPosition)
		end
	elseif Menu.ChoosePrediction:Value() == 3 then
		--WIP
	elseif Menu.ChoosePrediction:Value() == 4 then
		local Prediction, HitChance = GLP(To, Data)
		if Prediction and HitChance and HitChance == self:HitChanceValue(Menu, Spell) then
			CastSkillShot(Spell, Prediction)
		end
	elseif Menu.ChoosePrediction:Value() == 5 then
		local Prediction = GetPredictionForPlayer(From, To, GetMoveSpeed(To), Data.speed, Data.delay, Data.range, Data.width, Data.col, true)
		if Prediction and Prediction.HitChance == self:HitChanceValue(Menu, Spell) then
			CastSkillShot(Spell, Prediction.PredPos)
		end
	elseif Menu.ChoosePrediction:Value() == 6 then
		--WIP
	end
end
