\ ******************************************************************************
\
\       Name: NWSHP
\       Type: Subroutine
\   Category: Universe
\    Summary: Add a new ship to our local bubble of universe
\
\ ------------------------------------------------------------------------------
\
IF NOT(_NES_VERSION)
\ This creates a new block of ship data in the K% workspace, allocates a new
\ block in the ship line heap at WP, adds the new ship's type into the first
\ empty slot in FRIN, and adds a pointer to the ship data into UNIV. If there
\ isn't enough free memory for the new ship, it isn't added.
ELIF _NES_VERSION
\ This creates a new block of ship data in the K% workspace, adds the new ship's
\ type into the first empty slot in FRIN, and adds a pointer to the ship data
\ into UNIV. If there isn't enough free memory for the new ship, it isn't added.
ENDIF
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The type of the ship to add (see variable XX21 for a
\                       list of ship types)
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   C flag              Set if the ship was successfully added, clear if it
\                       wasn't (as there wasn't enough free memory)
\
\   INF                 Points to the new ship's data block in K%
\
\ ******************************************************************************

IF _NES_VERSION

.NW2

 STA FRIN,X             \ Store the ship type in the X-th byte of FRIN, so the
                        \ slot is now shown as occupied in the index table

 TAX                    \ Copy the ship type into X

 LDA #0                 \ Zero the ship's number on the scanner so that it
 STA INWK+33            \ doesn't appear on the scanner

 JMP NW8                \ Jump down to NW8 to continue setting up the new ship

ENDIF

.NWSHP

 STA T                  \ Store the ship type in location T

IF _NES_VERSION

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

ENDIF

 LDX #0                 \ Before we can add a new ship, we need to check
                        \ whether we have an empty slot we can put it in. To do
                        \ this, we need to loop through all the slots to look
                        \ for an empty one, so set a counter in X that starts
                        \ from the first slot at 0. When ships are killed, then
                        \ the slots are shuffled down by the KILLSHP routine, so
                        \ the first empty slot will always come after the last
IF NOT(_NES_VERSION)
                        \ filled slot. This allows us to tack the new ship's
                        \ data block and ship line heap onto the end of the
                        \ existing ship data and heap, as shown in the memory
                        \ map below
ELIF _NES_VERSION
                        \ filled slot
ENDIF

.NWL1

 LDA FRIN,X             \ Load the ship type for the X-th slot

 BEQ NW1                \ If it is zero, then this slot is empty and we can use
                        \ it for our new ship, so jump down to NW1

 INX                    \ Otherwise increment X to point to the next slot

 CPX #NOSH              \ If we haven't reached the last slot yet, loop back up
 BCC NWL1               \ to NWL1 to check the next slot (note that this means
                        \ only slots from 0 to #NOSH - 1 are populated by this
                        \ routine, but there is one more slot reserved in FRIN,
                        \ which is used to identify the end of the slot list
                        \ when shuffling the slots down in the KILLSHP routine)

.NW3

 CLC                    \ Otherwise we don't have an empty slot, so we can't
 RTS                    \ add a new ship, so clear the C flag to indicate that
                        \ we have not managed to create the new ship, and return
                        \ from the subroutine

.NW1

                        \ If we get here, then we have found an empty slot at
                        \ index X, so we can go ahead and create our new ship.
                        \ We do that by creating a ship data block at INWK and,
                        \ when we are done, copying the block from INWK into
                        \ the K% workspace (specifically, to INF)

 JSR GINF               \ Get the address of the data block for ship slot X
                        \ (which is in workspace K%) and store it in INF

IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION OR _NES_VERSION \ Comment

 LDA T                  \ If the type of ship that we want to create is
 BMI NW2                \ negative, then this indicates a planet or sun, so
                        \ jump down to NW2, as the next section sets up a ship
                        \ data block, which doesn't apply to planets and suns,
                        \ as they don't have things like shields, missiles,
                        \ vertices and edges

ELIF _ELECTRON_VERSION

 LDA T                  \ If the type of ship that we want to create is
 BMI NW2                \ negative, then this indicates the planet, so
                        \ jump down to NW2, as the next section sets up a ship
                        \ data block, which doesn't apply to planets, as they
                        \ don't have things like shields, missiles, vertices
                        \ and edges

