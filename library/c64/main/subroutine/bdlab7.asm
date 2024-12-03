\ ******************************************************************************
\
\       Name: BDlab7
\       Type: Subroutine
\   Category: Sound
\    Summary: Fetch the next two music data bytes and set the frequency of
\             voice 3 (high byte then low byte) and the vibrato variables
\
\ ******************************************************************************

.BDlab7

 JSR BDlab19            \ Increment the music data pointer in BDdataptr1(1 0)
                        \ and fetch the next music data byte into A

 STA SID+&F             \ Set SID register &F to the music data byte we just
                        \ fetched, which sets the high byte of the frequency
                        \ for voice 3

 STA voice3lo1          \ Store the high byte in the voice3lo variables
 STA voice3lo2

 JSR BDlab19            \ Increment the music data pointer in BDdataptr1(1 0)
                        \ and fetch the next music data byte into A

 STA SID+&E             \ Set SID register &E to the music data byte we just
                        \ fetched, which sets the low byte of the frequency
                        \ for voice 3

 STA voice3hi1          \ Store the low byte in the voice3hi variables
 STA voice3hi2

                        \ So by this point we have the following:
                        \
                        \   (voice3lo1 voice3hi1) = frequency
                        \
                        \   (voice3lo2 voice3hi2) = frequency
                        \
                        \ Note that the variable naming here is a bit odd, as
                        \ the high bytes are in the voice3lo variables, and the
                        \ low bytes are in the voice3hi variables
                        \
                        \ These are the names from the original source code, so
                        \ let's roll with it

 CLC                    \ Clear the C flag for the addition below

 CLD                    \ Clear the D flag to make sure we are in binary mode,
                        \ as we are in an interrupt handler and can't be sure of
                        \ the flag state on entry

IF _GMA_RELEASE

 LDA #37                \ Set A to the frequency change used when applying
                        \ vibrato to voice 3 (voice 2 applies a vibrato of 32,
                        \ so this sets a bigger vibrato frequency change for
                        \ voice 3)

ELIF _SOURCE_DISK

 LDA #32                \ Set A to the frequency change used when applying
                        \ vibrato to voice 3 (this is the same value as for
                        \ voice 2)

ENDIF

 ADC voice3hi2          \ Set (voice3lo2 voice3hi2) = (voice3lo2 voice3hi2) + A
 STA voice3hi2          \
 BCC BDruts2            \ So the second frequency in (voice3lo2 voice3hi2) is
 INC voice3lo2          \ now a bit higher than the first frequency, which we
                        \ can use to add vibrato to voice 3

.BDruts2

 RTS                    \ Return from the subroutine

