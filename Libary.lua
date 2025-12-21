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

	function MyLibrary:CreatePart(cf, opts)
		opts = opts or {}
		local name = opts.Name or "Part"
		local color = opts.Color or Color3.fromRGB(255, 0, 0)

		-- Predict the server part position
		local predictedPos = cf.Position

		-- Record existing parts BEFORE creation
		local before = {}
		for _, v in ipairs(workspace:GetChildren()) do
			if v:IsA("BasePart") then
				before[v] = true
			end
		end

		-- Tell server to create the part
		_( { "CreatePart", "Normal", cf, workspace } )

		-- Wait a tiny moment for replication
		task.wait() -- one frame

		-- Find the NEW part
		local createdpart = nil
		for _, v in ipairs(workspace:GetChildren()) do
			if v:IsA("BasePart") and not before[v] then
				-- Check if it's close to predicted position
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

		-- Apply name + color
		self:SetName(createdpart, name)
		self:Color(createdpart, color)

		return createdpart
	end

	function MyLibrary:CreateWedge(cf,opts)
		opts = opts or {}
		local name = opts.Name or "Part"
		local color = opts.Color or Color3.fromRGB(255, 0, 0)

		-- Predict the server part position
		local predictedPos = cf.Position

		-- Record existing parts BEFORE creation
		local before = {}
		for _, v in ipairs(workspace:GetChildren()) do
			if v:IsA("BasePart") then
				before[v] = true
			end
		end

		-- Tell server to create the part
		_( { "CreatePart", "Wedge", cf, workspace } )

		-- Wait a tiny moment for replication
		task.wait() -- one frame

		-- Find the NEW part
		local createdpart = nil
		for _, v in ipairs(workspace:GetChildren()) do
			if v:IsA("BasePart") and not before[v] then
				-- Check if it's close to predicted position
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

		-- Apply name + color
		self:SetName(createdpart, name)
		self:Color(createdpart, color)

		return createdpart
	end

	function MyLibrary:CreateCylinder(cf, opts)
		opts = opts or {}
		local name = opts.Name or "Part"
		local color = opts.Color or Color3.fromRGB(255, 0, 0)

		-- Predict the server part position
		local predictedPos = cf.Position

		-- Record existing parts BEFORE creation
		local before = {}
		for _, v in ipairs(workspace:GetChildren()) do
			if v:IsA("BasePart") then
				before[v] = true
			end
		end

		-- Tell server to create the part
		_( { "CreatePart", "Cylinder", cf, workspace } )

		-- Wait a tiny moment for replication
		task.wait() -- one frame

		-- Find the NEW part
		local createdpart = nil
		for _, v in ipairs(workspace:GetChildren()) do
			if v:IsA("BasePart") and not before[v] then
				-- Check if it's close to predicted position
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

		-- Apply name + color
		self:SetName(createdpart, name)
		self:Color(createdpart, color)

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

	-- === Letter decal map ===
	local LetterDecals = {
		["A"] = 1460466186,
		["B"] = 1460466463,
		["C"] = 1460467117,
		["D"] = 1460467565,
		["E"] = 1460467948,
		["F"] = 5101739695,
		["G"] = 1460468793,
		["H"] = 1460469885,
		["I"] = 1460470203,
		["J"] = 1460470864,
		["K"] = 1460471190,
		["L"] = 1460471552,
		["M"] = 1460472436,
		["N"] = 5101372203,
		["O"] = 6404504624,
		["P"] = 1460474960,
		["Q"] = 1460475387,
		["R"] = 1460476613,
		["S"] = 1460476986,
		["T"] = 5101375079,
		["U"] = 1463126252,
		["V"] = 1460478937,
		["W"] = 1460479970,
		["X"] = 1460480710,
		["Y"] = 1460481542,
		["Z"] = 1460482043,
	}

	-- === WriteWord function ===
	function MyLibrary:WriteWord(word, sizeperletter, position, orientation)
		local letters = {}

		position = position or Vector3.new(0, 5, 0)
		orientation = orientation or Vector3.new(0, 0, 0)

		local baseCF =
			CFrame.new(position) *
			CFrame.Angles(
				math.rad(orientation.X),
				math.rad(orientation.Y),
				math.rad(orientation.Z)
			)

		local offset = 0
		word = string.upper(word)

		for i = 1, #word do
			local char = word:sub(i, i)
			local decalId = LetterDecals[char]

			local currentOffset = offset
			offset += sizeperletter.X

			task.spawn(function()
				-- SPACE
				if char == " " then
					local cf = baseCF * CFrame.new(currentOffset, 0, 0)

					local part = self:CreatePart(cf, {
						Name = "Space",
						Color = Color3.fromRGB(255, 255, 255)
					})

					if part then
						part.Size = sizeperletter
						letters["Space" .. currentOffset] = part
					end

					return
				end

				-- NORMAL LETTER
				if decalId then
					local cf = baseCF * CFrame.new(currentOffset, 0, 0)

					local part = self:CreatePart(cf, {
						Name = char,
						Color = Color3.fromRGB(255, 255, 255)
					})

					if part then
						part.Size = sizeperletter

						-- BACK FACE (flipped)
						self:SpawnDecal(part, Enum.NormalId.Back)
						self:AddDecal(part, decalId, Enum.NormalId.Back)

						-- handle duplicates
						local key = char
						if letters[key] then
							local n = 1
							while letters[key .. n] do
								n += 1
							end
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
				MyLibrary:DestroyPart(v)
			end
		end
	end
	
	return MyLibrary
