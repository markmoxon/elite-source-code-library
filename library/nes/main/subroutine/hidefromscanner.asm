\ ******************************************************************************
\
\       Name: HideFromScanner
\       Type: Subroutine
\   Category: Dashboard
\    Summary: Hide the current ship from the scanner
\
\ ******************************************************************************

.HideFromScanner

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDX INWK+33            \ Set X to the number of the current ship on the
                        \ scanner, which is in ship data byte #33

 BEQ hide2              \ If byte #33 for the current ship is zero, then the
                        \ ship doesn't appear on the scanner, so jump to hide2
                        \ to return from the subroutine as there is nothing to
                        \ hide

 LDA #0                 \ Otherwise we need to hide this ship, so we start by
 STA scannerNumber,X    \ zeroing the scannerNumber entry for ship number X, so
                        \ it no longer has an allocated scanner number

                        \ We now hide the three sprites used to show this ship
                        \ on the scanner
                        \
                        \ There are four data bytes for each sprite in the
                        \ sprite buffer, and there are three sprites used to
                        \ display each ship on the scanner, so we start by
                        \ calculating the offset of the sprite data for this
                        \ ship's scanner sprites

 TXA                    \ Set X = (X * 2 + X) * 4
 ASL A                  \       = (3 * X) * 4
 ADC INWK+33            \
 ASL A                  \ So X is the index of the sprite buffer data for the
 ASL A                  \ three sprites for ship number X on the scanner
 TAX

 LDA QQ11               \ If this is not the space view, jump to hide1 as the
 BNE hide1              \ dashboard is only shown in the space view

 LDA #240               \ Set A to the y-coordinate that's just below the bottom
                        \ of the screen, so we can hide the required sprites by
                        \ moving them off-screen

 STA ySprite11,X        \ Hide the three scanner sprites for ship number X, so
 STA ySprite12,X        \ the current ship is no longer shown on the scanner
 STA ySprite13,X        \ (the first ship on the scanner, ship number 1, uses
                        \ the three sprites at 14, 15 and 16 in the buffer, and
                        \ each sprite has four bytes in the buffer, so we can
                        \ get the sprite numbers by adding X, which contains the
                        \ offset within the sprite buffer, to the addresses of
                        \ sprites 11, 12 and 13)

.hide1

 LDA #0                 \ Zero the current ship's byte #33 in INWK, so that it
 STA INWK+33            \ no longer has a ship number on the scanner (a non-zero
                        \ byte #33 represents the ship's number on the scanner,
                        \ but a ship number of zero indicates that the ship is
                        \ not shown on the scanner)

.hide2

 RTS                    \ Return from the subroutine

