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
    name = name or "Part"
    local part = Instance.new("Part")
    part.Size = Vector3.new(1,1,1)
    part.Anchored = true
    part.Transparency = 1
    part.Position = pos
    part.Name = "tempartlocal"
    part.Parent = workspace

    CreatePart(part.CFrame, workspace)

    -- You’ll need to figure out where the server puts the created part
    -- For now, just return the local placeholder
    part.Name = name
    return part
end

function MyLibrary:CreateWindow(options)
    print("Creating window with title:", options.Title)
    return {Title = options.Title}
end

return MyLibrary
