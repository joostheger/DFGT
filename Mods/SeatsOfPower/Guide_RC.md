# Raider Clans Guide #
*Raider Clans* is part of *Seats of Power*: a collection of additional dwarven government types. (no DFHack required)

## General features ##
Main features (see below for details):
* **A tribal society that survives through raiding** and pillaging neighboring settlements..
* **A council of elders** advises an elected chieftain.
* **Familiar clan structures;** many of the leadership positions are succeeded by heirs.
* **Lack of farming and fishing industry;** forcing the clan to rely on raiding, hunting and gathering.
* **Emerging feudal hierarchy;** no king or queen exists initially; authority rises through the landholder-chain to eventually establish a Raider King or Queen.

Raider Clans are Norse-inspired warband societies. A single hall is led by an elected Chieftain, advised by a council of Elders, a Lawspeaker who keeps the clan's unwritten law, a Volva who tends its spiritual life, a Reeve who manages its wealth, and a Clanspeaker who treats with outsiders. As a clan's raids succeed and territory is seized, its leadership can rise through a ladder of land-holder titles — Earl, High Earl, King, High King — culminating in a *Raider King or Queen* who rules the plunder-forged kingdom.

The clans inhabit the cold tundra and taiga biomes, relying on raiding, herding, and hunting rather than farming or fishing. They make clothing from leather and brew alcohol from gathered wild fruits and underground fungi. Though less agriculturally developed than their mountain-dwelling kin, they are equally skilled in building and crafts, such as metalworking and woodworking.

### Challenge level: 4/5 ###
The Raider Clans present a challenging playstyle due to their reliance on raiding and limited self-sufficiency. Players must carefully balance raiding, diplomacy and livestock management to ensure the clan's survival and growth.

Harder than vanilla :
* No farming or fishing industry; No such products available to trade within their own civilization.
* Raiding causes neighboring settlements to become hostile.
* Limited control over most noble positions; these roles are often inherited or influenced by clan traditions rather than direct player choice.
* Only one position for handling trade, bookkeeping and labour management (Reeve)

Easier than vanilla :
* Nothing really.

## State Summary ##
* **Government type:** Tribal clans, growing into a feudal hierarchy.
* **Head of state:** None, until a Raider King emerges. 
* **Government structure:** A loose confederation of independent clans centered around an elected Chieftain. The Lawspeaker and Clanspeaker represent the legal and diplomatic interests of the clans.
* **Territorial setup:** Cold biomes such as tundra and taiga, from where the clans launch their raids.
* **Defining concept:** A society based on raiding, loosely inspired by Norse culture. 
* **Foreign relations:** Grim.
* **Society and culture:** TODO: Warlike and tradition-light; family, loyalty, truth, craftsmanship, and martial prowess are highly valued, while peace, self-control, and tradition rank low. Slavery is shunned, but killing enemies and raiding are accepted parts of life.
no currency.

[RELIGION_SPHERE:VALOR]
	[RELIGION_SPHERE:HUNTING]
	[RELIGION_SPHERE:LAWS]
	[RELIGION_SPHERE:FAMILY]

## Play Guide ##
### Economy ###
* **Farming and plant-based clothing:** *Planter* and *Thresher* are disabled, while plant *gathering* remains available for brewing booze, which is otherwise unreliable to obtain through raids. 
* **Clothing:** Raiding is one source of obtaining garments, but leatherworking is also been kept available as alternative means of producing clothing.
* **Livestock:** Common domesticated animals are unavailable at embark and cannot be traded for, but you can obtain them through trapping (or raiding), then keep and breed them. (so no cats and dogs either)
* **Fishing:** *Fisherman* and *Fish Cleaner* are disabled to make food less readily available and give raiding a stronger role in the economy; 
* **Hunting and trapping:** Both jobs remain available as additional ways to find food and animals.
* Make sure to **raid for livestock** and keep and breed them, as this gives you a renewable source of meat and leather for your clan.

### The Chieftain and the Council of Elders ###
* The Chieftain is elected (based on tactician and leader qualities) and leads the clan's raids, enforces the law, and sets military strategy. When a Chieftain falls, one of the Captains succeeds him.
* The Elders form a council that grows with the hall's population, scaling from a single elder up to ten elders as the population passes roughly 10, 40, 90, 140, and 190. Elders are elected, inherited by heir, and advise on morale, health, and war.
* TODO: note on the Volva — if a female is chosen as elder, she is intended to automatically become Volva; needs testing to confirm this works reliably over multiple elections.

### Law, Wealth, and Diplomacy ###
* The Lawspeaker recites the clan's unwritten law from memory and judges disputes; the role is drawn from, and appointed by, the currently active Elder position.
* The Reeve, appointed by the Chieftain, manages trade, taxes, herds, and production.
* The Clanspeaker, appointed by the Elder council, handles peace agreements, introductions, trade agreements, and receiving diplomats on the clan's behalf.
* The Hammerer, appointed by the Chieftain and succeeded by heir, carries out the clan's harshest sentences.

### Raiding and Conquest ###
* Captains, appointed by the Chieftain, each lead a squad of ten warriors on raids.
* A Captain left in command of a conquered hold becomes a local governor, judging disputes and treating with envoys in the Chieftain's stead.
* TODO: describe how a hall's growth translates into the land-holder ladder in practice.

