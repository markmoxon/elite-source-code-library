\ ******************************************************************************
\
\       Name: SOINT
\       Type: Subroutine
\   Category: Sound
\    Summary: Process the contents of the sound buffer and send it to the sound
\             chip
\
\ ******************************************************************************

.SOINT

                        \ This routine is called from the IRQ1 interrupt handler
                        \ and appears to process the contents of the SOFLG sound
                        \ buffer, sending the results to the 76489 sound chip.
                        \ What it's actually doing, though, is a bit of a
                        \ mystery, so this part needs more investigation

 LDY #2                 \ We want to loop through the three tone channels, so
                        \ set a counter in Y to iterate through the channels

.SOUL8

 LDA SOFLG,Y            \ If the Y-th byte of SOFLG is zero, there is no data
 BEQ SOUL3              \ buffered for this channel, so jump to SOUL3 to move
                        \ onto the next one

 BMI SOUL4              \ If bit 7 of the Y-th byte of SOFLG is set, jump to
                        \ SOUL4

 LDA SOFRCH,Y           \ If SOFRCH+Y = 0, jump to SOUL5
 BEQ SOUL5

 EQUB &2C               \ Skip the next instruction by turning it into
                        \ &2C &A9 &00, or BIT &00A9, which does nothing apart
                        \ from affect the flags

.SOUL4

 LDA #0                 \ Set A = 0

 CLC                    \ Clear the C flag for the additions below

 CLD                    \ Clear the D flag to ensure we are in binary mode

 ADC SOFRQ,Y            \ Set SOFRQ+Y = SOFRQ+Y + A
 STA SOFRQ,Y

 PHA                    \ Store A on the stack

 ASL A                  \ Set A = (A * 4) mod 16
 ASL A
 AND #%00001111

 ORA SOFH,Y             \ Set the channel to 0, 1, 2 for Y = 2, 1, 0

 JSR SOUS1              \ Write the value in A directly to the 76489 sound chip

 PLA                    \ Retrieve A from the stack

 LSR A                  \ Set A = A / 4
 LSR A

 JSR SOUS1              \ Write the value in A directly to the 76489 sound chip

.SOUL5

 TYA                    \ Copy Y into X
 TAX

 LDA SOFLG,Y            \ If bit 7 of the Y-th byte of SOFLG is set, jump to
 BMI SOUL6              \ SOUL6

 DEC SOCNT,X            \ Decrement SOCNT+X

 BEQ SOKILL             \ If the value is zero, skip to SOKILL

 LDA SOCNT,X            \ If SOCNT+X AND SOVCH+X is non-zero, skip to SOUL3
 AND SOVCH,X
 BNE SOUL3

 DEC SOVOL,X            \ Decrement SOVOL+X

 BNE SOU1               \ If the value is non-zero, skip to SOU1

.SOKILL

 LDA #0                 \ Set SOFLG+Y = 0
 STA SOFLG,Y

 STA SOPR,Y             \ Set SOPR+Y = 0

 BEQ SOU3               \ Jump to SOU3 (this BEQ is effectively a JMP as A is
                        \ always zero)

.SOUL6

 LSR SOFLG,X            \ Halve the value in SOFLG+X

.SOU1

 LDA SOVOL,Y            \ Set A = SOVOL+Y + VOL
 CLC                    \
 ADC VOL                \ where VOL is the the current volume setting (0-7)

.SOU3

 EOR SOOFF,Y            \ EOR A with the Y-th byte of SOOFF

 JSR SOUS1              \ Write the value in A directly to the 76489 sound chip

.SOUL3

 DEY                    \ Decrement the loop counter

 BPL SOUL8              \ Loop back to SOUL8 until we have done all three
                        \ channels

 RTS                    \ Return from the subroutine

