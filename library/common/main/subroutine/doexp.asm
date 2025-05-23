\ ******************************************************************************
\
\       Name: DOEXP
\       Type: Subroutine
\   Category: Drawing ships
\    Summary: Draw an exploding ship
\  Deep dive: Drawing explosion clouds
\             Generating random numbers
IF _C64_VERSION
\             Sprite usage in Commodore 64 Elite
ENDIF
\
IF _NES_VERSION OR _C64_VERSION
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   EXS1                Set (A X) = (A R) +/- random * cloud size
\
ENDIF
\ ******************************************************************************

.EX2

 LDA INWK+31            \ Set bits 5 and 7 of the ship's byte #31 to denote that
 ORA #%10100000         \ the ship is exploding and has been killed
 STA INWK+31

IF NOT(_NES_VERSION)

 RTS                    \ Return from the subroutine

ELIF _NES_VERSION

.dexp1

 JMP HideExplosionBurst \ Hide the four sprites that make up the explosion burst
                        \ and return from the subroutine using a tail call

 EQUB &00, &02          \ These bytes appear to be unused

ENDIF

.DOEXP

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION \ Platform

 LDA INWK+31            \ If bit 6 of the ship's byte #31 is clear, then the
 AND #%01000000         \ ship is not already exploding so there is no existing
 BEQ P%+5               \ explosion cloud to remove, so skip the following
                        \ instruction

 JSR PTCLS              \ Call PTCLS to remove the existing cloud by drawing it
                        \ again

 LDA INWK+6             \ Set T = z_lo
 STA T

 LDA INWK+7             \ Set A = z_hi, so (A T) = z

 CMP #32                \ If z_hi < 32, skip the next two instructions
 BCC P%+6

 LDA #&FE               \ Set A = 254 and jump to yy (this BNE is effectively a
 BNE yy                 \ JMP, as A is never zero)

 ASL T                  \ Shift (A T) left twice
 ROL A
 ASL T
 ROL A

 SEC                    \ And then shift A left once more, inserting a 1 into
 ROL A                  \ bit 0

                        \ Overall, the above multiplies A by 8 and makes sure it
                        \ is at least 1, to leave a one-byte distance in A. We
                        \ can use this as the distance for our cloud, to ensure
                        \ that the explosion cloud is visible even for ships
                        \ that blow up a long way away

.yy

 STA Q                  \ Store the distance to the explosion in Q

 LDY #1                 \ Fetch byte #1 of the ship line heap, which contains
 LDA (XX19),Y           \ the cloud counter

ELIF _NES_VERSION

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDA INWK+6             \ Set T = z_lo
 STA T

 LDA INWK+7             \ Set A = z_hi, so (A T) = z

 CMP #32                \ If z_hi < 32, skip the next two instructions
 BCC P%+6

 LDA #&FE               \ Set A = 254 and jump to yy (this BNE is effectively a
 BNE yy                 \ JMP, as A is never zero)

 ASL T                  \ Shift (A T) left twice
 ROL A
 ASL T
 ROL A

 SEC                    \ And then shift A left once more, inserting a 1 into
 ROL A                  \ bit 0

                        \ Overall, the above multiplies A by 8 and makes sure it
                        \ is at least 1, to leave a one-byte distance in A. We
                        \ can use this as the distance for our cloud, to ensure
                        \ that the explosion cloud is visible even for ships
                        \ that blow up a long way away

.yy

 STA Q                  \ Store the distance to the explosion in Q

 LDA INWK+34            \ Set A to the cloud counter from byte #34 of the ship's
                        \ data block

ENDIF

IF _MASTER_VERSION OR _APPLE_VERSION \ Platform

 STA frump              \ Store the cloud counter in frump (though this value is
                        \ never read, so this has no effect)

