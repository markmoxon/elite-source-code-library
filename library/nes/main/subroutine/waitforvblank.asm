\ ******************************************************************************
\
\       Name: WaitForVBlank
\       Type: Subroutine
\   Category: Utility routines
\    Summary: Wait for the next VBlank to pass
\
\ ******************************************************************************

.WaitForVBlank

 LDA PPU_STATUS         \ Wait for the next VBlank to pass
 BPL WaitForVBlank

 RTS                    \ Return from the subroutine

