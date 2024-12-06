\ ******************************************************************************
\
\       Name: SOINT
\       Type: Subroutine
\   Category: Sound
\    Summary: Process the contents of the sound buffer and send it to the sound
\             chip, to make sound effects as part of the interrupt routine
\
\ ******************************************************************************

.SOINT

 LDY #2                 \ We are going to work our way through the three voices
                        \ and process each one in turn, so set a voice counter
                        \ in Y to go from 2 to 0, for voices 3 to 1

.SOUL8

 LDA SOFLG,Y            \ Set A to the sound flag in SOFLG for voice Y

 BEQ SOUL3b             \ If the sound flag is zero then no sound effect is
                        \ being made on voice Y, so jump to SOUL3b to move on to
                        \ the next voice, or return from the interrupt if this
                        \ is the last voice

 BMI SOUL4              \ If bit 7 of the sound flag is set then we are just
                        \ starting to make a new sound effect, so jump to SOUL4
                        \ to reset the SID registers for voice Y

 LDX SEVENS,Y           \ Use the lookup table at SEVENS to set X = 7 * Y, so it
                        \ can be used as an index into the SID registers for
                        \ voice Y (as each of the three voices has seven
                        \ associated register bytes, starting at to SID, SID+&7
                        \ and SID+&E for voices 1, 2 and 3 respectively)

 LDA SOFRCH,Y           \ If the SOFRCH value for voice Y is zero, then there is
 BEQ SOUL5              \ no frequency change to apply, so jump to SOUL5 to skip
                        \ past the frequency addition in SOUX2

 BNE SOUX2              \ Otherwise jump to SOUX2 to apply the frequency change
                        \ in A (this BNE is effectively a JMP as we just passed
                        \ through a BEQ above)

\EQUB &2C               \ This instruction is commented out in the original
                        \ source

.SOUL4

                        \ If we get here then this is a new sound on voice Y, so
                        \ we need to initialise the voice

 LDA SEVENS,Y           \ Use the lookup table at SEVENS to set A = 7 * Y

 STA SOUX3+1            \ Modify the STA instruction at SOUX3 to point to the
                        \ correct block of seven SID registers for voice Y, so
                        \ we zero the SID registers for voice Y in the following

 LDA #0                 \ Set A = 0 to use for zeroing the SID registers

 LDX #6                 \ There are seven bytes of SID registers for each voice,
                        \ so set a counter in X so we can zero them all

.SOUX3

 STA SID,X              \ Zero SID register X for voice Y
                        \
                        \ This instruction was modified by the above to point to
                        \ the register block for voice Y, so it zeroes register
                        \ byte X for voice Y, rather than voice 1

 DEX                    \ Decrement the byte counter

 BPL SOUX3              \ Loop back until we have zeroed all seven bytes of SID
                        \ registers for voice Y

 LDX SEVENS,Y           \ Use the lookup table at SEVENS to set X = 7 * Y, so it
                        \ can be used as an index into the SID registers for
                        \ voice Y

 LDA SOCR,Y             \ Set SID register &4 (the voice control register) for
 STA SID+&4,X           \ voice Y to the value from SOPR for voice Y, to control
                        \ the sound as follows:
                        \
                        \   * Bit 0: 0 = voice off, release cycle
                        \            1 = voice on, attack-decay-sustain cycle
                        \
                        \   * Bit 1 set = synchronization enabled
                        \
                        \   * Bit 2 set = ring modulation enabled
                        \
                        \   * Bit 3 set = disable voice, reset noise generator
                        \
                        \   * Bit 4 set = triangle waveform enabled
                        \
                        \   * Bit 5 set = saw waveform enabled
                        \
                        \   * Bit 6 set = square waveform enabled
                        \
                        \   * Bit 7 set = noise waveform enabled
                        \
                        \ These values come from the SFXCR table

 LDA SOATK,Y            \ Set SID register &5 (the attack and decay length) for
 STA SID+&5,X           \ voice Y to the value from SOATK for voice Y, to
                        \ control the sound as follows:
                        \
                        \   * Bits 0-3 = decay length
                        \
                        \   * Bits 4-7 = attack length
                        \
                        \ These values come from the SFXATK table

 LDA SOSUS,Y            \ Set SID register &6 (the release length and sustain
 STA SID+&6,X           \ volume) for voice Y to the value from SOSUS for voice
                        \ Y, to control the sound as follows:
                        \
                        \   * Bits 0-3 = release length
                        \
                        \   * Bits 4-7 = sustain volume
                        \
                        \ These values come from the SFXSUS table, but can be
                        \ overridden manually using the NOISE2 routine

 LDA #0                 \ Set A = 0 so the following frequency calculation has
                        \ no effect, as we are just adding 0 to the frequency

