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
{ -- RemapInfo
  dynamicHead: number, -- asset ID of DynamicHead
  head: number or nil, -- mesh ID
  headLink: string or nil, -- rbxassetid:// followed by head (above key-pair)

  face: number or nil, -- decal / image ID
  faceLink: string or nil, -- rbxassetid:// followed by face (above key-pair)
}
```

`RemapInfo` is defined as `{dynamicHead:number, head:number?, face:number?, headLink:string?, faceLink:string?}`

URL entries in this configuration are sent an `HTTP GET`; the retrieved value is a raw filter list, which is then parsed with the tiny built-in scripting language.

the keywords of the language are as follows:

- `macro <identifier> <number>` defines a macro, replacing identifiers at runtime
- `link <url>` defines a URL to be recursively compiled
- `dyn <number>` the dynamic head asset ID
- `head <number>` the head mesh ID
- `face <number>` the face decal / image ID

```py
# testingTFOG.tfogwhdb
macro FAVORITE_HEAD 290567345 # define the asset id of a particular head

link https://raw.githubusercontent.com/ilucere/fake-repository/refs/heads/main/scripts/fake-filter-list.tfogwhdb
# no need for quotations. in studio, the code will see `link` and get its corresponding repo.
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

a similar logic applies to the `face` and `dyn` keyword

every newline, the `put` keyword is signalled, which 'submits' the current line. the current `dynamicHead`, `head`, and `face` is submitted for mapping. manually writing the `put` keyword is not recommended, but is available for one-liners. here's an example of one-liners and the 'submissions' of `put` (in brackets).

```py
# commented-out `puts` are the ones done by newlines
dynamic 34637321 # put {lastDynamic=34637321, head=nil, face=nil}
head 1354235 face 2465246 put face 3489908 # put {lastDynamic=34637321, head=2465246, face=3489908}

# is essentially equivalent to...
dynamic 34637321 # put {lastDynamic=34637321, head=nil, face=nil}
head 1354235 face 2465246 # put {lastDynamic=34637321, head=1354235, face=2465246}
face 3489908 # put {lastDynamic=34637321, head=1354235, face=3489908}

# and almost
dynamic 34637321 # put {lastDynamic=34637321, head=nil, face=nil}
head 1354235 # put {lastDynamic=34637321, head=1354235, face=nil}
face 2465246 # put {lastDynamic=34637321, head=1354235, face=2465246}
face 3489908 # put {lastDynamic=34637321, head=1354235, face=3489908}
```

one may ask, why this particular format? why not names? here's [your answer](https://devforum.roblox.com/t/dynamic-faces-on-r6/4541892/16). structurally, it undermines the module, oversimplifying it and introducing a certain level of vagueness which would make it less cohesive and beginner-friendly, not more.

### `recursiveLinksEnabled: boolean`
if true, then filter lists can have links inside of them.

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

### `loveThyNeighbor: boolean`
**prefer cross-server MessageService requests for the compiled remapInfo instead of HTTP requests?** this is a really cool feature; however, servers rely on one another for `cfg.lists`, and so flexibility is lost if you want the filter to differentiate between servers (e.g. a contributor updates the filter list. if `false`, then a server pre-update will have the old filter list, and a post-update server will have the new filter list. if `true`, both servers will likely have the old filter list).

### `loveThyNeighborWhileCompiled: boolean`
if the server has already compiled data directly from the `cfg.lists` filter lists while `loveThyNeighbor` data is being retrieved from another server, should `loveThyNeighbor` overwrite the compiled data?


### `immediatelyApply: boolean`
**apply the converter to eligible figures immediately?**

### `compileOnBoot: boolean`
**compile on boot?** if `false`, then compilation (including the http requests) happens once a figure needs the list. if `true`, it happens seamlessly on boot.

### `jsonOnly: boolean`
**don't use the custom file format, and use JSON?**

# Methods

### `tfog:ApplyCharacter(character: Model)`
apply to a single figure

### `tfog:ApplyAll()`
apply to all eligible figures

### `tfog:SetDynamicHead(character: Model, id: number)`
set the players dynamic head to that id. just a standard `Humanoid::ApplyDescriptionAsync` function, no special code in here

# Functions


### `headSizeOverride: nil, function(character: Model, remapInfo: RemapInfo)-->Vector3`

function for overriding head size

### `getHeadFunction: nil, function(character: Model)-->Instance`

function for getting the head. for specific workflows where timing is imperative

### `newHeadFunction: nil, function(character: Model, remapInfo: RemapInfo)-->Instance`

function for creating a new head. if nil, the head respective of `useFakeHeadsInstead` will be created

### `headReplacementOverride: nil, function(character: Model, remapInfo: RemapInfo, player: Player?)`

completely overrides the head replacement functionality, if you only are in need of the `remapInfo`

ensure you create a value called `modified_head` inside the Humanoid once your function executes.

### `customApplicationFunction: nil, function(dynamicFaceCheck(character, player?), playerAdded(player), descendantAdded(object))

function for self-managing what humanoid receives the dynamic head changes

### `configureJson: nil, function(json: string)-->{RemapInfo}`
function for parsing the json yourself if `jsonOnly` is set to true


# Other

`httpRetries` is how many times we should retry http requests throughout most the module.

`cumulativeTimePerHttpAttempt` is the time per http request. this time builds up per attempt, resulting in longer waiting periods each attempt.

`version` is the modules version

`versionLink` is where the version number is retrieved

`disableVersionCheck` disables the version check

`debug` enables warnings if `true`