### The Land-Holder Ladder ###
* As a clan's conquests grow, its ruling line is appointed through the civilization-level Lawspeaker and rises through five tiers: Earl (1 land) → High Earl (2 lands) → King (3 lands) → High King (4 lands) → Raider King/Queen (5 lands).
* Each tier is hereditary (succession by heir) and carries law-making and diplomatic authority, plus steadily increasing trappings of rule (special burial, exemption from menial work and punishment, and ever-larger housing/office requirements).
* The Raider King or Queen is the clan's supreme authority — "feared across the seas" — but TODO: confirm this position is not filled during world-generation or automated world simulation, only through actual play/conquest.

### Other notes ###
* No DFHack is required.
* Dwarf-only entity; works with vanilla dwarves.
* Compatibility with other mods is assumed, not guaranteed.

### Starting a new fortress ###
* To find a location for your new fortress, consider the availability of raidable neighboring settlements.
* Consider the terrain and natural defenses of potential sites, as raiding causes retaliation.
* Find a location that has enough plant life to support gathering for brewing.
TODO: fill in once tested — which positions (if any) are available at embark, and what triggers the first elections/appointments.

## Government structure ##
**The Chieftain** is the head of a single hall. Elected for cunning, courage, and leadership, the Chieftain leads the clan's raids, enforces the law, sets military strategy, and commands a squad of ten retainers as well as all Captains. When the Chieftain falls, succession passes to one of the Captains.

**The Council of Elders** (ELDER_0 through ELDER_5) advises the Chieftain and scales directly with the hall's population — starting at a single elder and growing to ten elders as the hall passes roughly 10, 40, 90, 140, and 190 population. Elders are elected and succeed by heir; they handle morale, health, military goals, and receiving diplomats.

**The Lawspeaker** recites the clan's unwritten law from memory and judges its disputes. The position is filled from among the sitting Elders and is appointed by (and succeeds through) whichever Elder tier is currently active. A civilization-level counterpart, the **Lawspeaker (Civ)**, mirrors this role for the wider clan federation and is succeeded by the **Elder (Civ)** rather than appointed.

**The Volva** is the clan's seer and spiritual guide — a female-only position chosen from the circle of Elders. She tends the clan's spirit, reads omens, roots out treachery, counsels the elders, and is honored even in death with a special burial. TODO: confirm the intended mechanic by which a female Elder automatically becomes Volva.

**The Reeve** manages the hall's wealth — trade, tribute, herds, and craft — appointed by the Chieftain to keep the hall fed and its coffers full between raids.

**The Clanspeaker** treats with outsiders on the clan's behalf, forging peace, trade, and alliance where blades might otherwise answer. Appointed by the Elder council.

**The Hammerer** carries out the clan's harshest sentences with a single blow, appointed by the Chieftain; the role is traditionally passed down to the Hammerer's heir.

**Captains** ride beside the Chieftain on every raid, seizing plunder for the clan. Each commands a squad of ten warriors, and by tradition their heir succeeds them should they fall in battle. A **Captain (Conquered Site)** is left in command of a conquered hold, ruling in the Chieftain's stead: judging disputes, treating with envoys, and binding the hold's inhabitants to raider law.

**The Land-Holder Ladder** tracks a clan's rise through conquest, each tier appointed via the Lawspeaker (Civ) and inherited by heir:
- An **Earl/Earless** (LH1) holds an earldom — land and tribute beyond a single hall, drawing raiders hungry for plunder and glory.
- A **High Earl/High Earless** (LH2) holds dominion over several earldoms, won by raid and ruled by right of arms.
- A **King/Queen** (LH3) rules where raiding has forged a true realm from scattered halls — a seat of law, tribute, and war for all beneath the banner.
- A **High King/High Queen** (LH4) commands a realm forged from a lifetime of raids and sworn loyalties, to whom lesser earls and kings bend the knee.
- A **Raider King/Queen** (LH5), at the height of conquest, rules a kingdom carved from plunder and war — feared across the seas, their word is law wherever their banners fly.

## Lore ##
Urim Urist was the first of the Raider Kings. Ages ago, Urim led his people as they emerged from the mountains to dwell in these harsh but breathtaking lands. He did so with strength and cunning, uniting scattered clans under his banner and forging a legacy of conquest and raiding that would shape the future of the realm. 
Now, his story is over and his legacy lives on through you, chieftains of your clan, to follow in his footsteps, continuing the cycle of conquest and raiding that he began. For the last few generations, the raiding has halted, letting the lands beyond restore themselves. Now those lands are ripe for the taking, their people tend their fields in blissful ignorance, gathering what they cannot defend and shall not enjoy. It is your turn to take up the mantle and lead your clan to glory once more.

## My personal opinion ##
I enjoyed writing this entity because it offers a distinctive challenge and encourages players to build their strategy around raiding. Using job restricting mechanics to reinforces that focus, makes the challenge feel more tangible and immersive, rather than just self-implied. 
The clan structure lets me explore inheritance and succession. Although its noble system is relatively simple, it still feels distinct enought from the other government types so that it deserves its own place in the pack. 
I experimented with more Viking-inspired terminology, but kept only *Volva*: I wanted to leave players enought room for their imagination.
