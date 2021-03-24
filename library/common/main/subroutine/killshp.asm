\ ******************************************************************************
\
\       Name: KILLSHP
\       Type: Subroutine
\   Category: Universe
\    Summary: Remove a ship from our local bubble of universe
\
\ ------------------------------------------------------------------------------
\
\ Remove the ship in slot X from our local bubble of universe. This happens
\ when we kill a ship, collide with a ship and destroy it, or when a ship moves
\ outside our local bubble.
\
\ We also use this routine when we move out of range of the space station, in
\ which case we replace it with the sun.
\
\ When removing a ship, this creates a gap in the ship slots at FRIN, so we
\ shuffle all the later slots down to close the gap. We also shuffle the ship
\ data blocks at K% and ship line heap at WP, to reclaim all the memory that
\ the removed ship used to occupy.
\
\ Arguments:
\
\   X                   The slot number of the ship to remove
\
\   XX0                 The address of the blueprint for the ship to remove
\
\   INF                 The address of the data block for the ship to remove
\
\ ******************************************************************************

.KILLSHP

 STX XX4                \ Store the slot number of the ship to remove in XX4

IF _CASSETTE_VERSION OR _6502SP_VERSION OR _MASTER_VERSION \ Minor

                        \ The following two instructions appear in the BASIC
                        \ source file (ELITEF), but in the text source file
                        \ (ELITEF.TXT) they are replaced by:
                        \
                        \   CPX MSTG
                        \
                        \ which does the same thing, but saves two bytes of
                        \ memory (as CPX MSTG is a two-byte opcode, while LDA
                        \ MSTG and CMP XX4 take up four bytes between them)

 LDA MSTG               \ Check whether this slot matches the slot number in
 CMP XX4                \ MSTG, which is the target of our missile lock

ELIF _DISC_FLIGHT

 CPX MSTG               \ Check whether this slot matches the slot number in
                        \ MSTG, which is the target of our missile lock

ENDIF

 BNE KS5                \ If our missile is not locked on this ship, jump to KS5

IF _CASSETTE_VERSION OR _DISC_FLIGHT \ Screen

 LDY #&EE               \ Otherwise we need to remove our missile lock, so call
 JSR ABORT              \ ABORT to disarm the missile and update the missile
                        \ indicators on the dashboard to green/cyan (Y = &EE)

