\ ******************************************************************************
\
\       Name: RDS1
\       Type: Subroutine
\   Category: Keyboard
\    Summary: Scan one axis of the joystick and return its position
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   X                   The number of the joystick axis to read:
\
\                         * 0 = joystick x-axis
\
\                         * 1 = joystick y-axis
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   A                   The position of the joystick in the specified axis:
\
\                         * 0 to 254 = the position in that axis, flipped if
\                                      both joystick channels are configured
\                                      that way
\
\                         * 255 = the joystick could not be read
\
\ ******************************************************************************

.RDS1

 LDA &C064,X            \ Set A to the soft switch containing the status of
                        \ joystick X, so that's GC0, GC1, GC2 or GC3

 BMI RDS1               \ Loop back until bit 7 of the soft switch is clear, at
                        \ which point the game controller circuitry is ready for
                        \ us to reset it and read the result

 LDY &C070              \ Initiate the A/D conversion procedure for the game
                        \ controller circuits by reading the GCRESET soft switch

 LDY #0                 \ We are now going to wait until the timer runs down for
                        \ game controller port X, as that will give us the
                        \ analogue position of the joystick in that axis, so set
                        \ a counter in Y to count the number of loops before the
                        \ timer runs down

 NOP                    \ Wait for four CPU cycles to ensure the circuitry is
 NOP                    \ ready for reading

.RDL2

 LDA &C064,X            \ If the soft switch containing the status of joystick X
 BPL RDR1               \ has bit 7 clear, then the timer has run down and we
                        \ have our result in Y, so jump to RDR1 to return it

 INY                    \ Otherwise the timer has not yet run down, so increment
                        \ the result in Y

 BNE RDL2               \ Loop back until the timer runs down, or Y wraps around
                        \ to zero

 DEY                    \ If we get here then Y wrapped around to zero and we
                        \ haven't been able to read the value of the joystick,
                        \ so decrement Y to 255 to return as the result

.RDR1

 TYA                    \ Copy the result from Y into A

 EOR JSTE               \ The result in A is now EOR'd with the value in
                        \ location JSTE, which contains &FF if both joystick
                        \ channels are reversed and 0 otherwise (so A now
                        \ contains the result but inverted, if that's what
                        \ the current settings say)

 RTS                    \ Return from the subroutine

