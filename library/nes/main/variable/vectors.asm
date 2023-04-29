\ ******************************************************************************
\
\       Name: Vectors
\       Type: Variable
\   Category: Text
\    Summary: Vectors and padding at the end of the ROM bank
\
\ ******************************************************************************

 FOR I%, P%, &BFF9

  EQUB &FF              \ Pad out the rest of the ROM bank with &FF

 NEXT

 EQUW &C007             \ Vector to NMI handler

 EQUW &C000             \ Vector to RESET handler

 EQUW &C007             \ Vector to IRQ/BRK handler

