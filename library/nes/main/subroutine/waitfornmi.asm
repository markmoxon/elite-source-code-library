\ ******************************************************************************
\
\       Name: WaitForNMI
\       Type: Subroutine
\   Category: Utility routines
\    Summary: Wait until the next NMI interrupt has passed (i.e. the next
\             VBlank)
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   A                   A is preserved
\
\ ******************************************************************************

.WaitForNMI

 PHA                    \ Store A on the stack to preserve it

 LDX nmiCounter         \ Set X to the NMI counter, which increments with each
                        \ call to the NMI handler

.wnmi1

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 CPX nmiCounter         \ Loop back to wnmi1 until the NMI counter changes,
 BEQ wnmi1              \ which will happen when the NMI handler has been called
                        \ again (i.e. at the next VBlank)

 PLA                    \ Retrieve A from the stack so that it's preserved

 RTS                    \ Return from the subroutine

