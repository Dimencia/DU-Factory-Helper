## We now have a [Discord](https://discord.gg/sRaqzmS)!  

We have tons of code snippets, help channels, a github feed, and we focus on everything LUA and open source.  It's also a centralized place to get tech support: https://discord.gg/sRaqzmS

We've also just added a lua-commissions channel!  Non-scripters can post requests here, and scripters can freelance those requests for pay (or not)

We're also recruting for our in-game lua-focused org (with a bit of PVP focus on the side).  Check the discord for details

# DU-Factory-Helper

This allows you to order on-demand from up to 100 industry units on a single screen.  This will not allow you to change the recipes on industry - it will require a dedicated Assembler set to each recipe you want to be able to print.  

Each json file goes on a separate programming board.

ProductionMaster - Handles screen control and display

ProductionWorker - Handles connections to industry units and printing

ProductionTimeScreen - Handles display and parsing of queue information

![Example](/FactoryPrinterExample.png)


# To Use

There's some setup with these.

Before we start, let's go over some expectations.  *This will not yet create intermediates* - it assumes you have Maintain setup for anything like screws, etc.  It can't change a recipe on a machine.  It doesn't move ore or actually do anything except click the 'Start' button on the assemblers you connect (and sets the quantity) - *you need to already have all the resources for it available*.  It's meant to be used on large-scale factories that have dedicated assemblers for any given element.  

It can queue your items, but someone must activate a board in order to begin the next item in queue.  It is recommended to use a large detection zone so that all users of the factory can keep things queueing.  You may need to micromanage to avoid CPU overloads on larger factories - avoid having all PBs active at once, place detection zones carefully so that people who are crafting on the screen are not also running all of the WorkerBoards (they should just be running the WorkerBoards for the Master they're using, if using a Master, which is intensive)

In our case we've got pressure plates and OR gates, and a detection zone that covers the entrance but not the pressure plates.  So users who are using the screens are only triggering the pressure plates, and users who aren't at the screens are triggering all of the WorkerBoards to keep queues working.

It is still in development and there might be some weird things, but it seems good so far.

## Requirements

You will need one prog board for the Master, one prog board for the TimeScreen, one databank, and one prog board for each Worker (each Worker can control up to 10 industries).  The industries, of course, cannot have their recipes changed by LUA - you'll need one industry unit for each thing you want to be able to print.  You'll need a screen to control it all from, and one screen for the TimeScreen to display queue information.  You'll need proximity sensors.

Connect one screen to the Master board, and one to the TimeScreen board.  Connect the same databank to all boards.  You may use multiple Master boards to categorize, each with their own dedicated databank and Worker boards.  If you do this, connect each databank to the TimeScreen board.  

## Install Scripts

Copy the contents of each .json file above and paste them into a programming board each.  Link the boards - Core to Master/Worker, one screen each to Master/TimeScreen, databank to Master/TimeScreen/Worker, and industry units to Worker.  Slot names shouldn't matter.  

Continue to setup the recipes

## Setup Worker Boards

On each Worker Board, edit the lua and go into unit -> start().  At the top you'll see *Assemblies = ...* and a few example lines.  Edit these as appropriate.  For example, the default line of *recipe="Laser Thermic Ammo XS",machine=slot3* is a way to identify that the industry on slot3 crafts Laser Thermic Ammo XS.  

### There is a database of all items in the main board's System Start, you can use this as a reference to make sure the names are correct 
(just Ctrl+F and search for the recipe you want in an external text editor)

If the names don't match exactly, you will get script errors

This is easiest to do if you connect one industry at a time, then go label what that industry does, otherwise you may mix up which industry is in which slot.  The slot names can be anything you want, as long as they are correct in the table

## Setup Main Board

On the main board, edit the lua and go into system -> start().  At the top you'll see *CraftableItems = { "Laser Thermic Ammo XS", "Laser Electromagnetic Ammo XS" }*.  Edit this to be a list of all the items you've setup on your WorkerBoards.

You also have *Description = ...*.  This will be the title displayed on the screen


## Caveats

If you have multiple assemblies crafting the same item, you must put them all on the same WorkerBoard.  Times should be calculated accordingly with multiple assemblies crafting.  Times do not include any talents.

There is currently a race-condition that if someone queues an item to craft exactly when an item finishes crafting, it will not show up on the board (but will still craft)

## Features

Allows connecting multiple assemblies with the same recipe.  It will load-balance if multiple machines are available and a multiple-quantity craft is started

If no machines are available, it will leave the command in the queue and will start crafting as soon as a machine becomes available to craft it

Shows time remaining to craft (in minutes until the screen flicker issue is fixed)

Highlights your name on the queue board (whoever is running the programming board)

### Planned

Ore enforcement - for use in an org, enforce that users insert the correct ores and amounts before it allows them to print

Output enforcement - keep output behind a door that only opens when someone who has a queued item comes near it.  Monitor the output containers for the volume/mass removed.  Use a prox sensor to detect who is inside, and if more is removed than should have been.  Consider locking doors until they put back anything extra they took

Warnings/Statuses - warn the user if the machine is jammed or ingredients are missing, etc
