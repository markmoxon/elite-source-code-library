\ ******************************************************************************
\
\       Name: SIGHT
\       Type: Subroutine
\   Category: Flight
\    Summary: Draw the laser crosshairs
\
\ ******************************************************************************

.SIGHT

IF _C64_VERSION

 LDA #%101              \ Call SETL1 to set the 6510 input/output port to the
 JSR SETL1              \ following:
                        \
                        \   * LORAM = 1
                        \   * HIRAM = 0
                        \   * CHAREN = 1
                        \
                        \ This sets the entire 64K memory map to RAM except for
                        \ the I/O memory map at $D000-$DFFF, which gets mapped
                        \ to registers in the VIC-II video controller chip, the
                        \ SID sound chip, the two CIA I/O chips, and so on
                        \
                        \ See the memory map at the top of page 264 in the
                        \ Programmer's Reference Guide

ENDIF

 LDY VIEW               \ Fetch the laser power for our new view
 LDA LASER,Y

IF _DISC_DOCKED OR _ELITE_A_DOCKED \ Label

 BEQ BOL1-1             \ If it is zero (i.e. there is no laser fitted to this
                        \ view), jump to BOL1-1 to return from the subroutine
                        \ (as BOL1-1 contains &60, which is the opcode for an
                        \ RTS)

ELIF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _6502SP_VERSION OR _APPLE_VERSION OR _DISC_FLIGHT OR _ELITE_A_FLIGHT OR _ELITE_A_6502SP_PARA OR _MASTER_VERSION

 BEQ LO2                \ If it is zero (i.e. there is no laser fitted to this
                        \ view), jump to LO2 to return from the subroutine (as
                        \ LO2 contains an RTS)

ELIF _C64_VERSION

 BEQ SIG3               \ If it is zero (i.e. there is no laser fitted to this
                        \ view), jump to SIG3 with A = 0 to skip displaying the
                        \ laser sights

ENDIF

IF _6502SP_VERSION \ Master: In the Master version, the laser crosshairs are different colours for the different laser types

 LDA #YELLOW            \ Send a #SETCOL YELLOW command to the I/O processor to
 JSR DOCOL              \ switch to colour 1, which is yellow in the space view

ELIF _MASTER_VERSION OR _APPLE_VERSION

 LDY #0                 \ Set Y to 0, to represent a pulse laser

 CMP #POW               \ If the laser power in A is equal to a pulse laser,
 BEQ SIG1               \ jump to SIG1 with Y = 0

 INY                    \ Increment Y to 1, to represent a beam laser

 CMP #POW+128           \ If the laser power in A is equal to a beam laser,
 BEQ SIG1               \ jump to SIG1 with Y = 1

 INY                    \ Increment Y to 2, to represent a military laser

 CMP #Armlas            \ If the laser power in A is equal to a military laser,
 BEQ SIG1               \ jump to SIG1 with Y = 2

 INY                    \ Increment Y to 3, to represent a mining laser

.SIG1

 LDA sightcol,Y         \ Set the colour from the sightcol table
 STA COL

ELIF _C64_VERSION

                        \ We now set the sprite pointer for sprite 0 so that it
                        \ points to the correct sprite definition for the
                        \ current laser type, so we can display sprite 0 in the
                        \ middle of the space view to show the laser sights
                        \
                        \ The first sprite definition at SPRITELOC% contains the
                        \ sights for the pulse laser, so we start by setting Y
                        \ to the sprite pointer for this sprite (the sprites
                        \ are defined in elite-sprite.asm)
                        \
                        \ Sprite pointers are defined as the offset from the
                        \ start of the VIC-II screen bank to start of the sprite
                        \ definitions, divided by 64
                        \
                        \ So we want to calculate:
                        \
                        \   Y = (SPRITELOC% - SCBASE) / 64

