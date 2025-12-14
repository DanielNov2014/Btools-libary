-- MyLibrary.lua
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

local function _(args)
    if remote then
        remote:InvokeServer(unpack(args))
    else
        warn("Remote not set up")
    end
end

local function CreatePart(cf, parent)
    local args = {
        [1] = "CreatePart",
        [2] = "Normal",
        [3] = cf,
        [4] = parent
    }
    _(args)
end

function MyLibrary:CreatePart(pos, name)
    if name == nil then name = "Part" end

    -- temporary local part
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

    -- call your remote to create the server-side part
    CreatePart(part.CFrame, workspace.Terrain)

    -- ⚠️ this assumes the server puts a Part under Terrain
    local createdpart = workspace.Terrain:FindFirstChild("Part")
    if createdpart then
        createdpart.Name = name
    else
        warn("No created part found under Terrain")
    end

    part:Destroy()
    return createdpart
end


function MyLibrary:CreateWindow(options)
    print("Creating window with title:", options.Title)
    return {Title = options.Title}
end

return MyLibrary
