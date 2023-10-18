\ ******************************************************************************
\
\       Name: UpdateSaveScreen
\       Type: Subroutine
\   Category: Save and load
\    Summary: Update the Save and Load screen
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   A                   A is preserved
\
\ ******************************************************************************

.UpdateSaveScreen

 PHA                    \ Store the value of A on the stack so we can restore it
                        \ at the end of the subroutine

 JSR DrawScreenInNMI_b0 \ Configure the NMI handler to draw the screen

 JSR WaitForPPUToFinish \ Wait until both bitplanes of the screen have been
                        \ sent to the PPU, so the screen is fully updated and
                        \ there is no more data waiting to be sent to the PPU

 PLA                    \ Restore the value of A that we stored on the stack, so
                        \ A is preserved

 RTS                    \ Return from the subroutine

