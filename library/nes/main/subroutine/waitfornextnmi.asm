\ ******************************************************************************
\
\       Name: WaitForNextNMI
\       Type: Subroutine
\   Category: Utility routines
\    Summary: An unused routine that waits until the NMI counter increments
\             (i.e. the next VBlank)
\
\ ******************************************************************************

.WaitForNextNMI

 LDA nmiCounter         \ Set A to the NMI counter, which increments with each
                        \ call to the NMI handler

.wfrm1

 CMP nmiCounter         \ Loop back to wfrm1 until the NMI counter changes,
 BEQ wfrm1              \ which will happen when the NMI handler has been called
                        \ again (i.e. at the next VBlank)

 RTS                    \ Return from the subroutine

