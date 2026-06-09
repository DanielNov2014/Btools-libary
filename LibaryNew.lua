-- MyLibrary.lua
-- Full toolbox of remote helpers for SyncAPI (Batch-Upgraded)

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
	print("v 2.1 - Batch Support Active (Security Fix)")
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
function MyLibrary:CreatePart(cf, opts)
	opts = opts or {}
	local name = opts.Name or "Part"
	local color = opts.Color or Color3.fromRGB(255, 0, 0)

	local predictedPos = cf.Position
	local before = {}
	for _, v in ipairs(workspace:GetChildren()) do
		if v:IsA("BasePart") then before[v] = true end
	end

	_( { "CreatePart", "Normal", cf, workspace } )
	task.wait()

	local createdpart = nil
	for _, v in ipairs(workspace:GetChildren()) do
		if v:IsA("BasePart") and not before[v] then
			if (v.Position - predictedPos).Magnitude < 0.1 then
				createdpart = v
				break
			end
		end
	end

	if not createdpart then
		warn("CreatePart: Could not find server part (rare).")
		return nil
	end

	self:SetName(createdpart, name)
	self:Color(createdpart, color)

	return createdpart
end

function MyLibrary:CreateWedge(cf,opts)
	opts = opts or {}
	local name = opts.Name or "Part"
	local color = opts.Color or Color3.fromRGB(255, 0, 0)

	local predictedPos = cf.Position
	local before = {}
	for _, v in ipairs(workspace:GetChildren()) do
		if v:IsA("BasePart") then before[v] = true end
	end

	_( { "CreatePart", "Wedge", cf, workspace } )
	task.wait()

	local createdpart = nil
	for _, v in ipairs(workspace:GetChildren()) do
		if v:IsA("BasePart") and not before[v] then
			if (v.Position - predictedPos).Magnitude < 0.1 then
				createdpart = v
				break
			end
		end
	end

	if not createdpart then
		warn("CreateWedge: Could not find server part (rare).")
		return nil
	end

	self:SetName(createdpart, name)
	self:Color(createdpart, color)

	return createdpart
end

function MyLibrary:CreateCylinder(cf, opts)
	opts = opts or {}
	local name = opts.Name or "Part"
	local color = opts.Color or Color3.fromRGB(255, 0, 0)

	local predictedPos = cf.Position
	local before = {}
	for _, v in ipairs(workspace:GetChildren()) do
		if v:IsA("BasePart") then before[v] = true end
	end

	_( { "CreatePart", "Cylinder", cf, workspace } )
	task.wait()

	local createdpart = nil
	for _, v in ipairs(workspace:GetChildren()) do
		if v:IsA("BasePart") and not before[v] then
			if (v.Position - predictedPos).Magnitude < 0.1 then
				createdpart = v
				break
			end
		end
	end

	if not createdpart then
		warn("CreateCylinder: Could not find server part (rare).")
		return nil
	end

	self:SetName(createdpart, name)
	self:Color(createdpart, color)

	return createdpart
end

-- === Batch-Friendly Modifiers ===
function MyLibrary:DestroyPart(partData)
	if type(partData) == "table" then _( { "Remove", partData } ) else _( { "Remove", { partData } } ) end
end

function MyLibrary:SetCollision(partData, boolean)
	if type(partData) == "table" then _( { "SyncCollision", partData } ) else _( { "SyncCollision", { { Part = partData, CanCollide = boolean } } } ) end
end

function MyLibrary:MovePart(partData, cf)
	if type(partData) == "table" then _( { "SyncMove", partData } ) else _( { "SyncMove", { { Part = partData, CFrame = cf } } } ) end
end

function MyLibrary:Resize(partData, size)
	if type(partData) == "table" then _( { "SyncResize", partData } ) else _( { "SyncResize", { { Part = partData, CFrame = partData.CFrame, Size = size } } } ) end
end

function MyLibrary:AddMesh(partData)
	if type(partData) == "table" then _( { "CreateMeshes", partData } ) else _( { "CreateMeshes", { { Part = partData } } } ) end
end

function MyLibrary:SetMesh(partData, meshid)
	if type(partData) == "table" then _( { "SyncMesh", partData } ) else _( { "SyncMesh", { { Part = partData, MeshId = "rbxassetid://"..meshid } } } ) end
end

function MyLibrary:SetTexture(partData, texid)
	if type(partData) == "table" then _( { "SyncMesh", partData } ) else _( { "SyncMesh", { { Part = partData, TextureId = "rbxassetid://"..texid } } } ) end
end

function MyLibrary:MeshResize(partData, size)
	if type(partData) == "table" then _( { "SyncMesh", partData } ) else _( { "SyncMesh", { { Part = partData, Scale = size } } } ) end
end

