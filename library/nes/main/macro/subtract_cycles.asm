\ ******************************************************************************
\
\       Name: SUBTRACT_CYCLES
\       Type: Macro
\   Category: Drawing the screen
\    Summary: Subtract a specified number from the cycle count
\  Deep dive: Drawing vector graphics using NES tiles
\
\ ------------------------------------------------------------------------------
\
\ The following macro is used to subtract cycles from the cycle count:
\
\   SUBTRACT_CYCLES cycles
\
\ The cycle count is stored in the variable cycleCount.
\
\ Arguments:
\
\   cycles              The number of cycles to subtract from the cycle count
\
\ ******************************************************************************

MACRO SUBTRACT_CYCLES cycles

 SEC                    \ Subtract cycles from cycleCount(1 0)
 LDA cycleCount
 SBC #LO(cycles)
 STA cycleCount
 LDA cycleCount+1
 SBC #HI(cycles)
 STA cycleCount+1

ENDMACRO

