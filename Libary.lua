-- MyLibrary.lua
local MyLibrary = {}


local tool
function MyLibrary:Setup()

	for i,v in player:GetDescendants() do
		if v.Name == "SyncAPI" then
			tool = v.Parent
		end
	end
	for i,v in game.ReplicatedStorage:GetDescendants() do
		if v.Name == "SyncAPI" then
			tool = v.Parent
		end
	end

end

remote = tool.SyncAPI.ServerEndpoint
function _(args)
	remote:InvokeServer(unpack(args))
end

function CreatePart(cf,parent)
	local args = {
		[1] = "CreatePart",
		[2] = "Normal",
		[3] = cf,
		[4] = parent
	}
	_(args)
end

function MyLibrary:CreatePart(pos:Vector3,name:string) : Part
	if name == nil then name = "Part" end
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
	CreatePart(part.CFrame,workspace.Terrain)
	local createdpart = workspace.Terrain.Part
	SetName(createdpart,name)
	part:Destroy()
	return createdpart
end
function MyLibrary:CreateWindow(options)
	print("Creating window with title:", options.Title)
	-- return a fake window object
	return {Title = options.Title}
end

return MyLibrary
