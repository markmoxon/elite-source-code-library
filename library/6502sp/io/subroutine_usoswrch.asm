\ ******************************************************************************
\
\       Name: USOSWRCH
\       Type: Subroutine
\   Category: Tube
\    Summary: The custom OSWRCH routine for writing characters and implementing
\             jump table commands
\
\ ------------------------------------------------------------------------------
\
\ WRCHV is set to point to this routine in the STARTUP routine that runs when
\ the I/O processor code first loads (it's set via a call to PUTBACK).
\
\ This routine prints characters to the I/O processor's screen. For special jump
\ table commands with characters in the range 128-147, the routine calls the
\ corresponding routines in the JMPTAB table; all other characters are printed
\ normally using TT26.
\
\ To implement the special jump table commands, this routine sets the address
\ in WRCHV so that calls to OSWRCH get vectored via the appropriate address from
\ JMPTAB. The routine does the following, depending on the value in A:
\
\   * If A is in the range 128-147, it sets WRCHV to entry number A - 128 in
\     the JMPTAB table (so 128 is the first entry, 129 the second, and so on)
\
\   * Otherwise it prints the character in A by calling TT26
\
\ The vector can be reset to USOSWRCH by calling the PUTBACK routine, which is
\ done at the end of all of the routines that are pointed to by JMPTAB.
\
\ Arguments:
\
\   A                   The character to print:
\                       
\                         * 128-147: Run the jump command in A (see JMPTAB)
\
\                         * All others: Print the character in A
\
\ ******************************************************************************

.USOSWRCH

 STX SC                 \ Store X in SC so we can retrieve it later

 TAX                    \ Store A in X

 BPL OHMYGOD            \ If A < 128 jump to OHMYGOD to print the character in A

 ASL A                  \ Set X = A << 2
 TAX                    \       = (A - 128) * 2 (because A >= 128)
                        \
                        \ so X can be used as an index into a jump table, where
                        \ the table entries correspond to original values of A
                        \ of 128 for entry 0, 129 for entry 1, 130 for entry 2,
                        \ and so on

 CPX #39                \ If X >= 39 then it is past the end of the jump table
 BCS OHMYGOD            \ (JMPTAB contains addresses 0-19, so the last entry is
                        \ for X = 38), so jump to OHMYGOD to print the
                        \ character in A

 LDA JMPTAB,X           \ Fetch the low byte of the jump table address pointed
                        \ to by X from JMPTAB + X

 SEI                    \ Disable interrupts while we update the WRCHV vector

 STA WRCHV              \ Store the low byte of the jump table entry in the low
                        \ byte of WRCHV 

 LDA JMPTAB+1,X         \ Fetch the high byte of the jump table address pointed
 STA WRCHV+1            \ to by X from JMPTAB+1 + X, and store it in the high
                        \ byte of WRCHV

 CLI                    \ Enable interrupts again

 RTS                    \ Return from the subroutine

.OHMYGOD

 LDX SC                 \ Retrieve X from SC

 JMP TT26               \ Jump to TT26 to print the character in A, returning
                        \ from the subroutine with a tail call

