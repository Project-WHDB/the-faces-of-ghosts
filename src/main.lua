if (not script.Parent:IsA('ModuleScript')) then
	error('\'main\' for tfog must be parented to the module!')
end

local cfg = require(script.Parent)
local language = require(script:WaitForChild('language'))

local Players = game:GetService('Players')
local RunService = game:GetService('RunService')
local HttpService = game:GetService('HttpService')
local MessagingService = game:GetService('MessagingService')
local MarketplaceService = game:GetService('MarketplaceService')

local rbxAssetIdUrl = 'rbxassetid://'
local enableHttpResource = 'https://devforum.roblox.com/t/how-do-i-enable-httpservice/310985/5'
-- this is also good if u need it: https://www.youtube.com/watch?v=R4DbiJSbuBU

local function set(arr)
	local set = {}
	for _, obj in ipairs(arr) do
		set[obj] = true
	end
	return set
end

local function concat(...)
	return table.concat({...})
end

local function checkHttpEnabled()
	if (not HttpService.HttpEnabled) then
		error(`http requests are not enabled! cannot parse link. fix this in experience settings!\n{enableHttpResource}`)
	end
end



local part0Part1Instances = set{
	'Weld',
	'WeldConstraint',
	'Motor6D',
	'NoCollisionConstraint'
}

local descriptionPairs = {
	{'HeadColor3', 'HeadColor'},
	{'TorsoColor3', 'TorsoColor'},
	{'LeftArmColor3', 'LeftArmColor'},
	{'RightArmColor3', 'RightArmColor'},
	{'LeftLegColor3', 'LeftLegColor'},
	{'RightLegColor3', 'RightLegColor'}
}

local defaultFaceMap = {
	head=cfg.defaultHead,
	face=cfg.defaultFace,
	dynamicHead=0,
}


local languageParameters = {
	filterList = {
		keywords = {
			['dynamic'] = {value=1, expects={'number'}},
			['head'] = {value=2, expects={'number'}},
			['face'] = {value=3, expects={'number'}},
			
			['link'] = {value=5, expects={'string'}},
			['blockugc'] = {value=6, expects={'number'}},
			['put'] = {value=7, expects={}},

			['dyn'] = 'dynamic'
		},

		singleString = {"'", '"'},
		multiString = '[[',
		multiStringEnd = ']]',

		singleComment = {'#', '--'},
		multiComment = {'###:', '--[['},
		multiCommentEnd = {':###', ']]--'},

		noWords = false,
		noNumbers = false,
		noStrings = false,
		noComments = false,

		newlineFunction = function(self, tokensThisRow)
			local isModifier = self:_hasProximityKeyword({
				'dynamic', 'head', 'face'
			}, tokensThisRow)

			if (isModifier) then
				self:_finishToken({}, 'put')
			end
		end,
	},
	
	numbersOnly = {
		noWords = true,
		noNumbers = false,
		noStrings = true,
		noComments = true
	},
}

-- for distinguishing batched messages during federation
local function newCompilingObject()
	return {
		isCompiling = false,
		finished = Instance.new('BindableEvent')
	}
end

local compilationType = {
	filterList = {value=1, object=newCompilingObject()}
}

local function isCompiling(v)
	return v.object.isCompiling
end

local function compEventWait(v)
	if (v.object.isCompiling) then
		v.object.finished.Event:Wait()
	end
end

local function compEventSignal(v)
	v.object.isCompiling = false
	v.object.finished:Fire()
end

local function compList(v, value)
	if (value) then
		v.list = value
	end
	return v.list
end

local function compSet(v, value)
	if (value) then
		v.object.isCompiling = true
	else
		compEventSignal(v)
	end
end



local filterListCompilation;
local blockedUGCCompilation;

local marketInfoCache, simpleMarketInfoCache = {}, {}
local marketInfoLoaded = Instance.new('BindableEvent')



-- other
local _warn = warn; local function warn(...)
	if (cfg.debug) then
		_warn(...)
	end
end

local function yieldParts(character)
	for _, v in ipairs(cfg.yieldFor) do
		character:WaitForChild(v)
	end
