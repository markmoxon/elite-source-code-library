\ ******************************************************************************
\
\       Name: cour_buy
\       Type: Subroutine
\   Category: Missions
\    Summary: Show the Special Cargo screen (CTRL-f1)
\  Deep dive: Special cargo missions
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   cour_loop           The start of the loop for displaying mission menu items
\
\   cour_menu           Display the mission menu and process the choice
\
\ ******************************************************************************

.cour_buy

 LDA cmdr_cour          \ If there is no special cargo delivery mission in
 ORA cmdr_cour+1        \ progress, then the mission reward in cmdr_cour(1 0)
 BEQ cour_start         \ will be zero, so jump to cour_start to skip the next
                        \ instruction

 JMP jmp_start3         \ There is already a special cargo delivery mission in
                        \ progress, so jump to jmp_start3 to make a beep and
                        \ show the cargo bay

.cour_start

 LDA #10                \ Move the text cursor to column 10
 STA XC

 LDA #111               \ Print extended recursive token 111 ("{all caps}SPECIAL
 JSR DETOK              \ CARGO")

 JSR NLIN4              \ Draw a horizontal line at pixel row 19 to box in the
                        \ title

IF _ELITE_A_DOCKED

 JSR vdu_80             \ Call vdu_80 to switch to Sentence Case

ELIF _ELITE_A_6502SP_PARA

 LDA #%10000000         \ Set bit 7 of QQ17 to switch standard tokens to
 STA QQ17               \ Sentence Case