IF _GMA85_NTSC OR _GMA86_PAL

 LDY #&A0               \ For the GMA variants, we have:
                        \
                        \   SPRITELOC% = SCBASE + &2800
                        \
                        \ So we need to set Y to &2800 / 64 = &A0

ELIF _SOURCE_DISK_BUILD OR _SOURCE_DISC_FILES

 LDY #&C4               \ For the GMA variants, we have:
                        \
                        \   SPRITELOC% = SCBASE + &3100
                        \
                        \ So we need to set Y to &3100 / 64 = &C4

ENDIF

                        \ Y now contains the sprite pointer for the first sprite
                        \ definition, which is for the pulse laser
                        \
                        \ The second sprite definition is the beam laser sight,
                        \ the third is the military laser sight and the fourth
                        \ is the mining laser sprite, so we now increment Y (if
                        \ required) to point to the correct sprite definition
                        \ for the current laser type

 CMP #POW               \ If the laser power in A is equal to a pulse laser,
 BEQ SIG1               \ jump to SIG1 with Y pointing to the first sprite
                        \ definition

 INY                    \ Increment Y to point to the beam laser sight in the
                        \ second sprite definition

 CMP #POW+128           \ If the laser power in A is equal to a beam laser,
 BEQ SIG1               \ jump to SIG1 with Y pointing to the second sprite
                        \ definition

 INY                    \ Increment Y to point to the military laser sight in
                        \ the third sprite definition

 CMP #Armlas            \ If the laser power in A is equal to a military laser,
 BEQ SIG1               \ jump to SIG1 with Y pointing to the third sprite
                        \ definition

 INY                    \ Increment Y to point to the mining laser sight in the
                        \ fourth sprite definition

.SIG1

 STY &63F8              \ Set the pointer for sprite 0 in the text view to Y
                        \
                        \ The sprite pointer for sprite 0 is at &63F8 for the
                        \ text view because screen RAM for the text view is
                        \ at &6000 to &63FF, and the sprite pointers always
                        \ live in the last eight bytes of screen RAM, so that's
                        \ from &63F8 to &63FF for sprites 0 to 7

 STY &67F8              \ Set the pointer for sprite 0 in the space view to Y
                        \
                        \ The sprite pointer for sprite 0 is at &67F8 for the
                        \ space view because screen RAM for the space view is
                        \ at &6400 to &67FF, and the sprite pointers always
                        \ live in the last eight bytes of screen RAM, so that's
                        \ from &67F8 to &67FF for sprites 0 to 7

IF _GMA85_NTSC OR _GMA86_PAL

 LDA sightcol-&A0,Y     \ Fetch the colour from the sightcol table, subtracting
                        \ &A0 from Y so we have Y = 0 for pulse lasers through
                        \ to Y = 3 for mining lasers

ELIF _SOURCE_DISK_BUILD OR _SOURCE_DISC_FILES

 LDA sightcol-&C4,Y     \ Fetch the colour from the sightcol table, subtracting
                        \ &C4 from Y so we have Y = 0 for pulse lasers through
                        \ to Y = 3 for mining lasers

ENDIF

 STA VIC+&27            \ Set VIC register &27 to set the colour for sprite 0 to
                        \ the value in A, so the laser sights are shown in the
                        \ correct colour from the sightcol table

 LDA #1                 \ Set A = 1 to store in T to denote that we need to show
                        \ the laser sights

.SIG3

 STA T                  \ Store A in T, so T will be 0 if we jumped here without
                        \ wanting to show the laser sights, or 1 if we do want
                        \ to show the laser sights

 LDA TRIBBLE+1          \ Set A to bits 4-6 of the high byte of TRIBBLE(1 0)
 AND #%01111111         \
 LSR A                  \ TRIBBLE(1 0) is the number of Trumbles in the hold,
 LSR A                  \ and the maximum value of the high byte is &7F, so this
 LSR A                  \ sets A to the number of Trumbles in the hold, scaled
 LSR A                  \ to the range 0 to %111 (or 0 to 7)

