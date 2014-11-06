--[[
	
	Simple Money system. Made by fghdx.
	https://github.com/fghdx/Gmod-Simple-Logs/
	fghdx.me
	
	View the readme.md file to see how to add new functions.

]]--


if CLIENT then return end --We are only going to be dealing with client side code here.

money = {
	starting_money = 100, --Starting money	
	payday = true, --Enable paydays
	payday_money =  50, --How much money to add in a payday
	payday_time = 300 -- Time between paydays in seconds. 5 minutes(300 seconds.) by default.
} 

player_data = FindMetaTable("Player") --Gets all the functions that affect player.

function init_spawn( ply ) --Load money on player initial spawn.
 	ply:money_load()
end
hook.Add( "PlayerInitialSpawn", "playerInitialSpawn", init_spawn )

function player_data:money_load()
	if self:GetPData( "money" ) == nil then -- See if there is data under "money" for the player
		self:SetPData( "money", money['starting_money'] ) -- If not, add money.
	end
	self:SetNWInt("money", self:GetPData("money")) --Set the network int so the client can grab the info.
end



--YOU DO NOT NEED TO CALL THIS FUNCTION. money_give and money_take DO ALL THE WORK. USE THOSE INSTEAD.
function player_data:money_interact( method, amount ) -- Add or take money
	local money = self:GetPData("money") --Gets the players money.
	
	if method == 1 then	-- Method 1 is give money, method 0 is take money.
		self:SetNWInt("money", money + amount) --Set the network int for the money. This way we can get it on the client.
		self:SetPData("money", money + amount) --Users money gets updated to what the currently have + the amount from interation
	else
		self:SetNWInt("money", money - amount) 
		self:SetPData("money", money - amount) 

	end
end

-- Call with money_give(amount), for example if you wanted to give the player
-- $200 you would say ply:money_give(200)
function player_data:money_give( amount )
	if amount > 0 then --Check if the amount is over 0 to prevent players sending or giving negative amounts.
		self:money_interact(1, amount) --Add money 
	end
end

-- Call with money_take(amount), for example if you wanted to take
-- $200 away from the player you would say ply:money_take(200)
function player_data:money_take( amount )
	if amount > 0 and self:money_enough(amount) then --Check if the amount is over 0 to prevent players sending or giving negative amounts.
		self:money_interact(0, amount)
	end
end


--This is used to check if the player has enough money to do what he is requesting.
function player_data:money_enough( amount ) 		--Check if the player has enough money for an Action
	local money = tonumber(self:GetPData("money")) 	--If they do not the function will return false and if
	if money >= amount then 						--they do it will return true.
		return true;
	else
		return false;
	end
end


--You do not really need this, but it can be used to get the amount of money a player has.
function player_data:money_amount()
	return self:GetPData( "money" );
end

--Payday
if money['payday'] then

	timer.Create( "payday", money['payday_time'], 0, function() --Create a timer that will execute this function every how ever long set in the table.

			for k, v in pairs(player.GetAll()) do --Iterate over every player in the server.
				v:money_give(money['payday_money']) --give them the amount of money specified in the table.
				v:PrintMessage( HUD_PRINTTALK, "Payday! You were paid $" .. money['payday_money'] ) --Print to chat "Paid NAME $X"
			end

	 end )
end


--[[
	This function gives the person you are looking at a specified amount of money.
	To use look at a player and type "/givemoney x" or "!givemoney x", alternatively you
	can use "give_money x" in console. x = amount of money you want to give.
]]
function player_data:give_player_money( amount )
	local target = self:GetEyeTrace().Entity --Get the entity the player is looking at.
	if target:IsPlayer() then --If the entity is a player do this
		if self:money_enough(tonumber(amount)) then	--If the player has enough money, continue.
			target:money_give(tonumber(amount)) --Give money to the player he is looking at.
			self:money_take(tonumber(amount)) --Take money from the player
			self:PrintMessage( HUD_PRINTTALK, "Paid " .. target:Nick() .. " $" .. amount ) --Print to chat "Paid NAME $X"
			target:PrintMessage( HUD_PRINTTALK, self:Nick() .. " paid you $" .. amount ) --This is untested. It should print to the targets chat
																						 --"PLAYER paid you $X"
		else
			self:PrintMessage( HUD_PRINTTALK, "You do not have enough money!" ) --If the player does not have enough money print it to chat.
		end
	else
		self:PrintMessage( HUD_PRINTTALK, "Please aim at a player." ) --If the player is not aiming at player print to chat.
	end
end


--Creating the console command for give_player_money
function give_money( client, command, arguments )
	client:give_player_money(arguments[1])
end
concommand.Add("give_money", give_money)

--CHAT COMMANDS!
function chat_commands(ply, text)

	text = string.lower(text) -- Make the message sent lower case so the command is not case sensitive.
	text = string.Explode(" ", text) --Explode the string into a table on every space.
									 --We do this so we can get the arguments.

	if text[1] == "!givemoney" or text[1] == "/givemoney" then --If the first item in the list == !givemoney or /givemoney then
		ply:give_player_money(tonumber(text[2])) --Execute the give money function
	end
end
hook.Add("PlayerSay", "Chat_Commands", chat_commands) --Hook into PlayerSay so the function is called every time a player makes a chat message.




--[[
	ADD CUSTOM FUNCTIONS DOWN HERE!

	EXAMPLE FUNCTION:
		This will give the player $100 when he kills another player.

		function add_money_on_kill(victim, weapon, killer)
			if killer:IsPlayer() then
				killer:money_give(100)
			end

		end
		hook.Add("PlayerDeath", "add_money_on_kill", add_money_on_kill)





]]

