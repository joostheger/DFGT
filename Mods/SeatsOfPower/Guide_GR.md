# Grand Republic Guide #
*Grand Republic* is part of *Seats of Power*: a collection of additional dwarven government types.

## General features of Grand Republic ##
Main features:
* **Elite citizenry system**
* **Merchants' Guild rules the republic**

The Grand Republics are peaceful, trade-focused dwarven civilizations built around commerce and cooperation. Towns and hamlets flourish on fertile plains, while nestling at the feet of the mountains that bore their kin. The Merchants' Guild governs the republic and sends their representatives as diplomats across the world. They serve the gods of trade, wealth, and order. 
Their peaceful, conflict-averse nature makes them strong and reliable trading partners. Republican dwarves value competition, hard work, cooperation, and commerce over martial prowess and merriment.

### Challenge level: 4/5 ###
'Grand Republic' is designed to be a challenging experience. 

Harder than vanilla :
* The Citizens increasingly higher demands require continued attention.
* Minimal player agency for who gets a citizen position.
* Lesser military options.
* Certain administrative roles need a minimum population to be available.

Easier than vanilla:
* Trade caravans arrive more frequenty and bring a broader range of goods
* Because of their balanced ethics, they are treated less aggressively by other civilizations.
  
### My personal opinion ###
This is my favorite entity in the collection. Not perse of how it plays, but the burgher system was very fun and challenging to create and it taught me so much about entityes in DF. I'm happy with the intricate system with the helper-positions and the way it makes the system do what I had in mind. I had parts of this created a few years ago, then I throw it all away and started over end 2025. During the process I worte the article on DF Wiki 'Advanced Entity Position Mechanics' containing my findings. I hope this entity is fun to play for you and that the article is useful for other modders.

## Play Guide ##
### Freeholders ###
* The main feature of this mod is the extensive **elite citizenry system**, called *Freeholders*. It gives all 7 starting dwarves a special status with extensive rights and demands. They progress from *settler* to *citizen*, *burgher*, and eventually *patrician*. When they reach certain thresholds, they are promoted automatically. When you receive a succession message, check the nobles screen for new demands.
* When the first promotion has occurred, new migrants will also assume the *settler* status. This is an unsolvable issue in the system, however, these settlers will never be promoted and will not interfere with the citizenry. These positions will be cleaned up eventually. Just lets call it enthusiasm of these newcomers.
* Read the descriptions of the positions for more details of each rank.
* Once they reach a certain status, members of the citizenry can no longer be assigned tasks. They are exempt from menial labor. However, any tasks assigned earlier will continue. It is wise to plan ahead and only assign suitable duties. If they need to craft something, you can use the earlier assigned labor so they remain active when needed.
* If you assign members of the citizenry to other administrative positions, they will lose that position upon promotion. Just reassign if you want to keep them.
* This intricate promotion system has a few drawbacks:
  * Units may receive multiple sequential positions, resulting in multiple succession messages. Their status screen also records the history of these promotion paths.
  * In world generation, this system does not work. To compensate, dedicated positions are included to represent the fortress-mode system at world-gen sites.
  * You also might encounter *(promotion position)*'s in the nobles screen. These are residues from promotions and are cleaned up eventually. They are not functional anymore and should be ignored.
* The *select trader* position is a special case. It is the only position that initially can be assigned to a settler. This can be used to represent the initial selection of a representative of the fortress, but may also be ignored, in which case a random settler will assume this role. Eventually, when you become able to assign a *clerk of stores* this becomes irrelevant.

