we hate david baszucki, we hate dynamic heads.

# Basic Settings
### `defaultHead: decalId [number]`
**this is the default head** when no satisfactory dynamicHead is provided: zero, non-UGC, or not found in filter list.

### `defaultFace: decalId [number]`
**this is the default face** when no satisfactory dynamicHead is provided: zero, non-UGC, or not found in filter list.

**by default:**
- `cfg.fakeHeadName = 'FakeHead'`
- `cfg.faceName = 'face'`
- `cfg.specialMeshName = 'Mesh'`
- `cfg.fakeHeadWeldName = 'FakeHeadWeld'`

### `useFakeHeadsInstead: boolean`
**should fakeHeads be used?**

`true` the real head is set invisible, and a fakeHead is created.
`false` the real head is entirely replaced by anew.

### `removeUnfilteredDynamicFaces: boolean`
**should unfiltered dynamic heads be removed?**

`true` any dynamic face which is not replaced is automatically mapped to `defaultHead` and `defaultFace`.
`false` a figures dynamic face is kept as-is.

### `mdtmUGCSupport`
**should there be UGC support?** if `true`, then DynamicHead UGC items matching the configuration `ugcIdentifier` in its description (if `onlyUGCWithIdentifier` is `true`) will have its description checked for Mesh and Decal/Image IDs. if found, the DynamicHead will be mapped to these IDs.

`true`: UGC items respecting your defined criteria are included
`false`: there is no UGC support

### `viewLinksInHead`
**this is your primary means of exploiter defense.** if true, then two attributes are created on a players VISIBLE head (either FakeHead or Head): `dependencyChain` and `originalUrl`.

for `originalUrl`, this is simply the URL of which the users currently-equipped head is from. this does not include the chain of URLs.

for `dependencyChain`, this is the chain of URLs of which the user is getting their head from. if filter lists are recursively chained, this string shows every single link of that chain.

these properties help defend against sketchy lists. if a player has an unintended, game-breaking head mesh or face id, then setting this to true will show where that head is coming from. from there, it's a matter of reporting to the maintainer(s) of the lists and/or either removing the list from your game or forking the lists to remove the sketchy part.

#### criteria
- `ugcIdentifier: string` if this identifier is within the description of the UGC item, the asset is checked for asset IDs
- `onlyUGCWithIdentifier` only count DynamicHead UGCs if they have this identifier in their description
 
### `lists`
entries of this array can either be URLs (string), or a (recursive) array of URLs (string).
```lua
-- example flow.
cfg.lists = {
  'url1',
  'url2',
  {
    'url3',
    'url4'
  }
}
```

if neither, then it's regarded as a completed mapping, and will not send HTTP requests; in return, each element must be structured as the following:
```lua
[dynamicHead: number] = { -- asset ID of DynamicHead
  -- mapInfo
  head: number or nil, -- mesh ID
  face: number or nil, -- decal / image ID
}
```

`mapInfo` is defined as `{head:number?, face:number?}`

a `dynamicHeadMap`, or `map` in short, is the collection of `mapInfo`'s, used to map dynamicheads to their classic head and face counterparts.

URL entries in this `cfg.lists` configuration are sent an `HTTP GET`; the retrieved value is a raw filter list, which is then parsed with the tiny built-in scripting language.

the keywords of the language are as follows:

- `blockugc <id: number>` blacklists a given UGC creator from having their items converted to their classic counterpart (if `mdtmUGCSupport` is `true`)
- `link <url: string>` defines a URL to be recursively compiled
- `dyn <number>` the dynamic head asset ID (`dyn` and `dynamic` can be used interchangably.)
- `head <number>` the head mesh ID
- `face <number>` the face decal / image ID

here's every keyword and its mapping.
```
# and some common syntax 

'this is a one-line string'
"this is also a one-line string"
[[this, my friend, is a multi-line string]]

# this is a single comment
-- this is also a single comment

###: this is a multi comment :###
--[[ this is also a multi comment ]]--

```



the use of `link`:

```py
# testingTFOG.tfogwhdb
link "https://raw.githubusercontent.com/ilucere/fake-repository/refs/heads/main/scripts/fake-filter-list.tfogwhdb"
# essentially, you can have chained filter lists
```

when using `dyn`, `head`, or `face`, the argument is stored until it is overwritten. for example, instead of writing `head 1354235` on every line for multiple faces, you only need to write it above those faces

