\ ******************************************************************************
\
\       Name: MVTRIBS
\       Type: Variable
\   Category: Missions
\    Summary: Move the Trumble sprites around on-screen
\
\ ******************************************************************************

.MVTRIBS

 LDA MCNT               \ We want to move one Trumble sprite on each iteration
 AND #7                 \ around the main loop, so set A to the main loop
                        \ counter mod 8, so A counts up from 0 to 7 and repeats
                        \ as we iterate around the main loop

 CMP TRIBCT             \ If A < TRIBCT then skip the following instruction
 BCC P%+5

 JMP NOMVETR            \ Jump to NOMVETR to return to the main game loop
                        \ without moving any sprites

\STA T                  \ This instruction is commented out in the original
                        \ source

                        \ TRIBCT contains the number of Trumble sprites being
                        \ shown on-screen, in the range 0 to 6, and we only
                        \ call MVTRIBS when TRIBCT is non-zero, so it must be
                        \ in the range 1 to 6
                        \
                        \ We also know that A < TRIBCT, so if we get here then
                        \ we know A must be in the range 0 to TRIBCT - 1, with
                        \ a maximum value of 5
                        \
                        \ We can therefore move Trumble number A, and this will
                        \ ensure we work through the visible Trumble sprites,
                        \ updating one per iteration, with each sprite being
                        \ moved every eight uterations around the main loop

 ASL A                  \ Set Y = A * 2 so we can use it as an index into the
 TAY                    \ two-byte tables at TRIBVX, TRIBVXH and TRIBXH for the
                        \ Trumble sprite that we are processing
                        \
                        \ As A is reused and we use Y as the index into the data
                        \ for this Trumble, will refer to "Trumble Y" and
                        \ "Trumble sprite Y" in the following)
                        \
                        \ Note that Trumble Y uses sprite Y + 2, as sprites 0
                        \ and 1 have other uses (they contain the laser sight
                        \ sprite and the explosion sprite respectively)

 LDA #%101              \ Call SETL1 to set the 6510 input/output port to the
 JSR SETL1              \ following:
                        \
                        \   * LORAM = 1
                        \   * HIRAM = 0
                        \   * CHAREN = 1
                        \
                        \ This sets the entire 64K memory map to RAM except for
                        \ the I/O memory map at $D000-$DFFF, which gets mapped
                        \ to registers in the VIC-II video controller chip, the
                        \ SID sound chip, the two CIA I/O chips, and so on
                        \
                        \ See the memory map at the top of page 264 in the
                        \ Programmer's Reference Guide

 JSR DORND              \ Set A and X to random numbers

 CMP #235               \ If the random number in A < 235 (92% chance), jump to
 BCC MVTR1              \ MVTR1 to skip the following, so we only change the
                        \ direction of movement for this Trumble sprite 8% of
                        \ the time (and we keep the existing direction for the
                        \ other 92%)

 AND #3                 \ Set X to the random number in A, reduced to the range
 TAX                    \ 0 to 3 so we can pick one of four directions to move
                        \ in

 LDA TRIBDIR,X          \ Set (TRIBVXH TRIBVX) for Trumble sprite Y to the X-th
 STA TRIBVX,Y           \ entry from the TRIBDIRH and TRIBDIR tables
 LDA TRIBDIRH,X         \
 STA TRIBVXH,Y          \ These tables contain four 16-bit directions, so this
                        \ randomly sets (TRIBVXH TRIBVX) to 0, 1, -1 or 0 (so
                        \ there's a 50% chance of no horizontal movement, and a
                        \ 25% chance of movement left or right)
                        \
                        \ (TRIBVXH TRIBVX) now contains the updated x-axis
                        \ velocity of Trumble Y, i.e. the amount that it moves
                        \ horizontally in this iteration of the main loop

 JSR DORND              \ Set A and X to random numbers

 AND #3                 \ Set X to the random number in A, reduced to the range
 TAX                    \ 0 to 3 so we can pick another one of four directions
                        \ to move in

 LDA TRIBDIR,X          \ Set TRIBVX+1 for Trumble sprite Y to the X-th entry
 STA TRIBVX+1,Y         \ from the TRIBDIR table (so there's a 50% chance of no
                        \ vertical movement, and a 25% chance of movement up or
                        \ down)
                        \
                        \ TRIBVX+1 now contains the updated y-axis velocity of
                        \ Trumble Y, i.e. the amount that it moves vertically in
                        \ this iteration of the main loop

