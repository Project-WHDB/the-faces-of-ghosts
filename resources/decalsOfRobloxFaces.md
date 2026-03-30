# decal ids of all roblox faces
**lua code that was used for obtaining this list**
```lua
-- "workspace.everythang" is https://create.roblox.com/store/asset/97958566568465
local str = {}
for _, v in ipairs(workspace.everythang:GetDescendants()) do
	if (v:IsA('Decal')) then
		table.insert(str, `{v.Name}:{string.gsub(v.ColorMap, '%D', '')}`)
	end
end

local scr = Instance.new('Script', workspace)
scr.Source = table.concat(str, '\n')
scr.Name = 'faces'
```

**you can simply string.split the whole file by ':' and do something like this**
```lua
local map = {}
local list = string.split(list, ':') -- {"O.o", "7046277", "Classic Goof", "7046286", etc...}
for i = 1, #list do
    if (i % 2 == 0) then
        map[list[i-1]] = tonumber(list[i])
    end
end
print(map) -- {["O.o"]=7046277, ["Classic Goof"]=7046286", etc...}
```
edit: don't use `:` as an identifier, use `|`

___
```
O.o:7046277
Classic Goof:7046286
Glee:7074712
Chill:7074749
Check It:7074780
Existential Angst:417334857
Classic Vampire:7074827
Winky:7074856
Drool:7074882
Uh Oh:7074932
Fearless:7074972
Whatchoo Talkin Bout:7075077
Fang:7075130
Toothy Grin:7075412
:-/:7075459
Lazy Eye:7075492
Hmmm...:7076053
Chubs:7076096
Shhh...:629925953
RAWR!:7076211
Sad Zombie:7131308
Alright:7131482
I Am Not Amused:7131857
Mysterious:7132019
Slickfang:7317591
Chippy McTooth:7317697
:-o:7317691
Good Intentioned:7317606
Blinky:7506008
Emotionally Distressed Zombie:629906620
It's Go Time!:7506025
I Lack Personal Confidence:7505989
Silly Fun:7699086
Sad:7699115
Poor Man:478719512
Frightful:7699096
Stitchface:8329438
ZOMG:8329421
Sinister:8329434
Daring:8329410
Stare:8560915
Anguished:8560912
Toothy Drool:8560901
Frightening Unibrow:417335778
Aghast:629923753
Meanie:508490451
Mischievous:9250081
Concerned:9250431
Commando:10526794
Sly Cat:10678193
Serious Cat:10678215
Serious Dog:10678225
Bad Dog:10678229
RAWR Bear:10678240
Skeletar:10747452
Retro Smiley:10747911
Hypnoface:10747392
Sir Rich McMoneyston, III:629914851
Shy Lady:10749431
eXtreme:10747652
$.$:10747371
The Big Dog:10749405
Pumpkin Face:10747387
Silence:10749546
Meow?:10749222
Yuck!:629907657
Quijibo:508485561
Redonkulous:10747492
Slobbery Villain:508484319
Mr. Chuckles:10747810
I wuv u:10749449
Crazy Abstract Artist:620866423
Bird of Prey:629949468
Finn McCool:10749456
Dizzy Face:10749463
Owl:620869273
Mr. Oinkers:629919997
Adorable Puppy:5492600700
Cute Kitty:10747401
Ninja:10749503
Love:10749488
Quackface McGraw:478719853
Muttdawg:478731659
Distaught Alien Invader:11913422
Alien Ambassador:11913449
Nibbles, Devourer of Worlds:629912441
Lion:11956455
Oh Deer:12145229
Freckles:12145059
Demented Mouse:12188129
Koala:629901607
Ghostface:12466911
And then we'll take over the world!:12732236
Blerg!:12777582
Dragonface:629903805
¬_¬:13038247
Oh Noes Another Dog:13038224
Old Man Jenkins:629927480
Walk the Plank You Scurvy Dogs!:13478066
Pony Face:13655958
I Hate Noobs:14030506
Visual Studio Seized Up For 45 Seconds... Again:14083319
Two Guys on a Boat:14123364
WHAAAaaa!:14123340
No Z:14405631
Sniffles:14516479
Scarecrow Face:14721752
D::14812835
=):14817231
:P:14861556
:-O:15013091
XD:15054328
:'(:15133335
>:3:15177471
>_<:15324447
^_^:15365479
x_x:15395252
:3:15431991
:-{:15471076
Hut Hut Hike!:15470573
ILOVEFOOTBOLL!:629948559
:/:15470952
-_-:15637705
:-?:15858100
Cutiemouse:15885042
Tango:16101613
:D:16132434
Semi Colon Open Paren:16179600
NetHack Addict:16357318
>_>:16387598
D=:17137977
:}:18151722
Friendly Pirate:19366214
Jack Frost Face:19396122
Grr!:19398553
Toothless:19627641
Starry Eyed:19958885
Yawn:20010294
Puck:20298933
Disbelief:20337265
Err...:20418518
Secret Service:20612916
Xtreme Happy:20643951
Shiny Teeth:20722053
Sweat It Out:20909031
Sigmund:21311520
Downcast:21351916
Toughguy:21439548
Heeeeeey...:21635489
You ated my caik!:21638407
Woebegone:21754586
Glory on the Gridiron:21796275
Timmy McPwnage:22023001
Square Eyes:22118943
Masque:629920835
The Friendly Eviscerator:22500052
Fast Car:22587893
Speaker of Lightning:149486853
Lightning Speaker:22588800
Wink-Blink:22828283
Whistle:22877631
Nervous:23219775
Look At My Nose:23311760
Awkward....:23931977
Drooling Noob:24067663
Squiggle Mouth:25165947
Friendly Grin:25321744
Scarecrow:26260786
Know-It-All Grin:26424652
Sick Day:26619042
Old Timer:27003564
Raccoon:27052496
Goofball:27134272
Smith McCool:27412750
Friendly Puppy:27725380
Hilarious:27861351
Not Again!:28118994
Pwnda Face:28281785
Adoration:28878210
Joyous Surprise:28999175
Daydreaming:29296097
Lady Lashes:29347988
Vampire:29532362
Thinking:29716203
Robot Smile:30265036
Friendly Cyclops:30394437
Braces:30394483
Awesome Face:30394849
=(:30395096
Skeptic:31117192
Alien:31317607
So Funny:32058103
I <3 New Site Theme:32723156
Starface:32873288
Cheerful Grin:33321688
Disbelief Face:34186612
Shutter Shades: The Face:34673639
Magical Dragon:34871107
Exclamation Face:35168482
Gigglypuff:35397044
Epic Face:42070872
Crazy Happy:45515545
Monster Face:49045252
Sunny Fun:51241170
Obvious Wink:51241536
NOWAI!:51241861
Bored:66329524
O_o :66329844
Singing:66329905
Buddy Face:83025169
Disapproving Unibrow:66329994
Dr. Smyth Face:83016614
Manlier Face:83017053
Kate Face:83021209
Honey Face:83022608
Max Face:83015508
Missy Face:83321898
Pal Face:83025982
Sarge Face:82837707
Sarge Extreme Face:81615913
Sarge Sad Face:82824027
Dr. Smyth Face:83016614
Man Face:83017053
Kate Face:83021209
Woman Face:83022608
iFace:97717261
Spring Bunny :108209955
Daring Beard:110287880
I Didn't Eat That Cookie:115978221
Sadfaic:629925029
Bombo Face:121946959
Zombie Face:133360891
Tired Face:141728515
Drill Sergeant:657217430
Hockey Face:142888113
Smile:144080495
Shocked:147144198
Bluffing:147144273
Awkward Eyeroll:150070631
Huh?:150070505
Awkward Grin:150070305
Classic Alien Face:158017769
YAAAWWN.:161124757
Angry Zombie:168332015
Not sure if...:168332209
Grumpy Blox:478720454
Epic Vampire Face:181661839
Sharpnine's Face of Disappointment:209712916
Raig Face:209714802
Smiling Girl:209713952
Suspicious:209715003
Joyful Smile:209713384
Laughing Fun:226216895
Happy Wink:236455674
Sly Guy Face:238984437
Just Trouble:243755928
Serious Scar Face:255828374
Tiger Chase Fear Face:258192246
Bad News Face:629929484
Whuut?:273874617
Furious George :277939506
Super Happy Joy:280987381
Happy Girl Face:287062870
RBX-90 Face:293229488
Amelia Face:292668540
Ezebel Face:286947469
Krezak - Face:286951068
Furious Finn Face:295491745
Too Much Candy:295421997
Lin's Face:292668540
Serena’s Face:287062870
Claire's Face:287062870
Casey's Face:286951068
John's Face:321741599
Oakley's Face:286951068
Pumpkin Face:313548987
Don't Wake Me Up:343187883
Cheerful Hello:362050947
Chill McCool:376788359
Tix Vision:620870415
Blue-eyed Awesome Face:386188071
Ogre Face:629922352
Super Crazy Face:508488410
Big Sad Eyes:629933140
Nouveau George:398670843
Monster Smile:398671601
Happy :D:406035320
¬_¬ 2.0:405705854
XD 2.0:405706156
ROAR!!!:405704879
Smug:405706038
Sharpnine's Face of Joy:405706600
Stink Eye:416829404
Anime Surprise:416829065
Unbelievable:419749791
Pink Wistful Wink:583713318
Jacob: The Storm Breaker Face:599921920
The Winning Smile:616395480
Friendly Smile:616394568
DDotty Smile:667683410
BiteyMcFace:904124085
Dex's Face:286951068
Zoey Face:287062870
Sneaky Steve:823018334
Pink Moonstruck:878945106
Blue Moonstruck:878947374
Purple Moonstruck:878944494
Winning Smile:1315936169
Death's Grin:1315935475
Sapphire Gaze:1315942144
Squinty Assassin Face:1315942662
Up To Something:1016181246
Tohru: The Phantom Claw's Face:1384268303
Overjoyed Smile:1428312511
Rogueish Good Looks:1868539477
Rainbow Barf Face:1868469550
Otakufaic:2176326858
Upside Down Face:1772583132
Hold It In:2222767231
Pop Queen Smilestar Spectacusmile:2565825723
Fashion Face:2565818601
City Life Man - Face:2490055992
City Life Woman - Face:2492475038
Knights of Redcliff: Paladin - Face:2492950480
The High Seas: Beatrix The Pirate Queen - Face:2493660907
Squad Ghouls: Drop Dead Tedd - Zombie Face:2499282434
Rogue Era Magus - Face:2499475232
Sunstar - Face:2502420356
Wanted Desperado - Face:2502512164
Barb the Barbarian - Face:2502295804
Knight of Splintered Skies Ascendant - Face:2506453417
Police Officer Nash - Face:2506729946
Dark Age Apprentice - Face:2506788845
Dr. Lauren, Artifact Excavator - Face:2506968954
Knight of Chivalry - Face:2507424923
Elf Guardian of the Northern Border - Face:2507497762
Squad Ghouls: Zoe Saberhagen - Face:2514352026
Rock Star Singer - Face:2342052677
Wyldfire Fairy - Face:2514414752
Fearless Ocean Diver - Face:2515271103
Baroness Callidora - Face:2514388837
DIY Cardboard Knight - Face:2514392290
Arachnid Queen:2565828727
C.Y.N.D.I - Face:2514403812
Knights of Redcliff: General - Face:2313826098
Samantha - Face:2514418247
Knight of Courage - Face:2530798909
The Harbinger - Face:2514587317
Beekeeper - Face:2551694054
Alexandra Ninniflip - Face:2551758057
8-Bit Heart Face:2568569786
Satyr Face:2571723000
Ballerina Face:2571725090
Billionaire Heiress' Face:2571727019
Gamin the Scaled Sorcerer - Face:2573833907
Terrain Assault Specialist  - Face:2573923862
InsectZoids: Dr. Mantis_Face:2583147905
Icicle Fairy_Face:2514416175
Poisonous Beast Mode:2606174048
Specter Informant - Face:2514568836
Minerva Bright - Face:2341561567
Rach - Face:2514445602
Lynn - Face:2610489111
Rock Star Guitarist - Face:2514396066
Sparkle Time Sparkle Eyes:2620489144
Astral Isle Clan: Windsor the Blue - Face:2623056236
High Seas: Pirate King Xerxes - Face:2623052853
The Phantom Phalanx: Cygnus-34 - Face:2514345793
Genni the Snail Knight-Errant - Face:2623058805
Yeti Hunter Face:2646087114
Chester Finkleton - Face:2639364063
Pepper Krinklesnaps - Face:2639366656
Supreme Claus - Face:2625379390
Knights of Redcliff: Elite Dragoon - Face:2658471215
Skater Gurl - Face:2739777922
Skater Boi - Face:2739778788
Sheriff Buffington - Face:2756332108
Overseer: Assassin - Face:2756347310
Knights of Redcliff: Warrior - Face:2756343123
Football Player - Face:2772513986
Aztec Warrior Face:2803576899
Royal Eye of Horus Face:2803654708
Lady Darkshade - Face:2794747554
Dr. Bunton Madmind - Face:2797313154
Slithering Smile:2830640563
William "Big Bill" Conner - Face:2827303145
Pizza Face:3065052750
Cyanskeleface:3065051594
THE SOUP IS DRY:3065049688
Star-Mist Fairy - Face:2849462122
Gwen "Axe Angel" Rosewood - Face:2849500812
The Birdcaller - Face:2874300109
Valkyrie of the Splintered Skies - Face:2903490495
Fanciful Leprechaun Face:2907636680
Tenko the Nine-Tailed Fox - Face:2900211650
Sammy "Slick" Witter - Face:2874324913
Digital Artist - Face:2924060633
Jester Equinox - Face:2953700072
Oli Zigzag - Face:2957259729
Kroma Blitz - Face:2959503199
Aurora Spark - Face:2956959047
Octavia, The Ivory Spider Girl - Face:2975222716
Futureglam Bounty Hunter Face:3008636268
WWE - Seth Rollins Face:3016152826
WWE - Xavier Woods Face:3016289446
WWE - Becky Lynch Face:3016321351
WWE - Roman Reigns Face:3016622929
Ellie Face:3027117721
Chivalrous Knight of the Silver Kingdom Face:2976066765
Overseer: Prophet Face:3030235136
DJ Databaze - Face:3076877056
DJ E-Mosion - Face:3076875377
Battle Ready Kenji Face:3116344124
Druid of the Stag Face:3115551219
Erisyphia - Face:3134826009
Eita the Envious Youkai Face:3210093672
Chichiri the Wise Youkai Face:3210092741
Noriko the Gentle Youkai Face:3210091014
Tycoon Summoner Face:3210504690
Lobster Warrior Grimace:3237756144
Atlantean Warrior Face:3237758757
Fairly Faerie - Face:3064754707
Red Sparkle Time Lobster Person - Face:4018465122
Sharkbait - Face:3064754707
Valorous Knight - Face:3254218159
Prideful Smile:3267472315
Beaming with Pride:3267470325
Champion Of The Tide Face:3234016124
Dr. Fia Tyfoid - Face:3493258178
Sorority Star Face:4019292650
Wicked Webbed Berserker Face:3808073644
Classic Male - Face:3994344171
Classic Female - Face:3994345447
Digital Shock Artist - Face:2924060633
Mr. Toilet - Face:4086501806
Snow Samurai - Face:4417209075
NeoClassic Female v2 - Face:4588499007
Classic Male v2 - Face:4637450017
Classic Female v2 - Face:4586610741
Neoclassic Male v2 - Face:4588498182
Renegade Bounty Hunter Face:4426576622
Tsundere Expression:4895360333
Mixologist's Smile:4895362922
Cheerful Barista Face:4584117070
Paramedic's Face:4584973204
Elegant Evening Dress - Face:4582519378
Biohazard First Responder - Face:4508029059
Frozen Pirate King Xerxes - Face:2623052853
Gold Mermaid Visage:5849008243
Tears of Sorrow:6028824880
Performing Mime:5848997920
Zed Face:5849006088
Glided Diver - Face:2515271103
Irian the Legendary Sorcerer - Face:5579496275
Bubbly Reviewer - Face:6873584508
Cat Mascot - Face:5754100966
Steampunk Inventor - Face:5759199436
Lumber Joe - Face:2827303145
Lumber Jessie - Face:2849500812
Crank and Zap Mech - Face:5885708899
Vans Checkerboard Brown Eyes:8246559242
Rodeo Vampire - Lil Nas X (LNX):5924592609
Smil Nas X - Lil Nas X (LNX):5924588534
Holiday Cheer Toshi - Face:5964850347
Festive Beekeeper - Face:5965061327
Wonder Woman's Golden Armor - Face:6029531141
Award-Winning Smile:6531805594
Sparkling's Friendly Wink:6714123250
Super Pink Heart Makeup:6714740652
Princess Alexis:6714756103
Merciless Ninja - Face:6652963861
Domino Deckard - Face:6653115585
The Engineer - Face:6710820473
Bakonette:7369467011
Persephone's Girl Glam:6792755141
Starry Eyes Sparkling:7370410419
Monster Grumpy Face:7737933327
Mon Cheri Face:7737952495
Isabella:7737963900
Sai-eye Tyler Joseph - Twenty One Pilots:7389895884
Warpaint Josh Dun - Twenty One Pilots:7389918425
Diamond Grill - Lil Nas X (LNX):7657592485
Butterfly Wink - Lil Nas X (LNX):7657640018
Devil Nas X - Lil Nas X (LNX):7657648582
Cat Eye - Zara Larsson:7893435035
Glittering Eye - Zara Larsson:7893438453
Big Grin - Tai Verdes:7987146198
Sunrise Eyes - Tai Verdes:7987150722
Vans Checkerboard Blue Eyes:8246562466
Mermaid Mystique:8664088085
Rainbow Spirit Face:8666737055
Kandi's Sprinkle Face:8666858645
McLaren Smile:9062608001
McLaren Big Grin :9062612645
24kGoldn Face:9156233764
Devilish Smile - 24kGoldn:9156244686
Golden Eyes - 24kGoldn:9156248239
Red Lip - Tate McRae:9650705589
zOMG Hat Selling!:16413448
Rudolph:19397593
Eyes of Everfrost:22972635
ROBLOX Madness Face:129900258
Purple Alien:324192486
Heart Gaze - Zara Larsson:7893441222
Snowflake Eyes:84263778542721
Red Tango:629930519
Jungle Commando:16678109
Red Fang:16722374
Sapphire Drool:16723441
Ochre Ogre:16723395
Eyes of Azurewrath:629947734
Bubble Trouble:19264782
Pieface Jellyfreckles:19382647
Snowman Face:19396549
Prankster:20052028
Bandage:20418584
Optimist:21024598
Embarrassed:21272940
Clown School Dropout:21392803
The First Time I Ever Played ROBLOX...:22070531
Winter:22587827
Troublemaker:22920500
Surprise!:23261768
Mick McCann:23999943
Paintball Enthusiast:23310996
Clown Face:23644832
Zip It!:24125997
Camoface:24441824
Butterfly:24727888
Where are the eggs?:24975243
Emperor:629917700
Freckled Cheeks:25555431
Sophisticated Spectacles:25930455
Bling:25975157
Yum!:26018945
Tattletale:26343132
It's so beautiful!:26674356
Seeing Stars:27599799
Trance:29109680
Imagine:30394315
Facepalm:30394593
Mr. Bubbles:31615924
The Dog Whisperer:34764373
Angelic:45083898
Crimson Laser Vision:45514494
Eyes of Crimsonwrath:49493144
Grandma's Lipstick:51241479
Country Morning:51241521
Golden Shiny Teeth:66319713
Emerald Ambassador:66329462
Derp Face:508486545
Green-eyed Awesome Face:66329597
Emerald Laser Vision:66329642
Not So Friendly Eviscerator:66329683
Golden Lightning Speaker:66329737
Red RAWR:66329788
Egg on your Face:108213708
Evil Skeptic :110287983
Rosey Smile :658751484
Punk Face:119768621
Blue Starface :119772974
Green Starface :119773049
Purple Starface :119773113
Beast Mode:127959433
Fawkes Face:133867453
Crimson Starface:162185411
Orange Starface:162185335
Yellow Starface:162185210
Red Glowing Eyes:179693472
Sapphire Laser Vision:508487599
Eyes of Emeraldwrath:508398801
Blizzard Beast Mode:209712379
Egg Crazed:233240646
Purple Butterfly Smile:240961696
Blue Trance:260296642
Sad Clown:629934434
Green Trance:260296789
Purple Trance:629935400
Mildly Irritated Face:280987977
Daring Blonde Beard Face:324190505
Green Super Happy Joy:324189860
Desert Commando:323188972
Green Whatchoo Talkin' Bout:629936597
Blue Eyeroll:324191500
Pink Shades McCool:324191930
Blue Bubble Trouble:330393309
Miss Scarlet:334655813
Sneaky Green-Eyed Snake:334655587
Teal Rock Star Smile:334655293
True Love Smile:362047893
Eyes of Everflame:362046854
Violet Fang:362047042
Purple Bubble Trouble:362047189
Red Rock Star Smile:508489686
Really Embarrassed:376785624
Purple Super Happy Joy:376786318
Green Bubble Trouble:380753459
Monarch Butterfly Smile :383607989
Silver Punk Face:387256104
Green Glowing Eyes:398676207
Bacon Face:645438093
Friendly Trusting Smile:402301113
Red Serious Scar Face:405704912
Gritty Bombo:405704563
Green Drool Angry Zombie:629946036
Yellow Glowing Eyes:416830979
Pink Galaxy Gaze:440737960
Purple Galaxy Gaze:440738083
Blue Galaxy Gaze:440737549
Green Galaxy Gaze:440737812
Red White and Starface:445110839
Super Super Happy Face:494290547
Serious Red Eye Scar:494290010
Crazybot 10000:554651972
Madbot 10000:554654683
Cuckookrazybot 10000:554655304
Manicbot 10000:554654979
Blue Wistful Wink:583712942
Purple Wistful Wink:583713594
Green Wistful Wink:583713423
Green Amazeface:835059826
Blue Amazeface:835057164
Lavender Amazeface:835060246
Rose Amazeface:835060009
Crimson Evil Eye:1016178220
Sapphire Evil Eye:1016178981
Emerald Evil Eye:1016179764
Golden Evil Eye:1016180707
Red Goof :1191121968
Golden Bling Braces:1191124133
Blue Goof:1191123763
Green Goof :1191123237
Catching Snowflakes:1213444061
Blue Rock Star Smile:1428314296
Teal Mermaid Queen:1428397734
Pink Mermaid Princess:1428315155
Purple Mermaid Princess:1428396343
Blue Ultimate Dragon Face:1772533846
Red Ultimate Dragon Face:1772543614
Green Ultimate Dragon Face:1772542456
Green Starry Sight:2222769550
Blue Starry Sight:2222768690
Violet Starry Sight:2222770385
Radioactive Beast Mode:2225757922
Playful Vampire:2409281591
So Super Excited - Pink:2568608091
So Super Excited - Purple:2568605832
So Super Excited - Blue:2568609094
Snow Queen Smile:2568579815
Absolutely Shocked:2620488318
Crybaby:2620487058
Torque the Red Orc:2830472766
Torque the Blue Orc:2830474424
Torque the Green Orc:2830473786
Emerald Archfey Visage:2830481956
Sapphire Archfey Visage:2830481528
Ruby Archfey Visage:2830482465
Orange Trance:260296899
Evil Skeptic Face:110287983
```
