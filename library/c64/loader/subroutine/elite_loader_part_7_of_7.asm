\ ******************************************************************************
\
\       Name: Elite loader (Part 7 of 7)
\       Type: Subroutine
\   Category: Loader
\    Summary: Set up the sprite pointers, make a copy of the dashboard bitmap in
\             DSTORE% and copy the sprite definitions to SPRITELOC%
\  Deep dive: Sprite usage in Commodore 64 Elite
\
\ ******************************************************************************

                        \ We now set the sprite pointers to point to the sprite
                        \ definitions (the sprites themselves are defined in
                        \ elite-sprite.asm)

 LDA #SPOFF%            \ The first sprite definition at offset SPOFF% contains
                        \ the sights for the pulse laser, so we start by setting
                        \ Y to the sprite pointer for the first sprite, which is
                        \ for the pulse laser (the sprites are defined in
                        \ elite-sprite.asm)

 STA &63F8              \ Set the pointer for sprite 0 in the text view to A
                        \
                        \ The sprite pointer for sprite 0 is at &63F8 for the
                        \ text view because screen RAM for the text view is
                        \ at &6000 to &63FF, and the sprite pointers always
                        \ live in the last eight bytes of screen RAM, so that's
                        \ from &63F8 to &63FF for sprites 0 to 7

 STA &67F8              \ Set the pointer for sprite 0 in the space view to A
                        \
                        \ The sprite pointer for sprite 0 is at &67F8 for the
                        \ space view because screen RAM for the space view is
                        \ at &6400 to &67FF, and the sprite pointers always
                        \ live in the last eight bytes of screen RAM, so that's
                        \ from &67F8 to &67FF for sprites 0 to 7

                        \ Next we set the sprite pointer for the explosion
                        \ sprite in sprite 1

 LDA #SPOFF%+4          \ There are four laser sight sprite definitions, so to
                        \ get the offset of the fifth sprite definition, for
                        \ the explosion sprite, we need to set A to the sprite
                        \ offset plus 4 (as each increment in the pointer adds
                        \ 64 bytes to the address, or one sprite definition)

 STA &63F9              \ Set the pointer for sprite 1 in the text view to A

 STA &67F9              \ Set the pointer for sprite 1 in the space view to A

                        \ Next we set the sprite pointers for the Trumbles in
                        \ sprites 2, 4 and 6, so they all look to the right

 LDA #SPOFF%+5          \ Set A to the sprite pointer for the sixth sprite
                        \ definition (i.e. the first Trumble sprite, which
                        \ looks to the right)

 STA &63FA              \ Set the pointer for sprite 2 in the text view to A

 STA &67FA              \ Set the pointer for sprite 2 in the space view to A

 STA &63FC              \ Set the pointer for sprite 4 in the text view to A

 STA &67FC              \ Set the pointer for sprite 4 in the space view to A

 STA &63FE              \ Set the pointer for sprite 6 in the text view to A

 STA &67FE              \ Set the pointer for sprite 6 in the space view to A

                        \ And finally we set the sprite pointers for Trumble
                        \ sprites 3, 5 and 7, so they all look to the left

 LDA #SPOFF%+6          \ Set A to the sprite pointer for the seventh sprite
                        \ definition (i.e. the second Trumble sprite, which
                        \ looks to the left)

 STA &63FB              \ Set the pointer for sprite 3 in the text view to A

 STA &67FB              \ Set the pointer for sprite 3 in the space view to A

 STA &63FD              \ Set the pointer for sprite 5 in the text view to A

 STA &67FD              \ Set the pointer for sprite 5 in the space view to A

 STA &63FF              \ Set the pointer for sprite 7 in the text view to A

 STA &67FF              \ Set the pointer for sprite 7 in the space view to A

 LDA L1                 \ Set bits 0 to 2 of the 6510 port register at location
 AND #%11111000         \ L1 to %110 to set the input/output port to the
 ORA #%00000110         \ following:
 STA L1                 \
                        \   * LORAM = 0
                        \   * HIRAM = 1
                        \   * CHAREN = 1
                        \
                        \ This sets the entire 64K memory map to RAM except for
                        \ the I/O memory map at $D000-$DFFF, which gets mapped
                        \ to registers in the VIC-II video controller chip, the
                        \ SID sound chip, the two CIA I/O chips, and so on, and
                        \ $E000-$FFFF, which gets mapped to the Kernal ROM
                        \
                        \ See the memory map at the bottom of page 264 in the
                        \ "Commodore 64 Programmer's Reference Guide", published
                        \ by Commodore
 CLI                    \ Allow interrupts again

 LDX #9                 \ Set X = &16 so we copy 9 pages of data from DIALS
                        \ into DSTORE%

 LDA #LO(DSTORE%)       \ Set ZP(1 0) = DSTORE%
 STA ZP
 LDA #HI(DSTORE%)
 STA ZP+1

 LDA #LO(DIALS)         \ Set (A ZP2) = DIALS
 STA ZP2
 LDA #HI(DIALS)

 JSR mvblock            \ Call mvblock to copy 9 pages of data from DIALS to
                        \ DSTORE%, so this makes a copy of the dashboard bitmap
                        \ that can be poked into screen memory when the
                        \ dashboard needs to be redrawn (when changing from a
                        \ text view to the space view, for example)

 LDY #0                 \ Finally, we copy two pages of sprite definitions from
                        \ spritp to SPRITELOC%, which is where the game expects
                        \ to find them

.LOOP12

 LDA spritp,Y           \ Copy the Y-th byte of the sprite definitions at spritp
 STA SPRITELOC%,Y       \ to the Y-th byte of SPRITELOC%

 DEY                    \ Decrement the byte counter

 BNE LOOP12             \ Loop back until we have copied a whole page of bytes

.LOOP13

 LDA spritp+&100,Y      \ Copy the Y-th byte of the second page of sprite
 STA SPRITELOC%+&100,Y  \ definitions at spritp + &100 into SPRITELOC%

 DEY                    \ Decrement the byte counter

 BNE LOOP13             \ Loop back until we have copied a second page of bytes

 JMP &CE0E              \ This loader was originally run from the GMA1 disk
                        \ loader, which set a return address in &CE0E before
                        \ running the above
                        \
                        \ This therefore returns us to the GMA1 loader, so it
                        \ can load the game binary and finally run the game

