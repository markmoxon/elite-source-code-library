\ ******************************************************************************
\
\       Name: SOLARX
\       Type: Subroutine
\   Category: Universe
\    Summary: Set up various aspects of arriving in a new system, including
\             Trumble breeding
\
\ ******************************************************************************

.SOLARX

 LDA TRUMBLE            \ If we have no Trumbles in the hold, skip to SOLAR
 BEQ SOLAR

                        \ If we get here then we have Trumbles in the hold, so
                        \ this is where they breed (though we never get here in
                        \ the Master version as the number of Trumbles is always
                        \ zero)

 LDA #0                 \ Trumbles eat food and narcotics during the hyperspace
 STA QQ20               \ journey, so zero the amount of food and narcotics in
 STA QQ20+6             \ the hold

 JSR DORND              \ Take the number of Trumbles from TRUMBLE(1 0), add a
 AND #15                \ random number between 4 and 15, and double the result,
 ADC TRUMBLE            \ storing the resulting number in TRUMBLE(1 0)
 ORA #4                 \
 ROL A                  \ We start with the low byte
 STA TRUMBLE

 ROL TRUMBLE+1          \ And then do the high byte

 BPL P%+5               \ If bit 7 of the high byte is set, then rotate the high
 ROR TRUMBLE+1          \ byte back to the right, so the number of Trumbles is
                        \ always positive

