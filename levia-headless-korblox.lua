-- LocalScript (StarterPlayer -> StarterPlayerScripts)
-- Auto-apply Headless + Korblox Right Leg setiap spawn

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local KORBLOX_MESH_ID    = "rbxassetid://101851696"
local KORBLOX_TEXTURE_ID = "rbxassetid://101851254"
local HEADLESS_MESH_ID   = "rbxassetid://123456789"

local HEAD_NAMES      = {"Head"}
local RIGHT_LEG_NAMES = {"Right Leg", "RightLowerLeg", "RightUpperLeg", "RightFoot"}

local function findPart(character, list)
	for _, n in ipairs(list) do
		local p = character:FindFirstChild(n)
		if p then return p end
	end
end

local function applyMesh(part, meshId, textureId, scale)
	if not part then return end
	for _, c in ipairs(part:GetChildren()) do
		if c:IsA("SpecialMesh") then c:Destroy() end
	end
	local m = Instance.new("SpecialMesh")
	m.MeshType  = Enum.MeshType.FileMesh
	m.MeshId    = meshId or ""
	m.TextureId = textureId or ""
	m.Scale     = scale or Vector3.new(1,1,1)
	m.Parent    = part
end

local function applyMeshes(character)
	if not character then return end
	local head = findPart(character, HEAD_NAMES) or character:WaitForChild("Head", 3)
	if head and HEADLESS_MESH_ID ~= "" then
		applyMesh(head, HEADLESS_MESH_ID, "", Vector3.new(1,1,1))
	end
	local rightLeg = findPart(character, RIGHT_LEG_NAMES)
	if rightLeg and KORBLOX_MESH_ID ~= "" then
		applyMesh(rightLeg, KORBLOX_MESH_ID, KORBLOX_TEXTURE_ID, Vector3.new(1,1,1))
	end
end

-- Auto jalan setiap spawn
player.CharacterAdded:Connect(function(char)
	char:WaitForChild("Humanoid", 5)
	task.wait(0.1)
	applyMeshes(char)
end)

-- Kalau karakter udah ada waktu script load
if player.Character then
	task.wait(0.1)
	applyMeshes(player.Character)
end
