ESX = nil
craft_percent = -1
local item_data = {}
local wp_data = {}
item_craftlabel = nil
local item = {}
local openmenu = false
local Ploaded = false
local isDead = false
Config = {}
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(d) ESX = d end)
        Citizen.Wait(0)
    end
    while ESX.GetPlayerData().job == nil do 
		Citizen.Wait(100) 
	end
	TriggerServerEvent('crafting:getitemsv')
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function (xPlayer)
    ESX.PlayerData = xPlayer
	Citizen.Wait(5000)
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
	Citizen.Wait(5000) 
end)

RegisterNetEvent('esx:setGang')
AddEventHandler('esx:setGang', function(gang)
	ESX.PlayerData.gang = gang
end)

AddEventHandler('esx:onPlayerDeath', function()
    isDead = true
	if Ploaded then
		CloseUICraft()
	end
end)

AddEventHandler('esx:onPlayerSpawn', function()
    isDead = false
end)

RegisterNetEvent('crafting:getitem')
AddEventHandler('crafting:getitem', function(data)
	item_data = ESX.PlayerData.allitem
	Config = data.cf
	local wp = {}
	for k, v in pairs(data.wp) do
		wp[v.name] = v
	end
	wp_data = wp
	Ploaded = true
	Loadconfig()
end)

