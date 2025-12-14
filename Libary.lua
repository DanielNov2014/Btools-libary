-- MyLibrary.lua
local MyLibrary = {}
local tool
local remote

-- Internal remote invoker
local function _(args)
    if remote then
        remote:InvokeServer(unpack(args))
    else
        warn("Remote not initialized")
    end
end

-- Setup: locate SyncAPI tool and remote
function MyLibrary:Setup()
    local player = game.Players.LocalPlayer

    for _, v in ipairs(player:GetDescendants()) do
        if v.Name == "SyncAPI" then
            tool = v.Parent
        end
    end
    for _, v in ipairs(game.ReplicatedStorage:GetDescendants()) do
        if v.Name == "SyncAPI" then
            tool = v.Parent
        end
    end

    if tool then
        remote = tool:FindFirstChild("SyncAPI") and tool.SyncAPI:FindFirstChild("ServerEndpoint")
        if not remote then
            warn("ServerEndpoint not found in SyncAPI")
        end
    else
        warn("SyncAPI tool not found")
    end
end

-- SetName: rename a part via remote
function MyLibrary:SetName(part, newName)
    local args = {
        [1] = "SetName",
        [2] = { [1] = part },
        [3] = newName
    }
    _(args)
end

-- Internal CreatePart remote call
local function CreatePart(cf, parent)
    local args = {
        [1] = "CreatePart",
        [2] = "Normal",
        [3] = cf,
        [4] = parent
    }
    _(args)
end

-- CreatePart: spawn a server-side part
function MyLibrary:CreatePart(pos, name)
    name = name or "Part"

    local part = Instance.new("Part")
    part.Size = Vector3.new(1,1,1)
    part.Anchored = true
    part.CanCollide = false
    part.CanTouch = false
    part.CanQuery = false
    part.Transparency = 1
    part.Position = pos
    part.Name = "tempartlocal"
    part.Parent = workspace

    CreatePart(part.CFrame, workspace.Terrain)

    local createdpart = workspace.Terrain:FindFirstChild("Part")
    if createdpart then
        self:SetName(createdpart, name)
    else
        warn("Created part not found under Terrain")
    end

    part:Destroy()
    return createdpart
end

-- Optional: CreateWindow stub
function MyLibrary:CreateWindow(options)
    print("Creating window with title:", options.Title)
    return {Title = options.Title}
end

return MyLibrary
