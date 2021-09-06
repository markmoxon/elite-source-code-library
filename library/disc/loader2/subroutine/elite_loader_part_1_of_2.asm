\ ******************************************************************************
\
\       Name: Elite loader (Part 1 of 2)
\       Type: Subroutine
\   Category: Loader
\    Summary: Various copy protection checks, and make sure there is no Tube
\
\ ******************************************************************************

.ENTRY

 LDA #0                 \ We start by deleting the first loader from memory, so
                        \ it doesn't leave any clues for the crackers, so set A
                        \ to 0 so we can zero the memory

 TAY                    \ Set Y to 0 to act as an index in the following loop

.LOOP1

 STA &2F00,Y            \ Zero the Y-th byte of &2F00, which is where the first
                        \ loader was running before it loaded this one

 INY                    \ Increment the loop counter

 BNE LOOP1              \ Loop back until we have zeroed all 256 bytes from
                        \ &2F00 to &2FFF, leaving Y = 0

 LDA #0                 \ Set &3FFF = 0
 STA &3FFF

 LDA #64                \ Set &7FFF = 64
 STA &7FFF

 EOR &3FFF              \ Set A = 64 EOR &3FFF
                        \       = 64 EOR 0
                        \       = 64

 CLC                    \ Set A = A + 64
 ADC #64                \       = 64 + 64
                        \       = 128

 PHA                    \ Push 128 on the stack

 TAX                    \ Set X = 128

 LDA #254               \ Call OSBYTE with A = 254, X = 128 and Y = 0 to set
 LDY #0                 \ the available RAM to 32K
 JSR OSBYTE

 PLA                    \ Pull 128 from the stack into A

 AND &5973              \ &5973 contains 128, so set A = 128 AND 128 = 128

IF _REMOVE_CHECKSUMS

 NOP                    \ If we have disabled checksums, ignore the result in A
 NOP

ELSE

 BEQ P%                 \ If A = 0 then enter an infinite loop, which hangs the
                        \ computer

ENDIF

 JSR PROT1              \ Call PROT1 to display the mode 7 loading screen and
                        \ perform lots of copy protection

 LDA #172               \ Call OSBYTE 172 to read the address of the MOS
 LDX #0                 \ keyboard translation table into (Y X)
 LDY #&FF
 JSR OSBYTE

 STX TRTB%              \ Store the address of the keyboard translation table in
 STY TRTB%+1            \ TRTB%(1 0)

 LDA #234               \ Call OSBYTE with A = 234, X = 0 and Y = &FF, which
 LDX #0                 \ detects whether Tube hardware is present, returning
 LDY #&FF               \ X = 0 (not present) or X = &FF (present)
 JSR OSBYTE

 CPX #&FF               \ If X is not &FF, i.e. we are not running this over the
 BNE notube             \ Tube, then jump to notube

 LDA &5A00              \ &5A00 contains 0, so set A = 0

 BEQ P%                 \ If A = 0 then enter an infinite loop, which hangs the
                        \ computer

 JMP &5A00              \ Otherwise we jump to &5A00, though I have no idea why,
                        \ as we will only get here if the code has been altered
                        \ in some way

.notube

 LDA MPL                \ Set A = &A0, as MPL contains an LDY #0 instruction

 NOP                    \ These bytes appear to be unused
 NOP
 NOP

 JMP MPL                \ Jump to MPL to copy 512 bytes to &0400 and jump to
                        \ ENTRY2

