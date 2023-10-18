\ ******************************************************************************
\
\       Name: ResetBuffers
\       Type: Subroutine
\   Category: Drawing the screen
\    Summary: Reset the pattern and nametable buffers
\
\ ------------------------------------------------------------------------------
\
\ The pattern buffers are in a continuous block of memory as follows:
\
\   * pattBuffer0 (&6000 to &67FF)
\   * pattBuffer1 (&6800 to &6FFF)
\   * nameBuffer0 (&7000 to &73BF)
\   * attrBuffer0 (&73C0 to &73FF)
\   * nameBuffer1 (&7400 to &77BF)
\   * attrBuffer1 (&77C0 to &77FF)
\
\ This covers &1800 bytes (24 pages of memory), and this routine zeroes the
\ whole lot.
\
\ ******************************************************************************

.ResetBuffers

 LDA #HI(pattBuffer0)   \ Set SC2(1 0) to pattBuffer0, the address of the first
 STA SC2+1              \ of the buffers we want to clear
 LDA #Lo(pattBuffer0)
 STA SC2

 LDY #0                 \ Set Y as a byte counter that we can use as an index
                        \ into each page of memory as we clear them

 LDX #&18               \ We want to zero memory from &6000 to &7800, so set a
                        \ page counter in X to count each page of memory as we
                        \ clear them

 LDA #0                 \ We are going to clear the buffers by filling them with
                        \ zeroes, so set A = 0 so we can poke it into memory

.rbuf1

 STA (SC2),Y            \ Zero the Y-th byte of SC2(1 0)

 INY                    \ Increment the byte counter

 BNE rbuf1              \ Loop back until we have zeroed a full page of memory

 INC SC2+1              \ Increment the high byte of SC2(1 0) so it points to
                        \ the next page in memory

 DEX                    \ Decrement the page counter in X

 BNE rbuf1              \ Loop back until we have zeroed all X pages of memory

 RTS                    \ Return from the subroutine