end

local function retry(maxAttempts, timePerAtt, fn, ...)
	local attempt = 0
	local result;
	
	while (attempt <= maxAttempts) do
		attempt += 1

		result = {pcall(fn, ...)}
		if (result[1]) then
			break
		else
			warn(result[1], result[2])
		end

		if (timePerAtt) then
			task.wait(attempt * timePerAtt)
		else
			RunService.Heartbeat:Wait()
		end
	end
	
	return table.unpack(result)
end

local function retryWith(data, ...)
	return retry(data.attempts, data.secondsPerAttempt, ...)
end

local function prohibitArrayAndDictionary(ardict, tableName)
	local isArray, isDictionary;
	for k in (ardict) do
		if (type(k) == 'number') then
			isArray = true
		else
			isDictionary = true
		end

		if (isArray and isDictionary) then
			error(`cannot have {tableName or 'table'} with both named keys and numerical indices!`)
		end
	end
	
	return isArray
end

local function traverse(objs, traverseClassNames, includeClassNames, maxDepth, depth, list)
	depth = depth or 1
	maxDepth = maxDepth or -1

	if (maxDepth == depth) then
		return
	end

	list = list or {}

	local newDepth = depth + 1
	for p = 1, #objs do
		local parentObject = objs[p]
		local children = parentObject:GetChildren()
		local traverseChildren, doTraverse = {}, false

		for c = 1, #children do
			local child = children[c]
			if (traverseClassNames[child.ClassName]) then
				traverseChildren[#traverseChildren + 1] = child
				doTraverse = true
			end

			if (includeClassNames[child.ClassName]) then
				list[#list + 1] = child
			end
		end

		if (doTraverse) then
			traverse(
				traverseChildren,
				traverseClassNames,
				includeClassNames,
				maxDepth,
				newDepth,
				list
			)
		end
	end

	return list
end

local function waitForChildOfClass(object, class)
	local foundClass;
	repeat
		foundClass = object:FindFirstChildOfClass(class)
		if (not foundClass) then
			object.ChildAdded:Wait()
		end
	until foundClass
	return foundClass
end

local function getDescendantSearch()
	if (cfg.forAllNonPlayablesApplyWithDepth == 0) then
		return workspace:GetDescendants()
	else
		return traverse(
			cfg.applyOnlyInFolders or {workspace},
			set(cfg.traverseClassNames),
			set{'Humanoid'},
			cfg.forAllNonPlayablesApplyWithDepth
		)
	end
end





local function getNumbersOnly(targetString)
	local numberLanguage = language.New(languageParameters.numbersOnly)
	local tokens = numberLanguage:Tokenize(targetString)
	local bytecode = numberLanguage:GetValueArray(tokens)
	numberLanguage:Destroy()

	return bytecode
end

-- the programming language
function generateMapInfoForRawFilterList(targetString, params, heirlooms)
	local basicLang = language.New(languageParameters.filterList)
	local tokens = basicLang:Tokenize(targetString)
	local bytecode = basicLang:ParseAndCompile(tokens)
	local lastDynamic, lastHead, lastFace = 0, defaultFaceMap.head, defaultFaceMap.face
	
	local map, blockedUGC = {}, {}
	local keywords = languageParameters.filterList.keywords
	
	basicLang:Interpret(bytecode, function(code)
		local keyword = code[1]

		local isHead = keyword == keywords.head
		local isDyn = keyword == keywords.dynamic
		local isFace = keyword == keywords.face

		if (isHead or isDyn or isFace) then
			local idArgument = code[2]
			local def = idArgument ~= 0 and (idArgument) or (nil)
			
			if (isHead) then
				lastHead = def or cfg.defaultHead

			elseif (isDyn) then
				lastDynamic = def or 0
			elseif (isFace) then
				lastFace = def or cfg.defaultFace
			end
		elseif (keyword == keywords.put) then
			if (not map[lastDynamic]) then
				map[lastDynamic] = {
					head=lastHead,
					face=lastFace,
				}
			end
		elseif (keyword == keywords.link and cfg.recursiveLinksEnabled and cfg.recursiveLinksEnabledForFilterList) then
			local url = code[2]
			if (not params._seenLinks[url]) then
				table.insert(params._total,
					filterListFromLink(
						url,
						params,
						heirlooms
					)
				)
			end
		elseif (keyword == keywords.creator) then
			blockedUGC[code[2]] = true
		end
	end)
	basicLang:Destroy()
	
	return map, blockedUGC
end

-- function for getting links
local function url(object, params, heirlooms)
	checkHttpEnabled()

	local link = string.gsub(object, 'https://github.com', 'https://raw.githubusercontent.com')
	if (params._seenLinks[link]) then -- might not be reliable in stopping filter-list recursion.
		return
	end
	params._seenLinks[link] = true

	local success, result = retryWith(cfg.retry.getUrl,
		HttpService.GetAsync,
		HttpService,
		link
	)

	if (not success) then
		error(`error when getting list from url! "{link}"\nerror:{result}`)
	end
	
	return result
end

function filterListFromLink(object, params, heirlooms)
	local result = url(object, params, heirlooms)
	if (not result) then
		return
	end
	
	local dynamicHeadMap, blockedUGC = generateMapInfoForRawFilterList(result, params, heirlooms)
	
	if (cfg.viewLinksInHead) then
		if (not heirlooms.dependencyChain) then
			heirlooms.dependencyChain = {}
		end
		
		local dependencyChain = heirlooms.dependencyChain
		table.insert(dependencyChain, `#{#dependencyChain+1}: "{object}"`)
		
		return {
			dynamicHeadMap = dynamicHeadMap,
			blockedUGC = blockedUGC,
			
			dependencyChain = table.concat(dependencyChain, '\n'),
			originalUrl = object
		}
	else
		return {
			dynamicHeadMap = dynamicHeadMap,
			blockedUGC = blockedUGC,
		}
	end
end

--[[
final map info
unfortuantely this format cannot change at all, despite it being so convoluted.
this format actually saves performance with the cfg.viewLinksInHead logic
data = {
	{
		map = {
			remapInfo,
			remapInfo,
			remapInfo
		}
	},

	{
		map = {
			remapInfo,
			remapInfo,
			remapInfo
		}
	},
}
]]






-- versioning
local function checkVersion()
	if (cfg.disableVersionCheck) then
		return
	end

	if (not HttpService.HttpEnabled) then
		return warn('unable to check version for tfog')
	end

	local success, result = retryWith(
		cfg.retry.getVersion,
		HttpService.GetAsync,
		HttpService,
		cfg.versionLink
	)
	
	if (not success) then
		return warn('version check failed', result)
	end
	
	if (result and result ~= cfg.version) then
		_warn('outdated version! you are on:', `{cfg.version}`, 'but the repository is on:', `{result}`)
	end
end





-- getting the compiled 'map' data so we can run through it and map dynamic heads to classic items accordingly
local function recursiveCompilerForURLs(object, params, heirloom)
	-- no real need for heirloom parameter, just for separating from params.
	-- params and heirloom are both passed down generationally. treat the latter as varargs
	
	params = params or {}
	heirloom = heirloom or {}
	
	params._total = params._total or {}
	params._seenLinks = params._seenLinks or {}
	
	local objectType = type(object)
	if (objectType == 'string' and params.linkGetter) then
		local insert = params.linkGetter(object, params, heirloom)
		if (insert) then
			table.insert(params._total, insert)
		end
		
	elseif (objectType == 'table') then
		local isArray = prohibitArrayAndDictionary(object)
		if (isArray) then
			for _, targetObject in ipairs(object) do
				recursiveCompilerForURLs(targetObject, params, heirloom)
			end
		else
			-- this entry of 'lists' (allowing of dictionaries)
			-- permit same-level/same-scope entries for later features
			-- per-object. e.g. object={doX=1, doY=2, lists={{doX=1, doY=2, lists={urls...}}}}
			
			if (params.categorizeTables) then
				params.categorizeTables(object, params, heirloom)
			end
		end
	else
		if (params.treat) then
			params.treat(object, objectType, params, heirloom)
		else
			error(`unknown type {objectType} in lists.`)
		end
	end

	return params._total
end

local function compileFilterList(ign)
	if (ign or not compList(compilationType.filterList)) then
		compSet(compilationType.filterList, true)
		
		local unmapped = {
			dynamicHeadMap = {},
			blockedUGC = {}
		}
		
		filterListCompilation = recursiveCompilerForURLs(cfg.lists, {
			linkGetter = filterListFromLink,
			categorizeTables = function(object, params, heirloom)
				if (object.dynamic or object.head or object.face) then
					unmapped.dynamicHeadMap[object.dynamic] = {
						head = object.head,
						face = object.face
					}
				elseif (object.list) then
					recursiveCompilerForURLs(object.list, params, heirloom)
				end
			end
		})
		table.insert(filterListCompilation, unmapped)
		
		compSet(compilationType.filterList, false)
	end
end


-- actual setting of head
local function destroyFakeHeadIfApplicable(character)
	if (not character) then
		return warn('no character in destroyFakeHeadIfApplicable')
	end
	
	if (cfg.useFakeHeadsInstead) then
		local existingFakeHead = character:FindFirstChild(cfg.fakeHeadName)
		if (existingFakeHead) then
			existingFakeHead:Destroy()
		end
	end
end

local function setDynamicHead(character, id, noDestroyFakeHead)
	if (not character) then
		return warn('no character in setDynamicHead')
	end
	
	if (not id) then
		return warn('no id in setDynamicHead')
	end
	
	if (not noDestroyFakeHead) then
		destroyFakeHeadIfApplicable(character)
	end
	
	local humanoidDescription = (character.Humanoid :: Humanoid):GetAppliedDescription()
	humanoidDescription.Head = id
	retryWith(cfg.retry.applyHumanoidDescription, character.Humanoid, humanoidDescription)
end

local function tryBodyColorFix(character)
	if (not character) then
		return warn('no character in tryBodyColorFix')
	end
	
	local humanoid = character.Humanoid
	local bodyColors = waitForChildOfClass(character, 'BodyColors')
	
	if (bodyColors and cfg.fixMisloadedBodyColor) then
		local humanoidDescription = humanoid:GetAppliedDescription()
		for _, v in ipairs(descriptionPairs) do
			bodyColors[v[1]] = humanoidDescription[v[2]]
		end
	end
end

local function replaceHead(character, info, player, singleCompilation)
	if (not character) then
		return warn('no character in replaceHead')
	end
	
	if (not character) then
		return warn('no remapping info in replaceHead')
	end
	
	local originalHead = cfg.getHeadFunction and (cfg.getHeadFunction(character)) or character:FindFirstChild('Head')
	if (not originalHead) then
		return warn('no head.')
	end
	
	if (cfg.delay and cfg.delay > 0) then
		task.wait(cfg.delay)
	end
	
	local humanoid = waitForChildOfClass(character, 'Humanoid')
	local bodyColors = character:FindFirstChildOfClass('BodyColors')
	
	local findPriorFakeHead = character:FindFirstChild(cfg.fakeHeadName)
	local neckRigAttachment = originalHead:FindFirstChild('NeckRigAttachment')
	
	if (cfg.fixNeckRigAttachment and neckRigAttachment) then
		neckRigAttachment.CFrame = CFrame.new(0, -.5, 0)
	end

	if (cfg.forceBreakRigsOnDeath) then
		humanoid.BreakJointsOnDeath = true
	end

	if (cfg.headReplacementOverride) then
		return cfg.headReplacementOverride(character, info, player)
	end
	
	if (humanoid.RigType == Enum.HumanoidRigType.R6) then
		if (not cfg.useFakeHeadsInstead) then -- attempt at fixing bug
			waitForChildOfClass(originalHead, 'SpecialMesh')
		end
	end
	
	-- get new head
	local newHead;
	if (cfg.newHeadFunction) then
		newHead = cfg.newHeadFunction(character, info)
	else
		newHead = Instance.new('Part')
		newHead.Size = Vector3.new(2, 1, 1)
		newHead.Color = originalHead.Color

		local specialMesh = Instance.new('SpecialMesh')
		specialMesh.Name = cfg.specialMeshName
		specialMesh.MeshType = Enum.MeshType.Head
		specialMesh.Scale = cfg.headSizeOverride and (cfg.headSizeOverride(character, info)) or (Vector3.one)
		if (info.head) then
			specialMesh.MeshId = concat(rbxAssetIdUrl, info.head)
		end
		specialMesh.Parent = newHead
		
		if (info.face) then
			local decal = Instance.new('Decal')
			decal.Face = Enum.NormalId.Front
			decal.ColorMap = concat(rbxAssetIdUrl, info.face)
			decal.Name = cfg.faceName
			decal.Parent = newHead
		end

		if (cfg.useFakeHeadsInstead) then
			newHead.Name = cfg.fakeHeadName

			newHead.CanCollide = false
			newHead.CanTouch = false
			newHead.CanQuery = false
			newHead.EnableFluidForces = false
			newHead.AudioCanCollide = false
			newHead.Massless = true

			local weld = Instance.new('Weld')
			weld.Parent = newHead
			weld.Part0 = newHead
			weld.Part1 = originalHead
			weld.Name = cfg.fakeHeadWeldName
		else
			newHead.Name = 'Head'
			newHead.CanCollide = false
			newHead.Transparency = 1
			
			newHead.Parent = character
			while (newHead.Parent ~= character) do newHead.AncestryChanged:Wait() end -- ensure
			
			local requiresNeckSignal = humanoid:GetPropertyChangedSignal('RequiresNeck')
			humanoid.RequiresNeck = false
			while (humanoid.RequiresNeck) do requiresNeckSignal:Wait() end -- ensure
		end
		
		newHead.CFrame = originalHead.CFrame
	end

	-- fix attachments and whatnot
	if (not humanoid:FindFirstChild('modified_head')) then
		Instance.new('RayValue', humanoid).Name = 'modified_head'
	end
	
	if (not cfg.useFakeHeadsInstead) then
		for _, v in ipairs(character:GetDescendants()) do
			if (v:IsA('FaceControls') or v:IsA('BaseWrap')) then
				v:Destroy()
				continue
			end

			if (v.Parent == originalHead) then
				if (v:IsA('SpecialMesh')) then
					continue
				elseif (v:IsA('Decal') or v:IsA('SurfaceAppearance')) then
					v:Destroy()
					continue
				end
				v.Parent = newHead
			end

			if (part0Part1Instances[v.ClassName]) then
				if (v.Part0 == originalHead) then
					v.Part0 = newHead
				end

				if (v.Part1 == originalHead) then
					v.Part1 = newHead
				end
			end
		end
	else
		for _, v in ipairs(character:GetDescendants()) do
			if (v:IsA('FaceControls') or v:IsA('BaseWrap')) then
				v:Destroy()
				continue
			end

			if (v.Parent == originalHead) then
				if (v:IsA('Decal')) then
					v:Destroy()
				end
			end
		end
	end

	if (bodyColors) then
		-- two methods- lets do both because why not.
		if (cfg.reassignBodyColor) then
			bodyColors.Parent = nil
			bodyColors.Parent = character
		end

		if (cfg.bindHeadColorToBodyColorInstance and not cfg.useFakeHeadsInstead) then
			newHead.Color = bodyColors.HeadColor3
			bodyColors:GetPropertyChangedSignal('HeadColor3'):Connect(function()
				newHead.Color = bodyColors.HeadColor3
			end)
		end
	end

	if (cfg.bindHeadColorToPreviousHeadInstance and cfg.useFakeHeadsInstead) then
		newHead.Color = originalHead.Color
		originalHead:GetPropertyChangedSignal('Color'):Connect(function()
			newHead.Color = originalHead.Color
		end)
	end
	
	
	if (findPriorFakeHead) then
		findPriorFakeHead:Destroy()
	end
	
	if (cfg.useFakeHeadsInstead) then
		destroyFakeHeadIfApplicable(character)
		newHead.Parent = character
		originalHead.Transparency = 1
	else
		newHead.Transparency = 0
		newHead.CanCollide = true

		local before = humanoid.RequiresNeck
		humanoid.RequiresNeck = false
		originalHead:Destroy()
		
		if (humanoid.Parent) then
			humanoid.RequiresNeck = before
		end
	end
	
	if (cfg.viewLinksInHead and singleCompilation) then
		newHead:SetAttribute('dependencyChain', singleCompilation.dependencyChain)
		newHead:SetAttribute('originalUrl', singleCompilation.originalUrl)
	end
end

local function preloadAll() -- for preloading all the heads and faces and whatnot
	local part = Instance.new('Part')
	part.Transparency = 1
	part.Archivable = true
	part.Locked = true
	part.CanTouch = false
	part.CanQuery = false
	part.CanCollide = false
	part.AudioCanCollide = false
	part.Anchored = true
	part.Massless = true
	part.EnableFluidForces = false
	part.Name = ''
	part.Parent = workspace.Terrain
	
	-- maybe positioning near a player helps preloading in streamingenabled games?
	local cf = CFrame.new()
	for _, v in ipairs(Players:GetPlayers()) do
		if (v.Character and v.Character:FindFirstChild('HumanoidRootPart')) then
			cf = v.Character.HumanoidRootPart.CFrame * CFrame.new(0, -50, 0)
			break
		end
	end
	part.CFrame = cf
	
	
	local lastHead;
	for _, singleCompilation in (filterListCompilation) do
		for _, singleDynamicHead in (singleCompilation.dynamicHeadMap) do
			if (singleDynamicHead.head and lastHead ~= singleDynamicHead.head) then
				local specialMesh = Instance.new('SpecialMesh')
				specialMesh.Parent = part
				specialMesh.MeshId = singleDynamicHead.head
				lastHead = singleDynamicHead.head
			end

			if (singleDynamicHead.face) then
				local dec = Instance.new('Decal')
				dec.ColorMap = concat(rbxAssetIdUrl, singleDynamicHead.face)
				dec.Transparency = .995
				dec.Parent = part
				dec.Transparency = 1
			end
		end
	end
	
	part:ClearAllChildren()
	part:Destroy()
end








-- get all the market info, allowing us to have ugc classic replacements as well
local function simpleMarketInfo(id)
	if (simpleMarketInfoCache[id] == nil) then
		simpleMarketInfoCache[id] = false
		
		local success, asset = retryWith(
			cfg.retry.getProductInfo,
			MarketplaceService.GetProductInfoAsync,
			MarketplaceService,
			id
		)
		
		if (not success) then
			return
		end
		
		simpleMarketInfoCache[id] = asset
		marketInfoLoaded:Fire()
	end
	
	return simpleMarketInfoCache[id]
end

local function getComplementaryClassicAssetsForFace(descriptionParsed, id)
	local dynHeadReplacementInfo = {}
	dynHeadReplacementInfo.dynamicHead = id
	
	for _, number in ipairs(descriptionParsed) do
		local assetInfo = simpleMarketInfo(number)
		if (not assetInfo) then
			continue
		end

		-- lets avoid two ugc items having each others
		-- id in their descriptions by preventing recursion
		-- (using simpleMarketInfo over getMarketInfo)
		if (number <= 31) then
			continue -- prob jus a date lol
		end
		
		if (
			assetInfo.AssetTypeId == Enum.AssetType.Decal.Value or
			assetInfo.AssetTypeId == Enum.AssetType.Image.Value)
		then
			dynHeadReplacementInfo.face = number
		elseif (assetInfo.AssetTypeId == Enum.AssetType.Mesh.Value) then
			dynHeadReplacementInfo.head = number
		end
	end
	
	return dynHeadReplacementInfo
end

local function getMarketInfo(id)
	if (marketInfoCache[id] == nil) then
		marketInfoCache[id] = false
		
		local asset = simpleMarketInfo(id)
		if (not asset or asset.AssetTypeId ~= Enum.AssetType.DynamicHead.Value) then
			return
		end
		
		marketInfoCache[id] = {
			creator = asset.Creator.Id,
			asset = asset
		}
		
		local canGetClassic =
			if (cfg.onlyUGCWithIdentifier) then
			(string.match(asset.Description, cfg.ugcIdentifier))
			else (true)
		
		if (canGetClassic) then
			local parsedDescription = getNumbersOnly(asset.Description)
			
			if (#parsedDescription > 0) then
				marketInfoCache[id].classic = 0
				marketInfoCache[id].classic = getComplementaryClassicAssetsForFace(parsedDescription, id)
			end
		end
	end
	
	return marketInfoCache[id]
end






local function dynamicFaceCheck(character, player)
	compEventWait(compilationType.filterList)
	compileFilterList()
	
	local humanoidDescription = (character.Humanoid :: Humanoid):GetAppliedDescription()
	local localHead = humanoidDescription.Head
	
	if (localHead == 0) then
		return replaceHead(character, defaultFaceMap, player)
	end
	
	-- filter lists w/ the asset of a ugc item take priority over ugc support
	-- just in case a ugc supporter abuses- then the fallback is the more-so
	-- trustworthy filter lists
	print(filterListCompilation)
	for _, singleCompilation in (filterListCompilation) do
		local targetHead = singleCompilation.dynamicHeadMap[localHead]
		if (targetHead) then
			return replaceHead(character, targetHead, player, singleCompilation)
		end
	end
	
	if (cfg.mdtmUGCSupport) then
		local marketInfo = getMarketInfo(localHead)
		if (marketInfo and marketInfo.classic) then
			local isBanished;
			for _, singleCompilation in (filterListCompilation) do
				local targetCreator = singleCompilation.blockedUGC[marketInfo.creator]
				if (targetCreator) then
					isBanished = true; break
				end
			end
			
			if (not isBanished) then
				-- this line below fixes an issue
				while (marketInfo.classic == 0) do marketInfoLoaded.Event:Wait() end
				return replaceHead(character, marketInfo.classic, player)
			end
		end
	end
	
	if (cfg.removeUnfilteredDynamicFaces) then
		replaceHead(character, defaultFaceMap, player)
	end
end






-- instance-binding
local function characterAdded(player, character, first)
	if (cfg.shouldYieldForBodyParts) then
		yieldParts(character)
	end
	
	if (cfg.yieldForCharacterAppearanceLoaded) then
		if (not player:HasAppearanceLoaded()) then
			player.CharacterAppearanceLoaded:Wait()
		end
	end
	
	if (cfg.recalculateOnHumanoidDescriptionApplied) then
		character.Humanoid.ApplyDescriptionFinished:Connect(function()
			dynamicFaceCheck(character, player)
		end)
	end
	
	tryBodyColorFix(character)
	dynamicFaceCheck(character, player)
end

local function playerAdded(player)
	characterAdded(player, player.Character or player.CharacterAdded:Wait(), true)
	player.CharacterAdded:Connect(function(character)
		characterAdded(player, character, false)
	end)
	
	--[[task.delay(8,function()
		while (1) do
			applyAllFacesSequentially(player)
		end
	end)]]
end

local function descendantAdded(descendant)
	if (descendant:IsA('Humanoid')) then
		local character = descendant.Parent
		if (character:FindFirstChild('Head') and not Players:GetPlayerFromCharacter(character)) then
			dynamicFaceCheck(character)
		end
	end
end







-- application
local function applyFederatedCompilation()
	if (not cfg.federateWhileCompiled and (isCompiling(compilationType.filterList) or filterListCompilation)) then
		return
	end
	
	if (game.PlaceId == 0 or RunService:IsStudio()) then
		return compileFilterList()
	end
	
	checkHttpEnabled()
	compSet(compilationType.filterList, true)
	
	local function dec(data)
		return HttpService:JSONDecode(data)
	end

	local function enc(data)
		return HttpService:JSONEncode(data)
	end
	
	local function post(...)
		retryWith(cfg.retry.federationModeMessagePublish, MessagingService.PublishAsync, MessagingService, ...)
	end

	local jobId = game.JobId
	local quickestServer;
	
	-- tell servers that we want someone
	local batchingServices = {}
	MessagingService:SubscribeAsync(`tfog_finally_{jobId}`, function(message)
		-- us, the inquirer, gets the data!
		local isFinalMessage = message.Data[1]
		local giverJob = message.Data[2]
		if (not batchingServices[giverJob]) then
			batchingServices[giverJob] = {}
		end
		
		local messageCategory = message.Data[4]
		if (not batchingServices[giverJob][messageCategory]) then
			batchingServices[giverJob][messageCategory] = {}
		end
		
		table.insert(batchingServices[giverJob][messageCategory], message.Data[3])
		if (isFinalMessage) then
			local finalMessage = dec(table.concat(batchingServices[giverJob][messageCategory]))
			if (messageCategory == compilationType.filterList.value) then
				if ((not cfg.federateWhileCompiled) and filterListCompilation) then
					return
				end
				filterListCompilation = finalMessage
				compSet(compilationType.filterList, false)
			end
		end
	end)
	
	local batchSize = 812 -- must not be around 1kb
	MessagingService:SubscribeAsync(`tfog_ask_compilation_{jobId}`, function(message)
		-- this function is eye-candy. very very elegant
		-- us, the giver, gives it to them
		
		local forFederation = {
			{compilationType.filterList, filterListCompilation},
		}
		
		for _, fed in (forFederation) do
			local encoded = enc(fed[2])
			local min, max = 1, 0
			local maxBatchSize = math.ceil(#encoded / batchSize)
			local inquirerJob = `tfog_finally_{message.Data}`
			
			for batch = 1, maxBatchSize do -- chunk into batches
				max += batchSize

				local selection = string.sub(encoded, min, max)
				post(inquirerJob, {
					batch == maxBatchSize,
					jobId,
					selection,
					fed[1].value
				})
				
				min += batchSize
			end
		end
	end)
	
	MessagingService:SubscribeAsync(`tfog_get_compilation_{jobId}`, function(message)
		-- inquirer
		if (quickestServer) then
			return
		end

		local giverJob = message.Data
		quickestServer = true

		-- us, the inquirer, ask the fastest server for its filterListCompilation data
		post(`tfog_ask_compilation_{giverJob}`, jobId)
	end)
	
	post('tfog_new_server', jobId)
	MessagingService:SubscribeAsync(`tfog_new_server`, function(message)
		-- giver
		-- call back to original firing server
		local inquirerJob = message.Data
		if (filterListCompilation) then
			-- send inquirer our job
			post(`tfog_get_compilation_{inquirerJob}`, jobId)
		end
	end)
	
	task.delay(.83, compileFilterList, true)
end

local function applyPlayers()
	for _, player in ipairs(Players:GetPlayers()) do
		task.spawn(playerAdded, player)
	end
	Players.PlayerAdded:Connect(playerAdded)
end

local function applyDescendants()
	for _, descendant in ipairs(getDescendantSearch()) do
		task.spawn(descendantAdded, descendant)
	end
	workspace.DescendantAdded:Connect(descendantAdded)
end

local function applyCustom()
	cfg.customApplicationFunction(dynamicFaceCheck, playerAdded, descendantAdded)
end

local function applyAll()
	if (cfg.customApplicationFunction) then
		applyCustom()
	end
	
	if (cfg.autoApplyToPlayers) then
		applyPlayers()
	end
	
	if (cfg.autoApplyToNonPlayableHumanoids) then
		applyDescendants()
	end
	
	if (cfg.federate) then
		applyFederatedCompilation()
	end
end







-- ready
checkVersion()
if (cfg.compileOnBoot) then
	compileFilterList()
	preloadAll()
end

if (cfg.immediatelyApply) then
	applyAll()
end


return {
	ApplyCharacter = function(_, character)
		dynamicFaceCheck(character)
	end,
	
	ApplyAll = function(_)
		applyAll()
	end,
	
	SetDynamicHead = function(_, character, id)
		setDynamicHead(character, id)
	end,
	
	Recompile = function(_)
		compileFilterList(true)
	end,
}