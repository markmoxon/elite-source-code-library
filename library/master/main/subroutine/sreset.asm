\ ******************************************************************************
\
\       Name: SRESET
\       Type: Subroutine
\   Category: Sound
\    Summary: Reset the sound buffer and turn off all sound channels
\
\ ******************************************************************************

.SRESET

 LDY #3                 \ We need to zero the first 3 bytes of the sound buffer
                        \ at SBUF, so set a counter in Y

 LDA #0                 \ Set A to 0 so we can zero the sound buffer

.SRL1

 STA SBUF-1,Y           \ Zero the Y-1th byte of SBUF

 DEY                    \ Decrement the loop counter

 BNE SRL1               \ Loop back to zero the next byte until we have done all
                        \ three from SBUF+2 down to SBUF

 SEI                    \ Disable interrupts while we update the sound chip

                        \ At this point Y = 0, which we can now use as a loop
                        \ counter to loop throug the 5 bytes in QUIET and send
                        \ them directly to the 76489 sound chip to set the
                        \ volume levels on all 4 sound channels to 15 (silent)
                        \ and the noise register on channel 3 to %111

.SRL2

 LDA QUIET,Y            \ Fetch the Y-th byte of QUIET

 JSR SOUND              \ Write the value in A directly to the 76489 sound chip

 INY                    \ Increment the loop counter

 CPY #5                 \ Loop back until we have sent all 5 bytes to the sound
 BNE SRL2               \ chip

 CLI                    \ Enable interrupts again

 RTS                    \ Return from the subroutine

