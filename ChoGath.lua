--[[
╔══╦╗╔╦══╦═══╦══╦════╦╗╔╗  
║╔═╣║║║╔╗║╔══╣╔╗╠═╗╔═╣║║║    
║║─║╚╝║║║║║╔═╣╚╝║─║║─║╚╝║
║║─║╔╗║║║║║╚╗║╔╗║─║║─║╔╗║
║╚═╣║║║╚╝║╚═╝║║║║─║║─║║║║
╚══╩╝╚╩══╩═══╩╝╚╝─╚╝─╚╝╚╝ 
LoL Patch : 6.18+
Script Verison : 0.0.0.1
By Shulepin
_________________________

Credits:
-Deftsu(http://gamingonsteroids.com/user/220-deftsu/)
-Zwei(http://gamingonsteroids.com/user/13058-zwei/)
-Noddy(http://gamingonsteroids.com/user/304-noddy/)
-Icesythe7(http://gamingonsteroids.com/user/5317-icesythe7/)
]]--

if GetObjectName(GetMyHero()) ~= "Chogath" then return end

if not pcall( require, "OpenPredict" ) then PrintChat("This script doesn't work without OpenPredict! Download it!") return end	

local ver = "0.0.0.1"
PrintChat("Cho'Gath version " .. ver .. " Loaded!")

--Menu
ChoMenu = Menu("Cho", "Cho'Gath")
ChoMenu:SubMenu("c", "Combo")
ChoMenu.c:Info("c1", "-[Combo]-")
ChoMenu.c:Boolean("Q", "Use Q", true)
ChoMenu.c:Boolean("W", "Use W", true)

ChoMenu:SubMenu("u", "Ultimate")
ChoMenu.u:Info("u1", "-[Ultimate]-")
ChoMenu.u:Boolean("R", "Use R", true)

ChoMenu:SubMenu("h", "Harass")
ChoMenu.h:Info("h1", "-[Harass]-")
ChoMenu.h:Boolean("Q", "Use Q", true)
ChoMenu.h:Boolean("W", "Use W")
ChoMenu.h:Info("h2", "-[Mana Manager]-")
ChoMenu.h:Slider("mana", "Min. Mana(%) To Harass",60,0,100,1)

ChoMenu:SubMenu("l", "Clear")
ChoMenu.l:Info("l1", "-[Clear]-")
ChoMenu.l:Boolean("Q", "Use Q", true)
ChoMenu.l:Boolean("W", "Use W", true)
ChoMenu.l:Info("l2", "-[Mana Manager]-")
ChoMenu.l:Slider("mana", "Min. Mana(%) To Clear",65,0,100,1)
ChoMenu.l:Info("l3", "-[Misc]-")
ChoMenu.l:Slider("limQ", "Use Q if Minions Around >= X",3,1,10,1)
ChoMenu.l:Slider("limW", "Use W if Minions Around >= X",2,1,10,1)

ChoMenu:SubMenu("k", "Kill Steal")
ChoMenu.k:Info("k1", "-[KS]-")
ChoMenu.k:Boolean("Q", "Use Q", true)
ChoMenu.k:Boolean("W", "Use W", true)

ChoMenu:SubMenu("p", "Prediction")
ChoMenu.p:Info("p1", "-[Hit Chance]-")
ChoMenu.p:Slider("Qh", "HitChance Q", 50, 0, 100, 1)
ChoMenu.p:Slider("Wh", "HitChance W", 50, 0, 100, 1)

ChoMenu:SubMenu("dr", "Draw")
ChoMenu.dr:Info("i1", "-[Damage]-")
ChoMenu.dr:Boolean("DrDmg", "Draw Damage", true)
ChoMenu.dr:Boolean("DrDmgQ", "Draw Q Damage", true)
ChoMenu.dr:Boolean("DrDmgW", "Draw W Damage", true)
ChoMenu.dr:Boolean("DrDmgR", "Draw R Damage", true)
ChoMenu.dr:Info("i3", "-[Killable Text]-")
ChoMenu.dr:Boolean("KillRtext", "Draw text", true)
ChoMenu.dr:Info("i2", "-[Spells Range]-")
ChoMenu.dr:Boolean("DrRanQ", "Draw Q Range", true)
ChoMenu.dr:Boolean("DrRanW", "Draw W Range", true)
ChoMenu.dr:Boolean("DrRanR", "Draw R Range")

ChoMenu:SubMenu("m", "Misc")
ChoMenu.m:SubMenu("s", "Skin Changer")
ChoMenu.m.s:Boolean("sb", "Use Skin Changer")
ChoMenu.m.s:Slider("cs", "Choose Skin", 0, 0, 10, 1)

--Locals
local _skin = 0
local RangeQ = 950
local RangeW = 650
local RangeR = 250
local ChoQ = { delay = 1.200, speed = math.huge , width = 100, range = RangeQ }
local ChoW = { delay = 0.250, speed = math.huge, range = RangeW, angle = 60}

--Start
OnTick(function(myHero)
	if not IsDead(myHero) then
		local target = GetCurrentTarget()
		OnCombo(target)
		OnHarass(target)
		OnClear()
		OnKillSteal()
		CastR()
		skin()
	end
end)

OnDraw(function(myHero)

	local qRdy = Ready(0)
	local wRdy = Ready(1)
	local eRdy = Ready(2)
	local rRdy = Ready(3)

	--Text
	for x,unit in pairs(GetEnemyHeroes()) do 
		if ChoMenu.dr.KillRtext:Value() and rRdy and ValidTarget(unit,1500) and GetCurrentHP(unit) + GetDmgShield(unit) <  CalcDmg(3,unit) then
			DrawText(unit.charName.." R Killable", 20, GetHPBarPos(unit).x, GetHPBarPos(unit).y+150, GoS.Red)
		end
	end

    --Range
	if ChoMenu.dr.DrRanQ:Value() then DrawCircle(myHero, RangeQ, 1, 25, GoS.Green) end
	if ChoMenu.dr.DrRanW:Value() then DrawCircle(myHero, RangeW, 1, 25, GoS.Yellow) end
	if ChoMenu.dr.DrRanR:Value() then DrawCircle(myHero, RangeR, 1, 25, GoS.Red) end

    --Damage
	for q,unit in pairs(GetEnemyHeroes()) do
		if ValidTarget(unit,2000) and ChoMenu.dr.DrDmg:Value() then
			local DmgDraw=0
			if qRdy and ChoMenu.dr.DrDmgQ:Value() then
				DmgDraw = DmgDraw + CalcDamage(myHero, unit, 0 ,CalcDmg(0,unit))
			end	
			if wRdy and ChoMenu.dr.DrDmgW:Value() then
				DmgDraw = DmgDraw + CalcDamage(myHero, unit, 0 ,CalcDmg(1,unit))
			end	
			if rRdy and ChoMenu.dr.DrDmgR:Value() then
				DmgDraw = DmgDraw + CalcDmg(3,unit)
			end	
			if DmgDraw > GetCurrentHP(unit) then
				DmgDraw = GetCurrentHP(unit)
			end
			DrawDmgOverHpBar(unit,GetCurrentHP(unit),0,DmgDraw,ARGB(255,255,255,0))
		end
	end	
end)

function OnCombo(target)
	local qRdy = Ready(0)
	local wRdy = Ready(1)
	local eRdy = Ready(2)
	local rRdy = Ready(3)

	if IOW:Mode() == "Combo" then
		--Q
		if ChoMenu.c.Q:Value() and qRdy and ValidTarget(target, RangeQ) then
			local QPred = GetCircularAOEPrediction(target, ChoQ)
			if QPred and QPred.hitChance >= (ChoMenu.p.Qh:Value()/100) then
				CastSkillShot(0, QPred.castPos)
			end
		end
		--W
		if ChoMenu.c.W:Value() and wRdy and ValidTarget(target, RangeW) then
			local WPred = GetConicAOEPrediction(target, ChoW)
			if WPred and WPred.hitChance >= (ChoMenu.p.Wh:Value()/100) then
				CastSkillShot(1, WPred.castPos)
			end
		end
	end
end

function OnHarass(target)
	local qRdy = Ready(0)
	local wRdy = Ready(1)
	local GetPercentMana = (GetCurrentMana(myHero) / GetMaxMana(myHero)) * 100

	if IOW:Mode() == "Harass" then
		--Q
		if ChoMenu.h.Q:Value() and qRdy and ValidTarget(target, RangeQ) then
			local QPred = GetCircularAOEPrediction(target, ChoQ)
			if QPred and QPred.hitChance >= (ChoMenu.p.Qh:Value()/100) then
				if ChoMenu.h.mana:Value() <= GetPercentMana then
					CastSkillShot(0, QPred.castPos)
				end
			end
		end
		--W
		if ChoMenu.h.W:Value() and wRdy and ValidTarget(target, RangeW) then
			local WPred = GetConicAOEPrediction(target, ChoW)
			if WPred and WPred.hitChance >= (ChoMenu.p.Wh:Value()/100) then
				if ChoMenu.h.mana:Value() <= GetPercentMana then
					CastSkillShot(1, WPred.castPos)
				end
			end
		end
	end
end

function OnClear(target)
	local qRdy = Ready(0)
	local wRdy = Ready(1)
	local GetPercentMana = (GetCurrentMana(myHero) / GetMaxMana(myHero)) * 100

	if IOW:Mode() == "LaneClear" then
		for x, minion in pairs(minionManager.objects) do
			if GetTeam(minion) ~= MINION_ALLY then
		    --Q
			local QPred = GetCircularAOEPrediction(minion, ChoQ)
			if ChoMenu.l.Q:Value() and qRdy and ValidTarget(minion, RangeQ) and MinionsAround(minion, 950) >= ChoMenu.l.limQ:Value() then
				if ChoMenu.l.mana:Value() <= GetPercentMana then
					CastSkillShot(0, QPred.castPos)
				end
			end
			--W
			local WPred = GetConicAOEPrediction(minion, ChoW)
			if ChoMenu.l.W:Value() and wRdy and ValidTarget(minion, RangeW) and MinionsAround(minion, 650) >= ChoMenu.l.limW:Value() then
				if ChoMenu.l.mana:Value() <= GetPercentMana then
					CastSkillShot(1, WPred.castPos)
				end
			end
			end
		end
	end
end

function OnKillSteal()
	local qRdy = Ready(0)
	local wRdy = Ready(1)

	for t,unit in pairs(GetEnemyHeroes()) do
		--Q
		if ChoMenu.k.Q:Value() and qRdy and ValidTarget(unit,RangeQ) and GetCurrentHP(unit) + GetDmgShield(unit) <  CalcDamage(myHero, unit, 0 ,CalcDmg(0,unit)) then
			local QPred = GetCircularAOEPrediction(unit, ChoQ)
			if QPred and QPred.hitChance >= (ChoMenu.p.Qh:Value()/100) then
				CastSkillShot(0, QPred.castPos)
			end
		end
		--W
		if ChoMenu.k.W:Value() and wRdy and ValidTarget(unit,RangeW) and GetCurrentHP(unit) + GetDmgShield(unit) <  CalcDamage(myHero, unit, 0 ,CalcDmg(1,unit)) then
			local WPred = GetConicAOEPrediction(unit, ChoW)
			if WPred and WPred.hitChance >= (ChoMenu.p.Wh:Value()/100) then
				CastSkillShot(1, WPred.castPos)
			end
		end
	end
end

function CastR()
	local rRdy = Ready(3)
	for t,unit in pairs(GetEnemyHeroes()) do
		if ChoMenu.u.R:Value() and rRdy and ValidTarget(unit,RangeR) and GetCurrentHP(unit) + GetDmgShield(unit) <  CalcDmg(3,unit) then
			CastTargetSpell(unit,3)
		end
	end
end

function CalcDmg(spell, target)
	local dmg={
	[0] = 25 + 55*GetCastLevel(myHero,0) + GetBonusAP(myHero),
	[1] = 25 + 50*GetCastLevel(myHero,1) + GetBonusAP(myHero)*0.7,
	[3] = 125 + 175*GetCastLevel(myHero,3) + GetBonusAP(myHero)*0.7
}
return dmg[spell]
end

function skin()
	if ChoMenu.m.s.sb:Value() and ChoMenu.m.s.cs:Value() ~= _skin then
		HeroSkinChanger(GetMyHero(),ChoMenu.m.s.cs:Value()) 
		cSkin = ChoMenu.m.s.cs:Value()
	end
end
