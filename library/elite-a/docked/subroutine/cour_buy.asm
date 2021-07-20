\ ******************************************************************************
\
\       Name: cour_buy
\       Type: Subroutine
\   Category: Missions
\    Summary: Show the Special Cargo screen (CTRL-f1)
\
\ ******************************************************************************

.cour_buy

 LDA cmdr_cour          \ If there is no special cargo delivery mission in
 ORA cmdr_cour+1        \ progress, then the mission timer in cmdr_cour(1 0)
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

 LDA INWK+3             \ If INWK+3 < QQ25 then jump to cour_count to add
 CMP QQ25               \ another destination to the menu, as we have not yet
 BCC cour_count         \ shown QQ25 delivery missions in the menu

.cour_menu

                        \ If we get here then we have either got QQ25 items in
                        \ the menu, or we have worked our way through the whole
                        \ galaxy, so in either case we want to display the menu
                        \ of destinations

 JSR CLYNS              \ Clear the bottom three text rows of the upper screen,
                        \ and move the text cursor to column 1 on row 21, i.e.
                        \ the start of the top row of the three bottom rows

 LDA #206               \ Print recursive token 206 (" CR") followed by a
 JSR prq                \ question mark

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
                        \ delay for 1 second and go to the docking bay (i.e.
                        \ show the Status Mode screen)

.cour_cash

                        \ We have now taken on the delivery mission, so we need
                        \ to set variables that govern the mission progress,
                        \ i.e. the destination and the mission timer

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

 LDA &0C30,X            \ Set the mission timer in cmdr_cour(1 0) to the value
 STA cmdr_cour+1        \ we set in (&0C30+X &0C40+X) when setting up the menu
 LDA &0C40,X
 STA cmdr_cour

.cour_pres

 JMP jmp_start3         \ Jump to jmp_start3 to make a beep and show the cargo
                        \ bay

.cour_count

                        \ If we get here then we want to display another item
                        \ in the menu, so first we need to skip our way through
                        \ the number of systems given in INWK

 JSR TT20               \ We want to move on to the next system, so call TT20
                        \ to twist the three 16-bit seeds in QQ15

 INC INWK+6             \ We also increment the counter in INWK+6 to point to
                        \ the next system

 BEQ cour_menu          \ If INWK+6 has wrapped around back to 0, then we have
                        \ worked our way through the entire galaxy, so jump to
                        \ cour_menu to display the menu

 DEC INWK               \ Loop back to keep twisting the seeds until we have
 BNE cour_count         \ stepped through the number of systems in INWK

                        \ We now have a system that we can consider for
                        \ inclusion in the destination menu

 LDX INWK+3             \ Set X = INWK+3, which counts the number of delivery
                        \ missions we have already displayed in the menu, and
                        \ which we can use as an index when populating the menu
                        \ data in &0C00 below

 LDA QQ15+3             \ Fetch the s1_hi seed of the system we are considering
                        \ adding to the menu into A, which gives us the galactic
                        \ x-coordinate of the system we are considering

 CMP QQ0                \ If the x-coordinate of the system we are considering
 BNE cour_star          \ is different to the current system's galactic
                        \ x-coordinate in QQ0, then jump to cour_star to keep
                        \ going

 LDA QQ15+1             \ Fetch the s0_hi seed of the system we are considering
                        \ adding to the menu into A, which gives us the galactic
                        \ y-coordinate of the system we are considering

 CMP QQ1                \ If the y-coordinate of the system we are considering
 BNE cour_star          \ is different to the current system's galactic
                        \ y-coordinate in QQ1, then jump to cour_star to keep
                        \ going

 JMP cour_next          \ If we get here then the system we are considering has
                        \ the same coordinates as the current system, and we
                        \ can't offer a cargo mission to the system we are
                        \ already in, so jump to cour_next to move onto the next
                        \ system