.MVTR1

                        \ We now move Trumble sprite Y by applying the following
                        \ velocities:
                        \
                        \   * Apply (TRIBVXH TRIBVX) to the x-coordinate
                        \
                        \   * Apply TRIBVX+1 to the y-coordinate
                        \
                        \ The second calculation is pretty easy, but the first
                        \ one is complicated by the fact that x-coordinates are
                        \ 9-bit values with the top bits stored in VIC+&10

 LDA SPMASK,Y           \ Clear the relevant bit for this sprite in VIC+&10
 AND VIC+&10            \
 STA VIC+&10            \ We will replace it with a set bit after calculating
                        \ the new x-coordinate below, if we need to

 LDA VIC+5,Y            \ Add TRIBVX+1 for Trumble Y to the y-coordinate of
 CLC                    \ Trumble sprite Y, by updating VIC+&05 + Y
 ADC TRIBVX+1,Y         \
 STA VIC+5,Y            \ This works because VIC+&05 contains the y-coordinate
                        \ for sprite 2, the first Trumble sprite, and the
                        \ y-coordinates for sprites 3 onwards are in VIC+&07,
                        \ VIC+&09 and so on
                        \
                        \ We don't worry about whether the addition overflows,
                        \ so Trumbles that move off the top or bottom of the
                        \ screen simply reappear on the opposite side

                        \ We now want to add (TRIBVXH TRIBVX) to the sprite's
                        \ x-coordinate, as follows:
                        \
                        \   (A T) = (TRIBXH VIC+&04) + (TRIBVXH TRIBVX)
                        \
                        \ The table at TRIBXH is used to store the top bit of
                        \ the sprite's 9-bit x-coordinate
                        \
                        \ Now to do the above calculation, one byte at a time

 CLC                    \ Set T = VIC+&04 + TRIBVX
 LDA VIC+4,Y            \
 ADC TRIBVX,Y           \ We do this for Trumble sprite Y, so this does the low
 STA T                  \ byte of the calculation
                        \
                        \ This works because VIC+&04 contains the x-coordinate
                        \ for sprite 2, the first Trumble sprite, and the
                        \ x-coordinates for sprites 3 onwards are in VIC+&06,
                        \ VIC+&08 and so on

 LDA TRIBXH,Y           \ Set A = TRIBXH + TRIBVXH
 ADC TRIBVXH,Y          \
                        \ So this does the high byte of the calculation

                        \ (A T) now contains the updated x-coordinate of Trumble
                        \ sprite Y

 BPL nominus            \ If A is positive then the Trumble has not just moved
                        \ off the left edge of the screen, so jump to nominus

 LDA #&48               \ The Trumble has just moved off the left edge of the
 STA T                  \ screen, so set (A T) = &148 = 328 to move it to the
 LDA #&01               \ right edge of the screen

.nominus

 AND #1                 \ If bit 0 of A is zero, then bit 9 of the x-coordinate
 BEQ oktrib             \ in (A T) is zero, so jump to oktrib with A set to 0
                        \ to store a 0 in TRIBXH (which is where we store the
                        \ top coordinate of the x-coordinate) and set the
                        \ sprite's y-coordinate to (A T)

                        \ If we get here then (A T) has bit 9 set, so it's of
                        \ the form &1xx (where xx is T) and we need to check
                        \ whether it's off the right edge of the screen

 LDA T                  \ If T < &50, then (A T) < &150 = 336, so the sprite has
 CMP #&50               \ not moved off the right edge of the screen
 LDA #1                 \
 BCC oktrib             \ So set A = 1 and jump to oktrib to store a 1 in TRIBXH
                        \ (which is where we store the top coordinate of the
                        \ x-coordinate) and set the sprite's y-coordinate to
                        \ (A T)

 LDA #0                 \ If we get here then the Trumble has just moved off the
 STA T                  \ right edge of the screen, so set (A T) = 0 to move it
                        \ to the left edge of the screen

.oktrib

 STA TRIBXH,Y           \ Store the updated top byte of (A T) in TRIBXH so we
                        \ can use it the next time we move this Trumble sprite

                        \ We now set the sprite's x-coordinate to (A T) by
                        \ setting the relevant bit in VIC+&10 to the top bit in
                        \ bit 0 of A, and setting the relevant x-coordinate
                        \ register from VIC+&04 onwards to the low byte of (A T)

 BEQ NOHIBIT            \ If the top byte is zero then jump to NOHIBIT to skip
                        \ updating the top bit of the sprite's x-coordinate, as
                        \ we already zeroed the relevant bit in VIC+&10 above

 LDA SPMASK+1,Y         \ Set the relevant bit for this sprite in VIC+&10,
 ORA VIC+&10            \ making sure to disable interrupts while we do
 SEI
 STA VIC+&10

.NOHIBIT

 LDA T                  \ Set the bottom 8-bits of the x-coordinate of Trumble
 STA VIC+4,Y            \ sprite Y to the low byte of (A T), i.e. T, by setting
                        \ VIC+&04 + Y to T

 CLI                    \ Enable interrupts again, in case we disabled them
                        \ above

 LDA #%100              \ Call SETL1 to set the 6510 input/output port to the
 JSR SETL1              \ following:
                        \
                        \   * LORAM = 0
                        \   * HIRAM = 0
                        \   * CHAREN = 1
                        \
                        \ This sets the entire 64K memory map to RAM
                        \
                        \ See the memory map at the top of page 265 in the
                        \ Programmer's Reference Guide

 JMP NOMVETR            \ Jump to NOMVETR to return to the main game loop

