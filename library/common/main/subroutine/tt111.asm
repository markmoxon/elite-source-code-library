\ ******************************************************************************
\
\       Name: TT111
\       Type: Subroutine
\   Category: Universe
\    Summary: Set the current system to the nearest system to a point
\
\ ------------------------------------------------------------------------------
\
\ Given a set of galactic coordinates in (QQ9, QQ10), find the nearest system
\ to this point in the galaxy, and set this as the currently selected system.
\
\ Arguments:
\
\   QQ9                 The x-coordinate near which we want to find a system
\
\   QQ10                The y-coordinate near which we want to find a system
\
\ Returns:
\
\   QQ8(1 0)            The distance from the current system to the nearest
\                       system to the original coordinates
\
\   QQ9                 The x-coordinate of the nearest system to the original
\                       coordinates
\
\   QQ10                The y-coordinate of the nearest system to the original
\                       coordinates
\
\   QQ15 to QQ15+5      The three 16-bit seeds of the nearest system to the
\                       original coordinates
\
IF _6502SP_VERSION OR _DISC_DOCKED OR _ELITE_A_DOCKED OR _ELITE_A_6502SP_PARA OR _ELITE_A_ENCYCLOPEDIA OR _MASTER_VERSION \ Comment
\   ZZ                  The system number of the nearest system
\
ELIF _NES_VERSION
\   systemNumber        The system number of the nearest system
\
ENDIF
\ Other entry points:
\
\   TT111-1             Contains an RTS
\
IF _MASTER_VERSION \ Comment
\   readdistnce         Calculate the distance between the system with galactic
\                       coordinates (A, QQ15+1) and the system at (QQ0, QQ1),
\                       returning the result in QQ8(1 0)
\
ENDIF
\ ******************************************************************************

.TT111

 JSR TT81               \ Set the seeds in QQ15 to those of system 0 in the
                        \ current galaxy (i.e. copy the seeds from QQ21 to QQ15)

                        \ We now loop through every single system in the galaxy
                        \ and check the distance from (QQ9, QQ10). We get the
                        \ galactic coordinates of each system from the system's
                        \ seeds, like this:
                        \
                        \   x = s1_hi (which is stored in QQ15+3)
                        \   y = s0_hi (which is stored in QQ15+1)
                        \
                        \ so the following loops through each system in the
                        \ galaxy in turn and calculates the distance between
                        \ (QQ9, QQ10) and (s1_hi, s0_hi) to find the closest one

 LDY #127               \ Set Y = T = 127 to hold the shortest distance we've
 STY T                  \ found so far, which we initially set to half the
                        \ distance across the galaxy, or 127, as our coordinate
                        \ system ranges from (0,0) to (255, 255)

 LDA #0                 \ Set A = U = 0 to act as a counter for each system in
 STA U                  \ the current galaxy, which we start at system 0 and
                        \ loop through to 255, the last system

.TT130

IF _NES_VERSION

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

ENDIF

 LDA QQ15+3             \ Set A = s1_hi - QQ9, the horizontal distance between
 SEC                    \ (s1_hi, s0_hi) and (QQ9, QQ10)
 SBC QQ9

 BCS TT132              \ If a borrow didn't occur, i.e. s1_hi >= QQ9, then the
                        \ result is positive, so jump to TT132 and skip the
                        \ following two instructions

 EOR #&FF               \ Otherwise negate the result in A, so A is always
 ADC #1                 \ positive (i.e. A = |s1_hi - QQ9|)

.TT132

 LSR A                  \ Set S = A / 2
 STA S                  \       = |s1_hi - QQ9| / 2

 LDA QQ15+1             \ Set A = s0_hi - QQ10, the vertical distance between
 SEC                    \ (s1_hi, s0_hi) and (QQ9, QQ10)
 SBC QQ10

 BCS TT134              \ If a borrow didn't occur, i.e. s0_hi >= QQ10, then the
                        \ result is positive, so jump to TT134 and skip the
                        \ following two instructions

 EOR #&FF               \ Otherwise negate the result in A, so A is always
 ADC #1                 \ positive (i.e. A = |s0_hi - QQ10|)

.TT134

 LSR A                  \ Set A = S + A / 2
 CLC                    \       = |s1_hi - QQ9| / 2 + |s0_hi - QQ10| / 2
 ADC S                  \
                        \ So A now contains the sum of the horizontal and
                        \ vertical distances, both divided by 2 so the result
                        \ fits into one byte, and although this doesn't contain
                        \ the actual distance between the systems, it's a good
                        \ enough approximation to use for comparing distances

 CMP T                  \ If A >= T, then this system's distance is bigger than
 BCS TT135              \ our "minimum distance so far" stored in T, so it's no
                        \ closer than the systems we have already found, so
                        \ skip to TT135 to move on to the next system

 STA T                  \ This system is the closest to (QQ9, QQ10) so far, so
                        \ update T with the new "distance" approximation

 LDX #5                 \ As this system is the closest we have found yet, we
                        \ want to store the system's seeds in case it ends up
                        \ being the closest of all, so we set up a counter in X
                        \ to copy six bytes (for three 16-bit numbers)

