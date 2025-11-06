    local ui = loadstring(game:HttpGet('https://raw.githubusercontent.com/Singularity5490/rbimgui-2/main/rbimgui-2.lua'))()
    local mainWindow = ui.new({
        text = 'Lootify By Pancakq',
        size = UDim2.new(0, 650, 0, 400)
    })
    mainWindow.open()

    local autoFarmTab = mainWindow.new({
        text = 'AutoFarm',
        padding = Vector2.new(10, 10)
    })

    local autoKillEnabled = false
    local lastActionTime = os.clock()

    local dungeonList = {
        {
            name = '[...] None',
            id = nil
        },
        {
            name = '01. 1Starter',
            id = 101001
        },
        {
            name = '01. 1Medium',
            id = 101002
        },
        {
            name = '01. 1Hard',
            id = 101003
        },
        {
            name = '01. 1Extreme',
            id = 101004
        },
        {
            name = '01. 1Final Boss',
            id = 101005
        },
        {
            name = '02. 2Starter',
            id = 101007
        },
        {
            name = '02. 2Medium',
            id = 101008
        },
        {
            name = '02. 2Hard',
            id = 101009
        },
        {
            name = '02. 2Extreme',
            id = 101851
        },
        {
            name = '02. 2Final Boss',
            id = 101010
        },
        {
            name = '02. 2Secret Boss',
            id = 101011
        },
        {
            name = '02. 2Secret Boss Hard',
            id = 101012
        },
        {
            name = '03. 3Starter',
            id = 101013
        },
        {
            name = '03. 3Medium',
            id = 101014
        },
        {
            name = '03. 3Hard',
            id = 101015
        },
        {
            name = '03. 3Extreme',
            id = 101016
        },
        {
            name = '03. 3Final Boss',
            id = 101852
        },
        {
            name = '03. 3Final Boss Hard',
            id = 101017
        },
        {
            name = '03. 3Final Boss Extreme',
            id = 101018
        },
        {
            name = '04. 4Starter',
            id = 101025
        },
        {
            name = '04. 4Medium',
            id = 101026
        },
        {
            name = '04. 4Hard',
            id = 101027
        },
        {
            name = '04. 4Extreme',
            id = 101028
        },
        {
            name = '04. 4Final Boss',
            id = 101029
        },
        {
            name = '0.4 4Secret Boss',
            id = 101030
        },
        {
            name = '05. 5Starter',
            id = 101035
        },
        {
            name = '05. 5Medium',
            id = 101036
        },
        {
            name = '05. 5Hard',
            id = 101037
        },
        {
            name = '05. 5Extreme',
            id = 101038
        },
        {
            name = '05. 5Final Boss',
            id = 101039
        },
        {
            name = '06. 6Starter',
            id = 101045
        },
        {
            name = '06. 6Medium',
            id = 101046
        },
        {
            name = '06. 6Hard',
            id = 101047
        },
        {
            name = '06. 6Extreme',
            id = 101048
        },
        {
            name = '06. 6Final Boss',
            id = 10109
        },
        {
            name = 'Event. Celtic Altar',
            id = 101701
        },
        {
            name = 'Wheel War 1',
            id = 101711
        },
        {
            name = 'Endless Tower',
            id = 101980
        },
        {
            name = 'Halloween Event: Jack',
            id = 101797
        },
        {
            name = 'Impossible',
            id = 101804
        },
    }
    
    local priorityList = {}

    local function findClosestEnemy()
        local closestDistance, closestEnemy = math.huge, nil
        local playerRoot = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild('HumanoidRootPart')
        
        if not playerRoot then
            return nil
        end
        
        for _, enemy in pairs(workspace:FindFirstChild('EnemyFolder'):GetChildren()) do
            if enemy:IsA('Model') and enemy:FindFirstChild('HumanoidRootPart') and enemy:FindFirstChild('Humanoid') and enemy.Humanoid.Health > 0 then
                local distance = (enemy.HumanoidRootPart.Position - playerRoot.Position).Magnitude
                if distance < closestDistance then
                    closestDistance = distance
                    closestEnemy = enemy
                end
            end
        end
        
        return closestEnemy
    end

    local tweenService = game:GetService('TweenService')

    local function moveToTarget(playerRoot, target)
        local targetCFrame = target.HumanoidRootPart.CFrame * CFrame.new(0, 0, 5)
        local tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
        local tween = tweenService:Create(playerRoot, tweenInfo, {
            CFrame = targetCFrame
        })
        tween:Play()
    end

    local function enemiesExist()
        local enemyFolder = workspace:FindFirstChild('EnemyFolder')
        if not enemyFolder then
            return false
        end
        
        for _, enemy in pairs(enemyFolder:GetChildren()) do
            if enemy:IsA('Model') and enemy:FindFirstChild('Humanoid') and enemy.Humanoid.Health > 0 then
                return true
            end
        end
        
        return false
    end

    local dungeonPositions = {
        [101002] = Vector3.new(37.09999999999991, 101.35, -306.84),
        [101003] = Vector3.new(14.54000000000002, 101.34999999999991, -306.6),
        [101004] = Vector3.new(-15.3900000000001, 101.35, -307.2),
        [101005] = Vector3.new(-37.099999999999994, 101.35, -306.47),
        [101006] = Vector3.new(-2.29, 102.22, -274.05999999999995),
        [101007] = Vector3.new(-718.27, 55.77, 1270.1),
        [101008] = Vector3.new(-781.76, 56.08, 1320.87),
        [101009] = Vector3.new(-825.8899999999999, 59.6400000000001, 1408.4799999999996),
        [101010] = Vector3.new(-923.6300000000001, 56.75, 1384.1599999999999),
        [101011] = Vector3.new(-1049.83, 56.25999999999999, 1313.55),
        [101012] = Vector3.new(-893.3, 61.21000000000001, 1479.94),
        [101013] = Vector3.new(1776.08, -133.5, 2860.93),
        [101014] = Vector3.new(1378.2399999999998, -129.25, 2808.32),
        [101015] = Vector3.new(2014.44, -131.98, 2759.540000000001),
        [101016] = Vector3.new(1366.6400000000003, -127.01, 2824.76),
        [101017] = Vector3.new(1992.17, -65.05, 2805.37),
        [101018] = Vector3.new(-5608.38, 1457.12, 4601.58),
        [101028] = Vector3.new(3417.021, 182.666, -1232.83),
        [101045] = Vector3.new(3260.22, 159.74, -1187.23),
    }

    local function teleportToDungeon(dungeonId)
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoidRootPart = character:FindFirstChild('HumanoidRootPart')
        
        if humanoidRootPart and dungeonPositions[dungeonId] then
            humanoidRootPart.CFrame = CFrame.new(dungeonPositions[dungeonId])
            print('Teleported to dungeon:', dungeonId)
        else
            print('Invalid dungeon ID or missing HumanoidRootPart')
        end
    end

    local function tryNextDungeon()
        for _, dungeonInfo in ipairs(priorityList) do
            teleportToDungeon(dungeonInfo.id)
            wait(1)
            
            local args = {
                dungeonInfo.id
            }
            game:GetService('ReplicatedStorage'):WaitForChild('Remotes'):WaitForChild('Region'):WaitForChild('EnterRegion'):FireServer(unpack(args))
            
            print('Attempting to enter:', dungeonInfo.name)
            wait(3)
            
            if enemiesExist() then
                print('Enemies detected. Proceeding with Auto Kill.')
                return
            else
                print('No enemies detected in:', dungeonInfo.name, '. Trying next priority...')
            end
        end
        print('All selected dungeons attempted. Restarting from priority 1.')
    end

    local function toggleAutoKill(enabled)
        autoKillEnabled = enabled
        local player = game.Players.LocalPlayer
        local respawnDelay = 5
        local noEnemiesTimeout = 5
        local noEnemiesCounter = 0
        
        if autoKillEnabled then
            print('Auto Kill enabled')
            spawn(function()
                while autoKillEnabled do
                    pcall(function()
                        local character = player.Character or player.CharacterAdded:Wait()
                        local humanoid = character:WaitForChild('Humanoid', 5)
                        local humanoidRootPart = character:WaitForChild('HumanoidRootPart', 5)
                        
                        if humanoid.Health <= 0 then
                            print('-- Player is dead. Waiting to respawn...')
                            repeat
                                wait(1)
                                humanoid = player.Character:WaitForChild('Humanoid', 5)
                            until humanoid.Health > 0
                            print('-- Respawn detected. Waiting before resuming attacks...')
                            wait(respawnDelay)
                        end
                        
                        if not humanoidRootPart or not humanoid then
                            print('-- Tool or HumanoidRootPart not found, retrying...')
                            return
                        end
                        
                        local tool = character:FindFirstChildOfClass('Tool') or player.Backpack:FindFirstChildOfClass('Tool')
                        
                        if not tool then
                            print('-- Tool not found, retrying...')
                            return
                        end
                        
                        if tool.Parent ~= character then
                            tool.Parent = character
                            wait(0.5)
                        end
                        
                        local target = findClosestEnemy()
                        
                        if target then
                            print('-- Enemy found, attacking immediately')
                            moveToTarget(humanoidRootPart, target)
                            tool:Activate()
                            noEnemiesCounter = 0
                        else
                            print('-- No target found, checking for enemies...')
                        end
                    end)
                    wait(0.1)
                end
            end)
            
            spawn(function()
                while autoKillEnabled do
                    if not enemiesExist() then
                        noEnemiesCounter = noEnemiesCounter + 1
                        if noEnemiesCounter >= noEnemiesTimeout then
                            print('No enemies detected for 5 seconds. Attempting to join next dungeon in priority order...')
                            tryNextDungeon()
                            noEnemiesCounter = 0
                        end
                    else
                        noEnemiesCounter = 0
                    end
                    wait(1)
                end
            end)
        else
            print('Auto Kill disabled')
        end
    end

    local autoKillSwitch = autoFarmTab.new('switch', {
        text = 'Auto Kill',
        tooltip = 'Smoothly tethers behind enemies and attacks them automatically.'
    })
    autoKillSwitch.set(false)
    autoKillSwitch.event:Connect(toggleAutoKill)

    local priorityDropdowns = {}
    for i = 1, 10 do
        local dropdown = autoFarmTab.new('dropdown', {
            text = 'Priority ' .. i,
            tooltip = 'Select dungeon for priority ' .. i
        })
        
        for _, dungeonInfo in ipairs(dungeonList) do
            dropdown.new(dungeonInfo.name)
        end
        
        dropdown.event:Connect(function(selectedName)
            for _, dungeonInfo in ipairs(dungeonList) do
                if dungeonInfo.name == selectedName then
                    priorityList[i] = {
                        name = selectedName,
                        id = dungeonInfo.id
                    }
                    print('Set priority ' .. i .. ' to dungeon:', selectedName)
                    break
                end
            end
        end)
        
        table.insert(priorityDropdowns, dropdown)
    end

    local autoTab = mainWindow.new({
        text = 'Auto',
        padding = Vector2.new(10, 10)
    })


        -- // Auto Pickup Halloween Chests (Instant Teleport Version)
    -- Folder: Workspace.HalloweenChestFolder

    local player = game.Players.LocalPlayer

    -- // UI Toggle
    local autoPickupChestSwitch = autoTab.new('switch', {
        text = 'Auto Pickup Halloween Chest',
        tooltip = 'Automatically teleports to and collects Halloween Chests instantly.'
    })
    autoPickupChestSwitch.set(false)

    local autoPickupChestEnabled = false

    -- // Teleport to chest and collect
    local function teleportToChest(chest)
        local char = player.Character or player.CharacterAdded:Wait()
        local hrp = char:WaitForChild("HumanoidRootPart")

        local root = chest:FindFirstChild("RootPart") or chest:FindFirstChildWhichIsA("BasePart", true)
        local prompt = root and chest:FindFirstChildWhichIsA("ProximityPrompt", true)
        if not (root and prompt and prompt.Enabled) then return end

        print("[🎃] Teleporting to chest:", chest.Name)

        -- Instant teleport slightly above the chest
        hrp.CFrame = root.CFrame + Vector3.new(0, 4, 0)

        -- Fire the proximity prompt
        pcall(fireproximityprompt, prompt)
        print("[🎃] Collected chest:", chest.Name)

        task.wait(0.3)
    end

        -- // Scan and collect available chests
    local function scanForChests()
        local chestFolder = workspace:FindFirstChild("HalloweenChestFolder")
        if not chestFolder then
            print("[🎃] HalloweenChestFolder not found!")
            return
        end

        local found = 0
        for _, chest in ipairs(chestFolder:GetChildren()) do
            -- Stop immediately if toggle is off
            if not autoPickupChestEnabled then
                break
            end

            local root = chest:FindFirstChild("RootPart") or chest:FindFirstChildWhichIsA("BasePart", true)
            local prompt = root and chest:FindFirstChildWhichIsA("ProximityPrompt", true)

            if prompt and prompt.Enabled then
                found += 1
                teleportToChest(chest)

                -- Also stop during the wait if toggle is off
                if not autoPickupChestEnabled then
                    break
                end
            end
        end

        if found == 0 then
            print("[🎃] No Halloween chests found.")
        else
            print("[🎃] Processed", found, "chest(s).")
        end
    end

    -- // Toggle handler
    local function toggleAutoPickupChest(enabled)
        autoPickupChestEnabled = enabled

        if autoPickupChestEnabled then
            print("[🎃] Auto Pickup Halloween Chest enabled")
            while autoPickupChestEnabled do
                pcall(scanForChests)
                task.wait(5)
            end
        else
            print("[🎃] Auto Pickup Halloween Chest disabled")
        end
    end

    autoPickupChestSwitch.event:Connect(toggleAutoPickupChest)

    -- // Detect new chests in real-time
    local folder = workspace:FindFirstChild("HalloweenChestFolder")
    if folder then
        folder.ChildAdded:Connect(function(chest)
            if autoPickupChestEnabled then
                task.wait(1)
                teleportToChest(chest)
            end
        end)
    end

    print("[🎃] Auto Pickup Halloween Chest System Loaded.")


    local player = game.Players.LocalPlayer
    local tweenService = game:GetService("TweenService")

    -- // UI Toggle
    local autoOpenChestSwitch = autoTab.new('switch', {
        text = 'Auto Open Chests',
        tooltip = 'Automatically teleports to nearby chests and opens them.'
    })
    autoOpenChestSwitch.set(false)

    local autoOpenChestEnabled = false

    -- // Function to teleport and open chest
    local function tweenToChest(chest)
        local char = player.Character or player.CharacterAdded:Wait()
        local hrp = char:WaitForChild("HumanoidRootPart")
        local originalCFrame = hrp.CFrame

        local root = chest:FindFirstChild("RootPart") or chest:FindFirstChildWhichIsA("BasePart", true)
        local prompt = root and root:FindFirstChildOfClass("ProximityPrompt")
        if not (root and prompt and prompt.Enabled) then return end

        print("Teleporting to chest:", chest.Name)

        -- Tween to chest
        local targetCFrame = root.CFrame + Vector3.new(0, 3, 0)
        local tweenInfo = TweenInfo.new(0.8, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
        local tween = tweenService:Create(hrp, tweenInfo, { CFrame = targetCFrame })
        tween:Play()
        tween.Completed:Wait()

        -- Fire the prompt
        fireproximityprompt(prompt, prompt.HoldDuration)
        print("Opened chest:", chest.Name)

        task.wait(prompt.HoldDuration + 0.5)

        -- Tween back to original position
        local returnTween = tweenService:Create(hrp, tweenInfo, { CFrame = originalCFrame })
        returnTween:Play()
    end

    -- // Scanning function
    local function scanForChests()
        local chestFolder = workspace:FindFirstChild("ChestFolder")
        if not chestFolder then
            print("ChestFolder not found!")
            return
        end

        local found = 0
        for _, chest in ipairs(chestFolder:GetChildren()) do
            local root = chest:FindFirstChild("RootPart") or chest:FindFirstChildWhichIsA("BasePart", true)
            local prompt = root and root:FindFirstChildOfClass("ProximityPrompt")

            if prompt and prompt.Enabled then
                found += 1
                tweenToChest(chest)
            end
        end

        if found == 0 then
            print("No available chests found.")
        else
            print("Processed", found, "chest(s).")
        end
    end

    -- // Toggle handler
    local function toggleAutoOpenChest(enabled)
        autoOpenChestEnabled = enabled

        if autoOpenChestEnabled then
            print("Auto Open Chests enabled")
            while autoOpenChestEnabled do
                pcall(scanForChests)
                task.wait(1)
            end
        else
            print("Auto Open Chests disabled")
        end
    end

    autoOpenChestSwitch.event:Connect(toggleAutoOpenChest)

    local autoPickupRelicSwitch = autoTab.new('switch', {
        text = 'Auto Pickup Ancient Relic',
        tooltip = 'Automatically picks up Ancient Relics by teleporting and interacting with them.'
    })
    autoPickupRelicSwitch.set(false)

    local player = game.Players.LocalPlayer
    local autoPickupRelicEnabled = false

    local function tweenToPosition(part)
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoidRootPart = character:WaitForChild('HumanoidRootPart')
        
        if humanoidRootPart then
            local targetCFrame = part.CFrame + Vector3.new(0, 3, 0)
            local tweenInfo = TweenInfo.new(0.8, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
            local tween = tweenService:Create(humanoidRootPart, tweenInfo, {
                CFrame = targetCFrame
            })
            tween:Play()
            tween.Completed:Wait()
            task.wait(0.2)
        end
    end

    local function interactWithPrompt(prompt)
        print('Interacting with ProximityPrompt at:', prompt.Parent.Name)
        fireproximityprompt(prompt)
        wait(0.5)
    end

    local function scanForRelics()
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoidRootPart = character:WaitForChild('HumanoidRootPart')
        local originalPosition = humanoidRootPart.CFrame
        local relicsFound = 0
        
        local relicsFolder = workspace:FindFirstChild('Folder')
        if not relicsFolder then
            print('Folder not found!')
            return
        end
        
        print('Scanning for relics inside Folder...')
        for _, relic in ipairs(relicsFolder:GetChildren()) do
            if relic:IsA('Model') then
                local relicPart = relic:FindFirstChildWhichIsA('Part')
                local proximityPrompt = relic:FindFirstChildWhichIsA('ProximityPrompt', true)
                
                if relicPart and proximityPrompt then
                    relicsFound = relicsFound + 1
                    print('Found Relic:', relic.Name)
                    tweenToPosition(relicPart)
                    interactWithPrompt(proximityPrompt)
                    humanoidRootPart.CFrame = originalPosition
                end
            end
        end
        
        if relicsFound == 0 then
            print('No Ancient Relics found.')
        else
            print('Processed', relicsFound, 'relic(s).')
        end
    end

    local function toggleAutoPickupRelic(enabled)
        autoPickupRelicEnabled = enabled
        
        if autoPickupRelicEnabled then
            print('Auto Pickup Ancient Relic enabled')
            while autoPickupRelicEnabled do
                pcall(scanForRelics)
                wait(1)
            end
        else
            print('Auto Pickup Ancient Relic disabled')
        end
    end

    autoPickupRelicSwitch.event:Connect(toggleAutoPickupRelic)

    local autoPickupPotionSwitch = autoTab.new('switch', {
        text = 'Auto Pickup Potion',
        tooltip = 'Automatically picks up potions by teleporting to them and interacting with them.'
    })
    autoPickupPotionSwitch.set(false)

    local autoPickupPotionEnabled = false

    local function tweenToPotion(potion)
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoidRootPart = character:WaitForChild('HumanoidRootPart')
        local originalPosition = humanoidRootPart.CFrame
        
        if potion and potion:IsA('Part') then
            print('Tweening to potion:', potion.Name)
            local targetPosition = potion.CFrame + Vector3.new(0, 3, 0)
            local tweenInfo = TweenInfo.new(0.8, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
            
            local tween = tweenService:Create(humanoidRootPart, tweenInfo, {
                CFrame = targetPosition
            })
            tween:Play()
            tween.Completed:Wait()
            
            local humanoid = character:FindFirstChild('Humanoid')
            if humanoid then
                humanoid.Jump = true
                wait(1)
            end
            
            local returnTween = tweenService:Create(humanoidRootPart, tweenInfo, {
                CFrame = originalPosition
            })
            returnTween:Play()
        end
    end

    local function scanForPotions()
        local potionsFound = 0
        local potionsFolder = workspace:FindFirstChild('Folder')
        
        if not potionsFolder then
            print('Folder not found!')
            return
        end
        
        for _, potion in ipairs(potionsFolder:GetChildren()) do
            if potion:IsA('Part') then
                potionsFound = potionsFound + 1
                print('Found Potion:', potion.Name)
                tweenToPotion(potion)
            end
        end
        
        if potionsFound == 0 then
            print('No potions found.')
        else
            print('Processed', potionsFound, 'potion(s).')
        end
    end

    local function toggleAutoPickupPotion(enabled)
        autoPickupPotionEnabled = enabled
        
        if autoPickupPotionEnabled then
            print('Auto Pickup Potion enabled')
            while autoPickupPotionEnabled do
                pcall(scanForPotions)
                wait(1)
            end
        else
            print('Auto Pickup Potion disabled')
        end
    end

    autoPickupPotionSwitch.event:Connect(toggleAutoPickupPotion)

    autoTab.new('label', {
        text = '------------------',
        color = Color3.new(1, 1, 1)
    })

    local autoUseCoinBoostSwitch = autoTab.new('switch', {
        text = 'Auto Use Potion: Coin Boost',
        tooltip = 'Automatically uses Coin Boost potion every 2 seconds.'
    })
    autoUseCoinBoostSwitch.set(false)

    local autoUseCoinBoostEnabled = false

    local function toggleAutoUseCoinBoost(enabled)
        autoUseCoinBoostEnabled = enabled
        
        if autoUseCoinBoostEnabled then
            print('Auto Use Potion: Coin Boost enabled')
            while autoUseCoinBoostEnabled do
                pcall(function()
                    local args = {
                        [1] = 104010
                    }
                    game:GetService('ReplicatedStorage'):WaitForChild('Remotes'):WaitForChild('Item'):WaitForChild('Use'):FireServer(unpack(args))
                end)
                wait(2)
            end
        else
            print('Auto Use Potion: Coin Boost disabled')
        end
    end

    autoUseCoinBoostSwitch.event:Connect(toggleAutoUseCoinBoost)

    local autoUseLuckSwitch = autoTab.new('switch', {
        text = 'Auto Use Potion: Luck',
        tooltip = 'Automatically uses Luck potion every 2 seconds.'
    })
    autoUseLuckSwitch.set(false)

    local autoUseLuckEnabled = false

    local function toggleAutoUseLuck(enabled)
        autoUseLuckEnabled = enabled
        
        if autoUseLuckEnabled then
            print('Auto Use Potion: Luck enabled')
            while autoUseLuckEnabled do
                pcall(function()
                    local args = {
                        [1] = 104001
                    }
                    game:GetService('ReplicatedStorage'):WaitForChild('Remotes'):WaitForChild('Item'):WaitForChild('Use'):FireServer(unpack(args))
                end)
                wait(2)
            end
        else
            print('Auto Use Potion: Luck disabled')
        end
    end

    autoUseLuckSwitch.event:Connect(toggleAutoUseLuck)

    local autoUseRollSpeedSwitch = autoTab.new('switch', {
        text = 'Auto Use Potion: Roll Speed',
        tooltip = 'Automatically uses Roll Speed potion every 2 seconds.'
    })
    autoUseRollSpeedSwitch.set(false)

    local autoUseRollSpeedEnabled = false

    local function toggleAutoUseRollSpeed(enabled)
        autoUseRollSpeedEnabled = enabled
        
        if autoUseRollSpeedEnabled then
            print('Auto Use Potion: Roll Speed enabled')
            while autoUseRollSpeedEnabled do
                pcall(function()
                    local args = {
                        [1] = 104004
                    }
                    game:GetService('ReplicatedStorage'):WaitForChild('Remotes'):WaitForChild('Item'):WaitForChild('Use'):FireServer(unpack(args))
                end)
                wait(2)
            end
        else
            print('Auto Use Potion: Roll Speed disabled')
        end
    end

    autoUseRollSpeedSwitch.event:Connect(toggleAutoUseRollSpeed)

    local autoUseExpSwitch = autoTab.new('switch', {
        text = 'Auto Use Potion: Exp',
        tooltip = 'Automatically uses Exp potion every 2 seconds.'
    })
    autoUseExpSwitch.set(false)

    local autoUseExpEnabled = false

    local function toggleAutoUseExp(enabled)
        autoUseExpEnabled = enabled
        
        if autoUseExpEnabled then
            print('Auto Use Potion: Exp enabled')
            while autoUseExpEnabled do
                pcall(function()
                    local args = {
                        [1] = 104007
                    }
                    game:GetService('ReplicatedStorage'):WaitForChild('Remotes'):WaitForChild('Item'):WaitForChild('Use'):FireServer(unpack(args))
                end)
                wait(2)
            end
        else
            print('Auto Use Potion: Exp disabled')
        end
    end

    autoUseExpSwitch.event:Connect(toggleAutoUseExp)

    local miscTab = mainWindow.new({
        text = 'Misc',
        padding = Vector2.new(10, 10)
    })

    local equipBestEnabled = false

local function toggleEquipBest(enabled)
    equipBestEnabled = enabled
    
    if equipBestEnabled then
        print('Equip Best enabled')
        while equipBestEnabled do
            pcall(function()
                game:GetService('ReplicatedStorage'):WaitForChild('Remotes'):WaitForChild('Backpack'):WaitForChild('EquipBest'):FireServer()
            end)
            wait(3)
        end
    else
        print('Equip Best disabled')
    end
end

    local equipBestSwitch = miscTab.new('switch', {
    text = 'Equip Best',
    tooltip = 'Automatically equips the best items every second.'
})
equipBestSwitch.set(false)
equipBestSwitch.event:Connect(toggleEquipBest)

    local autoRebirthEnabled = false

    local function toggleAutoRebirth(enabled)
        autoRebirthEnabled = enabled
        
        if autoRebirthEnabled then
            print('Auto Rebirth enabled')
            while autoRebirthEnabled do
                pcall(function()
                    game:GetService('ReplicatedStorage'):WaitForChild('Remotes'):WaitForChild('Rebirth'):WaitForChild('TryRebirth'):FireServer()
                end)
                wait(5)
            end
        else
            print('Auto Rebirth disabled')
        end
    end

    local autoRebirthSwitch = miscTab.new('switch', {
        text = 'Auto Rebirth',
        tooltip = 'Automatically attempts to rebirth every 5 seconds.'
    })
    autoRebirthSwitch.set(false)
    autoRebirthSwitch.event:Connect(toggleAutoRebirth)


    local autoSkillEnabled = false

    local function enemiesExist()
        local enemyFolder = workspace:FindFirstChild("EnemyFolder")
        if not enemyFolder then return false end
        
        for _, enemy in pairs(enemyFolder:GetChildren()) do
            if enemy:IsA("Model") and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                return true
            end
        end
        
        return false
    end

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local quickUpgradeRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Backpack"):WaitForChild("QuicklyUpgrade")

-- Configuration
local autoUpgradeEnabled = false
local upgradeDelay = 1.5     -- delay between upgrade cycles
local batchSize = 10         -- how many items to upgrade per cycle
local perItemDelay = 0.05    -- small delay between each upgrade to reduce spikes

-- Generate item IDs 1–100
local itemIDs = {}
for i = 1, 100 do
	table.insert(itemIDs, i)
end

-- Smooth quick-upgrade function
local function doQuickUpgradeAll()
	for i = 1, #itemIDs, batchSize do
		if not autoUpgradeEnabled then break end

		-- Upgrade items in small batches
		for j = i, math.min(i + batchSize - 1, #itemIDs) do
			local id = itemIDs[j]
			task.spawn(function()
				pcall(function()
					quickUpgradeRemote:FireServer(id)
				end)
			end)
			task.wait(perItemDelay)
		end

		-- Optional short break between batches
		task.wait(0.1)
	end
end

-- Control logic
local function startAutoUpgrade()
	if autoUpgradeEnabled then return end
	autoUpgradeEnabled = true
	print("✅ Auto Quickly Upgrade (IDs 1–100) enabled")

	task.spawn(function()
		while autoUpgradeEnabled do
			doQuickUpgradeAll()
			task.wait(upgradeDelay)
		end
	end)
end

local function stopAutoUpgrade()
	autoUpgradeEnabled = false
	print("❌ Auto Quickly Upgrade disabled")
end

-- UI toggle
local autoUpgradeSwitch = miscTab.new("switch", {
	text = "Auto Quickly Upgrade (IDs 1–100)",
	tooltip = "Automatically performs quick upgrades for all item IDs from 1 to 100 (optimized)."
})

autoUpgradeSwitch.set(false)
autoUpgradeSwitch.event:Connect(function(state)
	if state then
		startAutoUpgrade()
	else
		stopAutoUpgrade()
	end
end)


    local function useSkill(skillId)
        local skillRemote = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Skill"):WaitForChild("ReleaseCmd")
        local args = {skillId}
        skillRemote:FireServer(unpack(args))
        print("Skill " .. skillId .. " used!")
    end

    local skillList = {1, 2, 3, 4} -- 🔹 Added Skill 4 here

    local function toggleAutoSkill(enabled)
        autoSkillEnabled = enabled
        
        if autoSkillEnabled then
            print("Auto Skill enabled")
            while autoSkillEnabled do
                if enemiesExist() then
                    for _, skillId in ipairs(skillList) do
                        useSkill(skillId)
                        task.wait(0.5) -- delay between each skill cast
                    end
                end
                task.wait(0.5) -- delay before rotation restarts
            end
        else
            print("Auto Skill disabled")
        end
    end

    local autoSkillSwitch = miscTab.new("switch", {
        text = "Auto Skill",
        tooltip = "Automatically rotates through skills only if enemies exist."
    })
    autoSkillSwitch.set(false)
    autoSkillSwitch.event:Connect(toggleAutoSkill)

    local autoSpinEnabled = false

    -- ✅ Auto Spin function
    local function autoSpin()
        local spinRemote = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Reward"):WaitForChild("RollDices")
        while autoSpinEnabled do
            spinRemote:FireServer()
            print("🎲 Auto Spin triggered!")
            task.wait(2) -- ⏳ delay between spins (adjust as needed)
        end
    end

    -- ✅ Toggle function
    local function toggleAutoSpin(enabled)
        autoSpinEnabled = enabled
        if autoSpinEnabled then
            print("Auto Spin enabled")
            task.spawn(autoSpin)
        else
            print("Auto Spin disabled")
        end
    end

    local autoSpinSwitch = miscTab.new("switch", {
        text = "Auto Spin",
        tooltip = "Automatically rolls the dice every few seconds."
    })
    autoSpinSwitch.set(false)
    autoSpinSwitch.event:Connect(toggleAutoSpin)

    local autoFuseEnabled = false

-- ✅ Auto Fuse function
local function autoFuse()
    local fuseRemote = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Item"):WaitForChild("FuseAll")
    while autoFuseEnabled do
        fuseRemote:FireServer(true)
        print("🧪 Auto Fuse triggered!")
        task.wait(5) -- ⏳ delay between fuses (adjust as needed)
    end
end

-- ✅ Toggle function
local function toggleAutoFuse(enabled)
    autoFuseEnabled = enabled
    if autoFuseEnabled then
        print("Auto Fuse enabled")
        task.spawn(autoFuse)
    else
        print("Auto Fuse disabled")
    end
end

-- GUI Switch for Auto Fuse
local autoFuseSwitch = miscTab.new("switch", {
    text = "Auto Fuse Potion",
    tooltip = "Automatically fuses all potions every few seconds."
})
autoFuseSwitch.set(false)
autoFuseSwitch.event:Connect(toggleAutoFuse)

    miscTab.new('label', {
        text = 'Note: Use Equip Best, Auto Roll, and Auto Sell for faster progression.',
        color = Color3.new(0, 1, 0)
    })
    

    local teleportTab = mainWindow.new({
        text = 'TP',
        padding = Vector2.new(10, 10)
    })

    local function teleportTo(position)
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoidRootPart = character:FindFirstChild('HumanoidRootPart')
        
        if humanoidRootPart then
            humanoidRootPart.CFrame = CFrame.new(position)
            print('Teleported to:', position)
        else
            print('HumanoidRootPart not found!')
        end
    end

    local island1Button = teleportTab.new('button', {
        text = 'Teleport to Island 1'
    })
    island1Button.event:Connect(function()
        teleportTo(Vector3.new(-1.07, 97.28999999999996, -400.77))
    end)

    local island2Button = teleportTab.new('button', {
        text = 'Teleport to Island 2'
    })
    island2Button.event:Connect(function()
        teleportTo(Vector3.new(-667.32, 72.21, 1327.43))
    end)

    local island3Button = teleportTab.new('button', {
        text = 'Teleport to Island 3'
    })
    island3Button.event:Connect(function()
        teleportTo(Vector3.new(1731.0500000000002, 53.58, 2833.26))
    end)
    
    local guildTab = mainWindow.new({
    text = "Guild",
    padding = Vector2.new(10, 10)
})

local difficulties = {"Medium", "Hard", "Extreme", "Impossible"}
local selectedDifficulty = "Medium"

-- Dropdown
local guildDropdown = guildTab.new("dropdown", {
    text = "Select Difficulty",
    tooltip = "Choose which Guild difficulty to auto join."
})
for _, diff in ipairs(difficulties) do
    guildDropdown.new(diff)
end
guildDropdown.event:Connect(function(value)
    selectedDifficulty = value
    print("✅ Selected Guild difficulty:", selectedDifficulty)
end)

-- Auto Join Switch
local autoGuildSwitch = guildTab.new("switch", {
    text = "Auto Guild Join",
    tooltip = "Automatically joins the selected Guild difficulty after waiting 15s."
})
autoGuildSwitch.set(false)

-- Portal positions (for teleporting)
local portalPositions = {
    Medium     = Vector3.new(-679.98, 109.77, -517.81),
    Hard       = Vector3.new(-666.28, 109.77, -552.18),
    Extreme    = Vector3.new(-667.81, 109.66, -583.13),
    Impossible = Vector3.new(-657.38, 109.64, -612.67)
}

-- Function to try joining
local function tryJoinGuild(diff)
    local idx = table.find(difficulties, diff)
    if not idx then return end

    -- Try finding Guild portals (works if they're directly under workspace)
    local guildIsland = workspace:FindFirstChild("GuildIsland")
    if not guildIsland then
        warn("⚠️ GuildIsland not found in workspace.")
        return
    end

    local matchFolder = guildIsland:FindFirstChild("Match" .. (idx + 1))
    if matchFolder and matchFolder:FindFirstChild("Match") then
        game:GetService("ReplicatedStorage").Remotes.Region.Match.Enter:FireServer(matchFolder.Match)
        print("➡️ Joined:", diff)
    else
        warn("⚠️ Could not find portal Match for:", diff)
    end
end

-- Switch toggle event
autoGuildSwitch.event:Connect(function(enabled)
    autoGuildEnabled = enabled
    if autoGuildEnabled then
        print("✅ Auto Guild Join enabled")
        task.spawn(function()
            while autoGuildEnabled do
                -- Teleport player to portal
                local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local pos = portalPositions[selectedDifficulty]
                    if pos then
                        hrp.CFrame = CFrame.new(pos)
                        print("📍 Teleported to:", selectedDifficulty)
                    end
                end

                -- Countdown
                for i = 15, 1, -1 do
                    if not autoGuildEnabled then break end
                    print("Standing... joining in " .. i .. "s")
                    task.wait(1)
                end

                -- Try to join
                if autoGuildEnabled then
                    tryJoinGuild(selectedDifficulty)
                end

                task.wait(2)
            end
        end)
    else
        print("❌ Auto Guild Join disabled")
    end
end)