ELIF _6502SP_VERSION OR _MASTER_VERSION

 LDY #GREEN2            \ Otherwise we need to remove our missile lock, so call
 JSR ABORT              \ ABORT to disarm the missile and update the missile
                        \ indicators on the dashboard to green (Y = #GREEN2)

ENDIF

 LDA #200               \ Print recursive token 40 ("TARGET LOST") as an
 JSR MESS               \ in-flight message

.KS5

 LDY XX4                \ Restore the slot number of the ship to remove into Y

 LDX FRIN,Y             \ Fetch the contents of the slot, which contains the
                        \ ship type

 CPX #SST               \ If this is the space station, then jump to KS4 to
 BEQ KS4                \ replace the space station with the sun

IF _6502SP_VERSION OR _DISC_FLIGHT OR _MASTER_VERSION \ Enhanced: In the enhanced versions, the Constrictor is a special ship, and killing it ends the first mission

 CPX #CON               \ Did we just kill the Constrictor from mission 1? If
 BNE lll                \ not, jump to lll

 LDA TP                 \ We just killed the Constrictor from mission 1, so set
 ORA #%00000010         \ bit 1 of TP to indicate that we have successfully
 STA TP                 \ completed mission 1

ENDIF

IF _MASTER_VERSION \ Advanced: In the Master version, killing the Constrictor at the end of mission 1 instantly gives you 256 kill points

 INC TALLY+1            \ Award 256 kill points for killing the Constrictor

ENDIF

IF _6502SP_VERSION OR _DISC_FLIGHT OR _MASTER_VERSION \ Label

.lll

ENDIF

IF _6502SP_VERSION OR _MASTER_VERSION \ Advanced: There are rock hermits in the 6502SP version, and they are classed as junk (along with the escape pod, alloy plate, cargo canister, asteroid, splinter, Shuttle and Transporter)

 CPX #HER               \ Did we just kill a rock hermit? If we did, jump to
 BEQ blacksuspenders    \ blacksuspenders to decrease the junk count

ENDIF

IF _6502SP_VERSION OR _DISC_FLIGHT OR _MASTER_VERSION \ Enhanced: Group A: In the cassette version, only the escape pod, asteroid and cargo canister are classed as junk. In the enhanced versions, the alloy plate, splinter, Shuttle and Transporter are also junk (and in the advanced versions, rock hermits are also junk). Junk in the vicinity doesn't prevent you from performing an in-system jump - in fact, it gets dragged along for the ride

 CPX #JL                \ If JL <= X < JH, i.e. the type of ship we killed in X
 BCC KS7                \ is junk (escape pod, alloy plate, cargo canister,
 CPX #JH                \ asteroid, splinter, Shuttle or Transporter), then keep
 BCS KS7                \ going, otherwise jump to KS7

ENDIF

IF _6502SP_VERSION OR _MASTER_VERSION \ Label

.blacksuspenders

ENDIF

IF _6502SP_VERSION OR _DISC_FLIGHT OR _MASTER_VERSION \ Enhanced: See group A

 DEC JUNK               \ We just killed junk, so decrease the junk counter

.KS7

ENDIF

 DEC MANY,X             \ Decrease the number of this type of ship in our little
                        \ bubble, which is stored in MANY+X (where X is the ship
                        \ type)

 LDX XX4                \ Restore the slot number of the ship to remove into X

                        \ We now want to remove this ship and reclaim all the
                        \ memory that it uses. Removing the ship will leave a
                        \ gap in three places, which we need to close up:
                        \
                        \   * The ship slots in FRIN
                        \
                        \   * The ship data blocks in K%
                        \
                        \   * The descending ship line heap at WP down
                        \
                        \ The rest of this routine closes up these gaps by
                        \ looping through all the occupied ship slots after the
                        \ slot we are removing, one by one, and shuffling each
                        \ ship's slot, data block and line heap down to close
                        \ up the gaps left by the removed ship. As part of this,
                        \ we have to make sure we update any address pointers
                        \ so they point to the newly shuffled data blocks and
                        \ line heaps
                        \
                        \ In the following, when shuffling a ship's data down
                        \ into the preceding empty slot, we call the ship that
                        \ we are shuffling down the "source", and we call the
                        \ empty slot we are shuffling it into the "destination"
                        \
                        \ Before we start looping through the ships we need to
                        \ shuffle down, we need to set up some variables to
                        \ point to the source and destination line heaps

 LDY #5                 \ Fetch byte #5 of the removed ship's blueprint into A,
 LDA (XX0),Y            \ which gives the ship's maximum heap size for the ship
                        \ we are removing (i.e. the size of the gap in the heap
                        \ created by the ship removal)

                        \ INF currently contains the ship data for the ship we
                        \ are removing, and INF(34 33) contains the address of
                        \ the bottom of the ship's heap, so we can calculate
                        \ the address of the top of the heap by adding the heap
                        \ size to this address

 LDY #33                \ First we add A and the address in INF+33, to get the
 CLC                    \ low byte of the top of the heap, which we store in P
 ADC (INF),Y
 STA P

 INY                    \ And next we add A and address in INF+34, with any
 LDA (INF),Y            \ from the previous addition, to get the high byte of
 ADC #0                 \ the top of the heap, which we store in P+1, so P(1 0)
 STA P+1                \ points to the top of this ship's heap

                        \ Now, we're ready to start looping through the ships
                        \ we want to move, moving the slots, data blocks and
                        \ line heap from the source to the destination. In the
                        \ following, we set up SC to point to the source data,
                        \ and INF (which currently points to the removed ship's
                        \ data that we can now overwrite) points to the
                        \ destination
                        \
                        \ So P(1 0) now points to the top of the line heap for
                        \ the destination

.KSL1

 INX                    \ On entry, X points to the empty slot we want to
                        \ shuffle the next ship into (the destination), so
                        \ this increment points X to the next slot - i.e. the
                        \ source slot we want to shuffle down

 LDA FRIN,X             \ Copy the contents of the source slot into the
 STA FRIN-1,X           \ destination slot

IF _CASSETTE_VERSION \ Minor

 BEQ KS2                \ If the slot we just shuffled down contains 0, then
                        \ the source slot is empty and we are done shuffling,
                        \ so jump to KS2 to move on to processing missiles

ELIF _6502SP_VERSION OR _DISC_FLIGHT OR _MASTER_VERSION

 BNE P%+5               \ If the slot we just shuffled down is not empty, then
                        \ skip the following instruction

 JMP KS2                \ The source slot is empty and we are done shuffling,
                        \ so jump to KS2 to move on to processing missiles

ENDIF

 ASL A                  \ Otherwise we have a source ship to shuffle down into
 TAY                    \ the destination, so set Y = A * 2 so it can act as an
                        \ index into the two-byte ship blueprint lookup table
                        \ at XX21 for the source ship

 LDA XX21-2,Y           \ Set SC(0 1) to point to the blueprint data for the
 STA SC                 \ source ship
 LDA XX21-1,Y
 STA SC+1

 LDY #5                 \ Fetch blueprint byte #5 for the source ship, which
 LDA (SC),Y             \ gives us its maximum heap size, and store it in T
 STA T

                        \ We now subtract T from P(1 0), so P(1 0) will point to
                        \ the bottom of the line heap for the destination
                        \ (which we will use later when closing up the gap in
                        \ the heap space)

 LDA P                  \ First, we subtract the low bytes
 SEC
 SBC T
 STA P

 LDA P+1                \ And then we do the high bytes, for which we subtract
 SBC #0                 \ 0 to include any carry, so this is effectively doing
 STA P+1                \ P(1 0) = P(1 0) - (0 T)

                        \ Next, we want to set SC(1 0) to point to the source
                        \ ship's data block

 TXA                    \ Set Y = X * 2 so it can act as an index into the
 ASL A                  \ two-byte lookup table at UNIV, which contains the
 TAY                    \ addresses of the ship data blocks. In this case we are
                        \ multiplying X by 2, and X contains the source ship's
                        \ slot number so Y is now an index for the source ship's
                        \ entry in UNIV

 LDA UNIV,Y             \ Set SC(1 0) to the address of the data block for the
 STA SC                 \ source ship
 LDA UNIV+1,Y
 STA SC+1

                        \ We have now set up our variables as follows:
                        \
                        \   SC(1 0) points to the source's ship data block
                        \
                        \   INF(1 0) points to the destination's ship data block
                        \
                        \   P(1 0) points to the destination's line heap
                        \
                        \ so let's start copying data from the source to the
                        \ destination

IF _CASSETTE_VERSION \ Enhanced: Ship data blocks have an extra byte in the enhanced versions - the NEWB flags. This gives a total of 37 bytes per ship, compared to 36 bytes in the cassette version

 LDY #35                \ We are going to be using Y as a counter for the 36
                        \ bytes of ship data we want to copy from the source
                        \ to the destination, so we set it to 35 to start things
                        \ off, and will decrement Y for each byte we copy

ELIF _6502SP_VERSION OR _DISC_FLIGHT OR _MASTER_VERSION

 LDY #36                \ We are going to be using Y as a counter for the 37
                        \ bytes of ship data we want to copy from the source
                        \ to the destination, so we set it to 36 to start things
                        \ off, and will decrement Y for each byte we copy

 LDA (SC),Y             \ Fetch byte #36 of the source's ship data block at SC,
 STA (INF),Y            \ and store it in byte #36 of the destination's block
 DEY                    \ at INF, so that's the ship's NEWB flags copied from
                        \ the source to the destination. One down, quite a few
                        \ to go...

ENDIF

 LDA (SC),Y             \ Fetch byte #35 of the source's ship data block at SC,
 STA (INF),Y            \ and store it in byte #35 of the destination's block
                        \ at INF, so that's the ship's energy copied from the
IF _CASSETTE_VERSION OR _DISC_FLIGHT OR _MASTER_VERSION \ Comment
                        \ source to the destination. One down, quite a few to
                        \ go...
ELIF _6502SP_VERSION
                        \ source to the destination
ENDIF

 DEY                    \ Fetch byte #34 of the source ship, which is the
 LDA (SC),Y             \ high byte of the source ship's line heap, and store
 STA K+1                \ in K+1

 LDA P+1                \ Set the low byte of the destination's heap pointer
 STA (INF),Y            \ to P+1

 DEY                    \ Fetch byte #33 of the source ship, which is the
 LDA (SC),Y             \ low byte of the source ship's heap, and store in K
 STA K                  \ so now we have the following:
                        \
                        \   K(1 0) points to the source's line heap

 LDA P                  \ Set the low byte of the destination's heap pointer
 STA (INF),Y            \ to P, so now the destination's heap pointer is to
                        \ P(1 0), so that's the heap pointer in bytes #33 and
                        \ #34 done

 DEY                    \ Luckily, we can just copy the rest of the source's
                        \ ship data block into the destination, as there are no
                        \ more address pointers, so first we decrement our
                        \ counter in Y to point to the next byte (the AI flag)
                        \ in byte #32) and then start looping

.KSL2

 LDA (SC),Y             \ Copy the Y-th byte of the source to the Y-th byte of
 STA (INF),Y            \ the destination

 DEY                    \ Decrement the counter

 BPL KSL2               \ Loop back to KSL2 to copy the next byte until we have
                        \ copied the whole block

                        \ We have now shuffled the ship's slot and the ship's
                        \ data block, so we only have the heap data itself to do

 LDA SC                 \ First, we copy SC into INF, so when we loop round
 STA INF                \ again, INF will correctly point to the destination for
 LDA SC+1               \ the next iteration
 STA INF+1

 LDY T                  \ Now we want to move the contents of the heap, as all
                        \ we did above was to update the pointers, so first
                        \ we set a counter in Y that is initially set to T
                        \ (which we set above to the maximum heap size for the
                        \ source ship)
                        \
                        \ As a reminder, we have already set the following:
                        \
                        \   K(1 0) points to the source's line heap
                        \
                        \   P(1 0) points to the destination's line heap
                        \
                        \ so we can move the heap data by simply copying the
                        \ correct number of bytes from K(1 0) to P(1 0)
.KSL3

 DEY                    \ Decrement the counter

 LDA (K),Y              \ Copy the Y-th byte of the source heap at K(1 0) to
 STA (P),Y              \ the destination heap at P(1 0)

 TYA                    \ Loop back to KSL3 to copy the next byte, until we
 BNE KSL3               \ have done them all

 BEQ KSL1               \ We have now shuffled everything down one slot, so
                        \ jump back up to KSL1 to see if there is another slot
                        \ that needs shuffling down (this BEQ is effectively a
                        \ JMP as A will always be zero)