function Loadconfig()
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(1)
			local coords = GetEntityCoords(GetPlayerPed(-1))
			if not isDead then
				for k, v in pairs(Config.CraftTable) do
					if v.coords ~= nil then
						if v.entity == nil then
							v.entity = true
							if v.map_blip then
								v.blip = AddBlipForCoord(v.coords.x, v.coords.y, v.coords.z)
								SetBlipSprite(v.blip, 643)
								SetBlipDisplay(v.blip, 2)
								SetBlipScale(v.blip, v.blip_scale or 0.5)
								SetBlipColour(v.blip, v.blip_coler or 35)
								SetBlipAsShortRange(v.blip, true)
								BeginTextCommandSetBlipName("STRING")
								AddTextComponentString(v.blip_name or "Crafting Table")
								EndTextCommandSetBlipName(v.blip)
							end
							Citizen.CreateThread(function()
								local bench = GetHashKey("gr_prop_gr_bench_01b")
								RequestModel(v.model or bench)
								while not HasModelLoaded(v.model or bench) do
									Citizen.Wait(1)
								end
								if v.disable_model then
									return
								end
								local entity = CreateObject(v.model or bench, v.coords.x, v.coords.y, v.coords.z, false, false, true)
								SetEntityHeading(entity, v.coords.h or 0)
								FreezeEntityPosition(entity, true)
								SetEntityInvincible(entity, true)
								SetModelAsNoLongerNeeded(v.model or bench)
								Config.CraftTable[k].entity = entity
							end)
						end
					end
					local pos = GetEntityCoords(PlayerPedId())
					local distance = GetDistanceBetweenCoords(v.coords["x"], v.coords["y"], v.coords["z"], pos.x, pos.y, pos.z, true)
					if v.entity and craft_percent ~= -1 and distance <= 2.0 then
						draw.Simple3DText(v.coords["x"], v.coords["y"], v.coords["z"] + 1.4, "CRAFTING", 1.0)
						draw.Simple3DText(v.coords["x"], v.coords["y"], v.coords["z"] + 1.3, craft_percent.."%", 0.7)
					end
					if distance <= (v.max_distance or 2.0) and craft_percent == -1 and not openmenu and Ploaded then
						Draw3DText(v.coords["x"], v.coords["y"], v.coords["z"] -1.0, v.name_model,  1.5)
						if IsControlJustPressed(0, 38) then
							if v.police_required then
									if exports["dri_scoreboard"]:getJob("police") < v.police_required then
										exports.pNotify:SendNotification({text = "ตำรวจไม่พอ", type = "error", queue = "crafting"})
									else
										if (v.job[ESX.PlayerData.job.name]) then
											if (v.allgang) or (not v.allgang and v.gang[ESX.PlayerData.gang.name]) then 
												SetNuiFocus(true, true)
												local catagory = {}
												for index, value in pairs(v.catagory) do
													table.insert(catagory, Config.CraftCatagory[value])
												end
												SendNUIMessage({
													loaditem = true,
													-- pid = GetPlayerServerId(PlayerId()),
													showmenu = true,		
													itemdata = item_data,
													wpdata = wp_data,
													catagory = catagory,
												})
												FreezeEntityPosition(PlayerPedId(), true)
												openmenu = true
											else
												exports.pNotify:SendNotification({text = "ใช้ได้เฉพาะแก๊งที่กำหนด", type = "error", queue = "crafting"})
											end
										else
											exports.pNotify:SendNotification({text = "ต้องออกเวรหรือลาพักร้อนก่อน", type = "error", queue = "crafting"})
										end
									end
							elseif v.police_required == nil then
								if (v.job[ESX.PlayerData.job.name]) then
									if (v.allgang) or (not v.allgang and v.gang[ESX.PlayerData.gang.name]) then 
										SetNuiFocus(true, true)
										local catagory = {}
										for index, value in pairs(v.catagory) do
											table.insert(catagory, Config.CraftCatagory[value])
										end
										SendNUIMessage({
											loaditem = true,
											-- pid = GetPlayerServerId(PlayerId()),
											showmenu = true,		
											itemdata = item_data,
											wpdata = wp_data,
											catagory = catagory,
										})
										FreezeEntityPosition(PlayerPedId(), true)
										openmenu = true
									else
										exports.pNotify:SendNotification({text = "ใช้ได้เฉพาะแก๊งที่กำหนด", type = "error", queue = "crafting"})
									end
								else
									exports.pNotify:SendNotification({text = "ต้องออกเวรหรือลาพักร้อนก่อน", type = "error", queue = "crafting"})
								end
							end
						end
						
					end 
				end
			end
		end
	end)
	
	RegisterNUICallback("ButtonClick", function(data, j)
		for k, v in pairs(Config.CraftCatagory) do
			if (data.catagory == v.NAME) then
				for k, v in pairs(v.ITEM_LIST) do
					if (v.item_index == data.item_index) then
						Craft(v, data)
					end
				end
			end
		end
	end)

	function table.Count(tbl)
		local count = 0
		for k,v in pairs(tbl) do
			count = count + 1
		end
		return count
	end

	function CloseUICraft()
		SetNuiFocus(false, false)
		SendNUIMessage({hidemenu = true})
		FreezeEntityPosition(PlayerPedId(), false)
		openmenu = false
	end

	function Craft(data, values)
		amount = values.item_amount or 1
		if isDead then
			return
		end
		ESX.PlayerData = ESX.GetPlayerData()
		local inv = ESX.PlayerData.inventory
		local accounts = ESX.PlayerData.accounts
		local money = 0
		local blackmoney = 0
		for key, value in pairs(accounts) do
			if accounts[key].name == "money" then
				money = accounts[key].money
			elseif accounts[key].name == "black_money" then
				blackmoney = accounts[key].money
			end
		end
		if tonumber(amount) < 1 then
			exports.pNotify:SendNotification(
			{
				text = "จำนวนไม่ถูกต้อง",
				type = "error",
				queue = "crafting"
			})
			return
		end
		if data.min_amount then
			if data.min_amount > tonumber(amount) or data.max_amount < tonumber(amount) then
				exports.pNotify:SendNotification(
				{
					text = "จำนวนไม่ถูกต้อง",
					type = "error",
					queue = "crafting"
				})
				return
			end
		end
		local cost = data.cost * amount
		if data.cost_type == 'cash' then
			if money < cost then
				exports.pNotify:SendNotification(
				{
					text = "เงินสดไม่พอ",
					type = "error",
					queue = "crafting"
				})
				return
			end
		else
			if blackmoney < cost then
				exports.pNotify:SendNotification(
				{
					text = "เงินผิดกฏหมายไม่พอ",
					type = "error",
					queue = "crafting"
				})
				return
			end
		end
		if data.equipment then
			for k, v in pairs(data.equipment) do
				local found, amount = ESX.HasItem(k)
				if not found then 
					exports.pNotify:SendNotification(
					{
						text = "ส่วนประกอบไม่เพียงพอ",
						type = "error",
						queue = "crafting"
					})
					return 
				end
			end
		end
		if data.blessed and values.blessed then
			local found, amount = ESX.HasItem(data.item_blessed)
			if not found then 
				exports.pNotify:SendNotification(
				{
					text = "ของเพิ่มโอกาสติดไม่เพียงพอ",
					type = "error",
					queue = "crafting"
				})
				return 
			end
		end
		if data.protection and values.protection then
			local found, amount = ESX.HasItem(data.item_protec)
			if not found then 
				exports.pNotify:SendNotification(
				{
					text = "ของกันแตกไม่เพียงพอ",
					type = "error",
					queue = "crafting"
				})
				return 
			end
		end
		local tab = GetNearestTable()
		if tab == nil then
			exports.pNotify:SendNotification(
			{
				text = "คุณไม่ได้อยู่ที่โต๊ะคราฟ",
				type = "error",
				queue = "crafting"
			})
			return
		end
		TriggerServerEvent('crafting:startcraft', data.item_index, amount, values.catagory, GetGameTimer(), values.blessed, values.protection)
	end
	
	function GetNearestTable()
		local pos = GetEntityCoords(PlayerPedId())
		for k,v in ipairs(Config.CraftTable) do
			if v.coords ~= nil then
				local dist = GetDistanceBetweenCoords(v.coords["x"], v.coords["y"], v.coords["z"], pos.x, pos.y, pos.z, true)
				if dist <= (v.max_distance or 2.0) then
					return v
				end
			end
		end
	end
	
	draw = draw or {}
	function draw.Simple3DText(x, y, z, text, sc)
		local onScreen, _x, _y = World3dToScreen2d(x, y, z)
		local p = GetGameplayCamCoords()
		local distance = GetDistanceBetweenCoords(p.x, p.y, p.z, x, y, z, 1)
		local scale = (1 / distance) * 2
		local fov = (1 / GetGameplayCamFov()) * 100
		scale = scale * fov
		if sc then scale = scale * sc end
		if onScreen then
			SetTextScale(0.0 * scale, 0.35 * scale)
			SetTextFont(0)
			SetTextProportional(1)
			SetTextColour(255, 255, 255, 255)
			SetTextDropshadow(0, 0, 0, 0, 255)
			SetTextEdge(2, 0, 0, 0, 150)
			SetTextDropShadow()
			SetTextOutline()
			SetTextEntry("STRING")
			SetTextCentre(1)
			AddTextComponentString(text)
			DrawText(_x,_y)
		end
	end
	
	local fontID = nil
	Citizen.CreateThread(function()
		while fontID == nil do
			Citizen.Wait(5000)
			fontID = exports['base_font']:GetFontId('srbn')
		end
	end)
	
	function Draw3DText(x,y,z,textInput,sc)
		local px,py,pz=table.unpack(GetGameplayCamCoords())
		local distance = GetDistanceBetweenCoords(px,py,pz, x, y, z, 1)
		local scale = (1 / distance) * 2
		local fov = (1 / GetGameplayCamFov()) * 100
		scale = scale * fov
		if sc then scale = scale * sc end
		SetTextScale(0.0 * scale, 0.35 * scale)
		SetTextFont(fontID)   ------แบบอักษร 1-7
		SetTextProportional(1)
		SetTextColour(255, 255, 0, 0.2)		-- You can change the text color here
		SetTextDropshadow(1, 1, 1, 1, 255)
		SetTextEdge(2, 0, 0, 0, 150)
		SetTextDropShadow()
		SetTextOutline()
		SetTextEntry("STRING")
		SetTextCentre(1)
		AddTextComponentString(textInput)
		SetDrawOrigin(x,y,z+2, 0)
		DrawText(0.0, 0.0)
		ClearDrawOrigin()
	end
	
	function PlayAnim(anim, param, duration, flag)
		Citizen.CreateThread(function()
		   RequestAnimDict(anim)
		   local time = GetGameTimer() + 1000
		   while not (HasAnimDictLoaded(anim) and time > GetGameTimer()) do
			   Citizen.Wait(0)
		   end
		   ClearPedTasks(PlayerPedId())
		   TaskPlayAnim(PlayerPedId(), anim, param or "Loop", 8.0, 8.0, duration, flag or 63, 0, 0, 0, 0)
		end)
	end
	
	function math.Round( num, idp )
		local mult = 10 ^ ( idp or 0 )
		return math.floor( num * mult + 0.5 ) / mult
	end
	
	RegisterNUICallback("exit", function(data, j)
		CloseUICraft()
	end)
	
	AddEventHandler('onResourceStop', function(resource)
		if resource == GetCurrentResourceName() then
			FreezeEntityPosition(GetPlayerPed(-1), false)
			ClearPedTasks(GetPlayerPed(-1))
			SetNuiFocus(false, false)
			for k, v in pairs(Config.CraftTable) do
				v.entity = nil
				v.entity = false
			end
			openmenu = false
			SendNUIMessage({hidemenu = true})
		end
	end)
end