-- part of FOSS and community-driven WHDB, "we hate david baszucki"
-- we hate dynamic heads.
-- for the non-compliant, the privacy-seeking, the nostalgia-bound, the anti-billionaires.
-- https://github.com/Project-WHDB/the-faces-of-ghosts/

-- this project aggregates (gets) filter lists (via http [website] requests)
-- to provide dynamic head replacements. these lists can be updated on their
-- respective sites and magically pushed to new roblox game servers,
-- allowing a community-based filter list. inspired by adguard home.

local yes, no = true, false
local cfg = {}

-------- the main things one would change
cfg.defaultHead = 5591363797 -- default head MESH id? by default, it's the classic head
cfg.defaultFace = 5786214012 -- default face DECAL id? by default, it's the smile

cfg.useFakeHeadsInstead = no -- use fake heads? or fully replace the real head?
-- fake heads render faces at a higher quality. they make the real head invisible.
-- enabling puts the player at the risk of immediate death upon spawning. it's very rare though, and might
-- actually be fixed.
-- with real heads, you need a long-ish delay before applying the head
-- i recommend fake heads.

cfg.removeUnfilteredDynamicFaces = yes -- if a dynamic head is not found in the filter list,
-- set it to the default head and face?

cfg.mdtmUGCSupport = yes -- if true, then for any UGC item with '_replace: ' (space included) in its
-- description, all of the numbers in the description will be checked. if its a decal, then that's the
-- classic face of the ugc. if it's a mesh, then that is the headshape.
-- "mdtm" is mightyDanTheMan https://devforum.roblox.com/t/dynamic-head-classic-face-automatic-conversion-ugc-support-early-testing/4314228

cfg.ugcIdentifier = '_replace: ' -- 'TFOG' -- CLASSIC
cfg.onlyUGCWithIdentifier = no -- gets rid of the identifier. just searches for numbers automatically
-- making this setting 'yes'/true is better than using identifier.

cfg.lists = { -- the filter lists! every entry contains the list of id's. open a link and check one out.
	{
		{dynamic=10725826963, head=431164358}
	},
	{
		list={
			{dynamic=10725826962, head=431164358},
			{dynamic=10725826961, head=431164358},
			{list={
				{dynamic=10725826960, head=431164358}
			}}
		}
	},
	'https://raw.githubusercontent.com/WHDB-SERIES/the-faces-of-ghosts/refs/heads/main/filters/trusted.tfogwhdb',
	{
		list={
			-- this list has already been retrieved so its not gonna be counted twice
			'https://raw.githubusercontent.com/WHDB-SERIES/the-faces-of-ghosts/refs/heads/main/filters/trusted.tfogwhdb',
			{dynamic=10725826959, head=431164358},
			{dynamic=10725826958, head=431164358},
		}
	}
	
	--'https://raw.githubusercontent.com/Project-WHDB/the-faces-of-ghosts/refs/heads/main/filters/dogutsune.tfogwhdb',
	--'https://raw.githubusercontent.com/Project-WHDB/the-faces-of-ghosts/refs/heads/main/filters/mightydantheman.tfogwhdb'
} -- cfg.lists is not intended for live changes.

cfg.viewLinksInHead = true -- for when somebody abuses this community-driven link system
-- if a player has an unintended, game-breaking head mesh or face id, then setting this to true
-- will attatch two guiding attributes (the url and its dependencies) to the players head
-- showing which url is causing this issue. then you report it to a links maintainer.

-- scroll down if you want a headache-
-- a programming masterpiece.







-------- other properties
-- function for overriding head size
-- @param character: the model with a humanoid and head
-- @param remapInfo: the table consisting of {dynamicHead=id, head=id, face=id, headLink="rbxassetid://id", faceLink="rbxassetid://id"}
-- @return: Vector3
cfg.headSizeOverride = nil

-- function for getting the head
-- @param character: the model with a humanoid
-- @return: Instance
cfg.getHeadFunction = nil

-- function for getting a new head, because developers have unique games with unique structures
-- @param character: the model with a humanoid and head
-- @param remapInfo: the table consisting of {dynamicHead=id, head=id, face=id, headLink="rbxassetid://id", faceLink="rbxassetid://id"}
-- @return: Instance
cfg.newHeadFunction = nil

-- function for completely overriding the head replacement functionality
-- @param character: the model with a humanoid and head
-- @param remapInfo: the table consisting of {dynamicHead=id, head=id, face=id, headLink="rbxassetid://id", faceLink="rbxassetid://id"}
-- @param player: the player if present
cfg.headReplacementOverride = nil -- ensure you mark any instance in the character exactly named 'Head'
-- with an attribute called 'modified' set to true


cfg.fixNeckRigAttachment = true -- fixes how far the head is from the neck.
--this is slightly outside the projects scope tbh.

cfg.forceBreakRigsOnDeath = false -- makes character break on death if true; leaves as default if false
-- this is completely outside the projects scope.

