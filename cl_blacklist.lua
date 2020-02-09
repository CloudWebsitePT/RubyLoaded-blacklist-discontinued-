Citizen.CreateThread(function()
    while not NetworkIsSessionActive() do Wait(100) end
    while true do
        Citizen.Wait(math.random(30,45)*1000)
        TriggerServerEvent("RubyLoaded:VerifId")
    end
end)