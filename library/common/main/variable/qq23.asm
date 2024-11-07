\ ******************************************************************************
\
\       Name: QQ23
\       Type: Variable
\   Category: Market
\    Summary: Market prices table
\
\ ------------------------------------------------------------------------------
\
\ Each item has four bytes of data, like this:
\
\   Byte #0 = Base price
\   Byte #1 = Economic factor in bits 0-4, with the sign in bit 7
\             Unit in bits 5-6
\   Byte #2 = Base quantity
\   Byte #3 = Mask to control price fluctuations
\
\ To make it easier for humans to follow, we've defined a macro called ITEM
\ that takes the following arguments and builds the four bytes for us:
\
\   ITEM base price, economic factor, units, base quantity, mask
\
\ So for food, we have the following:
\
\   * Base price = 19
\   * Economic factor = -2
\   * Unit = tonnes
\   * Base quantity = 6
\   * Mask = %00000001
\
\ ******************************************************************************

.QQ23

 ITEM 19,  -2, 't',   6, %00000001  \  0 = Food
 ITEM 20,  -1, 't',  10, %00000011  \  1 = Textiles
 ITEM 65,  -3, 't',   2, %00000111  \  2 = Radioactives
IF NOT(_NES_VERSION)
 ITEM 40,  -5, 't', 226, %00011111  \  3 = Slaves
 ITEM 83,  -5, 't', 251, %00001111  \  4 = Liquor/Wines
ELIF _NES_VERSION
 ITEM 40,  -5, 't', 226, %00011111  \  3 = Robot Slaves (Slaves in original)
 ITEM 83,  -5, 't', 251, %00001111  \  4 = Beverages (Liquor/Wines in original)
ENDIF
 ITEM 196,  8, 't',  54, %00000011  \  5 = Luxuries
IF NOT(_NES_VERSION)
 ITEM 235, 29, 't',   8, %01111000  \  6 = Narcotics
ELIF _NES_VERSION
 ITEM 235, 29, 't',   8, %01111000  \  6 = Rare Species (Narcotics in original)
ENDIF
 ITEM 154, 14, 't',  56, %00000011  \  7 = Computers
 ITEM 117,  6, 't',  40, %00000111  \  8 = Machinery
 ITEM 78,   1, 't',  17, %00011111  \  9 = Alloys
 ITEM 124, 13, 't',  29, %00000111  \ 10 = Firearms
 ITEM 176, -9, 't', 220, %00111111  \ 11 = Furs
 ITEM 32,  -1, 't',  53, %00000011  \ 12 = Minerals
 ITEM 97,  -1, 'k',  66, %00000111  \ 13 = Gold
IF _6502SP_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION \ Comment

\EQUD &360A118          \ This data is commented out in the original source

ENDIF
 ITEM 171, -2, 'k',  55, %00011111  \ 14 = Platinum
 ITEM 45,  -1, 'g', 250, %00001111  \ 15 = Gem-Stones
 ITEM 53,  15, 't', 192, %00000111  \ 16 = Alien items

