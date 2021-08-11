\ ******************************************************************************
\
\       Name: b_14
\       Type: Subroutine
\   Category: Keyboard
\    Summary: Scan the Delta 14b joystick buttons
\
\ ------------------------------------------------------------------------------
\
\ Scan the Delta 14b for the flight key given in register Y, where Y is the
\ offset into the KYTB table above (so this is the same approach as in DKS1).
\
\ The keys on the Delta 14b are laid out as follows (the top two fire buttons
\ are treated the same as the top button in the middle row):
\
\   Fire laser                                    Fire laser
\
\   Slow down              Fire laser             Speed up
\   Unarm Missile          Fire Missile           Target missile
\   Hyperspace Unit        E.C.M.                 Escape pod
\   Docking computer on    In-system jump         Docking computer off
\
\ Arguments:
\
\   Y                   The offset into the KYTB table of the key that we want
\                       to scan on the Delta 14b
\
\ ******************************************************************************

.b_13

 LDA #0                 \ Set A = 0 for the second pass through the following,
                        \ so we can check the joystick plugged into the rear
                        \ socket of the Delta 14b adaptor

.b_14

                        \ This is the entry point for the routine, which is
                        \ called with A = 128 (the value of BTSK when the Delta
                        \ 14b is enabled), and if the key we are checking has a
                        \ corresponding button on the Delta 14b, it is run a
                        \ second time with A = 0

 TAX                    \ Store A in X so we can restore it below

 EOR b_table-1,Y        \ We now EOR the value in A with the Y-th entry in
 BEQ b_quit             \ b_table, and jump to b_quit to return from the
                        \ subroutine if the table entry is 128 (&80) - in other
                        \ words, we quite if Y is the offset for the roll and
                        \ pitch controls

                        \ If we get here, then the offset in Y points to a
                        \ control with a corresponding button on the Delta 14b,
                        \ and we pass through the following twice, once with a
                        \ starting value of A = 128, and again with a starting
                        \ value of A = 0
                        \
                        \ On the first pass, the EOR will set A to the value
                        \ from b_table but with bit 7 set, which means we scan
                        \ the joystick plugged into the side socket of the
                        \ Delta 14b adaptor
                        \
                        \ On the second pass, the EOR will set A to the value
                        \ from b_table (i.e. with bit 7 clear), which means we
                        \ scan the joystick plugged into the rear socket of the
                        \ Delta 14b adaptor

 STA VIA+&60            \ Set 6522 User VIA output register ORB (SHEILA &60) to
                        \ the value in A, which tells the Delta 14b adaptor box
                        \ that we want to read the buttons specified in PB4 to
                        \ PB7 (i.e. bits 4-7), as follows:
                        \
                        \ On the side socket joystick (bit 7 set):
                        \
                        \   %1110 = read buttons in left column   (bit 4 clear)
                        \   %1101 = read buttons in middle column (bit 5 clear)
                        \   %1011 = read buttons in right column  (bit 6 clear)
                        \
                        \ On the rear socket joystick (bit 7 clear):
                        \
                        \   %0110 = read buttons in left column   (bit 4 clear)
                        \   %0101 = read buttons in middle column (bit 5 clear)
                        \   %0011 = read buttons in right column  (bit 6 clear)

 AND #%00001111         \ We now read the 6522 User VIA to fetch PB0 to PB3 from
 AND VIA+&60            \ the user port (PB0 = bit 0 to PB3 = bit 4), which
                        \ tells us whether any buttons in the specified column
                        \ are being pressed, and if they are, in which row. The
                        \ values read are as follows:
                        \
                        \   %1111 = no button is being pressed in this column
                        \   %1110 = button pressed in top row    (bit 0 clear)
                        \   %1101 = button pressed in second row (bit 1 clear)
                        \   %1011 = button pressed in third row  (bit 2 clear)
                        \   %0111 = button pressed in bottom row (bit 3 clear)
                        \
                        \ In other words, if a button is being pressed in the
                        \ top row in the previously specified column, then PB0
                        \ (bit 0) will go low in the value we read from the user
                        \ port

 BEQ b_pressed          \ In the above we AND'd the result from the user port
                        \ with the bottom four bits of the table value (the
                        \ lower nibble). The lower nibble in b_table contains
                        \ a 1 in the relevant position for that row that
                        \ corresponds with the clear bit in the response from
                        \ the user port, so if we AND the two together and get
                        \ a zero, that means that button is being pressed, in
                        \ which case we jump to b_pressed to update the key
                        \ logger for that button
                        \
                        \ For example, take the b_table entry for the escape pod
                        \ button, in the right column and third row. The value
                        \ in b_table is &34. The top nibble contains the column,
                        \ which is &3 = %011, which means in the STA VIA+&60
                        \ above, we write %1011 in the first pass (when A = 128)
                        \ to set the right column for the side socket joystick,
                        \ and we write %0011 in the first pass (when A = 0) to
                        \ set the right column for the rear socket joystick
                        \
                        \ Now for the row. The lower nibble of the &34 value
                        \ from b_table contains the row, so that's &4 = %0100.
                        \ When we read the user port, then we will fetch %1011
                        \ from VIA+&60 if the button in the third row is being
                        \ pressed, so when we AND the two together, we get:
                        \
                        \   %0100 AND %1011 = 0
                        \
                        \ which will indicate the button is being pressed. If
                        \ any other button is being pressed, or no buttons at
                        \ all, then the result will be non-zero and we move on
                        \ to the next buttton

 TXA                    \ Restore the original value of A that we stored in X

 BMI b_13               \ If we just did the above with A = 128, then loop back
                        \ to b_13 to do it again with A = 0

IF _ELITE_A_FLIGHT

 RTS                    \ Return from the subroutine

ELIF _ELITE_A_6502SP_IO

 BPL b_quit             \ Jump to b_quit to return the result over the Tube (the
                        \ BPL is effectively a JMP as we just passed through the
                        \ BMI above)

ENDIF


