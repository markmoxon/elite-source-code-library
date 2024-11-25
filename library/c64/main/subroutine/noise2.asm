\ ******************************************************************************
\
\       Name: NOISE2
\       Type: Subroutine
\   Category: Sound
\    Summary: Make a sound effect with a specific volume and release length
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   Determines the release length and sustain volume of the
\                       sound effect
\
\                         * Bits 0-3 contain the release length
\
\                         * Bits 4-7 contain the sustain volume
\
\   X                   The frequency of the sound effect
\
\ ******************************************************************************

.NOISE2

 BIT SOUR1              \ SOUR1 contains an RTS instruction, which has opcode
                        \ &60 (or %01100000), and as the BIT instructions sets
                        \ the V flag to bit 6 of its operand, this instruction
                        \ sets the V flag
                        \
                        \ There is no SEV instruction in the 6502, hence the
                        \ need for this workaround

 STA XX15               \ Store the sustain volume/release length in XX15

 STX XX15+1             \ Store the frequency in XX15+1

 EQUB &50               \ Skip the next instruction by turning it into
                        \ &50 &B8, or BVC &B8, which does nothing because we
                        \ set the V flag above

                        \ Fall through into NOISE with the V flag set

