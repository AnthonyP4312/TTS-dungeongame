function onDropped(player_color)
    --if player_color == "Orange" then
        rpgPos = self.getPosition()
        if math.abs(rpgPos.x) > 44.5 or  math.abs(rpgPos.z) > 26.5 then
            callLuaFunctionInOtherScript(Global, "endItAll")
            callLuaFunctionInOtherScript(Global, "click")
        end
    --end

    function self.RPGFigurine.onHit(attacker)
        print("rip in peace" .. attacker)
    end
end