\ ******************************************************************************
\
\       Name: WaitFor2NMIs
\       Type: Subroutine
\   Category: Utility routines
\    Summary: Wait until two NMI interrupts have passed (i.e. the next two
\             VBlanks)
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   A                   A is preserved
\
\ ******************************************************************************

.WaitFor2NMIs

 JSR WaitForNMI         \ Wait until the next NMI interrupt has passed (i.e. the
                        \ next VBlank)

                        \ Fall through into WaitForNMI to wait for the second
                        \ NMI interrupt