.SOUX2

                        \ We jump here if this is an existing sound whose SOFRCH
                        \ value is non-zero, in which case the non-zero value is
                        \ in A
                        \
                        \ SOFRCH contains a frequency change to be applied in
                        \ each frame, so we now add that to the frequency in
                        \ SOFRQ
                        \
                        \ If this is a new sound then we get here with A = 0, so
                        \ the frequency doesn't change
                        \
                        \ Is this is an existing sound with a frequency change
                        \ of 0, then we already jumped past this calculation and
                        \ went straight to SOUL5 from above

 CLC                    \ Add A to the SOFRQ value for voice Y, so the frequency
 CLD                    \ change gets applied
 ADC SOFRQ,Y
 STA SOFRQ,Y

 PHA                    \ Store the frequency from SOFRQ on the stack, so we can
                        \ extract the different parts to send to the SID chip

 LSR A                  \ Set SID register &1 (high byte of the frequency) for
 LSR A                  \ voice Y to bits 2-7 of A
 STA SID+&1,X

 PLA                    \ Set SID register &0 (low byte of the frequency) for
 ASL A                  \ voice Y so that bits 0-1 of A are in bits 6-7
 ASL A                  \
 ASL A                  \ So if "f" represents the value from SOFRQ, this sets
 ASL A                  \ the 16-bit frequency as follows (with the high byte on
 ASL A                  \ the left):
 ASL A                  \
 STA SID,X              \   00ffffff ff000000
                        \
                        \ Or, to put it another way, the frequency is set to
                        \ SOFRQ << 6, or SOFR * 64

 LDA PULSEW             \ Set SID register &3 (pulse width) for voice Y to the
 STA SID+&3,X           \ value of PULSEW, which oscillates between 2 and 6
                        \ for each frame

.SOUL5

 LDA SOFLG,Y            \ If bit 7 of the sound flag is set then this is a new
 BMI SOUL6              \ sound effect, and we just started making it, so jump
                        \ to SOUL6 to clear this bit in the sound flag as this
                        \ is no longer a new sound

 TYA                    \ Set X = Y, so both X and Y contain the voice number
 TAX                    \ in the range 0 to 2, which we'll call voice Y

 DEC SOPR,X             \ Decrement the priority in SOPR for voice Y, keeping
 BNE P%+5               \ it above zero, so sounds diminish in priority as they
 INC SOPR,X             \ play out

 DEC SOCNT,X            \ Decrement the counter in SOCNT for voice Y

 BEQ SOKILL             \ If the counter has reached zero then it has just run
                        \ out and this sound effect has finished, so jump to
                        \ SOKILL to terminate it

                        \ The SFXVCH table contains values whose lower bits are
                        \ all set (e.g. %00000011, %00001111, %000111111,
                        \ %11111111 and so on)
                        \
                        \ If we AND a number this with a value, this the result
                        \ will only be zero when the number is a multiple of the
                        \ SFXVCH value

 LDA SOCNT,X            \ If the sound effect counter is not a multiple of the
 AND SOVCH,Y            \ SOVCH value for voice Y, jump to SOUL3 to move on to
 BNE SOUL3              \ the next voice

                        \ If we get here then the sound effect counter is a
                        \ multiple of the SOVCH value for voice Y

 LDA SOSUS,Y            \ Subtract 16 from the release length and sustain
 SEC                    \ volume in SOSUS for voice Y
 SBC #16                \
 STA SOSUS,Y            \ This actually subtracts 1 from the high nibble of the
                        \ release length and sustain volume, and the high nibble
                        \ of the SOSUS value contains the sustain volume, so
                        \ this subtracts 1 from the sustain volume

 LDX SEVENS,Y           \ Use the lookup table at SEVENS to set X = 7 * Y, so it
                        \ can be used as an index into the SID registers for
                        \ voice Y

 STA SID+&6,X           \ Update SID register &6 (release length and sustain
                        \ volume) with the new value to reduce the volume of
                        \ the sound by 1

 JMP SOUL3              \ Jump to SOUL3 to move on to the next voice

.SOKILL

                        \ If we get here then the sound effect in voice Y has
                        \ reached the end of its counter, so we need to
                        \ terminate it

 LDX SEVENS,Y           \ Use the lookup table at SEVENS to set X = 7 * Y, so it
                        \ can be used as an index into the SID registers for
                        \ voice Y

 LDA SOCR,Y             \ Set SID register &4 (the voice control register) for
 AND #%11111110         \ voice Y to the value from SOPR for voice Y, but with
 STA SID+&4,X           \ bit 0 clear
                        \
                        \ Bit 0 controls the sound as follows:
                        \
                        \   * Bit 0: 0 = voice off, release cycle
                        \            1 = voice on, attack-decay-sustain cycle
                        \
                        \ So this turns the voice off, while leaving everything
                        \ else as it was

 LDA #0                 \ Zero the sound flag in SOFLG for voice Y to indicate
 STA SOFLG,Y            \ that no sound effect is playing on this voice any more

 STA SOPR,Y             \ Set the priority in SOPR for voice Y to zero, so any
                        \ new sound effects will always override the priority
                        \ of voice Y

 BEQ SOUL3              \ Jump to SOUL3 to move on to the next voice (this BEQ
                        \ is effectively a JMP as A is always zero)

.SOUL6

                        \ If we get here then bit 7 of the sound flag is set for
                        \ this sound (to indicate that it's a new sound effect),
                        \ and A contains the whole sound flag

 AND #%01111111         \ Clear bit 7 of A to indicate that this is no longer a
                        \ new sound effect

 STA SOFLG,Y            \ Update the sound flag for voice Y with the newly
                        \ cleared bit 7

.SOUL3

 DEY                    \ Decrement the voice number in Y to move on to the next
                        \ voice

 BMI P%+5               \ If we just decremented the voice number to a negative
                        \ value, then we have already processed all three
                        \ voices, so skip the following instruction to return
                        \ from the interrupt handler

 JMP SOUL8              \ Otherwise Y is still positive, so jump back to SOUL8
                        \ to make any sound effects on voice Y

 LDA PULSEW             \ Flip bit 2 of PULSEW, so it oscillates between 2 and 6
 EOR #%00000100
 STA PULSEW

\LDA #1                 \ These instructions are commented out in the original
\STA intcnt             \ source

                        \ Fall through into coffee to return from the interrupt
                        \ handler

