# DU-Factory-Helper
Factory Helper - Calculates base ore costs for any printable element

Industry Printer - Main controller unit for a centralized printing interface

Industry Slave - Slave unit for connecting to Industry to print on demand

![Example](/FactoryPrinterExample.png)

## To Use - Factory Helper
Copy the contents of the FactoryHelper.json file above and right click your programming board -> Advanced -> Paste Lua Configuration from Clipboard

You need a single screen connected to the programming board (and the core of course)

## To Use - Industry Printer
There's some setup with these.  And overall I don't think the JSON pastes are great because they may result in problems with your component names, but here goes

You will need one Prog board for the printer, one databank, and one prog board for each slave (each slave can control up to 9 industries).  The industries, of course, cannot have their recipes changed by LUA - you'll need one industry unit for each thing you want to be able to print.  You'll need a screen to control it all from

Connect the screen and databank (and core) to the primary Prog Board.  Make sure the names of the connections are correct, 'screen' and 'databank' where appropriate.

Connect the databank to each of your slave boards.

### Setup slave boards

On each slave board, edit the lua and go into unit -> start().  At the top you'll see *Assemblies = ...* and a few example lines.  Edit these as appropriate.  For example, the default line of *recipe="Freight Space Engine L",machine=slot1* is a way to identify that the industry on slot1 craft Freight Space Engine L.  There is a database of all items in the main board's System Start, you can use this as a reference to make sure the names are correct (just Ctrl+F and search for the recipe you want in an external text editor)

This is easiest to do if you connect one industry at a time, then go label what that industry does, otherwise you may mix up which industry is in which slot.  The slot names can be anything you want, just put the correct slot name to that machine in there (just like in the example, without quotes)

### Setup main board

On the main board, edit the lua and go into system -> start().  At the top you'll see *CraftableItems = { "Square Carpet", "Freight Space Engine S" }*.  Edit this to be a list of all the items you've setup on your slave boards.


## Caveats

This is still WIP and the buttons can be a little weird for very small lists of craftable items.  I had a really weird issue with the page down button, so if it's off by 20 pixels or so, let me know.  
