-- inside MyLibrary.lua

local MyLibrary = {}
local tool
local remote

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
        remote = tool.SyncAPI.ServerEndpoint
    else
        warn("No SyncAPI tool found")
    end
end

-- internal helper to invoke the remote
local function _(args)
    if remote then
        remote:InvokeServer(unpack(args))
    else
        warn("Remote not set up")
    end
end

-- new SetName method
function MyLibrary:SetName(part, newName)
    local args = {
        [1] = "SetName",
        [2] = { [1] = part },
        [3] = newName
    }
    _(args)
end

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
        self:SetName(createdpart, name) -- use the new helper
    else
        warn("No created part found under Terrain")
    end

    part:Destroy()
    return createdpart
end

return MyLibrary
