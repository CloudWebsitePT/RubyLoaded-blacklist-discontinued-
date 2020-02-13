
-- Wbehook ou toute les informations des personnes qui se connecte / essaye de se connecté son envoyé, à changer !
webhook = "Votre webhook ici"

-- Message de ban, c'est préférable de laisser celui la :)
local blacklistCheat = "RubyLoaded - Vous avez été définitivement blacklist de tout les serveur sous protection RubyLoaded dû à vos précédentes(s) action.\n\nInformation externe\nRaison: Utilisation de logiciel externe (Lua Injecteur, Mod Menu)\nVotre blacklist est définitive, le staff RubyLoaded **ne peut pas** vous aider.\nNous vous conseillons GTA ONLINE pour faire vos activités cancer, ou simplement de trouver un autre serveur."


local blacklistAchatModMenu = "RubyLoaded - Vous avez été blacklist de tout les serveur sous protection RubyLoaded dû à vos précédentes(s) action.\n\nInformation externe\nRaison: Achats de Mod Menu / Cheat.\nVotre blacklist n'est pas définitive, le staff RubyLoaded **peut ** vous aider ici: https://discord.gg/YZFXv4Y."

local blacklistVenteCheat = "RubyLoaded - Vous avez été définitivement blacklist de tout les serveur sous protection RubyLoaded dû à vos précédentes(s) action.\n\nInformation externe\nRaison: Vente de logiciel de triche (Injecteur LUA, Mod Menu etc...)\nVotre blacklist est définitive, le staff RubyLoaded **ne peut pas** vous aider.\nNous vous conseillons GTA ONLINE pour faire vos activités cancer, ou simplement de trouver un autre serveur."



AddEventHandler('playerConnecting', function(playerName, setKickReason, deferrals)
	identifiers = GetPlayerIdentifiers(source)
	deferrals.defer()
	deferrals.update("Ruby RELOADED - Vérification de la blacklist, merci de patienter ...\nTriages des cancers en cours ....")
	local blacklisted = false
	PerformHttpRequest("https://raw.githubusercontent.com/Rubylium/RubyLoaded-blacklist/master/blacklist.json", function (errorCode, resultData, resultHeaders)
		local blacklist = json.decode(resultData)
		for _,v in ipairs(identifiers) do
			for _, i in pairs(blacklist.cheat) do
				if i == v then
					CheckNewId(identifiers, blacklist, playerName, "Cheat ", v.."\n")
					print("^3RubyLoaded - ^1JOUEUR BLACK LIST POUR L'ID: "..v.."^7")
					deferrals.done(blacklistCheat)
					blacklisted = true
					return
				end
			end

			for _, i in pairs(blacklist.AchatMenu) do
				if i == v then
					CheckNewId(identifiers, blacklist, playerName, "Achat de cheat ", v.."\n")
					print("^3RubyLoaded - ^1JOUEUR BLACK LIST POUR L'ID: "..v.."^7")
					deferrals.done(blacklistAchatModMenu)
					blacklisted = true
					return
				end
			end

			for _, i in pairs(blacklist.VenteCheat) do
				if i == v then
					CheckNewId(identifiers, blacklist, playerName, "Vente de cheat ", v.."\n")
					print("^3RubyLoaded - ^1JOUEUR BLACK LIST POUR L'ID: "..v.."^7")
					deferrals.done(blacklistVenteCheat)
					blacklisted = true
					return
				end
			end
		end

		if not blacklisted then
			deferrals.update("Ruby RELOADED - Connexion autorisée ! Bon jeux !")
			print("^3RubyLoaded - ^2Connexion autorisé pour "..playerName.."^7")
			deferrals.done()
		end
	end)
end)

RegisterNetEvent("RubyLoaded:VerifId")
AddEventHandler("RubyLoaded:VerifId", function()
	local identifiers = GetPlayerIdentifiers(source)
	local _source = source
	PerformHttpRequest("https://raw.githubusercontent.com/Rubylium/RubyLoaded-blacklist/master/blacklist.json", function (errorCode, resultData, resultHeaders)
		local blacklist = json.decode(resultData)
		for _,v in ipairs(identifiers) do
			for _, i in pairs(blacklist.cheat) do
				if i == v then
					CheckNewId(identifiers, blacklist, GetPlayerName(_source), "Cheat ", v.."\n")
					DropPlayer(_source, GetPlayerName(_source))
					return
				end
			end

			for _, i in pairs(blacklist.AchatMenu) do
				if i == v then
					CheckNewId(identifiers, blacklist, GetPlayerName(_source), "Achat de cheat ", v.."\n")
					DropPlayer(_source, GetPlayerName(_source))
					return
				end
			end

			for _, i in pairs(blacklist.VenteCheat) do
				if i == v then
					CheckNewId(identifiers, blacklist, GetPlayerName(_source), "Vente de cheat ", v.."\n")
					DropPlayer(_source, GetPlayerName(_source))
					return
				end
			end
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
function CheckNewId(identifiers, resultData, playerName, type, banned)
	local NewId = ""
	local DejaBan = ""
	local BanType = ""
	local NewIdTable = {}
	local DejaBan = banned
	local BanType = type
	for k,v in pairs(identifiers) do
		for _, i in pairs(resultData.cheat) do
			if i == v then
				DejaBan = DejaBan..v.."\n"
				BanType = BanType.."Cheat "
			else
				local idAdded = false
				for _, id in pairs(NewIdTable) do
					if id == v then
						idAdded = true
					end
				end
				if not idAdded then
					NewId = NewId..v.."\n"
					table.insert(NewIdTable, v)
					break
				end
			end
		end

		for _, i in pairs(resultData.AchatMenu) do
			if i == v then
				DejaBan = DejaBan..v.."\n"
				BanType = BanType.."Achat de menu "
			else
				local idAdded = false
				for _, id in pairs(NewIdTable) do
					if id == v then
						idAdded = true
					end
				end
				if not idAdded then
					NewId = NewId..v.."\n"
					table.insert(NewIdTable, v)
					break
				end
			end
		end

		for _, i in pairs(resultData.VenteCheat) do
			if i == v then
				DejaBan = DejaBan..v.."\n"
				BanType = BanType.."Vente Cheat "
			else
				local idAdded = false
				for _, id in pairs(NewIdTable) do
					if id == v then
						idAdded = true
					end
				end
				if not idAdded then
					NewId = NewId..v.."\n"
					table.insert(NewIdTable, v)
					break
				end
			end
		end
	end

	if #NewId > 0 then
		local message = "**Pseudo:**"..playerName.."\n**Type de ban**: "..BanType.."\n**ID Déja banni:**\n"..DejaBan.."\n**Nouveaux ID:**\n"..NewId
		--print("**Pseudo:**"..playerName.."\n**Type de ban**: "..type.."\n**ID Déja banni:**\n"..DejaBan.."\n**Nouveaux ID:**\n"..NewId)

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

function SendCentralNouveauId(message)
	PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({ username = 'RUBY LOADED', embeds = { message } }), { ['Content-Type'] = 'application/json' })
end
