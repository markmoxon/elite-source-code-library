\ ******************************************************************************
\
\       Name: SOFLUSH
\       Type: Subroutine
\   Category: Sound
\    Summary: Reset the sound buffer and turn off all sound channels
\
\ ******************************************************************************

.SOFLUSH

 LDY #3                 \ We need to zero the first 3 bytes of the sound buffer
                        \ at SOFLG, so set a counter in Y

 LDA #0                 \ Set A to 0 so we can zero the sound buffer

.SOUL2

 STA SOFLG-1,Y          \ Zero the Y-1th byte of SOFLG

 DEY                    \ Decrement the loop counter

 BNE SOUL2              \ Loop back to zero the next byte until we have done all
                        \ three from SOFLG+2 down to SOFLG

 SEI                    \ Disable interrupts while we update the sound chip

                        \ At this point Y = 0, which we can now use as a loop
                        \ counter to loop through the 5 bytes in SOOFF and send
                        \ them directly to the 76489 sound chip to set the
                        \ volume levels on all 4 sound channels to 15 (silent)
                        \ and the noise register on channel 3 to %111

.SOUL1

 LDA SOOFF,Y            \ Fetch the Y-th byte of SOOFF

 JSR SOUS1              \ Write the value in A directly to the 76489 sound chip

 INY                    \ Increment the loop counter

 CPY #5                 \ Loop back until we have sent all 5 bytes to the sound
 BNE SOUL1              \ chip

 CLI                    \ Enable interrupts again

 RTS                    \ Return from the subroutine