cfg.delay = cfg.useFakeHeadsInstead and (0) or (3) -- time (seconds) (or false/nil) to wait before applying
-- this is because a roblox bug occurs settings: (useFakeHeadsInstead=false, delay=0) where the classic face is overwritten
-- by the dynamic face. beyond stupid.

-- for fake head
cfg.fakeHeadName = 'FakeHead'
cfg.faceName = 'face'
cfg.specialMeshName = 'Mesh'
cfg.fakeHeadWeldName = 'FakeHeadWeld'

-------- unnecessary to change below behaviours in most games

cfg.autoApplyToPlayers = true -- apply to players automatically?
cfg.autoApplyToNonPlayableHumanoids = true -- automatically apply to other humanoids that aren't players?

--[[]] cfg.forAllNonPlayablesApplyWithDepth = 4 -- if zero, getdescendants is used to get all humanoids
--[[]] -- otherwise we start from workspace and traverse each instance until the specified depth
--[[]] cfg.traverseClassNames = {'Folder', 'Model'} -- for traversal when depth ~= 0
--[[]] cfg.applyOnlyInFolders = {workspace} -- only go through other humanoids in these folders

cfg.immediatelyApply = true -- if false, nothing is applied until ::ApplyAll is called.
cfg.compileOnBoot = true -- if true,
-- then we http request the links and parse the data in cfg.lists on boot
-- disables cfg.federate unless cfg.federateWhileCompiled is true

cfg.yieldForCharacterAppearanceLoaded = true -- should we yield for player.characterAppearanceLoaded?
cfg.bindHeadColorToBodyColorInstance = true -- bind it to the bodycolors instance?
cfg.bindHeadColorToPreviousHeadInstance = true -- bind it to the head color?
cfg.reassignBodyColor = true -- parent the bodycolors to somewhere else, then back to character?
-- this updates the whole figures body colors i believe.

cfg.fixMisloadedBodyColor = true -- fixes a bug with body colors not loading a fully color3(0,0,0) avatar
cfg.recalculateOnHumanoidDescriptionApplied = true -- reapply when humanoid description is changed?

-- function for self-managing what humanoid receives the dynamic head changes
-- @param dynamicFaceCheck(character, player?): the function to apply dynamic head replacing to a character
-- @param playerAdded(player): player added function
-- @param descendantAdded(object): function for individual instancaes
cfg.customApplicationFunction = nil

-- for insurance
cfg.shouldYieldForBodyParts = true
cfg.yieldFor = {
	'Humanoid',
	'HumanoidRootPart',
	'Head'
}

cfg.retry = {
	['getUrl'] = {
		attempts = 3, -- how many times to try http request
		secondsPerAttempt = .2  -- first attempt takes 0 seconds, 2nd takes n seconds, 3rd takes 2n seconds, etc
	},
	
	['getVersion'] = {
		attempts = 16,
		secondsPerAttempt = .2
	},
	
	['applyHumanoidDescription'] = {
		attempts = 16,
		secondsPerAttempt = .02
	},
	
	['federationModeMessagePublish'] = {
		attempts = 64,
		secondsPerAttempt = .02
	},
	
	['getProductInfo'] = {
		attempts = 32,
		secondsPerAttempt = .1
	}
}

cfg.federate = true -- share parsed list data between servers? basically no http requests
-- but removes per-server list flexibility.
cfg.federateWhileCompiled = true -- federate runs even if the local/inquiring server already compiled the list data?

cfg.recursiveLinksEnabled = true -- enable links inside any lists?
cfg.recursiveLinksEnabledForFilterList = true

cfg.version = '1.0.0' -- don't change. if the game says that you're on an outdated version,
-- download the new version of the code (the settings and main modules) from the github:
-- https://github.com/Project-WHDB/the-faces-of-ghosts/
cfg.versionLink = 'https://raw.githubusercontent.com/Project-WHDB/the-faces-of-ghosts/refs/heads/main/VERSION'
-- for forks with unique versions


-- i really wouldn't change the version check below. your call. but i really, REALLY, recommend against turning it off.
cfg.disableVersionCheck = false -- set to true if the repository gets deleted for 'hate speech' or whatever

local RunService = game:GetService('RunService')
local onlyIfInRobloxStudio = RunService:IsStudio()

cfg.debug = false--onlyIfInRobloxStudio -- show warnings?

-- works cited
-- all roblox faces
-- modified (ilucere): https://create.roblox.com/store/asset/97958566568465/All-Classic-Faces
-- original (TheAngelMGR): https://create.roblox.com/store/asset/102647482553352/All-roblox-classic-faces-pack

-- works consulted
-- https://devforum.roblox.com/t/dynamic-head-classic-face-automatic-conversion-ugc-support-early-testing/4314228
-- https://devforum.roblox.com/t/facial-unification-convert-dynamic-heads-to-their-classic-format/4312162


return cfg