ENDIF

                        \ This is a ship, so first we need to set up various
                        \ pointers to the ship blueprint we will need. The
                        \ blueprints for each ship type in Elite are stored
                        \ in a table at location XX21, so refer to the comments
                        \ on that variable for more details on the data we're
                        \ about to access

 ASL A                  \ Set Y = ship type * 2
 TAY

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_DOCKED OR _ELITE_A_DOCKED OR _ELITE_A_ENCYCLOPEDIA \ Platform

 LDA XX21-2,Y           \ The ship blueprints at XX21 start with a lookup
 STA XX0                \ table that points to the individual ship blueprints,
                        \ so this fetches the low byte of this particular ship
                        \ type's blueprint and stores it in XX0

 LDA XX21-1,Y           \ Fetch the high byte of this particular ship type's
 STA XX0+1              \ blueprint and store it in XX0+1, so XX0(1 0) now
                        \ contains the address of this ship's blueprint

ELIF _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_FLIGHT OR _ELITE_A_6502SP_PARA OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION OR _NES_VERSION

 LDA XX21-1,Y           \ The ship blueprints at XX21 start with a lookup
                        \ table that points to the individual ship blueprints,
                        \ so this fetches the high byte of this particular ship
                        \ type's blueprint

 BEQ NW3                \ If the high byte is 0 then this is not a valid ship
                        \ type, so jump to NW3 to clear the C flag and return
                        \ from the subroutine

 STA XX0+1              \ This is a valid ship type, so store the high byte in
                        \ XX0+1

 LDA XX21-2,Y           \ Fetch the low byte of this particular ship type's
 STA XX0                \ blueprint and store it in XX0, so XX0(1 0) now
                        \ contains the address of this ship's blueprint

ENDIF

IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_FLIGHT OR _ELITE_A_DOCKED OR _ELITE_A_6502SP_PARA OR _6502SP_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION \ Comment

 CPY #2*SST             \ If the ship type is a space station (SST), then jump
 BEQ NW6                \ to NW6, skipping the heap space steps below, as the
                        \ space station has its own line heap at LSO (which it
                        \ shares with the sun)

ELIF _ELECTRON_VERSION

 CPY #2*SST             \ If the ship type is a space station (SST), then jump
 BEQ NW6                \ to NW6, skipping the heap space steps below, as the
                        \ space station has its own line heap at LSO

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION \ Comment

                        \ We now want to allocate space for a heap that we can
                        \ use to store the lines we draw for our new ship (so it
                        \ can easily be erased from the screen again). SLSP
                        \ points to the start of the current heap space, and we
                        \ can extend it downwards with the heap for our new ship
                        \ (as the heap space always ends just before the WP
                        \ workspace)

ELIF _6502SP_VERSION

                        \ We now want to allocate space for a heap that we can
                        \ use to store the lines we draw for our new ship (so it
                        \ can easily be erased from the screen again). SLSP
                        \ points to the start of the current heap space, and we
                        \ can extend it downwards with the heap for our new ship
                        \ (as the heap space always ends just before the ship
                        \ blueprints at D%)

ENDIF

IF NOT(_NES_VERSION)

 LDY #5                 \ Fetch ship blueprint byte #5, which contains the
 LDA (XX0),Y            \ maximum heap size required for plotting the new ship,
 STA T1                 \ and store it in T1

 LDA SLSP               \ Take the 16-bit address in SLSP and subtract T1,
 SEC                    \ storing the 16-bit result in INWK(34 33), so this now
 SBC T1                 \ points to the start of the line heap for our new ship
 STA INWK+33
 LDA SLSP+1
 SBC #0
 STA INWK+34

ELIF _NES_VERSION

 STX SC2                \ Store the new ship's slot number in SC2 to we can
                        \ retrieve it below

 LDX T                  \ Set X to the ship type that we stored in T above

 LDA #0                 \ Zero the ship's number on the scanner so that it
 STA INWK+33            \ doesn't appear on the scanner for now

 LDA scacol,X           \ Set A to the scanner colour for this ship type from
                        \ the X-th entry in the scacol table (the colour is
                        \ actually a sprite palette number)

 BMI nwsh3              \ If bit 7 is set of the scanner colour then this ship
                        \ has a cloaking device and is not visible on the
                        \ scanner, so jump to nwsh3 to skip the following so
                        \ the ship is not configured to appear on the scanner

 TAX                    \ Set X to the scanner colour for this ship

 LDY #8                 \ We now work our way through the list of scanner
                        \ numbers to try to find a number to allocate to the
                        \ new ship, starting from 8 and working down towards
                        \ 1, so set a number counter in Y