```py
# bad
head 1354235 face 2465246
head 1354235 face 3489908
head 1354235 face 3890634
head 1354235 face 2390025

# good
head 1354235 face 2465246
face 3489908
face 3890634
face 2390025

# even better- 'header-style' entries for clarity
head 1354235
face 2465246
face 3489908
face 3890634
face 2390025
```

a similar logic applies to the `face` keyword. the `dyn` keyword has different behaviour, in that once it's found in the map of dynamic heads to classic faces/heads, it is that entry which is used, hence between multiple entries with the same `dynamicHead` value, the one retrieved first is used.

every newline (with an eligible token such as `head`, `face`, or `dynamic`/`dyn`), the `put` keyword is automatically inserted, which 'submits' the current `dynamicHead`, `head`, and `face` for mapping. manually writing the `put` keyword is not recommended, but is available for one-liners. here's an example of 'submissions' of `put` (in brackets) when adding an entry into the map.

```py
dyn 34637321 # put {lastDynamic=34637321, lastHead=nil, lastFace=nil}
#--- any dynamic head will be replaced with a head with no mesh Id or face Id (top priority)

head 1354235 face 3489908 # put {lastDynamic=34637321, lastHead=1354235, lastFace=3489908}
#--- ignored- prior line takes precedence because it defined `dyn` first



# is equivalent to... (new script) 
dyn 34637321 # put {lastDynamic=34637321, lastHead=nil, lastFace=nil}
#--- any dynamic head will be replaced with a head with no mesh Id or face Id (top priority)

head 1354235 face 2465246 # put {lastDynamic=34637321, lastHead=1354235, lastFace=2465246}
#--- ignored- prior line takes precedence because it defined `dyn` first

face 3489908 # put {lastDynamic=34637321, lastHead=1354235, lastFace=3489908}
#--- ignored- first line takes precedence because it defined `dyn` first



# and (new script) 
dyn 34637321 # put {lastDynamic=34637321, lastHead=nil, lastFace=nil}
#--- any dynamic head will be replaced with a head with no mesh Id or face Id (top priority)

head 1354235 # put {lastDynamic=34637321, lastHead=1354235, lastFace=nil}
#--- ignored- first line takes precedence because it defined `dyn` first

face 2465246 # put {lastDynamic=34637321, lastHead=1354235, lastFace=2465246}
#--- ignored- first line takes precedence because it defined `dyn` first

face 3489908 # put {lastDynamic=34637321, lastHead=1354235, lastFace=3489908}
#--- ignored- first line takes precedence because it defined `dyn` first
```

here's an example of the manual `put` keyword in a one-liner:
```py
dynamic 34637321 head 1354235 face 2465246 put face 3489908
# put {lastDynamic=34637321, lastHead=1354235, lastFace=2465246}
# put {lastDynamic=34637321, lastHead=1354235, lastFace=3489908}

# notice how there's two `put`s in the comments?
# the first is from the manual use of the keyword
# the second is from the newline.
# both entries are added to the map, but the latter `put` is ignored because the map would find the prior first

# header-style entries do not work for the dyn/dynamic keyword.
```

one may ask, why this particular id-based format? why not names or human-friendly identifiers? here's [your answer](https://devforum.roblox.com/t/dynamic-faces-on-r6/4541892/16). structurally, it undermines the module, oversimplifying it and introducing a certain level of vagueness which would make it less cohesive and less beginner-friendly, not more.

why not JSON? it is overcomplicated for this purpose, and not beginner-friendly.



### `recursiveLinksEnabled: boolean`
if true, then filter lists can have links inside of them.
`recursiveLinksEnabledForFilterList` is a setting specifically for filter lists. both configurations must be true for filterlist chaining to occur

### `fixNeckRigAttachment: boolean`
**fixes the neck**. Roblox made it higher and elongated-looking.

### `forceBreakRigsOnDeath: boolean`
**makes humanoids break on death**. Roblox added R15 ragdolls.

### `delay: nil or boolean or seconds [number]`
**how long should we wait before applying the players head?**

### `yieldForCharacterAppearanceLoaded: boolean`
**should we wait for the players appearance to be loaded before applying the head?**

### `bindHeadColorToBodyColorInstance: boolean`
**should the head (real and fake) be bound to the bodyColor?**

### `bindHeadColorToPreviousHeadInstance: boolean`
**should the head color be bound to the previous head instance (fake head only)?**

### `reassignBodyColor: boolean`
a theoretical trick. **parent and unparent the bodyColors to reapply it?**