\LSR A                  \ These instructions are commented out in the original
\ORA #3                 \ source

 TAX                    \ Copy A into X, so X is now in the range 0 to 7

 LDA TRIBTA,X           \ Look up the X-th entry in the TRIBTA table, which will
                        \ change X from 7 to 6, but leave X alone otherwise
                        \ (this is a pretty inefficient way to do this, so
                        \ presumably the TRIBTA table approach was used during
                        \ development to fine-tune the relationship between
                        \ Trumble counts and the number of sprites)

 STA TRIBCT             \ Store A in TRIBCT to record the number of Trumble
                        \ sprites to show on-screen, which is in the range 0 to
                        \ 6 (as the six sprites from 2 to 7 are allocated to the
                        \ Trumbles)

 LDA TRIBMA,X           \ The TRIBMA table contains sprite-enable flags for use
                        \ with VIC register &15, where the byte at position X
                        \ contains the correct bits for enabling sprites 2 to 7,
                        \ according to the number of Trumble sprites we want to
                        \ enable, so TRIBMA+2 enables two sprites (2 and 3) for
                        \ example, while TRIBMA+5 enables five sprites (2 to 6)
                        \
                        \ The Trumble sprites are sprites 2 to 7, so the table
                        \ contains values with bits 0 and 1 clear
                        \
                        \ So this sets A to the correct sprite-enable mask for
                        \ the set of Trumble sprites that we want to enable

 ORA T                  \ T contains 1 if we want to show laser sights or 0 if
                        \ we don't, so this sets bit 0 of A so we show sprite 0
                        \ if there are laser sights

 STA VIC+&15            \ Set VIC register &15 to enable each of the eight
                        \ sprites, with sprite 0 enabled (bit 0) if there are
                        \ laser sights, and sprites 2 to 7 (bits 2 to 7) enabled
                        \ according to the number of Trumbles in the hold

 LDA #%100              \ Call SETL1 to set the 6510 input/output port to the
 JMP SETL1              \ following:
                        \
                        \   * LORAM = 0
                        \   * HIRAM = 0
                        \   * CHAREN = 1
                        \
                        \ and return from the subroutine using a tail call
                        \
                        \ This sets the entire 64K memory map to RAM
                        \
                        \ See the memory map at the top of page 265 in the
                        \ Programmer's Reference Guide

ENDIF

IF NOT(_C64_VERSION)

 LDA #128               \ Set QQ19 to the x-coordinate of the centre of the
 STA QQ19               \ screen

 LDA #Y-24              \ Set QQ19+1 to the y-coordinate of the centre of the
 STA QQ19+1             \ screen, minus 24 (because TT15 will add 24 to the
                        \ coordinate when it draws the crosshairs)

 LDA #20                \ Set QQ19+2 to size 20 for the crosshairs size
 STA QQ19+2

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _APPLE_VERSION OR _MASTER_VERSION \ Platform

 JSR TT15               \ Call TT15 to draw crosshairs of size 20 just to the
                        \ left of the middle of the screen

ELIF _6502SP_VERSION

 JSR TT15b              \ Call TT15b to draw crosshairs of size 20 just to the
                        \ left of the middle of the screen, in the current
                        \ colour (yellow)

ENDIF

IF NOT(_C64_VERSION)

 LDA #10                \ Set QQ19+2 to size 10 for the crosshairs size
 STA QQ19+2

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _APPLE_VERSION OR _MASTER_VERSION \ Platform

 JMP TT15               \ Call TT15 to draw crosshairs of size 10 at the same
                        \ location, which will remove the centre part from the
                        \ laser crosshairs, leaving a gap in the middle, and
                        \ return from the subroutine using a tail call

ELIF _6502SP_VERSION

 JMP TT15b              \ Call TT15b to draw crosshairs of size 10 at the same
                        \ location, which will remove the centre part from the
                        \ laser crosshairs, leaving a gap in the middle, and
                        \ return from the subroutine using a tail call

ENDIF

