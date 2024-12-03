\ ******************************************************************************
\
\       Name: BDlab5
\       Type: Subroutine
\   Category: Sound
\    Summary: Fetch the next two music data bytes and set the frequency of
\             voice 2 (high byte then low byte) and the vibrato variables
\
\ ******************************************************************************

.BDlab5

 JSR BDlab19            \ Increment the music data pointer in BDdataptr1(1 0)
                        \ and fetch the next music data byte into A

 STA SID+&8             \ Set SID register &8 to the music data byte we just
                        \ fetched, which sets the high byte of the frequency
                        \ for voice 2

 STA voice2lo1          \ Store the high byte in the voice2lo variables
 STA voice2lo2

 JSR BDlab19            \ Increment the music data pointer in BDdataptr1(1 0)
                        \ and fetch the next music data byte into A

 STA SID+&7             \ Set SID register &7 to the music data byte we just
                        \ fetched, which sets the low byte of the frequency
                        \ for voice 2

 STA voice2hi1          \ Store the low byte in the voice2hi variables
 STA voice2hi2

                        \ So by this point we have the following:
                        \
                        \   (voice2lo1 voice2hi1) = frequency
                        \
                        \   (voice2lo2 voice2hi2) = frequency
                        \
                        \ Note that the variable naming here is a bit odd, as
                        \ the high bytes are in the voice2lo variables, and the
                        \ low bytes are in the voice2hi variables
                        \
                        \ These are the names from the original source code, so
                        \ let's roll with it

 CLC                    \ Clear the C flag for the addition below

 CLD                    \ Clear the D flag to make sure we are in binary mode,
                        \ as we are in an interrupt handler and can't be sure of
                        \ the flag state on entry

 LDA #32                \ Set (voice2lo2 voice2hi2) = (voice2lo2 voice2hi2) + 32
 ADC voice2hi2          \
 STA voice2hi2          \ So the second frequency in (voice2lo2 voice2hi2) is
 BCC BDruts1            \ now a bit higher than the first frequency, which we
 INC voice2lo2          \ can use to add vibrato to voice 2

.BDruts1

 RTS                    \ Return from the subroutine

