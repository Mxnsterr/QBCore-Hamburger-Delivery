# Custom Qbus Hamburger Delivery Job

Dit is een custom job die gemaakt is voor het Qbus Framework. Je neemt de job in het gemeentehuis en dan zie je op de map verschijnen waar je moet zijn! Daar kan je dan een Hamburger Auto nemen waarvoor je €500 borg moet betalen. Deze wordt als je genoeg cash hebt, cash van je afgenomen. En als je niet genoeg cash hebt dan gaat het van je bankrekening. De borg wordt terugbetaalt bij het succesvol terugbrengen van de bedrijfswagen :)

## Installatie

Download de folder als zip, hierin zit het job script, de map van het bedrijf en een Hamburger Auto. Zet deze alle 3 in je resources en navigeer dan naar je `resources.cfg` daarin zet je het volgende:

```bash
start hamburger
start mimisburger 
start YourPrefix-hamburger (Verander 'YourPrefix' naar jouw resource prefix (qb- of rs- of hp-,...)
```

## Aanpassingen YourPrefix-hamburger

In `YourPrefix-hamburger` kan je als je Visual Studio Code hebt als editor `CTRL + F` doen en dan kan je 
alle plekken waar `YourCore` en `YourPrefix-` staat aanpassen naar jouw eigen **Core** *(QBCore, RSCore, HPCore)* en **resources prefix** *(qb- , rs-, hp-)*


## Aanpassingen aan je Core

Voeg volgende code toe aan je shared.lua in de core (kan zelf **label** en **payment** van de job aanpassen) ⚠**PAS "hambuger" NIET AAN ZONDER DIT OOK IN DE FILES AAN TE PASSEN**
```bash
["hamburger"] = {
		label = "Hamburger Delivery",
		payment = 50,
		defaultDuty = true,
	},
```

## Eigen locaties en/of auto
Locaties kan je aanpassen in `config.lua` bij **Config.Locaties** en de auto ook in de `config.lua` helemaal onderaan bij **Config.Wagen** 
(let op dat dit ofwel een GTA auto is ofwel een dat in je server zit) 

## Toevoegen aan gemeentehuis
Je moet de job in het jobmenu aan het gemeentehuis toevoegen, kijk naar hoe ze dit doen voor andere jobs. De resource noemt `YourPrefix-cityhall` *YourPrefix =(qb-, rs-, hp-)*

## Dependencies
- Qbus core
- Qbus Progressbars
- Qbus Police
- Qbus Animations
- Qbus Vehiclekeys
- LegacyFuel
- Mimi's Burger *(niet door mij gemaakt)*
- Burger auto *(niet door mij gemaakt)*
