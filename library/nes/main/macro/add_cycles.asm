\ ******************************************************************************
\
\       Name: ADD_CYCLES
\       Type: Macro
\   Category: Drawing the screen
\    Summary: Add a specified number to the cycle count
\  Deep dive: Drawing vector graphics using NES tiles
\
\ ------------------------------------------------------------------------------
\
\ The following macro is used to add cycles to the cycle count:
\
\   ADD_CYCLES cycles
\
\ The cycle count is stored in the variable cycleCount. This macro assumes that
\ the C flag is clear.
\
\ Arguments:
\
\   cycles              The number of cycles to add to the cycle count
\
\   C flag              Must be clear for the addition to work
\
\ ******************************************************************************

MACRO ADD_CYCLES cycles

 LDA cycleCount         \ Add cycles to cycleCount(1 0)
 ADC #LO(cycles)
 STA cycleCount
 LDA cycleCount+1
 ADC #HI(cycles)
 STA cycleCount+1

ENDMACRO

