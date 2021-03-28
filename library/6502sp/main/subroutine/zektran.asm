\ ******************************************************************************
\
\       Name: ZEKTRAN
\       Type: Subroutine
\   Category: Keyboard
\    Summary: Reset the key logger buffer at KTRAN
\
\ ******************************************************************************

.ZEKTRAN

 LDX #11                \ We use the first 12 bytes of the key logger buffer at
                        \ KTRAN, so set a loop counter accordingly

 LDA #0                 \ We want to zero the key logger buffer, so set A % 0

.ZEKLOOP

 STA KTRAN,X            \ Reset the X-th byte of the key logger buffer to 0

 DEX                    \ Decrement the loop counter

 BPL ZEKLOOP            \ Loop back until we have zeroed bytes #11 through #0

 RTS                    \ Return from the subroutine

 RTS                    \ This instruction has no effect as we already returned
                        \ from the subroutine

