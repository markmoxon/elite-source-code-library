\ ******************************************************************************
\
\       Name: ApplyEnvelopeTRI
\       Type: Subroutine
\   Category: Sound
\    Summary: Apply volume and pitch changes to the TRI channel
\  Deep dive: Music in NES Elite
\
\ ******************************************************************************

.ApplyEnvelopeTRI

 LDA volumeCounterTRI   \ If volumeCounterTRI = 0 then we are not counting down
 BEQ muse1              \ to a volume change, so jump to muse1 to move on to the
                        \ pitch envelope

 DEC volumeCounterTRI   \ Decrement the counter for the volume change

 BNE muse1              \ If the counter is still non-zero, then we haven't yet
                        \ done counted down to the volume change, so jump to
                        \ muse1 to skip the following

 LDA #%00000000         \ Configure the TRI channel as follows:
 STA TRI_LINEAR         \
                        \   * Bit 7 clear = do not reload the linear counter
                        \
                        \   * Bits 0-6    = counter reload value of 0
                        \
                        \ So this silences the TRI channel

.muse1

                        \ We now move on to the pitch envelope

 LDX pitchEnvelopeTRI   \ Set X to the number of the pitch envelope to apply

 LDA pitchEnvelopeLo,X  \ Set soundAddr(1 0) to the address of the data for
 STA soundAddr          \ pitch envelope X from the (i.e. pitchEnvelope0 for
 LDA pitchEnvelopeHi,X  \ envelope 0, pitchEnvelope1 for envelope 1, and so on)
 STA soundAddr+1

 LDY pitchIndexTRI      \ Set A to the byte of envelope data at the index in
 LDA (soundAddr),Y      \ pitchIndexTRI, which we increment to move through the
                        \ data one byte at a time

 CMP #&80               \ If A is not &80 then we just fetched a valid byte of
 BNE muse2              \ envelope data, so jump to muse2 to process it

                        \ If we get here then we just fetched a &80 from the
                        \ pitch envelope, which indicates the end of the list of
                        \ envelope values, so we now loop around to the start of
                        \ the list, so it keeps repeating

 LDY #0                 \ Set pitchIndexTRI = 0 to point to the start of the
 STY pitchIndexTRI      \ data for pitch envelope X

 LDA (soundAddr),Y      \ Set A to the byte of envelope data at index 0, so we
                        \ can fall through into muse2 to process it

.muse2

 INC pitchIndexTRI      \ Increment the index into the pitch envelope so we
                        \ move on to the next byte of data in the next iteration

 CLC                    \ Set triLo = triLoCopy + A
 ADC triLoCopy          \
 STA triLo              \ So this alters the low byte of the pitch that we send
                        \ to the APU via TRI_LO, altering it by the amount in
                        \ the byte of data we just fetched from the pitch
                        \ envelope

 RTS                    \ Return from the subroutine

