# the-faces-of-ghosts
FOSS, COMMUNITY-DRIVEN, and NON-COMPLIANT replacement of dynamic heads.
___

the faces of ghosts (tfog) is the first entry of WHDB, aiming to overturn Roblox's migration from Classic Faces to Dynamic Heads by forcing all dynamic heads to be replaced with their classic counterpart. a decal-based dynamic head to classic face tool.

- this is FOSS. anyone can make edits, rewrite my code, and upload their own modifications. see more about the license at the bottom of this page.
- this is COMMUNITY-DRIVEN. while I have provided a basic filter-list, it is by no means exhaustive. sustain the project by forking the basic list and/or making your own, and adding extra dynamic heads.
- this is NON-COMPLIANT. we do not comply with Roblox's agenda of not only stripping the platform of its core identity, but the other outcomes of their decisions such as age verification and/or FOMO as a result of dynamic faces.

this code is highly customizable, intended for use in games of any size. it's a simple drag-and-drop into serverscriptservice. by default, everything's configure for production-use.
it's also considerably lightweight but also designed with reliability and long-term stability in mind.
essentially, it uses HTTP requests to get a filter list of dynamic faces and their replacements off github, or any site that returns plaintext on http get requests- i.e., an 'off-site' filter list. that simply means the filter auto-updates so long as a user updates the off-site filter list. the code itself does not require changing, albeit you will be notified if your version doesn't match the repositories version.

___
This software is licensed under the MIT License.
In addition, any public use, distribution, or derivative work must provide clear and visible credit to the original author (e.g., in documentation, about page, or user interface where appropriate).
