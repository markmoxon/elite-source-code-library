\ ******************************************************************************
\
\       Name: ADD_CYCLES_CLC
\       Type: Macro
\   Category: Drawing the screen
\    Summary: Add a specified number to the cycle count
\  Deep dive: Drawing vector graphics using NES tiles
\
\ ------------------------------------------------------------------------------
\
\ The following macro is used to add cycles to the cycle count:
\
\   ADD_CYCLES_CLC cycles
\
\ The cycle count is stored in the variable cycleCount.
\
\ Arguments:
\
\   cycles              The number of cycles to add to the cycle count
\
\ ******************************************************************************

MACRO ADD_CYCLES_CLC cycles

 CLC                    \ Clear the C flag for the addition below

 LDA cycleCount         \ Add cycles to cycleCount(1 0)
 ADC #LO(cycles)
 STA cycleCount
 LDA cycleCount+1
 ADC #HI(cycles)
 STA cycleCount+1

ENDMACRO