### Other notes ###
* Clerks can be appointed from certain citizenry ranks for tasks such as trading (*clerk of stores*), management (*clerk of works*), and accounting (*clerk of accounts*). More of these positions unlock as the settlement grows.
* The limited military focus restricts the number of squads and soldiers per squad, but additional options open up as the settlement develops.
* If a diplomat leaves unhappy, it may be one of the two merchant journeymen arriving with the caravan. You likely did not have a *clerk of stores* assigned. Do not worry: the only thing you missed was a supplemental trade negotiation.
* There is a functional noble position called *promotion official*. It has no special features, but it can be used to force evaluation of nobility positions and trigger promotions when applicable. 
* If you want to use the squads of the municipal and republican guards, you have to assign first a civic guard captain or a bailif, to activate that function. 
* Caravans arrive in summer and autumn.
* Production options for clothing and weapons are expanded, and they make use of all crop types.
* Includes custom naming for groups, roads, bridges, and more.
* No DFHack is required.
* Dwarf-only entity; works with vanilla dwarves.
* Compatibity with other mods is assumed, not guaranteed.

### Starting a new fortress ###
* When starting a new fortress, choose a civilization named '... Republic ...' with a 'Grand merchant-master' as its leader.
* On embark, before unpausing, check the nobles screen for the position 'select trader' and read its description.
* Don't worry if vanilla noble positions are missing. As your fortress grows, new positions will open up automatically.

## Government structure ##

The Grand Republic does not merely *have* a Merchants' Guild — it *is* one. The guild and the state are indistinguishable: every executive, judicial, and diplomatic authority flows from the guild's charter, and every administrator sent to a settlement holds their office by guild appointment. There is no separate civic government. There is only the guild, operating at different scales.

**The Grand Merchant-Master** is the figurehead of the republic, an honorary title bestowed on the most distinguished member of the guild's leadership. They hold no executive power, but they command deference as the symbolic head of both guild and state. Succession to the position flows from the four offices of the guild council. When the republic's capital is established, the Grand Merchant-Master becomes the sole authority authorized to appoint the city's executioner.

**The Guild Council** is composed of five elected positions. Together they constitute the true governing body of the republic:

- The **Merchant Master Councillors** (two positions) are the chief decision-makers of the guild. They hold law-making and military authority, issue trade mandates, and appoint every guild administrator sent to the republic's settlements. The entire network of the guild's land-holders answers to them.
- The **Merchant Master Magistrate** is the supreme judicial officer of the guild-state. They oversee law enforcement, espionage, fire and building safety, and adjudicate disputes across the republic. They appoint the Captain-General of the republican military.
- The **Merchant Master Ambassador** is the guild's senior diplomat, responsible for receiving foreign envoys and negotiating peace agreements on behalf of the republic.
- The **Merchant Master Steward** holds the administrative portfolio: tax collection, food supply, construction permits, financial accounting, and the management of the guild council's household.
- 
**The Merchant Journeymen** are the main representatives of the guild, operating across the republic's trade network. Two distinct roles exist: one focused on establishing colony trade agreements and diplomatic introductions, the other additionally responsible for direct trade negotiations and topic agreements. Both oversee the maintenance of the republic's roads, bridges, tunnels, and sewers. Journeymen succeed from the merchant apprentice pool.

**The Merchant Apprentices** are serving the guild council directly. They carry messages, tend the household of guild leadership, and handle the everyday logistics that keep the council operational.

**The Guild's deployed administrators** are the guild's counterpart of land-holders, each appointed by the Merchant Master Councillors. Their appointment designates a settlement's official status and grants them judicial, diplomatic, and construction authority at the local level. As the guild's investment in a settlement grows, the administrator is promoted to a more senior office — and the settlement's charter is upgraded accordingly:

- The **Trade Agent** designates the site as a *chartered trade post*. They hold one mandate and appoint the first clerks.
- The **Trade Administrator** elevates the site to a *chartered market town*, with expanded mandate authority.
- The **Trade Director** elevates the site to a *chartered merchant city*.
- The **Chief Commissioner** elevates the site to a *principal mercantile city*, adding military authority to the portfolio and significantly broader mandate powers.
- The **Grand Commissioner** designates the site as a *citadel of commerce* — the guild's highest-status settlement. Grand Commissioners hold supreme mandate authority over commerce, production, and military expeditions. Multiple instances of this tier exist to accommodate the guild's growing needs without altering the underlying authority.

Succession for all land-holder positions runs through the guild's merchant journeymen when a direct replacement is unavailable.

