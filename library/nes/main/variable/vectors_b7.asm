\ ******************************************************************************
\
\       Name: Vectors_b7
\       Type: Variable
\   Category: Utility routines
\    Summary: Vectors at the end of ROM bank 7
\  Deep dive: Splitting NES Elite across multiple ROM banks
\
\ ******************************************************************************

 EQUW NMI               \ Vector to the NMI handler

 EQUW ResetMMC1_b7      \ Vector to the RESET handler

 EQUW IRQ               \ Vector to the IRQ/BRK handler