ELIF _C64_VERSION

 STA frump              \ Store the cloud counter in frump, so we can retrieve
                        \ it below

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION \ Platform

 ADC #4                 \ Add 4 to the cloud counter, so it ticks onwards every
                        \ we redraw it

 BCS EX2                \ If the addition overflowed, jump up to EX2 to update
                        \ the explosion flags and return from the subroutine

 STA (XX19),Y           \ Store the updated cloud counter in byte #1 of the ship
                        \ line heap

 JSR DVID4              \ Calculate the following:
                        \
                        \   (P R) = 256 * A / Q
                        \         = 256 * cloud counter / distance
                        \
                        \ We are going to use this as our cloud size, so the
                        \ further away the cloud, the smaller it is, and as the
                        \ cloud counter ticks onward, the cloud expands

 LDA P                  \ Set A = P, so we now have:
                        \
                        \   (A R) = 256 * cloud counter / distance

 CMP #&1C               \ If A < 28, skip the next two instructions
 BCC P%+6

 LDA #&FE               \ Set A = 254 and skip the following (this BNE is
 BNE LABEL_1            \ effectively a JMP as A is never zero)

 ASL R                  \ Shift (A R) left three times to multiply by 8
 ROL A
 ASL R
 ROL A
 ASL R
 ROL A

                        \ Overall, the above multiplies (A R) by 8 to leave a
                        \ one-byte cloud size in A, given by the following:
                        \
                        \   A = 8 * cloud counter / distance

.LABEL_1

ELIF _NES_VERSION

 ADC #4                 \ Add 4 to the cloud counter, so it ticks onwards every
                        \ we redraw it

 BCS EX2                \ If the addition overflowed, jump up to EX2 to update
                        \ the explosion flags and return from the subroutine

 STA INWK+34            \ Store the updated cloud counter in byte #34 of the
                        \ ship data block

 JSR DVID4              \ Calculate the following:
                        \
                        \   (P R) = 256 * A / Q
                        \         = 256 * cloud counter / distance
                        \
                        \ We are going to use this as our cloud size, so the
                        \ further away the cloud, the smaller it is, and as the
                        \ cloud counter ticks onward, the cloud expands

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDA P                  \ Set A = P, so we now have:
                        \
                        \   (A R) = 256 * cloud counter / distance

 CMP #&1C               \ If A < 28, skip the next two instructions
 BCC P%+6

 LDA #&FE               \ Set A = 254 and skip the following (this BNE is
 BNE LABEL_1            \ effectively a JMP as A is never zero)

 ASL R                  \ Shift (A R) left three times to multiply by 8
 ROL A
 ASL R
 ROL A
 ASL R
 ROL A

                        \ Overall, the above multiplies (A R) by 8 to leave a
                        \ one-byte cloud size in A, given by the following:
                        \
                        \   A = 8 * cloud counter / distance

.LABEL_1

ENDIF

