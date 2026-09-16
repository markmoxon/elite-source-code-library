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
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   nononono            Reset the machine
\
\ ******************************************************************************

 LDA VIA+&44            \ Read the 6522 System VIA T1C-L timer 1 low-order
 STA &0001              \ counter (SHEILA &44), which decrements one million
                        \ times a second and will therefore be pretty random,
                        \ and store it in location &0001, which is among the
                        \ main game code's random seeds (so this seeds the
                        \ random number generator for the main game)

IF _INTERLACE_FIX

 LDA &0291              \ If interlace is on then the MOS will have set &0291 to
 BEQ lace1              \ zero, so jump to lace1 to skip the following

                        \ If we get here then interlace is off, so we modify the
                        \ split-screen interrupt timer from (57 30) to (56 222)
                        \ to ensure a clean transition between the space view
                        \ and dashboard, using figures derived by Patrick Moore

                        \ In the following, we modify LINSCN in the interrupt
                        \ routine in the main game code that we just loaded,
                        \ i.e. at &2172 (and not at the LINSCN in the loader)

 LDA #222               \ Modify the LDA #30 instruction in LINSCN to LDA #222
 STA &2172+1            \ to change the low-order T1 count to 222

 LDA #56                \ Modify the LDA #VSCAN instruction in LINSCN to LDA #56
 STA &2172+8            \ to change the high-order T1 count to 56

 STA lace2+1            \ Modify the LDA #VSCAN instruction at lace2 to LDA #56
                        \ to change the high-order T1 count to 56

.lace1

ENDIF

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

IF _INTERLACE_FIX

.lace2

ENDIF

 LDA #VSCAN             \ Set 6522 System VIA T1C-L timer 1 high-order counter
 STA VIA+&45            \ (SHEILA &45) to VSCAN (56) to start the T1 counter
                        \ counting down from 14080 at a rate of 1 MHz (this is
                        \ a different value to the main game code)

 CLI                    \ Re-enable interrupts

\LDA #129               \ These instructions are commented out in the original
\LDY #&FF               \ source. They call OSBYTE with A = 129, X = 1 and
\LDX #1                 \ Y = &FF, which returns the machine type in X, so
\JSR OSBYTE             \ this code would detect the MOS version
\
\TXA
\EOR #&FF
\STA MOS
\
\BMI BLAST

 LDY #0                 \ Call OSBYTE with A = 200, X = 3 and Y = 0 to disable
 LDA #200               \ the ESCAPE key and clear memory if the BREAK key is
 LDX #3                 \ pressed
 JSR OSBYTE

IF _INTERLACE_FIX

.nononono

 JMP (S%)               \ Skip the checksum (as we have modified the game code)
                        \ and call the address held in the first two bytes of
                        \ the main game code, which point to TT170, the entry
                        \ point for the main game code, so this, finally, is
                        \ where we hand over to the game itself

 SKIPTO &0CD1           \ Pad out the rest of the routine so it's the same size
                        \ as in the original loader, so we don't have to change
                        \ this part of the encryption in elite-checksum.py

ELSE

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

 LDA #0                 \ If we have disabled checksums, just set A to 0 so the
 NOP                    \ BEQ below jumps to itsOK

ELSE

 CMP D%-1               \ D% is set to the address of the byte after the end of
                        \ the code, so this compares the result to the last byte
                        \ in the main game code at location checksum0

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

ENDIF

