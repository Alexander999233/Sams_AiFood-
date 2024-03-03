local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateCallback('sulsul:pedOnline', function(source, cb)
	local src = source
	local Ply = QBCore.Functions.GetPlayer(src)
	local xPlayers = QBCore.Functions.GetPlayers()
	local pedagang = 0
	local canpay = false
	if Ply.PlayerData.money["cash"] >= Config.Price then
		canpay = true
	else
		if Ply.PlayerData.money["bank"] >= Config.Price then
			canpay = true
		end
	end

	for i=1, #xPlayers, 1 do
		local xPlayer = QBCore.Functions.GetPlayer(xPlayers[i])
		if xPlayer.PlayerData.job.name == 'pedagang' and xPlayer.PlayerData.job.onduty then
			pedagang = pedagang + 1
			OnDuty = true
		end
	end

	cb(pedagang, canpay)
end)

RegisterServerEvent('sulsul:payment')
AddEventHandler('sulsul:payment', function()
	local src = source
	local xPlayer = QBCore.Functions.GetPlayer(src)
	if xPlayer.PlayerData.money["cash"] >= Config.Price then
		xPlayer.Functions.RemoveMoney("cash", Config.Price)
	else
		xPlayer.Functions.RemoveMoney("bank", Config.Price)
	end
	TriggerEvent("qb-bossmenu:server:addAccountMoney", 'pedagang', Config.Price)
end)

RegisterServerEvent('sulsul:item')
AddEventHandler('sulsul:item', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    Player.Functions.AddItem('burger', 1)
	Player.Functions.AddItem('cola', 1)
end)