.cour_star

                        \ If we get here then this destination is a suitable
                        \ system for a delivery mission, so we now want to add
                        \ the destination's data to the block at &0C00, which is
                        \ where we build up the menu data
                        \
                        \ We build up the data as follows, where X is the number
                        \ of the menu item (0-15):
                        \
                        \   * &0C00+X = x-coordinate of the delivery destination
                        \   * &0C10+X = y-coordinate of the delivery destination
                        \   * &0C20+X = legal status of the delivery mission
                        \   * &0C30+X = high byte of the mission timer
                        \   * &0C40+X = low byte of the mission timer
                        \               low byte of the mission cost
                        \   * &0C50+X = high byte of the mission cost
                        \
                        \ In other words, when we take on a mission, the timer
                        \ in cmdr_cour(1 0) is set to (&0C30+X &0C40+X), we pay
                        \ the mission cost of (&0C50+X &0C40+X), and our legal
                        \ status goes up by the amount in &0C20+X

 LDA QQ15+3             \ Set A = s1_hi EOR s2_hi EOR INWK+1
 EOR QQ15+5             \
 EOR INWK+1             \ which is a pretty random number based on the seeds for
                        \ the destination system, plus the random INWK+1 that we
                        \ generated above

 CMP FIST               \ If A < FIST then jump to cour_legal, so we will only
 BCC cour_legal         \ jump if FIST is non-zero, with a bigger chance of
                        \ jumping if we've been bad

 LDA #0                 \ We have either been very good or very lucky, so set
                        \ A = 0 to indicate that this delivery mission is legit

.cour_legal

 STA &0C20,X            \ Store A in the X-th byte of &0C20, which is the legal
                        \ status of this delivery mission (A = 0 means it's
                        \ legit, while higher numbers are increasingly bad)

 LDA QQ15+3             \ Set the X-th byte of &0C00 to s1_hi, the galactic
 STA &0C00,X            \ x-coordinate of the delivery destination

                        \ We need to calculate the distance from the current
                        \ system to the delivery destination, as the mission
                        \ timer is based on the distance of the delivery (as
                        \ well as the legality of the mission)
                        \
                        \ We do this using Pythagoras, so let's denote the
                        \ current system's coordinates as (current_x, current_y)
                        \ and the delivery destination's coordinates as
                        \ (destination_x, destination_y)

 SEC                    \ Set A = A - QQ0
 SBC QQ0                \       = destination_x - current_x

 BCS cour_negx          \ If the subtraction didn't underflow, jump to cour_negx

 EOR #&FF               \ The subtraction underflowed, so negate the result
 ADC #1                 \ using two's complement, so we know A is positive, i.e.
                        \
                        \   A = |destination_x - current_x|

.cour_negx

 JSR SQUA2              \ Set K(1 0) = A * A
 STA K+1                \            = |destination_x - current_x| ^ 2
 LDA P
 STA K

 LDX INWK+3             \ Set X = INWK+3 again, so we can use as an index when
                        \ populating the menu data in &0C00

 LDA QQ15+1             \ Set the X-th byte of &0C10 to s0_hi, the galactic
 STA &0C10,X            \ y-coordinate of the delivery destination

 SEC                    \ Set A = A - QQ1
 SBC QQ1                \       = destination_y - current_y

 BCS cour_negy          \ If the subtraction didn't underflow, jump to cour_negy

 EOR #&FF               \ The subtraction underflowed, so negate the result
 ADC #1                 \ using two's complement, so we know A is positive, i.e.
                        \
                        \   A = |destination_y - current_y|

.cour_negy

 LSR A                  \ Set A = A / 2

                        \ A now contains the difference between the two
                        \ systems' y-coordinates, with the sign removed, and
                        \ halved. We halve the value because the galaxy in
                        \ in Elite is rectangular rather than square, and is
                        \ twice as wide (x-axis) as it is high (y-axis), so to
                        \ get a distance that matches the shape of the
                        \ long-range galaxy chart, we need to halve the
                        \ distance between the vertical y-coordinates

 JSR SQUA2              \ Set (A P) = A * A
                        \           = (|destination_x - current_x| / 2) ^ 2

                        \ We now want to add the two so we can then apply
                        \ Pythagoras, so first we do this:
                        \
                        \   (R Q) = K(1 0) + (A P))
                        \         = (destination_x - current_x) ^ 2
                        \           + (|destination_x - current_x| / 2) ^ 2
                        \
                        \ and then the distance will be the square root:
                        \
                        \   Q = SQRT(R Q)

 PHA                    \ Store the high byte of the result on the stack

 LDA P                  \ Set Q = P + K
 CLC                    \
 ADC K                  \ which adds the low bytes
 STA Q

 PLA                    \ Set R = A + K+1
 ADC K+1                \
 STA R                  \ which adds the high bytes

 JSR LL5                \ Set Q = SQRT(R Q), so Q now contains the distance
                        \ between the two systems, in terms of coordinates,
                        \ which we can use to determine the reward for this
                        \ delivery mission

 LDX INWK+3             \ Set X = INWK+3 again, so we can use as an index when
                        \ populating the menu data in &0C00

 LDA QQ15+1             \ Set A = (s0_hi EOR s2_hi EOR INWK+1) / 8
 EOR QQ15+5             \
 EOR INWK+1             \ which is another pretty random number based on the
 LSR A                  \ seeds for the destination system, plus the random
 LSR A                  \ INWK+1 that we generated above
 LSR A

 CMP Q                  \ If A >= Q then skip the following
 BCS cour_dist

 LDA Q                  \ A < Q, so set A = Q, so A has a minimum value of Q,
                        \ i.e. our mission reward is always at least the
                        \ distance we have to travel

