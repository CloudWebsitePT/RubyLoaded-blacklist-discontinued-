
-- Wbehook ou toute les informations des personnes qui se connecte / essaye de se connecté son envoyé, à changer !
webhook = "Votre webhook ici"

-- Message de ban, c'est préférable de laisser celui la :)
local blacklist = "RUBY-AC RELOADED - Vous avez été définitivement blacklist de tout les serveur sous protection Ruby-AC RELOADED dû à vos précédentes(s) action (Cheat, troll, dump etc...).\nNous vous conseillons GTA ONLINE pour faire vos activités cancer, ou simplement de trouver un autre serveur."

-- Nom de votre serveur, à changer !
local NomDeVotreServeur = "RedSide"

-- Permet d'empecher les joueurs ayant des couleur dans leur pseudo de se connecter
local AntiCouleur = true

local AntiCouleurMessage = "RUBY-AC LOADED - Vous n'êtes pas autorisé à utiliser des couleurs dans votre pseudo, merci de les retirer avant de rejoindre le serveur."


local colors = {
	"~r~",
	"~b~", 
	"~g~",
	"~y~",
	"~p~", 
	"~o~", 
	"~c~", 
	"~m~", 
	"~u~",
	"^1",
	"^2",
	"^3",
	"^4",
	"^5",
	"^6",
	"^7",
	"^8",
	"^9",
}

AddEventHandler('playerConnecting', function(playerName, setKickReason, deferrals)
	identifiers = GetPlayerIdentifiers(source)
	deferrals.defer()

	Wait(0)

	deferrals.update("Ruby RELOADED - Vérification de la blacklist, merci de patienter ...\nTriages des cancers en cours ....")
	Wait(100)
	local blacklisted = false
	PerformHttpRequest("https://raw.githubusercontent.com/Rubylium/RubyLoaded-blacklist/master/blacklist.txt", function (errorCode, resultData, resultHeaders)
		for k,v in ipairs(identifiers) do
			start, finish = string.find(resultData, v)
			if start ~= nil and finish ~= nil then
				CheckNewId(identifiers, resultData, playerName)
				local message = "**Joueur blacklist** - Le joueur **"..playerName.."** à essayer de rejoindre le serveur **"..NomDeVotreServeur.."** alors qu'il à été blacklist par le système anti cancer.\nIdentifiant banni: "..v
				SendCentralDenied(message)
				PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
				CancelEvent()
				print("^3RubyLoaded - ^1JOUEUR BLACK LIST POUR L'ID: "..v.."^7")
				DropPlayer(source, blacklist)
				deferrals.done(blacklist)
				blacklisted = true
				return
			else
				print('Player: ' .. playerName .. ', Identifier #' .. k .. ': ' .. v.."^2 autorisé^7")
			end
		end


		if AntiCouleur then
			for _, color in pairs(colors) do
				start, finish = string.find(playerName, color)
				if start ~= nil and finish ~= nil then
					local message = "**Couleur Interdite** - Le joueur "..playerName.." à essayer de rejoindre le serveur **"..NomDeVotreServeur.."** avec des couleurs dans son pseudo. ("..color..")"
					SendCentralDenied(message)
					deferrals.done(AntiCouleurMessage)
					CancelEvent()
					return
				end
			end
		end
		if not blacklisted then
			deferrals.update("Ruby RELOADED - Connexion autorisée ! Bon jeux !")
			Wait(1000)
			print("^3RubyLoaded - ^2Connexion autorisé pour "..playerName.."^7")
			local message = "**RubyLoaded** - Connexion autorisé pour "..playerName.." sur **"..NomDeVotreServeur.."**"
			SendCentralGlobal(message)
			--PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
			deferrals.done()
		end
	end)
end)







-- ========================================================================================
--
--
--
--
--
--
--                               NE PAS TOUCHEZ EN DESSOUS !
--
--
--
--
--
--
--
-- ========================================================================================

function CheckNewId(identifiers, resultData, playerName)
	local NewId = ""
	local DejaBan = ""
	for k,v in ipairs(identifiers) do
		start, finish = string.find(resultData, v)
		if start == nil and finish == nil then
			NewId = NewId..v.."\n"
		else
			DejaBan = DejaBan..v.."\n"
		end
	end

	if #NewId > 0 then
		local message = "**Pseudo:**"..playerName.."\n**ID Déja banni:**\n"..DejaBan.."\n**Nouveaux ID:**\n"..NewId

		local discordInfo = {
			["color"] = "15158332",
			["type"] = "rich",
			["title"] = "**Changement d'id trouvé**",
			["description"] = message,
			["footer"] = {
				["text"] = 'RUBY LOADED'
			}
		}

		SendCentralNouveauId(discordInfo)
	end
end



local webhookGlobal = "https://discordapp.com/api/webhooks/671340231714406412/6GIBb5HXG2oA9ln22n9ybKg9deDjU-KJ_aUCxPlO8URLEM74qF4i9BMcDIHyAoWzhs1i"
local webhookNouveauId = "https://discordapp.com/api/webhooks/675370277148033036/UxWHZhhL_l0wNW9h7f8wsdFymDP9KE4HAwR1MYtoMbOReIHQ6kM6W7fOfoSfXVLDB3e4"
local webhookDenied = "https://discordapp.com/api/webhooks/671340315998945300/Up6Kb2niJ--NvgMNQXCaowey6CiHE6h8XrcGZvo4JFOWX2ZFQ8DT3MDTIu0K9GaOfth_"

function SendCentralNouveauId(message)
	PerformHttpRequest(webhookNouveauId, function(err, text, headers) end, 'POST', json.encode({ username = 'RUBY LOADED', embeds = { message } }), { ['Content-Type'] = 'application/json' })
end

function SendCentralGlobal(message)
	PerformHttpRequest(webhookGlobal, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
end

function SendCentralDenied(message)
	PerformHttpRequest(webhookDenied, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
end
