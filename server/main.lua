local ESX = exports['es_extended']:getSharedObject()

ESX.RegisterServerCallback('bungee.gasstation:pay', function(source, cb, amount, paymentMethod)
    local xPlayer = ESX.GetPlayerFromId(source)
    local playerMoney = 0

    if paymentMethod == 'cash' then
        playerMoney = xPlayer.getMoney()
    elseif paymentMethod == 'card' then
        playerMoney = xPlayer.getAccount('bank').money
    end

    if playerMoney >= amount then
        if paymentMethod == 'cash' then
            xPlayer.removeMoney(amount)
        elseif paymentMethod == 'card' then
            xPlayer.removeAccountMoney('bank', amount)
        end
        cb(true)
    else
        cb(false)
    end
end)
