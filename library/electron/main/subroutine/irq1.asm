\ ******************************************************************************
\
\       Name: IRQ1
\       Type: Subroutine
\   Category: Utility routines
\    Summary: The main interrupt handler (IRQ1V points here)
\
\ ******************************************************************************

.IRQ1

 LDA S%+6               \ Flip all the bits in S%+6 so it toggles between 0 and
 EOR #%11111111         \ &FF with each call to this routine (and set A to the
 STA S%+6               \ new value)

 ORA KEYB               \ If we are currently processing an OS command (OSWORD,
                        \ OSRDCH or OSFILE) then KEYB will be &FF rather than 0,
                        \ so A now contains the following:
                        \
                        \   * 0 if both S%+6 and KEYB are 0
                        \
                        \   * &FF if either of S%+6 or KEYB are &FF

 BMI jvec               \ If bit 7 of A is set, jump to jvec to skip the
                        \ following and process the interrupt as normal
                        \
                        \ This means that setting KEYB to a non-zero value will
                        \ enable interrupts, so that OS commands for reading the
                        \ keyboard and working with files commands will work,
                        \ while setting KEYB to zero will disable every other
                        \ interrupt to reduce slow-down

                        \ We only get here if S%+6 = 0 and KEYB = 0, so we only
                        \ do the following every other call to the interrupt
                        \ handler, and if we are not processing an OS command
                        \
                        \ The following clears all interrupts, so the net effect
                        \ of all this logic is that interrupts are only serviced
                        \ 50% of the time (unless the keyboard is being read, in
                        \ which case interrupts are serviced while this is the
                        \ case)
                        \
                        \ On the unexpanded Electron, the only interrupts that
                        \ trigger a call to IRQ1 are the following:
                        \
                        \   * High Tone Detect
                        \   * Real Time Clock (RTC)
                        \   * Display End
                        \
                        \ The first one only occurs when the tape input receives
                        \ ten successive bits of high tone, which won't happen
                        \ during a typical game of Elite, so the only interrupts
                        \ that will bring us here are the RTC and Display End
                        \ interrupts
                        \
                        \ Each of these fires 50 times a second, essentially
                        \ combining to give a 100Hz clock tick, so the logic
                        \ above skips every other interrupt, meaning we only
                        \ service half of the interrupts, one every 50Hz, and we
                        \ simply ignore the other half
                        \
                        \ This is an attempt to speed things up, as neither
                        \ interrupt is actually used by the game code

 LDA VIA+&05            \ On the surface, this code would appear to set bit 5 of
 ORA #%00100000         \ the "interrupt clear and paging" register at SHEILA
 STA VIA+&05            \ &05, to clear the RTC interrupt
                        \
                        \ However, SHEILA &05 is a read-only location, so the
                        \ LDA always returns &FF, which in turn means that this
                        \ code always sets SHEILA &05 to &FF, irrespective of
                        \ which interrupt got us here
                        \
                        \ This code therefore clears all interrupts (even NMI
                        \ interrupts) rather than just the RTC interrupt, by
                        \ setting bits 4 to 7, and it also pages out the BASIC
                        \ ROM by setting bits 0 to 3, though that doesn't have
                        \ any effect here
                        \
                        \ Interestingly, if the code worked as it was originally
                        \ intended and only cleared the RTC interrupt, then this
                        \ wouldn't necessarily have the desired effect, as we
                        \ don't check anywhere that this is actually the RTC
                        \ interrupt that we are processing; luckily, clearing
                        \ all interrupts will definitely clear the interrupt
                        \ that got us here, whatever it is, so this code still
                        \ does what we want
                        \
                        \ Given this, the LDA and ORA could be replaced by a
                        \ single LDA #&FF instruction to give us the same effect
                        \ but slightly more efficiently

 LDA &FC                \ Restore the value of A from before the call to the
                        \ interrupt handler (the MOS stores the value of A in
                        \ location &FC before calling the interrupt handler)

 RTI                    \ Return from interrupts, so this interrupt is not
                        \ passed on to the next interrupt handler, but instead
                        \ the interrupt terminates here

.jvec

 JMP (S%+2)             \ Jump to the original value of IRQ1V to process the
                        \ interrupt as normal

