function onload()
    params = {}
    params.click_function = "endTurn"
    params.function_owner = self
    params.label = "go"
    params.width = 600
    params.height = 600
    params.rotation = {0,0,180}
    self.createButton(params)
end

function endTurn()
    startLuaCoroutine(Global, "mobAI")
end