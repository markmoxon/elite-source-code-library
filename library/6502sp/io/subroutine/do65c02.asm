\ ******************************************************************************
\
\       Name: do65C02
\       Type: Subroutine
\   Category: Copy protection
\    Summary: Reverse the order of all bytes between the addresses in (1 0) and
\             (3 2) and start the game
\
\ ------------------------------------------------------------------------------
\
\ This routine is copied into the parasite's memory when it sends an OSWORD 249
\ command to the I/O processor. The code is copied by returning it in the OSWORD
\ parameter block. It ends up at location prtblock+2 in the S% routine.
\
\ When run, this routine reverses the order of all bytes between the address in
\ (1 0) and the address in (3 2). It starts by swapping the bytes at each end of
\ the memory block, and moves towards the centre of the block, swapping as it
\ goes until the two ends meet in the middle, where it stops.
\
\ In the original source, the memory is reversed by the first call to routine
\ V in the Big Code File, though in the BeebAsm version this is populated by
\ elite-checksum.py.
\
\ The original 6502 assembly language version of the V routine can be found in
\ the elite-checksum.asm file.
\
\ ******************************************************************************

 CPU 1                  \ Switch to 65C02 assembly, because although this
                        \ routine forms part of the code that runs on the 6502
                        \ CPU of the BBC Micro I/O processor, the do65C02
                        \ routine gets transmitted across the Tube to the
                        \ parasite, and it contains some 65C02 code

.do65C02

.whiz

                        \ When the following code is run as part of the S%
                        \ routine in the parasite, it is entered with the
                        \ following set:
                        \
                        \   (1 0) = SC(1 0) = G%
                        \
                        \   (3 2) = F% - 1
                        \
                        \   X = SC
                        \
                        \ We can access the address in (1 0) via indirect
                        \ addressing, as in LDA (0), which is the same as
                        \ LDA (&0000), and loads the byte at the 16-bit address
                        \ in locations &0000 and &0001, or (1 0). In the same
                        \ way, LDA (2) loads the byte at the address in (3 2)

 LDA (0)                \ Swap the bytes at the addresses (1 0) and (3 2), so
 PHA                    \ this starts by swapping G% and F%-1, and moves on to
 LDA (2)                \ G%+1 and F%-2, then G%+2 and F%-3, and so on, until
 STA (0)                \ (1 0) and (3 2) meet in the middle
 PLA
 STA (2)

\NOP
\NOP
\NOP
\NOP

 INC 0                  \ Increment the low byte of (1 0) to move it on to the
                        \ next byte

 BNE P%+4               \ If the low byte has not wrapped round to zero, skip
                        \ the following instruction

 INC 1                  \ Increment the high byte of (1 0) to move it on to the
                        \ first byte of the next page

 LDA 2                  \ Set A to the low byte of (3 2)

 BNE P%+4               \ If the low byte is not zero, skip the following
                        \ instruction

 DEC 3                  \ Decrement the high byte of (3 2) to move it on to the
                        \ last byte of the previous page

 DEC 2                  \ Decrement the low byte of (3 2) to move it on to the
                        \ previous byte

 DEA                    \ Decrement A, which we set to the low byte of (3 2)
                        \ above, so A now equals (2), the new low byte of (3 2)

 CMP 0                  \ If A < low byte of (1 0), i.e. low byte of (3 2) < low
                        \ byte of (1 0), then clear the C flag, else set it

 LDA 3                  \ Set A = high byte of (3 2) - high byte of (1 0)
 SBC 1                  \         - 1 if low byte of (3 2) < low byte of (1 0)
                        \
                        \ so this subtraction will underflow and clear the C
                        \ flag when the high bytes of (3 2) and (1 0) are equal
                        \ and low byte of (3 2) < low byte of (1 0), which will
                        \ happen when the two endpoints cross over in the
                        \ middle

 BCS whiz               \ If the C flag is set then (1 0) < (3 2), so loop back
                        \ to reverse more bytes, as we haven't yet crossed over
                        \ in the middle

 JMP (0,X)              \ Jump to (0+X), which is the same as (X). We set X to
                        \ SC in S% before entering this routine, so this jumps
                        \ to the address in SC(1 0), which contains G%... so
                        \ this jumps to G% to start the game

.end65C02

 protlen = end65C02 - do65C02

 CPU 0                  \ Switch back to normal 6502 assembly

