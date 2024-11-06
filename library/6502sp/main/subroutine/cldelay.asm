\ ******************************************************************************
\
\       Name: CLDELAY
\       Type: Subroutine
\   Category: Utility routines
IF _6502SP_VERSION \ Comment
\    Summary: Delay by iterating through 5 * 256 (1280) empty loops
ELIF _MASTER_VERSION OR _C64_VERSION  OR _APPLE_VERSION
\    Summary: Do nothing
ENDIF
\
\ ******************************************************************************

.CLDELAY

IF _6502SP_VERSION \ Platform

 PHX                    \ Store A, X and Y on the stack
 PHY
 PHA

 LDY #5                 \ We are going to loop for 5 * 256 empty loops, so set a
                        \ counter in Y for the outer loop

 LDX #0                 \ And set a counter in X for the inner loop

.CLDEL1

 DEX                    \ Decrement the inner loop counter

 BNE CLDEL1             \ Loop back to CLDEL1 until the inner loop counter has
                        \ rolled around to 0 again

 DEY                    \ Decrement the outer loop counter

 BNE CLDEL1             \ Loop back to CLDEL1 until the outer loop counter has
                        \ reached 0

 PLA                    \ Retrieve A, X and Y from the stack
 PLY
 PLX

 RTS                    \ Return from the subroutine

ELIF _MASTER_VERSION OR _C64_VERSION  OR _APPLE_VERSION

 RTS                    \ Return from the subroutine, as CLDELAY does nothing in
                        \ this version of Elite (it is left over from the 6502
                        \ Second Processor version)

ENDIF

