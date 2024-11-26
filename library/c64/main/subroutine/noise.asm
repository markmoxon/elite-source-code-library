\ ******************************************************************************
\
\       Name: NOISE
\       Type: Subroutine
\   Category: Sound
\    Summary: Make the sound whose number is in Y
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   Y                   The number of the sound effect to be made
\
\                       If bit 7 is set (i.e. Y = 128 + sound effect number)
\                       then it will play the sound effect without first
\                       checking to see if it is already playing, so the sound
\                       effect can be made on more than one voice at the same
\                       time
\
\   V flag              If set, use the values in XX15 and XX15+1 to determine
\                       the release length, sustain volume and frequency
\
\   XX15                Determines the release length and sustain volume of the
\                       sound effect (when V is set)
\
\                         * Bits 0-3 contain the release length
\
\                         * Bits 4-7 contain the sustain volume
\
\   XX15+1              The frequency of the sound effect (when V is set)
\
\ ******************************************************************************

.NOISE

 CLV                    \ Clear the V flag, unless we fell into this routine
                        \ from the NOISE2 routine, in which case this
                        \ instruction is skipped (and V remains set)

 LDA DNOIZ              \ If DNOIZ is non-zero, then sound is disabled, so
 BNE SOUR1              \ return from the subroutine (as SOUR1 contains an RTS)

 LDX #2                 \ Set X = 2 so we can loop through all three voices,
                        \ from voice 2 down to voice 0

 INY                    \ Set XX15+2 = sound effect number in Y + 1
 STY XX15+2
 DEY

 LDA SFXPR,Y            \ If bit 0 of SFXPR value for this sound effect is set,
 LSR A                  \ then we don't need to check the three voice channels
 BCS SOUX9              \ to see if any of them are already playing this sound
                        \ effect, so jumo to SOUX9 to skip the following
                        \
                        \ If NOISE was called with a sound effect of 128 + sound
                        \ effect number, this lookup will be fairly random, as
                        \ it is fetching values from game code

                        \ Bit 1 of SFXPR for this sound effect is clear, so now
                        \ we check to see if this sound effect is already
                        \ playing, and if it is, we jump to SOUX6 with the voice
                        \ number in X

.SOUX7

 LDA SOFLG,X            \ Set A to bits 0-5 of SOFLG for voice X, which contains
 AND #%00111111         \ the sound effect number currently playing in voice X,
                        \ incremented by 1

 CMP XX15+2             \ If this matches the incremented sound effect number
 BEQ SOUX6              \ in XX15+2, then the sound effect is already playing on
                        \ voice X, so jump to SOUX6 to play the new sound effect
                        \ using the same voice

 DEX                    \ Decrement the voice number in X

 BPL SOUX7              \ Loop back to check the next voice, until we have
                        \ checked them all

.SOUX9

                        \ The sound effect is not already being played, so now
                        \ we find out which voice currently has the lowest
                        \ priority, which is stored in the SOPR table

 LDX #0                 \ Set X = 0 to denote voice voice 1

 LDA SOPR               \ If SOPR < SOPR+1, jump to SOUX1 as voice 1 currently
 CMP SOPR+1             \ has a lower priority than voice 2
 BCC SOUX1

 INX                    \ Voice 1 has a higher priority than voice 2, so set
                        \ X = 1 to denote voice 2

 LDA SOPR+1             \ Set A to the priority of voice 2

.SOUX1

 CMP SOPR+2             \ If A < SOPR+2, then the priority in A is a lower
 BCC P%+4               \ priority than voice 3, so skip the following
                        \ instruction to keep the value of X unchanged

 LDX #2                 \ Set X = 2 so we make the sound effect in voice 3
                        \
                        \ So if we jumped here because voice 1 has a lower
                        \ priority than voice 2, we set X as follows:
                        \
                        \   * X = 0 to choose voice 1 as the lowest priority
                        \           if voice 1 is lower priority than voice 3
                        \           as v1 < v3 and v1 < v2
                        \
                        \   * X = 2 to choose voice 3 as the lowest priority
                        \           if voice 1 is higher priority than voice 3
                        \           as v1 > v3 and v1 < v2
                        \
                        \ If we fell through from above because voice 1 has a
                        \ higher priority than voice 2, then we set X as follows:
                        \
                        \   * X = 1 to choose voice 2 as the lowest priority
                        \           if voice 2 is lower priority than voice 3
                        \           as v2 < v3 and v1 > v2
                        \
                        \   * X = 2 to choose voice 3 as the lowest priority
                        \           if voice 2 is higher priority than voice 3
                        \           as v2 > v3 and v1 > v2
                        \
                        \ The result is that X now contains the voice with the
                        \ lowest priority in the SOPR table, so this is where we
                        \ make our new sound effect