.cour_dist

 ORA &0C20,X            \ We now OR this value with the legal status of this
                        \ delivery mission, so a legit mission (which has a
                        \ status of 0) will not change the value in A, but more
                        \ dangerous missions will bump the value up, with a
                        \ higher premium paid for more illegal missions

 STA &0C30,X            \ Set the X-th byte of &0C30 to A, which we use as the
                        \ high byte of the mission timer (which is also the
                        \ potential reward for completing this mission, though
                        \ it does halve every time we dock)

 STA INWK+4             \ Set INWK(5 4) = (A A) / 8
 LSR A                  \
 ROR INWK+4             \ which we use as the mission cost (i.e. the amount of
 LSR A                  \ cash we have to part with in order to take on the
 ROR INWK+4             \ delivery mission)
 LSR A
 ROR INWK+4
 STA INWK+5

 STA &0C50,X            \ Store INWK+5 in the X-th byte of &0C50, so it contains
                        \ the high byte of the mission cost

 LDA INWK+4             \ Store INWK+4 in the X-th byte of &0C40, so it contains
 STA &0C40,X            \ the low byte of the mission cost (and the same value
                        \ is used as the low byte of the mission timer)

 LDA #1                 \ Move the text cursor to column 1
 STA XC

 CLC                    \ Move the text cursor to row INWK+3 plus 3, where
 LDA INWK+3             \ INWK+3 is the menu item number, starting from 0 (so
 ADC #3                 \ the first menu item is on row 3, the next is on row 4
 STA YC                 \ and so on)

 LDX INWK+3             \ Set X to INWK+3 + 1, which we can use as the menu item
 INX                    \ number on-screen (so the first menu item with is shown
                        \ as item 1 on screen, the next is shown as item 2, and
                        \ so on)

 CLC                    \ Clear the C flag so the call to pr2 doesn't show a
                        \ decimal point

 JSR pr2                \ Call pr2 to print the number in X to a width of 3
                        \ 3 figures, so this prints the item number at the start
                        \ of the menu item

 JSR TT162              \ Print a space

 JSR cpl                \ Call cpl to print the name of the selected system
                        \ (i.e. the destination system)

 LDX INWK+4             \ Set (Y X) = INWK(5 4)
 LDY INWK+5             \
                        \ so (Y X) contains the mission cost, as we set up
                        \ INWK(5 4) with this value above

 SEC                    \ Set the C flag so the call to TT11 below includes a
                        \ decimal point

 LDA #25                \ Move the text cursor to column 25, so we can print the
 STA XC                 \ mission price

 LDA #6                 \ Set A = 6, for the call to TT11 below, so we pad out
                        \ the number to 6 digits

 JSR TT11               \ Call TT11 to print the mission timer in (Y X), padded
                        \ to six digits and with a decimal point

 INC INWK+3             \ We have just printed a menu item, so increment the
                        \ counter in INWK+3, as it contains a count of menu
                        \ items we have printed

.cour_next

 LDA INWK+1             \ Reset INWK to the value in INWK+1, so the next time we
 STA INWK               \ iterate round the loop, we skip over INWK+1 systems
                        \ before adding to the menu

 JMP cour_loop          \ Loop back to cour_loop to add the next menu item

