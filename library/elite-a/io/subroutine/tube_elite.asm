\ ******************************************************************************
\
\       Name: tube_elite
\       Type: Subroutine
\   Category: Tube
\    Summary: Set the vectors to receive Tube communications, run the parasite
\             code, and terminate the I/O processor's loading process
\
\ ******************************************************************************

.tube_elite

 LDX #&FF               \ Set the stack pointer to &01FF, which is the standard
 TXS                    \ location for the 6502 stack, so this instruction
                        \ effectively resets the stack

 LDA #LO(tube_wrch)     \ Set WRCHV to point to the tube_wrch routine, so when
 STA WRCHV              \ bytes are sent to the I/O processor from the parasite,
 LDA #HI(tube_wrch)     \ the tube_wrch routine is called to handle them
 STA WRCHV+1

 LDA #LO(tube_brk)      \ Set BRKV to point to the tube_brk routine (i.e. to the
 STA BRKV               \ Tube host code's break handler)
 LDA #HI(tube_brk)
 STA BRKV+1

 LDX #LO(tube_run)      \ Set (Y X) to point to tube_run ("R.2.T")
 LDY #HI(tube_run)

 JMP OSCLI              \ Call OSCLI to run the OS command in tube_run, which
                        \ *RUNs the parasite code in the 2.T file before
                        \ returning from the subroutine using a tail call

                        \ This terminates the I/O processor code, leaving the
                        \ BBC Micro to sit idle until a command arrives from the
                        \ parasite and calls tube_wrch via WRCHV