.SOUX6

                        \ By this point X contains the voice number for our new
                        \ sound effect, where X = 0, 1 or 2 (for voices 1 to 3)

 TYA                    \ Clear bit 0 of Y, so that if NOISE was called with a
 AND #%01111111         \ sound effect of 128 + sound effect number, the 128
 TAY                    \ part is now cleared from Y, so Y now contains the
                        \ sound effect number that we want to make

 LDA SFXPR,Y            \ If sound effect Y's priority in SFXPR is less than
 CMP SOPR,X             \ the current priority of voice X in SOPR+X, then the
 BCC SOUR1              \ sound currently playing in voice X is a higher
                        \ priority than the new sound, so jump to SOUR1 to
                        \ return from the subroutine (as SOUR1 contains an RTS)

 SEI                    \ Disable interrupts while we make the sound effect

 STA SOPR,X             \ Store the priority of the sound effect we are making
                        \ in the SOPR entry for voice X, so we can use this to
                        \ check the priority if we want to make sounds in this
                        \ voice in future

 BVS SOUX4              \ If the V flag is set then we got here via NOISE2, in
                        \ which case the release length and sustain volume were
                        \ passed to the routine in XX15, so skip to SOUX4 to
                        \ set A to this value

 LDA SFXSUS,Y           \ Set A to the release length and sustain volume for
                        \ sound effect Y

 EQUB &CD               \ Skip the next instruction by turning it into
                        \ &CD &A5 &6B, or CMP &6BA5, which does nothing apart
                        \ from affect the C and Z flags
                        \
                        \ This is similar to the EQUB &2C trick that we see
                        \ throughout Elite, but that uses a BIT opcode to skip
                        \ an instruction, and that would change the value of the
                        \ V flag (which we are using), so here we change the
                        \ next instruction into a CMP instead, as that doesn't
                        \ affect the V flag

.SOUX4

 LDA XX15               \ Set A to XX15, which contains the release length and
                        \ sustain volume that were passed here via NOISE2 (we
                        \ only run this instruction if the V flag is set)

 STA SOSUS,X            \ Store the release length and sustain volume in A into
                        \ the SOSUS entry for voice X

 LDA SFXCNT,Y           \ Store the counter ??? for sound effect Y in the SOCNT
 STA SOCNT,X            \ entry for voice X

 LDA SFXFRCH,Y          \ Store the ??? for sound effect Y in the SOFRCH entry
 STA SOFRCH,X           \ for voice X

 LDA SFXCR,Y            \ Store the ??? for sound effect Y in the SOCR entry for
 STA SOCR,X             \ voice X

 BVS SOUX5              \ If the V flag is set then we got here via NOISE2, in
                        \ which case the frequency was passed to the routine in
                        \ XX15+1, so skip to SOUX5 to set A to this value

 LDA SFXFQ,Y            \ Set A to the frequency for sound effect Y

 EQUB &CD               \ Skip the next instruction by turning it into
                        \ &CD &A5 &6C, or CMP &6CA5, which does nothing apart
                        \ from affect the C and Z flags

.SOUX5

 LDA XX15+1             \ Set A to XX15+1, which contains the frequency that was
                        \ passed here via NOISE2 (we only run this instruction
                        \ if the V flag is set)

 STA SOFRQ,X            \ Store the frequency in A into the SOFRQ entry for
                        \ voice X

 LDA SFXATK,Y           \ Store the attack ??? for sound effect Y in the SOATK
 STA SOATK,X            \ entry for voice X

 LDA SFXVCH,Y           \ Store the ??? for sound effect Y in the SOVCH entry
 STA SOVCH,X            \ for voice X

 INY                    \ Increment the sound effect number in Y

 TYA                    \ Store the incremented sound effect number in the low
 ORA #%10000000         \ bits of the SOFLG entry for voice X (so the lower bits
 STA SOFLG,X            \ are non-zero) and set bit 7 to ???

 CLI                    \ Enable interrupts again

 SEC                    \ Set the C flag

 RTS                    \ Return from the subroutine