### `fixMisloadedBodyColor: boolean`
sometimes when spawning and applying a head too fast, the avatar becomes `Color3.new(0, 0, 0)`. **should this be fixed?**

### `fixStaticHeadOnDeath: boolean`
fixes a roblox bug where character instances welded after death (with broken joints i.e. non-ragdolls) cease physics locally. however, this will make the player name and health visible to the player on death (with broken joints)

### `recalculateOnHumanoidDescriptionApplied: boolean`
**reapply the head when the humanoid description changes?**

### `autoApplyToPlayers: boolean`
**apply to players?**

### `autoApplyToNonPlayableHumanoids: boolean`
**apply to npcs?**

#### `forAllNonPlayablesApplyWithDepth: number`
if `0`, then we get the descendants of the workspace. if greater than `0`, then we get the first `forAllNonPlayablesApplyWithDepth` layers of workspace (for example, if `1`, we get the workspaces children; if `2`, we get the workspaces children and their children).

#### `traverseClassNames: {string}`
**traverse through these objects to find a humanoid.**

#### `applyOnlyInFolders: {Instance}`
**start with these top-level folders and get the objects until the depth level.** 

### `shouldYieldForBodyParts: boolean`
**should we wait for the figures essential bodyparts?**

### `yieldFor: {string}`
**the bodyparts to yield for**

### `federate: boolean`
**prefer cross-server MessageService requests for the compiled mapInfo instead of HTTP requests?** this is a really cool feature; however, servers rely on one another for `cfg.lists`, and so flexibility is lost if you want the filter to differentiate between servers (e.g. a contributor updates the filter list. if `false`, then a server pre-update will have the old filter list, and a post-update server will have the new filter list. if `true`, both servers will likely have the old filter list).

### `federateWhileCompiled: boolean`
if the server has already compiled data directly from the `cfg.lists` filter lists while `federate` data is being retrieved from another server, should `federate` overwrite the compiled data?

### `immediatelyApply: boolean`
**apply the converter to eligible figures immediately?**

### `compileOnBoot: boolean`
**compile on boot?** if `false`, then compilation (including the http requests) happens once a figure needs the list. if `true`, it happens seamlessly on boot.

# Methods

### `tfog:ApplyCharacter(character: Model)`
apply to a single figure

### `tfog:ApplyAll()`
apply to all eligible figures

### `tfog:SetDynamicHead(character: Model, id: number)`
set the players dynamic head to that id. just a standard `Humanoid::ApplyDescriptionAsync` function, no special code in here

### `tfog:Recompile()`
manually update the filter lists, syncing them with the Github repositories

# Functions


### `headSizeOverride: nil, function(character: Model, mapInfo: mapInfo)-->Vector3`

function for overriding head size

### `getHeadFunction: nil, function(character: Model)-->Instance`

function for getting the head. for specific workflows where timing is imperative

### `newHeadFunction: nil, function(character: Model, mapInfo: mapInfo)-->Instance`

function for creating a new head. if nil, the head respective of `useFakeHeadsInstead` will be created

### `headReplacementOverride: nil, function(character: Model, mapInfo: mapInfo, player: Player?)`

completely overrides the head replacement functionality, if you only are in need of the `mapInfo`

ensure you create a value called `modified_head` inside the Humanoid once your function executes.

### `customApplicationFunction: nil, function(dynamicFaceCheck(character, player?), playerAdded(player), descendantAdded(object))`

function for self-managing what humanoid receives the dynamic head changes

### `onStaticHeadFixed: nil, function(character, humanoid, player?)

function for altering the functionality of the static head death fix. can be used to change properties of humanoid, or locally fix the health and name visibility issue

# Other

`retry` is a list of how many times each (async) function should retry if it fails. each element contains `attempts`, which is the number of times it should try before giving up, and `secondsPerAttempt`, a cumulative, **quadratic**, wait-time per attempt

```lua
local function retry(maxAttempts, timePerAtt, fn, ...)
	local attempt = 0
	local result;
	
	while (attempt <= maxAttempts) do
		attempt += 1

		result = {pcall(fn, ...)}
		if (result[1]) then
			break
		end

		if (timePerAtt) then
			task.wait(attempt * timePerAtt)
		else
			RunService.Heartbeat:Wait()
		end
	end
	
	return table.unpack(result)
end
```


`version` is the modules version

`disableVersionCheck` disables the version check

`versionLink` is where the version number is retrieved, if you wish to change this to your own repository

`debug` enables warnings if `true`