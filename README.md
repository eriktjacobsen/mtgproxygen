mtgproxygen
===========

Generates 8.5 x 11 sheets of proxy cards from deck definition, suitable for printing. 
I use fedex online, comes to about $1.40 per sheet for 110lb index stock.
60 cards requires 7 sheets, if you are printing lands.

Usage: proxygen.pl \<deck-file\>

The deck-file should be in the format of "count CardName":
```
4 Evolving Wilds
9 Mountain
8 Island
3 Altar of the Lost
4 Burning Vengeance
4 Think Twice
```

This creates a deckNN folder, pulls the source images, and then creates multiple sheetNN.jpg images for printing.
Each deck (source and sheets) are created in a new incremented directory.

Source images are pulled from http://mtgimage.com/

Requires Image Magick to be installed, the "convert" and "montage" executables are used. 