.nwsh1

 LDA scannerNumber,Y    \ If the Y-th entry in scannerNumber is zero then this
 BEQ nwsh2              \ number is available, so jump to nwsh2 to allocate it
                        \ to our new ship

 DEY                    \ Otherwise decrement the index in Y to point to the
                        \ next number down

 BNE nwsh1              \ Loop back to check the next entry in the table until
                        \ we have found a free number, or we have checked all
                        \ numbers from 8 to 1

 BEQ nwsh3              \ We didn't find an available number for the new ship,
                        \ so jump to nwsh3 to skip the following as there isn't
                        \ room for another ship on the scanner

.nwsh2

 LDA #&FF               \ Set the scannerNumber entry for this ship to &FF to
 STA scannerNumber,Y    \ indicate that this scanner number is now being used
                        \ for our new ship

 STY INWK+33            \ Set the ship's byte #33 to the scanner number for the
                        \ new ship

 TYA                    \ Set Y = (A * 2 + A) * 4
 ASL A                  \       = A * 3 * 4
 ADC INWK+33            \
 ASL A                  \ This gives us the offset of the first scanner sprite
 ASL A                  \ for this ship within the sprite buffer, as each
 TAY                    \ ship has three sprites allocated to it, and there are
                        \ four bytes per sprite in the buffer
                        \
                        \ The offset is from the first scanner sprite in the
                        \ sprite buffer, so this is the offset within the block
                        \ of scanner sprites in the buffer
                        \
                        \ That said, this value is not used here, as Y gets
                        \ overwritten below before this value is used

 TXA                    \ Set A to the scanner colour for this ship, which we
                        \ put in X above

 LDX INWK+33            \ Set X to the scanner number for the new ship

 STA scannerColour,X    \ Set the X-th entry in the scannerColour table to the
                        \ colour of this ship on the scanner

.nwsh3

 LDX SC2                \ Set X to the new ship's slot number that we stored in
                        \ SC2 above

ENDIF

IF NOT(_NES_VERSION)

                        \ We now need to check that there is enough free space
                        \ for both this new line heap and the new data block
                        \ for our ship. In memory, this is the layout of the
                        \ ship data blocks and ship line heaps:
                        \
ENDIF
IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ Comment
                        \   +-----------------------------------+   &0F34
                        \   |                                   |
                        \   | WP workspace                      |
                        \   |                                   |
                        \   +-----------------------------------+   &0D40 = WP
                        \   |                                   |
                        \   | Current ship line heap            |
                        \   |                                   |
ELIF _6502SP_VERSION
                        \   +-----------------------------------+
                        \   |                                   |
                        \   | Ship blueprints                   |
                        \   |                                   |
                        \   +-----------------------------------+   &D000 = D%
                        \   |                                   |
                        \   | Current ship line heap            |
                        \   |                                   |
ELIF _MASTER_VERSION
                        \   +-----------------------------------+   &1034
                        \   |                                   |
                        \   | WP workspace                      |
                        \   |                                   |
                        \   +-----------------------------------+   &0800 = WP
                        \   |                                   |
                        \   | Current ship line heap            |
                        \   |                                   |
ELIF _C64_VERSION
                        \   +-----------------------------------+   &FFC0 = LS%
                        \   |                                   |
                        \   | Current ship line heap            |
                        \   |                                   |
ELIF _APPLE_VERSION
                        \   +-----------------------------------+   &0B5F = LS%
                        \   |                                   |
                        \   | Current ship line heap            |
                        \   |                                   |
ENDIF
IF NOT(_NES_VERSION)
                        \   +-----------------------------------+   SLSP
                        \   |                                   |
                        \   | Proposed heap for new ship        |
                        \   |                                   |
                        \   +-----------------------------------+   INWK(34 33)
                        \   |                                   |
                        \   .                                   .
                        \   .                                   .
                        \   .                                   .
                        \   .                                   .
                        \   .                                   .
                        \   |                                   |
                        \   +-----------------------------------+   INF + NI%
                        \   |                                   |
                        \   | Proposed data block for new ship  |
                        \   |                                   |
                        \   +-----------------------------------+   INF
                        \   |                                   |
                        \   | Existing ship data blocks         |
                        \   |                                   |