function MyLibrary:SetTrans(partData, transparency)
	if type(partData) == "table" then _( { "SyncMaterial", partData } ) else _( { "SyncMaterial", { { Part = partData, Transparency = transparency } } } ) end
end

function MyLibrary:SetAnchor(partData, boolean)
	if type(partData) == "table" then _( { "SyncAnchor", partData } ) else _( { "SyncAnchor", { { Part = partData, Anchored = boolean } } } ) end
end

function MyLibrary:CreateSpotlight(partData)
	if type(partData) == "table" then _( { "CreateLights", partData } ) else _( { "CreateLights", { { Part = partData, LightType = "SpotLight" } } } ) end
end

function MyLibrary:SyncLighting(partData, brightness)
	if type(partData) == "table" then _( { "SyncLighting", partData } ) else _( { "SyncLighting", { { Part = partData, LightType = "SpotLight", Brightness = brightness } } } ) end
end

function MyLibrary:Color(partData, color)
	if type(partData) == "table" then _( { "SyncColor", partData } ) else _( { "SyncColor", { { Part = partData, Color = color, UnionColoring = false } } } ) end
end

function MyLibrary:SpawnDecal(partData, side)
	if type(partData) == "table" then _( { "CreateTextures", partData } ) else _( { "CreateTextures", { { Part = partData, Face = side, TextureType = "Decal" } } } ) end
end

function MyLibrary:AddDecal(partData, asset, side)
	if type(partData) == "table" then _( { "SyncTexture", partData } ) else _( { "SyncTexture", { { Part = partData, Face = side, TextureType = "Decal", Texture = "rbxassetid://"..asset } } } ) end
end

function MyLibrary:SetName(part, newName)
	if type(part) == "table" then _( { "SetName", part, newName } ) else _( { "SetName", { part }, newName } ) end
end

function MyLibrary:SetLocked(partData, boolean)
	if type(partData) == "table" then 
		_( { "SetLocked", partData, boolean } ) 
	else 
		_( { "SetLocked", { partData }, boolean } ) 
	end
end

function MyLibrary:Weld(part1, part2, lead)
	_( { "CreateWelds", { part1, part2 }, lead } )
end

-- === Letter decal map ===
local LetterDecals = {
	["A"] = 1460466186, ["B"] = 1460466463, ["C"] = 1460467117, ["D"] = 1460467565,
	["E"] = 1460467948, ["F"] = 5101739695, ["G"] = 1460468793, ["H"] = 1460469885,
	["I"] = 1460470203, ["J"] = 1460470864, ["K"] = 1460471190, ["L"] = 1460471552,
	["M"] = 1460472436, ["N"] = 5101372203, ["O"] = 6404504624, ["P"] = 1460474960,
	["Q"] = 1460475387, ["R"] = 1460476613, ["S"] = 1460476986, ["T"] = 5101375079,
	["U"] = 1463126252, ["V"] = 1460478937, ["W"] = 1460479970, ["X"] = 1460480710,
	["Y"] = 1460481542, ["Z"] = 1460482043,
}

-- === WriteWord function ===
function MyLibrary:WriteWord(word, sizeperletter, position, orientation)
	local letters = {}
	position = position or Vector3.new(0, 5, 0)
	orientation = orientation or Vector3.new(0, 0, 0)

	local baseCF = CFrame.new(position) * CFrame.Angles(math.rad(orientation.X), math.rad(orientation.Y), math.rad(orientation.Z))
	local offset = 0
	word = string.upper(word)

	for i = 1, #word do
		local char = word:sub(i, i)
		local decalId = LetterDecals[char]
		local currentOffset = offset
		offset += sizeperletter.X

		task.spawn(function()
			if char == " " then
				local cf = baseCF * CFrame.new(currentOffset, 0, 0)
				local part = self:CreatePart(cf, {Name = "Space", Color = Color3.fromRGB(255, 255, 255)})
				if part then
					part.Size = sizeperletter
					letters["Space" .. currentOffset] = part
				end
				return
			end

			if decalId then
				local cf = baseCF * CFrame.new(currentOffset, 0, 0)
				local part = self:CreatePart(cf, {Name = char, Color = Color3.fromRGB(255, 255, 255)})

				if part then
					part.Size = sizeperletter
					self:SpawnDecal(part, Enum.NormalId.Back)
					self:AddDecal(part, decalId, Enum.NormalId.Back)

					local key = char
					if letters[key] then
						local n = 1
						while letters[key .. n] do n += 1 end
						key = key .. n
					end
					letters[key] = part
				end
			end
		end)
	end
	return letters
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
	self:CreatePart(CFrame.new(math.floor(pos.X), math.floor(pos.Y), math.floor(pos.Z)) + Vector3.new(0,6,0))

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
			self:DestroyPart(v)
		end
	end
end

return MyLibrary
