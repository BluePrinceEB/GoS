class "MinionManager"

function MinionManager:__init()
	Minions = { All = {}, Enemy = {}, Ally = {}, Jungle = {} }

	Callback.Add("CreateObj", function(Obj) self:CreateObj(Obj) end)
	Callback.Add("ObjectLoad", function(Obj) self:CreateObj(Obj) end)
	Callback.Add("DeleteObj", function(Obj) self:DeleteObj(Obj) end)
end

function MinionManager:CreateObj(Obj)
	if Obj.isMinion and not Obj.charName:find("Plant") and not Obj.dead then
		if Obj.charName:lower():find("minion") or Obj.team == MINION_JUNGLE then
			table.insert(Minions.All, Obj)
			if Obj.team == MINION_ALLY then
				table.insert(Minions.Ally, Obj)
			elseif Obj.team == MINION_ENEMY then
				table.insert(Minions.Enemy, Obj)
			elseif Obj.team == MINION_JUNGLE then
				table.insert(Minions.Jungle, Obj)
			end
		end
	end	
end

function MinionManager:DeleteObj(Obj)
	if Obj.isMinion then
		for _, v in pairs(Minions.All) do
			if v == Obj then
				table.remove(Minions.All, _)
			end
		end
		
		if Obj.team == MINION_ENEMY then
			for _, v in pairs(Minions.Enemy) do
				if v == Obj then
					table.remove(Minions.Enemy, _)
				end
			end
		elseif Obj.team == MINION_JUNGLE then
			for _, v in pairs(Minions.Jungle, _) do
				if v == Obj then
					table.remove(Minions.Jungle, _)
				end
			end
		elseif Obj.team == MINION_ALLY then
			for _, v in pairs(Minions.Ally) do
				if v == Obj then
					table.remove(Minions.Ally, _)
				end
			end
		end		
	end	
end

MinionManager()
