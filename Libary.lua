-- MyLibrary.lua
-- Full toolbox of remote helpers for SyncAPI

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
	print("v 1.0")
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

-- === Core building functions ===
function MyLibrary:SetCollision(part, boolean)
	_( { "SyncCollision", { { Part = part, CanCollide = boolean } } } )
end

function MyLibrary:CreatePart(cf, parent, opts)
    parent = workspace -- always parent to workspace
    opts = opts or {}
    local name = opts.Name or "Part"
    local color = opts.Color or Color3.fromRGB(255, 0, 0)

    -- temp local marker
    local temp = Instance.new("Part")
    temp.Size = Vector3.new(1,1,1)
    temp.Anchored = true
    temp.CanCollide = false
    temp.CanTouch = false
    temp.CanQuery = false
    temp.Transparency = 1
    temp.CFrame = cf
    temp.Name = "tempartlocal"
    temp.Parent = workspace

    local targetPos = temp.Position
    local createdpart

    -- hook once to grab the exact instance when it appears
    local conn
    conn = workspace.DescendantAdded:Connect(function(inst)
        if inst:IsA("BasePart") and (inst.Position - targetPos).Magnitude < 4 then
            createdpart = inst
            if conn then conn:Disconnect() end
        end
    end)

    -- invoke server creation
    _( { "CreatePart", "Normal", temp.CFrame, workspace } )

    -- fallback wait (in case event fired before we connected, or replication delay)
    for i = 1, 30 do
        if createdpart then break end
        -- scan only direct children (faster than GetDescendants)
        for _, v in ipairs(workspace:GetChildren()) do
            if v:IsA("BasePart") and (v.Position - targetPos).Magnitude < 4 then
                createdpart = v
                break
            end
        end
        if createdpart then break end
        task.wait(0.05)
    end
    if conn then conn:Disconnect() end

    if not createdpart then
        warn("CreatePart: could not capture server part near position")
        temp:Destroy()
        return nil
    end

    -- name and color
    self:SetName(createdpart, name)
    self:Color(createdpart, color)

    temp:Destroy()
    return createdpart
end



function MyLibrary:DestroyPart(part)
	_( { "Remove", { part } } )
end

function MyLibrary:MovePart(part, cf)
	_( { "SyncMove", { { Part = part, CFrame = cf } } } )
end

function MyLibrary:Resize(part, size)
	_( { "SyncResize", { { Part = part, CFrame = part.CFrame, Size = size } } } )
end

function MyLibrary:AddMesh(part)
	_( { "CreateMeshes", { { Part = part } } } )
end

function MyLibrary:SetMesh(part, meshid)
	_( { "SyncMesh", { { Part = part, MeshId = "rbxassetid://"..meshid } } } )
end

function MyLibrary:SetTexture(part, texid)
	_( { "SyncMesh", { { Part = part, TextureId = "rbxassetid://"..texid } } } )
end

function MyLibrary:SetName(part, newName)
	_( { "SetName", { part }, newName } )
end

function MyLibrary:MeshResize(part, size)
	_( { "SyncMesh", { { Part = part, Scale = size } } } )
end

function MyLibrary:Weld(part1, part2, lead)
	_( { "CreateWelds", { part1, part2 }, lead } )
end

function MyLibrary:SetLocked(part, boolean)
	_( { "SetLocked", { part }, boolean } )
end

function MyLibrary:SetTrans(part, transparency)
	_( { "SyncMaterial", { { Part = part, Transparency = transparency } } } )
end

function MyLibrary:SetAnchor(part, boolean)
	local args = {
		[1] = "SyncAnchor",
		[2] = {
			[1] = {
				["Part"] = part,
				["Anchored"] = boolean
			}
		}
	}
	_(args)
end


function MyLibrary:CreateSpotlight(part)
	_( { "CreateLights", { { Part = part, LightType = "SpotLight" } } } )
end

function MyLibrary:SyncLighting(part, brightness)
	_( { "SyncLighting", { { Part = part, LightType = "SpotLight", Brightness = brightness } } } )
end

function MyLibrary:Color(part, color)
	_( { "SyncColor", { { Part = part, Color = color, UnionColoring = false } } } )
end

function MyLibrary:SpawnDecal(part, side)
	_( { "CreateTextures", { { Part = part, Face = side, TextureType = "Decal" } } } )
end

function MyLibrary:AddDecal(part, asset, side)
	_( { "SyncTexture", { { Part = part, Face = side, TextureType = "Decal", Texture = "rbxassetid://"..asset } } } )
end

-- === Utility functions ===
function MyLibrary:Spam(id)
	for _, v in ipairs(workspace:GetDescendants()) do
		if v:IsA("BasePart") then
			spawn(function()
				self:SetLocked(v, false)
				for _, face in ipairs(Enum.NormalId:GetEnumItems()) do
					self:SpawnDecal(v, face)
					self:AddDecal(v, id, face)
				end
			end)
		end
	end
end

function MyLibrary:Sky(id)
	local char = game.Players.LocalPlayer.Character
	local pos = char.HumanoidRootPart.Position
	self:CreatePart(CFrame.new(math.floor(pos.X), math.floor(pos.Y), math.floor(pos.Z)) + Vector3.new(0,6,0), workspace)

	for _, v in ipairs(workspace:GetDescendants()) do
		if v:IsA("BasePart") and math.floor(v.Position.X) == math.floor(pos.X) and math.floor(v.Position.Z) == math.floor(pos.Z) then
			self:SetName(v, "Sky")
			self:AddMesh(v)
			self:SetMesh(v, "111891702759441")
			self:SetTexture(v, id)
			self:MeshResize(v, Vector3.new(9000,9000,9000))
			self:SetLocked(v, true)
		end
	end
end

function MyLibrary:CleanUp()
	for i,v in workspace.Terrain:GetChildren() do
		if v.Name == "Part" then
			MyLibrary:DestroyPart(v)
		end
	end
end

return MyLibrary
