local SceneManager = {}
SceneManager.scenes = {}
SceneManager.currentScene = nil


function SceneManager:addState(name, state)
    self.scenes[name] = state
end

function SceneManager:switchTo(name, lastState)
    if self.currentScene and self.currentScene.exit then
        self.currentScene:exit()
    end

    self.currentScene = self.scenes[name]

    if self.currentScene and self.currentScene.enter then
        self.currentScene:enter(lastState)
    end
end

function SceneManager:update(dt)
    if self.currentScene and self.currentScene.update then
        self.currentScene:update(dt)
    end
end

function SceneManager:mousepressed(x, y, button)
    if self.currentScene and self.currentScene.mousepressed then
        self.currentScene:mousepressed(x, y, button)
    end
end

function SceneManager:keypressed(key, scancode, isrepeat)
    if self.currentScene and self.currentScene.mousepressed then
        self.currentScene:keypressed(key, scancode, isrepeat)
    end
end

function SceneManager:draw()
    if self.currentScene and self.currentScene.draw then
        self.currentScene:draw()
    end
end

return SceneManager
