# the-faces-of-ghosts
Community-driven and Github-based replacement of dynamic heads.
___

The Faces of Ghosts (TFOG) is the first entry of the WHDB series, aiming to override Roblox's migration from Classic Faces to Dynamic Heads by forcing all dynamic heads to be replaced with their Classic counterparts. A decal-based Dynamic Head to Classic Face service.

#### This is **FOSS**
ANYONE in the world can make edits, rewrite the code, and upload their own modifications. Not only the code, but the filter lists- thats the magic!

#### This is **COMMUNITY-DRIVEN**
While a basic filter-list has been provided, it is by no means exhaustive. Susstain the project by forking the basic list and/or making your own, adding extra dynamic heads.

#### This is **NON-COMPLIANT at heart**
We do not agree with Roblox's agenda of stripping the platform of its core identity. This service is built to last, and is fundamentally unstoppable.

___

This code is HIGHLY customizable, intended for use in games of any size. It's a simple drag-and-drop into `ServerScriptService`, and by default, everything is configured, ready for production-use.

TFOG's designed with **reliability**, **stability**, **longevity**, **customization**, and **performance** in mind.

It uses HTTP requests to retrieve a filter list of dynamic faces and their replacements off (raw) github (see: examples or filters), or any site that returns plaintext per HTTP request; in other words, an **upstream** filter list. Because of this functionality, the filter auto-updates so long as a contributer changes the upstream filter list. The code itself does not require changing, albeit you will be notified if your version (number) doesn't match the repositories version.

___
## Supported Functionality
- Replace Dynamic Heads
- UGC Support (strongly inspired by MightyDanTheMan)
- Functionality Overriding
- Filter Lists or JSON
  - Recursive Filter Lists (other links inside filter list)
  - Tailored File Format / Beginner-friendly Scripting Language
- Fix 'Head Height' (NeckRigAttachment)
- Fake Heads + Changes w/ Real Head Properties (e.g. Color)
- Replacement of Real Head
- Folder-inclusion, Humanoid-inclusion, Player-inclusion
- Adjusts Fake Head
- Fixes `Color3.new(0, 0, 0)` HumanoidDescription BodyColor
- Recalculation on `Humanoid.ApplyDescriptionFinished`
- Version Checking
- Sharing of HTTP-Retrieved Filter Lists w/ Other Servers (`cfg.loveThyNeighbor`; federated mode)
___
## Filter Lists
sorted by trust level

| Name | Creator | Link | Trust Level | Notes |
| dogutsune's list | ilucere | ... | 10 | compiled and reformatted by ilucere |
| mightydantheman's list | ilucere | ... | 10 | compiled and reformatted by ilucere |
___

If used in your game(s), consider crediting "WHDB." Credit can be in the form of a small footer, in the credits of your game, or anywhere else- it does not necessarily need clear visbility. This is to spread influence.
