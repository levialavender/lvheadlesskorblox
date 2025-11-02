local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

-- ========== CONFIG ==========
local KORBLOX_MESH_ID    = "rbxassetid://101851696"
local KORBLOX_TEXTURE_ID = "rbxassetid://101851254"
local HEADLESS_MESH_ID   = "rbxassetid://123456789" 
local CHECK_INTERVAL     = 0.6  
-- ============================

local HEAD_NAMES      = {"Head"}
local RIGHT_LEG_NAMES = {"Right Leg", "RightLowerLeg", "RightUpperLeg", "RightFoot"}

local function findPart(character, nameList)
	for _, n in ipairs(nameList) do
		local p = character:FindFirstChild(n)
		if p then return p end
	end
	return nil
end

local function hasDesiredMesh(part, meshId, textureId)
	if not part then return false end
	for _, c in ipairs(part:GetChildren()) do
		if c:IsA("SpecialMesh") then
			if tostring(c.MeshId) == tostring(meshId) and (textureId == "" or tostring(c.TextureId) == tostring(textureId)) then
				return true
			end
		end
	end
	return false
end

local function applyMesh(part, meshId, textureId, scale)
	if not part then return end
	for _, c in ipairs(part:GetChildren()) do
		if c:IsA("SpecialMesh") then
			c:Destroy()
		end
	end
	local m = Instance.new("SpecialMesh")
	m.MeshType = Enum.MeshType.FileMesh
	m.MeshId = meshId or ""
	m.TextureId = textureId or ""
	m.Scale = scale or Vector3.new(1,1,1)
	m.Parent = part
end

local function ensureMeshes(character)
	if not character or not character.Parent then return end

	local head = findPart(character, HEAD_NAMES) or character:FindFirstChild("Head")
	if head and HEADLESS_MESH_ID and HEADLESS_MESH_ID ~= "" then
		if not hasDesiredMesh(head, HEADLESS_MESH_ID, "") then
			applyMesh(head, HEADLESS_MESH_ID, "", Vector3.new(1,1,1))
		end
	end

	local rightLeg = findPart(character, RIGHT_LEG_NAMES)
	if rightLeg and KORBLOX_MESH_ID and KORBLOX_MESH_ID ~= "" then
		if not hasDesiredMesh(rightLeg, KORBLOX_MESH_ID, KORBLOX_TEXTURE_ID) then
			applyMesh(rightLeg, KORBLOX_MESH_ID, KORBLOX_TEXTURE_ID, Vector3.new(1,1,1))
		end
	end
end

local function startMonitorForCharacter(char)
	task.wait(0.08)
	local childConn
	childConn = char.ChildAdded:Connect(function(child)
		if child:IsA("BasePart") then
			task.wait(0.04)
			ensureMeshes(char)
		end
	end)

	spawn(function()
		while char.Parent do
			ensureMeshes(char)
			task.wait(CHECK_INTERVAL)
		end
		if childConn then childConn:Disconnect() end
	end)
end

player.CharacterAdded:Connect(function(char)
	char:WaitForChild("Humanoid", 5)
	startMonitorForCharacter(char)
end)

if player.Character then
	startMonitorForCharacter(player.Character)
end