.TT136

 LDA QQ15,X             \ Copy the X-th byte in QQ15 to the X-th byte in QQ19,
 STA QQ19,X             \ where QQ15 contains the seeds for the system we just
                        \ found to be the closest so far, and QQ19 is temporary
                        \ storage

 DEX                    \ Decrement the counter

 BPL TT136              \ Loop back to TT136 if we still have more bytes to
                        \ copy

IF _6502SP_VERSION OR _DISC_DOCKED OR _ELITE_A_DOCKED OR _ELITE_A_6502SP_PARA OR _ELITE_A_ENCYCLOPEDIA OR _MASTER_VERSION \ Platform: Store the system number in ZZ so if we want to show the extended system description for this system, the PDESC routine knows which one to display

 LDA U                  \ Store the system number U in ZZ, so when we are done
 STA ZZ                 \ looping through all the candidates, the winner's
                        \ number will be in ZZ

ELIF _NES_VERSION

 LDA U                  \ Store the system number U in systemNumber, so when we
 STA systemNumber       \ are done looping through all the candidates, the
                        \ winner's number will be in systemNumber

ENDIF

.TT135

IF _NES_VERSION

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

ENDIF

 JSR TT20               \ We want to move on to the next system, so call TT20
                        \ to twist the three 16-bit seeds in QQ15

 INC U                  \ Increment the system counter in U

 BNE TT130              \ If U > 0 then we haven't done all 256 systems yet, so
                        \ loop back up to TT130

                        \ We have now finished checking all the systems in the
                        \ galaxy, and the seeds for the closest system are in
                        \ QQ19, so now we want to copy these seeds to QQ15,
                        \ to set the selected system to this closest system

 LDX #5                 \ So we set up a counter in X to copy six bytes (for
                        \ three 16-bit numbers)

.TT137

IF NOT(_NES_VERSION)

 LDA QQ19,X             \ Copy the X-th byte in QQ19 to the X-th byte in QQ15
 STA QQ15,X

ELIF _NES_VERSION

 LDA QQ19,X             \ Copy the X-th byte in QQ19 to the X-th byte in
 STA selectedSystem,X   \ selectedSystem so we can easily change the selected
                        \ system back to the system we just found

 STA QQ15,X             \ Copy the X-th byte in QQ19 to the X-th byte in QQ15

ENDIF

 DEX                    \ Decrement the counter

 BPL TT137              \ Loop back to TT137 if we still have more bytes to
                        \ copy

 LDA QQ15+1             \ The y-coordinate of the system described by the seeds
 STA QQ10               \ in QQ15 is in QQ15+1 (s0_hi), so we copy this to QQ10
                        \ as this is where we store the selected system's
                        \ y-coordinate

 LDA QQ15+3             \ The x-coordinate of the system described by the seeds
 STA QQ9                \ in QQ15 is in QQ15+3 (s1_hi), so we copy this to QQ9
                        \ as this is where we store the selected system's
                        \ x-coordinate

                        \ We have now found the closest system to (QQ9, QQ10)
                        \ and have set it as the selected system, so now we
                        \ need to work out the distance between the selected
                        \ system and the current system

IF _MASTER_VERSION \ Label

.readdistnce

ENDIF

 SEC                    \ Set A = QQ9 - QQ0, the horizontal distance between
 SBC QQ0                \ the selected system's x-coordinate (QQ9) and the
                        \ current system's x-coordinate (QQ0)

 BCS TT139              \ If a borrow didn't occur, i.e. QQ9 >= QQ0, then the
                        \ result is positive, so jump to TT139 and skip the
                        \ following two instructions

 EOR #&FF               \ Otherwise negate the result in A, so A is always
 ADC #1                 \ positive (i.e. A = |QQ9 - QQ0|)

                        \ A now contains the difference between the two
                        \ systems' x-coordinates, with the sign removed. We
                        \ will refer to this as the x-delta ("delta" means
                        \ change or difference in maths)

.TT139

 JSR SQUA2              \ Set (A P) = A * A
                        \           = |QQ9 - QQ0| ^ 2
                        \           = x_delta ^ 2

 STA K+1                \ Store (A P) in K(1 0)
 LDA P
 STA K

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _NES_VERSION \ Minor

 LDA QQ10               \ Set A = QQ10 - QQ1, the vertical distance between the
 SEC                    \ selected system's y-coordinate (QQ10) and the current
 SBC QQ1                \ system's y-coordinate (QQ1)