ENDIF

 LDA QQ26               \ Set INWK = the random market seed for this system in
 EOR QQ0                \ QQ26, EOR'd with the current system's galactic
 EOR QQ1                \ x-coordinate in QQ0, the current system's galactic
 EOR FIST               \ y-coordinate in QQ1, our legal status in FIST, and
 EOR TALLY              \ the low byte of our combat rank, which should give us
 STA INWK               \ a pretty random number that will stay the same until
                        \ we leave the station
                        \
                        \ We use this to determine the number of systems to skip
                        \ when generating the first delivery mission in the menu

 SEC                    \ Set INWK+1 = 1 + our legal status in FIST + the
 LDA FIST               \ current galaxy number in GCNT + the type of our
 ADC GCNT               \ current ship in cmdr_type, which again will give us
 ADC cmdr_type          \ a random number that will stay the same until we
 STA INWK+1             \ leave the station, as well as randomising the C flag
                        \
                        \ We use this to determine the number of systems to skip
                        \ when generating subsequent delivery missions in the
                        \ menu

 ADC INWK               \ Set QQ25 = INWK+1 + INWK + C - cmdr_courx - cmdr_coury
 SBC cmdr_courx         \
 SBC cmdr_coury         \ where (cmdr_courx, cmdr_coury) are the coordinates of
 AND #15                \ the previous special cargo delivery destination (which
 STA QQ25               \ will be (0, 0) if this is the first) and reduce the
                        \ result to be in the range 0 to 15
                        \
                        \ We use this to determine the maximum number of
                        \ delivery missions in the menu

 BEQ cour_pres          \ If the value of QQ25 = 0, jump to cour_pres to make a
                        \ beep and show the cargo bay (as QQ25 contains the
                        \ number of missions in the menu, so if it's zero we
                        \ have nothing more to do)

 LDA #0                 \ Set INWK+3 = 0 to act as a counter of the number of
 STA INWK+3             \ delivery missions we have displayed in the menu so far

 STA INWK+6             \ Set INWK+6 = 0 to act as a system counter that runs
                        \ from 0 to 255 as we work our way through all the
                        \ systems in the galaxy

 JSR TT81               \ Set the seeds in QQ15 to those of system 0 in the
                        \ current galaxy (i.e. copy the seeds from QQ21 to QQ15)

                        \ We now iterate around the cour_loop loop, working our
                        \ way through systems in the galaxy and picking suitable
                        \ destinations for display in the Special Cargo menu. We
                        \ use the following counters as we go:
                        \
                        \   * QQ25 contains the maximum number of delivery
                        \     missions to display in the menu
                        \
                        \   * INWK is the number of systems we skip past for the
                        \     very first menu item, when generating destinations
                        \     in cour_count
                        \
                        \   * INWK+1 is the number of systems we skip past for
                        \     subsequent menu items, when generating
                        \     destinations in cour_count
                        \
                        \   * INWK+3 counts the number of delivery missions we
                        \     have already displayed in the menu, starting at 0
                        \
                        \   * INWK+6 contains the system number we are currently
                        \     considering, starting at 0 and working through to
                        \     255, at which point we are done (even if we
                        \     haven't managed to find QQ25 delivery missions)

.cour_loop

 LDA INWK+3             \ If INWK+3 < QQ25 then call cour_count to add another
 CMP QQ25               \ destination to the menu, as we have not yet shown QQ25
 BCC cour_count         \ delivery missions in the menu (cour_count ends with a
                        \ jump back to cour_loop)

.cour_menu

                        \ If we get here then we have either got QQ25 items in
                        \ the menu, or we have worked our way through the whole
                        \ galaxy, so in either case we have finished displaying
                        \ the menu of destinations, and we want to process the
                        \ choice

 JSR CLYNS              \ Clear the bottom three text rows of the upper screen,
                        \ and move the text cursor to the first cleared row

 LDA #206               \ Print recursive token 46 (" CARGO{sentence case}")
 JSR prq                \ followed by a question mark

 JSR gnum               \ Call gnum to get a number from the keyboard, which
                        \ will be the menu item number of the mission we want to
                        \ take, returning the number entered in A and R, and
                        \ setting the C flag if the number is bigger than the
                        \ highest menu item number in QQ25

 BEQ cour_pres          \ If no number was entered, jump to cour_pres to make a
                        \ beep and show the cargo bay

 BCS cour_pres          \ If the number entered was too big, jump to cour_pres
                        \ to make a beep and show the cargo bay

 TAX                    \ Set X = A - 1, so X is now 0 if we picked the first
 DEX                    \ destination, 1 if we picked the second, and so on

 CPX INWK+3             \ If X >= INWK+3 then the number entered is bigger than
 BCS cour_pres          \ the number of entries in the menu, so jump to
                        \ cour_pres to make a beep and show the cargo bay

 LDA #2                 \ Move the text cursor to column 2
 STA XC

 INC YC                 \ Move the text cursor down one line

 STX INWK               \ Set INWK to the number of the chosen mission

 LDY &0C50,X            \ Set (Y X) to the cost of this mission in
 LDA &0C40,X            \ (&0C50+X &0C40+X)
 TAX

 JSR LCASH              \ Subtract (Y X) cash from the cash pot, but only if
                        \ we have enough cash

 BCS cour_cash          \ If the transaction was successful, we have just bought
                        \ ourselves a delivery mission, so jump to cour_cash

 JMP cash_query         \ Otherwise we didn't have enough cash, so jump to
                        \ cash_query to print "CASH?", make a short, high beep,
                        \ wait for 1 second and go to the docking bay (i.e. show
                        \ the Status Mode screen)

.cour_cash

                        \ We have now taken on the delivery mission, so we need
                        \ to set variables that govern the mission progress,
                        \ i.e. the destination and the mission reward

 LDX INWK               \ Set X to the number of the chosen mission which we
                        \ stored in INWK above

 LDA &0C00,X            \ Set cmdr_courx to the galactic x-coordinate of the
 STA cmdr_courx         \ destination of the chosen mission, which we stored in
                        \ &0C00+X when setting up the menu

 LDA &0C10,X            \ Set cmdr_coury to the galactic y-coordinate of the
 STA cmdr_coury         \ destination of the chosen mission, which we stored in
                        \ &0C10+X when setting up the menu

 CLC                    \ When setting up the menu, we set &0C20+X to the legal
 LDA &0C20,X            \ status of taking this mission, so we add this value to
 ADC FIST               \ our legal status in FIST, so taking on dodgy delivery
 STA FIST               \ missions adversely affects our legal status

 LDA &0C30,X            \ Set the mission reward in cmdr_cour(1 0) to the value
 STA cmdr_cour+1        \ we set in (&0C30+X &0C40+X) when setting up the menu
 LDA &0C40,X
 STA cmdr_cour

.cour_pres

 JMP jmp_start3         \ Jump to jmp_start3 to make a beep and show the cargo
                        \ bay

