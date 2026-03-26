# the-faces-of-ghosts
community-driven and github-based replacement of dynamic heads.
___

the faces of ghosts (tfog) is the first entry of the WHDB series, aiming to override Roblox's migration from Classic Faces to Dynamic Heads by forcing all dynamic heads to be replaced with their classic counterparts. a decal-based dynamic head to classic face tool.

### this is **FOSS**
anyone can make edits, rewrite the code, and upload their own modifications.
### this is **COMMUNITY-DRIVEN**
while a basic filter-list has been provided, it is by no means exhaustive. sustain the project by forking the basic list and/or making your own, and adding extra dynamic heads.
### this is **NON-COMPLIANT at heart**
we do not agree with Roblox's agenda of not only stripping the platform of its core identity, but the other outcomes of their decisions such as age verification and/or FOMO as a result of dynamic faces.

this code is highly customizable, intended for use in games of any size. it's a simple drag-and-drop into `ServerScriptService`. by default, everything is configure for production-use.
tfog's lightweight and designed with reliability and long-term stability in mind. essentially, it uses HTTP requests to get a filter list of dynamic faces and their replacements off (raw) github, or any site that returns plaintext on http get requests- i.e., an off-site, 'upstream' filter list. this means the filter auto-updates so long as a contributer updates the upstream filter list. the code itself does not require changing, albeit you will be notified if your version doesn't match the repositories version.

___

if used in your game(s), consider crediting "WHDB." credit can be in the form of a small footer, in the credits UI of your game, or anywhere else- it does not necessarily need clear visbility. this is to spread influence.
