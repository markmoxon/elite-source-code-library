\ ******************************************************************************
\
\       Name: UpdateVibratoSeeds
\       Type: Subroutine
\   Category: Sound
\    Summary: Update the sound seeds that are used to randomise the vibrato
\             effect
\
\ ******************************************************************************

.UpdateVibratoSeeds

 LDA soundVibrato       \ Set A to soundVibrato with all bits cleared except for
 AND #%01001000         \ bits 3 and 6

 ADC #%00111000         \ Add %00111000, so if bit 3 of A is clear, we leave
                        \ bit 6 alone, otherwise bit 6 gets flipped
                        \
                        \ The C flag doesn't affect this calculation, as it
                        \ will only affect bit 0, which we don't care about

 ASL A                  \ Set the C flag to bit 6 of A
 ASL A                  \
                        \ So the C flag is:
                        \
                        \   * Bit 6 of soundVibrato if bit 3 of soundVibrato is
                        \     clear
                        \
                        \   * Bit 6 of soundVibrato flipped if bit 3 of
                        \     soundVibrato is set
                        \
                        \ Or, to put it another way:
                        \
                        \   C = bit 6 of soundVibrato EOR bit 3 of soundVibrato

 ROL soundVibrato+3     \ Rotate soundVibrato(0 1 2 3) left, inserting the C
 ROL soundVibrato+2     \ flag into bit 0 of soundVibrato+3
 ROL soundVibrato+1
 ROL soundVibrato

 RTS                    \ Return from the subroutine

