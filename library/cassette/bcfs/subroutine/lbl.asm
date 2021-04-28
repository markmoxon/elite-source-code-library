\ ******************************************************************************
\
\       Name: LBL
\       Type: Subroutine
\   Category: Copy protection
\    Summary: Checksum the two pages of code that were copied from UU% to LE%
\
\ ------------------------------------------------------------------------------
\
\ This routine is called at LBL+1 from the CHECKER routine in the loader code in
\ elite-loader.asm. It calculates the checksum of the first two pages of the
\ loader code that was copied from UU% to LE% by part 3 of the loader, and
\ checks the result against the result in the first byte of the LE% block,
\ CHECKbyt, at address &0B00.
\
\ Other entry points:
\
\   LBL+2               Contains an RTS
\
\ ******************************************************************************

.LBL

 EQUB &6C               \ This is the opcode for an indirect JMP instruction,
                        \ and the opcode for LDX #&60 is &A2 &60, so together
                        \ the first three bytes are:
                        \
                        \   &6C &A2 &60 : JMP (&60A2)
                        \
                        \ Also, the third byte is &60, which is the opcode for
                        \ an RTS instruction, so jumping to LBL+2 (which we do
                        \ below) is the same as doing an RTS

 LDX #&60               \ Set X = &60 (this value of X isn't used, it's just a
                        \ set up for the JMP instruction and the RTS call below,
                        \ both of which are designed to confuse crackers

                        \ We now run a checksum on the block of memory from
                        \ &0B01 to &0CFF, which is the UU% routine from the
                        \ loader

 LDA #&B                \ Set ZP(1 0) = &0B00, to point to the start of the code
 STA ZP+1               \ we want to checksum

 LDY #0                 \ Set Y = 0 to count through each byte within each page
 STY ZP

 TYA                    \ Set A = 0 for building the checksum

 INY                    \ Increment Y to 1

.CHK3

 CLC                    \ Add the Y-th byte of the game code to A
 ADC (ZP),Y

 INY                    \ Increment the counter to point to the next byte

 BNE CHK3               \ Loop back for the next byte until we have finished
                        \ adding up this page

 INC ZP+1               \ Increment the high byte of ZP(1 0) to point to the
                        \ next page

.CHK4

 CLC                    \ Add the Y-th byte of this page to the checksum in A
 ADC (ZP),Y

 INY                    \ Increment the counter for this page

 BPL CHK4               \ Loop back for the next byte until we have finished
                        \ adding up this second page

 CMP &0B00              \ Compare the result to the contents of CHECKbyt in the
                        \ loader code at elite-loader.asm. This values gets set
                        \ by elite-checksum.py

 BEQ LBL+2              \ If the checksums match, jump to LBL+2, which contains
                        \ an RTS

                        \ Otherwise the checksum just failed, so we reset the
                        \ machine

 LDA #%01111111         \ Set 6522 System VIA interrupt enable register IER
 STA &FE4E              \ (SHEILA &4E) bits 0-6 (i.e. disable all hardware
                        \ interrupts from the System VIA)

 JMP (&FFFC)            \ Jump to the address in &FFFC to reset the machine

