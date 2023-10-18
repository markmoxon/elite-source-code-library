\ ******************************************************************************
\
\       Name: attrBuffer1
\       Type: Variable
\   Category: Drawing the screen
\    Summary: Buffer for attribute table 1 that gets sent to the PPU during
\             VBlank
\
\ ******************************************************************************

.attrBuffer1

 SKIP 8 * 8             \ 8 rows of 8 attribute bytes (each is a 2x2 tile block)

