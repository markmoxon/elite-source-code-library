\ ******************************************************************************
\
\       Name: ApplyEnvelopeSQ2
\       Type: Subroutine
\   Category: Sound
\    Summary: Apply volume and pitch changes to the SQ2 channel
\
\ ******************************************************************************

.ApplyEnvelopeSQ2

 LDA applyVolumeSQ2     \ If applyVolumeSQ2 = 0 then we do not apply the volume
 BEQ muss2              \ envelope, so jump to muss2 to move on to the pitch
                        \ envelope

 LDX volumeEnvelopeSQ2  \ Set X to the number of the volume envelope to apply

 LDA volumeEnvelopeLo,X \ Set soundAddr(1 0) to the address of the data for
 STA soundAddr          \ volume envelope X from the (i.e. volumeEnvelope0 for
 LDA volumeEnvelopeHi,X \ envelope 0, volumeEnvelope1 for envelope 1, and so on)
 STA soundAddr+1

 LDY #0                 \ Set volumeRepeatSQ2 to the first byte of envelope
 LDA (soundAddr),Y      \ data, which contains the number of times to repeat
 STA volumeRepeatSQ2    \ each entry in the envelope

 LDY volumeIndexSQ2     \ Set A to the byte of envelope data at the index in
 LDA (soundAddr),Y      \ volumeIndexSQ2, which we increment to move through the
                        \ data one byte at a time

 BMI muss1              \ If bit 7 of A is set then we just fetched the last
                        \ byte of envelope data, so jump to muss1 to skip the
                        \ following

 DEC volumeCounterSQ2   \ Decrement the counter for this envelope byte

 BPL muss1              \ If the counter is still positive, then we haven't yet
                        \ done all the repeats for this envelope byte, so jump
                        \ to muss1 to skip the following

                        \ Otherwise this is the last repeat for this byte of
                        \ envelope data, so now we reset the counter and move
                        \ on to the next byte

 LDX volumeRepeatSQ2    \ Reset the repeat counter for this envelope to the
 STX volumeCounterSQ2   \ first byte of envelope data that we fetched above,
                        \ which contains the number of times to repeat each
                        \ entry in the envelope

 INC volumeIndexSQ2     \ Increment the index into the volume envelope so we
                        \ move on to the next byte of data in the next iteration

.muss1

 AND #%00001111         \ Extract the low nibble from the envelope data, which
                        \ contains the volume level

 ORA dutyLoopEnvSQ2     \ Set the high nibble of A to dutyLoopEnvSQ2, which gets
                        \ set via command byte &FA and which contains the duty,
                        \ loop and NES envelope settings to send to the APU

 STA sq2Volume          \ Set sq2Volume to the resulting volume byte so it gets
                        \ sent to the APU via SQ2_VOL

.muss2

                        \ We now move on to the pitch envelope

 LDX pitchEnvelopeSQ2   \ Set X to the number of the pitch envelope to apply

 LDA pitchEnvelopeLo,X  \ Set soundAddr(1 0) to the address of the data for
 STA soundAddr          \ pitch envelope X from the (i.e. pitchEnvelope0 for
 LDA pitchEnvelopeHi,X  \ envelope 0, pitchEnvelope1 for envelope 1, and so on)
 STA soundAddr+1

 LDY pitchIndexSQ2      \ Set A to the byte of envelope data at the index in
 LDA (soundAddr),Y      \ pitchIndexSQ2, which we increment to move through the
                        \ data one byte at a time

 CMP #&80               \ If A is not &80 then we just fetched a valid byte of
 BNE muss3              \ envelope data, so jump to muss3 to process it

                        \ If we get here then we just fetched a &80 from the
                        \ pitch envelope, which indicates the end of the list of
                        \ envelope values, so we now loop around to the start of
                        \ the list, so it keeps repeating

 LDY #0                 \ Set pitchIndexSQ2 = 0 to point to the start of the
 STY pitchIndexSQ2      \ data for pitch envelope X

 LDA (soundAddr),Y      \ Set A to the byte of envelope data at index 0, so we
                        \ can fall through into muss3 to process it

.muss3

 INC pitchIndexSQ2      \ Increment the index into the pitch envelope so we
                        \ move on to the next byte of data in the next iteration

 CLC                    \ Set sq2Lo = sq2LoCopy + A
 ADC sq2LoCopy          \
 STA sq2Lo              \ So this alters the low byte of the pitch that we send
                        \ to the APU via SQ2_LO, altering it by the amount in
                        \ the byte of data we just fetched from the pitch
                        \ envelope

 RTS                    \ Return from the subroutine

