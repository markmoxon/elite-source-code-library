\ ******************************************************************************
\
\       Name: NWSHP
\       Type: Subroutine
\   Category: Universe
\    Summary: Add a new ship to our local bubble of universe
\
\ ------------------------------------------------------------------------------
\
\ This creates a new block of ship data in the K% workspace, allocates a new
\ block in the ship line heap at WP, adds the new ship's type into the first
\ empty slot in FRIN, and adds a pointer to the ship data into UNIV. If there
\ isn't enough free memory for the new ship, it isn't added.
\
\ Arguments:
\
\   A                   The type of the ship to add (see variable XX21 for a
\                       list of ship types)
\
\ Returns:
\
\   C flag              Set if the ship was successfully added, clear if it
\                       wasn't (as there wasn't enough free memory)
\
\ ******************************************************************************

.NWSHP

 STA T                  \ Store the ship type in location T

 LDX #0                 \ Before we can add a new ship, we need to check
                        \ whether we have an empty slot we can put it in. To do
                        \ this, we need to loop through all the slots to look
                        \ for an empty one, so set a counter in X that starts
                        \ from the first slot at 0. When ships are killed, then
                        \ the slots are shuffled down by the KILLSHP routine, so
                        \ the first empty slot will always come after the last
                        \ filled slot. This allows us to tack the new ship's
                        \ data block and ship line heap onto the end of the
                        \ existing ship data and heap, as shown in the memory
                        \ map below

.NWL1

 LDA FRIN,X             \ Load the ship type for the X-th slot

 BEQ NW1                \ If it is zero, then this slot is empty and we can use
                        \ it for our new ship, so jump down to NW1

 INX                    \ Otherwise increment X to point to the next slot

 CPX #NOSH              \ If we haven't reached the last slot yet, loop back up
 BCC NWL1               \ to NWL1 to check the next slot

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

 LDA T                  \ If the type of ship that we want to create is
 BMI NW2                \ negative, then this indicates a planet or sun, so
                        \ jump down to NW2, as the next section sets up a ship
                        \ data block, which doesn't apply to planets and suns,
                        \ as they don't have things like shields, missiles,
                        \ vertices and edges

                        \ This is a ship, so first we need to set up various
                        \ pointers to the ship blueprint we will need. The
                        \ blueprints for each ship type in Elite are stored
                        \ in a table at location XX21, so refer to the comments
                        \ on that variable for more details on the data we're
                        \ about to access

 ASL A                  \ Set Y = ship type * 2
 TAY

IF _CASSETTE_VERSION


 LDA XX21-2,Y           \ The ship blueprints at XX21 start with a lookup
 STA XX0                \ table that points to the individual ship blueprints,
                        \ so this fetches the low byte of this particular ship
                        \ type's blueprint and stores it in XX0

 LDA XX21-1,Y           \ Fetch the high byte of this particular ship type's
 STA XX0+1              \ blueprint and store it in XX0+1

ELIF _6502SP_VERSION

 LDA XX21-1,Y
 BEQ NW3
 STA XX0+1
 LDA XX21-2,Y
 STA XX0

ENDIF

 CPY #2*SST             \ If the ship type is a space station (SST), then jump
 BEQ NW6                \ to NW6, skipping the heap space steps below, as the
                        \ space station has its own line heap at LSO (which it
                        \ shares with the sun)

                        \ We now want to allocate space for a heap that we can
                        \ use to store the lines we draw for our new ship (so it
                        \ can easily be erased from the screen again). SLSP
                        \ points to the start of the current heap space, and we
                        \ can extend it downwards with the heap for our new ship
                        \ (as the heap space always ends just before the WP
                        \ workspace)

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

                        \ We now need to check that there is enough free space
                        \ for both this new line heap and the new data block
                        \ for our ship. In memory, this is the layout of the
                        \ ship data blocks and ship line heaps:
                        \
                        \   +-----------------------------------+   &0F34
                        \   |                                   |
                        \   | WP workspace                      |
                        \   |                                   |
                        \   +-----------------------------------+   &0D40 = WP
                        \   |                                   |
                        \   | Current ship line heap            |
                        \   |                                   |
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
                        \   +-----------------------------------+   &0900 = K%
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

 LDA INWK+33            \ Calculate INWK+33 - INF, again using 16-bit
\SEC                    \ arithmetic, and put the result in (A Y), so the high
 SBC INF                \ byte is in A and the low byte in Y. The SEC
 TAY                    \ instruction is commented out in the original source;
 LDA INWK+34            \ as the previous subtraction will never underflow, it
 SBC INF+1              \ is superfluous

 BCC NW3+1              \ If we have an underflow from the subtraction, then
                        \ INF > INWK+33 and we definitely don't have enough
                        \ room for this ship, so jump to NW3+1, which clears
                        \ the C flag and returns from the subroutine

 BNE NW4                \ If the subtraction of the high bytes in A is not
                        \ zero, and we don't have underflow, then we definitely
                        \ have enough space, so jump to NW4 to continue setting
                        \ up the new ship

 CPY #NI%               \ Otherwise the high bytes are the same in our
 BCC NW3+1              \ subtraction, so now we compare the low byte of the
                        \ result (which is in Y) with NI%. This is the same as
                        \ doing INWK+33 - INF > NI% (see above). If this isn't
                        \ true, the C flag will be clear and we don't have
                        \ enough space, so we jump to NW3+1, which clears the
                        \ C flag and returns from the subroutine

.NW4

 LDA INWK+33            \ If we get here then we do have enough space for our
 STA SLSP               \ new ship, so store the new bottom of the ship line
 LDA INWK+34            \ heap (i.e. INWK+33) in SLSP, doing both the high and
 STA SLSP+1             \ low bytes

.NW6

 LDY #14                \ Fetch ship blueprint byte #14, which contains the
 LDA (XX0),Y            \ ship's energy, and store it in byte #35
 STA INWK+35

 LDY #19                \ Fetch ship blueprint byte #19, which contains the
 LDA (XX0),Y            \ number of missiles and laser power, and AND with %111
 AND #%00000111         \ to extract the number of missiles before storing in
 STA INWK+31            \ byte #31

 LDA T                  \ Restore the ship type we stored above

.NW2

 STA FRIN,X             \ Store the ship type in the X-th byte of FRIN, so the
                        \ this slot is now shown as occupied in the index table

 TAX                    \ Copy the ship type into X

IF _CASSETTE_VERSION

 BMI P%+5               \ If the ship type is negative (planet or sun), then
                        \ skip the following instruction


ELIF _6502SP_VERSION

 BMI NW8
 CPX #HER
 BEQ gangbang
 CPX #JL
 BCC NW7
 CPX #JH
 BCS NW7

.gangbang

 INC JUNK

.NW7

ENDIF

 INC MANY,X             \ Increment the total number of ships of type X

IF _6502SP_VERSION

.NW8

 LDY T
 LDA E%-1,Y
 AND #&6F
 ORA NEWB
 STA NEWB

ENDIF

 LDY #(NI%-1)           \ The final step is to copy the new ship's data block
                        \ from INWK to INF, so set up a counter for NI% bytes
                        \ in Y

.NWL3

 LDA INWK,Y             \ Load the Y-th byte of INWK and store in the Y-th byte
 STA (INF),Y            \ of the workspace pointed to by INF

 DEY                    \ Decrement the loop counter

 BPL NWL3               \ Loop back for the next byte until we have copied them
                        \ all over

 SEC                    \ We have successfully created our new ship, so set the
                        \ C flag to indicate success

 RTS                    \ Return from the subroutine

