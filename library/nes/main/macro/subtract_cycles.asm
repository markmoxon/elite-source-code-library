\ ******************************************************************************
\
\       Name: SUBTRACT_CYCLES
\       Type: Macro
\   Category: Drawing tiles
\    Summary: Subtract a specifed number from the cycle count
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

