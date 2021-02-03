\ ******************************************************************************
\
\       Name: prstr
\       Type: Subroutine
\   Category: Loader
\    Summary: Print the NOP-terminated string immediately following the JSR
\             instruction that called the routine
\
\ ******************************************************************************

.prstr

 PLA                    \ We call prstr with a JSR, so pull the return address
 STA Q                  \ off the stack into Q(1 0), which actually points to
 PLA                    \ the last byte of the JSR prstr instruction
 STA Q+1

.p1

 INC Q                  \ Increment Q(1 0) to point to the next byte (so the
 BNE P%+4               \ first time we call prstr, Q points to the first byte
 INC Q+1                \ of the string we want to print)

 LDY #0                 \ Fetch the byte at Q(1 0) into A
 LDA (Q),Y

 CMP #&EA               \ If we just fetched a NOP instruction (opcode &EA),
 BEQ p2                 \ then we have reached the end of the string, so jump to
                        \ p2 to return from the subroutine

 JSR OSWRCH             \ Print the byte we just fetched

 CLC                    \ Loop back to p1 to fetch the next byte to print
 BCC p1

.p2

 JMP (Q)                \ Jump to the address in Q(1 0) - i.e. to the NOP that
                        \ we just fetched, so execution continues from the end
                        \ of the string we just printed

