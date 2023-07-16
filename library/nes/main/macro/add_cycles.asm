\ ******************************************************************************
\
\       Name: ADD_CYCLES
\       Type: Macro
\   Category: Drawing tiles
\    Summary: Add a specifed number to the cycle count
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

