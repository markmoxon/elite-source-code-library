\ ******************************************************************************
\
\       Name: Elite loader (Part 6 of 6)
\       Type: Subroutine
\   Category: Loader
\    Summary: Set up interrupt vectors, calculate checksums, run main game code
\
\ ------------------------------------------------------------------------------
\
\ This is the final part of the loader. It sets up some of the main game's
\ interrupt vectors and calculates various checksums, before finally handing
\ over to the main game.
\
\ ******************************************************************************

 LDA VIA+&44            \ Read the 6522 System VIA T1C-L timer 1 low-order
 STA 1                  \ counter (SHEILA &44) which increments 1000 times a
                        \ second so this will be pretty random, and store it in
                        \ location 1, which is among the main game code's random
                        \ seeds in RAND (so this seeds the random numbers for
                        \ the main game)

 SEI                    \ Disable all interrupts

 LDA #%00111001         \ Set 6522 System VIA interrupt enable register IER
 STA VIA+&4E            \ (SHEILA &4E) bits 0 and 3-5 (i.e. disable the Timer1,
                        \ CB1, CB2 and CA2 interrupts from the System VIA)

\LDA #&7F               \ These instructions are commented out in the original
\STA &FE6E              \ source with the comment "already done", which they
\LDA IRQ1V              \ were, in part 4
\STA VEC
\LDA IRQ1V+1
\STA VEC+1

 LDA S%+4               \ S% points to the entry point for the main game code,
 STA IRQ1V              \ so this copies the address of the main game's IRQ1
 LDA S%+5               \ routine from the start of the main code into IRQ1V
 STA IRQ1V+1

 LDA #VSCAN             \ Set 6522 System VIA T1C-L timer 1 high-order counter
 STA VIA+&45            \ (SHEILA &45) to VSCAN (56) to start the T1 counter
                        \ counting down from 14080 at a rate of 1 MHz (this is
                        \ a different value to the main game code)

 CLI                    \ Re-enable interrupts

\LDA #129               \ These instructions are commented out in the original
\LDY #&FF               \ source. They call OSBYTE with A = 129, X = 1 and
\LDX #1                 \ Y = &FF, which returns the machine type in X, so
\JSR OSBYTE             \ this code would detect the MOS version
\TXA
\EOR #&FF
\STA MOS
\BMI BLAST

 LDY #0                 \ Call OSBYTE with A = 200, X = 3 and Y = 0 to disable
 LDA #200               \ the ESCAPE key and clear memory if the BREAK key is
 LDX #3                 \ pressed
 JSR OSBYTE

                        \ The rest of the routine calculates various checksums
                        \ and makes sure they are correct before proceeding, to
                        \ prevent code tampering. We start by calculating the
                        \ checksum for the main game code from &0F40 to &5540,
                        \ which just adds up every byte and checks it against
                        \ the checksum stored at the end of the main game code

.BLAST

 LDA #HI(S%)            \ Set ZP(1 0) = S%
 STA ZP+1               \
 LDA #LO(S%)            \ so ZP(1 0) points to the start of the main game code
 STA ZP

 LDX #&45               \ We are going to checksum &45 pages from &0F40 to &5540
                        \ so set a page counter in X

 LDY #0                 \ Set Y to count through each byte within each page

 TYA                    \ Set A = 0 for building the checksum

.CHK

 CLC                    \ Add the Y-th byte of this page of the game code to A
 ADC (ZP),Y

 INY                    \ Increment the counter for this page

 BNE CHK                \ Loop back for the next byte until we have finished
                        \ adding up this page

 INC ZP+1               \ Increment the high byte of ZP(1 0) to point to the
                        \ next page

 DEX                    \ Decrement the page counter we set in X

 BPL CHK                \ Loop back to add up the next page until we have done
                        \ them all

IF _REMOVE_CHECKSUMS

 LDA #0                 \ If the checksum is disabled, just set A to 0 so the
 NOP                    \ BEQ below jumps to itsOK

ELSE

 CMP D%-1               \ D% is set to the size of the main game code, so this
                        \ compares the result to the last byte in the main game
                        \ code, at location checksum0

ENDIF

 BEQ itsOK              \ If the checksum we just calculated matches the value
                        \ in location checksum0, jump to itsOK

.nononono

 STA S%+1               \ If we get here then the checksum was wrong, so first
                        \ we store the incorrect checksum value in the low byte
                        \ of the address stored at the start of the main game
                        \ code, which contains the address of TT170, the entry
                        \ point for the main game (so this hides this address
                        \ from prying eyes)

 LDA #%01111111         \ Set 6522 System VIA interrupt enable register IER
 STA &FE4E              \ (SHEILA &4E) bits 0-6 (i.e. disable all hardware
                        \ interrupts from the System VIA)

 JMP (&FFFC)            \ Jump to the address in &FFFC to reset the machine

.itsOK

 JMP (S%)               \ The checksum was correct, so we call the address held
                        \ in the first two bytes of the main game code, which
                        \ point to TT170, the entry point for the main game
                        \ code, so this, finally, is where we hand over to the
                        \ game itself

