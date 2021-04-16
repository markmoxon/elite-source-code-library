\ ******************************************************************************
\
\       Name: FLFLLS
\       Type: Subroutine
\   Category: Drawing suns
\    Summary: Reset the sun line heap
\
\ ------------------------------------------------------------------------------
\
\ Reset the sun line heap at LSO by zero-filling it and setting the first byte
\ to &FF.
\
\ Returns:
\
\   A                   A is set to 0
\
\ ******************************************************************************

.FLFLLS

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _6502SP_VERSION \ Platform

 LDY #2*Y-1             \ #Y is the y-coordinate of the centre of the space
                        \ view, so this sets Y as a counter for the number of
                        \ lines in the space view (i.e. 191), which is also the
                        \ number of lines in the LSO block

ELIF _MASTER_VERSION

 LDY #2*Y-1+8           \ #Y is the y-coordinate of the centre of the space
                        \ view, so this sets Y as a counter for the number of
                        \ lines in the space view (i.e. 191) - which is also the
                        \ number of lines in the LSO block - plus an extra 8
                        \ bytes

ENDIF

 LDA #0                 \ Set A to 0 so we can zero-fill the LSO block

.SAL6

 STA LSO,Y              \ Set the Y-th byte of the LSO block to 0

 DEY                    \ Decrement the counter

 BNE SAL6               \ Loop back until we have filled all the way to LSO+1

 DEY                    \ Decrement Y to value of &FF (as we exit the above loop
                        \ with Y = 0)

 STY LSX                \ Set the first byte of the LSO block, which has its own
                        \ label LSX, to &FF, to indicate that the sun line heap
                        \ is empty

 RTS                    \ Return from the subroutine

