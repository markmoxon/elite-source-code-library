\ ******************************************************************************
\
\       Name: BEGIN%
\       Type: Subroutine
\   Category: Copy protection
\    Summary: Single-byte decryption and copying routine, run on the stack
\
\ ------------------------------------------------------------------------------
\
\ This routine is copied to the stack at &01F1. It pushes BLOCK to ENDBLOCK onto
\ the stack, and decrypts the code from TUT onwards.
\
\ The 15 instructions for this routine are pushed onto the stack and executed
\ there. The instructions are pushed onto the stack in reverse (as the stack
\ grows downwards in memory), so first the JMP gets pushed, then the STA, and
\ so on.
\
\ This is the code that is pushed onto the stack. It gets run by a JMP call to
\ David2, which then calls the routine on the stack with JSR &01F1.
\
\    01F1 : PLA             \ Remove the return address from the stack that was
\    01F2 : PLA             \ put here by the JSR that called this routine
\
\    01F3 : LDA BLOCK,Y     \ Set A = the Y-th byte of BLOCK
\
\    01F6 : PHA             \ Push A onto the stack
\
\    01F7 : EOR TUT,Y       \ EOR the Y-th byte of TUT with A
\    01FA : STA TUT,Y
\
\    01FD : JMP (David9)    \ Jump to the address in David9
\
\ The routine is called inside a loop with Y as the counter. It counts from 0 to
\ ENDBLOCK - BLOCK, so the routine eventually pushes every byte between BLOCK
\ and ENDBLOCK onto the stack, as well as EOR'ing each byte from TUT onwards to
\ decrypt that section.
\
\ The elite-checksums.py script reverses the order of the bytes between BLOCK
\ and ENDBLOCK in the final file, so pushing them onto the stack (which is a
\ descending stack) realigns them in memory as assembled below. Not only that,
\ but the last two bytes pushed on the stack are the ones that are at the start
\ of the block at BLOCK, and these contain the address of ENTRY2. This is why
\ the RTS at the end of part 4 above actually jumps to ENTRY2 in part 5.
\
\ ******************************************************************************

.BEGIN%

 EQUB HI(David9)        \ JMP (David9)
 EQUB LO(David9)
 EQUB &6C

 EQUB HI(TUT)           \ STA TUT,Y
 EQUB LO(TUT)
 EQUB &99

IF _REMOVE_CHECKSUMS

 EQUB HI(TUT)           \ If we have disabled checksums, then just load the Y-th
 EQUB LO(TUT)           \ byte of TUT with LDA TUT,Y
 EQUB &B9

ELSE

 EQUB HI(TUT)           \ EOR TUT,Y
 EQUB LO(TUT)
 EQUB &59

ENDIF

 PHA                    \ PHA

 EQUB HI(BLOCK)         \ LDA BLOCK,Y
 EQUB LO(BLOCK)
 EQUB &B9

 PLA                    \ PLA

 PLA                    \ PLA

