\ ******************************************************************************
\
\       Name: ApplyEnvelopeNOISE
\       Type: Subroutine
\   Category: Sound
\    Summary: Apply volume and pitch changes to the NOISE channel
\
\ ******************************************************************************

.ApplyEnvelopeNOISE

 LDA applyVolumeNOISE   \ If applyVolumeNOISE = 0 then we do not apply the
 BEQ musg2              \ volume envelope, so jump to musg2 to move on to the
                        \ pitch envelope

 LDX volumeEnvelopeNOISE    \ Set X to the number of the volume envelope to
                            \ apply

 LDA volumeEnvelopeLo,X \ Set soundAddr(1 0) to the address of the data for
 STA soundAddr          \ volume envelope X from the (i.e. volumeEnvelope0 for
 LDA volumeEnvelopeHi,X \ envelope 0, volumeEnvelope1 for envelope 1, and so on)
 STA soundAddr+1

 LDY #0                 \ Set volumeRepeatNOISE to the first byte of envelope
 LDA (soundAddr),Y      \ data, which contains the number of times to repeat
 STA volumeRepeatNOISE  \ each entry in the envelope

 LDY volumeIndexNOISE   \ Set A to the byte of envelope data at the index in
 LDA (soundAddr),Y      \ volumeIndexNOISE, which we increment to move through
                        \ the data one byte at a time

 BMI musg1              \ If bit 7 of A is set then we just fetched the last
                        \ byte of envelope data, so jump to musg1 to skip the
                        \ following

 DEC volumeCounterNOISE \ Decrement the counter for this envelope byte

 BPL musg1              \ If the counter is still positive, then we haven't yet
                        \ done all the repeats for this envelope byte, so jump
                        \ to musg1 to skip the following

                        \ Otherwise this is the last repeat for this byte of
                        \ envelope data, so now we reset the counter and move
                        \ on to the next byte

 LDX volumeRepeatNOISE  \ Reset the repeat counter for this envelope to the
 STX volumeCounterNOISE \ first byte of envelope data that we fetched above,
                        \ which contains the number of times to repeat each
                        \ entry in the envelope

 INC volumeIndexNOISE   \ Increment the index into the volume envelope so we
                        \ move on to the next byte of data in the next iteration

.musg1

 AND #%00001111         \ Extract the low nibble from the envelope data, which
                        \ contains the volume level

 ORA #%00110000         \ Set bits 5 and 6 to configure the NOISE channel as
                        \ follows:
                        \
                        \   * Bit 5 set   = infinite play
                        \
                        \   * Bit 4 set   = constant volume
                        \
                        \ Bits 6 and 7 are not used in the NOISE_VOL register

 STA noiseVolume        \ Set noiseVolume to the resulting volume byte so it
                        \ gets sent to the APU via NOISE_VOL

.musg2

                        \ We now move on to the pitch envelope

 LDX pitchEnvelopeNOISE \ Set X to the number of the pitch envelope to apply

 LDA pitchEnvelopeLo,X  \ Set soundAddr(1 0) to the address of the data for
 STA soundAddr          \ pitch envelope X from the (i.e. pitchEnvelope0 for
 LDA pitchEnvelopeHi,X  \ envelope 0, pitchEnvelope1 for envelope 1, and so on)
 STA soundAddr+1

 LDY pitchIndexNOISE    \ Set A to the byte of envelope data at the index in
 LDA (soundAddr),Y      \ pitchIndexNOISE, which we increment to move through
                        \ the data one byte at a time

 CMP #&80               \ If A is not &80 then we just fetched a valid byte of
 BNE musg3              \ envelope data, so jump to musg3 to process it

                        \ If we get here then we just fetched a &80 from the
                        \ pitch envelope, which indicates the end of the list of
                        \ envelope values, so we now loop around to the start of
                        \ the list, so it keeps repeating

 LDY #0                 \ Set pitchIndexNOISE = 0 to point to the start of the
 STY pitchIndexNOISE    \ data for pitch envelope X

 LDA (soundAddr),Y      \ Set A to the byte of envelope data at index 0, so we
                        \ can fall through into musg3 to process it

.musg3

 INC pitchIndexNOISE    \ Increment the index into the pitch envelope so we
                        \ move on to the next byte of data in the next iteration

 CLC                    \ Set noiseLo = low nibble of noiseLoCopy + A
 ADC noiseLoCopy        \
 AND #%00001111         \ So this alters the low byte of the pitch that we send
 STA noiseLo            \ to the APU via NOISE_LO, altering it by the amount in
                        \ the byte of data we just fetched from the pitch
                        \ envelope
                        \
                        \ We extract the low nibble because the top nibble is
                        \ ignored in NOISE_LO, except for bit 7, which we want
                        \ to clear so the period of the random noise generation
                        \ is normal and not shortened

 RTS                    \ Return from the subroutine

