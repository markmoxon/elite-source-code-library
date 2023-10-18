\ ******************************************************************************
\
\       Name: WaitForPPUToFinish
\       Type: Subroutine
\   Category: PPU
\    Summary: Wait until the NMI handler has finished updating both bitplanes,
\             so the screen is no longer refreshing
\
\ ******************************************************************************

.WaitForPPUToFinish

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDA bitplaneFlags      \ Keep looping back to the start of the routine until
 AND #%01000000         \ bit 6 of the bitplane flags for bitplane 0 is clear
 BNE WaitForPPUToFinish

 LDA bitplaneFlags+1    \ Do the same for bitplane 1
 AND #%01000000
 BNE WaitForPPUToFinish

                        \ We get here when both bitplanes have bit 6 clear,
                        \ which means neither bitplane is configured to send
                        \ nametable data to the PPU
                        \
                        \ This means the screen has finished refreshing and
                        \ there is no longer any nametable data that needs
                        \ sending to the PPU, so we can return from the
                        \ subroutine

 RTS                    \ Return from the subroutine