ELIF _MASTER_VERSION

 LDA QQ15+1             \ Set A = QQ15+1 - QQ1, the vertical distance between
\LDA QQ10               \ the selected system's y-coordinate (QQ15+1) and the
 SEC                    \ current system's y-coordinate (QQ1)
 SBC QQ1                \
                        \ The LDA instruction is commented out in the original
                        \ source

ENDIF

 BCS TT141              \ If a borrow didn't occur, i.e. QQ10 >= QQ1, then the
                        \ result is positive, so jump to TT141 and skip the
                        \ following two instructions

 EOR #&FF               \ Otherwise negate the result in A, so A is always
 ADC #1                 \ positive (i.e. A = |QQ10 - QQ1|)

.TT141

 LSR A                  \ Set A = A / 2

                        \ A now contains the difference between the two
                        \ systems' y-coordinates, with the sign removed, and
                        \ halved. We halve the value because the galaxy in
                        \ in Elite is rectangular rather than square, and is
                        \ twice as wide (x-axis) as it is high (y-axis), so to
                        \ get a distance that matches the shape of the
                        \ long-range galaxy chart, we need to halve the
                        \ distance between the vertical y-coordinates. We will
                        \ refer to this as the y-delta

 JSR SQUA2              \ Set (A P) = A * A
                        \           = (|QQ10 - QQ1| / 2) ^ 2
                        \           = y_delta ^ 2

                        \ By this point we have the following results:
                        \
                        \   K(1 0) = x_delta ^ 2
                        \    (A P) = y_delta ^ 2
                        \
                        \ so to find the distance between the two points, we
                        \ can use Pythagoras - so first we need to add the two
                        \ results together, and then take the square root

 PHA                    \ Store the high byte of the y-axis value on the stack,
                        \ so we can use A for another purpose

IF _NES_VERSION

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

ENDIF

 LDA P                  \ Set Q = P + K, which adds the low bytes of the two
 CLC                    \ calculated values
 ADC K
 STA Q

 PLA                    \ Restore the high byte of the y-axis value from the
                        \ stack into A again

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION \ Other: The Master version fixes a bug in the code to calculate the distance between two systems, which can overflow in the other versions and give an incorrect result

 ADC K+1                \ Set R = A + K+1, which adds the high bytes of the two
 STA R                  \ calculated values, so we now have:
                        \
                        \   (R Q) = K(1 0) + (A P)
                        \         = (x_delta ^ 2) + (y_delta ^ 2)

ELIF _MASTER_VERSION OR _NES_VERSION

 ADC K+1                \ Set A = A + K+1, which adds the high bytes of the two
                        \ calculated values

 BCC P%+4               \ If the above addition overflowed, set A = 255
 LDA #255

 STA R                  \ Store A in R, so we now have R = A + K+1, and:
                        \
                        \   (R Q) = K(1 0) + (A P)
                        \         = (x_delta ^ 2) + (y_delta ^ 2)

ENDIF

 JSR LL5                \ Set Q = SQRT(R Q), so Q now contains the distance
                        \ between the two systems, in terms of coordinates

                        \ We now store the distance to the selected system * 4
                        \ in the two-byte location QQ8, by taking (0 Q) and
                        \ shifting it left twice, storing it in QQ8(1 0)

 LDA Q                  \ First we shift the low byte left by setting
 ASL A                  \ A = Q * 2, with bit 7 of A going into the C flag

 LDX #0                 \ Now we set the high byte in QQ8+1 to 0 and rotate
 STX QQ8+1              \ the C flag into bit 0 of QQ8+1
 ROL QQ8+1

 ASL A                  \ And then we repeat the shift left of (QQ8+1 A)
 ROL QQ8+1

 STA QQ8                \ And store A in the low byte, QQ8, so QQ8(1 0) now
                        \ contains Q * 4. Given that the width of the galaxy is
                        \ 256 in coordinate terms, the width of the galaxy
                        \ would be 1024 in the units we store in QQ8

IF NOT(_NES_VERSION)

 JMP TT24               \ Call TT24 to calculate system data from the seeds in
                        \ QQ15 and store them in the relevant locations, so our
                        \ new selected system is fully set up, and return from
                        \ the subroutine using a tail call

ELIF _NES_VERSION

 JMP TT24_b6            \ Call TT24 to calculate system data from the seeds in
                        \ QQ15 and store them in the relevant locations, so our
                        \ new selected system is fully set up, and return from
                        \ the subroutine using a tail call

ENDIF

