\ ******************************************************************************
\
\       Name: ships_ag
\       Type: Subroutine
\   Category: Encyclopedia
\    Summary: Show the Ships A-G or Ships K-W menu and display the chosen ship
\             card
\  Deep dive: The Encyclopedia Galactica
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The menu to show:
\
\                         * 1 = Show the Ships A-G menu
\
\                         * 2 = Show the Ships K-W menu
\
\   C flag              Set if this is the second menu (Ships K-W)
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   ships_kw            Does exactly the same as a call to ships_kw
\
\ ******************************************************************************

.ships_ag

.ships_kw

 PHA                    \ Store the menu number on the stack

 TAX                    \ Call menu with X = A to show the correct menu, so A
 JSR menu               \ is now set to the type of ship card we need to show,
                        \ depending on which ships menu we just displayed:
                        \
                        \   * 1 for Adder to 14 for Ghavial
                        \   * 1 for Iguana to 14 for Worm

 SBC #0                 \ Decrement A so it is now in the range 0 to 13 (as menu
                        \ clears the C flag when the number entered is within
                        \ range), so we now have:
                        \
                        \   * 0 for Adder to 13 for Ghavial
                        \   * 0 for Iguana to 13 for Worm

 PLP                    \ Pull the menu number from the stack into the processor
                        \ flags, which will set the C flag to bit 0 of the value
                        \ on the stack (so if we called the routine with A = 1,
                        \ the C flag will be set, and if we called it with A = 2
                        \ it will be clear)

 BCS ship_over          \ If the C flag is set, then we called the routine with
                        \ A = 1, so jump to ship_over as the choice number is
                        \ already correct (i.e. 0 for Adder to 13 for Ghavial)

 ADC menu_entry+1       \ We just showed the second menu, so the choice number
                        \ is currently:
                        \
                        \   * 0 for Iguana to 13 for Worm
                        \
                        \ which is not right - we want the range to follow on
                        \ from the end of the first menu. To fix this, we need
                        \ to add the number of entries in the first menu to A
                        \ to get the correct choice number. The menu_entry table
                        \ contains the menu sizes, and menu_entry+1 contains the
                        \ size of menu 1 (the Ships A-G menu), so this adds the
                        \ number of entries in the first menu to give the
                        \ correct choice range, as follows:
                        \
                        \   * 14 for Iguana to 27 for Worm

.ship_over

 STA TYPE               \ A contains the ship that we just chose from the Ships
                        \ menu, so store it in TYPE, so TYPE is now:
                        \
                        \   * 0 for Adder to 27 for Worm

 CLC                    \ Store type + 7 on the stack, to give the token number
 ADC #7                 \ of the title to show for the relevant ship card, from
 PHA                    \ Adder (token 7) to Worm (token 34)

 LDA #32                \ Clear the top part of the screen, draw a white border,
 JSR TT66               \ and set the current view type in QQ11 to 32

 JSR MT1                \ Switch to ALL CAPS when printing extended tokens

IF _ELITE_A_ENCYCLOPEDIA

 LDX TYPE               \ Set A to the letter of the relevant ship blueprints
 LDA ship_file,X        \ file that we need to load for this ship card (fetched
                        \ from the ship_file table)

 CMP ship_load+4        \ If the fifth character of the OS command in ship_load
 BEQ ship_skip          \ already matches the ship blueprints file letter, then
                        \ we've already loaded this file, so jump to ship_skip
                        \ to skip the following instruction

 STA ship_load+4        \ Store the file letter in the fifth byte of ship_load,
                        \ which replaces the "0" in "L.S.0" with the relevant
                        \ letter (so if the letter is M, for example, the
                        \ command will become "L.S.M" to load the S.M file)

 LDX #LO(ship_load)     \ Set (Y X) to point to ship_load (the updated "L.S.0"
 LDY #HI(ship_load)     \ command)

 JSR OSCLI              \ Call OSCLI to run the OS command in ship_load, which
                        \ loads the ship blueprints file that contains the ship
                        \ we want to display

.ship_skip

ELIF _ELITE_A_6502SP_PARA

 LDX TYPE               \ Set X to the number of this ship type within the
 LDA ship_posn,X        \ ship_list table, so we can pass it to the install_ship
 TAX                    \ routine

 LDY #0                 \ Install this ship into blueprint position 0 so we can
 JSR install_ship       \ show it on the ship card

