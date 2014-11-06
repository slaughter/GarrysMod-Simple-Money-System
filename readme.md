#_**Simple Gmod Money System**_
####By fghdx
---

A simple GMod money system to use in your server. It sets up a base framework for you to build upon. Pretty mutch every line is commented saying what it does and why. Feel free to edit it at will.

##How to use:
To use simply [download the ZIP](https://github.com/fghdx/GarrysMod-Simple-Money-System/archive/master.zip) and extract into `garrysmod/garrysmod/addons` folder.

Reading over the code should give you some insight on how to add functions. But if you want an example I will show you how to add a system that will pay you when you kill someone.

First off you will need to navigate to `moneyserver.lua` as we will be adding a server side function. At the bottom of the file create a new function like so:

```
function add_money_on_kill(victim, weapon, killer)

end
hook.Add("PlayerDeath", "add_money_on_kill", add_money_on_kill)
```

The parameters `(victim, weapon, killer)` are used by the `PlayerDeath` hook that we added with the line `hook.Add("PlayerDeath", "add_money_on_kill", add_money_on_kill)`

Victim is the player who was killer.

Weapon is the weapon that was used.

Killer was the person who killed the player.

We are going to want to add money to the Killer. So to do that we need to first make sure the killer is a person.
```
function add_money_on_kill(victim, weapon, killer)
	if killer:IsPlayer() then
	--Code goes here
	end
end
hook.Add("PlayerDeath", "add_money_on_kill", add_money_on_kill)


```

Now we just have to add the command to add money to the killers account inside the if statement.
```	
function add_money_on_kill(victim, weapon, killer)
	if killer:IsPlayer() then
		killer:money_give(100)
	end

end
hook.Add("PlayerDeath", "add_money_on_kill", add_money_on_kill)
```

Then you're done.




















