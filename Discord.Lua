LastMessage = ''
Version = "1.9.0"
APIVersion = "2.2.2"
nm = ""
Outdated = false
CurrentVersion = ""
CurrentAPIVersion = ""
Invite = "https://discord.gg/9GUJ8NWbKu" -- if you dont have a discord just make it "nope"
API = "https://frequent-satisfying-indigo.glitch.me" -- put here the link to your DiscordXPolytoria API

function SendNotice(after, user)
    players = game['Players']:GetPlayers()
    playeramount = #players
    if after == "leave" then
        playeramount = playeramount - 1
    end
    Http:Get(API .."/sendNotice?user=".. user.Name .."&after=".. after .."&players=".. playeramount, function (data, error, errmsg)
        if error then
            errormessage = "[DiscordXPolytoria] ".. errmsg .." | Please report it to giglPRP on Polytoria or Alexx_0bro on discord!"
            Chat:UnicastMessage(errormessage, user)
            print(errormessage)
        else
            parsed = json.parse(data)
            if parsed['banned'] == "true" then
                user.Kick('You got permanently banned, with the reason: "'.. parsed['reason'] ..'" Goodbye.')
            end
        end
    end, {})
end

function Send2Discord(message, user)
    Http:Get(API .."/sendmsg?user=".. user.Name .."&message=".. message, function (data, error, errmsg)
        if error then
            errormessage = "[DiscordXPolytoria] ".. errmsg .." | Please report it to giglPRP on Polytoria or Alexx_0bro on discord!"
            Chat:UnicastMessage(errormessage, user)
            print(errormessage)
        else
        end
    end, {})
end

function getMessage()
    Http:Get(API .."/message", function (data, error, errmsg)
        if not error then
            message = json.parse(data)["message"]
            if LastMessage != message then
                Chat:BroadcastMessage(message)
            end
            LastMessage = message
        end
    end,{})
end

function CheckVersion(player)
    Http:Get("https://frequent-satisfying-indigo.glitch.me/version", function (data, error, errmsg) -- DO NOT change the API call
        if not error then
            dataparsed = json.parse(data)
            nm = dataparsed["Credit"]
            CurrentVersion = dataparsed["ScriptVer"]
            CurrentAPIVersion = dataparsed["APIVer"]
            if nm == " " then
                player:Kick("Credits are gone, you're a dissapointment :/")
            end
            if nm != "giglPRP" then
                player:Kick("Credits are gone, you're a dissapointment :/")
            end
            if nm == "" then
                player:Kick("Credits are gone, you're a dissapointment :/")
            end
            if CurrentVersion != Version then
                Outdated = true
            end
            if CurrentAPIVersion != APIVersion then
                Outdated = true
            end

            if Outdated == true then
                if CurrentAPIVersion != APIVersion then
                    Chat:UnicastMessage("Oh uh! API is outdated!", player)
                end
                if CurrentVersion != Version then
                    Chat:UnicastMessage("Oh uh! Script is outdated!", player)
                end
            else
                Chat:UnicastMessage('DiscordXPolytoria v'.. Version ..' By '.. nm, player)
                if Invite != "nope" then
                    Chat:UnicastMessage('Discord: '.. Invite, player)
                end
            end

        end
    end,{})
end

game['Players'].PlayerAdded:Connect(function (player)
    SendNotice("join", player)
    CheckVersion(player)
    player.Chatted:Connect(function (message, event)
        Send2Discord(message, player)
    end)
end)

game["Players"].PlayerRemoved:Connect(function(player)
    SendNotice("leave", player)
end)

while true do
    getMessage()
    wait(0.7)
end
