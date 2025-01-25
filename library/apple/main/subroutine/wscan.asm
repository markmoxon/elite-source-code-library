\ ******************************************************************************
\
\       Name: WSCAN
\       Type: Subroutine
\   Category: Drawing the screen
\    Summary: Wait for 15 * 256 loop iterations
\
\ ------------------------------------------------------------------------------
\
\ In the released version of Apple II Elite, this routine implements a
\ fixed-length pause of 15 * 256 iterations of an empty loop.
\
\ In the version on the source disk on Ian Bell's site, this routine waits for
\ the vertical sync by checking the state of the VERTBLANK soft switch, so this
\ behaviour was presumably changed at some stage during development.
\
\ ******************************************************************************

.WSCAN

IF _IB_DISK OR _4AM_CRACK

 PHA                    \ Store the A, X and Y registers on the stack
 TXA
 PHA
 TYA
 PHA

 LDY #15                \ Set an outer loop counter in Y, so we do a total of 15
                        \ outer loops to give a delay of 15 * 256 iterations

 LDX #0                 \ Set an inner loop counter in X to do 256 iterations of
                        \ each inner loop

.WSCL1

 DEX                    \ Decrement the inner loop counter

 BNE WSCL1              \ Loop back until we have done 256 iterations around the
                        \ inner loop

 DEY                    \ Decrement the outer loop counter

 BNE WSCL1              \ Loop back until we have done Y iterations around the
                        \ outer loop, to give Y * 256 iterations in all

 PLA                    \ Retrieve the A, X and Y registers from the stack
 TAY
 PLA
 TAX
 PLA

ELIF _SOURCE_DISK

 BIT &C019              \ Wait until bit 7 of the VERTBLANK soft switch is set,
 BPL WSCAN              \ which occurs when the vertical retrace is on

.WSCL1

 BIT &C019              \ Wait until bit 7 of the VERTBLANK soft switch is
 BMI WSCL1              \ clear, which occurs when the vertical retrace is off

ENDIF

 RTS                    \ Return from the subroutine

