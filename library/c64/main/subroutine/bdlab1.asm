\ ******************************************************************************
\
\       Name: BDlab1
\       Type: Subroutine
\   Category: Sound
\    Summary: Apply vibrato before cleaning up and returning from the interrupt
\             routine
\
\ ******************************************************************************

.BDlab1

 INC vibrato3           \ Increment the vibrato counter for voice 3

IF _GMA_RELEASE

 LDA #5                 \ Set A = 5 so the period of the vibrato for voice 3 is
                        \ five interrupts

ELIF _SOURCE_DISK

 LDA #6                 \ Set A = 6 so the period of the vibrato for voice 3 is
                        \ six interrupts

ENDIF

 CMP vibrato3           \ If the vibrato counter for voice 3 has reached the
                        \ the value in A, then it is time to change the voice 3
                        \ frequency to implement vibrato, so jump to the address
                        \ in the following BEQ instruction, which gets modified
                        \ by the BDlab23 routine to oscillate between the two
                        \ halves of the BDlab23 routine
                        \
                        \ One half applies the lower vibrato frequency, and the
                        \ other applies the higher vibrato frequency, so the
                        \ effect is to flip between the two frequencies every A
                        \ interrupts

.BDbeqmod2

 BEQ BDlab23            \ Jump to the BDlab23 routine to switch to the correct
                        \ vibrato frequency and jump back to BDlab21 to clean up
                        \ and return from the interrupt routine

 INC vibrato2           \ Increment the vibrato counter for voice 2

IF _GMA_RELEASE

 LDA #4                 \ Set A = 5 so the period of the vibrato for voice 2 is
                        \ four interrupts

ELIF _SOURCE_DISK

 LDA #5                 \ Set A = 5 so the period of the vibrato for voice 2 is
                        \ five interrupts

ENDIF

 CMP vibrato2           \ If the vibrato counter for voice 2 has reached the
                        \ the value in A, then it is time to change the voice 2
                        \ frequency to implement vibrato, so jump to the address
                        \ in the following BEQ instruction, which gets modified
                        \ by the BDlab24 routine to oscillate between the two
                        \ halves of the BDlab24 routine
                        \
                        \ One half applies the lower vibrato frequency, and the
                        \ other applies the higher vibrato frequency, so the
                        \ effect is to flip between the two frequencies every A
                        \ interrupts

.BDbeqmod1

 BEQ BDlab24            \ Jump to the BDlab24 routine to switch to the correct
                        \ vibrato frequency and jump back to BDlab21 to clean up
                        \ and return from the interrupt routine