ENDIF

 LDX TYPE               \ Set A to the card's title x-coordinate (fetched from
 LDA ship_centre,X      \ the ship_centre table)

 STA XC                 \ Move the text cursor to the correct column for the
                        \ title

 PLA                    \ Pull the token number for the title from the stack
 JSR write_msg3         \ (type + 7) and print it

 JSR NLIN4              \ Draw a horizontal line at pixel row 19 to box in the
                        \ title

 JSR ZINF               \ Call ZINF to reset the INWK ship workspace, so we can
                        \ spawn a rotating ship to display in the centre of the
                        \ ship card

 LDA #&60               \ Set byte #14 (nosev_z_hi) to 1 (&60), so the ship will
 STA INWK+14            \ be pointing away from us

 LDA #176               \ Set z_hi = 176 (very far away)
 STA INWK+7

 LDX #127               \ Set roll counter = 127, so don't dampen the roll and
 STX INWK+29            \ make the roll direction clockwise

 STX INWK+30            \ Set pitch counter = 127, so don't dampen the pitch and
                        \ set the pitch direction to dive

 INX                    \ Set X = 128

 STA QQ17               \ Set QQ17 = %10110000, which has bit 7 set, to
                        \ switch standard tokens to Sentence Case

 LDA TYPE               \ Call write_card to display the ship card for the ship
 JSR write_card         \ type in TYPE

IF _ELITE_A_ENCYCLOPEDIA

 LDX TYPE               \ Set A to the number of this ship blueprint within the
 LDA ship_posn,X        \ ship blueprints file that we loaded (fetched from the
                        \ ship_posn table)

 JSR NWSHP              \ Add a new ship of type A to the local bubble (or, in
                        \ this case, the encyclopedia ship card)

.l_release

 JSR RDKEY              \ Scan the keyboard for a key press and return the
                        \ internal key number in A and X (or 0 for no key press)

 BNE l_release          \ If a key is being pressed, loop back to l_release
                        \ until it is released

ELIF _ELITE_A_6502SP_PARA

 LDA #0                 \ Add a new ship of type 0 to the local bubble (or, in
 JSR NWSHP              \ this case, the encyclopedia ship card), which will
                        \ spawn the correct shop for this ship card, as we
                        \ installed the correct blueprint into position 0 with
                        \ the call to install_ship above

 JSR l_release          \ Call l_release so if a key is currently being pressed,
                        \ we wait until it is released before continuing

ENDIF

.l_395a

 LDX TYPE               \ Set A to the closest distance that we want to show the
 LDA ship_dist,X        \ ship (fetched from the ship_dist table)

 CMP INWK+7             \ If z_hi (the ship's distance) is equal to A, skip the
 BEQ P%+4               \ following decrement, as the ship is already close
                        \ enough

 DEC INWK+7             \ Decrement the ship's distance, to bring the ship
                        \ a bit closer to us

 JSR MVEIT              \ Move the ship in space according to the orientation
                        \ vectors and the new value in z_hi

 LDA #128               \ Set z_lo = 128, so the closest the ship gets to us is
 STA INWK+6             \ z_hi * 256 + 128 (where z_hi is the value in the
                        \ ship_dist table)

 ASL A                  \ Set A = 0

 STA INWK               \ Set x_lo = 0, so the ship remains in the screen centre

 STA INWK+3             \ Set y_lo = 0, so the ship remains in the screen centre

 JSR LL9                \ Call LL9 to display the ship

 DEC MCNT               \ Decrement the main loop counter

IF _ELITE_A_ENCYCLOPEDIA

 JSR WSCAN              \ Call WSCAN to wait for the vertical sync, so the ship
                        \ rotates smoothly

 JSR RDKEY              \ Scan the keyboard for a key press and return the
                        \ internal key number in A and X (or 0 for no key press)

 BEQ l_395a             \ If no key is being pressed, loop back to l_395a to
                        \ keep rotating the ship

ELIF _ELITE_A_6502SP_PARA

 JSR check_keys         \ Call check_keys to wait until a key is pressed,
                        \ quitting the game if the game if COPY (pause) and
                        \ ESCAPE are pressed

 CPX #0                 \ If check_keys returns with X = 0, then we paused the
 BEQ l_395a             \ game with COPY and then unpaused it with DELETE, in
                        \ which case loop back to l_395a to keep rotating the
                        \ ship

ENDIF

 JMP BAY                \ Otherwise a key was pressed, so jump to BAY to go to
                        \ the docking bay (i.e. show the Encyclopedia screen)