ENDIF
IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ Comment
                        \   +-----------------------------------+   &0900 = K%
ELIF _6502SP_VERSION
                        \   +-----------------------------------+   &8200 = K%
ELIF _MASTER_VERSION
                        \   +-----------------------------------+   &0400 = K%
ELIF _C64_VERSION
                        \   +-----------------------------------+   &F900 = K%
ELIF _APPLE_VERSION
                        \   +-----------------------------------+   &0800 = K%
ENDIF
IF NOT(_NES_VERSION)
                        \
                        \ So, to work out if we have enough space, we have to
                        \ make sure there is room between the end of our new
                        \ ship data block at INF + NI%, and the start of the
                        \ proposed heap for our new ship at the address we
                        \ stored in INWK(34 33). Or, to put it another way, we
                        \ and to make sure that:
                        \
                        \   INWK(34 33) > INF + NI%
                        \
                        \ which is the same as saying:
                        \
                        \   INWK+33 - INF > NI%
                        \
                        \ because INWK is in zero page, so INWK+34 = 0

ENDIF

IF _CASSETTE_VERSION OR _6502SP_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION \ Comment

 LDA INWK+33            \ Calculate INWK+33 - INF, again using 16-bit
\SEC                    \ arithmetic, and put the result in (A Y), so the high
 SBC INF                \ byte is in A and the low byte in Y. The SEC
 TAY                    \ instruction is commented out in the original source;
 LDA INWK+34            \ as the previous subtraction will never underflow, it
 SBC INF+1              \ is superfluous

ELIF _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION

 LDA INWK+33            \ Calculate INWK+33 - INF, again using 16-bit
 SBC INF                \ arithmetic, and put the result in (A Y), so the high
 TAY                    \ byte is in A and the low byte in Y. The subtraction
 LDA INWK+34            \ works because the previous subtraction will never
 SBC INF+1              \ underflow, so we know the C flag is set

ENDIF

IF NOT(_NES_VERSION)

 BCC NW3+1              \ If we have an underflow from the subtraction, then
                        \ INF > INWK+33 and we definitely don't have enough
                        \ room for this ship, so jump to NW3+1, which returns
                        \ from the subroutine (with the C flag already cleared)

 BNE NW4                \ If the subtraction of the high bytes in A is not
                        \ zero, and we don't have underflow, then we definitely
                        \ have enough space, so jump to NW4 to continue setting
                        \ up the new ship

 CPY #NI%               \ Otherwise the high bytes are the same in our
 BCC NW3+1              \ subtraction, so now we compare the low byte of the
                        \ result (which is in Y) with NI%. This is the same as
                        \ doing INWK+33 - INF > NI% (see above). If this isn't
                        \ true, the C flag will be clear and we don't have
                        \ enough space, so we jump to NW3+1, which returns
                        \ from the subroutine (with the C flag already cleared)

.NW4

 LDA INWK+33            \ If we get here then we do have enough space for our
 STA SLSP               \ new ship, so store the new bottom of the ship line
 LDA INWK+34            \ heap (i.e. INWK+33) in SLSP, doing both the high and
 STA SLSP+1             \ low bytes

ENDIF

.NW6

IF NOT(_NES_VERSION)

 LDY #14                \ Fetch ship blueprint byte #14, which contains the
 LDA (XX0),Y            \ ship's energy, and store it in byte #35
 STA INWK+35

 LDY #19                \ Fetch ship blueprint byte #19, which contains the
 LDA (XX0),Y            \ number of missiles and laser power, and AND with %111
 AND #%00000111         \ to extract the number of missiles before storing in
 STA INWK+31            \ byte #31

ELIF _NES_VERSION

 LDY #14                \ Fetch ship blueprint byte #14, which contains the
 JSR GetShipBlueprint   \ ship's energy, and store it in byte #35
 STA INWK+35

 LDY #19                \ Fetch ship blueprint byte #19, which contains the
 JSR GetShipBlueprint   \ number of missiles and laser power, and AND with %111
 AND #%00000111         \ to extract the number of missiles before storing in
 STA INWK+31            \ byte #31

ENDIF

 LDA T                  \ Restore the ship type we stored above

IF NOT(_NES_VERSION)

.NW2

