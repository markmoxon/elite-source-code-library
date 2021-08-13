\ ******************************************************************************
\
\       Name: cour_count
\       Type: Subroutine
\   Category: Missions
\    Summary: Generate a single special cargo mission and display its menu item
\  Deep dive: Special cargo missions
\
\ ******************************************************************************

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
                        \   * &0C30+X = high byte of the mission reward
                        \   * &0C40+X = low byte of the mission reward
                        \               low byte of the mission cost
                        \   * &0C50+X = high byte of the mission cost
                        \
                        \ In other words, when we take on a mission, the reward
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
                        \ reward is based on the distance of the delivery (as
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
                        \ Elite is rectangular rather than square, and is
                        \ twice as wide (x-axis) as it is high (y-axis), so to
                        \ get a distance that matches the shape of the
                        \ long-range galaxy chart, we need to halve the
                        \ distance between the vertical y-coordinates

 JSR SQUA2              \ Set (A P) = A * A
                        \           = (|destination_y - current_y| / 2) ^ 2

                        \ We now want to add the two so we can then apply
                        \ Pythagoras, so first we do this:
                        \
                        \   (R Q) = K(1 0) + (A P))
                        \         =    |destination_x - current_x| ^ 2
                        \           + (|destination_y - current_y| / 2) ^ 2
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
                        \ high byte of the mission reward

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
 STA &0C40,X            \ the low byte of the mission cost (and the low byte of
                        \ the mission reward, as they share the same value)

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
 STA XC                 \ mission cost

 LDA #6                 \ Set A = 6, for the call to TT11 below, so we pad out
                        \ the number to 6 digits

 JSR TT11               \ Call TT11 to print the mission cost in (Y X), padded
                        \ to six digits and with a decimal point

 INC INWK+3             \ We have just printed a menu item, so increment the
                        \ counter in INWK+3, as it contains a count of menu
                        \ items we have printed

.cour_next

 LDA INWK+1             \ Reset INWK to the value in INWK+1, so the next time we
 STA INWK               \ iterate round the loop, we skip over INWK+1 systems
                        \ before adding to the menu

 JMP cour_loop          \ Loop back to cour_loop to add the next menu item

