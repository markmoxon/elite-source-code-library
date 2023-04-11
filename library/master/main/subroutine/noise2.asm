\ ******************************************************************************
\
\       Name: NOISE2
\       Type: Subroutine
\   Category: Sound
\    Summary: Process the contents of the sound buffer and send it to the sound
\             chip
\
\ ******************************************************************************

.NOISE2

                        \ This routine is called from the IRQ1 interrupt handler
                        \ and appears to process the contents of the SBUF sound
                        \ buffer, sending the results to the 76489 sound chip.
                        \ What it's actually doing, though, is a bit of a
                        \ mystery, so this part needs more investigation

 LDY #2                 \ We want to loop through the three tone channels, so
                        \ set a counter in Y to iterate through the channels

.NSL1

 LDA SBUF,Y             \ If the Y-th byte of SBUF is zero, there is no data
 BEQ NS8                \ buffered for this channel, so jump to NS8 to move onto
                        \ the next one

 BMI NS2                \ If bit 7 of the Y-th byte of SBUF is set, jump to NS2

 LDA SBUF+15,Y          \ If SBUF+15+Y = 0, jump to NS3
 BEQ NS3

 EQUB &2C               \ Skip the next instruction by turning it into
                        \ &2C &A9 &00, or BIT &00A9, which does nothing apart
                        \ from affect the flags

.NS2

 LDA #0                 \ Set A = 0

 CLC                    \ Clear the C flag for the additions below

 CLD                    \ Clear the D flag to ensure we are in binary mode

 ADC SBUF+18,Y          \ Set SBUF+18+Y = SBUF+18+Y + A
 STA SBUF+18,Y

 PHA                    \ Store A on the stack

 ASL A                  \ Set A = (A * 4) mod 16
 ASL A
 AND #%00001111

 ORA CHANNEL,Y          \ Set the channel to 0, 1, 2 for Y = 2, 1, 0

 JSR SOUND              \ Write the value in A directly to the 76489 sound chip

 PLA                    \ Retrieve A from the stack

 LSR A                  \ Set A = A / 4
 LSR A

 JSR SOUND              \ Write the value in A directly to the 76489 sound chip

.NS3

 TYA                    \ Copy Y into X
 TAX

 LDA SBUF,Y             \ If bit 7 of the Y-th byte of SBUF is set, jump to NS5
 BMI NS5

 DEC SBUF+3,X           \ Decrement SBUF+3+X

 BEQ NS4                \ If the value is zero, skip to NS4

 LDA SBUF+3,X           \ If SBUF+3+X AND SBUF+9+X is non-zero, skip to NS8
 AND SBUF+9,X
 BNE NS8

 DEC SBUF+6,X           \ Decrement SBUF+6+X

 BNE NS6                \ If the value is non-zero, skip to NS6

.NS4

 LDA #0                 \ Set SBUF+Y = 0
 STA SBUF,Y

 STA SBUF+12,Y          \ Set SBUF+12+Y = 0

 BEQ NS7                \ Jump to NS7 (this BEQ is effectively a JMP as A is
                        \ always zero)

.NS5

 LSR SBUF,X             \ Halve the value in SBUF+X

.NS6

 LDA SBUF+6,Y           \ Set A = SBUF+6+Y + VOL
 CLC                    \
 ADC VOL                \ where VOL is the the current volume setting (0-7)

.NS7

 EOR QUIET,Y            \ EOR A with the Y-th byte of QUIET

 JSR SOUND              \ Write the value in A directly to the 76489 sound chip

.NS8

 DEY                    \ Decrement the loop counter

 BPL NSL1               \ Loop back to NSL1 until we have done all three
                        \ channels

.NS9

 RTS                    \ Return from the subroutine

