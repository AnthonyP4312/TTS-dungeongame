function onload()
    params = {}
    params.click_function = "pop"
    params.function_owner = self
    params.label = ""
    params.width = 3000
    params.height = 3000
    params.position = {0,-2,0}
    params.rotation = {0,0,180}
    self.createButton(params)
end

function pop()
    PLAYER = Global.getVar("GPLAYER")
    PLAYERpos = PLAYER.getPosition()
    CHESTpos = self.getPosition()
    xdiff = CHESTpos.x - PLAYERpos.x
    zdiff = CHESTpos.z - PLAYERpos.z

    if (math.abs(xdiff) < 2.5) and (math.abs(zdiff) < 2.5) then
        self.takeObject({position = self.getPosition()})
        self.destruct()
    else
        printToAll("That chest is too far.", {1,0,0})
    end
end