if SERVER then return end
surface.CreateFont("font", { font="Myriad Pro", size=38})
function money_hud()

	local money = LocalPlayer():GetNWInt( "money" )
	draw.WordBox(4, 10, 10, "$".. money, "font", Color(0, 0, 0, 180), Color(255,255,255))
end
hook.Add("HUDPaint", "draw money on hud", money_hud)
