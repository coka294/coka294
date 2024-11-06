-- ServerScriptService -> Script

-- Setările pentru notificare și ESP
local fruitNotificationRange = 1000 -- În metri (sau orice unitate Roblox)
local notificationColor = Color3.fromRGB(255, 165, 0) -- Portocaliu pentru notificare
local highlightColor = Color3.fromRGB(0, 255, 0) -- Verde pentru evidențierea fructului

-- Funcția pentru a adăuga highlight unui fruct
local function addHighlightToFruit(fruit)
    -- Verifică dacă highlight-ul deja există
    if fruit:FindFirstChild("Highlight") then return end

    local highlight = Instance.new("Highlight")
    highlight.Name = "FruitHighlight"
    highlight.Adornee = fruit
    highlight.FillColor = highlightColor
    highlight.FillTransparency = 0.3
    highlight.OutlineTransparency = 0.5
    highlight.Parent = fruit
end

-- Funcția pentru a notifica jucătorii despre un fruct nou spawnat
local function notifyPlayersAboutFruit(fruit)
    -- Adaugă highlight la fruct
    addHighlightToFruit(fruit)

    -- Notifică fiecare jucător cu informația despre fruct și distanța față de ei
    for _, player in pairs(game.Players:GetPlayers()) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local playerPosition = player.Character.HumanoidRootPart.Position
            local fruitPosition = fruit.Position
            local distance = (fruitPosition - playerPosition).Magnitude

            if distance <= fruitNotificationRange then
                -- Notifică jucătorul cu un mesaj
                player:FindFirstChildOfClass("PlayerGui"):SetCore("ChatMakeSystemMessage", {
                    Text = string.format("A new fruit has spawned nearby! Distance: %.0f meters", distance),
                    Color = notificationColor,
                    Font = Enum.Font.SourceSansBold,
                    TextSize = 18,
                })
            end
        end
    end
end

-- Monitorizează fructele spawnate în joc
game.Workspace.ChildAdded:Connect(function(child)
    -- Verifică dacă este un fruct (înlocuiește cu condiția corectă pentru jocul tău)
    if child:IsA("Part") and child.Name == "Fruit" then
        -- Apelează funcția de notificare
        notifyPlayersAboutFruit(child)
    end
end)

-- Aplică highlight pentru fructele deja existente în Workspace (dacă există)
for _, item in pairs(game.Workspace:GetChildren()) do
    if item:IsA("Part") and item.Name == "Fruit" then
        addHighlightToFruit(item)
    end
end
