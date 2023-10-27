\ ******************************************************************************
\
\       Name: SendPatternsToPPU (Part 6 of 6)
\       Type: Subroutine
\   Category: PPU
\    Summary: Save progress for use in the next VBlank and return from the
\             subroutine
\
\ ******************************************************************************

.spat30

                        \ We now store the following variables, so they can be
                        \ picked up when we return in the next VBlank:
                        \
                        \   * (patternBufferHi patternBufferLo)
                        \
                        \   * sendingPattern

 STX patternCounter     \ Store X in patternCounter to use below

 LDX nmiBitplane        \ Set (patternBufferHi patternBufferLo) for this
 STY patternBufferLo,X  \ bitplane to dataForPPU(1 0) + Y (which is the address
 LDA dataForPPU+1       \ of the next byte of data to be sent from the pattern
 STA patternBufferHi,X  \ buffer in the next VBlank)

 LDA patternCounter     \ Set sendingPattern for this bitplane to the value of
 STA sendingPattern,X   \ X we stored above (which is the number / 8 of the next
                        \ pattern to be sent from the pattern buffer in the next
                        \ VBlank)

 JMP RTS1               \ Return from the subroutine (as RTS1 contains an RTS)

