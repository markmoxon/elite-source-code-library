\ ******************************************************************************
\
\       Name: HALL
\       Type: Subroutine
\   Category: Ship hanger
IF _DISC_DOCKED \ Comment
\    Summary: Draw the ships in the ship hanger, then draw the hanger
ELIF _6502SP_VERSION
\    Summary: Draw the ships in the ship hanger, then draw the hanger by sending
\             an OSWORD 248 command to the I/O processor
ENDIF
\
\ ------------------------------------------------------------------------------
\
\ Half the time this will draw one of the four pre-defined ship hanger groups in
\ HATB, and half the time this will draw a solitary Sidewinder, Mamba, Krait or
\ Adder on a random position. In all cases, the ships will be randomly spun
\ around on the ground so they can face in any dirction, and larger ships are
\ drawn higher up off the ground than smaller ships.
\
\ The ships are drawn by the HAS1 routine, which uses the normal ship-drawing
\ routine in LL9, and then the hanger background is drawn by sending an OSWORD
\ 248 command to the I/O processor.
\
\ ******************************************************************************

.HALL

IF _6502SP_VERSION \ Screen

 LDA #0                 \ Send a #SETVDU19 0 command to the I/O processor to
 JSR DOVDU19            \ switch to the mode 1 palette for the space view,
                        \ which is yellow (colour 1), red (colour 2) and cyan
                        \ (colour 3)

ENDIF

IF _6502SP_VERSION \ Comment

 JSR UNWISE             \ Call UNWISE, which does nothing in the 6502 Second
                        \ Processor version of Elite (this routine does have a
                        \ function in the disc version that isn't required here,
                        \ so the authors presumably just cleared out the UNWISE
                        \ routine rather than unplumbing it from the code)

ELIF _DISC_DOCKED

 JSR UNWISE             \ Call UNWISE to switch the main line-drawing routine
                        \ between EOR and OR logic (in this case, switching it
                        \ to OR logic so that it overwrites anything that's
                        \ on-screen)

ENDIF

 LDA #0                 \ Clear the top part of the screen, draw a white border,
 JSR TT66               \ and set the current view type in QQ11 to 0 (space
                        \ view)

 JSR DORND              \ Set A and X to random numbers

 BPL HA7                \ Jump to HA7 if A is positive (50% chance)

 AND #3                 \ Reduce A to a random number in the range 0-3

 STA T                  \ Set X = A * 8 + A
 ASL A                  \       = 9 * A
 ASL A                  \
 ASL A                  \ so X is a random number, either 0, 9, 18 or 27
 ADC T
 TAX

                        \ The following double loop calls the HAS1 routine three
                        \ times to display three ships on screen. For each call,
                        \ the values passed to HAS1 in XX15+2 to XX15 are taken
                        \ from the HATB table, depending on the value in X, as
                        \ follows:
                        \
                        \   * If X = 0,  pass bytes #0 to #2 of HATB to HAS1
                        \                then bytes #3 to #5
                        \                then bytes #6 to #8
                        \
                        \   * If X = 9,  pass bytes  #9 to #11 of HATB to HAS1
                        \                then bytes #12 to #14
                        \                then bytes #15 to #17
                        \
                        \   * If X = 18, pass bytes #18 to #20 of HATB to HAS1
                        \                then bytes #21 to #23
                        \                then bytes #24 to #26
                        \
                        \   * If X = 27, pass bytes #27 to #29 of HATB to HAS1
                        \                then bytes #30 to #32
                        \                then bytes #33 to #35
                        \
                        \ Note that the values are passed in reverse, so for the
                        \ first call, for example, where we pass bytes #0 to #2
                        \ of HATB to HAS1, we call HAS1 with:
                        \
                        \   XX15   = HATB+2
                        \   XX15+1 = HATB+1
                        \   XX15+2 = HATB

 LDY #3                 \ Set CNT2 = 3 to act as an outer loop counter going
 STY CNT2               \ from 3 to 1, so the HAL8 loop is run 3 times

.HAL8

 LDY #2                 \ Set Y = 2 to act as an inner loop counter going from
                        \ 2 to 0

