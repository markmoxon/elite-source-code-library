\ ******************************************************************************
\
\       Name: SetupDemoUniverse
\       Type: Subroutine
\   Category: Combat demo
\    Summary: Initialise the local bubble of universe for the demo
\  Deep dive: The NES combat demo
\
\ ******************************************************************************

.SetupDemoUniverse

 LDY #12                \ Wait until 12 NMI interrupts have passed (i.e. the
 JSR DELAY              \ next 12 VBlanks)

 LDA #0                 \ Set A = 0
 CLC                    \
 ADC #0                 \ The ADC has no effect, so presumably it was left over
                        \ from a previous version of the code

 STA nmiCounter         \ Reset the NMI counter to zero

 STA nmiTimer           \ Set the NMI timer to zero
 STA nmiTimerLo
 STA nmiTimerHi

 STA hiddenBitplane     \ Set the hidden, NMI and drawing bitplanes to 0
 STA nmiBitplane
 STA drawingBitplane

 LDA #&FF               \ Set soundVibrato = &FF &80 &1B &34 to set the seeds
 STA soundVibrato       \ for the randomised vibrato that's applied to sound
 LDA #&80               \ effects
 STA soundVibrato+1
 LDA #&1B
 STA soundVibrato+2
 LDA #&34
 STA soundVibrato+3

 JSR ResetOptions       \ Reset the game options to their default values

 LDA #0                 \ Set K%+6 to 0 so the random number seeding at the
 STA K%+6               \ start of the main game loop at TT100 proceeds in a
                        \ predictable manner

 STA K%                 \ Set K% to 0 so the random number seeding at the start
                        \ of the main flight loop at M% proceeds in a
                        \ predictable manner

                        \ Fall through into FixRandomNumbers to set the random
                        \ number seeds to a known state