**Free Merchants** are prominent independent traders recognized at the site level as population thresholds are reached (at 70, 130, and 190 inhabitants). They hold no administrative duties but are identified as pillars of the local commercial community, contributing to civic morale.

**The Clerks** are appointed support staff drawn from the freeholder citizenry at the site level. Three types handle daily administration:

- The **Clerk of Stores** (broker) manages trade and procurement.
- The **Clerk of Works** (manager) oversees production.
- The **Clerk of Accounts** (bookkeeper) maintains financial records.
- The **Clerk of Letters** (messenger) handles inter-settlement correspondence.

**The Military** of the republic operates under a layered command structure. At the civ level, the **Captain-General** — appointed by the Merchant Master Magistrate — commands all captains and holds strategic military authority. They are supported by **Captains**, each leading a squad of eight soldiers responsible for patrolling, escorting tax collectors, and engaging enemies.

At the site level, three guard forces operate under distinct command chains:

- The **Republican Guard** is the republic's professional soldiery, led by a **Republican Guard Captain** (squad of 24), appointed by the Marshal.
- The **Municipal Guard** (squad of 16) is commanded by a **Municipal Guard Captain**, appointed from the burgher class and above.
- The **Civic Guard** (squad of 8) is commanded by a **Civic Guard Captain**, appointed from the citizenry and above.

The **Marshal** is a senior site-level military officer appointed by the patricians of the settlement. They set local military goals, advise leaders, and oversee squad equipment — and appoint the Republican Guard Captain.

The **Bailiff** is the settlement's chief law enforcement officer, commanding two constables and holding responsibility for espionage and law enforcement. Appointment is available to citizens, burghers, land-holders, and patricians.

When the republic's capital is established, the Grand Merchant-Master may appoint one of three **Executioners** — by hammer, axe, or spear — to carry out capital sentences.

In **conquered settlements**, a **Chief Commissioner** is installed by the Merchant Master Councillors as administrator, with law-making, diplomatic, and worker relations authority. An **Inquisitor**, commanding twenty constables, is assigned alongside to root out dissent and enforce the guild's order.

## Lore ##
A small company of settlers stepped onto the land, their names inked on a document that promised more than property. The soil beneath their boots was no longer empty earth. It was the freehold, held together by law, by promise, and by their hands. Every rock they mined, every tool they crafted, was a claim on the future. These settlers were the first freeholders, and in that status lay both their responsibility and their authority.

Commerce stirred almost immediately. Traders arrived with heavy packs and sharper eyes. Deals were struck in the marked square, in the shade of half-built halls, over mugs of ale. Promises had weight. Some merchants faltered; others proved trustworthy. Clerks of stores oversaw goods, clerks of accounts counted coins. Every reliable hand built trust.

Only those descended from, or formally welcomed into, the original freeholders could claim citizenship. Everyone else could trade, prosper, and influence in subtle ways, but the charter marked a boundary: the right to speak, to decide, to govern rested on origin. Citizenship was earned through service, but anchored in lineage. It was when the settlement was amended as chartered trade post that they first earned the right to call themselves Burghers.

Trade agents and administrators stepped forward, appointed by the Merchants' Guild to organize production, enforce rules, and issue mandates. A careful negotiator who resolved a quarrel between neighbors earned a place at council meetings. Homes grew taller, workloads shifted, and the settlement's heartbeat became both commerce and governance.

Even before this city took shape, the Merchants' Guild already held the republic in a firm grip. The merchant masters dictated trade policy, upheld the law, and managed resources, taxes and security. Grand commissioners oversaw entire trade networks, while apprentices learned to support the machinery of the guild. Influence accumulated slowly—through trust kept, disputes settled, promises honored—until reliance hardened into expectation. Yet as this city flourished, the merchant masters' eyes turned increasingly toward the possibility that this place could serve as a potential heart of their trading empire.

By the time the new republican freehold matured, streets thrummed with trade, halls rang with debate, and homes carried the weight of legacy. What began as a simple charter had grown into a living city-state: stratified, disciplined, and confident that the hierarchy reflected both founding right and proven competence. 