\ ******************************************************************************
\
\       Name: ClearBuffers
\       Type: Subroutine
\   Category: Drawing the screen
\    Summary: If there are enough free cycles, clear down the nametable and
\             pattern buffers for both bitplanes
\  Deep dive: Drawing vector graphics using NES tiles
\
\ ******************************************************************************

.ClearBuffers

 LDA cycleCount+1       \ If the high byte of cycleCount(1 0) is zero, then the
 BEQ cbuf3              \ cycle count is 255 or less, so jump to cbuf3 to skip
                        \ the buffer clearing, as we have run out of cycles (we
                        \ will pick up where we left off in the next VBlank)

 SUBTRACT_CYCLES 363    \ Subtract 363 from the cycle count

 BMI cbuf1              \ If the result is negative, jump to cbuf1 to skip the
                        \ buffer clearing, as we have run out of cycles (we
                        \ will pick up where we left off in the next VBlank)

 JMP cbuf2              \ The result is positive, so we have enough cycles to
                        \ clear the buffers, so jump to cbuf2 to do just that

.cbuf1

 ADD_CYCLES 318         \ Add 318 to the cycle count

 JMP cbuf3              \ Jump to cbuf3 to skip the buffer clearing and return
                        \ from the subroutine

.cbuf2

 LDA clearBlockSize     \ Store clearBlockSize(1 0) and clearAddress(1 0) on the
 PHA                    \ stack, so we can use them in the ClearPlaneBuffers
 LDA clearBlockSize+1   \ routine and can restore them to their original values
 PHA                    \ afterwards (in case the NMI handler was called while
 LDA clearAddress       \ these variables are being used)
 PHA
 LDA clearAddress+1
 PHA

 LDX #0                 \ Call ClearPlaneBuffers with X = 0 to clear the buffers
 JSR ClearPlaneBuffers  \ for bitplane 0

 LDX #1                 \ Call ClearPlaneBuffers with X = 1 to clear the buffers
 JSR ClearPlaneBuffers  \ for bitplane 1

 PLA                    \ Retore clearBlockSize(1 0) and clearAddress(1 0) from
 STA clearAddress+1     \ the stack
 PLA
 STA clearAddress
 PLA
 STA clearBlockSize+1
 PLA
 STA clearBlockSize

 ADD_CYCLES_CLC 238     \ Add 238 to the cycle count

.cbuf3

                        \ This part of the routine repeats the code in cbuf5
                        \ until we run out of cycles, though as cbuf5 only
                        \ contains NOPs, this doesn't achieve anything other
                        \ than running down the cycle counter (perhaps it's
                        \ designed to even out each call to the NMI handler,
                        \ or is just left over from development)

 SUBTRACT_CYCLES 32     \ Subtract 32 from the cycle count

 BMI cbuf4              \ If the result is negative, jump to cbuf4 to return
                        \ from the subroutine, as we have run out of cycles

 JMP cbuf5              \ The result is positive, so we have enough cycles to
                        \ continue, so jump to cbuf5

.cbuf4

 ADD_CYCLES 65527       \ Add 65527 to the cycle count (i.e. subtract 9)

 JMP cbuf6              \ Jump to cbuf6 to return from the subroutine

.cbuf5

 NOP                    \ This looks like code that has been removed
 NOP
 NOP

 JMP cbuf3              \ Jump back to cbuf3 to check the cycle count and keep
                        \ running the above until the cycle count runs out

.cbuf6

 RTS                    \ Return from the subroutine