.HAL9

 LDA HATB,X             \ Copy the X-th byte of HATB to the Y-th byte of XX15,
 STA XX15,Y             \ as described above

 INX                    \ Increment X to point to the next byte in HATB

 DEY                    \ Decrement Y to point to the previous byte in XX15

 BPL HAL9               \ Loop back to copy the next byte until we have copied
                        \ three of them (i.e. Y was 3 before the DEY)

 TXA                    \ Store X on the stack so we can retrieve it after the
 PHA                    \ call to HAS1 (as it contains the index of the next
                        \ byte in HATB

 JSR HAS1               \ Call HAS1 to draw this ship in the hanger

 PLA                    \ Restore the value of X, so X points to the next byte
 TAX                    \ in HATB after the three bytes we copied into XX15

 DEC CNT2               \ Decrement the outer loop counter in CNT2

 BNE HAL8               \ Loop back to HAL8 to do it 3 times, once for each ship
                        \ in the HATB table

 LDY #128               \ Set Y = 128 to send as byte #2 of the parameter block
                        \ to the OSWORD 248 command below, to tell the I/O
                        \ processor that there are multiple ships in the hanger

 BNE HA9                \ Jump to HA9 to display the ship hanger (this BNE is
                        \ effectively a JMP as Y is never zero)

.HA7

                        \ If we get here, A is a positive random number in the
                        \ range 0-127

 LSR A                  \ Set XX15+1 = A / 2 (random number 0-63)
 STA XX15+1

 JSR DORND              \ Set XX15 = random number 0-255
 STA XX15

IF _DISC_DOCKED \ Enhanced: The ship hanger has a 50% chance of displaying a group of ships, and a 50% chance of displaying a solitary ship. In the disc version, this latter option can display no ship at all, or it can show a solitary cargo canister, Shuttle, Transporter, Cobra Mk III, Python, Viper or Krait; in the 6502SP version there is always a ship, and it's a Sidewinder, Mamba, Krait or Adder

 JSR DORND              \ Set XX15+2 = random number 0-7
 AND #7                 \
 STA XX15+2             \ which is either 0 (no ships in the hanger) or one of
                        \ the first 7 ship types in the ship hanger blueprints
                        \ table, i.e. a cargo canister, Shuttle, Transporter,
                        \ Cobra Mk III, Python, Viper or Krait

 JSR HAS1               \ Call HAS1 to draw this ship in the hanger, with the
                        \ the following properties:
                        \
                        \   * Random x-coordinate from -63 to +63
                        \
                        \   * Randomly chosen cargo canister, Shuttle,
                        \     Transporter, Cobra Mk III, Python, Viper or Krait
                        \
                        \   * Random z-coordinate from +256 to +639

ELIF _6502SP_VERSION

 JSR DORND              \ Set XX15+2 = #SH3 + random number 0-3
 AND #3                 \
 ADC #SH3               \ which is the ship type of a Sidewinder, Mamba, Krait
 STA XX15+2             \ or Adder

 JSR HAS1               \ Call HAS1 to draw this ship in the hanger, with the
                        \ the following properties:
                        \
                        \   * Random x-coordinate from -63 to +63
                        \
                        \   * Randomly chosen Sidewinder, Mamba, Krait or Adder
                        \
                        \   * Random z-coordinate from +256 to +639

ENDIF

 LDY #0                 \ Set Y = 0 to use in the following instruction, to tell
                        \ the hanger-drawing routine that there is just one ship
                        \ in the hanger, so it knows not to draw between the
                        \ ships

.HA9

IF _6502SP_VERSION \ Minor

 STY HANG+2             \ Store Y in byte #2 of the parameter block to the
                        \ OSWORD 248 command below, to specify whether there
                        \ are multiple ships in the hanger

 JSR UNWISE             \ Call UNWISE, which (as noted above) does nothing in
                        \ the 6502 Second Processor version of Elite

ELIF _DISC_DOCKED

 STY YSAV               \ Store Y in YSAV to specify whether there are multiple
                        \ ships in the hanger

 JSR UNWISE             \ Call UNWISE to switch the main line-drawing routine
                        \ between EOR and OR logic (in this case, switching it
                        \ back to EOR logic so that we can erase anything we
                        \ draw on-screen)

ENDIF

IF _6502SP_VERSION \ Tube

 LDA #248               \ Set A in preparation for sending an OSWORD 248 command

 LDX #LO(HANG)          \ Set (Y X) to point to the HANG parameter block
 LDY #HI(HANG)

 JMP OSWORD             \ Send an OSWORD 248 command to the I/O processor to
                        \ draw the ship hanger, returning from the subroutine
                        \ using a tail call

.HANG

 EQUB 3                 \ The number of bytes to transmit with this command

 EQUB 0                 \ The number of bytes to receive with this command

 EQUB 0                 \ Multiple ship flag:
                        \
                        \   * 0 = there is just one ship in the hanger
                        \
                        \   * 128 = there are multiple ships in the hanger

ELIF _DISC_DOCKED

                        \ Fall through into HANGER to draw the hanger background

ENDIF