ENDIF

 STA FRIN,X             \ Store the ship type in the X-th byte of FRIN, so the
                        \ slot is now shown as occupied in the index table

 TAX                    \ Copy the ship type into X

IF _CASSETTE_VERSION OR _DISC_DOCKED OR _ELITE_A_DOCKED OR _ELITE_A_ENCYCLOPEDIA \ Label

 BMI P%+5               \ If the ship type is negative (planet or sun), then
                        \ skip the following instruction

ELIF _ELECTRON_VERSION

 BMI P%+5               \ If the ship type is negative (i.e. the planet), then
                        \ skip the following instruction

ELIF _DISC_FLIGHT OR _ELITE_A_FLIGHT OR _ELITE_A_6502SP_PARA OR _6502SP_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION OR _NES_VERSION

 BMI NW8                \ If the ship type is negative (planet or sun), then
                        \ jump to NW8 to skip the following instructions

ENDIF

IF _6502SP_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION OR _NES_VERSION \ Advanced: In the advanced versions, rock hermits are classed as junk, so they will not prevent you from performing an in-system jump (just like normal asteroids)

 CPX #HER               \ If the ship type is a rock hermit, jump to gangbang
 BEQ gangbang           \ to increase the junk count

ENDIF

IF _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_FLIGHT OR _ELITE_A_6502SP_PARA OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION OR _NES_VERSION \ Enhanced: The amount of junk in the enhanced versions is tracked in the JUNK variable

 CPX #JL                \ If JL <= X < JH, i.e. the type of ship we added in X
 BCC NW7                \ is junk (escape pod, alloy plate, cargo canister,
 CPX #JH                \ asteroid, splinter, Shuttle or Transporter), then keep
 BCS NW7                \ going, otherwise jump to NW7

.gangbang

 INC JUNK               \ We're adding junk, so increase the junk counter

.NW7

ENDIF

 INC MANY,X             \ Increment the total number of ships of type X

IF _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_FLIGHT OR _ELITE_A_6502SP_PARA OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION \ Enhanced: New ships are spawned using the default NEWB flags byte from the E% table, which gives each ship a typical "personality" which is then tailored to the game's needs. The cassette version doesn't have this byte, so ship behaviour is more limited

.NW8

 LDY T                  \ Restore the ship type we stored above

 LDA E%-1,Y             \ Fetch the E% byte for this ship to get the default
                        \ settings for the ship's NEWB flags

 AND #%01101111         \ Zero bits 4 and 7 (so the new ship is not docking, has
                        \ not been scooped, and has not just docked)

 ORA NEWB               \ Apply the result to the ship's NEWB flags, which sets
 STA NEWB               \ bits 0-3 and 5-6 in NEWB if they are set in the E%
                        \ byte

ELIF _NES_VERSION

 LDY T                  \ Restore the ship type we stored above

 JSR GetDefaultNEWB     \ Fetch the E% byte for this ship to get the default
                        \ settings for the ship's NEWB flags

 AND #%01101111         \ Zero bits 4 and 7 (so the new ship is not docking, has
                        \ not been scooped, and has not just docked)

 ORA NEWB               \ Apply the result to the ship's NEWB flags, which sets
 STA NEWB               \ bits 0-3 and 5-6 in NEWB if they are set in the E%
                        \ byte

 AND #%00000100         \ If bit 2 of the ship's NEWB flags is clear then the
 BEQ NW8                \ ship is not hostile, so jump to NW8 to skip the
                        \ following

 LDA allowInSystemJump  \ We are spawning a hostile ship, so set bit 7 of
 ORA #%10000000         \ allowInSystemJump to prevent us from being able to
 STA allowInSystemJump  \ perform an in-system jump

.NW8

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

ENDIF

 LDY #NI%-1             \ The final step is to copy the new ship's data block
                        \ from INWK to INF, so set up a counter for NI% bytes
                        \ in Y

.NWL3

 LDA INWK,Y             \ Load the Y-th byte of INWK and store in the Y-th byte
 STA (INF),Y            \ of the workspace pointed to by INF

 DEY                    \ Decrement the loop counter

 BPL NWL3               \ Loop back for the next byte until we have copied them
                        \ all over

IF _NES_VERSION

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

ENDIF

 SEC                    \ We have successfully created our new ship, so set the
                        \ C flag to indicate success

 RTS                    \ Return from the subroutine

