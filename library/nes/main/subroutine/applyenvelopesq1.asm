\ ******************************************************************************
\
\       Name: ApplyEnvelopeSQ1
\       Type: Subroutine
\   Category: Sound
\    Summary: Apply volume and pitch changes to the SQ1 channel
\
\ ******************************************************************************

.ApplyEnvelopeSQ1

 LDA applyVolumeSQ1     \ If applyVolumeSQ1 = 0 then we do not apply the volume
 BEQ musv2              \ envelope, so jump to musv2 to move on to the pitch
                        \ envelope

 LDX volumeEnvelopeSQ1  \ Set X to the number of the volume envelope to apply

 LDA volumeEnvelopeLo,X \ Set soundAddr(1 0) to the address of the data for
 STA soundAddr          \ volume envelope X from the (i.e. volumeEnvelope0 for
 LDA volumeEnvelopeHi,X \ envelope 0, volumeEnvelope1 for envelope 1, and so on)
 STA soundAddr+1

 LDY #0                 \ Set volumeRepeatSQ1 to the first byte of envelope
 LDA (soundAddr),Y      \ data, which contains the number of times to repeat
 STA volumeRepeatSQ1    \ each entry in the envelope

 LDY volumeIndexSQ1     \ Set A to the byte of envelope data at the index in
 LDA (soundAddr),Y      \ volumeIndexSQ1, which we increment to move through the
                        \ data one byte at a time

 BMI musv1              \ If bit 7 of A is set then we just fetched the last
                        \ byte of envelope data, so jump to musv1 to skip the
                        \ following

 DEC volumeCounterSQ1   \ Decrement the counter for this envelope byte

 BPL musv1              \ If the counter is still positive, then we haven't yet
                        \ done all the repeats for this envelope byte, so jump
                        \ to musv1 to skip the following

                        \ Otherwise this is the last repeat for this byte of
                        \ envelope data, so now we reset the counter and move
                        \ on to the next byte

 LDX volumeRepeatSQ1    \ Reset the repeat counter for this envelope to the
 STX volumeCounterSQ1   \ first byte of envelope data that we fetched above,
                        \ which contains the number of times to repeat each
                        \ entry in the envelope

 INC volumeIndexSQ1     \ Increment the index into the volume envelope so we
                        \ move on to the next byte of data in the next iteration

.musv1

 AND #%00001111         \ Extract the low nibble from the envelope data, which
                        \ contains the volume level

 ORA dutyLoopEnvSQ1     \ Set the high nibble of A to dutyLoopEnvSQ1, which gets
                        \ set via command byte &FA and which contains the duty,
                        \ loop and NES envelope settings to send to the APU

 STA sq1Volume          \ Set sq1Volume to the resulting volume byte so it gets
                        \ sent to the APU via SQ1_VOL

.musv2

                        \ We now move on to the pitch envelope

 LDX pitchEnvelopeSQ1   \ Set X to the number of the pitch envelope to apply

 LDA pitchEnvelopeLo,X  \ Set soundAddr(1 0) to the address of the data for
 STA soundAddr          \ pitch envelope X from the (i.e. pitchEnvelope0 for
 LDA pitchEnvelopeHi,X  \ envelope 0, pitchEnvelope1 for envelope 1, and so on)
 STA soundAddr+1

 LDY pitchIndexSQ1      \ Set A to the byte of envelope data at the index in
 LDA (soundAddr),Y      \ pitchIndexSQ1, which we increment to move through the
                        \ data one byte at a time

 CMP #&80               \ If A is not &80 then we just fetched a valid byte of
 BNE musv3              \ envelope data, so jump to musv3 to process it

                        \ If we get here then we just fetched a &80 from the
                        \ pitch envelope, which indicates the end of the list of
                        \ envelope values, so we now loop around to the start of
                        \ the list, so it keeps repeating

 LDY #0                 \ Set pitchIndexSQ1 = 0 to point to the start of the
 STY pitchIndexSQ1      \ data for pitch envelope X

 LDA (soundAddr),Y      \ Set A to the byte of envelope data at index 0, so we
                        \ can fall through into musv3 to process it

.musv3

 INC pitchIndexSQ1      \ Increment the index into the pitch envelope so we
                        \ move on to the next byte of data in the next iteration

 CLC                    \ Set sq1Lo = sq1LoCopy + A
 ADC sq1LoCopy          \
 STA sq1Lo              \ So this alters the low byte of the pitch that we send
                        \ to the APU via SQ1_LO, altering it by the amount in
                        \ the byte of data we just fetched from the pitch
                        \ envelope

 RTS                    \ Return from the subroutine

