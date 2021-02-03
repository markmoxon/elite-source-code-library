\ ******************************************************************************
\
\       Name: DOMOVE
\       Type: Subroutine
\   Category: Copy protection
\    Summary: Multi-byte decryption and copying routine, run on the stack
\
\ ------------------------------------------------------------------------------
\
\ This routine is copied to the stack at &01DF. It moves and decrypts a block of
\ memory. The original source refers to the stack routine as MVDL.
\
\ The 18 instructions for this routine are pushed onto the stack and executed
\ there. The instructions are pushed onto the stack in reverse (as the stack
\ grows downwards in memory), so first the RTS gets pushed, then the BNE, and
\ so on.
\
\ This is the code that is pushed onto the stack. It gets run by a JMP call to
\ crunchit, which then calls the routine on the stack at MVDL, or &01DF. The
\ label MVDL comes from a comment in the original source file ELITES.
\
\    01DF : .MVDL
\
\    01DF : LDA (ZP),Y      \ Set A = the Y-th byte from the block whose address
\                           \ is in ZP(1 0)
\
\    01E1 : EOR OSB,Y       \ EOR A with the Y-th byte on from OSB
\
\    01E4 : STA (P),Y       \ Store A in the Y-th byte of the block whose
\                           \ address is in P(1 0)
\
\    01E6 : DEY             \ Decrement the loop counter
\
\    01E7 : BNE MVDL        \ Loop back to copy and EOR the next byte until we
\                           \ have copied an entire page (256 bytes)
\
\    01E9 : INC P+1         \ Increment the high byte of P(1 0) so it points to
\                           \ the next page of 256 bytes
\
\    01EB : INC ZP+1        \ Increment ZP(1 0) so it points to the next page of
\                           \ 256 bytes
\
\    01ED : DEX             \ Decrement X
\
\    01EE : BNE MVDL        \ Loop back to copy the next page
\
\    01F0 : RTS             \ Return from the subroutine, which takes us back
\                           \ to the caller of the crunchit routine using a
\                           \ tail call, as we called this with JMP crunchit
\
\ We call MVDL with the following arguments:
\
\   (X Y)               The number of bytes to copy
\
\   ZP(1 0)             The source address
\
\   P(1 0)              The destination address
\
\ The routine moves and decrypts a block of memory, and is used in part 3 to
\ move blocks of code and images that are embedded within the loader binary,
\ either into low memory locations below PAGE (for the recursive token table and
\ page at UU%), or into screen memory (for the loading screen and dashboard
\ images).
\
\ If checksums are disabled in the build, we don't do the EOR instruction, so
\ the routine just moves and doesn't decrypt.
\
\ ******************************************************************************

.DOMOVE

 RTS                    \ RTS

 EQUW &D0EF             \ BNE MVDL

 DEX                    \ DEX

 EQUB ZP+1              \ INC ZP+1
 INC P+1                \ INC P+1
 EQUB &E6

 EQUW &D0F6             \ BNE MVDL

 DEY                    \ DEY

 EQUB P                 \ STA(P),Y
 EQUB &91

IF _REMOVE_CHECKSUMS

 NOP                    \ If we have disabled checksums, skip the EOR so the
 NOP                    \ routine just does the copying part
 NOP

ELSE

 EQUB HI(OSB)           \ EOR OSB,Y
 EQUB LO(OSB)
 EQUB &59

ENDIF

 EQUB ZP                \ LDA(ZP),Y
 EQUB &B1

