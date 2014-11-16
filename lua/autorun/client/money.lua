--[[
	
	Simple Money system. Made by fghdx.
	https://github.com/fghdx/Gmod-Simple-Logs/
	fghdx.me

	You can delete this file and use the same method to draw the money on
	your hud. Just use:
	LocalPlayer():GetNWInt( "money" )



]]--
--if SERVER then return end --We only want to execute client code here.

surface.CreateFont("font", { font="Myriad Pro", size=38}) --Create our font.

function money_hud() --Make our HudPaint function to draw the money.

	local money = LocalPlayer():GetNWInt( "money" ) --Get players money from the network int.
	draw.WordBox(4, 10, 10, "$".. money, "font", Color(0, 0, 0, 180), Color(255,255,255)) --Make a wordbox containing the wordbox.
end
hook.Add("HUDPaint", "draw money on hud", money_hud)