IF _6502SP_VERSION \ Comment

                        \ In the 6502 Second Processor version, the LABEL_1
                        \ label is actually `_ (a backtick followed by an
                        \ underscore), but that doesn't compile in BeebAsm and
                        \ it's pretty cryptic, so instead this version sticks
                        \ with the label LABEL_1 from the cassette version
ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_FLIGHT OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION \ Label

 DEY                    \ Decrement Y to 0

 STA (XX19),Y           \ Store the cloud size in byte #0 of the ship line heap

 LDA INWK+31            \ Clear bit 6 of the ship's byte #31 to denote that the
 AND #%10111111         \ explosion has not yet been drawn
 STA INWK+31

 AND #%00001000         \ If bit 3 of the ship's byte #31 is clear, then nothing
 BEQ TT48               \ is being drawn on-screen for this ship anyway, so
                        \ return from the subroutine (as TT48 contains an RTS)

 LDY #2                 \ Otherwise it's time to draw an explosion cloud, so
 LDA (XX19),Y           \ fetch byte #2 of the ship line heap into Y, which we
 TAY                    \ set to the explosion count for this ship (i.e. the
                        \ number of vertices used as origins for explosion
                        \ clouds)
                        \
                        \ The explosion count is stored as 4 * n + 6, where n is
                        \ the number of vertices, so the following loop copies
                        \ the coordinates of the first n vertices from the heap
                        \ at XX3, which is where we stored all the visible
                        \ vertex coordinates in part 8 of the LL9 routine, and
                        \ sticks them in the ship line heap pointed to by XX19,
                        \ starting at byte #7 (so it leaves the first 6 bytes of
                        \ the ship line heap alone)

.EXL1

 LDA XX3-7,Y            \ Copy byte Y-7 from the XX3 heap, into the Y-th byte of
 STA (XX19),Y           \ the ship line heap

 DEY                    \ Decrement the loop counter

 CPY #6                 \ Keep copying vertex coordinates into the ship line
 BNE EXL1               \ heap until Y = 6 (which will copy n vertices, where n
                        \ is the number of vertices we should be exploding)

 LDA INWK+31            \ Set bit 6 of the ship's byte #31 to denote that the
 ORA #%01000000         \ explosion has been drawn (as it's about to be)
 STA INWK+31

ELIF _ELITE_A_6502SP_PARA

 DEY                    \ Decrement Y to 0

 STA (XX19),Y           \ Store the cloud size in byte #0 of the ship line heap

 LDA INWK+31            \ Clear bit 6 of the ship's byte #31 to denote that the
 AND #%10111111         \ explosion has not yet been drawn
 STA INWK+31

 AND #%00001000         \ If bit 3 of the ship's byte #31 is clear, then nothing
 BEQ DOEXP-1            \ is being drawn on-screen for this ship anyway, so
                        \ return from the subroutine (as DOEXP-1 contains an
                        \ RTS)

 LDY #2                 \ Otherwise it's time to draw an explosion cloud, so
 LDA (XX19),Y           \ fetch byte #2 of the ship line heap into Y, which we
 TAY                    \ set to the explosion count for this ship (i.e. the
                        \ number of vertices used as origins for explosion
                        \ clouds)
                        \
                        \ The explosion count is stored as 4 * n + 6, where n is
                        \ the number of vertices, so the following loop copies
                        \ the coordinates of the first n vertices from the heap
                        \ at XX3, which is where we stored all the visible
                        \ vertex coordinates in part 8 of the LL9 routine, and
                        \ sticks them in the ship line heap pointed to by XX19,
                        \ starting at byte #7 (so it leaves the first 6 bytes of
                        \ the ship line heap alone)

.EXL1

 LDA XX3-7,Y            \ Copy byte Y-7 from the XX3 heap, into the Y-th byte of
 STA (XX19),Y           \ the ship line heap

 DEY                    \ Decrement the loop counter

 CPY #6                 \ Keep copying vertex coordinates into the ship line
 BNE EXL1               \ heap until Y = 6 (which will copy n vertices, where n
                        \ is the number of vertices we should be exploding)

 LDA INWK+31            \ Set bit 6 of the ship's byte #31 to denote that the
 ORA #%01000000         \ explosion has been drawn (as it's about to be)
 STA INWK+31

ELIF _NES_VERSION

 STA cloudSize          \ Store the cloud size in cloudSize so we can access it
                        \ later

 LDA INWK+31            \ Clear bit 6 of the ship's byte #31 to denote that the
 AND #%10111111         \ explosion has not yet been drawn
 STA INWK+31

 AND #%00001000         \ If bit 3 of the ship's byte #31 is clear, then nothing
 BEQ dexp1              \ is being drawn on-screen for this ship anyway, so
                        \ return from the subroutine

 LDA INWK+7             \ If z_hi = 0 then jump to PTCLS to draw the explosion
 BEQ PTCLS              \ cloud (but not the explosion burst, as the ship is too
                        \ close for the burst sprites to look good)

 LDY INWK+34            \ Fetch byte #34 of the ship data block, which contains
                        \ the cloud counter

 CPY #24                \ If Y >= 24 then jump to PTCLS to draw the explosion
 BCS PTCLS              \ cloud (but not the explosion burst as the explosion is
                        \ already past that point)

                        \ If we get here then the exploding ship is not too
                        \ close and we haven't yet counted past the initial part
                        \ of the explosion, so we can show the explosion burst
                        \ using the explosion sprites

 JMP DrawExplosionBurst \ Draw the exploding ship along with an explosion burst,
                        \ returning from the subroutine using a tail call

ENDIF

IF _C64_VERSION

 LDY frump              \ Fetch the cloud counter into Y, which we stored in
                        \ frump above

 CPY #18                \ If the cloud counter in Y is 18, then the explosion
 BNE P%+5               \ has just begun (as the cloud counter is initialised
 JMP PTCLS2S            \ to 18 in part 1 of LL9), so jump to PTCLS2 via PTCLS2S
                        \ to draw the explosion along with an explosion sprite,
                        \ returning from the subroutine using a tail call

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_FLIGHT OR _ELITE_A_6502SP_PARA OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION \ Platform

.PTCLS

                        \ This part of the routine actually draws the explosion
                        \ cloud

 LDY #0                 \ Fetch byte #0 of the ship line heap, which contains
 LDA (XX19),Y           \ the cloud size we stored above, and store it in Q
 STA Q

 INY                    \ Increment the index in Y to point to byte #1

 LDA (XX19),Y           \ Fetch byte #1 of the ship line heap, which contains
                        \ the cloud counter. We are now going to process this
                        \ into the number of particles in each vertex's cloud

 BPL P%+4               \ If the cloud counter < 128, then we are in the first
                        \ half of the cloud's existence, so skip the next
                        \ instruction

 EOR #&FF               \ Flip the value of A so that in the second half of the
                        \ cloud's existence, A counts down instead of up

ELIF _NES_VERSION

.PTCLS

                        \ This part of the routine actually draws the explosion
                        \ cloud

 JSR HideExplosionBurst \ Hide the four sprites that make up the explosion burst

 LDA cloudSize          \ Fetch the cloud size that we stored above, and store
 STA Q                  \ it in Q

 LDA INWK+34            \ Fetch byte #34 of the ship data block, which contains
                        \ the cloud counter

 BPL P%+4               \ If the cloud counter < 128, then we are in the first
                        \ half of the cloud's existence, so skip the next
                        \ instruction

 EOR #&FF               \ Flip the value of A so that in the second half of the
                        \ cloud's existence, A counts down instead of up

ENDIF

IF _CASSETTE_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _6502SP_VERSION \ Electron: The Master and Electron versions have half the number of explosion particles per vertex compared to the other versions

 LSR A                  \ Divide A by 8 so that is has a maximum value of 15
 LSR A
 LSR A

ELIF _ELECTRON_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION OR _NES_VERSION

 LSR A                  \ Divide A by 16 so that is has a maximum value of 7
 LSR A
 LSR A
 LSR A

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION \ Platform

 ORA #1                 \ Make sure A is at least 1 and store it in U, to
 STA U                  \ give us the number of particles in the explosion for
                        \ each vertex

 INY                    \ Increment the index in Y to point to byte #2

 LDA (XX19),Y           \ Fetch byte #2 of the ship line heap, which contains
 STA TGT                \ the explosion count for this ship (i.e. the number of
                        \ vertices used as origins for explosion clouds) and
                        \ store it in TGT

 LDA RAND+1             \ Fetch the current random number seed in RAND+1 and
 PHA                    \ store it on the stack, so we can re-randomise the
                        \ seeds when we are done

 LDY #6                 \ Set Y = 6 to point to the byte before the first vertex
                        \ coordinate we stored on the ship line heap above (we
                        \ increment it below so it points to the first vertex)

.EXL5

 LDX #3                 \ We are about to fetch a pair of coordinates from the
                        \ ship line heap, so set a counter in X for 4 bytes

.EXL3

 INY                    \ Increment the index in Y so it points to the next byte
                        \ from the coordinate we are copying

 LDA (XX19),Y           \ Copy the Y-th byte from the ship line heap to the X-th
 STA K3,X               \ byte of K3

 DEX                    \ Decrement the X index

 BPL EXL3               \ Loop back to EXL3 until we have copied all four bytes

                        \ The above loop copies the vertex coordinates from the
                        \ ship line heap to K3, reversing them as we go, so it
                        \ sets the following:
                        \
                        \   K3+3 = x_lo
                        \   K3+2 = x_hi
                        \   K3+1 = y_lo
                        \   K3+0 = y_hi

 STY CNT                \ Set CNT to the index that points to the next vertex on
                        \ the ship line heap

 LDY #2                 \ Set Y = 2, which we will use to point to bytes #3 to
                        \ #6, after incrementing it

                        \ This next loop copies bytes #3 to #6 from the ship
                        \ line heap into the four random number seeds in RAND to
                        \ RAND+3, EOR'ing them with the vertex index so they are
                        \ different for every vertex. This enables us to
                        \ generate random numbers for drawing each vertex that
                        \ are random but repeatable, which we need when we
                        \ redraw the cloud to remove it
                        \
                        \ Note that we haven't actually set the values of bytes
                        \ #3 to #6 in the ship line heap, so we have no idea
                        \ what they are, we just use what's already there. But
                        \ the fact that those bytes are stored for this ship
                        \ means we can repeat the random generation of the
                        \ cloud, which is the important bit

.EXL2

 INY                    \ Increment the index in Y so it points to the next
                        \ random number seed to copy

 LDA (XX19),Y           \ Fetch the Y-th byte from the ship line heap

 EOR CNT                \ EOR with the vertex index, so the seeds are different
                        \ for each vertex

ELIF _NES_VERSION

 ORA #1                 \ Make sure A is at least 1 and store it in U, to
 STA U                  \ give us the number of particles in the explosion for
                        \ each vertex

 LDY #7                 \ Fetch byte #7 of the ship blueprint, which contains
 LDA (XX0),Y            \ the explosion count for this ship (i.e. the number of
 STA TGT                \ vertices used as origins for explosion clouds) and
                        \ store it in TGT

 LDA RAND+1             \ Fetch the current random number seed in RAND+1 and
 PHA                    \ store it on the stack, so we can re-randomise the
                        \ seeds when we are done

 LDY #6                 \ Set Y = 6 to point to the byte before the first vertex
                        \ coordinate we stored on the XX3 heap above (we
                        \ increment it below so it points to the first vertex)

.EXL5

 LDX #3                 \ We are about to fetch a pair of coordinates from the
                        \ XX3 heap, so set a counter in X for 4 bytes

.dexp2

 INY                    \ Increment the index in Y so it points to the next byte
                        \ from the coordinate we are copying

 LDA XX3-7,Y            \ Copy byte Y-7 from the XX3 heap to the X-th byte of K3
 STA K3,X

 DEX                    \ Decrement the loop counter

 BPL dexp2              \ Keep copying vertex coordinates into K3 until we have
                        \ copied all six coordinates

                        \ The above loop copies the vertex coordinates from the
                        \ XX3 heap to K3, reversing them as we go, so it sets
                        \ the following:
                        \
                        \   K3+3 = x_lo
                        \   K3+2 = x_hi
                        \   K3+1 = y_lo
                        \   K3+0 = y_hi

 STY CNT                \ Set CNT to the index that points to the next vertex on
                        \ the XX3 heap

                        \ This next part copies bytes #37 to #40 from the ship
                        \ data block into the four random number seeds in RAND
                        \ to RAND+3, EOR'ing them with the vertex index so they
                        \ are different for every vertex. This enables us to
                        \ generate random numbers for drawing each vertex that
                        \ are random but repeatable, which we need when we
                        \ redraw the cloud to remove it
                        \
                        \ We set the values of bytes #37 to #40 randomly in the
                        \ LL9 routine before calling DOEXP, so the explosion
                        \ cloud is random but repeatable

 LDY #37                \ Set Y to act as an index into the ship data block for
                        \ byte #37

 LDA (INF),Y            \ Set the seed at RAND to byte #37, EOR'd with the
 EOR CNT                \ vertex index, so the seeds are different for each
 STA RAND               \ vertex

 INY                    \ Increment Y to point to byte #38

 LDA (INF),Y            \ Set the seed at RAND+1 to byte #38, EOR'd with the
 EOR CNT                \ vertex index, so the seeds are different for each
 STA RAND+1             \ vertex

 INY                    \ Increment Y to point to byte #39

 LDA (INF),Y            \ Set the seed at RAND+2 to byte #39, EOR'd with the
 EOR CNT                \ vertex index, so the seeds are different for each
 STA RAND+2             \ vertex

 INY                    \ Increment Y to point to byte #40

 LDA (INF),Y            \ Set the seed at RAND+3 to byte #49, EOR'd with the
 EOR CNT                \ vertex index, so the seeds are different for each
 STA RAND+3             \ vertex

 LDY U                  \ Set Y to the number of particles in the explosion for
                        \ each vertex, which we stored in U above. We will now
                        \ use this as a loop counter to iterate through all the
                        \ particles in the explosion

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _6502SP_VERSION \ Platform

 STA &FFFD,Y            \ Y is going from 3 to 6, so this stores the four bytes
                        \ in memory locations &00, &01, &02 and &03, which are
                        \ the memory locations of RAND through RAND+3

ELIF _MASTER_VERSION

IF _SNG47

 STA &FFFF,Y            \ Y is going from 3 to 6, so this stores the four bytes
                        \ in memory locations &02, &03, &04 and &05, which are
                        \ the memory locations of RAND through RAND+3

ELIF _COMPACT

 STA &0000,Y            \ Y is going from 3 to 6, so this stores the four bytes
                        \ in memory locations &03, &04, &05 and &06, which are
                        \ the memory locations of RAND through RAND+3

ENDIF

ELIF _C64_VERSION OR _APPLE_VERSION

 STA &FFFF,Y            \ Y is going from 3 to 6, so this stores the four bytes
                        \ in memory locations &02, &03, &04 and &05, which are
                        \ the memory locations of RAND through RAND+3

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION \ Platform

 CPY #6                 \ Loop back to EXL2 until Y = 6, which means we have
 BNE EXL2               \ copied four bytes

 LDY U                  \ Set Y to the number of particles in the explosion for
                        \ each vertex, which we stored in U above. We will now
                        \ use this as a loop counter to iterate through all the
                        \ particles in the explosion

ENDIF

IF _MASTER_VERSION OR _APPLE_VERSION \ Platform

 STY CNT2               \ Store the number of explosion particles in CNT2, to
                        \ use this as a loop counter to iterate through all the
                        \ particles in the explosion

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION OR _NES_VERSION \ Platform

.EXL4

ENDIF

IF _NES_VERSION

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _6502SP_VERSION \ Minor

 JSR DORND2             \ Set ZZ to a random number, making sure the C flag
 STA ZZ                 \ doesn't affect the outcome

ELIF _MASTER_VERSION OR _C64_VERSION OR _NES_VERSION

 CLC                    \ This contains the code from the DORND2 routine, so
 LDA RAND               \ this section is exactly equivalent to a JSR DORND2
 ROL A                  \ call, but is slightly faster as it's been inlined
 TAX                    \ (so it sets A and X to random values, making sure
 ADC RAND+2             \ the C flag doesn't affect the outcome)
 STA RAND
 STX RAND+2
 LDA RAND+1
 TAX
 ADC RAND+3
 STA RAND+1
 STX RAND+3

 STA ZZ                 \ Set ZZ to a random number

ELIF _APPLE_VERSION

 CLC                    \ This contains the code from the DORND2 routine, so
 LDA RAND               \ this section is exactly equivalent to a JSR DORND2
 ROL A                  \ call, but is slightly faster as it's been inlined
 TAX                    \ (so it sets A and X to random values, making sure
 ADC RAND+2             \ the C flag doesn't affect the outcome)
 STA RAND
 STX RAND+2
 LDA RAND+1
 TAX
 ADC RAND+3
 STA RAND+1
 STX RAND+3

ENDIF

IF _MASTER_VERSION \ Master: In the Master version, explosions are made up of yellow, red and cyan particles

 AND #3                 \ Set X to this random number, reduced to be in the
 TAX                    \ range 0-3

 LDA coltabl,X          \ Set the colour randomly to one of the four colours
 STA COL                \ in the coltabl table, so explosions are made up of
                        \ yellow, red and cyan particles

ELIF _APPLE_VERSION

 AND #%00001100         \ Set the colour randomly to one of the four colours
 ORA #16                \ 16, 20, 24 or 28, i.e. BLUE, RED, FUZZY or 28
 STA COL                \
                        \ A value of 28 will draw an explosion dot in a totally
                        \ random colour pattern, as the pixel byte will be taken
                        \ from MASKT+28, which contains code (specifically, the
                        \ start of the VLOIN routine)

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION \ Platform

 LDA K3+1               \ Set (A R) = (y_hi y_lo)
 STA R                  \           = y
 LDA K3

 JSR EXS1               \ Set (A X) = (A R) +/- random * cloud size
                        \           = y +/- random * cloud size

 BNE EX11               \ If A is non-zero, the particle is off-screen as the
                        \ coordinate is bigger than 255), so jump to EX11 to do
                        \ the next particle

 CPX #2*Y-1             \ If X > the y-coordinate of the bottom of the screen,
 BCS EX11               \ the particle is off the bottom of the screen, so jump
                        \ to EX11 to do the next particle

                        \ Otherwise X contains a random y-coordinate within the
                        \ cloud

 STX Y1                 \ Set Y1 = our random y-coordinate within the cloud

 LDA K3+3               \ Set (A R) = (x_hi x_lo)
 STA R
 LDA K3+2

 JSR EXS1               \ Set (A X) = (A R) +/- random * cloud size
                        \           = x +/- random * cloud size

 BNE EX4                \ If A is non-zero, the particle is off-screen as the
                        \ coordinate is bigger than 255), so jump to EX4 to do
                        \ the next particle

                        \ Otherwise X contains a random x-coordinate within the
                        \ cloud

 LDA Y1                 \ Set A = our random y-coordinate within the cloud

ELIF _NES_VERSION

 LDA K3+1               \ Set (A R) = (y_hi y_lo)
 STA R                  \           = y
 LDA K3

 JSR EXS1               \ Set (A X) = (A R) +/- random * cloud size
                        \           = y +/- random * cloud size

 BNE EX11               \ If A is non-zero, the particle is off-screen as the
                        \ coordinate is bigger than 255), so jump to EX11 to do
                        \ the next particle

 CPX Yx2M1              \ If X > the y-coordinate of the bottom of the screen
 BCS EX11               \ (which is in Yx2M1) then the particle is off the
                        \ bottom of the screen, so jump to EX11 to do the next
                        \ particle

                        \ Otherwise X contains a random y-coordinate within the
                        \ cloud

 STX Y1                 \ Set Y1 = our random y-coordinate within the cloud

 LDA K3+3               \ Set (A R) = (x_hi x_lo)
 STA R
 LDA K3+2

 JSR EXS1               \ Set (A X) = (A R) +/- random * cloud size
                        \           = x +/- random * cloud size

 BNE EX4                \ If A is non-zero, the particle is off-screen as the
                        \ coordinate is bigger than 255), so jump to EX11 to do
                        \ the next particle

                        \ Otherwise X contains a random x-coordinate within the
                        \ cloud

 LDA Y1                 \ Set A = our random y-coordinate within the cloud

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _C64_VERSION OR _MASTER_VERSION OR _NES_VERSION \ Minor

 JSR PIXEL              \ Draw a point at screen coordinate (X, A) with the
                        \ point size determined by the distance in ZZ

ELIF _6502SP_VERSION

 JSR PIXEL3             \ Draw a point at screen coordinate (X, A) with the
                        \ point size determined by the distance in ZZ

ELIF _APPLE_VERSION

 JSR CPIX               \ Draw a single pixel at screen coordinate (X, A) in the
                        \ colour in COL

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _C64_VERSION OR _NES_VERSION \ Platform

.EX4

 DEY                    \ Decrement the loop counter for the next particle

ELIF _MASTER_VERSION OR _APPLE_VERSION

.EX4

 DEC CNT2               \ Decrement the loop counter in CNT2 for the next
                        \ particle

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION \ Platform

 BPL EXL4               \ Loop back to EXL4 until we have done all the particles
                        \ in the cloud

 LDY CNT                \ Set Y to the index that points to the next vertex on
                        \ the ship line heap

 CPY TGT                \ If Y < TGT, which we set to the explosion count for
 BCC EXL5               \ this ship (i.e. the number of vertices used as origins
                        \ for explosion clouds), loop back to EXL5 to do a cloud
                        \ for the next vertex

 PLA                    \ Restore the current random number seed to RAND+1 that
 STA RAND+1             \ we stored at the start of the routine

ELIF _NES_VERSION

 BPL EXL4               \ Loop back to EXL4 until we have done all the particles
                        \ in the cloud

 LDY CNT                \ Set Y to the index that points to the next vertex on
                        \ the XX3 heap

 CPY TGT                \ If Y < TGT, which we set to the explosion count for
 BCC EXL5               \ this ship (i.e. the number of vertices used as origins
                        \ for explosion clouds), loop back to EXL5 to do a cloud
                        \ for the next vertex

 PLA                    \ Restore the current random number seed to RAND+1 that
 STA RAND+1             \ we stored at the start of the routine

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _APPLE_VERSION OR _MASTER_VERSION OR _NES_VERSION \ Platform

 LDA K%+6               \ Store the z_lo coordinate for the planet (which will
 STA RAND+3             \ be pretty random) in the RAND+3 seed

 RTS                    \ Return from the subroutine

.EX11

ELIF _C64_VERSION

 LDA K%+6               \ Store the z_lo coordinate for the planet (which will
 STA RAND+3             \ be pretty random) in the RAND+3 seed

 RTS                    \ Return from the subroutine

.PTCLS2S

 JMP PTCLS2             \ Jump to PTCLS2 to display the explosion sprite (this
                        \ JMP enables us to jump to PTCLS using a branch to
                        \ PTCLS2S though this isn't actually done anywhere)

.EX11

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _6502SP_VERSION \ Minor

 JSR DORND2             \ Set A and X to random numbers, making sure the C flag
                        \ doesn't affect the outcome

ELIF _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _NES_VERSION

 CLC                    \ This contains the code from the DORND2 routine, so
 LDA RAND               \ this section is exactly equivalent to a JSR DORND2
 ROL A                  \ call, but is slightly faster as it's been inlined
 TAX                    \ (so it sets A and X to random values, making sure
 ADC RAND+2             \ the C flag doesn't affect the outcome)
 STA RAND
 STX RAND+2
 LDA RAND+1
 TAX
 ADC RAND+3
 STA RAND+1
 STX RAND+3

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION OR _NES_VERSION \ Platform

 JMP EX4                \ We just skipped a particle, so jump up to EX4 to do
                        \ the next one

.EXS1

                        \ This routine calculates the following:
                        \
                        \   (A X) = (A R) +/- random * cloud size
                        \
                        \ returning with the flags set for the high byte in A

 STA S                  \ Store A in S so we can use it later

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _6502SP_VERSION \ Minor

 JSR DORND2             \ Set A and X to random numbers, making sure the C flag
                        \ doesn't affect the outcome

ELIF _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _NES_VERSION

 CLC                    \ This contains the code from the DORND2 routine, so
 LDA RAND               \ this section is exactly equivalent to a JSR DORND2
 ROL A                  \ call, but is slightly faster as it's been inlined
 TAX                    \ (so it sets A and X to random values, making sure
 ADC RAND+2             \ the C flag doesn't affect the outcome)
 STA RAND
 STX RAND+2
 LDA RAND+1
 TAX
 ADC RAND+3
 STA RAND+1
 STX RAND+3

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION OR _NES_VERSION \ Platform

 ROL A                  \ Set A = A * 2

 BCS EX5                \ If bit 7 of A was set (50% chance), jump to EX5

 JSR FMLTU              \ Set A = A * Q / 256
                        \       = random << 1 * projected cloud size / 256

 ADC R                  \ Set (A X) = (S R) + A
 TAX                    \           = (S R) + random * projected cloud size
                        \
                        \ where S contains the argument A, starting with the low
                        \ bytes

 LDA S                  \ And then the high bytes
 ADC #0

 RTS                    \ Return from the subroutine

.EX5

 JSR FMLTU              \ Set T = A * Q / 256
 STA T                  \       = random << 1 * projected cloud size / 256

 LDA R                  \ Set (A X) = (S R) - T
 SBC T                  \
 TAX                    \ where S contains the argument A, starting with the low
                        \ bytes

 LDA S                  \ And then the high bytes
 SBC #0

ENDIF

 RTS                    \ Return from the subroutine

