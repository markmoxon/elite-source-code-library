\ ******************************************************************************
\
\       Name: Main flight loop (Part 4 of 16)
\       Type: Subroutine
\   Category: Main loop
\    Summary: For each nearby ship: Copy the ship's data block from K% to the
\             zero-page workspace at INWK
\  Deep dive: Program flow of the main game loop
\             Ship data blocks
\
\ ------------------------------------------------------------------------------
\
\ The main flight loop covers most of the flight-specific aspects of Elite. This
\ section covers the following:
\
\   * Start looping through all the ships in the local bubble, and for each
\     one:
\
\     * Copy the ship's data block from K% to INWK
\
\     * Set XX0 to point to the ship's blueprint (if this is a ship)
\
\ Other entry points:
\
\   MAL1                Marks the beginning of the ship analysis loop, so we
\                       can jump back here from part 12 of the main flight loop
\                       to work our way through each ship in the local bubble.
\                       We also jump back here when a ship is removed from the
\                       bubble, so we can continue processing from the next ship
\
\ ******************************************************************************

IF NOT(_NES_VERSION)

.MA3

 LDX #0                 \ We're about to work our way through all the ships in
                        \ our local bubble of universe, so set a counter in X,
                        \ starting from 0, to refer to each ship slot in turn

ENDIF

.MAL1

 STX XSAV               \ Store the current slot number in XSAV

IF NOT(_NES_VERSION)

 LDA FRIN,X             \ Fetch the contents of this slot into A. If it is 0
 BNE P%+5               \ then this slot is empty and we have no more ships to
 JMP MA18               \ process, so jump to MA18 below, otherwise A contains
                        \ the type of ship that's in this slot, so skip over the
                        \ JMP MA18 instruction and keep going

ENDIF

 STA TYPE               \ Store the ship type in TYPE

IF _NES_VERSION

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

ENDIF

 JSR GINF               \ Call GINF to fetch the address of the ship data block
                        \ for the ship in slot X and store it in INF. The data
                        \ block is in the K% workspace, which is where all the
                        \ ship data blocks are stored

                        \ Next we want to copy the ship data block from INF to
                        \ the zero-page workspace at INWK, so we can process it
                        \ more efficiently

 LDY #NI%-1             \ There are NI% bytes in each ship data block (and in
                        \ the INWK workspace, so we set a counter in Y so we can
                        \ loop through them

.MAL2

 LDA (INF),Y            \ Load the Y-th byte of INF and store it in the Y-th
 STA INWK,Y             \ byte of INWK

 DEY                    \ Decrement the loop counter

 BPL MAL2               \ Loop back for the next byte until we have copied the
                        \ last byte from INF to INWK

IF _NES_VERSION

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

ENDIF

IF _CASSETTE_VERSION OR _DISC_FLIGHT OR _6502SP_VERSION OR _MASTER_VERSION OR _NES_VERSION \ Comment

 LDA TYPE               \ If the ship type is negative then this indicates a
 BMI MA21               \ planet or sun, so jump down to MA21, as the next bit
                        \ sets up a pointer to the ship blueprint, and then
                        \ checks for energy bomb damage, and neither of these
                        \ apply to planets and suns

ELIF _ELECTRON_VERSION

 LDA TYPE               \ If the ship type is negative then this indicates a
 BMI MA21               \ planet, so jump down to MA21, as the next bit sets
                        \ up a pointer to the ship blueprint, and then checks
                        \ for energy bomb damage, and neither of these apply
                        \ to planets

ELIF _ELITE_A_VERSION

 LDA TYPE               \ If the ship type is negative then this indicates a
 BMI MA21               \ planet or sun, so jump down to MA21, as the next bit
                        \ sets up a pointer to the ship blueprint, which doesn't
                        \ apply to planets and suns

ENDIF

IF _NES_VERSION

 CMP #2                 \ ???
 BNE main32

 LDA spasto             \ Copy the address of the space station's ship blueprint
 STA XX0                \ from spasto(1 0) to XX0(1 0), which we set up in NWSPS
 LDA spasto+1           \ when calculating the correct station type (Coriolis or
 STA XX0+1              \ Dodo)

 LDY #4
 BNE main33

.main32

ENDIF

 ASL A                  \ Set Y = ship type * 2
 TAY

 LDA XX21-2,Y           \ The ship blueprints at XX21 start with a lookup
 STA XX0                \ table that points to the individual ship blueprints,
                        \ so this fetches the low byte of this particular ship
                        \ type's blueprint and stores it in XX0

 LDA XX21-1,Y           \ Fetch the high byte of this particular ship type's
 STA XX0+1              \ blueprint and store it in XX0+1

IF _ELITE_A_VERSION

                        \ We now go straight to part 6, omitting part 5 from the
                        \ original disc version, as part 5 implements the energy
                        \ bomb, and Elite-A replaces the energy bomb with the
                        \ hyperspace unit

ENDIF

IF _NES_VERSION

.main33

 CPY #6
 BEQ main36
 CPY #&3C
 BEQ main36
 CPY #4
 BEQ main35
 LDA INWK+32
 BPL main36
 CPY #2
 BEQ main34
 AND #&3E
 BEQ main36

.main34

 LDA INWK+31
 AND #&A0
 BNE main36

.main35

 LDA NEWB
 AND #4
 BEQ main36
 ASL allowInSystemJump
 SEC
 ROR allowInSystemJump

.main36

ENDIF

